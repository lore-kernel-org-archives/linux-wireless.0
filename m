Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:41981 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1EGR5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 13:57:23 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v12.0.0)
	with ESMTP id md50000002738.msg
	for <linux-wireless@vger.kernel.org>; Sat, 07 May 2011 20:57:12 +0300
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
	driver
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
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
In-Reply-To: <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	 <201105061605.31625.arnd@arndb.de>
	 <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	 <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 07 May 2011 20:51:05 +0300
Message-Id: <1304790665.13983.10.camel@dev.znau.edu.ua> (sfid-20110507_195735_120683_CF00D875)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 2011/5/6 Rafał Miłecki <zajec5@gmail.com>:
> > 2011/5/6 Arnd Bergmann <arnd@arndb.de>:
> >>> +const char *bcma_device_name(u16 coreid)
> >>> +{
> >>> +     switch (coreid) {
> >>> +     case BCMA_CORE_OOB_ROUTER:
> >>> +             return "OOB Router";
> >>> +     case BCMA_CORE_INVALID:
> >>> +             return "Invalid";
> >>> +     case BCMA_CORE_CHIPCOMMON:
> >>> +             return "ChipCommon";
> >>> +     case BCMA_CORE_ILINE20:
> >>> +             return "ILine 20";
> >>
> >> It's better to make that a data structure than a switch() statement,
> >> both from readability and efficiency aspects.
> >
> > Well, maybe. We call it only once, at init time. In any case we're
> > still waiting for Broadcom to clarify which cores are really used for
> > BCMA.
> 
> Arnd: did you have a look at defines at all?
> 
> Most of the defines have values in range 0x800 → 0x837. Converting
> this to array means loosing 0x800 u16 entries. We can not use 0x800
> offset, because there are also some defined between 0x000 and 0x800:
> #define BCMA_CORE_OOB_ROUTER           0x367   /* Out of band */
> #define BCMA_CORE_INVALID              0x700
> 
> Oh and there is still:
> #define BCMA_CORE_DEFAULT              0xFFF
> we could want to include. Then we would loose additional (0xFFF -
> 0x837) u16 entries in array.
What is the purpose for bcma_device_name in bus driver code ? Why not
define const char *name in struct bcma_driver and let driver writers
supply kernel with knowledge on new cores' names rather than hard type
those into the bus code ? Also this will close the question Arend asked
you regarding same core ids with different manufacturer ids.

Have nice day,
George


