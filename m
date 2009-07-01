Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:51162 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZGAWyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 18:54:06 -0400
Date: Wed, 1 Jul 2009 15:42:54 -0700
From: Greg KH <greg@kroah.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, Dave <kilroyd@googlemail.com>,
	Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
Subject: Re: Insist on cfg80211 for new drivers?
Message-ID: <20090701224254.GA2854@kroah.com>
References: <1246464991.4331.18.camel@localhost>
 <4A4BA21F.1070101@gmail.com>
 <43e72e890907011112l220874bbu8db8808f666bbd4d@mail.gmail.com>
 <1246473300.30522.10.camel@localhost.localdomain>
 <20090701193657.GD3473@tuxdriver.com>
 <1246485123.12994.168.camel@localhost.localdomain>
 <43e72e890907011456q7e3d9f5al1057f940a7655cda@mail.gmail.com>
 <1246486104.12994.169.camel@localhost.localdomain>
 <20090701221359.GA2604@kroah.com>
 <1246486729.12994.176.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1246486729.12994.176.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 01, 2009 at 03:18:49PM -0700, Marcel Holtmann wrote:
> Hi Greg,
> 
> > > > >> > That's really all I
> > > > >> > care about, I don't want another WEXT-based driver accepted; I want all
> > > > >> > the new ones using cfg80211.
> > > > >>
> > > > >> Now there is a discussion we should have had in Berlin...is it time
> > > > >> to insist on cfg80211-based configuration for all new drivers?
> > > > >
> > > > > there is really nothing much to discuss on this topic. The plan is to
> > > > > deprecate WEXT, that simple. So if the driver has no cfg80211 support,
> > > > > then it will not be included. Period.
> > > > >
> > > > > Send such drivers off to staging and let them have their 6 month.  Then
> > > > > we either remove them again or they got ported to cfg80211.
> > > > 
> > > > 6 months only in staging ? Is this a rule now for staging?
> > > 
> > > that is what Greg mentioned to me. If there is no activity for 6 month
> > > and the driver is not getting anywhere, he going to drop it.
> > 
> > That is "within reason".  If a driver is still needed there, I'l
> > probably keep it, and will take each one on a case-by-case basis.
> 
> what do you mean "within reason". If the driver is just sitting there
> and no effort in making in upstream ready it is doing clearly more harm
> than any good.

Who is it "harming"?  You?  no.

> And I am not talking about removing some kernel version details or
> typedefs or coding style. Drivers with missing cfg80211 need active
> porting. And it is not that hard. See the orinoco one for an example.

Let me know if anything needs to be ported/fixed in the staging
directory.  Never use anything in that directory as a reason to not
change any kernel apis, I will always fix up things as needed.

> If we see developers committed to fixing it that is a different story,
> but a lot of drivers in staging are getting no attention all. So they
> are fully pointless and are not doing any good for Linux. We need to
> send the vendors a clear message that code drops of their crappy Windows
> code are not desired.

Oh yeah, "clear messages", I'm _sure_ that would get through to them...

{sigh}

Seriously, I will take each driver on a case-by-case basis.

thanks,

greg k-h
