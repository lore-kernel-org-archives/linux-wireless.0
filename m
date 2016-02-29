Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 015/113] rtl8xxxu: Only setup USB interrupts for parts which support it
Date: Mon, 29 Feb 2016 17:04:13 -0500
Message-Id: <1456783551-28315-16-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232949_852992_3E859A12)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Only 1st generation chips do provide USB interrupts, so do not try to
setup interrupts for newer chips (8192eu and 8723bu).

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 18 +++++++++++++-----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 66a0c17..b3fd5c2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1707,6 +1707,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 			priv->rtlchip = 0x8723b;
 		} else {
 			sprintf(priv->chip_name, "8723AU");
+			priv->usb_interrupts = 1;
 			priv->rtlchip = 0x8723a;
 		}
 
@@ -1744,12 +1745,14 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 			priv->rf_paths = 2;
 			priv->rx_paths = 2;
 			priv->tx_paths = 1;
+			priv->usb_interrupts = 1;
 			priv->rtlchip = 0x8191c;
 		} else {
 			sprintf(priv->chip_name, "8192CU");
 			priv->rf_paths = 2;
 			priv->rx_paths = 2;
 			priv->tx_paths = 2;
+			priv->usb_interrupts = 1;
 			priv->rtlchip = 0x8192c;
 		}
 		priv->has_wifi = 1;
@@ -1759,6 +1762,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		priv->rx_paths = 1;
 		priv->tx_paths = 1;
 		priv->rtlchip = 0x8188c;
+		priv->usb_interrupts = 1;
 		priv->has_wifi = 1;
 	}
 
@@ -5825,9 +5829,11 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	init_usb_anchor(&priv->int_anchor);
 
 	rtl8723a_enable_rf(priv);
-	ret = rtl8xxxu_submit_int_urb(hw);
-	if (ret)
-		goto exit;
+	if (priv->usb_interrupts) {
+		ret = rtl8xxxu_submit_int_urb(hw);
+		if (ret)
+			goto exit;
+	}
 
 	for (i = 0; i < RTL8XXXU_TX_URBS; i++) {
 		tx_urb = kmalloc(sizeof(struct rtl8xxxu_tx_urb), GFP_KERNEL);
@@ -5902,14 +5908,16 @@ static void rtl8xxxu_stop(struct ieee80211_hw *hw)
 
 	usb_kill_anchored_urbs(&priv->rx_anchor);
 	usb_kill_anchored_urbs(&priv->tx_anchor);
-	usb_kill_anchored_urbs(&priv->int_anchor);
+	if (priv->usb_interrupts)
+		usb_kill_anchored_urbs(&priv->int_anchor);
 
 	rtl8723a_disable_rf(priv);
 
 	/*
 	 * Disable interrupts
 	 */
-	rtl8xxxu_write32(priv, REG_USB_HIMR, 0);
+	if (priv->usb_interrupts)
+		rtl8xxxu_write32(priv, REG_USB_HIMR, 0);
 
 	rtl8xxxu_free_rx_resources(priv);
 	rtl8xxxu_free_tx_resources(priv);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index bf424db..2055048 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -693,6 +693,7 @@ struct rtl8xxxu_priv {
 	u32 has_polarity_ctrl:1;
 	u32 has_eeprom:1;
 	u32 boot_eeprom:1;
+	u32 usb_interrupts:1;
 	u32 ep_tx_high_queue:1;
 	u32 ep_tx_normal_queue:1;
 	u32 ep_tx_low_queue:1;
-- 
2.5.0

