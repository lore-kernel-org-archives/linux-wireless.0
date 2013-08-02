Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:61034 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3HBHva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 03:51:30 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so96831bkc.16
        for <linux-wireless@vger.kernel.org>; Fri, 02 Aug 2013 00:51:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bo5gpmij.fsf@kamboji.qca.qualcomm.com>
References: <1374129572-6079-1-git-send-email-michal.kazior@tieto.com>
	<1375427747-9539-1-git-send-email-michal.kazior@tieto.com>
	<87bo5gpmij.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 2 Aug 2013 09:51:28 +0200
Message-ID: <CA+BoTQktaDtp=fc3C_u4geA6vK72B1X4QnsD_GqrzU9NXEmBrA@mail.gmail.com> (sfid-20130802_095133_261082_F08995FC)
Subject: Re: [PATCH v2] ath10k: fix device teardown
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 August 2013 09:41, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This fixes interrupt-related issue when no
>> interfaces were running thus the device was
>> considered powered down.
>>
>> The power_down() function isn't really powering
>> down the device. It simply assumed it won't
>> interrupt. This wasn't true in some cases and
>> could lead to paging failures upon FW indication
>> interrupt (i.e. FW crash) because some structures
>> aren't allocated in that device state.
>>
>> One reason for that was that ar_pci->started
>> wasn't reset. The other is interrupts should've
>> been masked when teardown starts.
>>
>> The patch reorganized interrupt setup and makes
>> sure ar_pci->started is reset accordingly.
>>
>> Reported-by: Ben Greear <greearb@candelatech.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>> v2:
>>  * updated commit message
>>  * added Reported-By: Ben
>>  * added disable_irq() in hif_stop()
>>  * added ar_pci->started resetting
>>  * removed ar_pci->intr_started
>
> Thanks, this looks much better now.
>
> But I still have one question:
>
>> @@ -1742,6 +1761,12 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>>  {
>>       int ret;
>>
>> +     ret = ath10k_pci_start_intr(ar);
>> +     if (ret) {
>> +             ath10k_err("could not start interrupt handling (%d)\n", ret);
>> +             goto err;
>> +     }
>
> So now we call start_intr() during power_up(), which means that we do
> the request_irq() calls during every interface up event. Does that cause
> any meaningful overhead?

I don't think so.


> For me it looks better to do all resource allocation in
> ath10k_pci_probe(), like request_irq(), and free the resources in
> ath10k_pci_remove(). But then we would need to immeadiately call
> disable_irq() and then enable_irq() from power_up() so I'm not sure if
> that's any better.

Not only that. Since disable/enable_irq must be balanced we'd need
some way to track whether we have irqs enabled/disabled - either with
an extra bool variable, additional ath10k_states or new pci-specific
states.

The patch assumes disable_irq is followed by free_irq (which it is)
and possibly request_irq later on.


Pozdrawiam / Best regards,
Micha³ Kazior.
