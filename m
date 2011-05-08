Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.ukrpost.ua ([82.207.79.22]:38391 "EHLO relay2.ukrpost.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1EHC0J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 22:26:09 -0400
Received: from mail.academy.zt.ua ([82.207.120.245])
	by relay2.ukrpost.ua with esmtp (Exim 4.75)
	(envelope-from <prvs=110986adc1=george@znau.edu.ua>)
	id 1QItQD-0000GL-2Y
	for linux-wireless@vger.kernel.org; Sun, 08 May 2011 05:08:37 +0300
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v12.0.0)
	with ESMTP id md50000002783.msg
	for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 05:07:23 +0300
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
	driver
From: George Kashperko <george@znau.edu.ua>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-arm-kernel@lists.infradead.org,
	Russell King <rmk@arm.linux.org.uk>,
	Andy Botting <andy@andybotting.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1304819081.21680.6.camel@maggie>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	 <201105061605.31625.arnd@arndb.de>
	 <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	 <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
	 <1304790665.13983.10.camel@dev.znau.edu.ua>
	 <BANLkTikLFff_86Fvg+jSty9vGLENiELF2Q@mail.gmail.com>
	 <1304792795.13983.28.camel@dev.znau.edu.ua>
	 <BANLkTi=6BFD4OmtU1WPxjbFJQe36=mZKEA@mail.gmail.com>
	 <1304794931.13983.44.camel@dev.znau.edu.ua>
	 <BANLkTik9FWgzpNWuMXXRjOj-rDvPNY_nCA@mail.gmail.com>
	 <1304796956.13983.65.camel@dev.znau.edu.ua>
	 <1304819081.21680.6.camel@maggie>
Content-Type: text/plain
Date: Sun, 08 May 2011 05:01:09 +0300
Message-Id: <1304820069.13983.82.camel@dev.znau.edu.ua> (sfid-20110508_042622_385562_7A2538D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sat, 2011-05-07 at 22:35 +0300, George Kashperko wrote: 
> > dbg_bcma_device_name
> > {
> > #ifdef DEBUG
> > 		case/switch/if/else stuff
> > #endif
> > 		return NULL;
> > }
> > But I don't see here much sense to hardcode names other than those of
> > buscommons/buscores for debugging purposes.
> 
> Would you please read and understand the code before discussing this?
> That would help the discussion on the technical side.
> 
> Those names are hardcoded by definition. And just like 14e4 is the PCI
> ID for Broadcom devices, 800 is the AXI ID for Broadcom Chipcommon.
> 
> And building an #ifdef mess around this stuff is not better than having
> a few bytes of _helpful_ information messages.
> You are absolutely right that those messages only help 1% of the people.
> Just as _any_ other kernel message.
> 

Following is first part of my comment with "case/switch/if/else stuff"
which you didn't quoted and which I was actually commented at:
> > How do you see relation between bcma_device_name and:
> > int zd_ioread32v_locked(...) {
> >       if (r) {
> >               dev_dbg_f(zd_chip_dev(chip),
> >                         "error: zd_ioread16v_locked. Error number %d\n", r);
> >               return r;
> >       }
> }
> No relation at all. It like comparing warm and soft. It will be if you
> do something like

Original discussion on the bcma_device_name was started by Arend
pointing that there can be cores with same id but different vendor code.
As one among ways to deal with this I've proposed to remove
bcma_device_name and let drivers supply core name.

Have nice day,
George


