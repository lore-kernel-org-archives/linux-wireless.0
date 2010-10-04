Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57279 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab0JDRwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 13:52:14 -0400
Message-ID: <4CAA144C.7040906@candelatech.com>
Date: Mon, 04 Oct 2010 10:52:12 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Ming Lei <tom.leiming@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: lockdep warning in ieee80211 rx path
References: <AANLkTin5KfmQLYxLWdhTcO-AM0t83dVq=LFCG0UGysaw@mail.gmail.com> <201009142251.53021.chunkeey@googlemail.com>
In-Reply-To: <201009142251.53021.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2010 01:51 PM, Christian Lamparter wrote:
> On Sunday 05 September 2010 11:32:26 Ming Lei wrote:
>> Seems the warning does not affect use of wireless,  false positive?
>
> No, it's a bug... but please read&  test the attached patch.

This is not yet in wireless-testing.  Should it be?

Thanks,
Ben

>
>> [  221.023116] =======================================================
>> [  221.023164] [ INFO: possible circular locking dependency detected ]
>> [  221.023195] 2.6.36-rc3-next-20100903+ #65
>> [  221.023215] -------------------------------------------------------
>> [  221.023246] X/2091 is trying to acquire lock:
>> [  221.023268]  (slock-AF_INET/1){+.-...}, at: [<ffffffff81381151>]
>> tcp_v4_rcv+0x290/0x6b7
>> [  221.023323]
>> [  221.023323] but task is already holding lock:
>> [  221.023354]  (&(&sta->lock)->rlock){+.-...}, at:
>> [<ffffffffa01edd37>] sta_rx_agg_reorder_timer_expired+0x61/0x9c
>> [mac80211]
>> [  221.023425]
>> [  221.023426] which lock already depends on the new lock.
>> [  221.023426]
>> [  221.023469]
>> [  221.023469] the existing dependency chain (in reverse order) is:
>> [  221.023508]
>> [  221.023509] ->  #2 (&(&sta->lock)->rlock){+.-...}:
>> [  221.023547]        [<ffffffff8107d7e3>] lock_acquire+0xe6/0x113
>> [  221.023581]        [<ffffffff813ce6a4>] _raw_spin_lock_irqsave+0x5d/0x97
>> [  221.024007]
>> [  221.024007] ->  #1 (_xmit_ETHER){+.-...}:
>> [  221.024007]        [<ffffffff8107d7e3>] lock_acquire+0xe6/0x113
>> [  221.024007]        [<ffffffff81340d9c>] netif_receive_skb+0x6c/0x73
>> [  221.024007]        [<ffffffffa01fcf27>] ieee80211_rx+0x7b5/0x826 [mac80211]
>> [  221.024007]
>> [  221.024007] ->  #0 (slock-AF_INET/1){+.-...}:
>> [  221.024007]        [<ffffffff8107d406>] __lock_acquire+0xa2c/0xd23
>> [  221.024007]        [<ffffffff8107d7e3>] lock_acquire+0xe6/0x113
>> [  221.024007]        [<ffffffff813ce47b>] _raw_spin_lock_nested+0x43/0x76
>> [  221.024007]        [<ffffffff81381151>] tcp_v4_rcv+0x290/0x6b7
>> [  221.024007]        [<ffffffff81364424>] ip_local_deliver+0x130/0x1c0
>> [  221.024007]        [<ffffffff81364161>] ip_rcv+0x4d9/0x519
>> [  221.024007]        [<ffffffff8133fdd9>] __netif_receive_skb+0x292/0x2bf
>> [  221.024007]        [<ffffffff81340d9c>] netif_receive_skb+0x6c/0x73
> ---
> [PATCH] mac80211: hoist sta->lock from reorder release timer
>
> The patch "mac80211: AMPDU rx reorder timeout timer" clashes
> with "mac80211: use netif_receive_skb in ieee80211_rx callpath"
>
> The timer itself is part of the station's private struct and
> it gets killed whenever the station is removed. Therefore
> the extra sta->lock protection (that can interferes with the
> tx path) is not necessary.
>
> Reported-by: Ming Lei<tom.leiming@gmail.com>
> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
> ---
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index 58eab9e..309ed70 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -129,9 +129,7 @@ static void sta_rx_agg_reorder_timer_expired(unsigned long data)
>   			timer_to_tid[0]);
>
>   	rcu_read_lock();
> -	spin_lock(&sta->lock);
>   	ieee80211_release_reorder_timeout(sta, *ptid);
> -	spin_unlock(&sta->lock);
>   	rcu_read_unlock();
>   }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

