Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:32885 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753981AbdASUgF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 15:36:05 -0500
Received: by mail-ot0-f194.google.com with SMTP id f9so5512018otd.0
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 12:36:05 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH v2 1/3] rtlwifi: Download firmware as bytes rather than as dwords
Date: Thu, 19 Jan 2017 14:28:06 -0600
Message-Id: <20170119202808.27752-2-Larry.Finger@lwfinger.net> (sfid-20170119_213610_381661_BF463DCC)
In-Reply-To: <20170119202808.27752-1-Larry.Finger@lwfinger.net>
References: <20170119202808.27752-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware is read from disk as a little-endian byte string. The code
that loads the firmware into the device transfers it as 4-byte quantities.
The routines that write multi-byte quantities on BE hardware assume that
the data are in CPU order, and automatically do the conversion to the LE
order required by the device. As a result, the firmware is transmitted
incorrectly. Rather than do multiple byte swaps on the data, the download
routine is revised to transmit bytes rather than dwords. Although the
number of I/O operations is increased, the firmware is not often loaded.

All drivers have the same bug, and use essentially the same code to
download firmware. These routines have been moved into rtlwifi.

Some CamelCase variables have been renamed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
V2 - No functional changes. Merge conflict resolved.
---
 drivers/net/wireless/realtek/rtlwifi/efuse.c       | 45 ++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/efuse.h       |  4 ++
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    | 67 ++-------------------
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.c  | 70 +++-------------------
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.c    | 70 +++-------------------
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    | 68 ++-------------------
 .../realtek/rtlwifi/rtl8723com/fw_common.c         | 69 ++-------------------
 .../realtek/rtlwifi/rtl8723com/fw_common.h         |  6 --
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    | 67 ++-------------------
 9 files changed, 85 insertions(+), 381 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index afc7550..eb58633 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -31,6 +31,9 @@ static const u8 MAX_PGPKT_SIZE = 9;
 static const u8 PGPKT_DATA_SIZE = 8;
 static const int EFUSE_MAX_SIZE = 512;
 
+#define START_ADDRESS		0x1000
+#define REG_MCUFWDL		0x0080
+
 static const struct efuse_map RTL8712_SDIO_EFUSE_TABLE[] = {
 	{0, 0, 0, 2},
 	{0, 1, 0, 2},
@@ -1320,3 +1323,45 @@ int rtl_get_hwinfo(struct ieee80211_hw *hw, struct rtl_priv *rtlpriv,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rtl_get_hwinfo);
+
+void rtl_fw_block_write(struct ieee80211_hw *hw, const u8 *buffer, u32 size)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 *pu4byteptr = (u8 *)buffer;
+	u32 i;
+
+	for (i = 0; i < size; i++)
+		rtl_write_byte(rtlpriv, (START_ADDRESS + i), *(pu4byteptr + i));
+}
+EXPORT_SYMBOL_GPL(rtl_fw_block_write);
+
+void rtl_fw_page_write(struct ieee80211_hw *hw, u32 page, const u8 *buffer,
+		       u32 size)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 value8;
+	u8 u8page = (u8)(page & 0x07);
+
+	value8 = (rtl_read_byte(rtlpriv, REG_MCUFWDL + 2) & 0xF8) | u8page;
+
+	rtl_write_byte(rtlpriv, (REG_MCUFWDL + 2), value8);
+	rtl_fw_block_write(hw, buffer, size);
+}
+EXPORT_SYMBOL_GPL(rtl_fw_page_write);
+
+void rtl_fill_dummy(u8 *pfwbuf, u32 *pfwlen)
+{
+	u32 fwlen = *pfwlen;
+	u8 remain = (u8)(fwlen % 4);
+
+	remain = (remain == 0) ? 0 : (4 - remain);
+
+	while (remain > 0) {
+		pfwbuf[fwlen] = 0;
+		fwlen++;
+		remain--;
+	}
+
+	*pfwlen = fwlen;
+}
+EXPORT_SYMBOL_GPL(rtl_fill_dummy);
diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.h b/drivers/net/wireless/realtek/rtlwifi/efuse.h
index 51aa121..1338ae6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.h
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.h
@@ -111,5 +111,9 @@ void efuse_force_write_vendor_Id(struct ieee80211_hw *hw);
 void efuse_re_pg_section(struct ieee80211_hw *hw, u8 section_idx);
 int rtl_get_hwinfo(struct ieee80211_hw *hw, struct rtl_priv *rtlpriv,
 		   int max_size, u8 *hwinfo, int *params);
+void rtl_fill_dummy(u8 *pfwbuf, u32 *pfwlen);
+void rtl_fw_page_write(struct ieee80211_hw *hw, u32 page, const u8 *buffer,
+		       u32 size);
+void rtl_fw_block_write(struct ieee80211_hw *hw, const u8 *buffer, u32 size);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
index afa784a..21ed9ad 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
@@ -27,6 +27,7 @@
 #include "../pci.h"
 #include "../base.h"
 #include "../core.h"
+#include "../efuse.h"
 #include "reg.h"
 #include "def.h"
 #include "fw.h"
@@ -53,63 +54,6 @@ static void _rtl88e_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 	}
 }
 
-static void _rtl88e_fw_block_write(struct ieee80211_hw *hw,
-				   const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 blocksize = sizeof(u32);
-	u8 *bufferptr = (u8 *)buffer;
-	u32 *pu4BytePtr = (u32 *)buffer;
-	u32 i, offset, blockcount, remainsize;
-
-	blockcount = size / blocksize;
-	remainsize = size % blocksize;
-
-	for (i = 0; i < blockcount; i++) {
-		offset = i * blocksize;
-		rtl_write_dword(rtlpriv, (FW_8192C_START_ADDRESS + offset),
-				*(pu4BytePtr + i));
-	}
-
-	if (remainsize) {
-		offset = blockcount * blocksize;
-		bufferptr += offset;
-		for (i = 0; i < remainsize; i++) {
-			rtl_write_byte(rtlpriv, (FW_8192C_START_ADDRESS +
-						 offset + i), *(bufferptr + i));
-		}
-	}
-}
-
-static void _rtl88e_fw_page_write(struct ieee80211_hw *hw,
-				  u32 page, const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 value8;
-	u8 u8page = (u8) (page & 0x07);
-
-	value8 = (rtl_read_byte(rtlpriv, REG_MCUFWDL + 2) & 0xF8) | u8page;
-
-	rtl_write_byte(rtlpriv, (REG_MCUFWDL + 2), value8);
-	_rtl88e_fw_block_write(hw, buffer, size);
-}
-
-static void _rtl88e_fill_dummy(u8 *pfwbuf, u32 *pfwlen)
-{
-	u32 fwlen = *pfwlen;
-	u8 remain = (u8) (fwlen % 4);
-
-	remain = (remain == 0) ? 0 : (4 - remain);
-
-	while (remain > 0) {
-		pfwbuf[fwlen] = 0;
-		fwlen++;
-		remain--;
-	}
-
-	*pfwlen = fwlen;
-}
-
 static void _rtl88e_write_fw(struct ieee80211_hw *hw,
 			     enum version_8188e version, u8 *buffer, u32 size)
 {
@@ -120,7 +64,7 @@ static void _rtl88e_write_fw(struct ieee80211_hw *hw,
 
 	RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD, "FW size is %d bytes,\n", size);
 
-	_rtl88e_fill_dummy(bufferptr, &size);
+	rtl_fill_dummy(bufferptr, &size);
 
 	pagenums = size / FW_8192C_PAGE_SIZE;
 	remainsize = size % FW_8192C_PAGE_SIZE;
@@ -130,15 +74,14 @@ static void _rtl88e_write_fw(struct ieee80211_hw *hw,
 
 	for (page = 0; page < pagenums; page++) {
 		offset = page * FW_8192C_PAGE_SIZE;
-		_rtl88e_fw_page_write(hw, page, (bufferptr + offset),
-				      FW_8192C_PAGE_SIZE);
+		rtl_fw_page_write(hw, page, (bufferptr + offset),
+				  FW_8192C_PAGE_SIZE);
 	}
 
 	if (remainsize) {
 		offset = pagenums * FW_8192C_PAGE_SIZE;
 		page = pagenums;
-		_rtl88e_fw_page_write(hw, page, (bufferptr + offset),
-				      remainsize);
+		rtl_fw_page_write(hw, page, (bufferptr + offset), remainsize);
 	}
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index 433ab7f..c7a7746 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -27,6 +27,7 @@
 #include "../pci.h"
 #include "../base.h"
 #include "../core.h"
+#include "../efuse.h"
 #include "../rtl8192ce/reg.h"
 #include "../rtl8192ce/def.h"
 #include "fw_common.h"
@@ -68,63 +69,6 @@ static void _rtl92c_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 	}
 }
 
-static void _rtl92c_fw_block_write(struct ieee80211_hw *hw,
-				   const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 blocksize = sizeof(u32);
-	u8 *bufferptr = (u8 *)buffer;
-	u32 *pu4byteptr = (u32 *)buffer;
-	u32 i, offset, blockcount, remainsize;
-
-	blockcount = size / blocksize;
-	remainsize = size % blocksize;
-
-	for (i = 0; i < blockcount; i++) {
-		offset = i * blocksize;
-		rtl_write_dword(rtlpriv, (FW_8192C_START_ADDRESS + offset),
-				*(pu4byteptr + i));
-	}
-
-	if (remainsize) {
-		offset = blockcount * blocksize;
-		bufferptr += offset;
-		for (i = 0; i < remainsize; i++) {
-			rtl_write_byte(rtlpriv, (FW_8192C_START_ADDRESS +
-						 offset + i), *(bufferptr + i));
-		}
-	}
-}
-
-static void _rtl92c_fw_page_write(struct ieee80211_hw *hw,
-				  u32 page, const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 value8;
-	u8 u8page = (u8) (page & 0x07);
-
-	value8 = (rtl_read_byte(rtlpriv, REG_MCUFWDL + 2) & 0xF8) | u8page;
-
-	rtl_write_byte(rtlpriv, (REG_MCUFWDL + 2), value8);
-	_rtl92c_fw_block_write(hw, buffer, size);
-}
-
-static void _rtl92c_fill_dummy(u8 *pfwbuf, u32 *pfwlen)
-{
-	u32 fwlen = *pfwlen;
-	u8 remain = (u8) (fwlen % 4);
-
-	remain = (remain == 0) ? 0 : (4 - remain);
-
-	while (remain > 0) {
-		pfwbuf[fwlen] = 0;
-		fwlen++;
-		remain--;
-	}
-
-	*pfwlen = fwlen;
-}
-
 static void _rtl92c_write_fw(struct ieee80211_hw *hw,
 			     enum version_8192c version, u8 *buffer, u32 size)
 {
@@ -140,7 +84,7 @@ static void _rtl92c_write_fw(struct ieee80211_hw *hw,
 		u32 page, offset;
 
 		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192CE)
-			_rtl92c_fill_dummy(bufferptr, &size);
+			rtl_fill_dummy(bufferptr, &size);
 
 		pageNums = size / FW_8192C_PAGE_SIZE;
 		remainsize = size % FW_8192C_PAGE_SIZE;
@@ -150,18 +94,18 @@ static void _rtl92c_write_fw(struct ieee80211_hw *hw,
 
 		for (page = 0; page < pageNums; page++) {
 			offset = page * FW_8192C_PAGE_SIZE;
-			_rtl92c_fw_page_write(hw, page, (bufferptr + offset),
-					      FW_8192C_PAGE_SIZE);
+			rtl_fw_page_write(hw, page, (bufferptr + offset),
+					  FW_8192C_PAGE_SIZE);
 		}
 
 		if (remainsize) {
 			offset = pageNums * FW_8192C_PAGE_SIZE;
 			page = pageNums;
-			_rtl92c_fw_page_write(hw, page, (bufferptr + offset),
-					      remainsize);
+			rtl_fw_page_write(hw, page, (bufferptr + offset),
+					  remainsize);
 		}
 	} else {
-		_rtl92c_fw_block_write(hw, buffer, size);
+		rtl_fw_block_write(hw, buffer, size);
 	}
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
index 569d572..88faeab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
@@ -26,6 +26,7 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../base.h"
+#include "../efuse.h"
 #include "reg.h"
 #include "def.h"
 #include "fw.h"
@@ -59,84 +60,31 @@ static void _rtl92d_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 	}
 }
 
-static void _rtl92d_fw_block_write(struct ieee80211_hw *hw,
-				   const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 blocksize = sizeof(u32);
-	u8 *bufferptr = (u8 *) buffer;
-	u32 *pu4BytePtr = (u32 *) buffer;
-	u32 i, offset, blockCount, remainSize;
-
-	blockCount = size / blocksize;
-	remainSize = size % blocksize;
-	for (i = 0; i < blockCount; i++) {
-		offset = i * blocksize;
-		rtl_write_dword(rtlpriv, (FW_8192D_START_ADDRESS + offset),
-				*(pu4BytePtr + i));
-	}
-	if (remainSize) {
-		offset = blockCount * blocksize;
-		bufferptr += offset;
-		for (i = 0; i < remainSize; i++) {
-			rtl_write_byte(rtlpriv, (FW_8192D_START_ADDRESS +
-						 offset + i), *(bufferptr + i));
-		}
-	}
-}
-
-static void _rtl92d_fw_page_write(struct ieee80211_hw *hw,
-				  u32 page, const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 value8;
-	u8 u8page = (u8) (page & 0x07);
-
-	value8 = (rtl_read_byte(rtlpriv, REG_MCUFWDL + 2) & 0xF8) | u8page;
-	rtl_write_byte(rtlpriv, (REG_MCUFWDL + 2), value8);
-	_rtl92d_fw_block_write(hw, buffer, size);
-}
-
-static void _rtl92d_fill_dummy(u8 *pfwbuf, u32 *pfwlen)
-{
-	u32 fwlen = *pfwlen;
-	u8 remain = (u8) (fwlen % 4);
-
-	remain = (remain == 0) ? 0 : (4 - remain);
-	while (remain > 0) {
-		pfwbuf[fwlen] = 0;
-		fwlen++;
-		remain--;
-	}
-	*pfwlen = fwlen;
-}
-
 static void _rtl92d_write_fw(struct ieee80211_hw *hw,
 			     enum version_8192d version, u8 *buffer, u32 size)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u8 *bufferPtr = buffer;
-	u32 pagenums, remainSize;
+	u8 *bufferptr = buffer;
+	u32 pagenums, remainsize;
 	u32 page, offset;
 
 	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE, "FW size is %d bytes,\n", size);
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192DE)
-		_rtl92d_fill_dummy(bufferPtr, &size);
+		rtl_fill_dummy(bufferptr, &size);
 	pagenums = size / FW_8192D_PAGE_SIZE;
-	remainSize = size % FW_8192D_PAGE_SIZE;
+	remainsize = size % FW_8192D_PAGE_SIZE;
 	if (pagenums > 8)
 		pr_err("Page numbers should not greater then 8\n");
 	for (page = 0; page < pagenums; page++) {
 		offset = page * FW_8192D_PAGE_SIZE;
-		_rtl92d_fw_page_write(hw, page, (bufferPtr + offset),
-				      FW_8192D_PAGE_SIZE);
+		rtl_fw_page_write(hw, page, (bufferptr + offset),
+				  FW_8192D_PAGE_SIZE);
 	}
-	if (remainSize) {
+	if (remainsize) {
 		offset = pagenums * FW_8192D_PAGE_SIZE;
 		page = pagenums;
-		_rtl92d_fw_page_write(hw, page, (bufferPtr + offset),
-				      remainSize);
+		rtl_fw_page_write(hw, page, (bufferptr + offset), remainsize);
 	}
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 78ee6e1..9d7a16c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -27,6 +27,7 @@
 #include "../pci.h"
 #include "../base.h"
 #include "../core.h"
+#include "../efuse.h"
 #include "reg.h"
 #include "def.h"
 #include "fw.h"
@@ -48,64 +49,6 @@ static void _rtl92ee_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 	}
 }
 
-static void _rtl92ee_fw_block_write(struct ieee80211_hw *hw,
-				    const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 blocksize = sizeof(u32);
-	u8 *bufferptr = (u8 *)buffer;
-	u32 *pu4byteptr = (u32 *)buffer;
-	u32 i, offset, blockcount, remainsize;
-
-	blockcount = size / blocksize;
-	remainsize = size % blocksize;
-
-	for (i = 0; i < blockcount; i++) {
-		offset = i * blocksize;
-		rtl_write_dword(rtlpriv, (FW_8192C_START_ADDRESS + offset),
-				*(pu4byteptr + i));
-	}
-
-	if (remainsize) {
-		offset = blockcount * blocksize;
-		bufferptr += offset;
-		for (i = 0; i < remainsize; i++) {
-			rtl_write_byte(rtlpriv,
-				       (FW_8192C_START_ADDRESS + offset + i),
-				       *(bufferptr + i));
-		}
-	}
-}
-
-static void _rtl92ee_fw_page_write(struct ieee80211_hw *hw, u32 page,
-				   const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 value8;
-	u8 u8page = (u8)(page & 0x07);
-
-	value8 = (rtl_read_byte(rtlpriv, REG_MCUFWDL + 2) & 0xF8) | u8page;
-	rtl_write_byte(rtlpriv, (REG_MCUFWDL + 2), value8);
-
-	_rtl92ee_fw_block_write(hw, buffer, size);
-}
-
-static void _rtl92ee_fill_dummy(u8 *pfwbuf, u32 *pfwlen)
-{
-	u32 fwlen = *pfwlen;
-	u8 remain = (u8)(fwlen % 4);
-
-	remain = (remain == 0) ? 0 : (4 - remain);
-
-	while (remain > 0) {
-		pfwbuf[fwlen] = 0;
-		fwlen++;
-		remain--;
-	}
-
-	*pfwlen = fwlen;
-}
-
 static void _rtl92ee_write_fw(struct ieee80211_hw *hw,
 			      enum version_8192e version,
 			      u8 *buffer, u32 size)
@@ -117,7 +60,7 @@ static void _rtl92ee_write_fw(struct ieee80211_hw *hw,
 
 	RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD , "FW size is %d bytes,\n", size);
 
-	_rtl92ee_fill_dummy(bufferptr, &size);
+	rtl_fill_dummy(bufferptr, &size);
 
 	pagenums = size / FW_8192C_PAGE_SIZE;
 	remainsize = size % FW_8192C_PAGE_SIZE;
@@ -127,16 +70,15 @@ static void _rtl92ee_write_fw(struct ieee80211_hw *hw,
 
 	for (page = 0; page < pagenums; page++) {
 		offset = page * FW_8192C_PAGE_SIZE;
-		_rtl92ee_fw_page_write(hw, page, (bufferptr + offset),
-				       FW_8192C_PAGE_SIZE);
+		rtl_fw_page_write(hw, page, (bufferptr + offset),
+				  FW_8192C_PAGE_SIZE);
 		udelay(2);
 	}
 
 	if (remainsize) {
 		offset = pagenums * FW_8192C_PAGE_SIZE;
 		page = pagenums;
-		_rtl92ee_fw_page_write(hw, page, (bufferptr + offset),
-				       remainsize);
+		rtl_fw_page_write(hw, page, (bufferptr + offset), remainsize);
 	}
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
index 8e0d038..ac573d6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
@@ -26,6 +26,7 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../base.h"
+#include "../efuse.h"
 #include "fw_common.h"
 #include <linux/module.h>
 
@@ -53,65 +54,6 @@ void rtl8723_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 }
 EXPORT_SYMBOL_GPL(rtl8723_enable_fw_download);
 
-void rtl8723_fw_block_write(struct ieee80211_hw *hw,
-			    const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 blocksize = sizeof(u32);
-	u8 *bufferptr = (u8 *)buffer;
-	u32 *pu4byteptr = (u32 *)buffer;
-	u32 i, offset, blockcount, remainsize;
-
-	blockcount = size / blocksize;
-	remainsize = size % blocksize;
-
-	for (i = 0; i < blockcount; i++) {
-		offset = i * blocksize;
-		rtl_write_dword(rtlpriv, (FW_8192C_START_ADDRESS + offset),
-				*(pu4byteptr + i));
-	}
-	if (remainsize) {
-		offset = blockcount * blocksize;
-		bufferptr += offset;
-		for (i = 0; i < remainsize; i++) {
-			rtl_write_byte(rtlpriv,
-				       (FW_8192C_START_ADDRESS + offset + i),
-				       *(bufferptr + i));
-		}
-	}
-}
-EXPORT_SYMBOL_GPL(rtl8723_fw_block_write);
-
-void rtl8723_fw_page_write(struct ieee80211_hw *hw,
-			   u32 page, const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 value8;
-	u8 u8page = (u8) (page & 0x07);
-
-	value8 = (rtl_read_byte(rtlpriv, REG_MCUFWDL + 2) & 0xF8) | u8page;
-
-	rtl_write_byte(rtlpriv, (REG_MCUFWDL + 2), value8);
-	rtl8723_fw_block_write(hw, buffer, size);
-}
-EXPORT_SYMBOL_GPL(rtl8723_fw_page_write);
-
-void rtl8723_fill_dummy(u8 *pfwbuf, u32 *pfwlen)
-{
-	u32 fwlen = *pfwlen;
-	u8 remain = (u8) (fwlen % 4);
-
-	remain = (remain == 0) ? 0 : (4 - remain);
-
-	while (remain > 0) {
-		pfwbuf[fwlen] = 0;
-		fwlen++;
-		remain--;
-	}
-	*pfwlen = fwlen;
-}
-EXPORT_SYMBOL(rtl8723_fill_dummy);
-
 void rtl8723_write_fw(struct ieee80211_hw *hw,
 		      enum version_8723e version,
 		      u8 *buffer, u32 size, u8 max_page)
@@ -123,7 +65,7 @@ void rtl8723_write_fw(struct ieee80211_hw *hw,
 
 	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE, "FW size is %d bytes,\n", size);
 
-	rtl8723_fill_dummy(bufferptr, &size);
+	rtl_fill_dummy(bufferptr, &size);
 
 	page_nums = size / FW_8192C_PAGE_SIZE;
 	remain_size = size % FW_8192C_PAGE_SIZE;
@@ -134,15 +76,14 @@ void rtl8723_write_fw(struct ieee80211_hw *hw,
 	}
 	for (page = 0; page < page_nums; page++) {
 		offset = page * FW_8192C_PAGE_SIZE;
-		rtl8723_fw_page_write(hw, page, (bufferptr + offset),
-				      FW_8192C_PAGE_SIZE);
+		rtl_fw_page_write(hw, page, (bufferptr + offset),
+				  FW_8192C_PAGE_SIZE);
 	}
 
 	if (remain_size) {
 		offset = page_nums * FW_8192C_PAGE_SIZE;
 		page = page_nums;
-		rtl8723_fw_page_write(hw, page, (bufferptr + offset),
-				      remain_size);
+		rtl_fw_page_write(hw, page, (bufferptr + offset), remain_size);
 	}
 	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE, "FW write done.\n");
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.h
index 8ea372d..77c25a9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.h
@@ -28,7 +28,6 @@
 
 #define REG_SYS_FUNC_EN				0x0002
 #define REG_MCUFWDL				0x0080
-#define FW_8192C_START_ADDRESS			0x1000
 #define FW_8192C_PAGE_SIZE			4096
 #define FW_8723A_POLLING_TIMEOUT_COUNT		1000
 #define FW_8723B_POLLING_TIMEOUT_COUNT		6000
@@ -84,10 +83,6 @@ enum rtl8723be_cmd {
 void rtl8723ae_firmware_selfreset(struct ieee80211_hw *hw);
 void rtl8723be_firmware_selfreset(struct ieee80211_hw *hw);
 void rtl8723_enable_fw_download(struct ieee80211_hw *hw, bool enable);
-void rtl8723_fw_block_write(struct ieee80211_hw *hw,
-			    const u8 *buffer, u32 size);
-void rtl8723_fw_page_write(struct ieee80211_hw *hw,
-			   u32 page, const u8 *buffer, u32 size);
 void rtl8723_write_fw(struct ieee80211_hw *hw,
 		      enum version_8723e version,
 		      u8 *buffer, u32 size, u8 max_page);
@@ -95,6 +90,5 @@ int rtl8723_fw_free_to_go(struct ieee80211_hw *hw, bool is_8723be, int count);
 int rtl8723_download_fw(struct ieee80211_hw *hw, bool is_8723be, int count);
 bool rtl8723_cmd_send_packet(struct ieee80211_hw *hw,
 			     struct sk_buff *skb);
-void rtl8723_fill_dummy(u8 *pfwbuf, u32 *pfwlen);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index 94e97dc..328c64d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -27,6 +27,7 @@
 #include "../pci.h"
 #include "../base.h"
 #include "../core.h"
+#include "../efuse.h"
 #include "reg.h"
 #include "def.h"
 #include "fw.h"
@@ -51,63 +52,6 @@ static void _rtl8821ae_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 	}
 }
 
-static void _rtl8821ae_fw_block_write(struct ieee80211_hw *hw,
-				      const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 blocksize = sizeof(u32);
-	u8 *bufferptr = (u8 *)buffer;
-	u32 *pu4byteptr = (u32 *)buffer;
-	u32 i, offset, blockcount, remainsize;
-
-	blockcount = size / blocksize;
-	remainsize = size % blocksize;
-
-	for (i = 0; i < blockcount; i++) {
-		offset = i * blocksize;
-		rtl_write_dword(rtlpriv, (FW_8821AE_START_ADDRESS + offset),
-				*(pu4byteptr + i));
-	}
-
-	if (remainsize) {
-		offset = blockcount * blocksize;
-		bufferptr += offset;
-		for (i = 0; i < remainsize; i++) {
-			rtl_write_byte(rtlpriv, (FW_8821AE_START_ADDRESS +
-					offset + i), *(bufferptr + i));
-		}
-	}
-}
-
-static void _rtl8821ae_fw_page_write(struct ieee80211_hw *hw,
-				     u32 page, const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 value8;
-	u8 u8page = (u8)(page & 0x07);
-
-	value8 = (rtl_read_byte(rtlpriv, REG_MCUFWDL + 2) & 0xF8) | u8page;
-
-	rtl_write_byte(rtlpriv, (REG_MCUFWDL + 2), value8);
-	_rtl8821ae_fw_block_write(hw, buffer, size);
-}
-
-static void _rtl8821ae_fill_dummy(u8 *pfwbuf, u32 *pfwlen)
-{
-	u32 fwlen = *pfwlen;
-	u8 remain = (u8)(fwlen % 4);
-
-	remain = (remain == 0) ? 0 : (4 - remain);
-
-	while (remain > 0) {
-		pfwbuf[fwlen] = 0;
-		fwlen++;
-		remain--;
-	}
-
-	*pfwlen = fwlen;
-}
-
 static void _rtl8821ae_write_fw(struct ieee80211_hw *hw,
 				enum version_8821ae version,
 				u8 *buffer, u32 size)
@@ -119,7 +63,7 @@ static void _rtl8821ae_write_fw(struct ieee80211_hw *hw,
 
 	RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD, "FW size is %d bytes,\n", size);
 
-	_rtl8821ae_fill_dummy(bufferptr, &size);
+	rtl_fill_dummy(bufferptr, &size);
 
 	pagenums = size / FW_8821AE_PAGE_SIZE;
 	remainsize = size % FW_8821AE_PAGE_SIZE;
@@ -129,15 +73,14 @@ static void _rtl8821ae_write_fw(struct ieee80211_hw *hw,
 
 	for (page = 0; page < pagenums; page++) {
 		offset = page * FW_8821AE_PAGE_SIZE;
-		_rtl8821ae_fw_page_write(hw, page, (bufferptr + offset),
-					 FW_8821AE_PAGE_SIZE);
+		rtl_fw_page_write(hw, page, (bufferptr + offset),
+				  FW_8821AE_PAGE_SIZE);
 	}
 
 	if (remainsize) {
 		offset = pagenums * FW_8821AE_PAGE_SIZE;
 		page = pagenums;
-		_rtl8821ae_fw_page_write(hw, page, (bufferptr + offset),
-					 remainsize);
+		rtl_fw_page_write(hw, page, (bufferptr + offset), remainsize);
 	}
 }
 
-- 
2.10.2
