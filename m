Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbcF0QcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 12:32:12 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 01/12] rtl8xxxu: Set all ieee80211_rx_status values in parse_rx_desc()
Date: Mon, 27 Jun 2016 12:31:59 -0400
Message-Id: <1467045130-18874-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160627_183217_062141_95F38E8F)
In-Reply-To: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This needs to be handled locally in the parse_rx_desc() function in
order to be able to handle aggregated packets in the future.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index dfe61e4..4ebd819 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5048,6 +5048,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
 			    struct ieee80211_rx_status *rx_status)
 {
+	struct ieee80211_hw *hw = priv->hw;
 	struct rtl8xxxu_rxdesc16 *rx_desc =
 		(struct rtl8xxxu_rxdesc16 *)skb->data;
 	struct rtl8723au_phy_stats *phy_stats;
@@ -5059,6 +5060,8 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
 	for (i = 0; i < (sizeof(struct rtl8xxxu_rxdesc16) / sizeof(u32)); i++)
 		_rx_desc[i] = le32_to_cpu(_rx_desc_le[i]);
 
+	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
+
 	skb_pull(skb, sizeof(struct rtl8xxxu_rxdesc16));
 
 	phy_stats = (struct rtl8723au_phy_stats *)skb->data;
@@ -5088,12 +5091,16 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
 		rx_status->rate_idx = rx_desc->rxmcs;
 	}
 
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
+
 	return RX_TYPE_DATA_PKT;
 }
 
 int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
 			    struct ieee80211_rx_status *rx_status)
 {
+	struct ieee80211_hw *hw = priv->hw;
 	struct rtl8xxxu_rxdesc24 *rx_desc =
 		(struct rtl8xxxu_rxdesc24 *)skb->data;
 	struct rtl8723au_phy_stats *phy_stats;
@@ -5105,6 +5112,8 @@ int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
 	for (i = 0; i < (sizeof(struct rtl8xxxu_rxdesc24) / sizeof(u32)); i++)
 		_rx_desc[i] = le32_to_cpu(_rx_desc_le[i]);
 
+	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
+
 	skb_pull(skb, sizeof(struct rtl8xxxu_rxdesc24));
 
 	phy_stats = (struct rtl8723au_phy_stats *)skb->data;
@@ -5140,6 +5149,9 @@ int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
 		rx_status->rate_idx = rx_desc->rxmcs;
 	}
 
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
+
 	return RX_TYPE_DATA_PKT;
 }
 
@@ -5202,13 +5214,8 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 	skb_put(skb, urb->actual_length);
 
 	if (urb->status == 0) {
-		memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
-
 		rx_type = priv->fops->parse_rx_desc(priv, skb, rx_status);
 
-		rx_status->freq = hw->conf.chandef.chan->center_freq;
-		rx_status->band = hw->conf.chandef.chan->band;
-
 		if (rx_type == RX_TYPE_DATA_PKT)
 			ieee80211_rx_irqsafe(hw, skb);
 		else {
-- 
2.7.4

