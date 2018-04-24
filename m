Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57776 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756224AbeDXHcj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 03:32:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jared Bents <jared.bents@rockwellcollins.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v1 1/1] ath10k: convert kmemdup to dma_alloc_coherent
References: <1524238793-24481-1-git-send-email-jared.bents@rockwellcollins.com>
        <87in8lf314.fsf@kamboji.qca.qualcomm.com>
        <CAM=7fbeOBLMteeCxSVHzkwx5-MTiiHpudvHpiu5ydF=c33T1Fw@mail.gmail.com>
Date: Tue, 24 Apr 2018 10:32:34 +0300
In-Reply-To: <CAM=7fbeOBLMteeCxSVHzkwx5-MTiiHpudvHpiu5ydF=c33T1Fw@mail.gmail.com>
        (Jared Bents's message of "Mon, 23 Apr 2018 13:21:54 -0500")
Message-ID: <874lk1cb59.fsf@kamboji.qca.qualcomm.com> (sfid-20180424_093243_295833_0D9E74BD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jared Bents <jared.bents@rockwellcollins.com> writes:

> On Sat, Apr 21, 2018 at 2:10 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Jared Bents <jared.bents@rockwellcollins.com> writes:
>>
>>> Update to convert the use of kmemdup to dma_alloc_coherent as
>>> dma_alloc_coherent will consider DMA region limits such as
>>> those seen with CONFIG_FSL_PCI && CONFIG_ZONE_DMA32 whereas
>>> kmemdup does not take those limitations into account.
>>>
>>> Signed-off-by: Jared Bents <jared.bents@rockwellcollins.com>
>>
>> Does this fix a real bug or is it just a theoretical issue you noticed
>> while looking at the code? If this fixes a real bug please give a
>> description of it.
>
> It fixes a real bug that I have experienced.  My processor is a qoriq
> T1042 powerpc and I am running the fsl-sdk-v2.0-1703 kernel (mainline
> v4.1.35-rt41).  In 32 bit, the ath10k and ath9k work without issue.
> After migrating to 64 bit, we experienced dma mapping errors with both
> devices.  

Ok, please add this to the commit log.

> Here is the output from the dma mapping problem:
>
> ath10k_pci 0000:01:00.0: unable to get target info from device
> ath10k_pci 0000:01:00.0: could not get target info (-5)
> ath10k_pci 0000:01:00.0: could not probe fw (-5)

Please add this also.

And the patch doesn't seem to apply to at all, not sure why. But please
submit v2 and make sure that it applies to my ath.git master branch.

patching file drivers/net/wireless/ath/ath10k/pci.c
Hunk #1 FAILED at 1372.
Hunk #2 FAILED at 1422.
2 out of 2 hunks FAILED -- saving rejects to file drivers/net/wireless/ath/ath10k/pci.c.rej

More info:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches

-- 
Kalle Valo
