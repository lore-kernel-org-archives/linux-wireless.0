Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.siteground211.com ([209.62.36.12]:39532 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbYGaX0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 19:26:50 -0400
Date: Fri, 1 Aug 2008 02:26:41 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Message-ID: <20080731232640.GB10436@frodo> (sfid-20080801_012655_308617_3C1704E2)
Reply-To: me@felipebalbi.com
References: <4891D1B9.70703@imap.cc> <20080731163843.GB9606@kroah.com> <48922FE2.70705@imap.cc> <20080731215055.GB4817@kroah.com> <489242CF.2000100@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <489242CF.2000100@imap.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 01, 2008 at 12:55:11AM +0200, Tilman Schmidt wrote:
> Oh, please ... You aren't seriously trying to tell me there's a *technical*
> reason for changing EXPORT_SYMBOL to EXPORT_SYMBOL_GPL, are you?

You really have no idea what you're talking about. If manufacturers
really don't wanna write gpl code, they have really sane api via
usbdev_fs.h or libusb to do it.

It's like we completely removed any possibility of closed source
drivers.

> That's not true. Reverting commit 782e70c6fc2290a0395850e8e02583b8b62264d8
> would be enough. But again, I am not asking for that. My question isn't
> about getting AVM's closed source driver to work with kernel 2.6.25+.
> I just want to know whether there is an open source alternative, nothing
> more.

Did you read the commit message?

"Over two years ago, the Linux USB developers stated that they believed
there was no way to create a USB kernel driver that was not under the
GPL.  This patch moves the USB apis to enforce that decision.

There are no known closed source USB drivers in the wild, so this patch
should cause no problems."

So a) it wasn't an over-the-night decision. It was stated publicly and
given a 2 years period for everybody to know about what would happen and
b) "there are no know closed source usb drivers in the wild",
unfortunately, it looks like nobody knew about AVM's closed source
driver.

And after all, that driver isn't even closed source. I can see in the
files' header the driver is lgpl (that's actually the first lgpl driver
i see :-p)

> > This is between you and AVM.  I really suggest contacting the company.
> > I have talked to them in the past and they seem willing to help out
> > where they can.
>
> Obviously even you weren't able to convince them to convert their driver
> for this device to something compatible with post 2.6.24 kernels. How
> then could I possibly hope to achieve anything? I have no contractual
> relationship with AVM. I don't know anybody in that company. I don't work
> for anyone they would recognize. All I can do is contact the regular
> consumer support people who don't even know what I am talking about and
> keep asking me to boot Windows, where the device obviously works, so all
> is well, no? After all, it does say "System requirements: Windows" on the
> box.

Again, you can get the sources under lgpl, which means you can change
the code and fix it up.

With a few changes to the source file, I could make it build. Don't have
the device to test, but I assure you it's pretty simple changes.

-- 
balbi
