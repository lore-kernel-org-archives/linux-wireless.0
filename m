Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:48215 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751572Ab2ALA1c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 19:27:32 -0500
Message-ID: <1326328047.7886.21.camel@joe2Laptop> (sfid-20120112_012736_266733_56B093FE)
Subject: Re: [PATCH 1/5] rtlwifi: Move RX/TX macros into common file
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 11 Jan 2012 16:27:28 -0800
In-Reply-To: <1326323232-21752-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1326323232-21752-1-git-send-email-Larry.Finger@lwfinger.net>
	 <1326323232-21752-2-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-01-11 at 17:07 -0600, Larry Finger wrote:
> Each of the 4 drivers that use rtlwifi maintains its own set of macros
> that get and set the various fields in the RX and TX descriptors. To
> reduce the size of the source, and to help maintainability, these
> macros are combined into a single file. In addition, any macro that is
> defined, but not used, is deleted.
[]
> diff --git a/drivers/net/wireless/rtlwifi/macros.h b/drivers/net/wireless/rtlwifi/macros.h
[]
> +++ b/drivers/net/wireless/rtlwifi/macros.h
[]
> +#ifndef __RTLWIFI_MAC_H__
> +#define __RTLWIFI_MAC_H__

That's an odd name guard for this file.
There is a rtlwifi/rtl8192cu/mac.h file.

RTIWIFI_MACROS_H might be more appropriate.

> +
> +/* Define a macro that takes a le32 word, converts it to host ordering,
> + * right shifts by a specified count, creates a mask of the specified
> + * bit count, and extracts that number of bits.
> + */
> +
> +#define SHIFT_AND_MASK_LE(__pdesc, __shift, __mask)		\
> +	((le32_to_cpu(*(((__le32 *)(__pdesc)))) >> (__shift)) &	\
> +	BIT_LEN_MASK_32(__mask))

This macro depends on wifi.h so why not just put
all of these in wifi.h?

And instead of a #define, perhaps

static inline u32 le32p_to_cpu_shift_and_mask(__le32 *desc, int shift, u32 mask)
{
	return (le32_to_cpu(*desc) >> shift) & BIT_LEN_MASK_32(mask);
}

> +#define CLEAR_PCI_TX_DESC_CONTENT(__pdesc, _size)		\
> +do {								\
> +	if (_size > TX_DESC_NEXT_DESC_OFFSET)			\
> +		memset(__pdesc, 0, TX_DESC_NEXT_DESC_OFFSET);	\
> +	else							\
> +		memset(__pdesc, 0, _size);			\
> +} while (0)

Perhaps
	memset(__pdesc, 0, min(size, TX_DESC_NEXT_DESC_OFFSET))

> +
> +/* macros to read/write various fields in RX or TX descriptors
> + *
> + * The organization is as follows:
> + * 1. Macros that operate on the same dword are placed together.
> + * 2. The macros for rtl8192ce are first. Most of these are also
> + *    used for rtl8192de, but the register layout is different
> + *    for rtl8192cu and rtl8192se.
> + * 3. Special macros for other drivers will be given an _CU, _SE,
> + *    and _DE suffix, and listed following those for rtl8192ce.
> + */

I don't see how centralizing these non-shared
macro names helps.

Maybe if the code is actually common, have a
separate #include for each card with common
named #defines as appropriate.

> +
> +/*********************** DWORD 0 ***********************/
> +
> d+#define SET_TX_DESC_PKT_SIZE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc, 0, 16, __val)
> +#define SET_TX_DESC_OFFSET(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc, 16, 8, __val)
> +#define SET_TX_DESC_BMC(__pdesc, __val)			\
> +	SET_BITS_OFFSET_LE(__pdesc, 24, 1, __val)
> +#define SET_TX_DESC_HTC(__pdesc, __val)			\
> +	SET_BITS_OFFSET_LE(__pdesc, 25, 1, __val)
> +#define SET_TX_DESC_LAST_SEG(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc, 26, 1, __val)
> +#define SET_TX_DESC_FIRST_SEG(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc, 27, 1, __val)
> +#define SET_TX_DESC_LINIP(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc, 28, 1, __val)
> +#define SET_TX_DESC_OWN(__pdesc, __val)			\
> +	SET_BITS_OFFSET_LE(__pdesc, 31, 1, __val)
> +
> +#define GET_RX_DESC_PKT_LEN(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc, 0, 14)
> +#define GET_RX_DESC_CRC32(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc, 14, 1)
> +#define GET_RX_DESC_ICV(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc, 15, 1)
> +#define GET_RX_DESC_DRV_INFO_SIZE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc, 16, 4)
> +#define GET_RX_DESC_SHIFT(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc, 24, 2)
> +#define GET_RX_DESC_PHYST(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc, 26, 1)
> +#define GET_RX_DESC_SWDEC(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc, 27, 1)
> +#define GET_RX_DESC_OWN(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc, 31, 1)
> +#define GET_TX_DESC_OWN(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc, 31, 1)
> +/* Special macros for rtl8192cu */
> +#define GET_RX_DESC_PKT_LEN_CU(__rxdesc)		\
> +	SHIFT_AND_MASK_LE((__rxdesc), 0, 14)
> +#define GET_RX_DESC_CRC32_CU(__rxdesc)			\
> +	SHIFT_AND_MASK_LE(__rxdesc, 14, 1)
> +#define GET_RX_DESC_ICV_CU(__rxdesc)			\
> +	SHIFT_AND_MASK_LE(__rxdesc, 15, 1)
> +#define GET_RX_DESC_DRVINFO_SIZE_CU(__rxdesc)		\
> +	SHIFT_AND_MASK_LE(__rxdesc, 16, 4)
> +#define GET_RX_DESC_SHIFT_CU(__rxdesc)			\
> +	SHIFT_AND_MASK_LE(__rxdesc, 24, 2)
> +#define GET_RX_DESC_PHY_STATUS_CU(__rxdesc)		\
> +	SHIFT_AND_MASK_LE(__rxdesc, 26, 1)
> +#define GET_RX_DESC_SWDEC_CU(__rxdesc)			\
> +	SHIFT_AND_MASK_LE(__rxdesc, 27, 1)
> +/* Special macros for rtl8192se */
> +#define SET_RX_STATUS_DESC_PKT_LEN_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc, 0, 14, __val)
> +#define SET_RX_STATUS_DESC_EOR_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc, 30, 1, __val)
> +#define SET_RX_STATUS_DESC_OWN_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc, 31, 1, __val)
> +
> +#define GET_RX_STATUS_DESC_PKT_LEN_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc, 0, 14)
> +#define GET_RX_STATUS_DESC_CRC32_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc, 14, 1)
> +#define GET_RX_STATUS_DESC_ICV_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc, 15, 1)
> +#define GET_RX_STATUS_DESC_DRVINFO_SIZE_SE(__pdesc)	\
> +	SHIFT_AND_MASK_LE(__pdesc, 16, 4)
> +#define GET_RX_STATUS_DESC_SHIFT_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc, 24, 2)
> +#define GET_RX_STATUS_DESC_PHY_STATUS_SE(__pdesc)	\
> +	SHIFT_AND_MASK_LE(__pdesc, 26, 1)
> +#define GET_RX_STATUS_DESC_SWDEC_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc, 27, 1)
> +#define GET_RX_STATUS_DESC_OWN_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc, 31, 1)
> +
> +/*********************** DWORD 1 ***********************/
> +
> +#define SET_TX_DESC_MACID(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 0, 5, __val)
> +#define SET_TX_DESC_AGG_BREAK(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 5, 1, __val)
> +#define SET_TX_DESC_RDG_ENABLE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 7, 1, __val)
> +#define SET_TX_DESC_QUEUE_SEL(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 8, 5, __val)
> +#define SET_TX_DESC_RATE_ID(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 16, 4, __val)
> +#define SET_TX_DESC_SEC_TYPE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 22, 2, __val)
> +#define SET_TX_DESC_PKT_OFFSET(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 24, 8, __val)
> +
> +#define GET_TX_DESC_MACID(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc+4, 0, 5)
> +/* Special macros for rtl8192cu */
> +#define SET_TX_DESC_MACID_CU(__txdesc, __value)		\
> +	SET_BITS_OFFSET_LE(__txdesc+4, 0, 5, __value)
> +#define SET_TX_DESC_AGG_ENABLE_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+4, 5, 1, __value)
> +#define SET_TX_DESC_AGG_BREAK_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+4, 6, 1, __value)
> +#define SET_TX_DESC_RDG_ENABLE_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+4, 7, 1, __value)
> +#define SET_TX_DESC_QUEUE_SEL_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+4, 8, 5, __value)
> +#define GET_RX_DESC_PAGGR_CU(__rxdesc)			\
> +	SHIFT_AND_MASK_LE(__rxdesc+4, 14, 1)
> +#define GET_RX_DESC_FAGGR_CU(__rxdesc)			\
> +	SHIFT_AND_MASK_LE(__rxdesc+4, 15, 1)
> +#define SET_TX_DESC_RATE_ID_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+4, 16, 4, __value)
> +#define SET_TX_DESC_NAV_USE_HDR_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+4, 20, 1, __value)
> +#define SET_TX_DESC_SEC_TYPE_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+4, 22, 2, __value)
> +#define SET_TX_DESC_PKT_OFFSET_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+4, 26, 5, __value)
> +/* Special macros for rtl8192de */
> +#define SET_TX_DESC_AGG_ENABLE_DE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 5, 1, __val)
> +#define SET_TX_DESC_PKT_OFFSET_DE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 26, 8, __val)
> +/* Special macros for rtl8192se */
> +#define SET_TX_DESC_MACID_SE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 0, 5, __val)
> +#define SET_TX_DESC_QUEUE_SEL_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 8, 5, __val)
> +#define GET_RX_STATUS_DESC_PAGGR_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc+4, 14, 1)
> +#define GET_RX_STATUS_DESC_FAGGR_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc+4, 15, 1)
> +#define SET_TX_DESC_NON_QOS_SE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 16, 1, __val)
> +#define SET_TX_DESC_SEC_TYPE_SE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+4, 22, 2, __val)
> +
> +/*********************** DWORD 2 ***********************/
> +
> +#define SET_TX_DESC_MORE_FRAG(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+8, 17, 1, __val)
> +#define SET_TX_DESC_AMPDU_DENSITY(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+8, 20, 3, __val)
> +/* Special macros for rtl8192cu */
> +#define SET_TX_DESC_MORE_FRAG_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+8, 17, 1, __value)
> +#define SET_TX_DESC_AMPDU_DENSITY_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+8, 20, 3, __value)
> +/* Special macros for rtl8192se */
> +#define	SET_TX_DESC_RSVD_MACID_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(((__pdesc)+8), 24, 5, __val)
> +#define SET_TX_DESC_AGG_ENABLE_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+8, 29, 1, __val)
> +
> +/*********************** DWORD 3 ***********************/
> +
> +#define SET_TX_DESC_SEQ(__pdesc, __val)			\
> +	SET_BITS_OFFSET_LE(__pdesc+12, 16, 12, __val)
> +#define SET_TX_DESC_PKT_ID(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+12, 28, 4, __val)
> +/* Special macros for rtl8192cu */
> +#define GET_RX_DESC_RX_MCS_CU(__rxdesc)			\
> +	SHIFT_AND_MASK_LE(__rxdesc+12, 0, 6)
> +#define GET_RX_DESC_RX_HT_CU(__rxdesc)			\
> +	SHIFT_AND_MASK_LE(__rxdesc+12, 6, 1)
> +#define GET_RX_DESC_SPLCP_CU(__rxdesc)			\
> +	SHIFT_AND_MASK_LE(__rxdesc+12, 8, 1)
> +#define GET_RX_DESC_BW_CU(__rxdesc)			\
> +	SHIFT_AND_MASK_LE(__rxdesc+12, 9, 1)
> +#define SET_TX_DESC_SEQ_CU(__txdesc, __value)		\
> +	SET_BITS_OFFSET_LE(__txdesc+12, 16, 12, __value)
> +#define SET_TX_DESC_PKT_ID_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+12, 28, 4, __value)
> +/* Special macros for rtl8192se */
> +#define GET_RX_STATUS_DESC_RX_MCS_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc+12, 0, 6)
> +#define GET_RX_STATUS_DESC_RX_HT_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc+12, 6, 1)
> +#define GET_RX_STATUS_DESC_SPLCP_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc+12, 8, 1)
> +#define GET_RX_STATUS_DESC_BW_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc+12, 9, 1)
> +#define SET_TX_DESC_SEQ_SE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+12, 16, 12, __val)
> +#define SET_TX_DESC_FRAG(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+12, 28, 4, __val)
> +
> +/*********************** DWORD 4 ***********************/
> +
> +#define SET_TX_DESC_RTS_RATE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 0, 5, __val)
> +#define SET_TX_DESC_QOS(__pdesc, __val)			\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 6, 1, __val)
> +#define SET_TX_DESC_HWSEQ_EN(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 7, 1, __val)
> +#define SET_TX_DESC_USE_RATE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 8, 1, __val)
> +#define SET_TX_DESC_DISABLE_FB(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 10, 1, __val)
> +#define SET_TX_DESC_CTS2SELF(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 11, 1, __val)
> +#define SET_TX_DESC_RTS_ENABLE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 12, 1, __val)
> +#define SET_TX_DESC_HW_RTS_ENABLE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 13, 1, __val)
> +#define SET_TX_DESC_TX_SUB_CARRIER(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 20, 2, __val)
> +#define SET_TX_DESC_DATA_SHORT(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 24, 1, __val)
> +#define SET_TX_DESC_DATA_BW(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 25, 1, __val)
> +#define SET_TX_DESC_RTS_SHORT(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 26, 1, __val)
> +#define SET_TX_DESC_RTS_BW(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 27, 1, __val)
> +#define SET_TX_DESC_RTS_SC(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 28, 2, __val)
> +#define SET_TX_DESC_RTS_STBC(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 30, 2, __val)
> +/* Special macros for rtl8192cu */
> +#define SET_TX_DESC_RTS_RATE_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 0, 5, __value)
> +#define SET_TX_DESC_QOS_CU(__txdesc, __value)		\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 6, 1, __value)
> +#define SET_TX_DESC_HWSEQ_EN_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 7, 1, __value)
> +#define SET_TX_DESC_USE_RATE_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 8, 1, __value)
> +#define SET_TX_DESC_DISABLE_FB_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 10, 1, __value)
> +#define SET_TX_DESC_CTS2SELF_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 11, 1, __value)
> +#define SET_TX_DESC_RTS_ENABLE_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 12, 1, __value)
> +#define SET_TX_DESC_HW_RTS_ENABLE_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 13, 1, __value)
> +#define SET_TX_DESC_DATA_SC_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 20, 2, __value)
> +#define SET_TX_DESC_DATA_BW_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 25, 1, __value)
> +#define SET_TX_DESC_RTS_SHORT_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 26, 1, __value)
> +#define SET_TX_DESC_RTS_BW_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 27, 1, __value)
> +#define SET_TX_DESC_RTS_SC_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 28, 2, __value)
> +#define SET_TX_DESC_RTS_STBC_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+16, 30, 2, __value)
> +/* Special macros for rtl8192se */
> +#define SET_TX_DESC_RTS_RATE_SE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 0, 6, __val)
> +#define SET_TX_DESC_TXHT_SE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 16, 1, __val)
> +#define SET_TX_DESC_CTS_ENABLE_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 11, 1, __val)
> +#define SET_TX_DESC_RTS_ENABLE_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 12, 1, __val)
> +#define SET_TX_DESC_RA_BRSR_ID_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 13, 3, __val)
> +#define SET_TX_DESC_TX_SHORT_SE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 17, 1, __val)
> +#define SET_TX_DESC_TX_BANDWIDTH_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 18, 1, __val)
> +#define SET_TX_DESC_TX_SUB_CARRIER_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 19, 2, __val)
> +#define SET_TX_DESC_RTS_SHORT_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 25, 1, __val)
> +#define SET_TX_DESC_RTS_BANDWIDTH_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 26, 1, __val)
> +#define SET_TX_DESC_RTS_SUB_CARRIER_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 27, 2, __val)
> +#define SET_TX_DESC_RTS_STBC_SE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 29, 2, __val)
> +#define SET_TX_DESC_USER_RATE_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+16, 31, 1, __val)
> +
> +/*********************** DWORD 5 ***********************/
> +
> +#define SET_TX_DESC_TX_RATE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+20, 0, 6, __val)
> +#define SET_TX_DESC_DATA_SHORTGI(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+20, 6, 1, __val)
> +#define SET_TX_DESC_DATA_RATE_FB_LIMIT(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+20, 8, 5, __val)
> +#define SET_TX_DESC_RTS_RATE_FB_LIMIT(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+20, 13, 4, __val)
> +/* Special macros for rtl8192cu */
> +#define GET_RX_DESC_TSFL_CU(__rxdesc)		\
> +	SHIFT_AND_MASK_LE(__rxdesc+20, 0, 32)
> +#define SET_TX_DESC_DATA_SHORTGI_CU(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+20, 6, 1, __val)
> +#define SET_TX_DESC_DATA_RATE_FB_LIMIT_CU(__txdesc, __value) \
> +	SET_BITS_OFFSET_LE(__txdesc+20, 8, 5, __value)
> +#define SET_TX_DESC_RTS_RATE_FB_LIMIT_CU(__txdesc, __value) \
> +	SET_BITS_OFFSET_LE(__txdesc+20, 13, 4, __value)
> +/* Special macros for rtl8192se */
> +#define SET_TX_DESC_PACKET_ID_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+20, 0, 9, __val)
> +#define SET_TX_DESC_TX_RATE_SE(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+20, 9, 6, __val)
> +#define SET_TX_DESC_DATA_RATE_FB_LIMIT_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+20, 16, 5, __val)
> +#define GET_RX_STATUS_DESC_TSFL_SE(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc+20, 0, 32)
> +
> +/*********************** DWORD 6 ***********************/
> +
> +#define SET_TX_DESC_MAX_AGG_NUM(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+24, 11, 5, __val)
> +/* Special macros for rtl8192cu */
> +#define SET_TX_DESC_MAX_AGG_NUM_CU(__txdesc, __value)	\
> +	SET_BITS_OFFSET_LE(__txdesc+24, 11, 5, __value)
> +/* Special macros for rtl8192se */
> +#define SET_RX_STATUS__DESC_BUFF_ADDR_SE(__pdesc, __val)\
> +	SET_BITS_OFFSET_LE(__pdesc+24, 0, 32, __val)
> +
> +/*********************** DWORD 7 ***********************/
> +
> +#define SET_TX_DESC_TX_BUFFER_SIZE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+28, 0, 16, __val)
> +/* Special macros for rtl8192cu */
> +#define SET_TX_DESC_TX_DESC_CHECKSUM_CU(__txdesc, __value) \
> +	SET_BITS_OFFSET_LE(__txdesc+28, 0, 16, __value)
> +/* Special macros for rtl8192se */
> +#define SET_TX_DESC_TX_BUFFER_SIZE_SE(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+28, 0, 16, __val)
> +
> +/*********************** DWORD 8 ***********************/
> +
> +#define SET_TX_DESC_TX_BUFFER_ADDRESS(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+32, 0, 32, __val)
> +
> +#define GET_TX_DESC_TX_BUFFER_ADDRESS(__pdesc)		\
> +	SHIFT_AND_MASK_LE(__pdesc+32, 0, 32)
> +/* Special macros for rtl8192se */
> +#define SET_TX_DESC_TX_BUFFER_ADDRESS_SE(__pdesc, __val)\
> +	SET_BITS_OFFSET_LE(__pdesc+32, 0, 32, __val)
> +#define GET_TX_DESC_TX_BUFFER_ADDRESS_SE(__pdesc)	\
> +	SHIFT_AND_MASK_LE(__pdesc+32, 0, 32)
> +
> +/*********************** DWORD 9 ***********************/
> +/* Special macros for rtl8192se */
> +#define SET_TX_DESC_NEXT_DESC_ADDRESS_SE(__pdesc, __val)\
> +	SET_BITS_OFFSET_LE(__pdesc+36, 0, 32, __val)
> +
> +/*********************** DWORD 10 ***********************/
> +
> +#define SET_TX_DESC_NEXT_DESC_ADDRESS(__pdesc, __val)	\
> +	SET_BITS_OFFSET_LE(__pdesc+40, 0, 32, __val)
> +
> +/*********************** DWORD 11 ***********************/
> +
> +#define SET_RX_DESC_PKT_LEN(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc, 0, 14, __val)
> +#define SET_RX_DESC_EOR(__pdesc, __val)			\
> +	SET_BITS_OFFSET_LE(__pdesc, 30, 1, __val)
> +#define SET_RX_DESC_OWN(__pdesc, __val)			\
> +	SET_BITS_OFFSET_LE(__pdesc, 31, 1, __val)
> +
> +#define GET_RX_DESC_PAGGR(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc+4, 14, 1)
> +#define GET_RX_DESC_FAGGR(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc+4, 15, 1)
> +
> +#define GET_RX_DESC_RXMCS(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc+12, 0, 6)
> +#define GET_RX_DESC_RXHT(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc+12, 6, 1)
> +#define GET_RX_DESC_SPLCP(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc+12, 8, 1)
> +#define GET_RX_DESC_BW(__pdesc)				\
> +	SHIFT_AND_MASK_LE(__pdesc+12, 9, 1)
> +
> +#define GET_RX_DESC_TSFL(__pdesc)			\
> +	SHIFT_AND_MASK_LE(__pdesc+20, 0, 32)
> +
> +#define SET_RX_DESC_BUFF_ADDR(__pdesc, __val)		\
> +	SET_BITS_OFFSET_LE(__pdesc+24, 0, 32, __val)
> +
> +#endif



