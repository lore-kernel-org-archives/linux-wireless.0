Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:40058 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752260AbeB0NaS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 08:30:18 -0500
Received: by mail-it0-f50.google.com with SMTP id v186so15267665itc.5
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 05:30:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5A953DBE.9070805@broadcom.com>
References: <CAPcv9S3wyPd5jD1PZWtDf-mRicmzRmz00qh5Jbov_N_egBAEZg@mail.gmail.com>
 <5A953DBE.9070805@broadcom.com>
From: Harsha Rao <harshrao464@gmail.com>
Date: Tue, 27 Feb 2018 19:00:17 +0530
Message-ID: <CAPcv9S1fZfrg3AV3GoWG-CaTkonpQyiHY6twvhS_ikXnj00t4g@mail.gmail.com> (sfid-20180227_143121_329574_0FC76ECF)
Subject: Re: Support on vendor id and device id
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2018 at 4:45 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 2/27/2018 11:16 AM, Harsha Rao wrote:
>>
>> Hi folks,
>> I am developing a new wifi driver for our sdio based wifi device.
>>
>> I see that SDIO_VENDOR_ID and SDIO_DEVICE_ID for our device (We had
>> bought the SDIO IP from 3rd party)  is already  been used by some
>> other vendor and its already into staging .
>>
>> Please suggest me how can I move forward to submit the driver for staging.
>
>
> Can you be more specific about the conflicting vendor id and device id?

Hi,
My driver kicks in  with vendor id 0x296 and device id 0x5347.
But when I grepped the the kernel source I could see an other driver
wilc1000 using the same vendor ID and device ID
( We have a different hw than them !)

>> Is there a way to reconfigure the values in the SDIO host for
>> different value or does Linux allow two drivers with same values to
>> survive mutual exclusively
>
>
> First come first serve. When a device is detected, the driver core looks for
> drivers supporting it based on device table and the first that successfully
> returns from the .probe() callback is bound to the device.
>
> Regards,
> Arend

Does Linux allow two drivers with conflicting device and vendor IDs to
stay on in kernel ?

-
Harsha
