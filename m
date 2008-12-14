Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49126 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbYLNDNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Dec 2008 22:13:32 -0500
Date: Sun, 14 Dec 2008 01:13:27 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Tony Vroon <tony@linx.net>, Len Brown <lenb@kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-acpi@vger.kernel.org, jwoithe@physics.adelaide.edu.au,
	Peter Gruber <nokos@gmx.net>, linux-wireless@vger.kernel.org
Subject: Re: Fuijtsu Lifebook RFKILL support
Message-ID: <20081214031326.GA16087@khazad-dum.debian.net> (sfid-20081214_041343_786077_BEB06F2A)
References: <1228957506.4045.11.camel@localhost> <20081211165247.GA4844@khazad-dum.debian.net> <1229016827.6446.6.camel@localhost> <20081211194734.GA18132@khazad-dum.debian.net> <1229046602.4030.13.camel@localhost> <20081212195331.GA12679@khazad-dum.debian.net> <alpine.LFD.2.00.0812121532580.4064@localhost.localdomain> <1229172465.4010.11.camel@localhost> <20081213132857.GA11428@khazad-dum.debian.net> <20081213175745.GA6825@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081213175745.GA6825@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 13 Dec 2008, Matthew Garrett wrote:
> On Sat, Dec 13, 2008 at 11:28:57AM -0200, Henrique de Moraes Holschuh wrote:
> > > Len, I would still like to export the 3 values learned about in this
> > > event to userspace. Is it alright for me to create 3 read-only files on
> > > the platform device? (docked, lid, radios)
> > > It would if anything simplify the code.
> > 
> > FWIW, I think this is also the way to go.  It is much easier for
> > userspace to deal with sysfs attributes.  HAL can deal with more
> > complex stuff, but shell script writers often don't know how to, nor
> > care to, deal with HAL.
> 
> I feel like I'm missing something here, but surely what we're talking 
> about is simply a single rfkill device that affects all radios and as 
> such should have a new RFKILL_TYPE_ALL type associated with it? I'd read 
> this as there being a software control that affected all radios. If 
> there's no software control at all then I agree that providing an rfkill 
> class here isn't appropriate.

There isn't a "type all" rfkill class.  I have patches that export the
rfkill core global states, and one of the global states looks like an
"all switch" indeed (the Emergency Power Off global state).

I did try an "one rfkill class for each type, and a master rfkill
class" approach a few months ago, and it didn't fly.  I think I even
deleted it because it was too ugly to see the light of the day, or
something.

I will post what I have soon. I am not happy with it, but it might be
interesting to see if someone can come up with a better approach.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
