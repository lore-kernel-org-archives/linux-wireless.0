Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:10781 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933137AbbLQV4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 16:56:33 -0500
Message-ID: <56732F64.2020508@qca.qualcomm.com> (sfid-20151217_225637_600717_C4EE6B28)
Date: Thu, 17 Dec 2015 13:55:48 -0800
From: Peter Oh <poh@qca.qualcomm.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>,
	Peter Oh <poh@codeaurora.org>
CC: "nbd@openwrt.org" <nbd@openwrt.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add modparam 'hw_csum' to make HW checksum configurable
References: <1450290051-15593-1-git-send-email-poh@qca.qualcomm.com>	<5671AD10.70004@openwrt.org>	<5671C99A.703@codeaurora.org>	<5671CAF5.6010606@openwrt.org>	<5671CDBD.5060006@codeaurora.org>	<5671CF63.9040308@openwrt.org>	<5671D56F.8030903@codeaurora.org>	<5671DDA1.5030709@openwrt.org>	<5671F8B7.2060801@codeaurora.org> <CA+BoTQmOg3gACzk5PAtkyDo1a5WJuCauOXPZKqL+cgVi+n1HCg@mail.gmail.com>
In-Reply-To: <CA+BoTQmOg3gACzk5PAtkyDo1a5WJuCauOXPZKqL+cgVi+n1HCg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 12/16/2015 11:29 PM, Michal Kazior wrote:
> On 17 December 2015 at 00:50, Peter Oh <poh@codeaurora.org> wrote:
>> On 12/16/2015 01:54 PM, Felix Fietkau wrote:
>>> On 2015-12-16 22:19, Peter Oh wrote:
> [...]
>>>> If mentioned to use the function to mesh frame only without touching
>>>> mac80211, then how do you suggest it to apply it only to mesh frame
>>>> without interfere other data frames?
>>>> Can you share your example?
>>> It's trivial - in ath10k_tx you do this:
>>>
>>> if (vif->type == NL80211_IFTYPE_MESH_POINT &&
>>>       skb->ip_summed == CHECKSUM_PARTIAL)
>>>          skb_checksum_help(skb);

>> Thank you Felix for the quick response.
>> I agree on your user experience opinion,
>> but what do you think when ath10k has a new chip supporting HW checksum for
>> Mesh?
> You can simply introduce a fw-feature flag saying
> "supports_mesh_csum_offload" later and skip the skb_checksum_help() if
> it's set.
If we rely on fw-feature flag, then we are not able to use HW checksum 
at all even for AP/STA interfaces.

>
> Michał
Thanks,
Peter
