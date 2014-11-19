Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:59375
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756339AbaKSTIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 14:08:16 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 3/7] mac80211: minstrel: switch to .tx_status_noskb
Date: Wed, 19 Nov 2014 20:08:09 +0100
Message-Id: <1416424093-19439-3-git-send-email-nbd@openwrt.org> (sfid-20141119_200829_226435_B37AA3E9)
In-Reply-To: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
References: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index c2b91bf..d51f6b1 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -223,11 +223,10 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 static void
 minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		   struct ieee80211_sta *sta, void *priv_sta,
-		   struct sk_buff *skb)
+		   struct ieee80211_tx_info *info)
 {
 	struct minstrel_priv *mp = priv;
 	struct minstrel_sta_info *mi = priv_sta;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *ar = info->status.rates;
 	int i, ndx;
 	int success;
@@ -674,7 +673,7 @@ static u32 minstrel_get_expected_throughput(void *priv_sta)
 
 const struct rate_control_ops mac80211_minstrel = {
 	.name = "minstrel",
-	.tx_status = minstrel_tx_status,
+	.tx_status_noskb = minstrel_tx_status,
 	.get_rate = minstrel_get_rate,
 	.rate_init = minstrel_rate_init,
 	.alloc = minstrel_alloc,
-- 
2.1.2

