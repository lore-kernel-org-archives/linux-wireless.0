Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34245 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab2EBUSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 16:18:00 -0400
Received: by obbtb18 with SMTP id tb18so1419205obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2012 13:17:59 -0700 (PDT)
Message-ID: <4FA19674.90804@lwfinger.net> (sfid-20120502_221804_614976_E61E40CE)
Date: Wed, 02 May 2012 15:17:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Wireless problem in 3.4-rc5
References: <4FA0405C.8050101@lwfinger.net> <CAB3XZEerHsNUr4p5rTu0msucKUnxXwFxwZVtONrkZ_czmgS+ig@mail.gmail.com>
In-Reply-To: <CAB3XZEerHsNUr4p5rTu0msucKUnxXwFxwZVtONrkZ_czmgS+ig@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2012 07:58 AM, Eliad Peller wrote:
> hi Larry,
>
> On Tue, May 1, 2012 at 10:58 PM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> After upgrading to 3.4-rc5 from wireless-testing, one of my boxes fails to
>> scan and gets a "Network down" message for all wireless devices. The code in
>> 3.4-rc4 was OK, thus I bisected to find the offending commit. The one that
>> broke my wireless is commit 3a25a8c entitled "mac80211: add improved HW
>> queue control".
>>
>> On my main laptop, this patch causes no problems. On a 3rd box, a BCM4312
>> (b43) is OK, but an RTL8187L (rtl8187) also fails in the same manner.
>>
>> The problem is not in the configuration as I copied the one from the box
>> that works to the one that fails, and it still fails. The only difference is
>> that the working system has 2 CPUs and the ones that fail are uni-processor;
>> however, if I boot with maxcpus=1, my main machine still works.
>>
>> Any suggestions of things to try will be appreciated.
>>
> i'm not sure this is related to the problem you're facing, but the
> commit above seems to have some bug in which a packet might get
> enqueued on invalid queue (0xff) - please try this patch (compile
> tested only):
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 3557354..ee815a9 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2106,7 +2106,8 @@ static int ieee80211_mgmt_tx(struct wiphy
> *wiphy, struct net_device *dev,
>
>   	IEEE80211_SKB_CB(skb)->flags = flags;
>
> -	if (flags&  IEEE80211_TX_CTL_TX_OFFCHAN)
> +	if (local->hw.flags&  IEEE80211_HW_QUEUE_CONTROL&&
> +	    flags&  IEEE80211_TX_CTL_TX_OFFCHAN)
>   		IEEE80211_SKB_CB(skb)->hw_queue =
>   			local->hw.offchannel_tx_hw_queue;
>
> @@ -2151,8 +2152,9 @@ static int ieee80211_mgmt_tx(struct wiphy
> *wiphy, struct net_device *dev,
>   		/* modify cookie to prevent API mismatches */
>   		*cookie ^= 2;
>   		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
> -		IEEE80211_SKB_CB(skb)->hw_queue =
> -			local->hw.offchannel_tx_hw_queue;
> +		if (local->hw.flags&  IEEE80211_HW_QUEUE_CONTROL)
> +			IEEE80211_SKB_CB(skb)->hw_queue =
> +				local->hw.offchannel_tx_hw_queue;
>   		local->hw_roc_skb = skb;
>   		local->hw_roc_skb_for_status = skb;
>   		mutex_unlock(&local->mtx);

Sorry, but this patch does not fix my problem.

Larry

