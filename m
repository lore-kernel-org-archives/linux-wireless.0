Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbcB2WGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:05 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 104/113] rtl8xxxu: Pass RX rate to rx_parse_phystats and enable phystats for rtl8723bu
Date: Mon, 29 Feb 2016 17:05:42 -0500
Message-Id: <1456783551-28315-105-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232954_499845_9A827010)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

rtl8xxxu_rx_parse_phystats() only needs the RX rate to determine
whether to handle the stats as CCK or not. Parsing in the rate rather
than the rx descriptor elimantes the need to handle multiple rx
descriptor formats in the function.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 253de87..8cb76e2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7216,13 +7216,13 @@ error:
 
 static void rtl8xxxu_rx_parse_phystats(struct rtl8xxxu_priv *priv,
 				       struct ieee80211_rx_status *rx_status,
-				       struct rtl8xxxu_rx_desc *rx_desc,
-				       struct rtl8723au_phy_stats *phy_stats)
+				       struct rtl8723au_phy_stats *phy_stats,
+				       u32 rxmcs)
 {
 	if (phy_stats->sgi_en)
 		rx_status->flag |= RX_FLAG_SHORT_GI;
 
-	if (rx_desc->rxmcs < DESC_RATE_6M) {
+	if (rxmcs < DESC_RATE_6M) {
 		/*
 		 * Handle PHY stats for CCK rates
 		 */
@@ -7350,7 +7350,8 @@ static int rtl8723au_parse_rx_desc(struct rtl8xxxu_priv *priv,
 	skb_pull(skb, drvinfo_sz + desc_shift);
 
 	if (rx_desc->phy_stats)
-		rtl8xxxu_rx_parse_phystats(priv, rx_status, rx_desc, phy_stats);
+		rtl8xxxu_rx_parse_phystats(priv, rx_status, phy_stats,
+					   rx_desc->rxmcs);
 
 	rx_status->mactime = le32_to_cpu(rx_desc->tsfl);
 	rx_status->flag |= RX_FLAG_MACTIME_START;
@@ -7395,6 +7396,10 @@ static int rtl8723bu_parse_rx_desc(struct rtl8xxxu_priv *priv,
 		return RX_TYPE_C2H;
 	}
 
+	if (rx_desc->phy_stats)
+		rtl8xxxu_rx_parse_phystats(priv, rx_status, phy_stats,
+					   rx_desc->rxmcs);
+
 	rx_status->mactime = le32_to_cpu(rx_desc->tsfl);
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
-- 
2.5.0

