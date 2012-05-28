Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62995 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab2E1LTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 07:19:36 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 02/14] cfg80211: check iface combinations only when intf is running
Date: Mon, 28 May 2012 13:18:50 +0200
Message-ID: <1338203942-5667-3-git-send-email-michal.kazior@tieto.com> (sfid-20120528_132024_448151_54356219)
In-Reply-To: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't validate interface combinations on a stopped
interface. Otherwise we might end up being able to
create a new interface with a certain type, but
won't be able to change an existing interface
type.

This also skips some other functions when
interface is stopped when changing interface type.

Change-Id: I02af110905184c8182aa30dc9054a2c53f0238d0
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 147f283..eb7ca3c 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -805,7 +805,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	     ntype == NL80211_IFTYPE_P2P_CLIENT))
 		return -EBUSY;
 
-	if (ntype != otype) {
+	if (ntype != otype && netif_running(dev)) {
 		err = cfg80211_can_change_interface(rdev, dev->ieee80211_ptr,
 						    ntype);
 		if (err)
-- 
1.7.0.4

