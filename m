Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48819 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab0KRAm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 19:42:27 -0500
Message-ID: <4CE4766E.9080806@candelatech.com>
Date: Wed, 17 Nov 2010 16:42:22 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: recursive locking on wireless-testing.
References: <4CE446E3.3090604@candelatech.com> <4CE47563.2090803@openwrt.org>
In-Reply-To: <4CE47563.2090803@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2010 04:37 PM, Felix Fietkau wrote:
> On 2010-11-17 10:19 PM, Ben Greear wrote:
>> I found this while testing wpa_supplicant that shares scan results.
>> The kernel has no scan-sharing hacks in it..just a few patches
>> I've been using for a while (and the deadlock prevention patch
>> previously mentioned in other threads).
>>
>>
>> Nov 17 13:16:25 ath9k kernel: ieee80211 wiphy0: Removed STA 00:14:d1:c6:d2:54
>> Nov 17 13:16:25 ath9k kernel: ieee80211 wiphy0: Destroyed STA 00:14:d1:c6:d2:54
>>
>> =============================================
>> [ INFO: possible recursive locking detected ]
>> 2.6.37-rc1-wl+ #48
>> ---------------------------------------------
> This should fix it. ath_tx_complete is already called with the txq locked.

Thanks, I'll give it a try now.

Ben

>
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1830,10 +1830,8 @@ static void ath_tx_complete(struct ath_s
>   	else {
>   		q = skb_get_queue_mapping(skb);
>   		if (txq == sc->tx.txq_map[q]) {
> -			spin_lock_bh(&txq->axq_lock);
>   			if (WARN_ON(--txq->pending_frames<  0))
>   				txq->pending_frames = 0;
> -			spin_unlock_bh(&txq->axq_lock);
>   		}
>
>   		ieee80211_tx_status(hw, skb);


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

