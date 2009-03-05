Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45930 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752435AbZCEPYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 10:24:04 -0500
Date: Thu, 5 Mar 2009 17:23:46 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix WMM ACM parsing and AC downgrade operation
Message-ID: <20090305152346.GA30029@jm.kir.nu> (sfid-20090305_162408_825621_7EABDA8D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Incorrect local->wmm_acm bits were set for AC_BK and AC_BE. Fix this
and add some comments to make it easier to understand the AC-to-UP(pair)
mapping. Set the wmm_acm bits (and show WMM debug) even if the driver
does not implement conf_tx() handler.

In addition, fix the ACM-based AC downgrade code to not use the
highest priority in error cases. We need to break the loop to get the
correct AC_BK value (3) instead of returning 0 (which would indicate
AC_VO). The comment here was not really very useful either, so let's
provide somewhat more helpful description of the situation.

Since it is very unlikely that the ACM flag would be set for AC_BK and
AC_BE, these bugs are not likely to be seen in real life networks.
Anyway, better do these things correctly should someone really use
silly AP configuration (and to pass some functionality tests, too).

Remove the TODO comment about handling ACM. Downgrading AC is
perfectly valid mechanism for ACM. Eventually, we may add support for
WMM-AC and send a request for a TS, but anyway, that functionality
won't be here at the location of this TODO comment.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/mlme.c |   24 ++++++++++--------------
 net/mac80211/wme.c  |    9 ++++++---
 2 files changed, 16 insertions(+), 17 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-03-05 16:52:36.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-03-05 17:16:53.000000000 +0200
@@ -417,9 +417,6 @@ static void ieee80211_sta_wmm_params(str
 
 	memset(&params, 0, sizeof(params));
 
-	if (!local->ops->conf_tx)
-		return;
-
 	local->wmm_acm = 0;
 	for (; left >= 4; left -= 4, pos += 4) {
 		int aci = (pos[0] >> 5) & 0x03;
@@ -427,26 +424,26 @@ static void ieee80211_sta_wmm_params(str
 		int queue;
 
 		switch (aci) {
-		case 1:
+		case 1: /* AC_BK */
 			queue = 3;
 			if (acm)
-				local->wmm_acm |= BIT(0) | BIT(3);
+				local->wmm_acm |= BIT(1) | BIT(2); /* BK/- */
 			break;
-		case 2:
+		case 2: /* AC_VI */
 			queue = 1;
 			if (acm)
-				local->wmm_acm |= BIT(4) | BIT(5);
+				local->wmm_acm |= BIT(4) | BIT(5); /* CL/VI */
 			break;
-		case 3:
+		case 3: /* AC_VO */
 			queue = 0;
 			if (acm)
-				local->wmm_acm |= BIT(6) | BIT(7);
+				local->wmm_acm |= BIT(6) | BIT(7); /* VO/NC */
 			break;
-		case 0:
+		case 0: /* AC_BE */
 		default:
 			queue = 2;
 			if (acm)
-				local->wmm_acm |= BIT(1) | BIT(2);
+				local->wmm_acm |= BIT(0) | BIT(3); /* BE/EE */
 			break;
 		}
 
@@ -460,9 +457,8 @@ static void ieee80211_sta_wmm_params(str
 		       local->mdev->name, queue, aci, acm, params.aifs, params.cw_min,
 		       params.cw_max, params.txop);
 #endif
-		/* TODO: handle ACM (block TX, fallback to next lowest allowed
-		 * AC for now) */
-		if (local->ops->conf_tx(local_to_hw(local), queue, &params)) {
+		if (local->ops->conf_tx &&
+		    local->ops->conf_tx(local_to_hw(local), queue, &params)) {
 			printk(KERN_DEBUG "%s: failed to set TX queue "
 			       "parameters for queue %d\n", local->mdev->name, queue);
 		}
--- wireless-testing.orig/net/mac80211/wme.c	2009-03-05 17:01:26.000000000 +0200
+++ wireless-testing/net/mac80211/wme.c	2009-03-05 17:03:25.000000000 +0200
@@ -99,10 +99,13 @@ static u16 classify80211(struct ieee8021
 	/* in case we are a client verify acm is not set for this ac */
 	while (unlikely(local->wmm_acm & BIT(skb->priority))) {
 		if (wme_downgrade_ac(skb)) {
-			/* The old code would drop the packet in this
-			 * case.
+			/*
+			 * This should not really happen. The AP has marked all
+			 * lower ACs to require admission control which is not
+			 * a reasonable configuration. Allow the frame to be
+			 * transmitted using AC_BK as a workaround.
 			 */
-			return 0;
+			break;
 		}
 	}
 

-- 
Jouni Malinen                                            PGP id EFC895FA
