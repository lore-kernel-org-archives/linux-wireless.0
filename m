Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62636 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaHRNvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 09:51:41 -0400
Received: by mail-wi0-f172.google.com with SMTP id n3so3749972wiv.11
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2014 06:51:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878umspjkm.fsf@kamboji.qca.qualcomm.com>
References: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
	<1407402260-29854-4-git-send-email-michal.kazior@tieto.com>
	<878umspjkm.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 18 Aug 2014 15:51:40 +0200
Message-ID: <CA+BoTQnFCnixx1P8Q-F-xgiNr8W05fv8h8jiCBFfmV7aQmXKjA@mail.gmail.com> (sfid-20140818_155145_566158_0CFEFAA4)
Subject: Re: [PATCH 3/5] ath10k: remove early irq handling
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 August 2014 16:09, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> It's not really necessary to have a dedicated irq
>> handler just for the sake of catching early fw
>> crashes. It is now safe to use one handler even
>> during early stages of device boot up.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Nice, this really needs to be cleaned up.
>
>>  drivers/net/wireless/ath/ath10k/pci.c | 160 ++++++++--------------------------
>>  1 file changed, 36 insertions(+), 124 deletions(-)
>
> Shouldn't you also remove early_irq_tasklet from struct ath10k_pci?

Oops. Good catch.


>> -static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
>> +static bool ath10k_pci_fw_crashed(struct ath10k *ar)
>>  {
>> -     struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
>> -     u32 fw_indicator;
>> -
>> -     fw_indicator = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
>> -
>> -     if (fw_indicator & FW_IND_EVENT_PENDING) {
>> -             /* ACK: clear Target-side pending event */
>> -             ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
>> -                                fw_indicator & ~FW_IND_EVENT_PENDING);
>> +     return ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS) &
>> +            FW_IND_EVENT_PENDING;
>> +}
>
> Hehe, in Ben's firmware crash dump patches I renamed
> ath10k_pci_hif_dump_area() to ath10k_pci_firmware_crashed(). So we now
> have two very similarly named functions doing very different :)
>
> I propose that you rename this function to ath10k_pci_is_fw_crashed() or
> ath10k_pci_has_fw_crashed() and I rename ath10k_pci_hif_dump_area() to
> ath10k_pci_fw_crashed_dump(). I think that we have pretty consistent
> naming, no?

I'm okay with that. WIll fix.


>> +static void ath10k_pci_fw_crashed_clear(struct ath10k *ar)
>> +{
>> +     ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
>> +                        (ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS) &
>> +                         ~FW_IND_EVENT_PENDING));
>
> Please don't embed calls like this, with a temporary variable you get it
> more readable and the resulting code should be the same anyway.

Will fix.


>
>> @@ -2412,14 +2322,6 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
>>               return -EIO;
>>       }
>>
>> -     if (val & FW_IND_EVENT_PENDING) {
>> -             ath10k_warn("device has crashed during init\n");
>> -             ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
>> -                                val & ~FW_IND_EVENT_PENDING);
>> -             ath10k_pci_hif_dump_area(ar);
>> -             return -ECOMM;
>> -     }
>
> I'm a bit worried about this. Are you relying now that the target will
> always trigger an interrupt or what? If yes, how can we sure it will
> happen on all possible cases? I would prefer to have some kind of safety
> net anyway, even if it's just a simple warning.

Hmm, I'll keep it. I just remembered it's possible for a device to
fail to fully setup pci link/config and crash without asserting an
interrupt while still providing a trace in the host interest area.


Michał
