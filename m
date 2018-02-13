Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:35394 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933865AbeBMKj1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 05:39:27 -0500
MIME-Version: 1.0
In-Reply-To: <87r2q5mc4x.fsf@purkki.adurom.net>
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
 <1513168977-2121-5-git-send-email-amitkarwar@gmail.com> <87r2q5mc4x.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Tue, 13 Feb 2018 16:09:25 +0530
Message-ID: <CAEhWJF=iF4Gy65O3vUNtBrKcXBMpSnCuZgvpCDvuObkgf4zuaA@mail.gmail.com> (sfid-20180213_113932_624398_44355480)
Subject: Re: [v5 4/8] rsi: add coex support
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 1, 2018 at 12:26 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> With BT support, driver has to handle two streams of data
>> (i.e. wlan and BT). Actual coex implementation is in firmware.
>> Coex module just schedule the packets to firmware by taking them
>> from the corresponding paths.
>>
>> Structures for module and protocol operations are introduced for
>> this purpose. Protocol operations structure is global structure
>> which can be shared among different modules. Initialization of
>> coex and operating mode values is moved to rsi_91x_init().
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> [...]
>
>> @@ -270,6 +271,7 @@ struct rsi_common {
>>       u8 obm_ant_sel_val;
>>       int tx_power;
>>       u8 ant_in_use;
>> +     struct semaphore tx_bus_lock;
>
> Do you really need to use semaphore? I think nowadays the preference is
> to use something other than semaphores.

We used semaphore here, as USB/SDIO bus write operations could be
blocking/waiting. I will check if spinlock suits here in follow up
patch. It will need some testing.

> Also calling it tx_bus_lock is IMHO misleading, tx_bus_sema would be
> nicer.

Sure. I will rename the variable

Regards,
Amitkumar
