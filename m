Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 065/113] rtl8xxxu: Initialize burst parameters for 8723bu
Date: Mon, 29 Feb 2016 17:05:03 -0500
Message-Id: <1456783551-28315-66-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230849_552365_056B1FB3)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Implement burst parameter sequence for 8723bu parts. Eventually this
should be moved into device specific sections.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 33 ++++++++++++++++++++++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  5 +++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 835eca8..ecd0f59 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6279,6 +6279,39 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	rtl8xxxu_write16(priv, REG_BEACON_TCFG, 0x660F);
 
 	/*
+	 * Initialize burst parameters
+	 */
+	if (priv->rtlchip == 0x8723b) {
+		/*
+		 * For USB high speed set 512B packets
+		 */
+		val8 = rtl8xxxu_read8(priv, REG_RXDMA_PRO_8723B);
+		val8 &= ~(BIT(4) | BIT(5));
+		val8 |= BIT(4);
+		val8 |= BIT(1) | BIT(2) | BIT(3);
+		rtl8xxxu_write8(priv, REG_RXDMA_PRO_8723B, val8);
+
+		/*
+		 * For USB high speed set 512B packets
+		 */
+		val8 = rtl8xxxu_read8(priv, REG_HT_SINGLE_AMPDU_8723B);
+		val8 |= BIT(7);
+		rtl8xxxu_write8(priv, REG_HT_SINGLE_AMPDU_8723B, val8);
+
+		rtl8xxxu_write16(priv, REG_MAX_AGGR_NUM, 0x0c14);
+		rtl8xxxu_write8(priv, REG_AMPDU_MAX_TIME_8723B, 0x5e);
+		rtl8xxxu_write32(priv, REG_AGGLEN_LMT, 0xffffffff);
+		rtl8xxxu_write8(priv, REG_RX_PKT_LIMIT, 0x18);
+		rtl8xxxu_write8(priv, REG_PIFS, 0x00);
+		rtl8xxxu_write8(priv, REG_USTIME_TSF_8723B, 0x50);
+		rtl8xxxu_write8(priv, REG_USTIME_EDCA, 0x50);
+
+		val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL);
+		val8 |= BIT(5) | BIT(6);
+		rtl8xxxu_write8(priv, REG_RSV_CTRL, val8);
+	}
+
+	/*
 	 * Enable CCK and OFDM block
 	 */
 	val32 = rtl8xxxu_read32(priv, REG_FPGA0_RF_MODE);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 5250388..8209830 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -405,7 +405,7 @@
 
 /* Presumably only found on newer chips such as 8723bu */
 #define REG_RX_DMA_CTRL_8723B		0x0286
-#define REG_RX_DMA_MODE_CTRL_8723B	0x0290
+#define REG_RXDMA_PRO_8723B		0x0290
 
 #define REG_RF_BB_CMD_ADDR		0x02c0
 #define REG_RF_BB_CMD_DATA		0x02c4
@@ -478,6 +478,7 @@
 #define REG_ARFR1			0x0448
 #define REG_ARFR2			0x044c
 #define REG_ARFR3			0x0450
+#define REG_AMPDU_MAX_TIME_8723B	0x0456
 #define REG_AGGLEN_LMT			0x0458
 #define REG_AMPDU_MIN_SPACE		0x045c
 #define REG_TXPKTBUF_WMAC_LBK_BF_HD	0x045d
@@ -496,6 +497,7 @@
 #define REG_PKT_VO_VI_LIFE_TIME		0x04c0
 #define REG_PKT_BE_BK_LIFE_TIME		0x04c2
 #define REG_STBC_SETTING		0x04c4
+#define REG_HT_SINGLE_AMPDU_8723B	0x04c7
 #define REG_PROT_MODE_CTRL		0x04c8
 #define REG_MAX_AGGR_NUM		0x04ca
 #define REG_RTS_MAX_AGGR_NUM		0x04cb
@@ -560,6 +562,7 @@
 #define  BEACON_DMA_ATIME_INT_TIME	2
 
 #define REG_ATIMWND			0x055a
+#define REG_USTIME_TSF_8723B		0x055c
 #define REG_BCN_MAX_ERR			0x055d
 #define REG_RXTSF_OFFSET_CCK		0x055e
 #define REG_RXTSF_OFFSET_OFDM		0x055f
-- 
2.5.0

