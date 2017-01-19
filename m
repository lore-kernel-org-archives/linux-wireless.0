Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:35316 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754649AbdASUf6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 15:35:58 -0500
Received: by mail-ot0-f196.google.com with SMTP id 65so5488105otq.2
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 12:35:57 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH v2 3/3] rtlwifi: rtl8192cu: Convert driver to use common macros
Date: Thu, 19 Jan 2017 14:28:08 -0600
Message-Id: <20170119202808.27752-4-Larry.Finger@lwfinger.net> (sfid-20170119_213601_358024_0C91529B)
In-Reply-To: <20170119202808.27752-1-Larry.Finger@lwfinger.net>
References: <20170119202808.27752-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These drivers use a set of complicated macros to extract and insert
information for the RX and TX descriptors. Driver rtl8192cu had a
different set than was used for the PCI-based drivers. To simplify
the code, rtl8192cu is switched to use the common version. In the
process, two errors in those common macros were found and fixed.

Besides simplifying the code, there is an additional benefit. We have
no BE hardware to test the PCI driver, but using the common macros
provides an additional test for the validity of many endian-sensitive
operations.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
V2 - No functional changes. Merge conflict resolved.
---
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.h   | 272 ++++++++++-----------
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  23 +-
 2 files changed, 132 insertions(+), 163 deletions(-)

Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
@@ -92,129 +92,107 @@ struct rx_drv_info_92c {
 	u8 reserve:4;
 } __packed;
 
-/* Define a macro that takes a le32 word, converts it to host ordering,
- * right shifts by a specified count, creates a mask of the specified
- * bit count, and extracts that number of bits.
- */
-
-#define SHIFT_AND_MASK_LE(__pdesc, __shift, __bits)		\
-	((le32_to_cpu(*(((__le32 *)(__pdesc)))) >> (__shift)) &	\
-	BIT_LEN_MASK_32(__bits))
-
-/* Define a macro that clears a bit field in an le32 word and
- * sets the specified value into that bit field. The resulting
- * value remains in le32 ordering; however, it is properly converted
- * to host ordering for the clear and set operations before conversion
- * back to le32.
- */
-
-#define SET_BITS_OFFSET_LE(__pdesc, __shift, __len, __val)	\
-	(*(__le32 *)(__pdesc) = 				\
-	(cpu_to_le32((le32_to_cpu(*((__le32 *)(__pdesc))) &	\
-	(~(BIT_OFFSET_LEN_MASK_32((__shift), __len)))) |		\
-	(((u32)(__val) & BIT_LEN_MASK_32(__len)) << (__shift)))));
-
 /* macros to read various fields in RX descriptor */
 
 /* DWORD 0 */
 #define GET_RX_DESC_PKT_LEN(__rxdesc)		\
-	SHIFT_AND_MASK_LE((__rxdesc), 0, 14)
+	LE_BITS_TO_4BYTE((__rxdesc), 0, 14)
 #define GET_RX_DESC_CRC32(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 14, 1)
+	LE_BITS_TO_4BYTE(__rxdesc, 14, 1)
 #define GET_RX_DESC_ICV(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 15, 1)
+	LE_BITS_TO_4BYTE(__rxdesc, 15, 1)
 #define GET_RX_DESC_DRVINFO_SIZE(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc, 16, 4)
+	LE_BITS_TO_4BYTE(__rxdesc, 16, 4)
 #define GET_RX_DESC_SECURITY(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 20, 3)
+	LE_BITS_TO_4BYTE(__rxdesc, 20, 3)
 #define GET_RX_DESC_QOS(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 23, 1)
+	LE_BITS_TO_4BYTE(__rxdesc, 23, 1)
 #define GET_RX_DESC_SHIFT(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 24, 2)
+	LE_BITS_TO_4BYTE(__rxdesc, 24, 2)
 #define GET_RX_DESC_PHY_STATUS(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc, 26, 1)
+	LE_BITS_TO_4BYTE(__rxdesc, 26, 1)
 #define GET_RX_DESC_SWDEC(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 27, 1)
+	LE_BITS_TO_4BYTE(__rxdesc, 27, 1)
 #define GET_RX_DESC_LAST_SEG(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 28, 1)
+	LE_BITS_TO_4BYTE(__rxdesc, 28, 1)
 #define GET_RX_DESC_FIRST_SEG(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 29, 1)
+	LE_BITS_TO_4BYTE(__rxdesc, 29, 1)
 #define GET_RX_DESC_EOR(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 30, 1)
+	LE_BITS_TO_4BYTE(__rxdesc, 30, 1)
 #define GET_RX_DESC_OWN(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc, 31, 1)
+	LE_BITS_TO_4BYTE(__rxdesc, 31, 1)
 
 /* DWORD 1 */
 #define GET_RX_DESC_MACID(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 0, 5)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 0, 5)
 #define GET_RX_DESC_TID(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 5, 4)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 5, 4)
 #define GET_RX_DESC_PAGGR(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 14, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 14, 1)
 #define GET_RX_DESC_FAGGR(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 15, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 15, 1)
 #define GET_RX_DESC_A1_FIT(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 16, 4)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 16, 4)
 #define GET_RX_DESC_A2_FIT(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 20, 4)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 20, 4)
 #define GET_RX_DESC_PAM(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 24, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 24, 1)
 #define GET_RX_DESC_PWR(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 25, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 25, 1)
 #define GET_RX_DESC_MORE_DATA(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 26, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 26, 1)
 #define GET_RX_DESC_MORE_FRAG(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 27, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 27, 1)
 #define GET_RX_DESC_TYPE(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 28, 2)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 28, 2)
 #define GET_RX_DESC_MC(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 30, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 30, 1)
 #define GET_RX_DESC_BC(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+4, 31, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 4, 31, 1)
 
 /* DWORD 2 */
 #define GET_RX_DESC_SEQ(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+8, 0, 12)
+	LE_BITS_TO_4BYTE(__rxdesc + 8, 0, 12)
 #define GET_RX_DESC_FRAG(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+8, 12, 4)
+	LE_BITS_TO_4BYTE(__rxdesc + 8, 12, 4)
 #define GET_RX_DESC_USB_AGG_PKTNUM(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc+8, 16, 8)
+	LE_BITS_TO_4BYTE(__rxdesc + 8, 16, 8)
 #define GET_RX_DESC_NEXT_IND(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+8, 30, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 8, 30, 1)
 
 /* DWORD 3 */
 #define GET_RX_DESC_RX_MCS(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 0, 6)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 0, 6)
 #define GET_RX_DESC_RX_HT(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 6, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 6, 1)
 #define GET_RX_DESC_AMSDU(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 7, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 7, 1)
 #define GET_RX_DESC_SPLCP(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 8, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 8, 1)
 #define GET_RX_DESC_BW(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 9, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 9, 1)
 #define GET_RX_DESC_HTC(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 10, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 10, 1)
 #define GET_RX_DESC_TCP_CHK_RPT(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 11, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 11, 1)
 #define GET_RX_DESC_IP_CHK_RPT(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 12, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 12, 1)
 #define GET_RX_DESC_TCP_CHK_VALID(__rxdesc)	\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 13, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 13, 1)
 #define GET_RX_DESC_HWPC_ERR(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 14, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 14, 1)
 #define GET_RX_DESC_HWPC_IND(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 15, 1)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 15, 1)
 #define GET_RX_DESC_IV0(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+12, 16, 16)
+	LE_BITS_TO_4BYTE(__rxdesc + 12, 16, 16)
 
 /* DWORD 4 */
 #define GET_RX_DESC_IV1(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+16, 0, 32)
+	LE_BITS_TO_4BYTE(__rxdesc + 16, 0, 32)
 
 /* DWORD 5 */
 #define GET_RX_DESC_TSFL(__rxdesc)		\
-	SHIFT_AND_MASK_LE(__rxdesc+20, 0, 32)
+	LE_BITS_TO_4BYTE(__rxdesc + 20, 0, 32)
 
 /*======================= tx desc ============================================*/
 
@@ -222,182 +200,182 @@ struct rx_drv_info_92c {
 
 /* Dword 0 */
 #define SET_TX_DESC_PKT_SIZE(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 0, 16, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc, 0, 16, __value)
 #define SET_TX_DESC_OFFSET(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 16, 8, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc, 16, 8, __value)
 #define SET_TX_DESC_BMC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 24, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc, 24, 1, __value)
 #define SET_TX_DESC_HTC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 25, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc, 25, 1, __value)
 #define SET_TX_DESC_LAST_SEG(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 26, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc, 26, 1, __value)
 #define SET_TX_DESC_FIRST_SEG(__txdesc, __value)	\
-	 SET_BITS_OFFSET_LE(__txdesc, 27, 1, __value)
+	 SET_BITS_TO_LE_4BYTE(__txdesc, 27, 1, __value)
 #define SET_TX_DESC_LINIP(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 28, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc, 28, 1, __value)
 #define SET_TX_DESC_NO_ACM(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 29, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc, 29, 1, __value)
 #define SET_TX_DESC_GF(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 30, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc, 30, 1, __value)
 #define SET_TX_DESC_OWN(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc, 31, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc, 31, 1, __value)
 
 
 /* Dword 1 */
 #define SET_TX_DESC_MACID(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+4, 0, 5, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 0, 5, __value)
 #define SET_TX_DESC_AGG_ENABLE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 5, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 5, 1, __value)
 #define SET_TX_DESC_AGG_BREAK(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 6, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 6, 1, __value)
 #define SET_TX_DESC_RDG_ENABLE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 7, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 7, 1, __value)
 #define SET_TX_DESC_QUEUE_SEL(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 8, 5, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 8, 5, __value)
 #define SET_TX_DESC_RDG_NAV_EXT(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 13, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 13, 1, __value)
 #define SET_TX_DESC_LSIG_TXOP_EN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 14, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 14, 1, __value)
 #define SET_TX_DESC_PIFS(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+4, 15, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 15, 1, __value)
 #define SET_TX_DESC_RATE_ID(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+4, 16, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 16, 4, __value)
 #define SET_TX_DESC_RA_BRSR_ID(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 16, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 16, 4, __value)
 #define SET_TX_DESC_NAV_USE_HDR(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 20, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 20, 1, __value)
 #define SET_TX_DESC_EN_DESC_ID(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 21, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 21, 1, __value)
 #define SET_TX_DESC_SEC_TYPE(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+4, 22, 2, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 22, 2, __value)
 #define SET_TX_DESC_PKT_OFFSET(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+4, 26, 5, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 26, 5, __value)
 
 /* Dword 2 */
 #define SET_TX_DESC_RTS_RC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 0, 6, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 0, 6, __value)
 #define SET_TX_DESC_DATA_RC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 6, 6, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 6, 6, __value)
 #define SET_TX_DESC_BAR_RTY_TH(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+8, 14, 2, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 14, 2, __value)
 #define SET_TX_DESC_MORE_FRAG(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+8, 17, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 17, 1, __value)
 #define SET_TX_DESC_RAW(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 18, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 18, 1, __value)
 #define SET_TX_DESC_CCX(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 19, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 19, 1, __value)
 #define SET_TX_DESC_AMPDU_DENSITY(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+8, 20, 3, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 20, 3, __value)
 #define SET_TX_DESC_ANTSEL_A(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 24, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 24, 1, __value)
 #define SET_TX_DESC_ANTSEL_B(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 25, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 25, 1, __value)
 #define SET_TX_DESC_TX_ANT_CCK(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+8, 26, 2, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 26, 2, __value)
 #define SET_TX_DESC_TX_ANTL(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+8, 28, 2, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 28, 2, __value)
 #define SET_TX_DESC_TX_ANT_HT(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+8, 30, 2, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 8, 30, 2, __value)
 
 /* Dword 3 */
 #define SET_TX_DESC_NEXT_HEAP_PAGE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+12, 0, 8, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 12, 0, 8, __value)
 #define SET_TX_DESC_TAIL_PAGE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+12, 8, 8, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 12, 8, 8, __value)
 #define SET_TX_DESC_SEQ(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+12, 16, 12, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 12, 16, 12, __value)
 #define SET_TX_DESC_PKT_ID(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+12, 28, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 12, 28, 4, __value)
 
 /* Dword 4 */
 #define SET_TX_DESC_RTS_RATE(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 0, 5, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 0, 5, __value)
 #define SET_TX_DESC_AP_DCFE(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 5, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 5, 1, __value)
 #define SET_TX_DESC_QOS(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 6, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 6, 1, __value)
 #define SET_TX_DESC_HWSEQ_EN(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 7, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 7, 1, __value)
 #define SET_TX_DESC_USE_RATE(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 8, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 8, 1, __value)
 #define SET_TX_DESC_DISABLE_RTS_FB(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 9, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 9, 1, __value)
 #define SET_TX_DESC_DISABLE_FB(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 10, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 10, 1, __value)
 #define SET_TX_DESC_CTS2SELF(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 11, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 11, 1, __value)
 #define SET_TX_DESC_RTS_ENABLE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 12, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 12, 1, __value)
 #define SET_TX_DESC_HW_RTS_ENABLE(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 13, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 13, 1, __value)
 #define SET_TX_DESC_WAIT_DCTS(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 18, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 18, 1, __value)
 #define SET_TX_DESC_CTS2AP_EN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 19, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 19, 1, __value)
 #define SET_TX_DESC_DATA_SC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 20, 2, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 20, 2, __value)
 #define SET_TX_DESC_DATA_STBC(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 22, 2, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 22, 2, __value)
 #define SET_TX_DESC_DATA_SHORT(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 24, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 24, 1, __value)
 #define SET_TX_DESC_DATA_BW(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 25, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 25, 1, __value)
 #define SET_TX_DESC_RTS_SHORT(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+16, 26, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 26, 1, __value)
 #define SET_TX_DESC_RTS_BW(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 27, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 27, 1, __value)
 #define SET_TX_DESC_RTS_SC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 28, 2, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 28, 2, __value)
 #define SET_TX_DESC_RTS_STBC(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+16, 30, 2, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 16, 30, 2, __value)
 
 /* Dword 5 */
 #define SET_TX_DESC_TX_RATE(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc+20, 0, 6, __val)
+	SET_BITS_TO_LE_4BYTE(__pdesc + 20, 0, 6, __val)
 #define SET_TX_DESC_DATA_SHORTGI(__pdesc, __val)	\
-	SET_BITS_OFFSET_LE(__pdesc+20, 6, 1, __val)
+	SET_BITS_TO_LE_4BYTE(__pdesc + 20, 6, 1, __val)
 #define SET_TX_DESC_CCX_TAG(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc+20, 7, 1, __val)
+	SET_BITS_TO_LE_4BYTE(__pdesc + 20, 7, 1, __val)
 #define SET_TX_DESC_DATA_RATE_FB_LIMIT(__txdesc, __value) \
-	SET_BITS_OFFSET_LE(__txdesc+20, 8, 5, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 20, 8, 5, __value)
 #define SET_TX_DESC_RTS_RATE_FB_LIMIT(__txdesc, __value) \
-	SET_BITS_OFFSET_LE(__txdesc+20, 13, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 20, 13, 4, __value)
 #define SET_TX_DESC_RETRY_LIMIT_ENABLE(__txdesc, __value) \
-	SET_BITS_OFFSET_LE(__txdesc+20, 17, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 20, 17, 1, __value)
 #define SET_TX_DESC_DATA_RETRY_LIMIT(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+20, 18, 6, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 20, 18, 6, __value)
 #define SET_TX_DESC_USB_TXAGG_NUM(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+20, 24, 8, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 20, 24, 8, __value)
 
 /* Dword 6 */
 #define SET_TX_DESC_TXAGC_A(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+24, 0, 5, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 24, 0, 5, __value)
 #define SET_TX_DESC_TXAGC_B(__txdesc, __value)		\
-	SET_BITS_OFFSET_LE(__txdesc+24, 5, 5, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 24, 5, 5, __value)
 #define SET_TX_DESC_USB_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 10, 1, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 24, 10, 1, __value)
 #define SET_TX_DESC_MAX_AGG_NUM(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 11, 5, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 24, 11, 5, __value)
 #define SET_TX_DESC_MCSG1_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 16, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 24, 16, 4, __value)
 #define SET_TX_DESC_MCSG2_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 20, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 24, 20, 4, __value)
 #define SET_TX_DESC_MCSG3_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 24, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 24, 24, 4, __value)
 #define SET_TX_DESC_MCSG7_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+24, 28, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 24, 28, 4, __value)
 
 /* Dword 7 */
 #define SET_TX_DESC_TX_DESC_CHECKSUM(__txdesc, __value) \
-	SET_BITS_OFFSET_LE(__txdesc+28, 0, 16, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 28, 0, 16, __value)
 #define SET_TX_DESC_MCSG4_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+28, 16, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 28, 16, 4, __value)
 #define SET_TX_DESC_MCSG5_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+28, 20, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 28, 20, 4, __value)
 #define SET_TX_DESC_MCSG6_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+28, 24, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 28, 24, 4, __value)
 #define SET_TX_DESC_MCSG15_MAX_LEN(__txdesc, __value)	\
-	SET_BITS_OFFSET_LE(__txdesc+28, 28, 4, __value)
+	SET_BITS_TO_LE_4BYTE(__txdesc + 28, 28, 4, __value)
 
 
 int  rtl8192cu_endpoint_mapping(struct ieee80211_hw *hw);
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/wifi.h
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2704,23 +2704,14 @@ enum bt_radio_shared {
 	(le32_to_cpu(_val))
 
 /* Read data from memory */
-#define READEF1BYTE(_ptr)	\
+#define READEF1BYTE(_ptr)      \
 	EF1BYTE(*((u8 *)(_ptr)))
 /* Read le16 data from memory and convert to host ordering */
-#define READEF2BYTE(_ptr)	\
+#define READEF2BYTE(_ptr)      \
 	EF2BYTE(*(_ptr))
-#define READEF4BYTE(_ptr)	\
+#define READEF4BYTE(_ptr)      \
 	EF4BYTE(*(_ptr))
 
-/* Write data to memory */
-#define WRITEEF1BYTE(_ptr, _val)	\
-	(*((u8 *)(_ptr))) = EF1BYTE(_val)
-/* Write le16 data to memory in host ordering */
-#define WRITEEF2BYTE(_ptr, _val)	\
-	(*((u16 *)(_ptr))) = EF2BYTE(_val)
-#define WRITEEF4BYTE(_ptr, _val)	\
-	(*((u32 *)(_ptr))) = EF2BYTE(_val)
-
 /* Create a bit mask
  * Examples:
  * BIT_LEN_MASK_32(0) => 0x00000000
@@ -2801,14 +2792,14 @@ value to host byte ordering.*/
  * Set subfield of little-endian 4-byte value to specified value.
  */
 #define SET_BITS_TO_LE_4BYTE(__pstart, __bitoffset, __bitlen, __val) \
-	*((u32 *)(__pstart)) = \
-	( \
+	*((__le32 *)(__pstart)) = \
+	cpu_to_le32( \
 		LE_BITS_CLEARED_TO_4BYTE(__pstart, __bitoffset, __bitlen) | \
 		((((u32)__val) & BIT_LEN_MASK_32(__bitlen)) << (__bitoffset)) \
 	);
 #define SET_BITS_TO_LE_2BYTE(__pstart, __bitoffset, __bitlen, __val) \
-	*((u16 *)(__pstart)) = \
-	( \
+	*((__le16 *)(__pstart)) = \
+	cpu_to_le16( \
 		LE_BITS_CLEARED_TO_2BYTE(__pstart, __bitoffset, __bitlen) | \
 		((((u16)__val) & BIT_LEN_MASK_16(__bitlen)) << (__bitoffset)) \
 	);
