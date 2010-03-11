Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:40465 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0CKP2a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 10:28:30 -0500
Message-ID: <4B990C18.5050807@openwrt.org>
Date: Thu, 11 Mar 2010 16:28:24 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: optimize tx status processing
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a cooked monitor interface is active, ieee80211_tx_status()
generates a radiotap header for every single frame, even if it wasn't
injected and thus won't be sent to a monitor interface.
This patch reduces cpu utilization by moving the cooked monitor check a
bit earlier, before it generates the rtap header.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -171,7 +171,7 @@ void ieee80211_tx_status(struct ieee8021
 	struct net_device *prev_dev = NULL;
 	struct sta_info *sta, *tmp;
 	int retry_count = -1, i;
-	bool injected;
+	bool send_to_cooked;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		/* the HW cannot have attempted that rate */
@@ -296,11 +296,15 @@ void ieee80211_tx_status(struct ieee8021
 	/* this was a transmitted frame, but now we want to reuse it */
 	skb_orphan(skb);
 
+	/* Need to make a copy before skb->cb gets cleared */
+	send_to_cooked = !!(info->flags & IEEE80211_TX_CTL_INJECTED) ||
+			(type != IEEE80211_FTYPE_DATA);
+
 	/*
 	 * This is a bit racy but we can avoid a lot of work
 	 * with this test...
 	 */
-	if (!local->monitors && !local->cooked_mntrs) {
+	if (!local->monitors && (!send_to_cooked || !local->cooked_mntrs)) {
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -345,9 +349,6 @@ void ieee80211_tx_status(struct ieee8021
 	/* for now report the total retry_count */
 	rthdr->data_retries = retry_count;
 
-	/* Need to make a copy before skb->cb gets cleared */
-	injected = !!(info->flags & IEEE80211_TX_CTL_INJECTED);
-
 	/* XXX: is this sufficient for BPF? */
 	skb_set_mac_header(skb, 0);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -362,8 +363,7 @@ void ieee80211_tx_status(struct ieee8021
 				continue;
 
 			if ((sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) &&
-			    !injected &&
-			    (type == IEEE80211_FTYPE_DATA))
+			    !send_to_cooked)
 				continue;
 
 			if (prev_dev) {

