Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbcB2WGG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:06 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 110/113] rtl8xxxu: Flush FIFO before powering down devices
Date: Mon, 29 Feb 2016 17:05:48 -0500
Message-Id: <1456783551-28315-111-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230628_709023_0699AA83)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This should help when reloading the driver for 8723bu devices

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 34 ++++++++++++++++++++++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  2 ++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 7f68b61..c594afa 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5687,6 +5687,36 @@ static int rtl8xxxu_emu_to_disabled(struct rtl8xxxu_priv *priv)
 	return 0;
 }
 
+static int rtl8xxxu_flush_fifo(struct rtl8xxxu_priv *priv)
+{
+	u32 val32;
+	int retry, retval;
+
+	rtl8xxxu_write8(priv, REG_TXPAUSE, 0xff);
+
+	val32 = rtl8xxxu_read32(priv, REG_RXPKT_NUM);
+	val32 |= RXPKT_NUM_RW_RELEASE_EN;
+	rtl8xxxu_write32(priv, REG_RXPKT_NUM, val32);
+
+	retry = 100;
+	retval = -EBUSY;
+
+	do {
+		val32 = rtl8xxxu_read32(priv, REG_RXPKT_NUM);
+		if (val32 & RXPKT_NUM_RXDMA_IDLE) {
+			retval = 0;
+			break;
+		}
+	} while (retry--);
+
+	rtl8xxxu_write16(priv, REG_RQPN_NPQ, 0);
+	rtl8xxxu_write32(priv, REG_RQPN, 0x80000000);
+	mdelay(2);
+	pr_info("%s: retry %i\n", __func__, retry);
+
+	return retval;
+}
+
 static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -5957,6 +5987,8 @@ static void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write32(priv, REG_FPGA0_XCD_RF_PARM, val32);
 	}
 
+	rtl8xxxu_flush_fifo(priv);
+
 	rtl8xxxu_active_to_lps(priv);
 
 	/* Turn off RF */
@@ -5995,6 +6027,8 @@ static void rtl8723bu_power_off(struct rtl8xxxu_priv *priv)
 	u8 val8;
 	u16 val16;
 
+	rtl8xxxu_flush_fifo(priv);
+
 	/*
 	 * Disable TX report timer
 	 */
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index a8d5c9f..e545e84 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -404,6 +404,8 @@
 #define REG_RXDMA_AGG_PG_TH		0x0280
 #define  RXDMA_USB_AGG_ENABLE		BIT(31)
 #define REG_RXPKT_NUM			0x0284
+#define  RXPKT_NUM_RXDMA_IDLE		BIT(17)
+#define  RXPKT_NUM_RW_RELEASE_EN	BIT(18)
 #define REG_RXDMA_STATUS		0x0288
 
 /* Presumably only found on newer chips such as 8723bu */
-- 
2.5.0

