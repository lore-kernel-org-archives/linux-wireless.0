Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48006 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbbLPU3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 15:29:55 -0500
Message-ID: <5671C99A.703@codeaurora.org> (sfid-20151216_212959_298971_EFF2233D)
Date: Wed, 16 Dec 2015 12:29:14 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, Peter Oh <poh@qca.qualcomm.com>,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: add modparam 'hw_csum' to make HW checksum configurable
References: <1450290051-15593-1-git-send-email-poh@qca.qualcomm.com> <5671AD10.70004@openwrt.org>
In-Reply-To: <5671AD10.70004@openwrt.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 12/16/2015 10:27 AM, Felix Fietkau wrote:
> On 2015-12-16 19:20, Peter Oh wrote:
>> Some hardwares such as QCA988X and QCA99X0 doesn't have
>> capability of checksum offload when frame formats are not
>> suitable for it such as Mesh frame.
>> Hence add a module parameter, hw_csum, to make checksum offload
>> configurable during module registration time.
>>
>> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
> How about instead of inventing yet another crappy module parameter, you
> call skb_checksum_help() in the driver in cases where the hardware is
> unable to offload the checksum calculation.
>
> That way the user has to worry about less driver specific hackery ;)
That will be good option for hardware not supporting HW checksum, but I 
mind that using the function will add more workload per every packet on 
critical data path when HW supports checksum resulting in throughput down.
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks,
Peter
