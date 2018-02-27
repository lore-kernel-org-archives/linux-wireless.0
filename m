Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:45235 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752930AbeB0P3X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 10:29:23 -0500
Received: by mail-io0-f175.google.com with SMTP id m22so21571340iob.12
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 07:29:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <68f5549d-b8ad-85fb-4e80-50c53cac8108@lwfinger.net>
References: <CAPcv9S3wyPd5jD1PZWtDf-mRicmzRmz00qh5Jbov_N_egBAEZg@mail.gmail.com>
 <5A953DBE.9070805@broadcom.com> <CAPcv9S1fZfrg3AV3GoWG-CaTkonpQyiHY6twvhS_ikXnj00t4g@mail.gmail.com>
 <68f5549d-b8ad-85fb-4e80-50c53cac8108@lwfinger.net>
From: Harsha Rao <harshrao464@gmail.com>
Date: Tue, 27 Feb 2018 20:59:22 +0530
Message-ID: <CAPcv9S0TmMhrL0qcxq-8NStd=fYQreXribrA+GQmppLvrB_avg@mail.gmail.com> (sfid-20180227_162951_798344_6C8A3FDA)
Subject: Re: Support on vendor id and device id
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2018 at 8:44 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 02/27/2018 07:30 AM, Harsha Rao wrote:
>>
>> On Tue, Feb 27, 2018 at 4:45 PM, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>>
>>> On 2/27/2018 11:16 AM, Harsha Rao wrote:
>>>>
>>>>
>>>> Hi folks,
>>>> I am developing a new wifi driver for our sdio based wifi device.
>>>>
>>>> I see that SDIO_VENDOR_ID and SDIO_DEVICE_ID for our device (We had
>>>> bought the SDIO IP from 3rd party)  is already  been used by some
>>>> other vendor and its already into staging .
>>>>
>>>> Please suggest me how can I move forward to submit the driver for
>>>> staging.
>>>
>>>
>>>
>>> Can you be more specific about the conflicting vendor id and device id?
>>
>>
>> Hi,
>> My driver kicks in  with vendor id 0x296 and device id 0x5347.
>> But when I grepped the the kernel source I could see an other driver
>> wilc1000 using the same vendor ID and device ID
>> ( We have a different hw than them !)
>>
>>>> Is there a way to reconfigure the values in the SDIO host for
>>>> different value or does Linux allow two drivers with same values to
>>>> survive mutual exclusively
>>>
>>>
>>>
>>> First come first serve. When a device is detected, the driver core looks
>>> for
>>> drivers supporting it based on device table and the first that
>>> successfully
>>> returns from the .probe() callback is bound to the device.
>>>
>>> Regards,
>>> Arend
>>
>>
>> Does Linux allow two drivers with conflicting device and vendor IDs to
>> stay on in kernel ?
>
>
> Yes. We have a similar situation with the rtl8192e driver in staging and the
> rtl8192se driver in the wireless tree, which share PCI ID 0bda:8192. Our
> solution was to insert code in the probe routine that tests some value in
> addition to the PCI ID. In our case, that was the PCI revision id. Line 2496
> of file drivers/staging/rtl8192e/rtl8192e/rtl_core.c shows the test in the
> staging driver.
>
> The downsides of this unfortunate duplication are that if the wrong driver
> loads first, then it remains loaded, you will need to cooperate with the
> maintainer of the other driver to insert the extra detection code, and you
> may need to do quite a bit of processing to be able to determine whether you
> have the correct device.
>
> Larry
>
Thanks Larry and Arend for your valuable time in clarifying my doubts..

-
Harsha
