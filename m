Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35582 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab1KQSPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 13:15:20 -0500
Received: by mail-gx0-f174.google.com with SMTP id b2so1421463ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 10:15:19 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] rtlwifi: rtl8192cu: Fix endianian issues
Date: Thu, 17 Nov 2011 12:14:44 -0600
Message-Id: <1321553685-31154-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111117_191526_268652_2DFA1637)
In-Reply-To: <1321553685-31154-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1321553685-31154-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver rtlwifi fails on a big-endian host.

These changes have been tested on a Mac PowerBook G4, which has
a PPC processor.

Although this patch touches some of the code that will affect endian
issues on PCI hardware through drivers rtl8192ce, rtl8192se, and
rtl8192de, these have not been tested due to lack of suitable hardware.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/base.c               |    6 ++--
 drivers/net/wireless/rtlwifi/base.h               |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c |   28 ++++++++++++---------
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h |   20 +++++++-------
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c       |    9 +++---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      |    2 +-
 drivers/net/wireless/rtlwifi/usb.c                |   12 +++++---
 7 files changed, 43 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 3bb64e6..b78b3f1 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -345,9 +345,9 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	if (is_valid_ether_addr(rtlefuse->dev_addr)) {
 		SET_IEEE80211_PERM_ADDR(hw, rtlefuse->dev_addr);
 	} else {
-		u8 rtlmac[] = { 0x00, 0xe0, 0x4c, 0x81, 0x92, 0x00 };
-		get_random_bytes((rtlmac + (ETH_ALEN - 1)), 1);
-		SET_IEEE80211_PERM_ADDR(hw, rtlmac);
+		u8 rtlmac1[] = { 0x00, 0xe0, 0x4c, 0x81, 0x92, 0x00 };
+		get_random_bytes((rtlmac1 + (ETH_ALEN - 1)), 1);
+		SET_IEEE80211_PERM_ADDR(hw, rtlmac1);
 	}
 
 }
diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index b6eb85e..a7595e2 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -76,7 +76,7 @@ enum ap_peer {
 	SET_BITS_TO_LE_2BYTE(_hdr, 8, 1, _val)
 
 #define SET_80211_PS_POLL_AID(_hdr, _val)		\
-	(*(u16 *)((u8 *)(_hdr) + 2) = le16_to_cpu(_val))
+	(*(u16 *)((u8 *)(_hdr) + 2) = _val)
 #define SET_80211_PS_POLL_BSSID(_hdr, _val)		\
 	memcpy(((u8 *)(_hdr)) + 4, (u8 *)(_val), ETH_ALEN)
 #define SET_80211_PS_POLL_TA(_hdr, _val)		\
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
index e20bf31..fa393df 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -109,6 +109,7 @@ static void _rtl92c_fw_block_write(struct ieee80211_hw *hw,
 	u8 *bufferPtr = (u8 *) buffer;
 	u32 *pu4BytePtr = (u32 *) buffer;
 	u32 i, offset, blockCount, remainSize;
+	u32 data;
 
 	if (rtlpriv->io.writeN_sync) {
 		rtl_block_fw_writeN(hw, buffer, size);
@@ -116,20 +117,22 @@ static void _rtl92c_fw_block_write(struct ieee80211_hw *hw,
 	}
 	blockCount = size / blockSize;
 	remainSize = size % blockSize;
+	if (remainSize) {
+		/* the last word is < 4 bytes - pad it with zeros */
+		for (i = 0; i < 4 - remainSize; i++)
+			*(bufferPtr + size + i) = 0;
+		blockCount++;
+	}
 
 	for (i = 0; i < blockCount; i++) {
 		offset = i * blockSize;
+		/* for big-endian platforms, the firmware data need to be byte
+		 * swapped as it was read as a byte string and will be written
+		 * as 32-bit dwords and byte swapped when written
+		 */
+		data = le32_to_cpu(*(__le32 *)(pu4BytePtr + i));
 		rtl_write_dword(rtlpriv, (FW_8192C_START_ADDRESS + offset),
-				*(pu4BytePtr + i));
-	}
-
-	if (remainSize) {
-		offset = blockCount * blockSize;
-		bufferPtr += offset;
-		for (i = 0; i < remainSize; i++) {
-			rtl_write_byte(rtlpriv, (FW_8192C_START_ADDRESS +
-						 offset + i), *(bufferPtr + i));
-		}
+				data);
 	}
 }
 
@@ -270,8 +273,9 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
 	if (IS_FW_HEADER_EXIST(pfwheader)) {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
 			 ("Firmware Version(%d), Signature(%#x),Size(%d)\n",
-			  pfwheader->version, pfwheader->signature,
-			  (uint)sizeof(struct rtl92c_firmware_header)));
+			 le16_to_cpu(pfwheader->version),
+			 le16_to_cpu(pfwheader->signature),
+			 (uint)sizeof(struct rtl92c_firmware_header)));
 
 		pfwdata = pfwdata + sizeof(struct rtl92c_firmware_header);
 		fwsize = fwsize - sizeof(struct rtl92c_firmware_header);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
index c55c054..cec5a3a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
@@ -38,26 +38,26 @@
 #define FW_8192C_POLLING_TIMEOUT_COUNT		100
 
 #define IS_FW_HEADER_EXIST(_pfwhdr)	\
-	((_pfwhdr->signature&0xFFF0) == 0x92C0 ||\
-	(_pfwhdr->signature&0xFFF0) == 0x88C0)
+	((le16_to_cpu(_pfwhdr->signature)&0xFFF0) == 0x92C0 ||\
+	(le16_to_cpu(_pfwhdr->signature)&0xFFF0) == 0x88C0)
 
 struct rtl92c_firmware_header {
-	u16 signature;
+	__le16 signature;
 	u8 category;
 	u8 function;
-	u16 version;
+	__le16 version;
 	u8 subversion;
 	u8 rsvd1;
 	u8 month;
 	u8 date;
 	u8 hour;
 	u8 minute;
-	u16 ramcodeSize;
-	u16 rsvd2;
-	u32 svnindex;
-	u32 rsvd3;
-	u32 rsvd4;
-	u32 rsvd5;
+	__le16 ramcodeSize;
+	__le16 rsvd2;
+	__le32 svnindex;
+	__le32 rsvd3;
+	__le32 rsvd4;
+	__le32 rsvd5;
 };
 
 enum rtl8192c_h2c_cmd {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 814c05d..4ed973a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -498,7 +498,7 @@ static void _rtl92cu_read_adapter_info(struct ieee80211_hw *hw)
 	}
 	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_LOUD, ("MAP\n"),
 		      hwinfo, HWSET_MAX_SIZE);
-	eeprom_id = *((u16 *)&hwinfo[0]);
+	eeprom_id = le16_to_cpu(*((__le16 *)&hwinfo[0]));
 	if (eeprom_id != RTL8190_EEPROM_ID) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("EEPROM ID(%#x) is invalid!!\n", eeprom_id));
@@ -516,13 +516,14 @@ static void _rtl92cu_read_adapter_info(struct ieee80211_hw *hw)
 	pr_info("MAC address: %pM\n", rtlefuse->dev_addr);
 	_rtl92cu_read_txpower_info_from_hwpg(hw,
 					   rtlefuse->autoload_failflag, hwinfo);
-	rtlefuse->eeprom_vid = *(u16 *)&hwinfo[EEPROM_VID];
-	rtlefuse->eeprom_did = *(u16 *)&hwinfo[EEPROM_DID];
+	rtlefuse->eeprom_vid = le16_to_cpu(*(__le16 *)&hwinfo[EEPROM_VID]);
+	rtlefuse->eeprom_did = le16_to_cpu(*(__le16 *)&hwinfo[EEPROM_DID]);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 		 (" VID = 0x%02x PID = 0x%02x\n",
 		 rtlefuse->eeprom_vid, rtlefuse->eeprom_did));
 	rtlefuse->eeprom_channelplan = *(u8 *)&hwinfo[EEPROM_CHANNELPLAN];
-	rtlefuse->eeprom_version = *(u16 *)&hwinfo[EEPROM_VERSION];
+	rtlefuse->eeprom_version =
+			 le16_to_cpu(*(__le16 *)&hwinfo[EEPROM_VERSION]);
 	rtlefuse->txpwr_fromeprom = true;
 	rtlefuse->eeprom_oemid = *(u8 *)&hwinfo[EEPROM_CUSTOMER_ID];
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index f875fed..f27092c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -489,7 +489,7 @@ static void _rtl_tx_desc_checksum(u8 *txdesc)
 	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, 0);
 	for (index = 0; index < 16; index++)
 		checksum = checksum ^ (*(ptr + index));
-	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, checksum);
+	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, cpu_to_le16(checksum));
 }
 
 void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 34ea59b..ad109ad 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -83,6 +83,7 @@ static int _usbctrl_vendorreq_async_write(struct usb_device *udev, u8 request,
 	dr->wValue = cpu_to_le16(value);
 	dr->wIndex = cpu_to_le16(index);
 	dr->wLength = cpu_to_le16(len);
+	/* data are already in little-endian order */
 	memcpy(buf, pdata, len);
 	usb_fill_control_urb(urb, udev, pipe,
 			     (unsigned char *)dr, buf, len,
@@ -102,6 +103,7 @@ static int _usbctrl_vendorreq_sync_read(struct usb_device *udev, u8 request,
 	int status;
 	u8 reqtype;
 	int vendorreq_times = 0;
+	static int count;
 
 	pipe = usb_rcvctrlpipe(udev, 0); /* read_in */
 	reqtype =  REALTEK_USB_VENQT_READ;
@@ -118,9 +120,9 @@ static int _usbctrl_vendorreq_sync_read(struct usb_device *udev, u8 request,
 			break;
 		}
 	}
-	if (status < 0)
+	if (status < 0 && count++ < 4)
 		pr_err("reg 0x%x, usbctrl_vendorreq TimeOut! status:0x%x value=0x%x\n",
-		       value, status, *(u32 *)pdata);
+		       value, status, le32_to_cpu(*(u32 *)pdata));
 	return status;
 }
 
@@ -140,7 +142,7 @@ static u32 _usb_read_sync(struct usb_device *udev, u32 addr, u16 len)
 
 	wvalue = (u16)addr;
 	_usbctrl_vendorreq_sync_read(udev, request, wvalue, index, data, len);
-	ret = *data;
+	ret = le32_to_cpu(*data);
 	kfree(data);
 	return ret;
 }
@@ -172,12 +174,12 @@ static void _usb_write_async(struct usb_device *udev, u32 addr, u32 val,
 	u8 request;
 	u16 wvalue;
 	u16 index;
-	u32 data;
+	__le32 data;
 
 	request = REALTEK_USB_VENQT_CMD_REQ;
 	index = REALTEK_USB_VENQT_CMD_IDX; /* n/a */
 	wvalue = (u16)(addr&0x0000ffff);
-	data = val;
+	data = cpu_to_le32(val);
 	_usbctrl_vendorreq_async_write(udev, request, wvalue, index, &data,
 				       len);
 }
-- 
1.7.7

