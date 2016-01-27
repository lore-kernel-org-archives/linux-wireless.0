Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:3025 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbcA0Vxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 16:53:44 -0500
Subject: Re: [RFC V4 1/2] nl80211: add feature for BSS selection support
To: Johannes Berg <johannes@sipsolutions.net>
References: <1453813592-5266-1-git-send-email-arend@broadcom.com>
 <1453813592-5266-2-git-send-email-arend@broadcom.com>
 <1453816594.2759.70.camel@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend@broadcom.com>
Message-ID: <56A93C65.50204@broadcom.com> (sfid-20160127_225351_740210_1F21A1D8)
Date: Wed, 27 Jan 2016 22:53:41 +0100
MIME-Version: 1.0
In-Reply-To: <1453816594.2759.70.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 26-1-2016 14:56, Johannes Berg wrote:
> On Tue, 2016-01-26 at 14:06 +0100, Arend van Spriel wrote:
>>  
>> + * @behaviour: requested BSS selection behaviour.
>> + * @param: parameters for requestion behaviour.
>> + * @band_pref: preferred band for
>> %NL80211_BSS_SELECT_ATTR_BAND_PREF.
>> + * @adjust: parameters for %NL80211_BSS_SELECT_ATTR_RSSI_ADJUST.
> 
> Sadly, I don't think this works with kernel-doc. You'd have to split it
> out into a named union to get this working properly.

Yeah. I did not run kernel-doc. Will look into it.

>> +/**
>> + * enum nl80211_bss_select_attr - attributes for bss selection.
>> + *
>> + * @__NL80211_BSS_SELECT_ATTR_INVALID: reserved.
>> + * @NL80211_BSS_SELECT_ATTR_RSSI: Flag indicating only RSSI-based BSS selection
>> + * is requested.
>> + * @NL80211_BSS_SELECT_ATTR_BAND_PREF: attribute indicating BSS
>> + *> 	> selection should be done such that the specified band is preferred.
>> + *> 	> When there are multiple BSS-es in the preferred band, the driver
>> + *> 	> shall use RSSI-based BSS selection as a second step. The value of
>> + *> 	> this attribute is according to &enum nl80211_band (u32).
>> + * @NL80211_BSS_SELECT_ATTR_RSSI_ADJUST: When present the RSSI level for
>> + *> 	> BSS-es in the specified band is to be adjusted before doing
>> + *> 	> RSSI-based BSS selection. The attribute value is a packed two-byte
>> + *> 	> value. The lower byte contains the adjustment value (s8) and the
>> + *	high byte contains the band according &enum nl80211_band.
> 
> I think it might be nicer to define an explicit struct for this, then
> you don't have to use u8 for the band in one attribute and u32 for the
> band in the other attribute either.
> 
> As long as there's no u64 in the struct that's pretty much safe - if
> u64 is needed use compat_u64 :)

So you mean mapping the explicit structure over the nla_data()?

>> + * @NL80211_BSS_SELECT_ATTR_MAX: highest bss select attribute number.
>> + *@__NL80211_BSS_SELECT_ATTR_AFTER_LAST: internal use.
>> + *
>> + * These attributes are found within %NL80211_ATTR_BSS_SELECT and
>> + * indicate the required BSS selection behaviour which the driver
>> + * should use.
> 
> You should probably indicate that only a single one can ever be
> specified?

Realized that was missing indeed. Will add it.

>> +static const struct nla_policy
>> +nl80211_bss_select_policy[NL80211_BSS_SELECT_ATTR_MAX + 1] = {
>> +	[NL80211_BSS_SELECT_ATTR_RSSI] = { .type = NLA_FLAG },
>> +	[NL80211_BSS_SELECT_ATTR_BAND_PREF] = { .type = NLA_U32 },
>> +	[NL80211_BSS_SELECT_ATTR_RSSI_ADJUST] = { .type = NLA_U8 },
> 
> The RSSI_ADJUST here seems wrong in any case? Should've been NLA_U16
> now?

It should have, yes.

>> @@ -5753,6 +5778,42 @@ static int validate_scan_freqs(struct nlattr
>> *freqs)
>>  	return n_channels;
>>  }
>>  
>> +static int parse_bss_select(struct nlattr *nla,
>> +			    struct cfg80211_bss_selection
>> *bss_select)
>> +{
>> +	struct nlattr *attr[NL80211_BSS_SELECT_ATTR_MAX + 1];
>> +	u16 band_delta;
>> +	int err;
> 
> This should perhaps reject specification of multiple attributes, since
> otherwise the order of the code here dictates which one "wins".

I was waiting for your opinion on this as it did not feel right to me
either.

> But these are small things - looks good!

Thanks. Will work on final patch (famous last words).

Regards,
Arend
