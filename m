Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbcB2WGB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:01 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 070/113] rtl8xxxu: Setup RX aggregation
Date: Mon, 29 Feb 2016 17:05:08 -0500
Message-Id: <1456783551-28315-71-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232951_905678_D510E366)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This initializes RX DMA aggregation on 8723bu. We should do this for
all parts eventually, and also init TX aggregation.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 23 ++++++++++++++++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index de921cf..50494e4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5962,6 +5962,25 @@ static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ignore_wlan));
 }
 
+static void rtl8723bu_init_aggregation(struct rtl8xxxu_priv *priv)
+{
+	u32 agg_rx;
+	u8 agg_ctrl;
+
+	/*
+	 * For now simply disable RX aggregation
+	 */
+	agg_ctrl = rtl8xxxu_read8(priv, REG_TRXDMA_CTRL);
+	agg_ctrl &= ~TRXDMA_CTRL_RXDMA_AGG_EN;
+
+	agg_rx = rtl8xxxu_read32(priv, REG_RXDMA_AGG_PG_TH);
+	agg_rx &= ~RXDMA_USB_AGG_ENABLE;
+	agg_rx &= ~0xff0f;
+
+	rtl8xxxu_write8(priv, REG_TRXDMA_CTRL, agg_ctrl);
+	rtl8xxxu_write32(priv, REG_RXDMA_AGG_PG_TH, agg_rx);
+}
+
 static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
@@ -6320,6 +6339,9 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rtl8xxxu_write8(priv, REG_RSV_CTRL, val8);
 	}
 
+	if (priv->fops->init_aggregation)
+		priv->fops->init_aggregation(priv);
+
 	/*
 	 * Enable CCK and OFDM block
 	 */
@@ -7998,6 +8020,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.config_channel = rtl8723bu_config_channel,
 	.init_bt = rtl8723bu_init_bt,
 	.parse_rx_desc = rtl8723bu_parse_rx_desc,
+	.init_aggregation = rtl8723bu_init_aggregation,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 2250e1b..14b7a35 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1133,6 +1133,7 @@ struct rtl8xxxu_fileops {
 	void (*init_bt) (struct rtl8xxxu_priv *priv);
 	int (*parse_rx_desc) (struct rtl8xxxu_priv *priv, struct sk_buff *skb,
 			      struct ieee80211_rx_status *rx_status);
+	void (*init_aggregation) (struct rtl8xxxu_priv *priv);
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index ec6f40f..d6c7ad3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -318,6 +318,7 @@
 #define  PBP_PAGE_SIZE_1024		0x4
 
 #define REG_TRXDMA_CTRL			0x010c
+#define  TRXDMA_CTRL_RXDMA_AGG_EN	BIT(2)
 #define  TRXDMA_CTRL_VOQ_SHIFT		4
 #define  TRXDMA_CTRL_VIQ_SHIFT		6
 #define  TRXDMA_CTRL_BEQ_SHIFT		8
-- 
2.5.0

