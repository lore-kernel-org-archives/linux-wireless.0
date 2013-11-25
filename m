Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48391 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3KYMq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 07:46:26 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so2669744wgh.26
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 04:46:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87siukn05r.fsf@kamboji.qca.qualcomm.com>
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
	<1385125518-13461-8-git-send-email-michal.kazior@tieto.com>
	<87siukn05r.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 25 Nov 2013 13:46:23 +0100
Message-ID: <CA+BoTQnQWEy6QzKb9Ts6UokyC7yhY829PB42kUpZwLP4dqj+nQ@mail.gmail.com> (sfid-20131125_134630_277747_A792D007)
Subject: Re: [PATCH 7/8] ath10k: re-add support for early fw indication
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 November 2013 13:20, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> It's possible for FW to panic during early boot or
>> at driver teardown in some rare cases.
>>
>> The patch re-introduces support to detect and
>> print those crashes.
>>
>> This introduces an additional irq handler that is
>> set for the duration of early boot and shutdown.
>> The handler is then overriden with regular
>> handlers upon hif start().
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

>> @@ -1952,6 +1975,9 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
>>  {
>>       struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
>>
>> +     ath10k_ce_disable_interrupts(ar);
>> +     ath10k_pci_free_early_irq(ar);
>> +     ath10k_pci_kill_tasklet(ar);
>
> Should disable_interrupts() and kill_tasklet() be in an earlier patch?

No. Before this patch there are no interrupt handlers registered by
power_up, so there are no interrupts to be cleaned up in power_down.

Since this patch introduces early irq handling in power_up, then
power_down must shut everything down. Now that I think about the
ath10k_ce_disable_interrupts() isn't necessary here. The other two
functions are though.


Micha³
