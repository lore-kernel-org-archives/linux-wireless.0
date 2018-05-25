Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46120 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965450AbeEYKLf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 06:11:35 -0400
Message-ID: <b1d344f5f5fa2797fa5b931f019bb7f3bd18b904.camel@coelho.fi> (sfid-20180525_121159_665120_6AA8CDEA)
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Ido Yariv <idox.yariv@intel.com>
Date: Fri, 25 May 2018 13:11:28 +0300
In-Reply-To: <5B032249.2020900@broadcom.com>
References: <20180518140543.13620-1-luca@coelho.fi>
         <20180518140543.13620-2-luca@coelho.fi> <5B032249.2020900@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [RFC 1/3] cfg80211: Add support for HE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Mon, 2018-05-21 at 21:47 +0200, Arend van Spriel wrote:
> On 5/18/2018 4:05 PM, Luca Coelho wrote:
> > From: Luca Coelho <luciano.coelho@intel.com>
> > 
> > Add support for the HE in cfg80211 and also add userspace API to
> > nl80211 to send rate information out, conforming with
> > P802.11ax_D1.4.
> 
> A couple of things changed in D2.0 so does it make sense to
> introduce 
> stuff from older draft?

That was my mistake.  We support D2.0, it's just that the changes for
D2.0 were mixed in an iwlwifi driver patch and I missed it.


> > +/**
> > + * struct ieee80211_he_mcs_nss_supp - HE Tx/Rx HE MCS NSS Support Field
> > + *
> > + * This structure holds the data required for the Tx/Rx HE MCS NSS Support Field
> > + * described in P802.11ax_D1.4 section 9.4.2.237.4
> > + *
> > + * @rx_msc_80: Rx MCS map 2 bits for each stream, total 8 streams, for channel
> > + *     widths less than 80MHz.
> > + * @tx_msc_80: Tx MCS map 2 bits for each stream, total 8 streams, for channel
> > + *     widths less than 80MHz.
> > + * @rx_msc_160: Rx MCS map 2 bits for each stream, total 8 streams, for channel
> > + *     width 160MHz.
> > + * @tx_msc_160: Tx MCS map 2 bits for each stream, total 8 streams, for channel
> > + *     width 160MHz.
> > + * @rx_msc_80p80: Rx MCS map 2 bits for each stream, total 8 streams, for
> > + *     channel width 80p80MHz.
> > + * @tx_msc_80p80: Tx MCS map 2 bits for each stream, total 8 streams, for
> > + *     channel width 80p80MHz.
> > + */
> > +struct ieee80211_he_mcs_nss_supp {
> > +	__le16 rx_msc_80;
> 
> Should 'msc' in these fields be 'mcs'?

Certainly, it's a typo and I'll fix it.


> > +	__le16 tx_msc_80;
> > +	__le16 rx_msc_160;
> > +	__le16 tx_msc_160;
> > +	__le16 rx_msc_80p80;
> > +	__le16 tx_msc_80p80;
> > +} __packed;
> > +
> > +/**
> > + * struct ieee80211_he_operation - HE capabilities element
> > + *
> > + * This structure is the "HE operation element" fields as
> > + * described in P802.11ax_D1.4 section 9.4.2.238
> > + */
> > +struct ieee80211_he_operation {
> > +	__le32 he_oper_params;
> > +	__le16 he_mcs_nss_set;
> > +	/* Optional 0,1,3 or 4 bytes: depends on %he_oper_params */
> > +	u8 optional[0];
> > +} __packed;
> 
> If I recall correctly the he operation element changed significantly in 
> later revisions of the spec. So do we want to introduce (stale) D1.4 
> stuff when currently at D2.3?

Yeah, in our internal tree we support D2.0 and I'll update accordingly.
 Do you think it's okay to support D2.0 for now and update to D2.3 if
needed later on? I don't really know how much changed between these
versions...


> > +/* Link adaptation is split between byte #2 and byte #3. It should
> > be set only
> > + * if IEEE80211_HE_MAC_CAP0_HTC_HE in which case the following values apply:
> > + * 0 = No feedback.
> > + * 1 = reserved.
> > + * 2 = Unsolicited feedback.
> > + * 3 = both
> > + */
> > +#define IEEE80211_HE_MAC_CAP1_LINK_ADAPTATION			0x80
> 
> This is confusing. I suspect 'byte #2' is HE_MAC_CAP1 and 'byte #3' is 
> HE_MAC_CAP2. Just refer to that instead of the byte-number reference.

Right, I'll do it.


> > +/**
> > + * struct ieee80211_sband_iftype_data
> > + *
> > + * This structure encapsulates sband data that is relevant for the interface
> > + * types defined in %types
> > + *
> > + * @types: interface types (bits)
> 
> maybe better named @types_mask.

Makes sense.


> > +/**
> > + * ieee80211_get_sband_ift_data - return sband data for a given iftype
> > + * @sband: the sband to search for the STA on
> > + * @iftype: enum nl80211_iftype
> > + *
> > + * Return: pointer to the struct ieee80211_sband_iftype_data, or NULL is none found
> > + */
> > +static inline const struct ieee80211_sband_iftype_data *
> > +ieee80211_get_sband_ift_data(const struct ieee80211_supported_band *sband,
> 
> Just call this function ieee80211_get_sband_iftype_data. It's only 3 
> additional chars.

Yeah, I bumped into this in one of the internal reviews, but didn't
bother.  But you're right, iftype is better.


@@ -781,6 +783,23 @@ int wiphy_register(struct wiphy *wiphy)
> >   			sband->channels[i].band = band;
> >   		}
> > 
> > +		for (i = 0; i < sband->n_iftype_data; i++) {
> > +			const struct ieee80211_sband_iftype_data *iftd;
> > +
> > +			iftd = &sband->iftype_data[i];
> > +
> > +			if (WARN_ON(!iftd->types))
> > +				return -EINVAL;
> > +			if (WARN_ON(types & iftd->types))
> > +				return -EINVAL;
> 
> I suspected the types mask was not allowed to overlap for the 
> iftype_data entries, but may be worth documenting that in struct 
> ieee80211_sband_iftype_data kerneldoc.

Sure, I'll add it.


> > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> > index f7715b85fd2b..661728dbf989 100644
> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -428,6 +428,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
> >   	[NL80211_ATTR_TXQ_LIMIT] = { .type = NLA_U32 },
> >   	[NL80211_ATTR_TXQ_MEMORY_LIMIT] = { .type = NLA_U32 },
> >   	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
> > +	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
> > +					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
> >   };
> > 
> >   /* policy for the key attributes */
> > @@ -1324,6 +1326,34 @@ static int nl80211_send_coalesce(struct sk_buff *msg,
> >   	return 0;
> >   }
> > 
> > +static int
> > +nl80211_send_ift_data(struct sk_buff *msg,
> > +		      const struct ieee80211_sband_iftype_data *iftdata)
> 
> make it nl80211_send_iftype_data.

Okay, I'll replace all ift instances to iftype.


> >   static int nl80211_send_band_rateinfo(struct sk_buff *msg,
> >   				      struct ieee80211_supported_band *sband)
> >   {
> > @@ -1353,6 +1383,32 @@ static int nl80211_send_band_rateinfo(struct sk_buff *msg,
> >   			 sband->vht_cap.cap)))
> >   		return -ENOBUFS;
> > 
> > +	if (sband->n_iftype_data) {
> > +		struct nlattr *nl_iftype_data =
> > +			nla_nest_start(msg, NL80211_BAND_ATTR_IFTYPE_DATA);
> > +		int err;
> > +
> > +		if (!nl_iftype_data)
> > +			return -ENOBUFS;
> > +
> > +		for (i = 0; i < sband->n_iftype_data; i++) {
> > +			struct nlattr *iftdata;
> > +
> > +			iftdata = nla_nest_start(msg, i + 1);
> > +			if (!iftdata)
> > +				return -ENOBUFS;
> 
> bit inconsistent dealing with error path. Here errno is returned....
> 
> > @@ -4490,6 +4549,19 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
> >   		if (info->flags & RATE_INFO_FLA
  			return false;
> > +	} else if (info->flags & RATE_INFO_FLAGS_HE_MCS) {
> > +		if (nla_put_u8(msg, NL80211_RATE_INFO_HE_MCS, info->mcs))
> > +			return false;
> 
> ... and here bool is returned. Admittedly, this seems to have been the
> case already before this patch.

Yeah, so I'll leave it like this, ok?


> > diff --git a/net/wireless/util.c b/net/wireless/util.c
> > index d112e9a89364..b66a68a41cd6 100644
> > --- a/net/wireless/util.c
> > +++ b/net/wireless/util.c
> > @@ -4,6 +4,7 @@
> >    *
> >    * Copyright 2007-2009	Johannes Berg <johannes@sipsolutions.net>
> >    * Copyright 2013-2014  Intel Mobile Communications GmbH
> > + * Copyright 2017	Intel Deutschland GmbH
> >    */
> >   #include <linux/export.h>
> >   #include <linux/bitops.h>
> > @@ -1142,6 +1143,85 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
> >   	return 0;
> >   }
> > 
> > +static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
> > +{
> > +#define SCALE 2048
> > +	u16 mcs_divisors[12] = {
> > +		34133, /* 16.666666... */
> > +		17067, /*  8.333333... */
> > +		11378, /*  5.555555... */
> > +		 8533, /*  4.166666... */
> > +		 5689, /*  2.777777... */
> > +		 4267, /*  2.083333... */
> > +		 3923, /*  1.851851... */
> > +		 3413, /*  1.666666... */
> > +		 2844, /*  1.388888... */
> > +		 2560, /*  1.250000... */
> > +		 2276, /*  1.111111... */
> > +		 2048, /*  1.000000... */
> > +	};
> > +	u32 rates_160M[3] = { 960777777, 907400000, 816666666 };
> > +	u32 rates_969[3] =  { 480388888, 453700000, 408333333 };
> > +	u32 rates_484[3] =  { 229411111, 216666666, 195000000 };
> > +	u32 rates_242[3] =  { 114711111, 108333333,  97500000 };
> > +	u32 rates_106[3] =  {  40000000,  37777777,  34000000 };
> > +	u32 rates_52[3]  =  {  18820000,  17777777,  16000000 };
> > +	u32 rates_26[3]  =  {   9411111,   8888888,   8000000 };
> > +	u64 tmp;
> > +	u32 result;
> > +
> > +	if (WARN_ON_ONCE(rate->mcs > 11))
> > +		return 0;
> > +
> > +	if (WARN_ON_ONCE(rate->he_gi > NL80211_RATE_INFO_HE_GI_3_2))
> > +		return 0;
> > +	if (WARN_ON_ONCE(rate->he_ru_alloc >
> > +			 NL80211_RATE_INFO_HE_RU_ALLOC_2x996))
> > +		return 0;
> > +	if (WARN_ON_ONCE(rate->nss < 1 || rate->nss > 8))
> > +		return 0;
> > +
> > +	if (rate->bw == RATE_INFO_BW_160)
> > +		result = rates_160M[rate->he_gi];
> > +	else if (rate->bw == RATE_INFO_BW_80 ||
> > +		 (rate->bw == RATE_INFO_BW_HE_RU &&
> > +		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_996))
> > +		result = rates_969[rate->he_gi];
> > +	else if (rate->bw == RATE_INFO_BW_40 ||
> > +		 (rate->bw == RATE_INFO_BW_HE_RU &&
> > +		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_484))
> > +		result = rates_484[rate->he_gi];
> > +	else if (rate->bw == RATE_INFO_BW_20 ||
> > +		 (rate->bw == RATE_INFO_BW_HE_RU &&
> > +		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_242))
> > +		result = rates_242[rate->he_gi];
> > +	else if (rate->bw == RATE_INFO_BW_HE_RU &&
> > +		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_106)
> > +		result = rates_106[rate->he_gi];
> > +	else if (rate->bw == RATE_INFO_BW_HE_RU &&
> > +		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_52)
> > +		result = rates_52[rate->he_gi];
> > +	else if (rate->bw == RATE_INFO_BW_HE_RU &&
> > +		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_26)
> > +		result = rates_26[rate->he_gi];
> > +	else if (WARN(1, "invalid HE MCS: bw:%d, ru:%d\n",
> > +		      rate->bw, rate->he_ru_alloc))
> > +		return 0;
> > +
> 
> Could consider shifts below iso multiply/division.

> > +     /* now scale to the appropriate MCS */
> > +     tmp = result;
> > +     tmp *= SCALE;
>         tmp <<= 11;
> > +     do_div(tmp, mcs_divisors[rate->mcs]);
> > +     result = tmp;
> > +
> > +     /* and take NSS, DCM into account */
> > +     result = (result * rate->nss) / 8;
>         result = (result * rate->nss) >> 3;
> > +     if (rate->he_dcm)
> > +             result /= 2;
>                 result >>= 1;
> > +
> > +     return result;
> > +}
> > +

I'm not sure I agree.  These are divisions and not really shifts, so
IMHO it's clearer as is.  This is not a hot path and the compiler will
probably optimize it in to shifts if possible anyway.  So I won't
change it in my next version.  Feel free to yell if you disagree (and
have a good argument :P).

Thanks a lot for your review!


--
Cheers,
Luca.
