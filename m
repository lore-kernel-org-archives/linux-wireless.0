Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50054 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab0KRSPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 13:15:14 -0500
Message-ID: <4CE56D2E.7080509@candelatech.com>
Date: Thu, 18 Nov 2010 10:15:10 -0800
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

I'll give this a try later.  Overnight my ath9k box started spitting endless ath9k TX DMA
errors and it seems to have corrupted the / file-system or disk again:

[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
dracut: Starting plymouth daemon
Gdracut: rd_NO_DM: removing DM RAID activation
dracut: rd_NO_MD: removing MD RAID activation
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
G

No root device found
GG

No root device found

Boot has failed, sleeping forever.



Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

