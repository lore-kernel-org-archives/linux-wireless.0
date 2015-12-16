Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:45649 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966737AbbLPVyw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 16:54:52 -0500
Subject: Re: [PATCH] ath10k: add modparam 'hw_csum' to make HW checksum
 configurable
To: Peter Oh <poh@codeaurora.org>, Peter Oh <poh@qca.qualcomm.com>,
	ath10k@lists.infradead.org
References: <1450290051-15593-1-git-send-email-poh@qca.qualcomm.com>
 <5671AD10.70004@openwrt.org> <5671C99A.703@codeaurora.org>
 <5671CAF5.6010606@openwrt.org> <5671CDBD.5060006@codeaurora.org>
 <5671CF63.9040308@openwrt.org> <5671D56F.8030903@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <5671DDA1.5030709@openwrt.org> (sfid-20151216_225455_148952_03C9E1B9)
Date: Wed, 16 Dec 2015 22:54:41 +0100
MIME-Version: 1.0
In-Reply-To: <5671D56F.8030903@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-12-16 22:19, Peter Oh wrote:
> 
> On 12/16/2015 12:53 PM, Felix Fietkau wrote:
>> On 2015-12-16 21:46, Peter Oh wrote:
>>> On 12/16/2015 12:35 PM, Felix Fietkau wrote:
>>>> On 2015-12-16 21:29, Peter Oh wrote:
>>>>> On 12/16/2015 10:27 AM, Felix Fietkau wrote:
>>>>>> On 2015-12-16 19:20, Peter Oh wrote:
>>>>>>> Some hardwares such as QCA988X and QCA99X0 doesn't have
>>>>>>> capability of checksum offload when frame formats are not
>>>>>>> suitable for it such as Mesh frame.
>>>>>>> Hence add a module parameter, hw_csum, to make checksum offload
>>>>>>> configurable during module registration time.
>>>>>>>
>>>>>>> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
>>>>>> How about instead of inventing yet another crappy module parameter, you
>>>>>> call skb_checksum_help() in the driver in cases where the hardware is
>>>>>> unable to offload the checksum calculation.
>>>>>>
>>>>>> That way the user has to worry about less driver specific hackery ;)
>>>>> That will be good option for hardware not supporting HW checksum, but I
>>>>> mind that using the function will add more workload per every packet on
>>>>> critical data path when HW supports checksum resulting in throughput down.
>>>> I didn't mean calling it for every single frame in the data path.
>>>> What I'm suggesting is calling it selectively only for mesh frames, or
>>>> any other frames that the hardware cannot offload, and leaving the rest
>>>> for the hardware to process.
>>>>
>>>> There should be no performance difference between disabling checksum
>>>> offload and calling skb_checksum_help from the driver.
>>> To call it selectively for Mesh frame or interface, we need to add it on
>>> mac80211 layer such as ieee80211_build_hdr() since driver layer does not
>>> care the interface type in data path.
>> No need to change mac80211 - it only touches the headers, and
>> skb_checksum_help does not care about that. The skb has enough
>> information for it to find the right range to calculate the checksum and
>> the place to store it.
> If mentioned to use the function to mesh frame only without touching 
> mac80211, then how do you suggest it to apply it only to mesh frame 
> without interfere other data frames?
> Can you share your example?
It's trivial - in ath10k_tx you do this:

if (vif->type == NL80211_IFTYPE_MESH_POINT &&
    skb->ip_summed == CHECKSUM_PARTIAL)
	skb_checksum_help(skb);

>>> In that case it will also introduce throughput degrade to HW that
>>> supports HW checksum for Mesh.
>> This doesn't make any sense to me. Are you saying that there's no way
>> for the driver to detect the cases where the hardware cannot do checksum
>> offloading?
> I'm saying the case that HW supports checksum except for specific frame 
> such as Mesh and to make driver support both case dynamically at code 
> level, it requires extra codes which need to check if the frame is Mesh 
> or not. Since this approach requires extra workload especially in data 
> path, it will degrade driver's performance.
The check is cheap enough that it will not have any visible impact. And
the improved user experience is certainly worth it ;)

- Felix
