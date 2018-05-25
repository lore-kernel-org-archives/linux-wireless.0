Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:43862 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965305AbeEYKe6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 06:34:58 -0400
Received: by mail-qt0-f180.google.com with SMTP id f13-v6so5893389qtp.10
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 03:34:58 -0700 (PDT)
Subject: Re: [RFC 1/3] cfg80211: Add support for HE
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
References: <20180518140543.13620-1-luca@coelho.fi>
 <20180518140543.13620-2-luca@coelho.fi> <5B032249.2020900@broadcom.com>
 <b1d344f5f5fa2797fa5b931f019bb7f3bd18b904.camel@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Ido Yariv <idox.yariv@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B07E6CF.8070000@broadcom.com> (sfid-20180525_123527_836153_CA91E8DB)
Date: Fri, 25 May 2018 12:34:55 +0200
MIME-Version: 1.0
In-Reply-To: <b1d344f5f5fa2797fa5b931f019bb7f3bd18b904.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/25/2018 12:11 PM, Luca Coelho wrote:
>>> +static int
>>> > >+nl80211_send_ift_data(struct sk_buff *msg,
>>> > >+		      const struct ieee80211_sband_iftype_data *iftdata)
>> >
>> >make it nl80211_send_iftype_data.
> Okay, I'll replace all ift instances to iftype.

My comment is mainly about function names.

>>> > >   static int nl80211_send_band_rateinfo(struct sk_buff *msg,
>>> > >   				      struct ieee80211_supported_band *sband)
>>> > >   {
>>> > >@@ -1353,6 +1383,32 @@ static int nl80211_send_band_rateinfo(struct sk_buff *msg,
>>> > >   			 sband->vht_cap.cap)))
>>> > >   		return -ENOBUFS;
>>> > >
>>> > >+	if (sband->n_iftype_data) {
>>> > >+		struct nlattr *nl_iftype_data =
>>> > >+			nla_nest_start(msg, NL80211_BAND_ATTR_IFTYPE_DATA);
>>> > >+		int err;
>>> > >+
>>> > >+		if (!nl_iftype_data)
>>> > >+			return -ENOBUFS;
>>> > >+
>>> > >+		for (i = 0; i < sband->n_iftype_data; i++) {
>>> > >+			struct nlattr *iftdata;
>>> > >+
>>> > >+			iftdata = nla_nest_start(msg, i + 1);
>>> > >+			if (!iftdata)
>>> > >+				return -ENOBUFS;
>> >
>> >bit inconsistent dealing with error path. Here errno is returned....
>> >
>>> > >@@ -4490,6 +4549,19 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
>>> > >   		if (info->flags & RATE_INFO_FLA
>    			return false;
>>> > >+	} else if (info->flags & RATE_INFO_FLAGS_HE_MCS) {
>>> > >+		if (nla_put_u8(msg, NL80211_RATE_INFO_HE_MCS, info->mcs))
>>> > >+			return false;
>> >
>> >... and here bool is returned. Admittedly, this seems to have been the
>> >case already before this patch.

Sure.

>
>>> > >diff --git a/net/wireless/util.c b/net/wireless/util.c
>>> > >index d112e9a89364..b66a68a41cd6 100644
>>> > >--- a/net/wireless/util.c
>>> > >+++ b/net/wireless/util.c
>>> > >@@ -4,6 +4,7 @@
>>> > >    *
>>> > >    * Copyright 2007-2009	Johannes Berg<johannes@sipsolutions.net>
>>> > >    * Copyright 2013-2014  Intel Mobile Communications GmbH
>>> > >+ * Copyright 2017	Intel Deutschland GmbH
>>> > >    */
>>> > >   #include <linux/export.h>
>>> > >   #include <linux/bitops.h>
>>> > >@@ -1142,6 +1143,85 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
>>> > >   	return 0;
>>> > >   }
>>> > >
>>> > >+static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
>>> > >+{
>>> > >+#define SCALE 2048
>>> > >+	u16 mcs_divisors[12] = {
>>> > >+		34133, /* 16.666666... */
>>> > >+		17067, /*  8.333333... */
>>> > >+		11378, /*  5.555555... */
>>> > >+		 8533, /*  4.166666... */
>>> > >+		 5689, /*  2.777777... */
>>> > >+		 4267, /*  2.083333... */
>>> > >+		 3923, /*  1.851851... */
>>> > >+		 3413, /*  1.666666... */
>>> > >+		 2844, /*  1.388888... */
>>> > >+		 2560, /*  1.250000... */
>>> > >+		 2276, /*  1.111111... */
>>> > >+		 2048, /*  1.000000... */
>>> > >+	};
>>> > >+	u32 rates_160M[3] = { 960777777, 907400000, 816666666 };
>>> > >+	u32 rates_969[3] =  { 480388888, 453700000, 408333333 };
>>> > >+	u32 rates_484[3] =  { 229411111, 216666666, 195000000 };
>>> > >+	u32 rates_242[3] =  { 114711111, 108333333,  97500000 };
>>> > >+	u32 rates_106[3] =  {  40000000,  37777777,  34000000 };
>>> > >+	u32 rates_52[3]  =  {  18820000,  17777777,  16000000 };
>>> > >+	u32 rates_26[3]  =  {   9411111,   8888888,   8000000 };
>>> > >+	u64 tmp;
>>> > >+	u32 result;
>>> > >+
>>> > >+	if (WARN_ON_ONCE(rate->mcs > 11))
>>> > >+		return 0;
>>> > >+
>>> > >+	if (WARN_ON_ONCE(rate->he_gi > NL80211_RATE_INFO_HE_GI_3_2))
>>> > >+		return 0;
>>> > >+	if (WARN_ON_ONCE(rate->he_ru_alloc >
>>> > >+			 NL80211_RATE_INFO_HE_RU_ALLOC_2x996))
>>> > >+		return 0;
>>> > >+	if (WARN_ON_ONCE(rate->nss < 1 || rate->nss > 8))
>>> > >+		return 0;
>>> > >+
>>> > >+	if (rate->bw == RATE_INFO_BW_160)
>>> > >+		result = rates_160M[rate->he_gi];
>>> > >+	else if (rate->bw == RATE_INFO_BW_80 ||
>>> > >+		 (rate->bw == RATE_INFO_BW_HE_RU &&
>>> > >+		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_996))
>>> > >+		result = rates_969[rate->he_gi];
>>> > >+	else if (rate->bw == RATE_INFO_BW_40 ||
>>> > >+		 (rate->bw == RATE_INFO_BW_HE_RU &&
>>> > >+		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_484))
>>> > >+		result = rates_484[rate->he_gi];
>>> > >+	else if (rate->bw == RATE_INFO_BW_20 ||
>>> > >+		 (rate->bw == RATE_INFO_BW_HE_RU &&
>>> > >+		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_242))
>>> > >+		result = rates_242[rate->he_gi];
>>> > >+	else if (rate->bw == RATE_INFO_BW_HE_RU &&
>>> > >+		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_106)
>>> > >+		result = rates_106[rate->he_gi];
>>> > >+	else if (rate->bw == RATE_INFO_BW_HE_RU &&
>>> > >+		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_52)
>>> > >+		result = rates_52[rate->he_gi];
>>> > >+	else if (rate->bw == RATE_INFO_BW_HE_RU &&
>>> > >+		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_26)
>>> > >+		result = rates_26[rate->he_gi];
>>> > >+	else if (WARN(1, "invalid HE MCS: bw:%d, ru:%d\n",
>>> > >+		      rate->bw, rate->he_ru_alloc))
>>> > >+		return 0;
>>> > >+
>> >
>> >Could consider shifts below iso multiply/division.
>>> > >+     /* now scale to the appropriate MCS */
>>> > >+     tmp = result;
>>> > >+     tmp *= SCALE;
>> >         tmp <<= 11;
>>> > >+     do_div(tmp, mcs_divisors[rate->mcs]);
>>> > >+     result = tmp;
>>> > >+
>>> > >+     /* and take NSS, DCM into account */
>>> > >+     result = (result * rate->nss) / 8;
>> >         result = (result * rate->nss) >> 3;
>>> > >+     if (rate->he_dcm)
>>> > >+             result /= 2;
>> >                 result >>= 1;
>>> > >+
>>> > >+     return result;
>>> > >+}
>>> > >+
> I'm not sure I agree.  These are divisions and not really shifts, so
> IMHO it's clearer as is.  This is not a hot path and the compiler will
> probably optimize it in to shifts if possible anyway.  So I won't
> change it in my next version.  Feel free to yell if you disagree (and
> have a good argument :P).

Not really. It is just that everything was power of 2, but indeed it is 
not used in data path.

> Thanks a lot for your review!

No problemo.

Gr. AvS
