Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38194 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab0KLC13 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 21:27:29 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 18:27:17 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <mark@moxienet.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>
Subject: [PATCH] cfg80211: Fix regulatory bug with multiple cards with a delayed CRDA response
Date: Thu, 11 Nov 2010 18:27:23 -0800
Message-ID: <1289528843-21982-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When two cards are connected with the same regulatory domain
if CRDA had a delayed response then cfg80211's own set regulatory
domain would still be the world regulatory domain. There was a bug
on cfg80211's ignore_request() when analyzing incoming driver
regulatory hints as it was only checking against the currently
set cfg80211 regulatory domain and not for any other new
pending requests. This is easily fixed by also checking against
the pending request.

Without this fix the second card would end up with an intersected
regulatory domain and now allow it to use the channels it really
is designed for.

This was reproduced and tested against mac80211_hwsim using this
CRDA delayer:

	#!/bin/bash
	echo $COUNTRY >> /tmp/log
	sleep 2
	/sbin/crda.orig

And this regulatory test:

	modprobe mac80211_hwsim regtest=2

This patch has fixes for cfg80211 all the way back.

Reported-by: Mark Mentovai <mark@moxienet.com>
Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3be18d9..ecac993 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1281,9 +1281,13 @@ static int ignore_request(struct wiphy *wiphy,
 		 * This would happen if you unplug and plug your card
 		 * back in or if you add a new device for which the previously
 		 * loaded card also agrees on the regulatory domain.
+		 * This can also happen if you have two cards both with the
+		 * same regulatory domain and CRDA hasn't yet replied back
+		 * with the last request's regulatory domain.
 		 */
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
-		    !regdom_changes(pending_request->alpha2))
+		    (!regdom_changes(pending_request->alpha2) ||
+		     alpha2_equal(last_request->alpha2, pending_request->alpha2)))
 			return -EALREADY;
 
 		return REG_INTERSECT;
-- 
1.7.1

