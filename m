Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:59640 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab3GaFuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 01:50:39 -0400
Received: by mail-bk0-f52.google.com with SMTP id e11so87273bkh.11
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2013 22:50:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87d2pzuc90.fsf@kamboji.qca.qualcomm.com>
References: <1374129572-6079-1-git-send-email-michal.kazior@tieto.com>
	<87d2pzuc90.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 31 Jul 2013 07:50:37 +0200
Message-ID: <CA+BoTQn-VF-Ehio4Az6GenGb5cBTm2t2a9bQFAuALFhx+MQ+cw@mail.gmail.com> (sfid-20130731_075043_235096_A6297197)
Subject: Re: [PATCH] ath10k: move irq setup
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 July 2013 20:35, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> There was a slight race during PCI shutdown. Since
>> interrupts weren't really stopped (only Copy
>> Engine interrupts were disabled through device hw
>> registers) it was possible for a firmware
>> indication (crash) interrupt to come in after
>> tasklets were synced/killed. This would cause
>> memory corruption and a panic in most cases. It
>> was also possible for interrupt to come before CE
>> was initialized during device probing.
>>
>> Interrupts are required for BMI phase so they are enabled as soon as
>> power_up() is called but are freed upon both power_down() and stop()
>> so there's asymmetry here. As by design stop() cannot be followed by
>> start() it is okay. Both power_down() and stop() should be merged
>> later on to avoid confusion.
>
> Why are the interrupts freed both in power_down() and stop()? I don't
> get that.
>
> What if we call disable_irq() in power_down() instead?

power_down() must call free_irq(), because power_up() calls
request_irq() (if you want the symmetry). If anything, the stop()
should call disable_irq(), but wouldn't that mean start() should call
enable_irq()? But than, irqs are needed before start()..

I did think about disable_irq() but AFAIR you need to enable_irq()
later on (so either way you need to keep track of the irq state or
you'll get a ton of WARN_ONs from the system). I'll double check that
and report back later


>> Before this can be really properly fixed var/hw
>> init code split is necessary.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>
>> Please note: this is based on my (still under
>> review at the time of posting) previous patchests:
>> device setup refactor and recovery.
>>
>> I'm posting this before those patchsets are merged
>> so anyone interested in testing this fix (I can't
>> reproduce the problem on my setup) can give it a
>> try.
>
> This was reported by Ben, right? So this sould have a Reported-by line
> attributing him.

Yes. I'll fix that, provided we get through the review with the patch :)


>> @@ -1783,16 +1792,24 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>>       return 0;
>>
>>  err_ce:
>> +     /* XXX: Until var/hw init is split it's impossible to fix the ordering
>> +      * here so we must call stop_intr() here too to prevent interrupts after
>> +      * CE is teared down. It's okay to double call the stop_intr()
>> */
>
> "FIXME:"

Ok.



>>  exit:
>> +     ar_pci->intr_started = ret == 0;
>
> A bit too clever for the sake of readibility for my taste, but I guess
> it's ok.
>
>> --- a/drivers/net/wireless/ath/ath10k/pci.h
>> +++ b/drivers/net/wireless/ath/ath10k/pci.h
>> @@ -198,6 +198,7 @@ struct ath10k_pci {
>>        * interrupts.
>>        */
>>       int num_msi_intrs;
>> +     bool intr_started;
>
> Adding a new state variable makes me worried. I really would prefer a
> solution which would not require that.

I know that. That's why I mentioned in the commit log that it is more
of a workaround than a real fix. Me, I don't like this either but a
real fix requires a lot of rework from what I can tell.

This bug can be triggered more easily now apparently after recovery
patches went in. I'm not experiencing it but I get reports of rare
panics when a machine is left idle for a very long time with
interfaces brought down.


> Also if we call request_irq() in ath10k_pci_probe() we should also call
> free_irq() in ath10k_pci_remove() for symmetry. Just doing a temporary
> hack will most likely stay forever :)

With the patch interrupts are temporarily enabled&disabled for
probe_fw() during pci_probe() and are then not requested until
mac80211 start().


Pozdrawiam / Best regards,
Michał Kazior.
