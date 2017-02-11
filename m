Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33437 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752083AbdBKEhr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 23:37:47 -0500
Received: by mail-wr0-f195.google.com with SMTP id i10so16990683wrb.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Feb 2017 20:37:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e71fe0b1-4482-b80b-2624-240b154ff980@dd-wrt.com>
References: <0082a9e3-83f3-9bc3-af43-b890b91cfd93@candelatech.com> <e71fe0b1-4482-b80b-2624-240b154ff980@dd-wrt.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Fri, 10 Feb 2017 20:37:44 -0800
Message-ID: <CAJ-VmokKafmamWJJ0-=PJ_oNBejbqcHbd8NO7-M9=Z6DFRuhzw@mail.gmail.com> (sfid-20170211_053757_023831_31C68E47)
Subject: Re: VHT 160Mhz and nss related config.
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 February 2017 at 20:22, Sebastian Gottschall
<s.gottschall@dd-wrt.com> wrote:
> i really can't believe this. if this is true the  160 mhz mode would not
> make any sense.
> the maximum tx / rx rate for 4x4 vht80 and 2x2 vht160 is identical. so
> vht160 would not increase performance in any way

Well, if it can also do 2x2 MU-MIMO at 160MHz then it can be a
perfectly fine STA to a 4x4 160MHz MU-MIMO chip that can actually
transmit 2x2 rates to different MU-MIMO peers.

That's the outstanding question I have - is it like, 2x2 MU only, or
is it say, 2 concurrently different spatial stream 2x2 MU? Ie, can you
have 2 peers, different VHT spatial groups (or 4 peers, 1 spatial
group each) all going at the same time?

I'm .. not even sure how you're supposed to cleanly negotiate that you
can do 4NSS in VHT80 but 2NSS in VHT160 to a peer... that only makes
sense if you're doing lots of 1NSS and 2NSS MU-MIMO peers..


-adrian

>
> Am 10.02.2017 um 23:58 schrieb Ben Greear:
>>
>> So, it appears that the ath10k QCA9984 4x4 160Mhz chip can do 4x4 MIMO a=
t
>> VHT80, but
>> it can do only 2x2 MIMO at VHT160/80+80.
>>
>> When configuring a peer, we need to tell the firmware the number of
>> spatial streams
>> of the peer at VHT160 and at VHT80 and lower.  They are not the same
>> value.
>>
>> I cannot think of any standard way to get this information based on VHT
>> capabilities
>> and such.  Currently, one could just assume VHT160 NSS is 1/2 of the VHT=
80
>> NSS,
>> but that is unlikely to be true for all vendors.
>>
>> Any ideas?
>>
>> Thanks,
>> Ben
>>
>
>
> --
> Mit freundlichen Gr=C3=BCssen / Regards
>
> Sebastian Gottschall / CTO
>
> NewMedia-NET GmbH - DD-WRT
> Firmensitz:  Berliner Ring 101, 64625 Bensheim
> Registergericht: Amtsgericht Darmstadt, HRB 25473
> Gesch=C3=A4ftsf=C3=BChrer: Peter Steinh=C3=A4user, Christian Scheele
> http://www.dd-wrt.com
> email: s.gottschall@dd-wrt.com
> Tel.: +496251-582650 / Fax: +496251-5826565
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
