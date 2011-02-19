Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1BSWaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 17:30:04 -0500
Date: Sat, 19 Feb 2011 16:30:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 16/16] rtlwifi: Remove obsolete/unused macros
Message-ID: <4d60446a.m3FrhbEuMzXzp6iz%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original code has many macros that are no longer needed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.h
@@ -53,46 +53,22 @@
 #define FRAME_OFFSET_SEQUENCE		22
 #define FRAME_OFFSET_ADDRESS4		24
 
-#define SET_80211_HDR_FRAME_CONTROL(_hdr, _val)		\
-	WRITEEF2BYTE(_hdr, _val)
-#define SET_80211_HDR_TYPE_AND_SUBTYPE(_hdr, _val)	\
-	WRITEEF1BYTE(_hdr, _val)
-#define SET_80211_HDR_PWR_MGNT(_hdr, _val)		\
-	SET_BITS_TO_LE_2BYTE(_hdr, 12, 1, _val)
-#define SET_80211_HDR_TO_DS(_hdr, _val)			\
-	SET_BITS_TO_LE_2BYTE(_hdr, 8, 1, _val)
 
 #define SET_80211_PS_POLL_AID(_hdr, _val)		\
-	WRITEEF2BYTE(((u8 *)(_hdr)) + 2, _val)
+	(*(u16 *)((u8 *)(_hdr) + 2) = le16_to_cpu(_val))
 #define SET_80211_PS_POLL_BSSID(_hdr, _val)		\
-	CP_MACADDR(((u8 *)(_hdr)) + 4, (u8 *)(_val))
+	memcpy(((u8 *)(_hdr)) + 4, (u8 *)(_val), ETH_ALEN)
 #define SET_80211_PS_POLL_TA(_hdr, _val)		\
-	CP_MACADDR(((u8 *)(_hdr)) + 10, (u8 *)(_val))
+	memcpy(((u8 *)(_hdr)) + 10, (u8 *)(_val), ETH_ALEN)
 
 #define SET_80211_HDR_DURATION(_hdr, _val)	\
-	WRITEEF2BYTE((u8 *)(_hdr)+FRAME_OFFSET_DURATION, _val)
+	(*(u16 *)((u8 *)(_hdr) + FRAME_OFFSET_DURATION) = le16_to_cpu(_val))
 #define SET_80211_HDR_ADDRESS1(_hdr, _val)	\
-	CP_MACADDR((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS1, (u8*)(_val))
+	memcpy((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS1, (u8*)(_val), ETH_ALEN)
 #define SET_80211_HDR_ADDRESS2(_hdr, _val)	\
-	CP_MACADDR((u8 *)(_hdr) + FRAME_OFFSET_ADDRESS2, (u8 *)(_val))
+	memcpy((u8 *)(_hdr) + FRAME_OFFSET_ADDRESS2, (u8 *)(_val), ETH_ALEN)
 #define SET_80211_HDR_ADDRESS3(_hdr, _val)	\
-	CP_MACADDR((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS3, (u8 *)(_val))
-#define SET_80211_HDR_FRAGMENT_SEQUENCE(_hdr, _val)  \
-	WRITEEF2BYTE((u8 *)(_hdr)+FRAME_OFFSET_SEQUENCE, _val)
-
-#define SET_BEACON_PROBE_RSP_TIME_STAMP_LOW(__phdr, __val)	\
-	WRITEEF4BYTE(((u8 *)(__phdr)) + 24, __val)
-#define SET_BEACON_PROBE_RSP_TIME_STAMP_HIGH(__phdr, __val) \
-	WRITEEF4BYTE(((u8 *)(__phdr)) + 28, __val)
-#define SET_BEACON_PROBE_RSP_BEACON_INTERVAL(__phdr, __val) \
-	WRITEEF2BYTE(((u8 *)(__phdr)) + 32, __val)
-#define GET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr)	\
-	READEF2BYTE(((u8 *)(__phdr)) + 34)
-#define SET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr, __val) \
-	WRITEEF2BYTE(((u8 *)(__phdr)) + 34, __val)
-#define MASK_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr, __val) \
-	SET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr, \
-	(GET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr) & (~(__val))))
+	memcpy((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS3, (u8 *)(_val), ETH_ALEN)
 
 int rtl_init_core(struct ieee80211_hw *hw);
 void rtl_deinit_core(struct ieee80211_hw *hw);
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1632,7 +1632,7 @@ struct bt_coexist_info {
 	2. Before write integer to IO.
 	3. After read integer from IO.
 ****************************************/
-/* Convert little data endian to host */
+/* Convert little data endian to host ordering */
 #define EF1BYTE(_val)		\
 	((u8)(_val))
 #define EF2BYTE(_val)		\
@@ -1640,27 +1640,21 @@ struct bt_coexist_info {
 #define EF4BYTE(_val)		\
 	(le32_to_cpu(_val))
 
-/* Read data from memory */
-#define READEF1BYTE(_ptr)	\
-	EF1BYTE(*((u8 *)(_ptr)))
+/* Read le16 data from memory and convert to host ordering */
 #define READEF2BYTE(_ptr)	\
 	EF2BYTE(*((u16 *)(_ptr)))
-#define READEF4BYTE(_ptr)	\
-	EF4BYTE(*((__le32 *)(_ptr)))
 
-/* Write data to memory */
-#define WRITEEF1BYTE(_ptr, _val)	\
-	(*((u8 *)(_ptr))) = EF1BYTE(_val)
+/* Write le16 data to memory in host ordering */
 #define WRITEEF2BYTE(_ptr, _val)	\
 	(*((u16 *)(_ptr))) = EF2BYTE(_val)
-#define WRITEEF4BYTE(_ptr, _val)	\
-	(*((u32 *)(_ptr))) = EF4BYTE(_val)
 
-/*Example:
-BIT_LEN_MASK_32(0) => 0x00000000
-BIT_LEN_MASK_32(1) => 0x00000001
-BIT_LEN_MASK_32(2) => 0x00000003
-BIT_LEN_MASK_32(32) => 0xFFFFFFFF*/
+/* Create a bit mask
+ * Examples:
+ * BIT_LEN_MASK_32(0) => 0x00000000
+ * BIT_LEN_MASK_32(1) => 0x00000001
+ * BIT_LEN_MASK_32(2) => 0x00000003
+ * BIT_LEN_MASK_32(32) => 0xFFFFFFFF
+ */
 #define BIT_LEN_MASK_32(__bitlen)	 \
 	(0xFFFFFFFF >> (32 - (__bitlen)))
 #define BIT_LEN_MASK_16(__bitlen)	 \
@@ -1668,9 +1662,11 @@ BIT_LEN_MASK_32(32) => 0xFFFFFFFF*/
 #define BIT_LEN_MASK_8(__bitlen) \
 	(0xFF >> (8 - (__bitlen)))
 
-/*Example:
-BIT_OFFSET_LEN_MASK_32(0, 2) => 0x00000003
-BIT_OFFSET_LEN_MASK_32(16, 2) => 0x00030000*/
+/* Create an offset bit mask
+ * Examples:
+ * BIT_OFFSET_LEN_MASK_32(0, 2) => 0x00000003
+ * BIT_OFFSET_LEN_MASK_32(16, 2) => 0x00030000
+ */
 #define BIT_OFFSET_LEN_MASK_32(__bitoffset, __bitlen) \
 	(BIT_LEN_MASK_32(__bitlen) << (__bitoffset))
 #define BIT_OFFSET_LEN_MASK_16(__bitoffset, __bitlen) \
@@ -1679,8 +1675,9 @@ BIT_OFFSET_LEN_MASK_32(16, 2) => 0x00030
 	(BIT_LEN_MASK_8(__bitlen) << (__bitoffset))
 
 /*Description:
-Return 4-byte value in host byte ordering from
-4-byte pointer in little-endian system.*/
+ * Return 4-byte value in host byte ordering from
+ * 4-byte pointer in little-endian system.
+ */
 #define LE_P4BYTE_TO_HOST_4BYTE(__pstart) \
 	(EF4BYTE(*((u32 *)(__pstart))))
 #define LE_P2BYTE_TO_HOST_2BYTE(__pstart) \
@@ -1688,28 +1685,10 @@ Return 4-byte value in host byte orderin
 #define LE_P1BYTE_TO_HOST_1BYTE(__pstart) \
 	(EF1BYTE(*((u8 *)(__pstart))))
 
-/*Description:
-Translate subfield (continuous bits in little-endian) of 4-byte
-value to host byte ordering.*/
-#define LE_BITS_TO_4BYTE(__pstart, __bitoffset, __bitlen) \
-	( \
-		(LE_P4BYTE_TO_HOST_4BYTE(__pstart) >> (__bitoffset))  & \
-		BIT_LEN_MASK_32(__bitlen) \
-	)
-#define LE_BITS_TO_2BYTE(__pstart, __bitoffset, __bitlen) \
-	( \
-		(LE_P2BYTE_TO_HOST_2BYTE(__pstart) >> (__bitoffset)) & \
-		BIT_LEN_MASK_16(__bitlen) \
-	)
-#define LE_BITS_TO_1BYTE(__pstart, __bitoffset, __bitlen) \
-	( \
-		(LE_P1BYTE_TO_HOST_1BYTE(__pstart) >> (__bitoffset)) & \
-		BIT_LEN_MASK_8(__bitlen) \
-	)
-
-/*Description:
-Mask subfield (continuous bits in little-endian) of 4-byte value
-and return the result in 4-byte value in host byte ordering.*/
+/* Description:
+ * Mask subfield (continuous bits in little-endian) of 4-byte value
+ * and return the result in 4-byte value in host byte ordering.
+ */
 #define LE_BITS_CLEARED_TO_4BYTE(__pstart, __bitoffset, __bitlen) \
 	( \
 		LE_P4BYTE_TO_HOST_4BYTE(__pstart)  & \
@@ -1726,20 +1705,9 @@ and return the result in 4-byte value in
 		(~BIT_OFFSET_LEN_MASK_8(__bitoffset, __bitlen)) \
 	)
 
-/*Description:
-Set subfield of little-endian 4-byte value to specified value.	*/
-#define SET_BITS_TO_LE_4BYTE(__pstart, __bitoffset, __bitlen, __val) \
-	*((u32 *)(__pstart)) = EF4BYTE \
-	( \
-		LE_BITS_CLEARED_TO_4BYTE(__pstart, __bitoffset, __bitlen) | \
-		((((u32)__val) & BIT_LEN_MASK_32(__bitlen)) << (__bitoffset)) \
-	);
-#define SET_BITS_TO_LE_2BYTE(__pstart, __bitoffset, __bitlen, __val) \
-	*((u16 *)(__pstart)) = EF2BYTE \
-	( \
-		LE_BITS_CLEARED_TO_2BYTE(__pstart, __bitoffset, __bitlen) | \
-		((((u16)__val) & BIT_LEN_MASK_16(__bitlen)) << (__bitoffset)) \
-	);
+/* Description:
+ * Set subfield of little-endian 4-byte value to specified value.
+ */
 #define SET_BITS_TO_LE_1BYTE(__pstart, __bitoffset, __bitlen, __val) \
 	*((u8 *)(__pstart)) = EF1BYTE \
 	( \
@@ -1747,16 +1715,12 @@ Set subfield of little-endian 4-byte val
 		((((u8)__val) & BIT_LEN_MASK_8(__bitlen)) << (__bitoffset)) \
 	);
 
-#define	N_BYTE_ALIGMENT(__value, __aligment) ((__aligment == 1) ? \
-	(__value) : (((__value + __aligment - 1) / __aligment) * __aligment))
-
 /****************************************
 	mem access macro define end
 ****************************************/
 
 #define byte(x, n) ((x >> (8 * n)) & 0xff)
 
-#define packet_get_type(_packet) (EF1BYTE((_packet).octet[0]) & 0xFC)
 #define RTL_WATCH_DOG_TIME	2000
 #define MSECS(t)		msecs_to_jiffies(t)
 #define WLAN_FC_GET_VERS(fc)	(le16_to_cpu(fc) & IEEE80211_FCTL_VERS)
@@ -1791,15 +1755,6 @@ Set subfield of little-endian 4-byte val
 #define container_of_dwork_rtl(x, y, z) \
 	container_of(container_of(x, struct delayed_work, work), y, z)
 
-#define FILL_OCTET_STRING(_os, _octet, _len)	\
-	do {					\
-		(_os). octet = (u8 *)(_octet);		\
-		(_os). length = (_len);		\
-	} while (0);
-
-#define CP_MACADDR(des, src)		\
-	memcpy((des), (src), ETH_ALEN)
-
 static inline u8 rtl_read_byte(struct rtl_priv *rtlpriv, u32 addr)
 {
 	return rtlpriv->io.read8_sync(rtlpriv, addr);
