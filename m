Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43920 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab0KSXM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 18:12:27 -0500
Message-ID: <4CE70456.8070008@candelatech.com>
Date: Fri, 19 Nov 2010 15:12:22 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: recursive locking on wireless-testing.
References: <4CE446E3.3090604@candelatech.com> <4CE47563.2090803@openwrt.org> <4CE47978.8050405@candelatech.com> <4CE4F79B.3000500@openwrt.org>
In-Reply-To: <4CE4F79B.3000500@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2010 01:53 AM, Felix Fietkau wrote:
> On 2010-11-18 1:55 AM, Ben Greear wrote:
>> On 11/17/2010 04:37 PM, Felix Fietkau wrote:
>>> On 2010-11-17 10:19 PM, Ben Greear wrote:
>>>> I found this while testing wpa_supplicant that shares scan results.
>>>> The kernel has no scan-sharing hacks in it..just a few patches
>>>> I've been using for a while (and the deadlock prevention patch
>>>> previously mentioned in other threads).
>>>>
>>>>
>>>> Nov 17 13:16:25 ath9k kernel: ieee80211 wiphy0: Removed STA 00:14:d1:c6:d2:54
>>>> Nov 17 13:16:25 ath9k kernel: ieee80211 wiphy0: Destroyed STA 00:14:d1:c6:d2:54
>>>>
>>>> =============================================
>>>> [ INFO: possible recursive locking detected ]
>>>> 2.6.37-rc1-wl+ #48
>>>> ---------------------------------------------
>>> This should fix it. ath_tx_complete is already called with the txq locked.
>>>
>>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>>> @@ -1830,10 +1830,8 @@ static void ath_tx_complete(struct ath_s
>>>    	else {
>>>    		q = skb_get_queue_mapping(skb);
>>>    		if (txq == sc->tx.txq_map[q]) {
>>> -			spin_lock_bh(&txq->axq_lock);
>>>    			if (WARN_ON(--txq->pending_frames<   0))
>>>    				txq->pending_frames = 0;
>>> -			spin_unlock_bh(&txq->axq_lock);
>>>    		}
>>>
>>>    		ieee80211_tx_status(hw, skb);
>>
>>
> How about this instead of the other patch?
>
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -163,6 +163,7 @@ static void ath_tx_flush_tid(struct ath_
>   		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
>   		list_move_tail(&bf->list,&bf_head);
>
> +		spin_unlock_bh(&txq->axq_lock);
>   		fi = get_frame_info(bf->bf_mpdu);
>   		if (fi->retries) {
>   			ath_tx_update_baw(sc, tid, fi->seqno);
> @@ -170,6 +171,7 @@ static void ath_tx_flush_tid(struct ath_
>   		} else {
>   			ath_tx_send_normal(sc, txq, tid,&bf_head);
>   		}
> +		spin_lock_bh(&txq->axq_lock);
>   	}
>
>   	spin_unlock_bh(&txq->axq_lock);

I don't see any lockdep errors with this, but I did see this spit out:


WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/recv.c:532 ath_stoprecv+0x90/0x9a [ath9k]()
Hardware name: PDSBM
Could not stop RX, we could be confusing the DMA engine when we start RX up
Modules linked in: bluetooth aes_i586 aes_generic 8021q garp stp llc michael_mic macvlan pktgen fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6]
Pid: 16092, comm: kworker/u:0 Tainted: P        W   2.6.37-rc2-wl+ #50
Call Trace:
  [<78436f25>] warn_slowpath_common+0x77/0x8c
  [<f91f513e>] ? ath_stoprecv+0x90/0x9a [ath9k]
  [<f91f513e>] ? ath_stoprecv+0x90/0x9a [ath9k]
  [<78436fb6>] warn_slowpath_fmt+0x2e/0x30
  [<f91f513e>] ath_stoprecv+0x90/0x9a [ath9k]
  [<f91f40dc>] ath_set_channel+0x94/0x1e8 [ath9k]
  [<f8c73767>] ? ath_hw_cycle_counters_update+0xc4/0x114 [ath]
  [<f91f4574>] ath9k_config+0x344/0x423 [ath9k]
  [<f9111aaa>] ieee80211_hw_config+0x11b/0x125 [mac80211]
  [<f9115dea>] ieee80211_scan_work+0x29e/0x3f8 [mac80211]
  [<7845a5e5>] ? trace_hardirqs_on+0xb/0xd
  [<7878ea66>] ? _raw_spin_unlock_irq+0x22/0x2b
  [<78446ecb>] ? process_one_work+0x13e/0x2bf
  [<78446f3c>] process_one_work+0x1af/0x2bf
  [<78446ecb>] ? process_one_work+0x13e/0x2bf
  [<f9115b4c>] ? ieee80211_scan_work+0x0/0x3f8 [mac80211]
  [<7844868a>] worker_thread+0xf9/0x1bf
  [<78448591>] ? worker_thread+0x0/0x1bf
  [<7844b1ba>] kthread+0x62/0x67
  [<7844b158>] ? kthread+0x0/0x67
  [<784036c6>] kernel_thread_helper+0x6/0x1a


That, or similar,  was happening before, so your patch may still be fine.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

