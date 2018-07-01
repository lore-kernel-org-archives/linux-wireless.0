Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 20.mo4.mail-out.ovh.net ([46.105.33.73]:49419 "EHLO
        20.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbeGAKro (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Jul 2018 06:47:44 -0400
Received: from player770.ha.ovh.net (unknown [10.109.108.3])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 6F03C187CB4
        for <linux-wireless@vger.kernel.org>; Sun,  1 Jul 2018 08:01:49 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sun, 01 Jul 2018 08:01:36 +0200
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH] brcmfmac: update STA info struct to the v5
In-Reply-To: <5B37D08B.9050008@broadcom.com>
References: <20180628103623.29103-1-zajec5@gmail.com>
 <5B37D08B.9050008@broadcom.com>
Message-ID: <5d9c879c39864733cbbbc31af0f3ffd8@milecki.pl> (sfid-20180701_124749_149722_6213CB49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-30 20:48, Arend van Spriel wrote:
> On 6/28/2018 12:36 PM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> That struct is used when querying firmware for the STA. It seem is has
>> been changing during the time. Luckily its format seems to be backward
>> compatible starting with v2 (the only breakage was v1 -> v2).
>> 
>> The version that was supported by brcmfmac so far was v4. It was what
>> 43602a1 and 4366b1 firmwares (7.35.177.56 and 10.10.69.3309 
>> accordingly)
>> were using. It also seems to be used by early 4366c0 firmwares
>> (10.10.69.6908 and 10.10.69.69017).
>> 
>> The problem appears when switching to the 10.10.122.20 firmware. It 
>> uses
>> v5 and instead of falling back to v4 when submitted buffer isn't big
>> enough it fallbacks to the v3.
>> 
>> To receive all v4 specific info with the newest firmware we have to
>> submit a struct (buffer) that matches v5.
> 
> So do you have firmware that actually return v5 in the 'ver' field. I
> am asking because I see a comment that version 5 is obsoleted and in
> recent branch we are at version 7. Just curious what the actual
> version is. If you do not explicitly need version 5 I would prefer to
> skip it and move to version 6 struct. Otherwise it is...

Yes. As stated in the commit message, firmware 10.10.122.20 uses v5.

I didn't list vendors using that firmware, but if you take a look at the
side thread "Research + questions on brcmfmac and support for monitor
mode", you'll see that 10.10.122.20 is used in:
1) FW_EA9500v2_EA9500S_2.1.1.183171_prod.img
2) GT-AC5300_3.0.0.4_382_15984-gf481f58_cferom_ubi_0824.w
3) ArcherC5400X(US)_171023.bin

That means I explicitly need v5 to make brcmfmac work with any
10.10.122.20 firmware from above images.

Unfortunately I didn't find any vendor release their GPL package with
Broadcom's SDK using v6 or v7. I hope it's backward compatible and
maybe you'll be able to provide patch on top of mine?


> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks!
