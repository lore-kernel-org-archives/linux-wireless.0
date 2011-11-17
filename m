Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37324 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1KQSPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 13:15:18 -0500
Received: by mail-yw0-f46.google.com with SMTP id 32so1410397ywt.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 10:15:18 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] rtlwifi: rtl8192cu: Change firmware upload to use block writes
Date: Thu, 17 Nov 2011 12:14:43 -0600
Message-Id: <1321553685-31154-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111117_191531_734748_D4A498E4)
In-Reply-To: <1321553685-31154-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1321553685-31154-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver rtl8192cu writes the firmware with 32-bit asynchronous writes. This
design is OK for USB 2.0 adapters, but the current implementation of
xhcu-hcd has a limited ring size, which is exceeded. By converting to
synchronous block writes, this error is avoided.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c |   32 +++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c      |    1 +
 drivers/net/wireless/rtlwifi/usb.c                |   26 ++++++++++++++++-
 drivers/net/wireless/rtlwifi/wifi.h               |    7 +++-
 5 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
index 950c65a..e20bf31 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -73,6 +73,34 @@ static void _rtl92c_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 	}
 }
 
+static void rtl_block_fw_writeN(struct ieee80211_hw *hw, const u8 *buffer,
+				u32 size)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 blockSize = REALTEK_USB_VENQT_MAX_BUF_SIZE - 20;
+	u8 *bufferPtr = (u8 *) buffer;
+	u32 i, offset, blockCount, remainSize;
+
+	blockCount = size / blockSize;
+	remainSize = size % blockSize;
+
+	for (i = 0; i < blockCount; i++) {
+		offset = i * blockSize;
+		rtlpriv->io.writeN_sync(rtlpriv,
+					(FW_8192C_START_ADDRESS + offset),
+					(void *)(bufferPtr + offset),
+					blockSize);
+	}
+
+	if (remainSize) {
+		offset = blockCount * blockSize;
+		rtlpriv->io.writeN_sync(rtlpriv,
+					(FW_8192C_START_ADDRESS + offset),
+					(void *)(bufferPtr + offset),
+					remainSize);
+	}
+}
+
 static void _rtl92c_fw_block_write(struct ieee80211_hw *hw,
 				   const u8 *buffer, u32 size)
 {
@@ -82,6 +110,10 @@ static void _rtl92c_fw_block_write(struct ieee80211_hw *hw,
 	u32 *pu4BytePtr = (u32 *) buffer;
 	u32 i, offset, blockCount, remainSize;
 
+	if (rtlpriv->io.writeN_sync) {
+		rtl_block_fw_writeN(hw, buffer, size);
+		return;
+	}
 	blockCount = size / blockSize;
 	remainSize = size % blockSize;
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
index fcc4032..c55c054 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
@@ -94,5 +94,6 @@ void rtl92c_firmware_selfreset(struct ieee80211_hw *hw);
 void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
 void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished);
 void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
+void usb_writeN_async(struct rtl_priv *rtlpriv, u32 addr, void *data, u16 len);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index 060a06f..9e0c8fc 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -84,6 +84,7 @@ void rtl92c_read_chip_version(struct ieee80211_hw *hw)
 		}
 	}
 	rtlhal->version  = (enum version_8192c)chip_version;
+	pr_info("rtl8192cu: Chip version 0x%x\n", chip_version);
 	switch (rtlhal->version) {
 	case VERSION_NORMAL_TSMC_CHIP_92C_1T2R:
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index add29e9..34ea59b 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -41,7 +41,6 @@
 #define REALTEK_USB_VENQT_CMD_REQ		0x05
 #define	REALTEK_USB_VENQT_CMD_IDX		0x00
 
-#define REALTEK_USB_VENQT_MAX_BUF_SIZE		254
 #define MAX_USBCTRL_VENDORREQ_TIMES		10
 
 static void usbctrl_async_callback(struct urb *urb)
@@ -204,6 +203,30 @@ static void _usb_write32_async(struct rtl_priv *rtlpriv, u32 addr, u32 val)
 	_usb_write_async(to_usb_device(dev), addr, val, 4);
 }
 
+static void _usb_writeN_sync(struct rtl_priv *rtlpriv, u32 addr, void *data,
+			     u16 len)
+{
+	struct device *dev = rtlpriv->io.dev;
+	struct usb_device *udev = to_usb_device(dev);
+	u8 request = REALTEK_USB_VENQT_CMD_REQ;
+	u8 reqtype =  REALTEK_USB_VENQT_WRITE;
+	u16 wvalue;
+	u16 index = REALTEK_USB_VENQT_CMD_IDX;
+	int pipe = usb_sndctrlpipe(udev, 0); /* write_out */
+	u8 *buffer;
+	dma_addr_t dma_addr;
+
+	wvalue = (u16)(addr&0x0000ffff);
+	buffer = usb_alloc_coherent(udev, (size_t)len, GFP_ATOMIC, &dma_addr);
+	if (!buffer)
+		return;
+	memcpy(buffer, data, len);
+	usb_control_msg(udev, pipe, request, reqtype, wvalue,
+			index, buffer, len, 50);
+
+	usb_free_coherent(udev, (size_t)len, buffer, dma_addr);
+}
+
 static void _rtl_usb_io_handler_init(struct device *dev,
 				     struct ieee80211_hw *hw)
 {
@@ -217,6 +240,7 @@ static void _rtl_usb_io_handler_init(struct device *dev,
 	rtlpriv->io.read8_sync		= _usb_read8_sync;
 	rtlpriv->io.read16_sync		= _usb_read16_sync;
 	rtlpriv->io.read32_sync		= _usb_read32_sync;
+	rtlpriv->io.writeN_sync		= _usb_writeN_sync;
 }
 
 static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 713c7dd..f3c132b 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -63,6 +63,7 @@
 #define AC_MAX					4
 #define QOS_QUEUE_NUM				4
 #define RTL_MAC80211_NUM_QUEUE			5
+#define REALTEK_USB_VENQT_MAX_BUF_SIZE		254
 
 #define QBSS_LOAD_SIZE				5
 #define MAX_WMMELE_LENGTH			64
@@ -943,8 +944,10 @@ struct rtl_io {
 	unsigned long pci_base_addr;	/*device I/O address */
 
 	void (*write8_async) (struct rtl_priv *rtlpriv, u32 addr, u8 val);
-	void (*write16_async) (struct rtl_priv *rtlpriv, u32 addr, __le16 val);
-	void (*write32_async) (struct rtl_priv *rtlpriv, u32 addr, __le32 val);
+	void (*write16_async) (struct rtl_priv *rtlpriv, u32 addr, u16 val);
+	void (*write32_async) (struct rtl_priv *rtlpriv, u32 addr, u32 val);
+	void (*writeN_sync) (struct rtl_priv *rtlpriv, u32 addr, void *buf,
+			     u16 len);
 
 	u8(*read8_sync) (struct rtl_priv *rtlpriv, u32 addr);
 	u16(*read16_sync) (struct rtl_priv *rtlpriv, u32 addr);
-- 
1.7.7

