Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41038 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354AbXIJMOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 08:14:18 -0400
Subject: [PATCH] mac80211: remove/change some comments about Michael MIC  hardware offload
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 14:15:25 +0200
Message-Id: <1189426525.4506.87.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a few TODO comments in the mac80211 sources regarding
hardware offload for Michael MIC verification. Those items are,
however, better handled in the driver instead of the stack, if
any device requires such hand-holding.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-09-10 14:13:04.257222494 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-10 14:13:07.547223090 +0200
@@ -1340,8 +1340,6 @@ static void ieee80211_rx_michael_mic_rep
 	else
 		keyidx = -1;
 
-	/* TODO: verify that this is not triggered by fragmented
-	 * frames (hw does not verify MIC for them). */
 	if (net_ratelimit())
 		printk(KERN_DEBUG "%s: TKIP hwaccel reported Michael MIC "
 		       "failure from " MAC_FMT " to " MAC_FMT " keyidx=%d\n",
@@ -1349,9 +1347,10 @@ static void ieee80211_rx_michael_mic_rep
 		       keyidx);
 
 	if (!sta) {
-		/* Some hardware versions seem to generate incorrect
-		 * Michael MIC reports; ignore them to avoid triggering
-		 * countermeasures. */
+		/*
+		 * Some hardware seem to generate incorrect Michael MIC
+		 * reports; ignore them to avoid triggering countermeasures.
+		 */
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
 			       "error for unknown address " MAC_FMT "\n",
@@ -1362,16 +1361,18 @@ static void ieee80211_rx_michael_mic_rep
 	if (!(rx->fc & IEEE80211_FCTL_PROTECTED)) {
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
-			       "error for a frame with no ISWEP flag (src "
+			       "error for a frame with no PROTECTED flag (src "
 			       MAC_FMT ")\n", dev->name, MAC_ARG(hdr->addr2));
 		goto ignore;
 	}
 
 	if (rx->sdata->type == IEEE80211_IF_TYPE_AP && keyidx) {
-		/* AP with Pairwise keys support should never receive Michael
-		 * MIC errors for non-zero keyidx because these are reserved
-		 * for group keys and only the AP is sending real multicast
-		 * frames in BSS. */
+		/*
+		 * APs with pairwise keys should never receive Michael MIC
+		 * errors for non-zero keyidx because these are reserved for
+		 * group keys and only the AP is sending real multicast
+		 * frames in the BSS.
+		 */
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: ignored Michael MIC error for "
 			       "a frame with non-zero keyidx (%d)"
@@ -1391,10 +1392,6 @@ static void ieee80211_rx_michael_mic_rep
 		goto ignore;
 	}
 
-	/* TODO: consider verifying the MIC error report with software
-	 * implementation if we get too many spurious reports from the
-	 * hardware. */
-
 	mac80211_ev_michael_mic_failure(rx->dev, keyidx, hdr);
  ignore:
 	dev_kfree_skb(rx->skb);


