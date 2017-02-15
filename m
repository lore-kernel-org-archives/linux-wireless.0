Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36083 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdBOJIM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:08:12 -0500
Received: by mail-pf0-f177.google.com with SMTP id 189so30229635pfu.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 01:08:11 -0800 (PST)
Subject: Re: [RFC v2 3/7] ieee80211: add new VHT capability fields/parsing
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170214132208.8715-1-johannes@sipsolutions.net>
 <20170214132208.8715-4-johannes@sipsolutions.net>
Cc: j@w1.fi, greearb@candelatech.com,
        Johannes Berg <johannes.berg@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <281180d5-2a7e-00b5-f12b-13bf568812da@broadcom.com> (sfid-20170215_100944_787216_B906D903)
Date: Wed, 15 Feb 2017 10:08:07 +0100
MIME-Version: 1.0
In-Reply-To: <20170214132208.8715-4-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-2-2017 14:22, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> IEEE 802.11-2016 extended the VHT capability fields to allow
> indicating the number of spatial streams depending on the
> actually used bandwidth, add support for decoding this.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/linux/ieee80211.h | 105 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 103 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 4a7200c6c9ea..c51d309a45e7 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -1457,13 +1457,16 @@ struct ieee80211_ht_operation {
>   *	STA can receive. Rate expressed in units of 1 Mbps.
>   *	If this field is 0 this value should not be used to
>   *	consider the highest RX data rate supported.
> - *	The top 3 bits of this field are reserved.
> + *	The top 3 bits of this field indicate the Maximum NSTS,total
> + *	(a beamformee capability.)
>   * @tx_mcs_map: TX MCS map 2 bits for each stream, total 8 streams
>   * @tx_highest: Indicates highest long GI VHT PPDU data rate
>   *	STA can transmit. Rate expressed in units of 1 Mbps.
>   *	If this field is 0 this value should not be used to
>   *	consider the highest TX data rate supported.
> - *	The top 3 bits of this field are reserved.
> + *	The top 2 bits of this field are reserved, the
> + *	3rd bit from the top indiciates VHT Extended NSS BW
> + *	Capability.
>   */
>  struct ieee80211_vht_mcs_info {
>  	__le16 rx_mcs_map;
> @@ -1472,6 +1475,13 @@ struct ieee80211_vht_mcs_info {
>  	__le16 tx_highest;
>  } __packed;
>  
> +/* for rx_highest */
> +#define IEEE80211_VHT_MAX_NSTS_TOTAL_SHIFT	13
> +#define IEEE80211_VHT_MAX_NSTS_TOTAL_MASK	(7 << IEEE80211_VHT_MAX_NSTS_TOTAL_SHIFT)
> +
> +/* for tx_highest */
> +#define IEEE80211_VHT_EXT_NSS_BW_CAPABLE	(1 << 13)
> +
>  /**
>   * enum ieee80211_vht_mcs_support - VHT MCS support definitions
>   * @IEEE80211_VHT_MCS_SUPPORT_0_7: MCSes 0-7 are supported for the
> @@ -1547,6 +1557,7 @@ struct ieee80211_vht_operation {
>  #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ		0x00000004
>  #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ	0x00000008
>  #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK			0x0000000C
> +#define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_SHIFT			2
>  #define IEEE80211_VHT_CAP_RXLDPC				0x00000010
>  #define IEEE80211_VHT_CAP_SHORT_GI_80				0x00000020
>  #define IEEE80211_VHT_CAP_SHORT_GI_160				0x00000040
> @@ -1575,6 +1586,96 @@ struct ieee80211_vht_operation {
>  #define IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_MRQ_MFB	0x0c000000
>  #define IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN			0x10000000
>  #define IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN			0x20000000
> +#define IEEE80211_VHT_CAP_EXT_NSS_BW_SHIFT			30
> +#define IEEE80211_VHT_CAP_EXT_NSS_BW_MASK			0xc0000000
> +
> +static int __maybe_unused
> +ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
> +			  enum ieee80211_vht_chanwidth bw,
> +			  int mcs)
> +{
> +	u16 map = le16_to_cpu(cap->supp_mcs.rx_mcs_map);
> +	int max_vht_nss;
> +	int ext_nss_bw;
> +	int supp_width;
> +	int i, mcs_encoding;
> +
> +	if (map == 0xffff)
> +		return 0;
> +
> +	if (WARN_ON(mcs > 9))
> +		return 0;
> +	if (mcs <= 7)
> +		mcs_encoding = 0;
> +	else if (mcs == 8)
> +		mcs_encoding = 1;
> +	else
> +		mcs_encoding = 2;
> +
> +	/* find max_vht_nss for the given MCS */
> +	for (i = 7; i >= 0; i--) {
> +		int supp = (map >> (2*i)) & 3;
> +
> +		if (supp == 3)
> +			continue;
> +
> +		if (supp >= mcs_encoding) {
> +			max_vht_nss = i;
> +			break;
> +		}
> +	}
> +
> +	if (!(cap->supp_mcs.tx_mcs_map & cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE)))
> +		return max_vht_nss;
> +
> +	ext_nss_bw = (le32_to_cpu(cap->vht_cap_info) &
> +					IEEE80211_VHT_CAP_EXT_NSS_BW_MASK)
> +			>> IEEE80211_VHT_CAP_EXT_NSS_BW_SHIFT;
> +	supp_width = (le32_to_cpu(cap->vht_cap_info) &
> +					IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK)
> +			>> IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_SHIFT;
> +
> +	/*
> +	 * Cover all the special cases according to IEEE 802.11-2016 Table 9-250.
> +	 * All other cases are either factor of 1 or not valid/supported.
> +	 */
> +	switch (bw) {
> +	case IEEE80211_VHT_CHANWIDTH_USE_HT:
> +	case IEEE80211_VHT_CHANWIDTH_80MHZ:
> +		if ((supp_width == 1 || supp_width == 2) &&
> +		    ext_nss_bw == 3)
> +			return 2 * max_vht_nss;
> +		break;
> +	case IEEE80211_VHT_CHANWIDTH_160MHZ:
> +		if (supp_width == 0 &&
> +		    (ext_nss_bw == 1 || ext_nss_bw == 2))
> +			return DIV_ROUND_UP(max_vht_nss, 2);
> +		if (supp_width == 0 &&
> +		    ext_nss_bw == 3)
> +			return DIV_ROUND_UP(3 * max_vht_nss, 4);
> +		if (supp_width == 1 &&
> +		    ext_nss_bw == 3)
> +			return 2 * max_vht_nss;
> +		break;
> +	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
> +		if (supp_width == 0 &&
> +		    ext_nss_bw == 2)
> +			return DIV_ROUND_UP(max_vht_nss, 2);
> +		if (supp_width == 0 &&
> +		    ext_nss_bw == 3)
> +			return DIV_ROUND_UP(3 * max_vht_nss, 4);
> +		if (supp_width == 1 &&
> +		    ext_nss_bw == 1)
> +			return DIV_ROUND_UP(max_vht_nss, 2);
> +		if (supp_width == 1 &&
> +		    ext_nss_bw == 2)
> +			return DIV_ROUND_UP(3 * max_vht_nss, 4);
> +		break;
> +	}

Looks good to me.

> +	/* not covered or invalid combination received */

Do you want to inform about the invalid/reserved combination.

Regards,
Arend

> +	return max_vht_nss;
> +}
>  
>  /* Authentication algorithms */
>  #define WLAN_AUTH_OPEN 0
> 
