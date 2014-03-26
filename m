Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45661 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaCZKFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 06:05:24 -0400
Received: by mail-wi0-f169.google.com with SMTP id hm4so4425640wib.2
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 03:05:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ppl9z54w.fsf@kamboji.qca.qualcomm.com>
References: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
	<1395745943-29492-3-git-send-email-michal.kazior@tieto.com>
	<87ppl9z54w.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 26 Mar 2014 11:05:23 +0100
Message-ID: <CA+BoTQnMZ+B0nC_MdYqKk6z1wH-bK47vE+Uknqnv+FpJRKaRjA@mail.gmail.com> (sfid-20140326_110528_359190_B9ECBF1F)
Subject: Re: [PATCH 2/2] ath10k: split ce initialization and allocation
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 March 2014 10:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Definitions by which copy engine structure are
>> allocated do not change so it doesn't make much
>> sense to re-create those structures each time
>> device is booted (e.g. due to firmware recovery).
>>
>> This should decrease chance of memory allocation
>> failures.
>>
>> Reported-By: Avery Pennarun <apenwarr@gmail.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/ce.h
>> +++ b/drivers/net/wireless/ath/ath10k/ce.h
>> @@ -104,7 +104,8 @@ struct ath10k_ce_ring {
>>       void *shadow_base_unaligned;
>>       struct ce_desc *shadow_base;
>>
>> -     void **per_transfer_context;
>> +     /* keep last */
>> +     void *per_transfer_context[0];
>>  };
>
> If possible, I would prefer to have changes like this in a separate
> patch as it makes easier to review. Or at least mention the change in
> the commit log.

The patch already alters the allocation code so I thought I'd squash
this here. You want me to just update the commit log or split it up?


>> @@ -2018,9 +2029,9 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
>>       ath10k_pci_free_early_irq(ar);
>>       ath10k_pci_kill_tasklet(ar);
>>       ath10k_pci_deinit_irq(ar);
>> +     ath10k_pci_ce_deinit(ar);
>>       ath10k_pci_warm_reset(ar);
>>
>> -     ath10k_pci_ce_deinit(ar);
>>       if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
>>               ath10k_do_pci_sleep(ar);
>>  }
>
> Why this?

ath10k_pci_ce_deinit() zeroes copy engine registers now so I thought
it's nice to have this done before reset.

Before ath10k_pci_ce_deinit() freed memory so it was required to reset
the device beforehand. Otherwise you risked device accessing memory
that wasn't mapped nor allocated by the driver anymore.


Michał
