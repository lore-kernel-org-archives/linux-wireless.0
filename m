Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:47022 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbeB0XOt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:14:49 -0500
Received: by mail-io0-f180.google.com with SMTP id p78so1106130iod.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 15:14:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5A95B9B2.4040403@broadcom.com>
References: <CAPcv9S3wyPd5jD1PZWtDf-mRicmzRmz00qh5Jbov_N_egBAEZg@mail.gmail.com>
 <5A953DBE.9070805@broadcom.com> <CAPcv9S1fZfrg3AV3GoWG-CaTkonpQyiHY6twvhS_ikXnj00t4g@mail.gmail.com>
 <68f5549d-b8ad-85fb-4e80-50c53cac8108@lwfinger.net> <CAPcv9S0TmMhrL0qcxq-8NStd=fYQreXribrA+GQmppLvrB_avg@mail.gmail.com>
 <CALLGbRJxwOUkxnNCyCt2sBuoZacs60AcDnFfWMQQuVdj5YykOw@mail.gmail.com>
 <CALLGbRKrnnmsNtzpkABn+xOTjDaFKZz0jNxGkyJXMT1=XLa_3g@mail.gmail.com> <5A95B9B2.4040403@broadcom.com>
From: Harsha Rao <harshrao464@gmail.com>
Date: Wed, 28 Feb 2018 04:44:48 +0530
Message-ID: <CAPcv9S2gwDL6Jikxot2yS4daYaFQN6mEMx3vuY5w+ma_6wHCew@mail.gmail.com> (sfid-20180228_001453_935827_3B39E201)
Subject: Re: Support on vendor id and device id
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Steve deRosier <derosier@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 28, 2018 at 1:34 AM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 2/27/2018 6:34 PM, Steve deRosier wrote:
>>
>> Hi Harsha,
>>
>> Part 2 - the darn cmd-enter shortcut in gmail got me again. Sorry for
>> the premature send.
>>
>>>
>>> As both Larry and Arend mention, while it's possible to have multiple
>>> drivers with the same IDs, for obvious reasons it's not desirable.
>>>
>>> In theory the vendor IDs shouldn't be duplicated on fundamentally
>>> different devices, assuming that the manufacturers are doing things
>>> "right". The VID is paid for by buying it from the SD Association.
>
>
> Indeed. And this is fun already. If the sdio.ids file in systemd has any
> value the vendor id 0x296 is assigned to:
>
> 0296  GCT Semiconductor, Inc.
>         5347  GDM72xx WiMAX
>
>>> My suspicion is that your device, is fundamentally a wilc1000 and that
>>> the existing wilc1000 driver will likely largely work for it and all
>>> you really need to do is modify the existing driver to handle the
>>> quirks of your particular implementation of the wilc1000 chip. And,
>>> often WiFi chips will let you change the VID/PID somewhere within
>>> whatever non-volatile storage it has (like where it stores the MAC
>>> address).
>
>
> So it seems the wilc1000 devices from Microchip/Atmel are also using a
> vendor id they did not buy. Could be that the mentioned 3rd party providing
> the SDIO IP actually owns that vendor id, but if you are building your wifi
> chip on that you should better buy you own vendor id from the SD
> Association. Now if Harsha is actually working for Microchip (unclear to me)
> there is basically one party that should go shopping.
>
I would like to clarify that I am not building anything on top of
microchip wifi device.
We have a different HW . Its been just that 3rd party vendor providing
SDIO IP has given
same ID to different customers.


>
>> What I was going to mention is this is how it's worked for me many
>> times on several chips from QCA, Broadcom and Marvell included. The
>> use-case in this case would be building a custom WiFi module using a
>> vendor's chip. Very common - Silex, Laird and others do this all the
>> time: buy a chip from QCA (or Broadcom or Marvell or...), put it on a
>> board with lna, pa, passives, antennas, etc...  And you package it and
>> sell that often with value-add software.  Sometimes it's fine if it
>> represents like the original chip (for example on the ath6kl chips
>> Laird sells, it just uses the QCA IDs), but sometimes you want it to
>> represent as "my chip" (again, as Laird has to do on the chips they
>> sell to the Windows market to avoid the kind of driver conflicts
>> you're encountering). All of these chips usually have a way to store a
>> MAC address and at least all that I've worked on will also allow you
>> to change the SDIO VID in the same one-time-programable memory.
>> Obviously the method changes depending on the chip.
>>
>> However, in nearly every case, the chip is still fundamentally
>> whatever it was and we still use the upstream driver, though often
>> with tweaks and customizations based on our implementation. In the
>> cases where we've added a custom VID, we've also had to add the new
>> VID to the original driver and then key our quirks off that.
>>
>> I'm not saying this is definitely applicable in your case, but it is
>> common and maybe it will help.
>>

Definitely I will have a look at it .

>> Also thanks for bringing this issue up. Something I haven't thought
>> about in a long time but I'm adding it to my talk at ELC on WiFi
>> module interfacing. http://sched.co/DXn3
>
>
> Hah. Keep plugging that talk and seats may become scarce :-p
>
> Regards,
> Arend
