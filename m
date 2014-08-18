Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:51558 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaHRNrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 09:47:05 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so5020567wes.20
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2014 06:47:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87d2c4pkks.fsf@kamboji.qca.qualcomm.com>
References: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
	<1407402260-29854-3-git-send-email-michal.kazior@tieto.com>
	<87d2c4pkks.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 18 Aug 2014 15:47:03 +0200
Message-ID: <CA+BoTQmTiEaZ03Nu-UiOn2ObW8e-m7it7_Th2KKCn+byFP+mPg@mail.gmail.com> (sfid-20140818_154709_316946_1860D250)
Subject: Re: [PATCH 2/5] ath10k: setup irq method in probe
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 August 2014 15:48, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> It doesn't make sense to re-init irqs completely
>> whenever transport is started/stopped. Do it just
>> once upon probing/removing.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> @@ -1905,22 +1915,10 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
>>               goto err;
>>       }
>>
>> -     ret = ath10k_ce_disable_interrupts(ar);
>> -     if (ret) {
>> -             ath10k_err("failed to disable CE interrupts: %d\n", ret);
>> -             goto err_ce;
>> -     }
>> -
>> -     ret = ath10k_pci_init_irq(ar);
>> -     if (ret) {
>> -             ath10k_err("failed to init irqs: %d\n", ret);
>> -             goto err_ce;
>> -     }
>> -
>>       ret = ath10k_pci_request_early_irq(ar);
>>       if (ret) {
>>               ath10k_err("failed to request early irq: %d\n", ret);
>> -             goto err_deinit_irq;
>> +             goto err_ce;
>>       }
>
> You add ath10k_pci_ce_init() to probe() and respective
> ath10k_pci_ce_deinit() to remove(), and you remove
> ath10k_pci_ce_deinit() from hif_power_down(). But why do you leave
> ath10k_pci_ce_init() to hif_power_up()? Isn't that unnecessary as we
> already do that in probe()?

Hmm.. I didn't check if copy engine register state (notable ring index
values) is guaranteed to be usable in all cases yet and decided it's
safer to just re-init it on each power up until it is proven it is not
necessary.


>
>> +     ath10k_info("pci irq %s (num %d) irq_mode %d reset_mode %d\n",
>> +                 ath10k_pci_get_irq_method(ar), ar_pci->num_msi_intrs,
>> +                 ath10k_pci_irq_mode, ath10k_pci_reset_mode);
>
> "pci irq %s interrupts %d irq_mode %d ..."

Will fix.


Michał
