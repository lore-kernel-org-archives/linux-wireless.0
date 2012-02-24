Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab2BXK6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 05:58:07 -0500
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for SPROM
 storage
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <4F4768D0.4030109@broadcom.com> (sfid-20120224_113946_190994_AFCFACFE)
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
	 <CACna6rwk8xbjbX7uisqAv_y_JYn636orR-VLgNQ908yOYS+i1A@mail.gmail.com>
	 <4F4768D0.4030109@broadcom.com> (sfid-20120224_113946_190994_AFCFACFE)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 11:58:03 +0100
Message-ID: <1330081083.3426.15.camel@jlt3.sipsolutions.net> (sfid-20120224_115811_632090_C6ED480D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-24 at 11:39 +0100, Arend van Spriel wrote:
> On 02/24/2012 08:52 AM, Rafał Miłecki wrote:
> >> +               srom_control = bcma_read32(bus->drv_cc.core,
> >> >  +                                          BCMA_CC_SROM_CONTROL);
> >> >  +               return !!(srom_control&  BCMA_CC_SROM_CONTROL_PRESENT);
> > Does any compiler complain on returning sth like 0xF as a bool?
> >
> 
> The compiler probably will not complain, but the caller could have 
> following:
> 
> if (bcma_sprom_ext_available(bus) == true) {
> 	return;
> }
> BUG();
> 
> I guess you would see the BUG show up in your log with the function 
> returning 0xF.

If it's really

bool foo = a & b;

then the compiler has to compile that as if it was

u8 foo = !!(a & b);

since bool can only carry the values 0 and 1.

So the !! isn't necessary.

johannes

