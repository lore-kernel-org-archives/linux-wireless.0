Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:59947 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0EGXB5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 19:01:57 -0400
Message-ID: <4BE49BDD.8010803@free.fr>
Date: Sat, 08 May 2010 01:01:49 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: Add HT IE to IBSS beacons and probe responses.
References: <1273098986-19330-1-git-send-email-benoit.papillault@free.fr>	 <1273098986-19330-2-git-send-email-benoit.papillault@free.fr> <1273128051.3573.17.camel@jlt3.sipsolutions.net>
In-Reply-To: <1273128051.3573.17.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 06/05/2010 08:40, Johannes Berg a écrit :
> On Thu, 2010-05-06 at 00:36 +0200, Benoit Papillault wrote:
>> When an HT IBSS is configured, we add HT Information and HT Capabilities
>> IE to beacons&  probe responses. This is done according to channel_type
>> transmitted by iw/cfg80211.
>>
>> v2: Added helpers to build HT Capability&  HT Information IE
>
> This line belongs after the --- so it's not part of the commit log.
>
>>   	local->oper_channel = chan;
>> -	local->oper_channel_type = NL80211_CHAN_NO_HT;
>> +	local->oper_channel_type = channel_type;
>
> It would be helpful if you were to rebase over my patch that adds the
> channel type tracking.

Your patches are now in wireless-testing, so I am doing it at the moment.

>
>> @@ -165,6 +169,14 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>>   		memcpy(pos,&supp_rates[8], rates);
>>   	}
>>
>> +	if (channel_type != NL80211_CHAN_NO_HT&&
>> +	    sband->ht_cap.ht_supported) {
>
> You shouldn't be able to get here with an HT channel but !ht_supported,
> no? Or is that to support the case where you have HT only on one band?

Good point. I think there are several cases here :

- a non-HT STA is joining an HT IBSS (we need to check 802.11n-2009 to 
see how it's supposed to be handled). In this case channel_type could be 
ht40+ and ht_supported = false

- an HT STA is joining a non-HT IBSS. It's clear in this case that no HT 
IE should be sent, which is catched by (channel_type != 
NL80211_CHAN_NO_HT) condition.

Could we examine those cases in a follow up patch?

>
>> +	}
>> +	
>
> trailing whitespace
>
>> @@ -202,6 +214,9 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>>   	u32 basic_rates;
>>   	int i, j;
>>   	u16 beacon_int = cbss->beacon_interval;
>> +	const u8 * ht_info_ie;
>
> CodingStyle.
>
>> @@ -223,9 +238,28 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>>   		}
>>   	}
>>
>> +	/* parse HT Information IE, if present */
>> +	ht_info_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_INFORMATION);
>> +	if (ht_info_ie) {
>> +		ht_info = (const struct ieee80211_ht_info *)(ht_info_ie + 2);
>> +		switch (ht_info->ht_param
>> +			&  IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
>
> The parser in mlme.c looks different. Please see there and also make it
> a helper function.

Thanks. I did not notice.

>
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -404,6 +404,7 @@ struct ieee80211_if_ibss {
>>   	u8 ssid_len, ie_len;
>>   	u8 *ie;
>>   	struct ieee80211_channel *channel;
>> +	enum nl80211_channel_type channel_type;
>>
>>   	unsigned long ibss_join_req;
>>   	/* probe response/beacon for IBSS */
>> @@ -1193,6 +1194,15 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
>>   			 u16 transaction, u16 auth_alg,
>>   			 u8 *extra, size_t extra_len, const u8 *bssid,
>>   			 const u8 *key, u8 key_len, u8 key_idx);
>> +
>> +int ieee80211_add_ht_cap(u8 **ppos,
>> +			 struct ieee80211_supported_band *sband);
>
> The length is fixed anyway, so how about just passing in
> 	...(u8 *buffer, ... sband)
>
>> +int ieee80211_add_ht_info(u8 **ppos,
>> +			  struct ieee80211_supported_band *sband,
>> +			  struct ieee80211_channel *channel,
>> +			  enum nl80211_channel_type channel_type);
>
> same here.
>
>> --- a/net/mac80211/util.c
>> +++ b/net/mac80211/util.c
>> @@ -898,6 +898,82 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
>>   	ieee80211_tx_skb(sdata, skb);
>>   }
>>
>> +int ieee80211_add_ht_cap(u8 **ppos,
>> +			 struct ieee80211_supported_band *sband)
>> +{
>
> Actually ... please split up the patches.
>
>   1) pure code moving from the mlme code to helper functions
>   2) helper function rewrite using the structures, like you did
>   3) this patch
>
>> +	u16 cap = sband->ht_cap.cap;
>> +	struct ieee80211_ht_cap ht_cap;
>> +	u8 *pos = *ppos;
>> +
>> +	if (ieee80211_disable_40mhz_24ghz&&
>> +	    sband->band == IEEE80211_BAND_2GHZ) {
>> +		cap&= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
>> +		cap&= ~IEEE80211_HT_CAP_SGI_40;
>> +	}
>> +
>> +	ht_cap.cap_info = cpu_to_le16(cap);
>> +	ht_cap.ampdu_params_info = sband->ht_cap.ampdu_factor |
>> +		(sband->ht_cap.ampdu_density<<
>> +		 IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
>> +	ht_cap.mcs = sband->ht_cap.mcs;
>> +	ht_cap.extended_ht_cap_info = cpu_to_le16(0);
>> +	ht_cap.tx_BF_cap_info = cpu_to_le32(0);
>> +	ht_cap.antenna_selection_info = 0;
>> +
>> +	/* HT Capabilities element */
>> +	*pos++ = WLAN_EID_HT_CAPABILITY;
>> +	*pos++ = sizeof(struct ieee80211_ht_cap);
>> +	memcpy(pos,&ht_cap, sizeof(struct ieee80211_ht_cap));
>> +	pos += sizeof(struct ieee80211_ht_cap);
>> +
>> +	*ppos = pos;
>> +
>> +	return 1;
>
> oh and get rid of the entirely useless return value.

Let's do so.

>
>> +}
>> +
>> +int ieee80211_add_ht_info(u8 **ppos,
>> +			  struct ieee80211_supported_band *sband,
>> +			  struct ieee80211_channel *channel,
>> +			  enum nl80211_channel_type channel_type)
>
> what's wrong with ieee80211_add_ht_ie()

Seems it's close to what I'm doing, but not entirely the same. I will 
read it. If applicable, should I move ieee80211_add_ht_ie to util.c (and 
declaration to ieee80211_i.h) then ?

>
> Some more effort please! Patches with such _basic_ errors are no fun to
> review!

I will try to do better next time, sorry about that.

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

