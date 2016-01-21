Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37470 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbcAUGBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 01:01:24 -0500
Received: by mail-wm0-f47.google.com with SMTP id n5so63027583wmn.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 22:01:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <569FE132.7040006@candelatech.com>
References: <1452693668-30030-1-git-send-email-michal.kazior@tieto.com>
	<1452693668-30030-5-git-send-email-michal.kazior@tieto.com>
	<569FE132.7040006@candelatech.com>
Date: Thu, 21 Jan 2016 07:01:23 +0100
Message-ID: <CA+BoTQkvZN65dPN4anjEwu3H-yNkgHJz60MY5stNwqvTxRTTjA@mail.gmail.com> (sfid-20160121_070128_423786_559DAE60)
Subject: Re: [PATCH 4/5] ath10k: clean up cont frag desc init code
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 January 2016 at 20:34, Ben Greear <greearb@candelatech.com> wrote:
> On 01/13/2016 06:01 AM, Michal Kazior wrote:
>>
>> This makes the code easier to extend and re-use.
>>
>> While at it fix _warn to _err. Other than that
>> there are no functional changes.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/htt_tx.c | 58
>> ++++++++++++++++++++++----------
>>   1 file changed, 41 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c
>> b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> index b3adadb5f824..41a9811820e8 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> @@ -97,6 +97,41 @@ void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt,
>> u16 msdu_id)
>>         idr_remove(&htt->pending_tx, msdu_id);
>>   }
>>
>> +static void ath10k_htt_tx_free_cont_frag_desc(struct ath10k_htt *htt)
>> +{
>> +       size_t size;
>> +
>> +       if (!htt->frag_desc.vaddr)
>> +               return;
>> +
>> +       size = htt->max_num_pending_tx * sizeof(struct htt_msdu_ext_desc);
>> +
>> +       dma_free_coherent(htt->ar->dev,
>> +                         size,
>> +                         htt->frag_desc.vaddr,
>> +                         htt->frag_desc.paddr);
>> +}
>> +
>> +static int ath10k_htt_tx_alloc_cont_frag_desc(struct ath10k_htt *htt)
>> +{
>> +       struct ath10k *ar = htt->ar;
>> +       size_t size;
>> +
>> +       if (!ar->hw_params.continuous_frag_desc)
>> +               return 0;
>> +
>> +       size = htt->max_num_pending_tx * sizeof(struct htt_msdu_ext_desc);
>> +       htt->frag_desc.vaddr = dma_alloc_coherent(ar->dev, size,
>> +                                                 &htt->frag_desc.paddr,
>> +                                                 GFP_DMA);
>
>
> Did you mean to change GFP_KERNEL to GFP_DMA?

Ah, good catch! I obviously meant to keep GFP_KERNEL. I must've missed
that during a rebase at some point.


Michał
