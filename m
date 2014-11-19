Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:59383
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756358AbaKSTIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 14:08:16 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 4/7] mac80211: minstrel_ht: switch to .tx_status_noskb
Date: Wed, 19 Nov 2014 20:08:10 +0100
Message-Id: <1416424093-19439-4-git-send-email-nbd@openwrt.org> (sfid-20141119_200821_782958_C9643705)
In-Reply-To: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
References: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2641dc8..b52996a 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -709,11 +709,10 @@ minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 static void
 minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
                       struct ieee80211_sta *sta, void *priv_sta,
-                      struct sk_buff *skb)
+                      struct ieee80211_tx_info *info)
 {
 	struct minstrel_ht_sta_priv *msp = priv_sta;
 	struct minstrel_ht_sta *mi = &msp->ht;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *ar = info->status.rates;
 	struct minstrel_rate_stats *rate, *rate2;
 	struct minstrel_priv *mp = priv;
@@ -721,7 +720,8 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	int i;
 
 	if (!msp->is_ht)
-		return mac80211_minstrel.tx_status(priv, sband, sta, &msp->legacy, skb);
+		return mac80211_minstrel.tx_status_noskb(priv, sband, sta,
+							 &msp->legacy, info);
 
 	/* This packet was aggregated but doesn't carry status info */
 	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
@@ -1343,7 +1343,7 @@ static u32 minstrel_ht_get_expected_throughput(void *priv_sta)
 
 static const struct rate_control_ops mac80211_minstrel_ht = {
 	.name = "minstrel_ht",
-	.tx_status = minstrel_ht_tx_status,
+	.tx_status_noskb = minstrel_ht_tx_status,
 	.get_rate = minstrel_ht_get_rate,
 	.rate_init = minstrel_ht_rate_init,
 	.rate_update = minstrel_ht_rate_update,
-- 
2.1.2

