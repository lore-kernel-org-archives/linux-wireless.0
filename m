Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:58487 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbZBBNvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 08:51:09 -0500
Message-ID: <37630.82.152.223.193.1233582663.squirrel@www.phantomjinx.co.uk> (sfid-20090202_145116_108165_0EBDE251)
In-Reply-To: <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com>
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>
    <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>
    <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>
    <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>
    <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk>
    <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com>
Date: Mon, 2 Feb 2009 13:51:03 -0000 (UTC)
Subject: Re: rtl8187 wireless issues
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That is a fair possibility. I upgraded the kernel on Saturday hence I h=
ad
to rebuild against the new kernel. Upon install, I noticed that rtl8187
was correctly installed. Of course, this second time of building and
installing, I had removed the blacklist entries for rtl8187 as I had
successfully used it for 24 hours.

One minor point, I notice in iwconfig is that it doesnt report a bit ra=
te
of greater than 1Mb/sec. Is this a known issue?

Regards

PGR

> On Fri, Jan 30, 2009 at 10:04 PM, P.G. Richardson
> <p.g.richardson@phantomjinx.co.uk> wrote:
>
>> I am not that familiar with kernel makefiles but it would seem that =
the
>> drivers/net/wireless line below is not recursive:
>>
>> obj-y :=3D net/wireless/ net/mac80211/
>> ifeq ($(ONLY_CORE),)
>> obj-$(CONFIG_B44) +=3D drivers/net/b44.o
>> obj-y +=3D drivers/ssb/ \
>>        drivers/misc/eeprom/ \
>>        drivers/net/usb/ \
>>        drivers/net/wireless/
>> endif
>
> It is recursive - it runs Makefile in drivers/net/wireless/ . Your
> list is very small - it should build and install 40+ kernel modules.
> curious. some kernel config means the modules aren't built, but in
> your case they are built but not installed... I wonder if it is
> affected by blacklist.
>


--=20
Laws are partly formed for the sake of good men, in order to instruct t=
hem
how they may live on friendly terms with one another, and partly for th=
e
sake of those who refuse to be instructed, whose spirit cannot be subdu=
ed,
or softened, or hindered from plunging into evil. [The Laws, Plato]

You fiend! Never have I encountered such corrupt and foul-minded
perversity=85 Have you ever considered a career in the church?
Bishop of Bath and Wells (Blackadder II)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
