Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo68.mail-out.ovh.net ([178.32.228.68]:42090 "EHLO
        mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdBXOUU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 09:20:20 -0500
Received: from player750.ha.ovh.net (b6.ovh.net [213.186.33.56])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id EC4673F5BC
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 14:44:09 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 24 Feb 2017 14:43:59 +0100
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 4.12 1/2] brcmfmac: don't use 43602a1 firmware for 43602a0
 chipset
In-Reply-To: <c7c82c1f-df42-c4a2-4f1f-1ff4928590d1@broadcom.com>
References: <20170224122739.1778-1-zajec5@gmail.com>
 <c7c82c1f-df42-c4a2-4f1f-1ff4928590d1@broadcom.com>
Message-ID: <6d84044d4d51bbe99492b3cf06b1cae1@milecki.pl> (sfid-20170224_152023_699495_ABD487CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-24 14:21, Arend Van Spriel wrote:
> On 24-2-2017 13:27, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> 43602a0 uses chip revision 0 compared to 43602a1 with revision 1. In
>> brcmfmac there is support for 43602a1 and from what I know supporting
>> 43602a0 would require loading a different firmware.
> 
> This is not necessarily true. It depends on whether the rom image is
> different or not and there is no way to tell up front. So if a0 has 
> same
> rom image as a1 the firmware is compatible and no distinction is 
> needed.
> This tends to be the case for chips that only change the digit and not
> the letter in the chip revision. Anyway, I do not know if a0 has
> different rom image, but the a0 was never sold so there is no harm in
> keeping it as is.

Just to be sure (I don't have such a good hardware knowledge):
1) Does ROM image mean some code that is permanently on the device?
2) Does firmware mean code we upload from the host driver?

I'm not sure if I understand the rest of your description.

AFAIU first you said ROM image tends to be the same on chipset 
variations using
the same letter. If this is so, why we need different firmware for 
43602a0 and
43602a1? Or different firmware for 43570a0 and 43570a2?

Also if what you said about sharing one ROM image between chip 
variations using
the same letter was correct, shouldn't you expect the same ROM image on 
43602a0
and 43602a1?

Forgive me if something of this is obvious for you, I just don't have 
access to
any Broadcom internal documentation :)
