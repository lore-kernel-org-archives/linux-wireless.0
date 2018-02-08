Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:39715 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbeBHJvP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 04:51:15 -0500
Received: by mail-qk0-f177.google.com with SMTP id d72so4841239qkc.6
        for <linux-wireless@vger.kernel.org>; Thu, 08 Feb 2018 01:51:15 -0800 (PST)
Subject: Re: [PATCH 5/6] qtnfmac: implement asynchronous firmware loading
To: Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
References: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
 <20180205150516.16030-6-sergey.matyukevich.os@quantenna.com>
 <5A79900D.5080605@broadcom.com>
 <9e2bbb8c-b34f-a93a-873a-6f5e744669ec@quantenna.com>
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A7C1D90.6060401@broadcom.com> (sfid-20180208_105121_522802_E61F9640)
Date: Thu, 8 Feb 2018 10:51:12 +0100
MIME-Version: 1.0
In-Reply-To: <9e2bbb8c-b34f-a93a-873a-6f5e744669ec@quantenna.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/7/2018 12:09 PM, Sergei Maksimenko wrote:
> Hi Arend,
>
> Qsr10g devices support loading firmware not only from the host over PCIe
> but also from on-board flash.
> Firmware start-up sequence and the following handshake are common for
> PCIe and flash boot modes. They take much more
> time (about 10 seconds) than the firmware upload process.
> To make flash mode startup also asynchronous we can't use the existing
> API such as request_firmware_nowait() as there is
> no firmware to upload, and have to explicitly run the needed functions
> in a work queue.
> In my opinion it is more neat to have one firmware load function invoked
> in a work queue for both modes than using
> request_firmware_nowait() for one mode only.

I was taught "neat" is not a real argument ;-) I agree that if you need 
the worker for async flashing it makes sense to use that for async 
firmware loading as well. Missed that reading the patch itself.

Regards,
Arend

> Regards,
> Sergei
>
> On 06.02.2018 14:22, Arend van Spriel wrote:
>>
>> External Email
>>
>>
>> On 2/5/2018 4:05 PM, Sergey Matyukevich wrote:
>>> From: Sergei Maksimenko <smaksimenko@quantenna.com>
>>>
>>> In pci probe() function start firmware loading, protocol handshake
>>> and driver core initialization, and not wait for completion.
>>
>> The moving of the debugfs stuff makes this a drag to review, but I get
>> the gist. The thing is that the firmware api already provides an
>> asynchronous api, ie. request_firmware_nowait(), so why not use that.
>>
>> Regards,
>> Arend
>
>
>
> This email, including its contents and any attachment(s), may contain
> confidential information of Quantenna Communications, Inc. and is solely
> for the intended recipient(s). If you may have received this in error,
> please contact the sender and permanently delete this email, its
> contents and any attachment(s).
