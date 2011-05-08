Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40615 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1EHKuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 06:50:55 -0400
Date: Sun, 8 May 2011 11:50:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: George Kashperko <george@znau.edu.ua>,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
	Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-arm-kernel@lists.infradead.org,
	Andy Botting <andy@andybotting.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
	driver
Message-ID: <20110508105027.GI27807@n2100.arm.linux.org.uk> (sfid-20110508_125059_575296_171D4299)
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com> <201105061605.31625.arnd@arndb.de> <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com> <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com> <1304790665.13983.10.camel@dev.znau.edu.ua> <BANLkTikLFff_86Fvg+jSty9vGLENiELF2Q@mail.gmail.com> <1304792795.13983.28.camel@dev.znau.edu.ua> <BANLkTi=6BFD4OmtU1WPxjbFJQe36=mZKEA@mail.gmail.com> <20110508101609.GF27807@n2100.arm.linux.org.uk> <BANLkTikMruTibp64GjE9qP9r80JiHgAFXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <BANLkTikMruTibp64GjE9qP9r80JiHgAFXw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 08, 2011 at 12:37:15PM +0200, Rafał Miłecki wrote:
> 2011/5/8 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> > On Sat, May 07, 2011 at 08:48:10PM +0200, Rafał Miłecki wrote:
> >> Really, what's wrong with that? Does it kill anyone's pet we print
> >> this? We also do:
> >> pr_err("Scanning failed because of wrong CID\n");
> >> return -1;
> >> While we could drop pr_err. Why to do this? Advanced used can always
> >> check what -1 means.
> >
> > And why return -1 when we have a system of error codes?  I _really_ wish
> > people would stop returning -1 for "some random error occurred".
> 
> You commented on imagined code, but we actually do sth similar in code.
> 
> I did this because:
> 1) I had no idea what err code would be valid for invalid EPROM layout
> (content). Nothing from include/asm-generic/errno-base.h sounds
> reasonable.
> 2) I wanted to use different error codes for different EPROM layout
> issues. Sometimes we don't get CIA block. Sometimes we don't get CIB
> block. Sometimes there is problem with master port (not found in EPROM
> when expected). They all would probably use the same errno.
> 
> Could you help me with this?

The problem is if you start using -1 and mixing it with stuff which does
return negative errno codes, you end up hitting one of two bugs:

1. you interpret -1 as being -EPERM when actually you meant something else.
2. you check the function's return value for -1 rather than < 0, and you
   unintentionally ignore valid -errno codes.

So it's normally far better to find something in the errno stuff which
approximates the error you have rather than using -1.  Eg, if something
is invalid and you can't find something which fits, -EINVAL is probably
a good idea.

If you can't access the eeprom because its not responding, maybe -EIO
or -ETIMEDOUT would be better than -1?

Maybe for CRC errors, or unexpected data -EILSEQ would be appropriate?

Maybe if something being requested isn't found, -ENOENT would be better
(may not be a file or directory, but it approximates the error as being
'error no entry').
