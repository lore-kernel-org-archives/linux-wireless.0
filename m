Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33809 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdGFOvJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:51:09 -0400
Received: by mail-qk0-f194.google.com with SMTP id 91so616307qkq.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:51:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87h8z02bxh.fsf@purkki.adurom.net>
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
 <1497624881-2315-2-git-send-email-amit.karwar@redpinesignals.com> <87h8z02bxh.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 6 Jul 2017 20:21:08 +0530
Message-ID: <CAEhWJFm_J3=F37NgGi+OJa3LVpoNr5-Dz=euJiL0ohjYOBt8Vw@mail.gmail.com> (sfid-20170706_165112_976660_25D25A11)
Subject: Re: [v2 01/20] rsi: changes in eeprom read frame
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 29, 2017 at 12:10 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> EEPROM read frame is sent during device initialization to read mac address.
>> The format of the frame is modified in firmware to include eeprom length
>> and offset. This frame does not return firmware version now. Also same
>> frame is sent again to read rf type and band information.
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> [...]
>
>> --- a/drivers/net/wireless/rsi/rsi_main.h
>> +++ b/drivers/net/wireless/rsi/rsi_main.h
>> @@ -37,6 +37,7 @@ enum RSI_FSM_STATES {
>>       FSM_COMMON_DEV_PARAMS_SENT,
>>       FSM_BOOT_PARAMS_SENT,
>>       FSM_EEPROM_READ_MAC_ADDR,
>> +     FSM_EEPROM_READ_RF_TYPE,
>>       FSM_RESET_MAC_SENT,
>>       FSM_RADIO_CAPS_SENT,
>>       FSM_BB_RF_PROG_SENT,
>
> Shouldn't you also update fsm_state array, just like Colin fixed earlier
> this week:

Thanks for pointing this out. This has been addressed in v3 series.

>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=58828680af495bc4863af3a006f2018c71714665
>
> I think a some kind of build time check for this is in order, should be
> doable with BUILD_BUG_ON().
>

Sure. I have created a separate patch for this in v3 series.

Regards,
Amitkumar
