Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:62405 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbcAEJuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 04:50:17 -0500
Message-ID: <568B91D6.6080404@broadcom.com> (sfid-20160105_105022_239773_985365A6)
Date: Tue, 5 Jan 2016 10:50:14 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/2] nl80211: add extended feature for BSS selection support
References: <1450959550-19655-1-git-send-email-arend@broadcom.com>	 <1450959550-19655-2-git-send-email-arend@broadcom.com> <1451985926.12357.16.camel@sipsolutions.net>
In-Reply-To: <1451985926.12357.16.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2016 10:25 AM, Johannes Berg wrote:
> On Thu, 2015-12-24 at 13:19 +0100, Arend van Spriel wrote:
>> Introducing a new extended feature that the driver can support which
>> indicate the driver/firmware supports configuration of BSS selection
>> criteria upon CONNECT command.
>
> Can you edit the commit message to include some of the 0/2 email here?

Sure I can and will.

>>   /**
>> + * struct cfg80211_bss_selection - Connection parameters for BSS selection.
>> + *
>> + * @present: indicates whether parameters are set.
>> + * @pref_band: preferred band.
>> + * @rssi_adjust: adjustment for RSSI level of the preferred band.
>> + * @ignore_rssi: indicates whether BSS in preferred band is to be selected
>> + *> 	> regardless its RSSI level.
>> + */
>> +struct cfg80211_bss_selection {
>> +> 	> bool present;
>> +> 	> enum nl80211_band pref_band;
>> +> 	> u8 rssi_adjust;
>> +> 	> bool ignore_rssi;
>> +};
>
> Hm. Isn't it possible to specify *some* parameters of these? Or at
> least, in the future (if we extend this), it would be?
>
> Seems that 'present' might want to be a bitmap or so? Or perhaps be
> done by using invalid values by default (e.g. NUM_BANDS for no band
> preference, etc.)?

Ok. I was not sure how to go about this. Our firmware uses an ordered 
list of selection "keys" with the first being the primary selection key 
and so on. So there are three "key" types: band, rssi, and rssi_adjust. 
The latter is not really a selection key, but will do rssi adjustment 
for BSSes in the specified band.

One of the questions I have is whether the order of a nested list 
attribute is retained.

>> @@ -1910,6 +1926,7 @@ struct cfg80211_connect_params {
>>   > 	> struct ieee80211_ht_cap ht_capa_mask;
>>   > 	> struct ieee80211_vht_cap vht_capa;
>>   > 	> struct ieee80211_vht_cap vht_capa_mask;
>> +	struct cfg80211_bss_selection bss_select;
>
> No documentation here?

Obviously, but will add it ;-)

>> +/**
>> + * enum nl80211_attr_bss_select - attributes for bss selection.
>> + *
>> + * @__NL80211_ATTR_BSS_SELECT_INVALID: reserved.
>> + * @NL80211_ATTR_BSS_SELECT_BAND_PREF: Required attribute indicating the
>> + *> 	> preferred band. The preference by itself still allows RSSI based
>> + *> 	> selection of BSS and as such is only a tie breaker. Value according
>> + *> 	> %enum nl80211_band.
>> + * @NL80211_ATTR_BSS_SELECT_RSSI_ADJUST: When present the RSSI level for
>> + *	the BSS in the preferred band is adjusted accordingly (u8).
>
> "adjusted" is a bit vague - should specify more precisely what happens?

Ok. Will elaborate. In follow-up email I raise question whether this 
could/should be a signed value. Any opinion on this?

>> + * @NL80211_ATTR_BSS_SELECT_IGNORE_RSSI: flag attribute which can be used to
>> + *> 	> to have the BSS in the preferred band being selected regardless
>> + *	of its RSSI level.
>
> Can't that be done by a huge adjustment? Like, say, 255 dB adjustment?

Probably, but this may go away depending on the "key" type thing 
mentioned above.

>> +> 	> err = nla_parse(attr, NL80211_ATTR_BSS_SELECT_MAX,
>> +> 	> 	> 	> nla_data(nla), nla_len(nla), nl80211_bss_select_policy);
>> +> 	> if (err)
>> +> 	> 	> return err;
>> +
>> +> 	> bss_select->present = true;
>> +> 	> if (!attr[NL80211_ATTR_BSS_SELECT_BAND_PREF])
>> +> 	> 	> return -EINVAL;
>> +
>> +> 	> bss_select->pref_band =
>> +> 	> 	> nla_get_u32(attr[NL80211_ATTR_BSS_SELECT_BAND_PREF]);
>> +> 	> bss_select->rssi_adjust =
>> +		nla_get_u8(attr[NL80211_ATTR_BSS_SELECT_RSSI_ADJUST]);
>
> Need to check the attribute exists, no?

Was assuming nla_get_u8 would return 0 so it would not matter, but it 
seems to be recipe for disaster [1].

>
> It could be worthwhile to have a "demo" implementation for the code in
> cfg80211 that's used when you use CONNECT command with mac80211, maybe?

Sure. Sorry for being single-minded here ;-)

Regards,
Arend

[1] http://lxr.free-electrons.com/source/include/net/netlink.h#L1037
