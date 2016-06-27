Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbcF0QcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 12:32:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 10/12] rtl8xxxu: Make DMA aggregation optional by setting a module parameter
Date: Mon, 27 Jun 2016 12:32:08 -0400
Message-Id: <1467045130-18874-11-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160627_184249_116315_A81F55D1)
In-Reply-To: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Let the default to off until we have more data on the right default
tuning values.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index e488406..b392a92 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -44,6 +44,7 @@
 
 int rtl8xxxu_debug = RTL8XXXU_DEBUG_EFUSE;
 static bool rtl8xxxu_ht40_2g;
+static bool rtl8xxxu_dma_aggregation;
 
 MODULE_AUTHOR("Jes Sorensen <Jes.Sorensen@redhat.com>");
 MODULE_DESCRIPTION("RTL8XXXu USB mac80211 Wireless LAN Driver");
@@ -62,6 +63,8 @@ module_param_named(debug, rtl8xxxu_debug, int, 0600);
 MODULE_PARM_DESC(debug, "Set debug mask");
 module_param_named(ht40_2g, rtl8xxxu_ht40_2g, bool, 0600);
 MODULE_PARM_DESC(ht40_2g, "Enable HT40 support on the 2.4GHz band");
+module_param_named(dma_aggregation, rtl8xxxu_dma_aggregation, bool, 0600);
+MODULE_PARM_DESC(dma_aggregation, "Enable DMA packet aggregation");
 
 #define USB_VENDOR_ID_REALTEK		0x0bda
 #define RTL8XXXU_RX_URBS		32
@@ -4411,14 +4414,18 @@ void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
 
 	usb_spec = rtl8xxxu_read8(priv, REG_USB_SPECIAL_OPTION);
 	usb_spec &= ~USB_SPEC_USB_AGG_ENABLE;
+	rtl8xxxu_write8(priv, REG_USB_SPECIAL_OPTION, usb_spec);
 
 	agg_ctrl = rtl8xxxu_read8(priv, REG_TRXDMA_CTRL);
 	agg_ctrl &= ~TRXDMA_CTRL_RXDMA_AGG_EN;
 
-	agg_ctrl |= TRXDMA_CTRL_RXDMA_AGG_EN;
+	if (!rtl8xxxu_dma_aggregation) {
+		rtl8xxxu_write8(priv, REG_TRXDMA_CTRL, agg_ctrl);
+		return;
+	}
 
+	agg_ctrl |= TRXDMA_CTRL_RXDMA_AGG_EN;
 	rtl8xxxu_write8(priv, REG_TRXDMA_CTRL, agg_ctrl);
-	rtl8xxxu_write8(priv, REG_USB_SPECIAL_OPTION, usb_spec);
 
 	/*
 	 * The number of packets we can take looks to be buffer size / 512
-- 
2.7.4

