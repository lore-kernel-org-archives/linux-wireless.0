Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbcF0QcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 12:32:12 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 11/12] rtl8xxxu: gen1: Set aggregation timeout (REG_RXDMA_AGG_PG_TH + 1) as well
Date: Mon, 27 Jun 2016 12:32:09 -0400
Message-Id: <1467045130-18874-12-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160627_183228_519681_0821FA26)
In-Reply-To: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

gen2 chips as well as 8188eu seems to use this register for setting
DMA timeout threshold values, however the 8192cu is using
REG_USB_DMA_AGG_TO. Set both to be on the safe side.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index b392a92..609c216 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4410,7 +4410,7 @@ void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 
 void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
 {
-	u8 agg_ctrl, usb_spec, page_thresh;
+	u8 agg_ctrl, usb_spec, page_thresh, timeout;
 
 	usb_spec = rtl8xxxu_read8(priv, REG_USB_SPECIAL_OPTION);
 	usb_spec &= ~USB_SPEC_USB_AGG_ENABLE;
@@ -4442,7 +4442,14 @@ void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
 
 	page_thresh = (priv->fops->rx_agg_buf_size / 512);
 	rtl8xxxu_write8(priv, REG_RXDMA_AGG_PG_TH, page_thresh);
-	rtl8xxxu_write8(priv, REG_USB_DMA_AGG_TO, 4);
+	/*
+	 * REG_RXDMA_AGG_PG_TH + 1 seems to be the timeout register on
+	 * gen2 chips and rtl8188eu. The rtl8723au seems unhappy if we
+	 * don't set it, so better set both.
+	 */
+	timeout = 4;
+	rtl8xxxu_write8(priv, REG_RXDMA_AGG_PG_TH + 1, timeout);
+	rtl8xxxu_write8(priv, REG_USB_DMA_AGG_TO, timeout);
 	priv->rx_buf_aggregation = 1;
 }
 
-- 
2.7.4

