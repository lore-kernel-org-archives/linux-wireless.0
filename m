Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:42372 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898Ab2GKLPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 07:15:33 -0400
Message-ID: <4FFD6053.9070003@net.t-labs.tu-berlin.de> (sfid-20120711_131536_489953_31A83EB5)
Date: Wed, 11 Jul 2012 13:15:31 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	buytenh@wantstofly.org, nbd@openwrt.org
Subject: Re: [PATCH v2] mwl8k: fix possible race condition in info->control.sta
 use
References: <1341984754-76477-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <CAAd0S9CMUVQNMsbg0Wv6DrNoyqw6H-OiGnvA8ByVgEgAd+02sw@mail.gmail.com>
In-Reply-To: <CAAd0S9CMUVQNMsbg0Wv6DrNoyqw6H-OiGnvA8ByVgEgAd+02sw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

You have a very valid point here.
I will send a v3.

Greetings Thomas

Christian Lamparter schrieb:

> On Wed, Jul 11, 2012 at 7:32 AM, Thomas Huehn
> <thomas@net.t-labs.tu-berlin.de> wrote:
>> info->control.sta may only be dereferenced during the drv_tx call otherwise
>> could lead to use-after-free bugs
> 
> Don"t forget many ieee80211_sta_* functions have to be called under RCU
> lock and the resulting pointer is only valid under RCU lock as well.
> 
>> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
>> index df6c6f1..eec5cd1 100644
>> --- a/drivers/net/wireless/mwl8k.c
>> +++ b/drivers/net/wireless/mwl8k.c
>> @@ -1667,7 +1667,8 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw,
>>
>>                 info = IEEE80211_SKB_CB(skb);
>>                 if (ieee80211_is_data(wh->frame_control)) {
> 
> +                         rcu_read_lock();
> 
>> -                       sta = info->control.sta;
>> +                       sta = ieee80211_find_sta_by_ifaddr(hw, wh->addr1,
>> +                                                          wh->addr2);
>>                         if (sta) {
>>                                 sta_info = MWL8K_STA(sta);
>>                                 BUG_ON(sta_info == NULL);
>>                                 [...]
>>                         }
> 
> +                         rcu_read_unlock();
> 
> Regards,
>       Chr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

