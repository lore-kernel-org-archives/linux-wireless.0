Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37371 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab1BJEtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 23:49:41 -0500
Message-ID: <4D536E61.3080202@candelatech.com>
Date: Wed, 09 Feb 2011 20:49:37 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Set up tx-queue-mapping in subif_start_xmit.
References: <1297299951-25604-1-git-send-email-greearb@candelatech.com> <1297299951-25604-2-git-send-email-greearb@candelatech.com> <4D533C28.4000704@openwrt.org>
In-Reply-To: <4D533C28.4000704@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2011 05:15 PM, Felix Fietkau wrote:
> On 2011-02-10 2:05 AM, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Otherwise, ath9k gets confused about which queue to use
>> and spews a warning like this when driving traffic with
>> pktgen.
>>
>> WARNING: at drivers/net/wireless/ath/ath9k/xmit.c:1748 ath_tx_start+0x4a2/0x662 [ath9k]()
>> Hardware name: To Be Filled By O.E.M.
>> Modules linked in: ath5k arc4 ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 nfs lockd bluetooth cryptd aes_i586 aes_generic veth 8021q garp stp l]
>> Pid: 1729, comm: kpktgend_0 Tainted: G        W   2.6.38-rc4-wl+ #21
>> Call Trace:
>>   [<c043091b>] ? warn_slowpath_common+0x65/0x7a
>>   [<fabe784e>] ? ath_tx_start+0x4a2/0x662 [ath9k]
>>   [<c043093f>] ? warn_slowpath_null+0xf/0x13
>>   [<fabe784e>] ? ath_tx_start+0x4a2/0x662 [ath9k]
>>   [<fabe14d0>] ? ath9k_tx+0x14f/0x183 [ath9k]
>>   [<fab9026d>] ? __ieee80211_tx+0x10c/0x18c [mac80211]
>>   [<fab90397>] ? ieee80211_tx+0xaa/0x188 [mac80211]
>>   [<fab905f3>] ? ieee80211_xmit+0x17e/0x186 [mac80211]
>>   [<fab8ecc0>] ? ieee80211_skb_resize+0x8e/0xd2 [mac80211]
>>   [<fab9148b>] ? ieee80211_subif_start_xmit+0x643/0x65c [mac80211]
>>   [<c0440000>] ? rescuer_thread+0x25/0x1c8
>>   [<f92cd354>] ? pktgen_thread_worker+0x114c/0x1b44 [pktgen]
>>   [<fab90e48>] ? ieee80211_subif_start_xmit+0x0/0x65c [mac80211]
>>   [<c042d612>] ? default_wake_function+0xb/0xd
>>   [<c04254c7>] ? __wake_up_common+0x34/0x5c
>>   [<c0443a29>] ? autoremove_wake_function+0x0/0x2f
>>   [<f92cc208>] ? pktgen_thread_worker+0x0/0x1b44 [pktgen]
>>   [<c044371a>] ? kthread+0x62/0x67
>>   [<c04436b8>] ? kthread+0x0/0x67
>>   [<c04035f6>] ? kernel_thread_helper+0x6/0x10
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>>
>> NOTE:  This needs review by someone who actually understands this code.
>>
>> :100644 100644 17ef4f4... 95eb4fa... M	net/mac80211/tx.c
>>   net/mac80211/tx.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index 17ef4f4..95eb4fa 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -2028,6 +2028,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>>   	} else
>>   		memcpy(skb_push(skb, hdrlen),&hdr, hdrlen);
>>
>> +	skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));
> I think this is wrong - it's up to the network stack to set up the queue
> mapping. The bug you're looking for is probably in pktgen - I think
> there was a similar issue in the bridge code at some point, which was
> also fixed.

Pktgen has a feature that allows it to set the queue-map.  The problem
is that wifi, and particular ath9k, has some preconceptions about what
skb priority should match to what queue, it seems.

I think that mac80211 should do whatever needed to fix up any skb
handed to it.

An alternative is to hack on ath9k to make it handle that case,
but even if we got that to work somehow, other drivers may have
similar issues.

Or, fix thing somehow so that if pktgen says queue-map is 0, then
the wifi code just accepts that and doesn't try to use queue 2
instead.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
