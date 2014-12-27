Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35156 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaL0Si0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 13:38:26 -0500
Received: by mail-oi0-f48.google.com with SMTP id u20so25154553oif.7
        for <linux-wireless@vger.kernel.org>; Sat, 27 Dec 2014 10:38:25 -0800 (PST)
Message-ID: <549EFC9F.9030504@lwfinger.net> (sfid-20141227_193830_072466_B4B82861)
Date: Sat, 27 Dec 2014 12:38:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	Christopher Chavez <chrischavez@gmx.us>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: p54usb kernel panic on recent mainline kernels
References: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com> <loom.20141227T010207-869@post.gmane.org> <2296382.VCr2c4tJc9@debian64> <5946673.YueIgFzjsn@debian64>
In-Reply-To: <5946673.YueIgFzjsn@debian64>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/27/2014 05:57 AM, Christian Lamparter wrote:
> Alright, here's lunch [for the people in CET].
>
> On Saturday, December 27, 2014 11:10:16 AM Christian Lamparter wrote:
>> On Saturday, December 27, 2014 12:15:58 AM Christopher Chavez wrote:
>>>> My bisection led to a branch commit d17ec4d as the "bad" commit.
>>>> Rather than finding out where the bisection went bad, I added
>>>> code to check skb->tail, skb->end, and the length to be added.
>>>> At the time of the call that panics, there are 6 bytes between
>>>> tail and end with 8 bytes needed.
>>>>
>>>> I will be looking for the place where the driver calculates how
>>>> large the skb should be.
>>
>>  From looking at a other patch from that time and context. I think: "
>>
>> commit ca34e3b5c808385b175650605faa29e71e91991b
>> Author: Ido Yariv <ido@wizery.com>
>> Date:   Tue Jul 29 15:38:53 2014 +0300
>>
>>      mac80211: Fix accounting of the tailroom-needed counter [1]
>>
>> [...]
>> I can think of several ways of dealing with this issue:
>>
>>   2. add extra IEEE80211_KEY_FLAG_ or HW_FLAG to restore the old behavior.
>>      This should be possible and relatively simple. But we/I have to be
>>      especially careful to differentiate properly between the old and new.
>>      [i.e.: I need to know what the deal is behind:
>>      IEEE80211_KEY_FLAG_GENERATE_IV_MGMT in this case? Looks like it can
>>      be ignored?]
>>
>
> ---
> [Note: for convenience this patch is rolled into one for now -
> if it and the concept works, I'll make two parts. one for p54
> one for mac80211 [both -stable]. It would be great if someone
> could proofread the commit message though - and provide
> "tested-by" tags if possible]
>
> mac80211: re-enable tailroom resizing when needed for hardware encryption
>
> The patch "mac80211: Fix accounting of the tailroom-needed counter" reduced
> the overhead associated with unnecessary resizing of outgoing frames.
> Unfortunately this change broke the assumption that there is always enough
> tailroom and this in turn caused p54* to panic.
>
> Reported-by: Christopher Chavez <chrischavez@gmx.us>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
> index 97aeff0..b877c7f 100644
> --- a/drivers/net/wireless/p54/main.c
> +++ b/drivers/net/wireless/p54/main.c
> @@ -751,6 +751,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
>   		     IEEE80211_HW_SUPPORTS_PS |
>   		     IEEE80211_HW_PS_NULLFUNC_STACK |
>   		     IEEE80211_HW_MFP_CAPABLE |
> +		     IEEE80211_HW_TAILROOM_CRYPTO |
>   		     IEEE80211_HW_REPORTS_TX_ACK_STATUS;
>
>   	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 58d719d..c04ac04 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1270,8 +1270,11 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
>    *
>    * @IEEE80211_KEY_FLAG_GENERATE_IV: This flag should be set by the
>    *	driver to indicate that it requires IV generation for this
> - *	particular key. Setting this flag does not necessarily mean that SKBs
> - *	will have sufficient tailroom for ICV or MIC.
> + *	particular key. Setting this flag does not mean that SKBs will
> + *	have sufficient tailroom for ICV or MIC. If additional tailroom
> + *	tailroom needs to be reserved for the ICV or MIC, the driver
> + *	should also set the hardware feature flag:
> + *      %IEEE80211_HW_TAILROOM_CRYPTO.
>    * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
>    *	the driver for a TKIP key if it requires Michael MIC
>    *	generation in software.
> @@ -1583,6 +1586,10 @@ struct ieee80211_tx_control {
>    * @IEEE80211_HW_MFP_CAPABLE:
>    *	Hardware supports management frame protection (MFP, IEEE 802.11w).
>    *
> + * @IEEE80211_HW_TAILROOM_CRYPTO: The driver would like to have sufficient
> + *	tailroom for ICV or MIC for outgoing frames in order to perform
> + *	hardware encryption without any additional resizing overhead.
> + *
>    * @IEEE80211_HW_SUPPORTS_UAPSD:
>    *	Hardware supports Unscheduled Automatic Power Save Delivery
>    *	(U-APSD) in managed mode. The mode is configured with
> @@ -1673,7 +1680,7 @@ enum ieee80211_hw_flags {
>   	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
>   	IEEE80211_HW_WANT_MONITOR_VIF			= 1<<14,
>   	IEEE80211_HW_NO_AUTO_VIF			= 1<<15,
> -	/* free slot */
> +	IEEE80211_HW_TAILROOM_CRYPTO			= 1<<16,
>   	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
>   	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
>   	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
> index 0bb7038..c3e9a9a 100644
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -140,7 +140,8 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
>   	if (!ret) {
>   		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
>
> -		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
> +		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
> +		      (key->local->hw.flags & IEEE80211_HW_TAILROOM_CRYPTO)))
>   			sdata->crypto_tx_tailroom_needed_cnt--;
>
>   		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
> @@ -188,7 +189,8 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
>   	sta = key->sta;
>   	sdata = key->sdata;
>
> -	if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
> +	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
> +	      (key->local->hw.flags & IEEE80211_HW_TAILROOM_CRYPTO)))
>   		increment_tailroom_need_count(sdata);
>
>   	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
> @@ -884,7 +886,8 @@ void ieee80211_remove_key(struct ieee80211_key_conf *keyconf)
>   	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
>   		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
>
> -		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
> +		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
> +		      (key->local->hw.flags & IEEE80211_HW_TAILROOM_CRYPTO)))
>   			increment_tailroom_need_count(key->sdata);
>   	}

Christian,

I had redone the bisection and found that ca34e3b was the bad commit. That was 
late last night (CST - UTC-5). I was pleased to find your patch in my mailbox 
this morning.

With your patch, my system has survived for about 2 hours, whereas it would have 
failed in 2 minutes or less. You can add

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

I think this needs to be applied to 3.{17-19}.

Thanks,

Larry


