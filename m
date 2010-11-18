Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37780 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0KRAzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 19:55:23 -0500
Message-ID: <4CE47978.8050405@candelatech.com>
Date: Wed, 17 Nov 2010 16:55:20 -0800
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


I restarted a few times, and haven't see any lockdep errors.  I did see the
WARN_ON inside that lock hit, however:

------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c:1833 ath_tx_complete_buf+0x1d5/0x240 [ath9k]()
Hardware name: PDSBM
Modules linked in: aes_i586 aes_generic 8021q garp stp llc michael_mic macvlan pktgen nfs lockd fscache nfs_acl auth_rpcgss sunrpc p4_clockmod ipv6 uinput arc4 
ecb e1000e ath9k mac80211 ath9k_common ath9k_hw ath i2c_i801 cfg80211 iTCO_wdt iTCO_vendor_support pcspkr microcode i915 drm_kms_helper drm i2c_algo_bit 
i2c_core video output [last unloaded: ipt_addrtype]
Pid: 0, comm: swapper Tainted: P            2.6.37-rc2-wl+ #50
Call Trace:
  [<78436f25>] warn_slowpath_common+0x77/0x8c
  [<f86e910b>] ? ath_tx_complete_buf+0x1d5/0x240 [ath9k]
  [<f86e910b>] ? ath_tx_complete_buf+0x1d5/0x240 [ath9k]
  [<78436f57>] warn_slowpath_null+0x1d/0x1f
  [<f86e910b>] ath_tx_complete_buf+0x1d5/0x240 [ath9k]
  [<7843c24b>] ? _local_bh_enable_ip+0x9d/0xa6
  [<f86eb1bf>] ath_tx_tasklet+0x242/0x2b6 [ath9k]
  [<f86e68bc>] ath9k_tasklet+0xb9/0x127 [ath9k]
  [<7843bb0d>] tasklet_action+0x88/0xe3
  [<7843c089>] __do_softirq+0x85/0x142
  [<7843c004>] ? __do_softirq+0x0/0x142
  <IRQ>  [<7843beab>] ? irq_exit+0x35/0x69
  [<78404245>] ? do_IRQ+0x8e/0xa2
  [<7844e97c>] ? hrtimer_start+0x22/0x28
  [<784036ae>] ? common_interrupt+0x2e/0x40
  [<78408a12>] ? mwait_idle+0x59/0x69
  [<78402417>] ? cpu_idle+0x4e/0x6b
  [<78779419>] ? rest_init+0xa1/0xa7
  [<78779378>] ? rest_init+0x0/0xa7
  [<78992949>] ? start_kernel+0x334/0x33a
  [<7899244f>] ? unknown_bootoption+0x0/0x190
  [<789920e2>] ? i386_start_kernel+0xe2/0xea
---[ end trace a659d7b152ca5d4f ]---


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

