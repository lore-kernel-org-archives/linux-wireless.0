Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbcF0QcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 12:32:12 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 03/12] rtl8xxxu: Obtain ieee80211_rx_status within parse_rx_desc()
Date: Mon, 27 Jun 2016 12:32:01 -0400
Message-Id: <1467045130-18874-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160627_183216_478697_0CB00BEF)
In-Reply-To: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

When handling aggregated packets, we'll get a new ieee80211_rx_status
for each cloned skb, so passing in the pointer from the outside
doesn't make sense.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      |  9 +++------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 11 +++++------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 870c9cd..d0ccda8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1315,8 +1315,7 @@ struct rtl8xxxu_fileops {
 	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
 	void (*phy_iq_calibrate) (struct rtl8xxxu_priv *priv);
 	void (*config_channel) (struct ieee80211_hw *hw);
-	int (*parse_rx_desc) (struct rtl8xxxu_priv *priv, struct sk_buff *skb,
-			      struct ieee80211_rx_status *rx_status);
+	int (*parse_rx_desc) (struct rtl8xxxu_priv *priv, struct sk_buff *skb);
 	void (*init_aggregation) (struct rtl8xxxu_priv *priv);
 	void (*init_statistics) (struct rtl8xxxu_priv *priv);
 	void (*enable_rf) (struct rtl8xxxu_priv *priv);
@@ -1412,10 +1411,8 @@ void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 void rtl8xxxu_gen1_enable_rf(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen1_disable_rf(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen2_disable_rf(struct rtl8xxxu_priv *priv);
-int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
-			    struct ieee80211_rx_status *rx_status);
-int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
-			    struct ieee80211_rx_status *rx_status);
+int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb);
+int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb);
 int rtl8xxxu_gen2_channel_to_group(int channel);
 bool rtl8xxxu_gen2_simularity_compare(struct rtl8xxxu_priv *priv,
 				      int result[][8], int c1, int c2);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 7c4df4d..52652e6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5090,10 +5090,10 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 	}
 }
 
-int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
-			    struct ieee80211_rx_status *rx_status)
+int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hw *hw = priv->hw;
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct rtl8xxxu_rxdesc16 *rx_desc =
 		(struct rtl8xxxu_rxdesc16 *)skb->data;
 	struct rtl8723au_phy_stats *phy_stats;
@@ -5143,10 +5143,10 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
 	return RX_TYPE_DATA_PKT;
 }
 
-int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
-			    struct ieee80211_rx_status *rx_status)
+int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hw *hw = priv->hw;
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct rtl8xxxu_rxdesc24 *rx_desc =
 		(struct rtl8xxxu_rxdesc24 *)skb->data;
 	struct rtl8723au_phy_stats *phy_stats;
@@ -5211,13 +5211,12 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 	struct ieee80211_hw *hw = rx_urb->hw;
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct sk_buff *skb = (struct sk_buff *)urb->context;
-	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct device *dev = &priv->udev->dev;
 
 	skb_put(skb, urb->actual_length);
 
 	if (urb->status == 0) {
-		priv->fops->parse_rx_desc(priv, skb, rx_status);
+		priv->fops->parse_rx_desc(priv, skb);
 
 		skb = NULL;
 		rx_urb->urb.context = NULL;
-- 
2.7.4

