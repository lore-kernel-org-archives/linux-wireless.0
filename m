Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36209 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbYJJAzd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 20:55:33 -0400
Message-ID: <48EEA7F7.6020508@openwrt.org> (sfid-20081010_025535_783817_65BCAE42)
Date: Fri, 10 Oct 2008 02:55:19 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH 1/2] mac80211: detect hardware rate fallback for non-MRR hardware
References: <48EEA7A4.2020303@openwrt.org>
In-Reply-To: <48EEA7A4.2020303@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes tx status processing for drivers that do not support mrr.
If the retry count is bigger than the maximum retry count configured in
the hardware, do not count the rate attempt as successful, the hardware
has probably switched to a lower rate.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>

--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -171,6 +171,7 @@ minstrel_tx_status(void *priv, struct ie
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_altrate *ar = info->status.retries;
 	struct minstrel_priv *mp = priv;
+	struct ieee80211_local *local = hw_to_local(mp->hw);
 	int i, ndx, tries;
 	int success = 0;
 
@@ -180,6 +181,13 @@ minstrel_tx_status(void *priv, struct ie
 	if (!mp->has_mrr || (ar[0].rate_idx < 0)) {
 		ndx = rix_to_ndx(mi, info->tx_rate_idx);
 		tries = info->status.retry_count + 1;
+
+		/* If the driver does not support the MRR API, but uses
+		 * a fallback rate, use the long retry limit as indication
+		 * that a rate switch has happened */
+		if (!mp->has_mrr && (tries >= local->long_retry_limit))
+			success = 0;
+
 		mi->r[ndx].success += success;
 		mi->r[ndx].attempts += tries;
 		return;
