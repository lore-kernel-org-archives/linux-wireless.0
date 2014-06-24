Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:58282 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaFXCyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 22:54:13 -0400
Received: by mail-lb0-f181.google.com with SMTP id p9so5579830lbv.40
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 19:54:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53A8E3F9.7000001@candelatech.com>
References: <1402517314-20110-1-git-send-email-greearb@candelatech.com>
 <20140623191504.GD1390@garbanzo.do-not-panic.com> <53A89011.1010806@candelatech.com>
 <20140623205451.GG1390@garbanzo.do-not-panic.com> <53A89A0F.9090509@candelatech.com>
 <20140624004442.GH1390@garbanzo.do-not-panic.com> <53A8E3F9.7000001@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 23 Jun 2014 19:53:51 -0700
Message-ID: <CAB=NE6XJaHNAL17mN7Ghw9GnatOwaOacikv5XupK7xKjUe=m_Q@mail.gmail.com> (sfid-20140624_045417_392675_BF06A32F)
Subject: Re: [RFC] wireless: improve dfs-region intersection.
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2014 at 7:35 PM, Ben Greear <greearb@candelatech.com> wrote:
>
>>> Maybe just use time-zone or user hints in this case since NICs cannot
>>> be fully trusted.
>>
>>
>> WTF no, the regulatory hint stuff should all be automated and user input
>> should really only come from trusted sources, see the cell base station
>> hint as a good example use case. The NICs are trusted as that's what
>> regulatory bodies like folks to do. Hell even the country IEs are only
>> trusted for the alpha2, the actual contents are disregarded. Regular
>> user input should only help compliance further, that's it.
>
>
> NICs just aren't that reliable, seems you can buy NICs with any number
> of regulatory domains on the interweb, and then you can hop on a plane
> and go other interesting places.

You can also reverse engineer firmware, also design RW support on OTPs
and EEPROMs, so there's tons of ways one can circumvent regulatory,
its not meant to be perfect, specially since tons of software is
required for hugely complex regulatory compliance rules such as in
DFS. We however do the best to enable all types of devices to be
compliant, we do the very best, and its also why we get vendor support
upstream even with open firmware designs. Location information is also
important for a device that get calibrated for a specific region --
the architecture on some devices mandates that you can only fit
certain things into hardware / OTP / EEPOM and some folks optimize
functionality of a card so that that very specific tuning applies only
to a specific region it got certified for, so the ideal operation of a
device is for what area it was designed for. If folks repuropose them
it may not work as well.What ends up in the market will vary and what
folks do in their basement or lab is up to them -- enable onus kernel
flag stuff and go to town.

There's tons of good resources an operating system can rely on to
guarantee the region other than a stupid EEPROM / OTP / Country IE,
the ideal solution folks should strive for would be a series of
heuristics that can guarantee this and only use the OTP / whatever for
when the location cannot be known for sure.

An easy start up idea would be to find a really cheap way to ensure
this for hardware other than GPS. The resolution would suffice to be
ISO3166 specific to the most popular countries.

> If you ever have a system with NICs with two different regulatory domains,

Folks should not be selling these and if they end up with them the
intersection is taken, and additionally user input is welcomed.

> I assume it is very likely that it was not certified in that configuration.

A device *sold* under that configuration would need to be certified.

> Maybe the user's input (and AP's beacons and such) are more reliable in this
> case.

Location information should use a series of heuristics, and a degree
of trust should be used to quality them. Userespace input for hints
coming from cell base stations are of a good source, as an example and
some folks ship products using it. Users should only be allowed to
help compliance further, that's it. The default stuff should be done
without any user input.

> But, not worth arguing about at this point.  As long as the basic regulatory
> bugs are fixed (as per the other thread), then my problems should be
> solveable.

Yes, lets use our time effectively please.

 Luis
