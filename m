Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63329 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1I0Fsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 01:48:52 -0400
Received: by gyg10 with SMTP id 10so4834912gyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 22:48:51 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] rtlwifi: Remove unused routine _usb_readN_sync
Date: Tue, 27 Sep 2011 00:48:20 -0500
Message-Id: <1317102501-17387-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110927_074856_045616_67D5BB74)
In-Reply-To: <1317102501-17387-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1317102501-17387-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/usb.c  |   10 ----------
 drivers/net/wireless/rtlwifi/wifi.h |    2 --
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 4bf3cf4..2e544a0 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -211,15 +211,6 @@ static int _usb_nbytes_read_write(struct usb_device *udev, bool read, u32 addr,
 	return status;
 }
 
-static int _usb_readN_sync(struct rtl_priv *rtlpriv, u32 addr, u16 len,
-			   u8 *pdata)
-{
-	struct device *dev = rtlpriv->io.dev;
-
-	return _usb_nbytes_read_write(to_usb_device(dev), true, addr, len,
-				       pdata);
-}
-
 static int _usb_writeN_async(struct rtl_priv *rtlpriv, u32 addr, u16 len,
 			     u8 *pdata)
 {
@@ -243,7 +234,6 @@ static void _rtl_usb_io_handler_init(struct device *dev,
 	rtlpriv->io.read8_sync		= _usb_read8_sync;
 	rtlpriv->io.read16_sync		= _usb_read16_sync;
 	rtlpriv->io.read32_sync		= _usb_read32_sync;
-	rtlpriv->io.readN_sync		= _usb_readN_sync;
 }
 
 static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 615f6b4..31b3be9 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -950,8 +950,6 @@ struct rtl_io {
 	u8(*read8_sync) (struct rtl_priv *rtlpriv, u32 addr);
 	u16(*read16_sync) (struct rtl_priv *rtlpriv, u32 addr);
 	u32(*read32_sync) (struct rtl_priv *rtlpriv, u32 addr);
-	int (*readN_sync) (struct rtl_priv *rtlpriv, u32 addr, u16 len,
-			    u8 *pdata);
 
 };
 
-- 
1.7.6.3

