Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44672 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752916AbeDQMKf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 08:10:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 17 Apr 2018 17:40:34 +0530
From: pillair@codeaurora.org
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] ath10k: Enable SRRI/DRRI support on ddr for WCN3990
In-Reply-To: <87y3hnp9hj.fsf@kamboji.qca.qualcomm.com>
References: <1523370212-8778-1-git-send-email-pillair@codeaurora.org>
 <1523370212-8778-4-git-send-email-pillair@codeaurora.org>
 <87y3hnp9hj.fsf@kamboji.qca.qualcomm.com>
Message-ID: <6965b5c5716369967813b87705ec2c42@codeaurora.org> (sfid-20180417_141038_611592_67BB2FE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

The checkpatch warning has been addressed in v2 for this patchset.

Thanks,
Rakesh Pillai.

On 2018-04-16 18:57, Kalle Valo wrote:
> pillair@codeaurora.org writes:
> 
>> From: Govind Singh <govinds@codeaurora.org>
>> 
>> SRRI/DRRI are not mapped in the HW Shadow block and can lead
>> to un-clocked access if common subsystem in the target is
>> powered down due to idle mode.
>> 
>> To mitigate this problem SRRI/DRRI can be read from
>> DDR instead of doing an actual hardware read.
>> Host allocates non cached memory on ddr and configures
>> the physical address of this memory to the CE hardware.
>> The hardware updates the RRI on this particular location.
>> Read SRRI/DRRI from DDR location instead of
>> direct target read.
>> 
>> Enable retention restore on ddr using hw params to enable
>> in specific targets.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> 
> [...]
> 
>> +	for (i = 0; i < CE_COUNT; i++) {
>> +		ctrl1_regs = ar->hw_ce_regs->ctrl1_regs->addr;
>> +		ce_base_addr = ath10k_ce_base_address(ar, i);
>> +		ath10k_ce_write32(ar, ce_base_addr + ctrl1_regs,
>> +				  ath10k_ce_read32(ar,
>> +				  ce_base_addr + ctrl1_regs) |
>> +				  ar->hw_ce_regs->upd->mask);
>> +	}
> 
> This gives a checkpatch warning:
> 
> drivers/net/wireless/ath/ath10k/ce.c:1917: Alignment should match open
> parenthesis
> 
> You could fix that, and make the code a lot more readable, with
> something like this:
> 
> tmp = ath10k_ce_read32(ar, ce_base_addr + ctrl1_regs);
> tmp |= ar->hw_ce_regs->upd->mask;
> ath10k_ce_write32(ar, ce_base_addr + ctrl1_regs, tmp);
> 
> Usually it's a good practise avoid making clever tricks, simple code is
> a lot easier to read.
