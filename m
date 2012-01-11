Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64914 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab2AKXHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 18:07:42 -0500
Received: by mail-iy0-f174.google.com with SMTP id z25so1744774iab.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 15:07:42 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] rtl8192se: Convert driver to use the new macro file
Date: Wed, 11 Jan 2012 17:07:12 -0600
Message-Id: <1326323232-21752-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120112_000746_856948_D0653579)
In-Reply-To: <1326323232-21752-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1326323232-21752-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch switches rtl8192se to use the new macros file.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192se/def.h |  406 +-------------------------
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |  121 ++++----
 2 files changed, 67 insertions(+), 460 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/def.h b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
index d1b0a1e..3a3a3d9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
@@ -29,6 +29,8 @@
 #ifndef __REALTEK_92S_DEF_H__
 #define __REALTEK_92S_DEF_H__
 
+#include "../macros.h"
+
 #define RX_MPDU_QUEUE				0
 #define RX_CMD_QUEUE				1
 #define RX_MAX_QUEUE				2
@@ -57,413 +59,17 @@
 #define TX_DESC_SIZE_RTL8192S			(16 * 4)
 #define TX_CMDDESC_SIZE_RTL8192S		(16 * 4)
 
-/* Define a macro that takes a le32 word, converts it to host ordering,
- * right shifts by a specified count, creates a mask of the specified
- * bit count, and extracts that number of bits.
- */
-
-#define SHIFT_AND_MASK_LE(__pdesc, __shift, __mask)		\
-	((le32_to_cpu(*(((__le32 *)(__pdesc)))) >> (__shift)) &	\
-	BIT_LEN_MASK_32(__mask))
-
-/* Define a macro that clears a bit field in an le32 word and
- * sets the specified value into that bit field. The resulting
- * value remains in le32 ordering; however, it is properly converted
- * to host ordering for the clear and set operations before conversion
- * back to le32.
- */
-
-#define SET_BITS_OFFSET_LE(__pdesc, __shift, __len, __val)	\
-	(*(__le32 *)(__pdesc) =					\
-	(cpu_to_le32((le32_to_cpu(*((__le32 *)(__pdesc))) &	\
-	(~(BIT_OFFSET_LEN_MASK_32((__shift), __len)))) |	\
-	(((u32)(__val) & BIT_LEN_MASK_32(__len)) << (__shift)))));
-
-/* macros to read/write various fields in RX or TX descriptors */
-
-/* Dword 0 */
-#define SET_TX_DESC_PKT_SIZE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 0, 16, __val)
-#define SET_TX_DESC_OFFSET(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 16, 8, __val)
-#define SET_TX_DESC_TYPE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 24, 2, __val)
-#define SET_TX_DESC_LAST_SEG(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 26, 1, __val)
-#define SET_TX_DESC_FIRST_SEG(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 27, 1, __val)
-#define SET_TX_DESC_LINIP(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 28, 1, __val)
-#define SET_TX_DESC_AMSDU(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 29, 1, __val)
-#define SET_TX_DESC_GREEN_FIELD(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 30, 1, __val)
-#define SET_TX_DESC_OWN(__pdesc, __val)				\
-	SET_BITS_OFFSET_LE(__pdesc, 31, 1, __val)
-
-#define GET_TX_DESC_OWN(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc, 31, 1)
-
-/* Dword 1 */
-#define SET_TX_DESC_MACID(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 0, 5, __val)
-#define SET_TX_DESC_MORE_DATA(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 5, 1, __val)
-#define SET_TX_DESC_MORE_FRAG(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 6, 1, __val)
-#define SET_TX_DESC_PIFS(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 7, 1, __val)
-#define SET_TX_DESC_QUEUE_SEL(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 8, 5, __val)
-#define SET_TX_DESC_ACK_POLICY(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 13, 2, __val)
-#define SET_TX_DESC_NO_ACM(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 15, 1, __val)
-#define SET_TX_DESC_NON_QOS(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 16, 1, __val)
-#define SET_TX_DESC_KEY_ID(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 17, 2, __val)
-#define SET_TX_DESC_OUI(__pdesc, __val)				\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 19, 1, __val)
-#define SET_TX_DESC_PKT_TYPE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 20, 1, __val)
-#define SET_TX_DESC_EN_DESC_ID(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 21, 1, __val)
-#define SET_TX_DESC_SEC_TYPE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 22, 2, __val)
-#define SET_TX_DESC_WDS(__pdesc, __val)				\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 24, 1, __val)
-#define SET_TX_DESC_HTC(__pdesc, __val)				\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 25, 1, __val)
-#define SET_TX_DESC_PKT_OFFSET(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 26, 5, __val)
-#define SET_TX_DESC_HWPC(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 27, 1, __val)
-
-/* Dword 2 */
-#define SET_TX_DESC_DATA_RETRY_LIMIT(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 0, 6, __val)
-#define SET_TX_DESC_RETRY_LIMIT_ENABLE(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 6, 1, __val)
-#define SET_TX_DESC_TSFL(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 7, 5, __val)
-#define SET_TX_DESC_RTS_RETRY_COUNT(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 12, 6, __val)
-#define SET_TX_DESC_DATA_RETRY_COUNT(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 18, 6, __val)
-#define	SET_TX_DESC_RSVD_MACID(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(((__pdesc) + 8), 24, 5, __val)
-#define SET_TX_DESC_AGG_ENABLE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 29, 1, __val)
-#define SET_TX_DESC_AGG_BREAK(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 30, 1, __val)
-#define SET_TX_DESC_OWN_MAC(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 31, 1, __val)
-
-/* Dword 3 */
-#define SET_TX_DESC_NEXT_HEAP_PAGE(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 0, 8, __val)
-#define SET_TX_DESC_TAIL_PAGE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 8, 8, __val)
-#define SET_TX_DESC_SEQ(__pdesc, __val)				\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 16, 12, __val)
-#define SET_TX_DESC_FRAG(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 28, 4, __val)
-
-/* Dword 4 */
-#define SET_TX_DESC_RTS_RATE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 0, 6, __val)
-#define SET_TX_DESC_DISABLE_RTS_FB(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 6, 1, __val)
-#define SET_TX_DESC_RTS_RATE_FB_LIMIT(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 7, 4, __val)
-#define SET_TX_DESC_CTS_ENABLE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 11, 1, __val)
-#define SET_TX_DESC_RTS_ENABLE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 12, 1, __val)
-#define SET_TX_DESC_RA_BRSR_ID(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 13, 3, __val)
-#define SET_TX_DESC_TXHT(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 16, 1, __val)
-#define SET_TX_DESC_TX_SHORT(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 17, 1, __val)
-#define SET_TX_DESC_TX_BANDWIDTH(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 18, 1, __val)
-#define SET_TX_DESC_TX_SUB_CARRIER(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 19, 2, __val)
-#define SET_TX_DESC_TX_STBC(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 21, 2, __val)
-#define SET_TX_DESC_TX_REVERSE_DIRECTION(__pdesc, __val)	\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 23, 1, __val)
-#define SET_TX_DESC_RTS_HT(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 24, 1, __val)
-#define SET_TX_DESC_RTS_SHORT(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 25, 1, __val)
-#define SET_TX_DESC_RTS_BANDWIDTH(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 26, 1, __val)
-#define SET_TX_DESC_RTS_SUB_CARRIER(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 27, 2, __val)
-#define SET_TX_DESC_RTS_STBC(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 29, 2, __val)
-#define SET_TX_DESC_USER_RATE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 31, 1, __val)
-
-/* Dword 5 */
-#define SET_TX_DESC_PACKET_ID(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 20, 0, 9, __val)
-#define SET_TX_DESC_TX_RATE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 20, 9, 6, __val)
-#define SET_TX_DESC_DISABLE_FB(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 20, 15, 1, __val)
-#define SET_TX_DESC_DATA_RATE_FB_LIMIT(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 20, 16, 5, __val)
-#define SET_TX_DESC_TX_AGC(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 20, 21, 11, __val)
-
-/* Dword 6 */
-#define SET_TX_DESC_IP_CHECK_SUM(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 24, 0, 16, __val)
-#define SET_TX_DESC_TCP_CHECK_SUM(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 24, 16, 16, __val)
-
-/* Dword 7 */
-#define SET_TX_DESC_TX_BUFFER_SIZE(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 28, 0, 16, __val)
-#define SET_TX_DESC_IP_HEADER_OFFSET(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 28, 16, 8, __val)
-#define SET_TX_DESC_TCP_ENABLE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 28, 31, 1, __val)
-
-/* Dword 8 */
-#define SET_TX_DESC_TX_BUFFER_ADDRESS(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 32, 0, 32, __val)
-#define GET_TX_DESC_TX_BUFFER_ADDRESS(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 32, 0, 32)
-
-/* Dword 9 */
-#define SET_TX_DESC_NEXT_DESC_ADDRESS(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 36, 0, 32, __val)
-
-/* Because the PCI Tx descriptors are chaied at the
- * initialization and all the NextDescAddresses in
- * these descriptors cannot not be cleared (,or
- * driver/HW cannot find the next descriptor), the
- * offset 36 (NextDescAddresses) is reserved when
- * the desc is cleared. */
 #define	TX_DESC_NEXT_DESC_OFFSET			36
-#define CLEAR_PCI_TX_DESC_CONTENT(__pdesc, _size)		\
-do {								\
-	if (_size > TX_DESC_NEXT_DESC_OFFSET)			\
-		memset(__pdesc, 0, TX_DESC_NEXT_DESC_OFFSET);	\
-	else							\
-		memset(__pdesc, 0, _size);			\
-} while (0);
 
 /* Rx Desc */
 #define RX_STATUS_DESC_SIZE				24
 #define RX_DRV_INFO_SIZE_UNIT				8
 
-/* DWORD 0 */
-#define SET_RX_STATUS_DESC_PKT_LEN(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc, 0, 14, __val)
-#define SET_RX_STATUS_DESC_CRC32(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc, 14, 1, __val)
-#define SET_RX_STATUS_DESC_ICV(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 15, 1, __val)
-#define SET_RX_STATUS_DESC_DRVINFO_SIZE(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc, 16, 4, __val)
-#define SET_RX_STATUS_DESC_SECURITY(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc, 20, 3, __val)
-#define SET_RX_STATUS_DESC_QOS(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 23, 1, __val)
-#define SET_RX_STATUS_DESC_SHIFT(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc, 24, 2, __val)
-#define SET_RX_STATUS_DESC_PHY_STATUS(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc, 26, 1, __val)
-#define SET_RX_STATUS_DESC_SWDEC(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc, 27, 1, __val)
-#define SET_RX_STATUS_DESC_LAST_SEG(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc, 28, 1, __val)
-#define SET_RX_STATUS_DESC_FIRST_SEG(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc, 29, 1, __val)
-#define SET_RX_STATUS_DESC_EOR(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 30, 1, __val)
-#define SET_RX_STATUS_DESC_OWN(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc, 31, 1, __val)
-
-#define GET_RX_STATUS_DESC_PKT_LEN(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc, 0, 14)
-#define GET_RX_STATUS_DESC_CRC32(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc, 14, 1)
-#define GET_RX_STATUS_DESC_ICV(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc, 15, 1)
-#define GET_RX_STATUS_DESC_DRVINFO_SIZE(__pdesc)		\
-	SHIFT_AND_MASK_LE(__pdesc, 16, 4)
-#define GET_RX_STATUS_DESC_SECURITY(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc, 20, 3)
-#define GET_RX_STATUS_DESC_QOS(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc, 23, 1)
-#define GET_RX_STATUS_DESC_SHIFT(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc, 24, 2)
-#define GET_RX_STATUS_DESC_PHY_STATUS(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc, 26, 1)
-#define GET_RX_STATUS_DESC_SWDEC(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc, 27, 1)
-#define GET_RX_STATUS_DESC_LAST_SEG(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc, 28, 1)
-#define GET_RX_STATUS_DESC_FIRST_SEG(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc, 29, 1)
-#define GET_RX_STATUS_DESC_EOR(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc, 30, 1)
-#define GET_RX_STATUS_DESC_OWN(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc, 31, 1)
-
-/* DWORD 1 */
-#define SET_RX_STATUS_DESC_MACID(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 0, 5, __val)
-#define SET_RX_STATUS_DESC_TID(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 5, 4, __val)
-#define SET_RX_STATUS_DESC_PAGGR(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 14, 1, __val)
-#define SET_RX_STATUS_DESC_FAGGR(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 15, 1, __val)
-#define SET_RX_STATUS_DESC_A1_FIT(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 16, 4, __val)
-#define SET_RX_STATUS_DESC_A2_FIT(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 20, 4, __val)
-#define SET_RX_STATUS_DESC_PAM(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 24, 1, __val)
-#define SET_RX_STATUS_DESC_PWR(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 25, 1, __val)
-#define SET_RX_STATUS_DESC_MOREDATA(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 26, 1, __val)
-#define SET_RX_STATUS_DESC_MOREFRAG(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 27, 1, __val)
-#define SET_RX_STATUS_DESC_TYPE(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 28, 2, __val)
-#define SET_RX_STATUS_DESC_MC(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 30, 1, __val)
-#define SET_RX_STATUS_DESC_BC(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 4, 31, 1, __val)
-
-#define GET_RX_STATUS_DEC_MACID(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 0, 5)
-#define GET_RX_STATUS_DESC_TID(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 5, 4)
-#define GET_RX_STATUS_DESC_PAGGR(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 14, 1)
-#define GET_RX_STATUS_DESC_FAGGR(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 15, 1)
-#define GET_RX_STATUS_DESC_A1_FIT(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 16, 4)
-#define GET_RX_STATUS_DESC_A2_FIT(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 20, 4)
-#define GET_RX_STATUS_DESC_PAM(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 24, 1)
-#define GET_RX_STATUS_DESC_PWR(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 25, 1)
-#define GET_RX_STATUS_DESC_MORE_DATA(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 26, 1)
-#define GET_RX_STATUS_DESC_MORE_FRAG(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 27, 1)
-#define GET_RX_STATUS_DESC_TYPE(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 28, 2)
-#define GET_RX_STATUS_DESC_MC(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 30, 1)
-#define GET_RX_STATUS_DESC_BC(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc + 4, 31, 1)
-
-/* DWORD 2 */
-#define SET_RX_STATUS_DESC_SEQ(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 0, 12, __val)
-#define SET_RX_STATUS_DESC_FRAG(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 12, 4, __val)
-#define SET_RX_STATUS_DESC_NEXT_PKTLEN(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 16, 8, __val)
-#define SET_RX_STATUS_DESC_NEXT_IND(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 8, 30, 1, __val)
-
-#define GET_RX_STATUS_DESC_SEQ(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc + 8, 0, 12)
-#define GET_RX_STATUS_DESC_FRAG(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 8, 12, 4)
-#define GET_RX_STATUS_DESC_NEXT_PKTLEN(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 8, 16, 8)
-#define GET_RX_STATUS_DESC_NEXT_IND(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 8, 30, 1)
-
-/* DWORD 3 */
-#define SET_RX_STATUS_DESC_RX_MCS(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 0, 6, __val)
-#define SET_RX_STATUS_DESC_RX_HT(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 6, 1, __val)
-#define SET_RX_STATUS_DESC_AMSDU(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 7, 1, __val)
-#define SET_RX_STATUS_DESC_SPLCP(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 8, 1, __val)
-#define SET_RX_STATUS_DESC_BW(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 9, 1, __val)
-#define SET_RX_STATUS_DESC_HTC(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 10, 1, __val)
-#define SET_RX_STATUS_DESC_TCP_CHK_RPT(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 11, 1, __val)
-#define SET_RX_STATUS_DESC_IP_CHK_RPT(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 12, 1, __val)
-#define SET_RX_STATUS_DESC_TCP_CHK_VALID(__pdesc, __val)	\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 13, 1, __val)
-#define SET_RX_STATUS_DESC_HWPC_ERR(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 14, 1, __val)
-#define SET_RX_STATUS_DESC_HWPC_IND(__pdesc, __val)		\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 15, 1, __val)
-#define SET_RX_STATUS_DESC_IV0(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 12, 16, 16, __val)
-
-#define GET_RX_STATUS_DESC_RX_MCS(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 0, 6)
-#define GET_RX_STATUS_DESC_RX_HT(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 6, 1)
-#define GET_RX_STATUS_DESC_AMSDU(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 7, 1)
-#define GET_RX_STATUS_DESC_SPLCP(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 8, 1)
-#define GET_RX_STATUS_DESC_BW(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 9, 1)
-#define GET_RX_STATUS_DESC_HTC(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 10, 1)
-#define GET_RX_STATUS_DESC_TCP_CHK_RPT(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 11, 1)
-#define GET_RX_STATUS_DESC_IP_CHK_RPT(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 12, 1)
-#define GET_RX_STATUS_DESC_TCP_CHK_VALID(__pdesc)		\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 13, 1)
-#define GET_RX_STATUS_DESC_HWPC_ERR(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 14, 1)
-#define GET_RX_STATUS_DESC_HWPC_IND(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 15, 1)
-#define GET_RX_STATUS_DESC_IV0(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc + 12, 16, 16)
-
-/* DWORD 4 */
-#define SET_RX_STATUS_DESC_IV1(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 16, 0, 32, __val)
-#define GET_RX_STATUS_DESC_IV1(__pdesc)				\
-	SHIFT_AND_MASK_LE(__pdesc + 16, 0, 32)
-
-/* DWORD 5 */
-#define SET_RX_STATUS_DESC_TSFL(__pdesc, __val)			\
-	SET_BITS_OFFSET_LE(__pdesc + 20, 0, 32, __val)
-#define GET_RX_STATUS_DESC_TSFL(__pdesc)			\
-	SHIFT_AND_MASK_LE(__pdesc + 20, 0, 32)
-
-/* DWORD 6 */
-#define SET_RX_STATUS__DESC_BUFF_ADDR(__pdesc, __val)	\
-	SET_BITS_OFFSET_LE(__pdesc + 24, 0, 32, __val)
-
 #define SE_RX_HAL_IS_CCK_RATE(_pdesc)\
-	(GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE1M ||	\
-	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE2M ||	\
-	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE5_5M ||\
-	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE11M)
+	(GET_RX_STATUS_DESC_RX_MCS_SE(_pdesc) == DESC92_RATE1M ||	\
+	 GET_RX_STATUS_DESC_RX_MCS_SE(_pdesc) == DESC92_RATE2M ||	\
+	 GET_RX_STATUS_DESC_RX_MCS_SE(_pdesc) == DESC92_RATE5_5M ||	\
+	 GET_RX_STATUS_DESC_RX_MCS_SE(_pdesc) == DESC92_RATE11M)
 
 enum rf_optype {
 	RF_OP_BY_SW_3WIRE = 0,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index e58b80f..e742bf3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -513,25 +513,26 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 			   struct sk_buff *skb)
 {
 	struct rx_fwinfo *p_drvinfo;
-	u32 phystatus = (u32)GET_RX_STATUS_DESC_PHY_STATUS(pdesc);
+	u32 phystatus = (u32)GET_RX_STATUS_DESC_PHY_STATUS_SE(pdesc);
 	struct ieee80211_hdr *hdr;
 
-	stats->length = (u16)GET_RX_STATUS_DESC_PKT_LEN(pdesc);
-	stats->rx_drvinfo_size = (u8)GET_RX_STATUS_DESC_DRVINFO_SIZE(pdesc) * 8;
-	stats->rx_bufshift = (u8)(GET_RX_STATUS_DESC_SHIFT(pdesc) & 0x03);
-	stats->icv = (u16)GET_RX_STATUS_DESC_ICV(pdesc);
-	stats->crc = (u16)GET_RX_STATUS_DESC_CRC32(pdesc);
+	stats->length = (u16)GET_RX_STATUS_DESC_PKT_LEN_SE(pdesc);
+	stats->rx_drvinfo_size = (u8)GET_RX_STATUS_DESC_DRVINFO_SIZE_SE(pdesc)
+				 * 8;
+	stats->rx_bufshift = (u8)(GET_RX_STATUS_DESC_SHIFT_SE(pdesc) & 0x03);
+	stats->icv = (u16)GET_RX_STATUS_DESC_ICV_SE(pdesc);
+	stats->crc = (u16)GET_RX_STATUS_DESC_CRC32_SE(pdesc);
 	stats->hwerror = (u16)(stats->crc | stats->icv);
-	stats->decrypted = !GET_RX_STATUS_DESC_SWDEC(pdesc);
+	stats->decrypted = !GET_RX_STATUS_DESC_SWDEC_SE(pdesc);
 
-	stats->rate = (u8)GET_RX_STATUS_DESC_RX_MCS(pdesc);
-	stats->shortpreamble = (u16)GET_RX_STATUS_DESC_SPLCP(pdesc);
-	stats->isampdu = (bool)(GET_RX_STATUS_DESC_PAGGR(pdesc) == 1);
-	stats->isfirst_ampdu = (bool) ((GET_RX_STATUS_DESC_PAGGR(pdesc) == 1)
-			       && (GET_RX_STATUS_DESC_FAGGR(pdesc) == 1));
-	stats->timestamp_low = GET_RX_STATUS_DESC_TSFL(pdesc);
-	stats->rx_is40Mhzpacket = (bool)GET_RX_STATUS_DESC_BW(pdesc);
-	stats->is_ht = (bool)GET_RX_STATUS_DESC_RX_HT(pdesc);
+	stats->rate = (u8)GET_RX_STATUS_DESC_RX_MCS_SE(pdesc);
+	stats->shortpreamble = (u16)GET_RX_STATUS_DESC_SPLCP_SE(pdesc);
+	stats->isampdu = (bool)(GET_RX_STATUS_DESC_PAGGR_SE(pdesc) == 1);
+	stats->isfirst_ampdu = (bool) ((GET_RX_STATUS_DESC_PAGGR_SE(pdesc) == 1)
+			       && (GET_RX_STATUS_DESC_FAGGR_SE(pdesc) == 1));
+	stats->timestamp_low = GET_RX_STATUS_DESC_TSFL_SE(pdesc);
+	stats->rx_is40Mhzpacket = (bool)GET_RX_STATUS_DESC_BW_SE(pdesc);
+	stats->is_ht = (bool)GET_RX_STATUS_DESC_RX_HT_SE(pdesc);
 	stats->is_cck = SE_RX_HAL_IS_CCK_RATE(pdesc);
 
 	if (stats->hwerror)
@@ -628,13 +629,13 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 		if (rtlpriv->dm.useramask) {
 			/* set txdesc macId */
 			if (ptcb_desc->mac_id < 32) {
-				SET_TX_DESC_MACID(pdesc, ptcb_desc->mac_id);
+				SET_TX_DESC_MACID_SE(pdesc, ptcb_desc->mac_id);
 				reserved_macid |= ptcb_desc->mac_id;
 			}
 		}
-		SET_TX_DESC_RSVD_MACID(pdesc, reserved_macid);
+		SET_TX_DESC_RSVD_MACID_SE(pdesc, reserved_macid);
 
-		SET_TX_DESC_TXHT(pdesc, ((ptcb_desc->hw_rate >=
+		SET_TX_DESC_TXHT_SE(pdesc, ((ptcb_desc->hw_rate >=
 				 DESC92_RATEMCS0) ? 1 : 0));
 
 		if (rtlhal->version == VERSION_8192S_ACUT) {
@@ -646,31 +647,31 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 			}
 		}
 
-		SET_TX_DESC_TX_RATE(pdesc, ptcb_desc->hw_rate);
+		SET_TX_DESC_TX_RATE_SE(pdesc, ptcb_desc->hw_rate);
 
 		if (ptcb_desc->use_shortgi || ptcb_desc->use_shortpreamble)
-			SET_TX_DESC_TX_SHORT(pdesc, 0);
+			SET_TX_DESC_TX_SHORT_SE(pdesc, 0);
 
 		/* Aggregation related */
 		if (info->flags & IEEE80211_TX_CTL_AMPDU)
-			SET_TX_DESC_AGG_ENABLE(pdesc, 1);
+			SET_TX_DESC_AGG_ENABLE_SE(pdesc, 1);
 
 		/* For AMPDU, we must insert SSN into TX_DESC */
-		SET_TX_DESC_SEQ(pdesc, seq_number);
+		SET_TX_DESC_SEQ_SE(pdesc, seq_number);
 
 		/* Protection mode related */
 		/* For 92S, if RTS/CTS are set, HW will execute RTS. */
 		/* We choose only one protection mode to execute */
-		SET_TX_DESC_RTS_ENABLE(pdesc, ((ptcb_desc->rts_enable &&
+		SET_TX_DESC_RTS_ENABLE_SE(pdesc, ((ptcb_desc->rts_enable &&
 				!ptcb_desc->cts_enable) ? 1 : 0));
-		SET_TX_DESC_CTS_ENABLE(pdesc, ((ptcb_desc->cts_enable) ?
+		SET_TX_DESC_CTS_ENABLE_SE(pdesc, ((ptcb_desc->cts_enable) ?
 				       1 : 0));
-		SET_TX_DESC_RTS_STBC(pdesc, ((ptcb_desc->rts_stbc) ? 1 : 0));
+		SET_TX_DESC_RTS_STBC_SE(pdesc, ((ptcb_desc->rts_stbc) ? 1 : 0));
 
-		SET_TX_DESC_RTS_RATE(pdesc, ptcb_desc->rts_rate);
-		SET_TX_DESC_RTS_BANDWIDTH(pdesc, 0);
-		SET_TX_DESC_RTS_SUB_CARRIER(pdesc, ptcb_desc->rts_sc);
-		SET_TX_DESC_RTS_SHORT(pdesc, ((ptcb_desc->rts_rate <=
+		SET_TX_DESC_RTS_RATE_SE(pdesc, ptcb_desc->rts_rate);
+		SET_TX_DESC_RTS_BANDWIDTH_SE(pdesc, 0);
+		SET_TX_DESC_RTS_SUB_CARRIER_SE(pdesc, ptcb_desc->rts_sc);
+		SET_TX_DESC_RTS_SHORT_SE(pdesc, ((ptcb_desc->rts_rate <=
 		       DESC92_RATE54M) ?
 		       (ptcb_desc->rts_use_shortpreamble ? 1 : 0)
 		       : (ptcb_desc->rts_use_shortgi ? 1 : 0)));
@@ -679,17 +680,17 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 		/* Set Bandwidth and sub-channel settings. */
 		if (bw_40) {
 			if (ptcb_desc->packet_bw) {
-				SET_TX_DESC_TX_BANDWIDTH(pdesc, 1);
+				SET_TX_DESC_TX_BANDWIDTH_SE(pdesc, 1);
 				/* use duplicated mode */
-				SET_TX_DESC_TX_SUB_CARRIER(pdesc, 0);
+				SET_TX_DESC_TX_SUB_CARRIER_SE(pdesc, 0);
 			} else {
-				SET_TX_DESC_TX_BANDWIDTH(pdesc, 0);
-				SET_TX_DESC_TX_SUB_CARRIER(pdesc,
+				SET_TX_DESC_TX_BANDWIDTH_SE(pdesc, 0);
+				SET_TX_DESC_TX_SUB_CARRIER_SE(pdesc,
 						   mac->cur_40_prime_sc);
 			}
 		} else {
-			SET_TX_DESC_TX_BANDWIDTH(pdesc, 0);
-			SET_TX_DESC_TX_SUB_CARRIER(pdesc, 0);
+			SET_TX_DESC_TX_BANDWIDTH_SE(pdesc, 0);
+			SET_TX_DESC_TX_SUB_CARRIER_SE(pdesc, 0);
 		}
 
 		/* 3 Fill necessary field in First Descriptor */
@@ -699,7 +700,7 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_PKT_SIZE(pdesc, (u16) skb->len);
 
 		/*DWORD 1*/
-		SET_TX_DESC_RA_BRSR_ID(pdesc, ptcb_desc->ratr_index);
+		SET_TX_DESC_RA_BRSR_ID_SE(pdesc, ptcb_desc->ratr_index);
 
 		/* Fill security related */
 		if (info->control.hw_key) {
@@ -709,37 +710,37 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 			switch (keyconf->cipher) {
 			case WLAN_CIPHER_SUITE_WEP40:
 			case WLAN_CIPHER_SUITE_WEP104:
-				SET_TX_DESC_SEC_TYPE(pdesc, 0x1);
+				SET_TX_DESC_SEC_TYPE_SE(pdesc, 0x1);
 				break;
 			case WLAN_CIPHER_SUITE_TKIP:
-				SET_TX_DESC_SEC_TYPE(pdesc, 0x2);
+				SET_TX_DESC_SEC_TYPE_SE(pdesc, 0x2);
 				break;
 			case WLAN_CIPHER_SUITE_CCMP:
-				SET_TX_DESC_SEC_TYPE(pdesc, 0x3);
+				SET_TX_DESC_SEC_TYPE_SE(pdesc, 0x3);
 				break;
 			default:
-				SET_TX_DESC_SEC_TYPE(pdesc, 0x0);
+				SET_TX_DESC_SEC_TYPE_SE(pdesc, 0x0);
 				break;
 
 			}
 		}
 
 		/* Set Packet ID */
-		SET_TX_DESC_PACKET_ID(pdesc, 0);
+		SET_TX_DESC_PACKET_ID_SE(pdesc, 0);
 
 		/* We will assign magement queue to BK. */
-		SET_TX_DESC_QUEUE_SEL(pdesc, fw_qsel);
+		SET_TX_DESC_QUEUE_SEL_SE(pdesc, fw_qsel);
 
 		/* Alwasy enable all rate fallback range */
-		SET_TX_DESC_DATA_RATE_FB_LIMIT(pdesc, 0x1F);
+		SET_TX_DESC_DATA_RATE_FB_LIMIT_SE(pdesc, 0x1F);
 
 		/* Fix: I don't kown why hw use 6.5M to tx when set it */
-		SET_TX_DESC_USER_RATE(pdesc,
+		SET_TX_DESC_USER_RATE_SE(pdesc,
 				      ptcb_desc->use_driver_rate ? 1 : 0);
 
 		/* Set NON_QOS bit. */
 		if (!ieee80211_is_data_qos(fc))
-			SET_TX_DESC_NON_QOS(pdesc, 1);
+			SET_TX_DESC_NON_QOS_SE(pdesc, 1);
 
 	}
 
@@ -750,10 +751,10 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 	SET_TX_DESC_LAST_SEG(pdesc, (lastseg ? 1 : 0));
 
 	/* DWORD 7 */
-	SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16) skb->len);
+	SET_TX_DESC_TX_BUFFER_SIZE_SE(pdesc, (u16) skb->len);
 
 	/* DOWRD 8 */
-	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
+	SET_TX_DESC_TX_BUFFER_ADDRESS_SE(pdesc, cpu_to_le32(mapping));
 
 	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "\n");
 }
@@ -782,8 +783,8 @@ void rtl92se_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 
 		/* 92SE need not to set TX packet size when firmware download */
 		SET_TX_DESC_PKT_SIZE(pdesc, (u16)(skb->len));
-		SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16)(skb->len));
-		SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
+		SET_TX_DESC_TX_BUFFER_SIZE_SE(pdesc, (u16)(skb->len));
+		SET_TX_DESC_TX_BUFFER_ADDRESS_SE(pdesc, cpu_to_le32(mapping));
 
 		wmb();
 		SET_TX_DESC_OWN(pdesc, 1);
@@ -797,12 +798,12 @@ void rtl92se_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 		/* Buffer size + command header */
 		SET_TX_DESC_PKT_SIZE(pdesc, (u16)(skb->len));
 		/* Fixed queue of H2C command */
-		SET_TX_DESC_QUEUE_SEL(pdesc, 0x13);
+		SET_TX_DESC_QUEUE_SEL_SE(pdesc, 0x13);
 
 		SET_BITS_TO_LE_4BYTE(skb->data, 24, 7, rtlhal->h2c_txcmd_seq);
 
-		SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16)(skb->len));
-		SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
+		SET_TX_DESC_TX_BUFFER_SIZE_SE(pdesc, (u16)(skb->len));
+		SET_TX_DESC_TX_BUFFER_ADDRESS_SE(pdesc, cpu_to_le32(mapping));
 
 		wmb();
 		SET_TX_DESC_OWN(pdesc, 1);
@@ -819,7 +820,7 @@ void rtl92se_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
 			SET_TX_DESC_OWN(pdesc, 1);
 			break;
 		case HW_DESC_TX_NEXTDESC_ADDR:
-			SET_TX_DESC_NEXT_DESC_ADDRESS(pdesc, *(u32 *) val);
+			SET_TX_DESC_NEXT_DESC_ADDRESS_SE(pdesc, *(u32 *) val);
 			break;
 		default:
 			RT_ASSERT(false, "ERR txdesc :%d not process\n",
@@ -830,16 +831,16 @@ void rtl92se_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
 		switch (desc_name) {
 		case HW_DESC_RXOWN:
 			wmb();
-			SET_RX_STATUS_DESC_OWN(pdesc, 1);
+			SET_RX_STATUS_DESC_OWN_SE(pdesc, 1);
 			break;
 		case HW_DESC_RXBUFF_ADDR:
-			SET_RX_STATUS__DESC_BUFF_ADDR(pdesc, *(u32 *) val);
+			SET_RX_STATUS__DESC_BUFF_ADDR_SE(pdesc, *(u32 *) val);
 			break;
 		case HW_DESC_RXPKT_LEN:
-			SET_RX_STATUS_DESC_PKT_LEN(pdesc, *(u32 *) val);
+			SET_RX_STATUS_DESC_PKT_LEN_SE(pdesc, *(u32 *) val);
 			break;
 		case HW_DESC_RXERO:
-			SET_RX_STATUS_DESC_EOR(pdesc, 1);
+			SET_RX_STATUS_DESC_EOR_SE(pdesc, 1);
 			break;
 		default:
 			RT_ASSERT(false, "ERR rxdesc :%d not process\n",
@@ -859,7 +860,7 @@ u32 rtl92se_get_desc(u8 *desc, bool istx, u8 desc_name)
 			ret = GET_TX_DESC_OWN(desc);
 			break;
 		case HW_DESC_TXBUFF_ADDR:
-			ret = GET_TX_DESC_TX_BUFFER_ADDRESS(desc);
+			ret = GET_TX_DESC_TX_BUFFER_ADDRESS_SE(desc);
 			break;
 		default:
 			RT_ASSERT(false, "ERR txdesc :%d not process\n",
@@ -869,10 +870,10 @@ u32 rtl92se_get_desc(u8 *desc, bool istx, u8 desc_name)
 	} else {
 		switch (desc_name) {
 		case HW_DESC_OWN:
-			ret = GET_RX_STATUS_DESC_OWN(desc);
+			ret = GET_RX_STATUS_DESC_OWN_SE(desc);
 			break;
 		case HW_DESC_RXPKT_LEN:
-			ret = GET_RX_STATUS_DESC_PKT_LEN(desc);
+			ret = GET_RX_STATUS_DESC_PKT_LEN_SE(desc);
 			break;
 		default:
 			RT_ASSERT(false, "ERR rxdesc :%d not process\n",
-- 
1.7.7

