Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55101 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab3C1J4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 05:56:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6W6Ey8iU1vs=XfA7Or0wF=Qh6Gu8zF-DxMatgk-V+wdkQ@mail.gmail.com>
References: <CAKprTDHpf0PgisfJK9bJOYgYxLU5PRLNtbkg7V6Zj2s=gVVMCA@mail.gmail.com>
	<CAB=NE6Wbym4XksV=uKz9eZD0rZwmtS3ZfP-zbXg9TAc2+2+Z9g@mail.gmail.com>
	<CAKprTDEEEdy++Bk5AY4Zfrtwsc9HOKGQ+uWR58PFCWU=v+PE1g@mail.gmail.com>
	<CAB=NE6UtuxuTduYhDy5BcPap-rri+P1mcKYr2KEjAbuE2FU13g@mail.gmail.com>
	<20130327175711.GA8794@stt008.linux.site>
	<CAKprTDFspW4B2tk9EZPBBXy3C6gL_NJsjwj-bUeYj1rN3j6sYg@mail.gmail.com>
	<CAB=NE6W6Ey8iU1vs=XfA7Or0wF=Qh6Gu8zF-DxMatgk-V+wdkQ@mail.gmail.com>
Date: Thu, 28 Mar 2013 10:56:08 +0100
Message-ID: <CAKprTDFJet+m7RmkZt5uyf=FMyEYciCYUahEcCC6_ukRQ2pjgw@mail.gmail.com> (sfid-20130328_105614_649043_1962BB69)
Subject: Re: brcmsmac: Unknown symbol backport_cordic_calc_iq (err 0)
From: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	meuleman@broadcom.com, brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/28 Luis R. Rodriguez <mcgrof@frijolero.org>:
> On Thu, Mar 28, 2013 at 2:02 AM, Camaleón <noelamac@gmail.com> wrote:

(...)

>> Now, as soon as I proceed to load "brcmsmac" I get a long and
>> uninterruptible "beeeeep", system hard-freezes (no mouse nor caps lock
>> led reaction) and only restart is possible.
>>
>> Any clue?
>
> You are on 3.9.0-rc2, so there is nothing for us to backport on these
> linux-next based releases except the delta between v3.9 and what is
> not yet on Linus' tree, in other worlds just the development delta for
> the 802.11 subsystem.

I have two sets of kernels installed in this system: Debian's stock
kernel (3.2.39-2) and another one I get from kernel.org (3.9.0-rc2).

Now, what happens is that the compat-driver freezes with kernel 3.9
and I get this message with kernel 3.2:

[  684.589268] Compat-drivers backport release: compat-drivers-2013-03-26-u
[  684.589279] Backport based on linux-next.git next-20130326
[  684.589285] compat.git: linux-next.git
[  684.609187] cfg80211: Unknown symbol
backport_netdev_set_default_ethtool_ops (err 0)

This driver is "driving" me nuts :-)

> We have yet to require any backport work between 3.9 and what we assume will be
> 3.10. My bet is this is a real driver bug, not backport bug.

Curious is that brcmsmac module loads fine from the common kernel
module, I mean, the stock one.

> Can you
>
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>
> and use your .config, and build and test that kernel ? If it fails to
> boot / crash then you know its the driver.

I'm not using git (don't even have it installed in my system), I'm
used to compile kernels/modules in the old fashion way. Sorry, I don't
know how git works.

> Has brcmsmac ever worked for you?

Well, yes (this is a long story¹ with many helpful people doing their
best). It stopped from working since kernel 2.38 or so, but even
though the driver is giving me some headaches, it never froze the
system like is doing now.

¹ http://marc.info/?t=136359599600001&r=1&w=2

Greetings,

-- 
Camaleón
