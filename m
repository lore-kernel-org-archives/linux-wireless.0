Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37542 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933624AbeBMPh5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 10:37:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        "open list\:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: Re: [v5 4/8] rsi: add coex support
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
        <1513168977-2121-5-git-send-email-amitkarwar@gmail.com>
        <87r2q5mc4x.fsf@purkki.adurom.net>
        <CAEhWJF=iF4Gy65O3vUNtBrKcXBMpSnCuZgvpCDvuObkgf4zuaA@mail.gmail.com>
Date: Tue, 13 Feb 2018 17:37:51 +0200
In-Reply-To: <CAEhWJF=iF4Gy65O3vUNtBrKcXBMpSnCuZgvpCDvuObkgf4zuaA@mail.gmail.com>
        (Amitkumar Karwar's message of "Tue, 13 Feb 2018 16:09:25 +0530")
Message-ID: <87r2po6gts.fsf@kamboji.qca.qualcomm.com> (sfid-20180213_163807_178048_30121F86)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> On Thu, Feb 1, 2018 at 12:26 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>>
>>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>>
>>> With BT support, driver has to handle two streams of data
>>> (i.e. wlan and BT). Actual coex implementation is in firmware.
>>> Coex module just schedule the packets to firmware by taking them
>>> from the corresponding paths.
>>>
>>> Structures for module and protocol operations are introduced for
>>> this purpose. Protocol operations structure is global structure
>>> which can be shared among different modules. Initialization of
>>> coex and operating mode values is moved to rsi_91x_init().
>>>
>>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>>
>> [...]
>>
>>> @@ -270,6 +271,7 @@ struct rsi_common {
>>>       u8 obm_ant_sel_val;
>>>       int tx_power;
>>>       u8 ant_in_use;
>>> +     struct semaphore tx_bus_lock;
>>
>> Do you really need to use semaphore? I think nowadays the preference is
>> to use something other than semaphores.
>
> We used semaphore here, as USB/SDIO bus write operations could be
> blocking/waiting. I will check if spinlock suits here in follow up
> patch. It will need some testing.

I was more thinking about using a mutex.

-- 
Kalle Valo
