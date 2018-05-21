Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37361 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbeEUTrW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 15:47:22 -0400
Received: by mail-wm0-f68.google.com with SMTP id l1-v6so28655862wmb.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 12:47:21 -0700 (PDT)
Subject: Re: [RFC 1/3] cfg80211: Add support for HE
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
References: <20180518140543.13620-1-luca@coelho.fi>
 <20180518140543.13620-2-luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Ido Yariv <idox.yariv@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B032249.2020900@broadcom.com> (sfid-20180521_214727_475694_5C031079)
Date: Mon, 21 May 2018 21:47:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180518140543.13620-2-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/18/2018 4:05 PM, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
>
> Add support for the HE in cfg80211 and also add userspace API to
> nl80211 to send rate information out, conforming with P802.11ax_D1.4.

A couple of things changed in D2.0 so does it make sense to introduce 
stuff from older draft?

> Additionally, remove the IEEE80211_MAX_AMPDU_BUF definition from some
> realtek drivers in staging because they are now conflicting with the
> new definitions and are not used anyway.
>
> Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> Signed-off-by: Ido Yariv <idox.yariv@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>   drivers/staging/rtl8188eu/include/wifi.h |   1 -
>   drivers/staging/rtl8712/wifi.h           |   1 -
>   drivers/staging/rtl8723bs/include/wifi.h |   1 -
>   include/linux/ieee80211.h                | 431 ++++++++++++++++++++++-
>   include/net/cfg80211.h                   | 102 +++++-
>   include/uapi/linux/nl80211.h             |  87 ++++-
>   net/wireless/core.c                      |  21 +-
>   net/wireless/nl80211.c                   |  99 +++++-
>   net/wireless/util.c                      |  82 +++++
>   9 files changed, 813 insertions(+), 12 deletions(-)

[snip]

> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 8fe7e4306816..7e1a650be329 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h

[snip]

> +/**
> + * struct ieee80211_he_mcs_nss_supp - HE Tx/Rx HE MCS NSS Support Field
> + *
> + * This structure holds the data required for the Tx/Rx HE MCS NSS Support Field
> + * described in P802.11ax_D1.4 section 9.4.2.237.4
> + *
> + * @rx_msc_80: Rx MCS map 2 bits for each stream, total 8 streams, for channel
> + *     widths less than 80MHz.
> + * @tx_msc_80: Tx MCS map 2 bits for each stream, total 8 streams, for channel
> + *     widths less than 80MHz.
> + * @rx_msc_160: Rx MCS map 2 bits for each stream, total 8 streams, for channel
> + *     width 160MHz.
> + * @tx_msc_160: Tx MCS map 2 bits for each stream, total 8 streams, for channel
> + *     width 160MHz.
> + * @rx_msc_80p80: Rx MCS map 2 bits for each stream, total 8 streams, for
> + *     channel width 80p80MHz.
> + * @tx_msc_80p80: Tx MCS map 2 bits for each stream, total 8 streams, for
> + *     channel width 80p80MHz.
> + */
> +struct ieee80211_he_mcs_nss_supp {
> +	__le16 rx_msc_80;

Should 'msc' in these fields be 'mcs'?

> +	__le16 tx_msc_80;
> +	__le16 rx_msc_160;
> +	__le16 tx_msc_160;
> +	__le16 rx_msc_80p80;
> +	__le16 tx_msc_80p80;
> +} __packed;
> +
> +/**
> + * struct ieee80211_he_operation - HE capabilities element
> + *
> + * This structure is the "HE operation element" fields as
> + * described in P802.11ax_D1.4 section 9.4.2.238
> + */
> +struct ieee80211_he_operation {
> +	__le32 he_oper_params;
> +	__le16 he_mcs_nss_set;
> +	/* Optional 0,1,3 or 4 bytes: depends on %he_oper_params */
> +	u8 optional[0];
> +} __packed;

If I recall correctly the he operation element changed significantly in 
later revisions of the spec. So do we want to introduce (stale) D1.4 
stuff when currently at D2.3?

> +/**
> + * struct ieee80211_he_mu_edca_param_ac_rec - MU AC Parameter Record field
> + *
> + * This structure is the "MU AC Parameter Record" fields as
> + * described in P802.11ax_D1.4 section 9.4.2.240
> + */

[snip]

> @@ -1577,6 +1679,322 @@ struct ieee80211_vht_operation {
>   #define IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN			0x10000000
>   #define IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN			0x20000000
>
> +/* 802.11ax HE MAC capabilities */
> +#define IEEE80211_HE_MAC_CAP0_HTC_HE				0x01

[snip]

> +
> +/* Link adaptation is split between byte #2 and byte #3. It should be set only
> + * if IEEE80211_HE_MAC_CAP0_HTC_HE in which case the following values apply:
> + * 0 = No feedback.
> + * 1 = reserved.
> + * 2 = Unsolicited feedback.
> + * 3 = both
> + */
> +#define IEEE80211_HE_MAC_CAP1_LINK_ADAPTATION			0x80

This is confusing. I suspect 'byte #2' is HE_MAC_CAP1 and 'byte #3' is 
HE_MAC_CAP2. Just refer to that instead of the byte-number reference.

> +#define IEEE80211_HE_MAC_CAP2_LINK_ADAPTATION			0x01
> +#define IEEE80211_HE_MAC_CAP2_ALL_ACK				0x02
> +#define IEEE80211_HE_MAC_CAP2_UL_MU_RESP_SCHED			0x04

[snip]

> +/**
> + * struct ieee80211_sband_iftype_data
> + *
> + * This structure encapsulates sband data that is relevant for the interface
> + * types defined in %types
> + *
> + * @types: interface types (bits)

maybe better named @types_mask.

> + * @he_cap: holds the HE capabilities
> + */
> +struct ieee80211_sband_iftype_data {
> +	u16 types;
> +	struct ieee80211_sta_he_cap he_cap;
> +};
> +
>   /**
>    * struct ieee80211_supported_band - frequency band definition
>    *
> @@ -301,6 +335,8 @@ struct ieee80211_sta_vht_cap {
>    * @n_bitrates: Number of bitrates in @bitrates
>    * @ht_cap: HT capabilities in this band
>    * @vht_cap: VHT capabilities in this band
> + * @n_iftype_data: number of iftype data entries
> + * @iftype_data: interface type data entries
>    */
>   struct ieee80211_supported_band {
>   	struct ieee80211_channel *channels;
> @@ -310,8 +346,55 @@ struct ieee80211_supported_band {
>   	int n_bitrates;
>   	struct ieee80211_sta_ht_cap ht_cap;
>   	struct ieee80211_sta_vht_cap vht_cap;
> +	u16 n_iftype_data;
> +	const struct ieee80211_sband_iftype_data *iftype_data;
>   };
>
> +/**
> + * ieee80211_get_sband_ift_data - return sband data for a given iftype
> + * @sband: the sband to search for the STA on
> + * @iftype: enum nl80211_iftype
> + *
> + * Return: pointer to the struct ieee80211_sband_iftype_data, or NULL is none found
> + */
> +static inline const struct ieee80211_sband_iftype_data *
> +ieee80211_get_sband_ift_data(const struct ieee80211_supported_band *sband,

Just call this function ieee80211_get_sband_iftype_data. It's only 3 
additional chars.

> +			     u8 iftype)
> +{
> +	int i;
> +
> +	if (WARN_ON(iftype >= NL80211_IFTYPE_MAX))
> +		return NULL;
> +
> +	for (i = 0; i < sband->n_iftype_data; i++)  {
> +		const struct ieee80211_sband_iftype_data *data =
> +			&sband->iftype_data[i];
> +
> +		if (data->types & BIT(iftype))
> +			return data;
> +	}
> +
> +	return NULL;
> +}

[snip]

> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index a6f3cac8c640..848d16631643 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c

[snip]

> @@ -781,6 +783,23 @@ int wiphy_register(struct wiphy *wiphy)
>   			sband->channels[i].band = band;
>   		}
>
> +		for (i = 0; i < sband->n_iftype_data; i++) {
> +			const struct ieee80211_sband_iftype_data *iftd;
> +
> +			iftd = &sband->iftype_data[i];
> +
> +			if (WARN_ON(!iftd->types))
> +				return -EINVAL;
> +			if (WARN_ON(types & iftd->types))
> +				return -EINVAL;

I suspected the types mask was not allowed to overlap for the 
iftype_data entries, but may be worth documenting that in struct 
ieee80211_sband_iftype_data kerneldoc.

> +			/* at least one piece of information must be present */
> +			if (WARN_ON(!iftd->he_cap.has_he))
> +				return -EINVAL;
> +
> +			types |= iftd->types;
> +		}
> +
>   		have_band = true;
>   	}
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index f7715b85fd2b..661728dbf989 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -428,6 +428,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
>   	[NL80211_ATTR_TXQ_LIMIT] = { .type = NLA_U32 },
>   	[NL80211_ATTR_TXQ_MEMORY_LIMIT] = { .type = NLA_U32 },
>   	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
> +	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
> +					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
>   };
>
>   /* policy for the key attributes */
> @@ -1324,6 +1326,34 @@ static int nl80211_send_coalesce(struct sk_buff *msg,
>   	return 0;
>   }
>
> +static int
> +nl80211_send_ift_data(struct sk_buff *msg,
> +		      const struct ieee80211_sband_iftype_data *iftdata)

make it nl80211_send_iftype_data.

> +{
> +	const struct ieee80211_sta_he_cap *he_cap = &iftdata->he_cap;
> +
> +	if (nl80211_put_iftypes(msg, NL80211_BAND_IFT_ATTR_IFTYPES,
> +				iftdata->types))
> +		return -ENOBUFS;
> +
> +	if (he_cap->has_he) {
> +		if (nla_put(msg, NL80211_BAND_IFT_ATTR_HE_CAP_MAC,
> +			    sizeof(he_cap->he_cap_elem.mac_cap_info),
> +			    he_cap->he_cap_elem.mac_cap_info) ||
> +		    nla_put(msg, NL80211_BAND_IFT_ATTR_HE_CAP_PHY,
> +			    sizeof(he_cap->he_cap_elem.phy_cap_info),
> +			    he_cap->he_cap_elem.phy_cap_info) ||
> +		    nla_put(msg, NL80211_BAND_IFT_ATTR_HE_CAP_MCS_SET,
> +			    sizeof(he_cap->he_mcs_nss_supp),
> +			    &he_cap->he_mcs_nss_supp) ||
> +		    nla_put(msg, NL80211_BAND_IFT_ATTR_HE_CAP_PPE,
> +			    sizeof(he_cap->ppe_thres), he_cap->ppe_thres))
> +			return -ENOBUFS;
> +	}
> +
> +	return 0;
> +}
> +
>   static int nl80211_send_band_rateinfo(struct sk_buff *msg,
>   				      struct ieee80211_supported_band *sband)
>   {
> @@ -1353,6 +1383,32 @@ static int nl80211_send_band_rateinfo(struct sk_buff *msg,
>   			 sband->vht_cap.cap)))
>   		return -ENOBUFS;
>
> +	if (sband->n_iftype_data) {
> +		struct nlattr *nl_iftype_data =
> +			nla_nest_start(msg, NL80211_BAND_ATTR_IFTYPE_DATA);
> +		int err;
> +
> +		if (!nl_iftype_data)
> +			return -ENOBUFS;
> +
> +		for (i = 0; i < sband->n_iftype_data; i++) {
> +			struct nlattr *iftdata;
> +
> +			iftdata = nla_nest_start(msg, i + 1);
> +			if (!iftdata)
> +				return -ENOBUFS;

bit inconsistent dealing with error path. Here errno is returned....

> +			err = nl80211_send_ift_data(msg,
> +						    &sband->iftype_data[i]);
> +			if (err)
> +				return err;
> +
> +			nla_nest_end(msg, iftdata);
> +		}
> +
> +		nla_nest_end(msg, nl_iftype_data);
> +	}
> +
>   	/* add bitrates */
>   	nl_rates = nla_nest_start(msg, NL80211_BAND_ATTR_RATES);
>   	if (!nl_rates)
> @@ -4471,6 +4527,9 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
>   	case RATE_INFO_BW_160:
>   		rate_flg = NL80211_RATE_INFO_160_MHZ_WIDTH;
>   		break;
> +	case RATE_INFO_BW_HE_RU:
> +		rate_flg = 0;
> +		WARN_ON(!(info->flags & RATE_INFO_FLAGS_HE_MCS));
>   	}
>
>   	if (rate_flg && nla_put_flag(msg, rate_flg))
> @@ -4490,6 +4549,19 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
>   		if (info->flags & RATE_INFO_FLAGS_SHORT_GI &&
>   		    nla_put_flag(msg, NL80211_RATE_INFO_SHORT_GI))
>   			return false;
> +	} else if (info->flags & RATE_INFO_FLAGS_HE_MCS) {
> +		if (nla_put_u8(msg, NL80211_RATE_INFO_HE_MCS, info->mcs))
> +			return false;

... and here bool is returned. Admittedly, this seems to have been the 
case already before this patch.

> +		if (nla_put_u8(msg, NL80211_RATE_INFO_HE_NSS, info->nss))
> +			return false;
> +		if (nla_put_u8(msg, NL80211_RATE_INFO_HE_GI, info->he_gi))
> +			return false;
> +		if (nla_put_u8(msg, NL80211_RATE_INFO_HE_DCM, info->he_dcm))
> +			return false;
> +		if (info->bw == RATE_INFO_BW_HE_RU &&
> +		    nla_put_u8(msg, NL80211_RATE_INFO_HE_RU_ALLOC,
> +			       info->he_ru_alloc))
> +			return false;
>   	}
>
>   	nla_nest_end(msg, rate);

[snip]

> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index d112e9a89364..b66a68a41cd6 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -4,6 +4,7 @@
>    *
>    * Copyright 2007-2009	Johannes Berg <johannes@sipsolutions.net>
>    * Copyright 2013-2014  Intel Mobile Communications GmbH
> + * Copyright 2017	Intel Deutschland GmbH
>    */
>   #include <linux/export.h>
>   #include <linux/bitops.h>
> @@ -1142,6 +1143,85 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
>   	return 0;
>   }
>
> +static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
> +{
> +#define SCALE 2048
> +	u16 mcs_divisors[12] = {
> +		34133, /* 16.666666... */
> +		17067, /*  8.333333... */
> +		11378, /*  5.555555... */
> +		 8533, /*  4.166666... */
> +		 5689, /*  2.777777... */
> +		 4267, /*  2.083333... */
> +		 3923, /*  1.851851... */
> +		 3413, /*  1.666666... */
> +		 2844, /*  1.388888... */
> +		 2560, /*  1.250000... */
> +		 2276, /*  1.111111... */
> +		 2048, /*  1.000000... */
> +	};
> +	u32 rates_160M[3] = { 960777777, 907400000, 816666666 };
> +	u32 rates_969[3] =  { 480388888, 453700000, 408333333 };
> +	u32 rates_484[3] =  { 229411111, 216666666, 195000000 };
> +	u32 rates_242[3] =  { 114711111, 108333333,  97500000 };
> +	u32 rates_106[3] =  {  40000000,  37777777,  34000000 };
> +	u32 rates_52[3]  =  {  18820000,  17777777,  16000000 };
> +	u32 rates_26[3]  =  {   9411111,   8888888,   8000000 };
> +	u64 tmp;
> +	u32 result;
> +
> +	if (WARN_ON_ONCE(rate->mcs > 11))
> +		return 0;
> +
> +	if (WARN_ON_ONCE(rate->he_gi > NL80211_RATE_INFO_HE_GI_3_2))
> +		return 0;
> +	if (WARN_ON_ONCE(rate->he_ru_alloc >
> +			 NL80211_RATE_INFO_HE_RU_ALLOC_2x996))
> +		return 0;
> +	if (WARN_ON_ONCE(rate->nss < 1 || rate->nss > 8))
> +		return 0;
> +
> +	if (rate->bw == RATE_INFO_BW_160)
> +		result = rates_160M[rate->he_gi];
> +	else if (rate->bw == RATE_INFO_BW_80 ||
> +		 (rate->bw == RATE_INFO_BW_HE_RU &&
> +		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_996))
> +		result = rates_969[rate->he_gi];
> +	else if (rate->bw == RATE_INFO_BW_40 ||
> +		 (rate->bw == RATE_INFO_BW_HE_RU &&
> +		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_484))
> +		result = rates_484[rate->he_gi];
> +	else if (rate->bw == RATE_INFO_BW_20 ||
> +		 (rate->bw == RATE_INFO_BW_HE_RU &&
> +		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_242))
> +		result = rates_242[rate->he_gi];
> +	else if (rate->bw == RATE_INFO_BW_HE_RU &&
> +		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_106)
> +		result = rates_106[rate->he_gi];
> +	else if (rate->bw == RATE_INFO_BW_HE_RU &&
> +		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_52)
> +		result = rates_52[rate->he_gi];
> +	else if (rate->bw == RATE_INFO_BW_HE_RU &&
> +		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_26)
> +		result = rates_26[rate->he_gi];
> +	else if (WARN(1, "invalid HE MCS: bw:%d, ru:%d\n",
> +		      rate->bw, rate->he_ru_alloc))
> +		return 0;
> +

Could consider shifts below iso multiply/division.

> +	/* now scale to the appropriate MCS */
> +	tmp = result;
> +	tmp *= SCALE;
	tmp <<= 11;
> +	do_div(tmp, mcs_divisors[rate->mcs]);
> +	result = tmp;
> +
> +	/* and take NSS, DCM into account */
> +	result = (result * rate->nss) / 8;
	result = (result * rate->nss) >> 3;
> +	if (rate->he_dcm)
> +		result /= 2;
		result >>= 1;
> +
> +	return result;
> +}
> +
>   u32 cfg80211_calculate_bitrate(struct rate_info *rate)
>   {
>   	if (rate->flags & RATE_INFO_FLAGS_MCS)
> @@ -1150,6 +1230,8 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate)
>   		return cfg80211_calculate_bitrate_60g(rate);
>   	if (rate->flags & RATE_INFO_FLAGS_VHT_MCS)
>   		return cfg80211_calculate_bitrate_vht(rate);
> +	if (rate->flags & RATE_INFO_FLAGS_HE_MCS)
> +		return cfg80211_calculate_bitrate_he(rate);
>
>   	return rate->legacy;
>   }
>
