Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22756 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaHSLry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 07:47:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/5] ath10k: setup irq method in probe
References: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
	<1407402260-29854-3-git-send-email-michal.kazior@tieto.com>
	<87d2c4pkks.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmTiEaZ03Nu-UiOn2ObW8e-m7it7_Th2KKCn+byFP+mPg@mail.gmail.com>
Date: Tue, 19 Aug 2014 14:47:44 +0300
In-Reply-To: <CA+BoTQmTiEaZ03Nu-UiOn2ObW8e-m7it7_Th2KKCn+byFP+mPg@mail.gmail.com>
	(Michal Kazior's message of "Mon, 18 Aug 2014 15:47:03 +0200")
Message-ID: <8738csbt0f.fsf@kamboji.qca.qualcomm.com> (sfid-20140819_134826_077600_B5FD94A1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>>> @@ -1905,22 +1915,10 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
>>>               goto err;
>>>       }
>>>
>>> -     ret = ath10k_ce_disable_interrupts(ar);
>>> -     if (ret) {
>>> -             ath10k_err("failed to disable CE interrupts: %d\n", ret);
>>> -             goto err_ce;
>>> -     }
>>> -
>>> -     ret = ath10k_pci_init_irq(ar);
>>> -     if (ret) {
>>> -             ath10k_err("failed to init irqs: %d\n", ret);
>>> -             goto err_ce;
>>> -     }
>>> -
>>>       ret = ath10k_pci_request_early_irq(ar);
>>>       if (ret) {
>>>               ath10k_err("failed to request early irq: %d\n", ret);
>>> -             goto err_deinit_irq;
>>> +             goto err_ce;
>>>       }
>>
>> You add ath10k_pci_ce_init() to probe() and respective
>> ath10k_pci_ce_deinit() to remove(), and you remove
>> ath10k_pci_ce_deinit() from hif_power_down(). But why do you leave
>> ath10k_pci_ce_init() to hif_power_up()? Isn't that unnecessary as we
>> already do that in probe()?
>
> Hmm.. I didn't check if copy engine register state (notable ring index
> values) is guaranteed to be usable in all cases yet and decided it's
> safer to just re-init it on each power up until it is proven it is not
> necessary.

So I have been trying to follow this naming scheme for initilisation:

_create() - called during device probe time
_start() - if up / power up
_stop() - if down / power down
_destroy() - called when device is removed

If you call ce_init() both in create() and start() time there has to be
some redundant code and I think the function should be split. This isn't
a concern now, but something for the future.

-- 
Kalle Valo
