Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:48158 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaCZLNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 07:13:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: split ce initialization and allocation
References: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
	<1395745943-29492-3-git-send-email-michal.kazior@tieto.com>
	<87ppl9z54w.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnMZ+B0nC_MdYqKk6z1wH-bK47vE+Uknqnv+FpJRKaRjA@mail.gmail.com>
Date: Wed, 26 Mar 2014 13:13:05 +0200
In-Reply-To: <CA+BoTQnMZ+B0nC_MdYqKk6z1wH-bK47vE+Uknqnv+FpJRKaRjA@mail.gmail.com>
	(Michal Kazior's message of "Wed, 26 Mar 2014 11:05:23 +0100")
Message-ID: <87d2h9yzzy.fsf@kamboji.qca.qualcomm.com> (sfid-20140326_121322_541429_88DC5373)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 26 March 2014 10:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> --- a/drivers/net/wireless/ath/ath10k/ce.h
>>> +++ b/drivers/net/wireless/ath/ath10k/ce.h
>>> @@ -104,7 +104,8 @@ struct ath10k_ce_ring {
>>>       void *shadow_base_unaligned;
>>>       struct ce_desc *shadow_base;
>>>
>>> -     void **per_transfer_context;
>>> +     /* keep last */
>>> +     void *per_transfer_context[0];
>>>  };
>>
>> If possible, I would prefer to have changes like this in a separate
>> patch as it makes easier to review. Or at least mention the change in
>> the commit log.
>
> The patch already alters the allocation code so I thought I'd squash
> this here. You want me to just update the commit log or split it up?

In this case updating the commit log is fine.

>>> @@ -2018,9 +2029,9 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
>>>       ath10k_pci_free_early_irq(ar);
>>>       ath10k_pci_kill_tasklet(ar);
>>>       ath10k_pci_deinit_irq(ar);
>>> +     ath10k_pci_ce_deinit(ar);
>>>       ath10k_pci_warm_reset(ar);
>>>
>>> -     ath10k_pci_ce_deinit(ar);
>>>       if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
>>>               ath10k_do_pci_sleep(ar);
>>>  }
>>
>> Why this?
>
> ath10k_pci_ce_deinit() zeroes copy engine registers now so I thought
> it's nice to have this done before reset.
>
> Before ath10k_pci_ce_deinit() freed memory so it was required to reset
> the device beforehand. Otherwise you risked device accessing memory
> that wasn't mapped nor allocated by the driver anymore.

But can you split this change into it's own patch, please? Just in case
if there are regressions, it's easier to find the culprit.

-- 
Kalle Valo
