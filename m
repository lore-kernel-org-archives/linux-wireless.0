Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58043 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab3C1Kkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 06:40:36 -0400
Date: Thu, 28 Mar 2013 11:40:30 +0100
From: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	meuleman <meuleman@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: brcmsmac: Unknown symbol backport_cordic_calc_iq (err 0)
Message-ID: <20130328104030.GA4602@stt008.linux.site> (sfid-20130328_114042_424264_D6752397)
References: <CAKprTDHpf0PgisfJK9bJOYgYxLU5PRLNtbkg7V6Zj2s=gVVMCA@mail.gmail.com> <CAB=NE6Wbym4XksV=uKz9eZD0rZwmtS3ZfP-zbXg9TAc2+2+Z9g@mail.gmail.com> <CAKprTDEEEdy++Bk5AY4Zfrtwsc9HOKGQ+uWR58PFCWU=v+PE1g@mail.gmail.com> <CAB=NE6UtuxuTduYhDy5BcPap-rri+P1mcKYr2KEjAbuE2FU13g@mail.gmail.com> <20130327175711.GA8794@stt008.linux.site> <CAKprTDFspW4B2tk9EZPBBXy3C6gL_NJsjwj-bUeYj1rN3j6sYg@mail.gmail.com> <CAB=NE6W6Ey8iU1vs=XfA7Or0wF=Qh6Gu8zF-DxMatgk-V+wdkQ@mail.gmail.com> <CAKprTDFJet+m7RmkZt5uyf=FMyEYciCYUahEcCC6_ukRQ2pjgw@mail.gmail.com> <CAB=NE6VzvVkFvGaudZHQTM5R3s05QV5Jw23wZ_DLxkNf00Utdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAB=NE6VzvVkFvGaudZHQTM5R3s05QV5Jw23wZ_DLxkNf00Utdg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 2013-03-28 a las 03:23 -0700, Luis R. Rodriguez escribió:

> On Thu, Mar 28, 2013 at 2:56 AM, Camaleón <noelamac@gmail.com> wrote:

(...)

> > Now, what happens is that the compat-driver freezes with kernel 3.9
> > and I get this message with kernel 3.2:
> >
> > [  684.589268] Compat-drivers backport release: compat-drivers-2013-03-26-u
> > [  684.589279] Backport based on linux-next.git next-20130326
> > [  684.589285] compat.git: linux-next.git
> > [  684.609187] cfg80211: Unknown symbol
> > backport_netdev_set_default_ethtool_ops (err 0)
> >
> > This driver is "driving" me nuts :-)
> 
> I have a fix for this, mind you, this is a Debian thing, that is --
> debian cherry picked some code from a future kernel on their own
> kernel. The new LINUX_BACKPORT() macro will rescue these. I'll post a
> new release tomorrow, but I'm working on backporting some other
> collateral evolutions right now.

Okay, no problem and thanks for caring about this.
 
> >> We have yet to require any backport work between 3.9 and what we assume will be
> >> 3.10. My bet is this is a real driver bug, not backport bug.
> >
> > Curious is that brcmsmac module loads fine from the common kernel
> > module, I mean, the stock one.
> 
> What do you mean? Have you tried the stock driver from 3.9-rc2?

Sure! (full report is on the kernel wireless mailing list)

In fact, the only reason I compiled the kernel is to test the latest brcmsmac 
driver because being this a netbook, having to use an external usb card 
to be "online" when I'm out of home is a bit annoying.

Now you say... can you please tell me -in user's parlance terms so I can 
understand it- what's the difference between "brcmsmac" from the stock 
kernel modules and this one from "compat-drivers"? I mean, what's the 
difference from a user's POV and from kernel hacker POV. Are they 
related? Are they going to me merged somehow? What's the goal of having 
both?

> >> Can you
> >>
> >> git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> >>
> >> and use your .config, and build and test that kernel ? If it fails to
> >> boot / crash then you know its the driver.
> >
> > I'm not using git (don't even have it installed in my system), I'm
> > used to compile kernels/modules in the old fashion way. Sorry, I don't
> > know how git works.
> 
> make localmodconfig
> make
> make install

(...)

Will try and report back. Thanks, Luis.
 
Greetings,

-- 
Camaleón 
