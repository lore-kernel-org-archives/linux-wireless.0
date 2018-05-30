Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33477 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbeE3KF7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 06:05:59 -0400
Received: by mail-qt0-f194.google.com with SMTP id e8-v6so22490547qth.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2018 03:05:59 -0700 (PDT)
Subject: Re: [PATCH 2/3] brcmfmac: handle monitor mode marked msgbuf packets
To: Julian Calaby <julian.calaby@gmail.com>
References: <20180522131836.26858-1-zajec5@gmail.com>
 <20180522131836.26858-2-zajec5@gmail.com> <5B070A5D.3080400@broadcom.com>
 <CAGRGNgXMUTBhjGA_Rk=_ASaOcYNM+udAN8=HhutxFP5kwQYLww@mail.gmail.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        stanley.hsu@cypress.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, rafal@milecki.pl
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B0E7783.7070309@broadcom.com> (sfid-20180530_120603_719153_324CD3A7)
Date: Wed, 30 May 2018 12:05:55 +0200
MIME-Version: 1.0
In-Reply-To: <CAGRGNgXMUTBhjGA_Rk=_ASaOcYNM+udAN8=HhutxFP5kwQYLww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/27/2018 7:34 AM, Julian Calaby wrote:
> Hi Arend,
> On Fri, May 25, 2018 at 12:38 PM Arend van Spriel <
> arend.vanspriel@broadcom.com> wrote:
>
>> On 5/22/2018 3:18 PM, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> New Broadcom firmwares mark monitor mode packets using a newly defined
>>> bit in the flags field. Use it to filter them out and pass to the
>>> monitor interface. These defines were found in bcmmsgbuf.h from SDK.
>>>
>>> As not every firmware generates radiotap header this commit introduces
>>> BRCMF_FEAT_MON_FMT_RADIOTAP that has to be set per firmware version. If
>>> not present brcmf_netif_mon_rx() assumed packet being a raw 802.11 frame
>>> and prepends it with an empty radiotap header.
>>>
>>> It's limited to the msgbuf protocol. Adding support for SDIO/USB devices
>>> will require some extra research.
>
>> So I went looking on my shelf and found the patch I made for SDIO a
>> while back. It relies on firmware change and I did not introduce a
>> firmware flag for it. I will send the patch as RFT so you can have a
>> look at it.
>
>> I checked our internal driver and it turns out the raw vs. radiotap is a
>> compilation option. So depending on customer they would get either
>> firmware doing the radiotap header generation or the host driver,
>> without any run-time way to determine it. Not nice for brcmfmac.
>
> I pretty sure I know what the answer to this is going to be, however I
> still have to ask:
>
> Is it possible to open up _any_ part of the firmware? (Even if it's just
> the host-interface end and the hardware end is a big ugly blob) It'd make
> dealing with stuff like this so much easier if we can just toggle a flag
> and recompile. (I'm also sure that we'd be more than happy to pass some
> flag through telling us/you that it's unofficial firmware and has probably
> broken the hardware, etc.)

Hah. Yeah, with next to nil uncertainty I know the answer to this as 
well. If you know how long it took before we committed to supporting the 
upstream drivers. Despite my better judgement I will pass your idea, but 
it is not something that is going to fall in the timeframe that Rafał 
had in mind.

Regards,
Arend
