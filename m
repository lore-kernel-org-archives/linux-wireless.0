Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:25280 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbbLQWCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 17:02:36 -0500
Message-ID: <567330CE.3080808@qca.qualcomm.com> (sfid-20151217_230240_304656_EC41F5A4)
Date: Thu, 17 Dec 2015 14:01:50 -0800
From: Peter Oh <poh@qca.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, Peter Oh <poh@codeaurora.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add modparam 'hw_csum' to make HW checksum configurable
References: <1450290051-15593-1-git-send-email-poh@qca.qualcomm.com> <5671AD10.70004@openwrt.org> <5671C99A.703@codeaurora.org> <5671CAF5.6010606@openwrt.org> <5671CDBD.5060006@codeaurora.org> <5671CF63.9040308@openwrt.org> <5671D56F.8030903@codeaurora.org> <5671DDA1.5030709@openwrt.org> <5671F8B7.2060801@codeaurora.org> <5671FADD.6010009@openwrt.org>
In-Reply-To: <5671FADD.6010009@openwrt.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 12/16/2015 03:59 PM, Felix Fietkau wrote:
> On 2015-12-17 00:50, Peter Oh wrote:
>> On 12/16/2015 01:54 PM, Felix Fietkau wrote:
>>> On 2015-12-16 22:19, Peter Oh wrote:
>>>> On 12/16/2015 12:53 PM, Felix Fietkau wrote:
>>>>> On 2015-12-16 21:46, Peter Oh wrote:
>>>>>> On 12/16/2015 12:35 PM, Felix Fietkau wrote:
>>>>>>> On 2015-12-16 21:29, Peter Oh wrote:
>>>>>>>> On 12/16/2015 10:27 AM, Felix Fietkau wrote:
>>>>>>>>> On 2015-12-16 19:20, Peter Oh wrote:
>>>>>>>>>> Some hardwares such as QCA988X and QCA99X0 doesn't have
>>>>>>>>>> capability of checksum offload when frame formats are not
>>>>>>>>>> suitable for it such as Mesh frame.
>>>>>>>>>> Hence add a module parameter, hw_csum, to make checksum offload
>>>>>>>>>> configurable during module registration time.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
>>>>>>>>> How about instead of inventing yet another crappy module parameter, you
>>>>>>>>> call skb_checksum_help() in the driver in cases where the hardware is
>>>>>>>>> unable to offload the checksum calculation.
>>>>>>>>>
>>>>>>>>> That way the user has to worry about less driver specific hackery ;)
>>>>>>>> That will be good option for hardware not supporting HW checksum, but I
>>>>>>>> mind that using the function will add more workload per every packet on
>>>>>>>> critical data path when HW supports checksum resulting in throughput down.
>>>>>>> I didn't mean calling it for every single frame in the data path.
>>>>>>> What I'm suggesting is calling it selectively only for mesh frames, or
>>>>>>> any other frames that the hardware cannot offload, and leaving the rest
>>>>>>> for the hardware to process.
>>>>>>>
>>>>>>> There should be no performance difference between disabling checksum
>>>>>>> offload and calling skb_checksum_help from the driver.
>>>>>> To call it selectively for Mesh frame or interface, we need to add it on
>>>>>> mac80211 layer such as ieee80211_build_hdr() since driver layer does not
>>>>>> care the interface type in data path.
>>>>> No need to change mac80211 - it only touches the headers, and
>>>>> skb_checksum_help does not care about that. The skb has enough
>>>>> information for it to find the right range to calculate the checksum and
>>>>> the place to store it.
>>>> If mentioned to use the function to mesh frame only without touching
>>>> mac80211, then how do you suggest it to apply it only to mesh frame
>>>> without interfere other data frames?
>>>> Can you share your example?
>>> It's trivial - in ath10k_tx you do this:
>>>
>>> if (vif->type == NL80211_IFTYPE_MESH_POINT &&
>>>       skb->ip_summed == CHECKSUM_PARTIAL)
>>> 	skb_checksum_help(skb);
>> Thank you Felix for the quick response.
>> I agree on your user experience opinion,
>> but what do you think when ath10k has a new chip supporting HW checksum
>> for Mesh?
> Then you simply update the checks. What's the big deal?
keep adding condition to such data path is not a good option.
I also considered again about user experiences and reached to that this 
patch won't disturb user experience since the products will ship with 
proper module settings. for instance the parameter will be turned on if 
product support it other wise will be turned off as they shipped, so 
that users don't need to touch it.
In addition, for enterprise customers, they do care even a very small 
performance drop or enhancement especially when they are running BMT 
among vendors.
So we need to avoid adding extra codes in data path in my opinion.
> - Felix

