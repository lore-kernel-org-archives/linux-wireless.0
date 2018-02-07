Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0084.outbound.protection.outlook.com ([104.47.40.84]:33504
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753693AbeBGLJs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 06:09:48 -0500
Subject: Re: [PATCH 5/6] qtnfmac: implement asynchronous firmware loading
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
References: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
 <20180205150516.16030-6-sergey.matyukevich.os@quantenna.com>
 <5A79900D.5080605@broadcom.com>
From: Sergei Maksimenko <smaksimenko@quantenna.com>
Message-ID: <9e2bbb8c-b34f-a93a-873a-6f5e744669ec@quantenna.com> (sfid-20180207_120953_047615_994865F9)
Date: Wed, 7 Feb 2018 14:09:38 +0300
MIME-Version: 1.0
In-Reply-To: <5A79900D.5080605@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Qsr10g devices support loading firmware not only from the host over PCIe bu=
t also from on-board flash.
Firmware start-up sequence and the following handshake are common for PCIe =
and flash boot modes. They take much more
time (about 10 seconds) than the firmware upload process.
To make flash mode startup also asynchronous we can't use the existing API =
such as request_firmware_nowait() as there is
no firmware to upload, and have to explicitly run the needed functions in a=
 work queue.
In my opinion it is more neat to have one firmware load function invoked in=
 a work queue for both modes than using
request_firmware_nowait() for one mode only.

Regards,
Sergei

On 06.02.2018 14:22, Arend van Spriel wrote:
>
> External Email
>
>
> On 2/5/2018 4:05 PM, Sergey Matyukevich wrote:
>> From: Sergei Maksimenko <smaksimenko@quantenna.com>
>>
>> In pci probe() function start firmware loading, protocol handshake
>> and driver core initialization, and not wait for completion.
>
> The moving of the debugfs stuff makes this a drag to review, but I get
> the gist. The thing is that the firmware api already provides an
> asynchronous api, ie. request_firmware_nowait(), so why not use that.
>
> Regards,
> Arend



This email, including its contents and any attachment(s), may contain confi=
dential information of Quantenna Communications, Inc. and is solely for the=
 intended recipient(s). If you may have received this in error, please cont=
act the sender and permanently delete this email, its contents and any atta=
chment(s).
