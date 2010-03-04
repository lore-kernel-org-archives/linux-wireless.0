Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49021 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab0CDCVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 21:21:52 -0500
Date: Wed, 3 Mar 2010 21:20:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jose Alonso <joalonsof@gmail.com>
Cc: matthieu castet <castet.matthieu@free.fr>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] airo : Print of firmware version
Message-ID: <20100304022012.GA1994@tuxdriver.com>
References: <4B8A80EE.6000102@free.fr>
 <20100303201411.GF23920@tuxdriver.com>
 <1267657973.6254.11.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1267657973.6254.11.camel@laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 03, 2010 at 08:12:53PM -0300, Jose Alonso wrote:
> On Wed, 2010-03-03 at 15:14 -0500, John W. Linville wrote:
> > On Sun, Feb 28, 2010 at 03:42:54PM +0100, matthieu castet wrote:
> > > For the firmware version 5.30.17 the log file shows:
> > > Firmware version 5.30.11
> > >
> > > The variable softSubVer is binary.
> > >
> > >
> > > Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> > > Signed-off-by: Jose Alonso <joalonsof@gmail.com>
> > 
> > > Index: airo.c
> > > ===================================================================
> > > --- 1/drivers/net/wireless/airo.c	(r?vision 47)
> > > +++ 2/drivers/net/wireless/airo.c	(r?vision 48)
> > > @@ -2993,7 +2993,7 @@
> > >  	ai->wep_capable = (cap_rid.softCap & cpu_to_le16(0x02)) ? 1 : 0;
> > >  	ai->max_wep_idx = (cap_rid.softCap & cpu_to_le16(0x80)) ? 3 : 0;
> > >  
> > > -	airo_print_info(dev->name, "Firmware version %x.%x.%02x",
> > > +	airo_print_info(dev->name, "Firmware version %x.%x.%02d",
> > >  	                ((le16_to_cpu(cap_rid.softVer) >> 8) & 0xF),
> > >  	                (le16_to_cpu(cap_rid.softVer) & 0xFF),
> > >  	                le16_to_cpu(cap_rid.softSubVer));
> > 
> > Why should the last segment be in decimal form if the other two
> > segments of the version number are in hexadecimal form?
> 
> The airo.c shows the usage of hexadecimal and binary form:
> 
>         /* Test for WPA support */
>         /* Only firmware versions 5.30.17 or better can do WPA */
>         if (le16_to_cpu(cap_rid.softVer) > 0x530
>          || (le16_to_cpu(cap_rid.softVer) == 0x530
>               && le16_to_cpu(cap_rid.softSubVer) >= 17)) {
>                 airo_print_info(ai->dev->name, "WPA supported.");

Alright, but that could be an argument for changing the comment.
Probably too much to ask, but is there some authoritative source for
this busted numbering scheme?

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
