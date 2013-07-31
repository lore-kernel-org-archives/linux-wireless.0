Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:37056 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3GaKu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 06:50:26 -0400
Received: by mail-bk0-f45.google.com with SMTP id je2so185926bkc.18
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 03:50:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQn-VF-Ehio4Az6GenGb5cBTm2t2a9bQFAuALFhx+MQ+cw@mail.gmail.com>
References: <1374129572-6079-1-git-send-email-michal.kazior@tieto.com>
	<87d2pzuc90.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQn-VF-Ehio4Az6GenGb5cBTm2t2a9bQFAuALFhx+MQ+cw@mail.gmail.com>
Date: Wed, 31 Jul 2013 12:50:25 +0200
Message-ID: <CA+BoTQn4xc6M8cwH7tFiq7823-e7LNS=cwWa9F4c5L_xc8POZw@mail.gmail.com> (sfid-20130731_125030_468284_EE668CCB)
Subject: Re: [PATCH] ath10k: move irq setup
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 July 2013 07:50, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 30 July 2013 20:35, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> There was a slight race during PCI shutdown. Since
>>> interrupts weren't really stopped (only Copy
>>> Engine interrupts were disabled through device hw
>>> registers) it was possible for a firmware
>>> indication (crash) interrupt to come in after
>>> tasklets were synced/killed. This would cause
>>> memory corruption and a panic in most cases. It
>>> was also possible for interrupt to come before CE
>>> was initialized during device probing.
>>>
>>> Interrupts are required for BMI phase so they are enabled as soon as
>>> power_up() is called but are freed upon both power_down() and stop()
>>> so there's asymmetry here. As by design stop() cannot be followed by
>>> start() it is okay. Both power_down() and stop() should be merged
>>> later on to avoid confusion.
>>
>> Why are the interrupts freed both in power_down() and stop()? I don't
>> get that.
>>
>> What if we call disable_irq() in power_down() instead?
>
> power_down() must call free_irq(), because power_up() calls
> request_irq() (if you want the symmetry). If anything, the stop()
> should call disable_irq(), but wouldn't that mean start() should call
> enable_irq()? But than, irqs are needed before start()..
>
> I did think about disable_irq() but AFAIR you need to enable_irq()
> later on (so either way you need to keep track of the irq state or
> you'll get a ton of WARN_ONs from the system). I'll double check that
> and report back later

enable/disable_irq must be balanced as well.

There are two cases of power cycle:
 * power_up, power_down
 * power_up, start, stop, power_down

If irq setup is moved from pci_probe/remove to power_up/power_down,
then stop() still needs irqs to be halted - either disable_irq, or
free_irq. In the latter case power_down must be prepared and not issue
free_irq again.

If irq setup remains in pci_probe/remove then both stop() and
power_down() need irqs to be halted too. Same issue applies.

If stop/power_down is merged than the whole problem is solved. This
seems like the sane solution to the whole problem but requires some
refactoring to be done first.


Pozdrawiam / Best regards,
Micha³ Kazior.
