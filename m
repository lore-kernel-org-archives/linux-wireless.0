Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40932 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab0JSAox (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 20:44:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 18 Oct 2010 17:44:43 -0700
Date: Mon, 18 Oct 2010 17:44:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: fix regression on processing country IEs
Message-ID: <20101019004451.GB1932@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch 4f366c5:

	wireless: only use alpha2 regulatory information from country IE

removed some complex intersection we were always doing between the AP's
country IE info and what we got from CRDA. When CRDA sent us back a
regulatory domain we would do some sanity checks on that regulatory
domain response we just got. Part of these sanity checks included
checking that we already had performed an intersection for the
request of NL80211_REGDOM_SET_BY_COUNTRY_IE type.

This mean that cfg80211 was only processing country IEs for cases
where we already had an intersection, but since we removed enforcing
this this is no longer required, we should just apply the country
IE country hint with the data received from CRDA.

This patch has fixes intended for kernels >= 2.6.36.

Cc: stable@kernel.org
Reported-by: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d14bbf9..4b9f891 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1167,7 +1167,7 @@ static int ignore_request(struct wiphy *wiphy,
 				return 0;
 			return -EALREADY;
 		}
-		return REG_INTERSECT;
+		return 0;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_CORE) {
 			if (regdom_changes(pending_request->alpha2))
-- 
1.7.0.4

