Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45796 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbeC1Ffe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 01:35:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 28 Mar 2018 11:05:33 +0530
From: vthiagar@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/4] mac80211: Add NoAck policy functionality offload
 infrastructure
In-Reply-To: <1522155185.3050.7.camel@sipsolutions.net>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
 <1522140171-10926-2-git-send-email-vthiagar@codeaurora.org>
 <1522155185.3050.7.camel@sipsolutions.net>
Message-ID: <5b341b2146fa9e0cf79fd9a6774a871f@codeaurora.org> (sfid-20180328_073538_746133_69212C24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-27 18:23, Johannes Berg wrote:
> On Tue, 2018-03-27 at 14:12 +0530, Vasanthakumar Thiagarajan wrote:
>> 
>> + * @IEEE80211_HW_SUPPORTS_NOACK_POLICY: Hardware (or driver) manages 
>> noack
>> + *	policy handling. Hardware (or driver) takes care of setting
>> + *	noack policy in the qos header and does not wait for the ack based
>> + *	on the noack TID map. Driver advertising this support must 
>> implement
>> + *	callback @set_noack_tid_bitmap to receive the user configured 
>> noack TID
>> + *	bitmap.
> 
> Do you really need the ops method and the flag?

Ath10k would send NoAck policy configuration on control path 
configuration.
It seems a new ops might be appropriate. Perhaps the ops alone is 
sufficient
to know the capability?

> 
>> +	int (*set_noack_tid_bitmap)(struct ieee80211_hw *hw,
>> +				    struct ieee80211_vif *vif, u8 noack_map);
> 
> You'd safe some effort by reordering the nl80211 patch first, so you 
> can
> immediately introduce it with per-peer capability here.

Sure.

> 
>> +++ b/net/mac80211/cfg.c
>> @@ -347,9 +347,15 @@ static int ieee80211_set_noack_map(struct wiphy 
>> *wiphy,
>> 
>>  	sdata->noack_map = noack_map;
>> 
>> -	ieee80211_check_fast_xmit_iface(sdata);
>> +	if (!ieee80211_hw_check(&sdata->local->hw, SUPPORTS_NOACK_POLICY)) {
>> +		ieee80211_check_fast_xmit_iface(sdata);
>> +		return 0;
>> +	}
>> 
>> -	return 0;
>> +	if (!ieee80211_sdata_running(sdata))
>> +		return 0;
>> +
>> +	return drv_set_noack_tid_bitmap(sdata->local, sdata, noack_map);
> 
> This doesn't seem right - you should do the fast xmit checks even if
> calling the driver, no? And in fact, fast xmit should be permitted when
> the noack is offloaded, so you shouldn't set sdata->noack_map in the
> offloaded case at all.
> 
>> --- a/net/mac80211/iface.c
>> +++ b/net/mac80211/iface.c
>> @@ -631,6 +631,10 @@ int ieee80211_do_open(struct wireless_dev *wdev, 
>> bool coming_up)
>>  				ieee80211_vif_type_p2p(&sdata->vif));
>>  			if (res)
>>  				goto err_del_interface;
>> +
>> +			if (sdata->noack_map)
>> +				drv_set_noack_tid_bitmap(local, sdata,
>> +							 sdata->noack_map);
> 
> Or maybe you do need to store it for this reason, but need to ignore it
> for the purposes of fast-xmit if SUPPORTS_NOACK_POLICY is set.
> 
>> +++ b/net/mac80211/tx.c
>> @@ -2817,7 +2817,8 @@ void ieee80211_check_fast_xmit(struct sta_info 
>> *sta)
>>  	    test_sta_flag(sta, WLAN_STA_CLEAR_PS_FILT))
>>  		goto out;
>> 
>> -	if (sdata->noack_map)
>> +	if (sdata->noack_map &&
>> +	    !ieee80211_hw_check(&local->hw, SUPPORTS_NOACK_POLICY))
>>  		goto out;
> 
> Ah, and you do :-)
> 
> And then maybe you're indeed right and don't need to call the fast xmit
> check in that place since it wouldn't have any effect either way.

Right.

Vasanth
