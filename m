Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13804 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2CSUoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 16:44:34 -0400
Date: Mon, 19 Mar 2012 15:44:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: joe@perches.com, linux-wireless@vger.kernel.org
Subject: [PATCH V2] rtlwifi: Preallocate USB read buffers and eliminate
 kalloc in read routine
Message-ID: <4f679aaf.mzz0Ty2aMFrgD2NO%Larry.Finger@lwfinger.net> (sfid-20120319_214438_360735_759E6511)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current version of rtlwifi for USB operations uses kmalloc to
acquire a 32-bit buffer for each read of the device. When
_usb_read_sync() is called with the rcu_lock held, the result is
a "sleeping function called from invalid context" BUG. This is
reported for two cases in https://bugzilla.kernel.org/show_bug.cgi?id=42775.
The first case has the lock originating from within rtlwifi and could
be fixed by rearranging the locking; however, the second originates from
within mac80211. The kmalloc() call is removed from _usb_read_sync()
by creating a ring buffer pointer in the private area and
allocating the buffer data in the probe routine.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> [This version good for 3.3+ - different patch for 3.2 - 2.6.39]
---

V2 - rewrote the commit message.
   - eliminated an ASSERT message that is not needed.
---

John,

This bug only shows up with full debugging; therefore, it can be part of
kernel 3.5.

Larry
---

 usb.c  |   34 ++++++++++++++++------------------
 wifi.h |    6 +++++-
 2 files changed, 21 insertions(+), 19 deletions(-)

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -124,46 +124,38 @@ static int _usbctrl_vendorreq_sync_read(
 	return status;
 }
 
-static u32 _usb_read_sync(struct usb_device *udev, u32 addr, u16 len)
+static u32 _usb_read_sync(struct rtl_priv *rtlpriv, u32 addr, u16 len)
 {
+	struct device *dev = rtlpriv->io.dev;
+	struct usb_device *udev = to_usb_device(dev);
 	u8 request;
 	u16 wvalue;
 	u16 index;
-	u32 *data;
-	u32 ret;
+	__le32 *data = &rtlpriv->usb_data[rtlpriv->usb_data_index];
 
-	data = kmalloc(sizeof(u32), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
 	request = REALTEK_USB_VENQT_CMD_REQ;
 	index = REALTEK_USB_VENQT_CMD_IDX; /* n/a */
 
 	wvalue = (u16)addr;
 	_usbctrl_vendorreq_sync_read(udev, request, wvalue, index, data, len);
-	ret = le32_to_cpu(*data);
-	kfree(data);
-	return ret;
+	if (++rtlpriv->usb_data_index >= RTL_USB_MAX_RX_COUNT)
+		rtlpriv->usb_data_index = 0;
+	return le32_to_cpu(*data);
 }
 
 static u8 _usb_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	struct device *dev = rtlpriv->io.dev;
-
-	return (u8)_usb_read_sync(to_usb_device(dev), addr, 1);
+	return (u8)_usb_read_sync(rtlpriv, addr, 1);
 }
 
 static u16 _usb_read16_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	struct device *dev = rtlpriv->io.dev;
-
-	return (u16)_usb_read_sync(to_usb_device(dev), addr, 2);
+	return (u16)_usb_read_sync(rtlpriv, addr, 2);
 }
 
 static u32 _usb_read32_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	struct device *dev = rtlpriv->io.dev;
-
-	return _usb_read_sync(to_usb_device(dev), addr, 4);
+	return _usb_read_sync(rtlpriv, addr, 4);
 }
 
 static void _usb_write_async(struct usb_device *udev, u32 addr, u32 val,
@@ -955,6 +947,11 @@ int __devinit rtl_usb_probe(struct usb_i
 		return -ENOMEM;
 	}
 	rtlpriv = hw->priv;
+	rtlpriv->usb_data = kzalloc(RTL_USB_MAX_RX_COUNT * sizeof(u32),
+				    GFP_KERNEL);
+	if (!rtlpriv->usb_data)
+		return -ENOMEM;
+	rtlpriv->usb_data_index = 0;
 	init_completion(&rtlpriv->firmware_loading_complete);
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	udev = interface_to_usbdev(intf);
@@ -1025,6 +1022,7 @@ void rtl_usb_disconnect(struct usb_inter
 	/* rtl_deinit_rfkill(hw); */
 	rtl_usb_deinit(hw);
 	rtl_deinit_core(hw);
+	kfree(rtlpriv->usb_data);
 	rtlpriv->cfg->ops->deinit_sw_leds(hw);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 	_rtl_usb_io_handler_release(hw);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -67,7 +67,7 @@
 #define QOS_QUEUE_NUM				4
 #define RTL_MAC80211_NUM_QUEUE			5
 #define REALTEK_USB_VENQT_MAX_BUF_SIZE		254
-
+#define RTL_USB_MAX_RX_COUNT			100
 #define QBSS_LOAD_SIZE				5
 #define MAX_WMMELE_LENGTH			64
 
@@ -1629,6 +1629,10 @@ struct rtl_priv {
 	   interface or hardware */
 	unsigned long status;
 
+	/* data buffer pointer for USB reads */
+	__le32 *usb_data;
+	int usb_data_index;
+
 	/*This must be the last item so
 	   that it points to the data allocated
 	   beyond  this structure like:
