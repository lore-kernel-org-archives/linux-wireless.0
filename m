Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65029 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1I0Fsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 01:48:53 -0400
Received: by ywb5 with SMTP id 5so4977181ywb.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 22:48:53 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] rtlwifi: Remove unused _usb_nbytes_read_write and _usb_writeN_sync
Date: Tue, 27 Sep 2011 00:48:21 -0500
Message-Id: <1317102501-17387-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110927_074856_694812_87FDC104)
In-Reply-To: <1317102501-17387-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1317102501-17387-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/usb.c  |   30 ------------------------------
 drivers/net/wireless/rtlwifi/wifi.h |    6 ++----
 2 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 2e544a0..b42c2e2 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -191,35 +191,6 @@ static void _usb_write32_async(struct rtl_priv *rtlpriv, u32 addr, u32 val)
 	_usb_write_async(to_usb_device(dev), addr, val, 4);
 }
 
-static int _usb_nbytes_read_write(struct usb_device *udev, bool read, u32 addr,
-				  u16 len, u8 *pdata)
-{
-	int status;
-	u8 request;
-	u16 wvalue;
-	u16 index;
-
-	request = REALTEK_USB_VENQT_CMD_REQ;
-	index = REALTEK_USB_VENQT_CMD_IDX; /* n/a */
-	wvalue = (u16)addr;
-	if (read)
-		status = _usbctrl_vendorreq_sync_read(udev, request, wvalue,
-						      index, pdata, len);
-	else
-		status = _usbctrl_vendorreq_async_write(udev, request, wvalue,
-							index, pdata, len);
-	return status;
-}
-
-static int _usb_writeN_async(struct rtl_priv *rtlpriv, u32 addr, u16 len,
-			     u8 *pdata)
-{
-	struct device *dev = rtlpriv->io.dev;
-
-	return _usb_nbytes_read_write(to_usb_device(dev), false, addr, len,
-				      pdata);
-}
-
 static void _rtl_usb_io_handler_init(struct device *dev,
 				     struct ieee80211_hw *hw)
 {
@@ -230,7 +201,6 @@ static void _rtl_usb_io_handler_init(struct device *dev,
 	rtlpriv->io.write8_async	= _usb_write8_async;
 	rtlpriv->io.write16_async	= _usb_write16_async;
 	rtlpriv->io.write32_async	= _usb_write32_async;
-	rtlpriv->io.writeN_async	= _usb_writeN_async;
 	rtlpriv->io.read8_sync		= _usb_read8_sync;
 	rtlpriv->io.read16_sync		= _usb_read16_sync;
 	rtlpriv->io.read32_sync		= _usb_read32_sync;
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 31b3be9..3126485 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -942,10 +942,8 @@ struct rtl_io {
 	unsigned long pci_base_addr;	/*device I/O address */
 
 	void (*write8_async) (struct rtl_priv *rtlpriv, u32 addr, u8 val);
-	void (*write16_async) (struct rtl_priv *rtlpriv, u32 addr, u16 val);
-	void (*write32_async) (struct rtl_priv *rtlpriv, u32 addr, u32 val);
-	int (*writeN_async) (struct rtl_priv *rtlpriv, u32 addr, u16 len,
-			     u8 *pdata);
+	void (*write16_async) (struct rtl_priv *rtlpriv, u32 addr, __le16 val);
+	void (*write32_async) (struct rtl_priv *rtlpriv, u32 addr, __le32 val);
 
 	u8(*read8_sync) (struct rtl_priv *rtlpriv, u32 addr);
 	u16(*read16_sync) (struct rtl_priv *rtlpriv, u32 addr);
-- 
1.7.6.3

