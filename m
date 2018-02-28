Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:42349 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751823AbeB1Jib (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 04:38:31 -0500
Received: by mail-qk0-f175.google.com with SMTP id b130so2135972qkg.9
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2018 01:38:31 -0800 (PST)
Subject: Re: Support on vendor id and device id
To: Harsha Rao <harshrao464@gmail.com>
References: <CAPcv9S3wyPd5jD1PZWtDf-mRicmzRmz00qh5Jbov_N_egBAEZg@mail.gmail.com>
 <5A953DBE.9070805@broadcom.com>
 <CAPcv9S1fZfrg3AV3GoWG-CaTkonpQyiHY6twvhS_ikXnj00t4g@mail.gmail.com>
 <68f5549d-b8ad-85fb-4e80-50c53cac8108@lwfinger.net>
 <CAPcv9S0TmMhrL0qcxq-8NStd=fYQreXribrA+GQmppLvrB_avg@mail.gmail.com>
 <CALLGbRJxwOUkxnNCyCt2sBuoZacs60AcDnFfWMQQuVdj5YykOw@mail.gmail.com>
 <CALLGbRKrnnmsNtzpkABn+xOTjDaFKZz0jNxGkyJXMT1=XLa_3g@mail.gmail.com>
 <5A95B9B2.4040403@broadcom.com>
 <CAPcv9S2gwDL6Jikxot2yS4daYaFQN6mEMx3vuY5w+ma_6wHCew@mail.gmail.com>
Cc: Steve deRosier <derosier@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A967894.9090900@broadcom.com> (sfid-20180228_103835_956650_584389FB)
Date: Wed, 28 Feb 2018 10:38:28 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcv9S2gwDL6Jikxot2yS4daYaFQN6mEMx3vuY5w+ma_6wHCew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/28/2018 12:14 AM, Harsha Rao wrote:
>>>> My suspicion is that your device, is fundamentally a wilc1000 and that
>>>> >>>the existing wilc1000 driver will likely largely work for it and all
>>>> >>>you really need to do is modify the existing driver to handle the
>>>> >>>quirks of your particular implementation of the wilc1000 chip. And,
>>>> >>>often WiFi chips will let you change the VID/PID somewhere within
>>>> >>>whatever non-volatile storage it has (like where it stores the MAC
>>>> >>>address).
>> >
>> >
>> >So it seems the wilc1000 devices from Microchip/Atmel are also using a
>> >vendor id they did not buy. Could be that the mentioned 3rd party providing
>> >the SDIO IP actually owns that vendor id, but if you are building your wifi
>> >chip on that you should better buy you own vendor id from the SD
>> >Association. Now if Harsha is actually working for Microchip (unclear to me)
>> >there is basically one party that should go shopping.
>> >
> I would like to clarify that I am not building anything on top of
> microchip wifi device.
> We have a different HW . Its been just that 3rd party vendor providing
> SDIO IP has given
> same ID to different customers.

So it is as I said, ie. you are using the 3rd party SDIO IP as is and 
add your own wifi IP to it? So what does the term "SDIO IP" mean here. 
Is it a piece of hardware that you hook up to your wifi hardware or is 
it VHDL/verilog in which the vendor id is defined. If it is VHDL you 
should really get your own vendor id from the SD Association and fix it. 
Otherwise, the 3rd party hardware should have means to change it. If 
not, you better find another party.

Regards,
Arend
