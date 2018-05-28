Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36778 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968556AbeE1KQo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 06:16:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 28 May 2018 13:16:42 +0300
From: merez@codeaurora.org
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Gidon Studinski <gidons@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 3/7] wil6210: initialize TX and RX enhanced DMA rings
In-Reply-To: <87in7ckk3k.fsf@purkki.adurom.net>
References: <1526227375-31881-1-git-send-email-merez@codeaurora.org>
 <1526227375-31881-4-git-send-email-merez@codeaurora.org>
 <87muwokki3.fsf@purkki.adurom.net> <87in7ckk3k.fsf@purkki.adurom.net>
Message-ID: <4086372eaafb04727c3d8265e6991925@codeaurora.org> (sfid-20180528_174725_417297_A7AC6A4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-25 15:14, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
>> Maya Erez <merez@codeaurora.org> writes:
>> 
>>> From: Gidon Studinski <gidons@codeaurora.org>
>>> 
>>> Enhanced DMA design includes the following rings:
>>> - Single RX descriptor ring is used for all VIFs
>>> - Multiple RX status rings are supported, to allow RSS
>>> - TX descriptor ring is allocated per connection
>>> - A single TX status ring is used for all TX descriptor rings
>>> 
>>> This patch initializes and frees the above descriptor and
>>> status rings.
>>> 
>>> The RX SKBs are handled by a new entity of RX buffers manager,
>>> which handles RX buffers, each one points to an allocated SKB.
>>> During Rx completion processing, the driver extracts a buffer
>>> ID which is used as an index to the buffers array.
>>> After the SKB is freed the buffer is moved from the 'active'
>>> list to the 'free' list, indicating it can be used for another
>>> descriptor. During Rx refill, SKBs are allocated and attached
>>> to 'free' buffers. Those buffers are attached to new descriptors
>>> and moved to the 'active' list.
>>> 
>>> Signed-off-by: Gidon Studinski <gidons@codeaurora.org>
>>> Signed-off-by: Maya Erez <merez@codeaurora.org>
>> 
>> [...]
>> 
>>> --- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
>>> +++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
>>> @@ -32,6 +32,10 @@
>>>  module_param(ftm_mode, bool, 0444);
>>>  MODULE_PARM_DESC(ftm_mode, " Set factory test mode, default - 
>>> false");
>>> 
>>> +static bool use_enhanced_dma_hw = true;
>>> +module_param(use_enhanced_dma_hw, bool, 0444);
>>> +MODULE_PARM_DESC(use_enhanced_dma_hw, " Use enhanced or legacy DMA 
>>> HW. Default: true when available");
>> 
>> Similarly as with debugfs, please document in the commit log any 
>> changes
>> in module parameters.
> 
> Oh, and in this patch there are even more new module parameters and no
> mention them in the commit log.
> 
> But a bigger problem is that wil6210 has now 24 module parameters (with
> this patchset included). That is quite a lot, are those all really
> needed? Module parameters are bad user experience and there should be
> good reasons before adding them.

24 module parameters is indeed a lot.
We will review the new module parameters added for enhanced DMA to check 
what can be configured via debugfs.
Regardless, we will review the existing module parameters and see what 
can be removed or
moved to debugfs.

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
