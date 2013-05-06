Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:52669 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3EFG1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 02:27:36 -0400
Message-ID: <1367821181.23730.5.camel@cumari.coelho.fi> (sfid-20130506_082742_617172_01C689C6)
Subject: Re: linux-firmware: pull-request TI wireless firmwares 2012-04-29
From: Luciano Coelho <coelho@ti.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
Date: Mon, 06 May 2013 09:19:41 +0300
In-Reply-To: <1367811576.4131.39.camel@deadeye.wl.decadent.org.uk>
References: <1367229856.30716.22.camel@cumari.coelho.fi>
	 <1367811576.4131.39.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-06 at 04:39 +0100, Ben Hutchings wrote:
> On Mon, 2013-04-29 at 13:04 +0300, Luciano Coelho wrote:
> > Hi Ben,
> > 
> > Here are some updates to our wireless firmwares.  Updated the firmwares
> > for WiLink 6 and 7 and added a new version of the firmware for WiLink 8
> > and a binary configuration file.  Also updated the WHENCE file
> > accordingly.
> > 
> > Please let me know if there are any more problems.
> [...]
> > diff --git a/WHENCE b/WHENCE
> > index 4726742..257f24e 100644
> > --- a/WHENCE
> > +++ b/WHENCE
> > @@ -1681,11 +1681,11 @@ Version: 6.5.2.0.15 (Multi-role)
> >  File: ti-connectivity/wl127x-fw-4-plt.bin
> >  Version: 6.3.5.0.98 (PLT-only)
> >  File: ti-connectivity/wl127x-fw-5-sr.bin
> > -Version: 6.3.10.2.115 (Single-role)
> > +Version: 6.3.10.0.133 (Single-role)
> >  File: ti-connectivity/wl127x-fw-5-mr.bin
> > -Version: 6.5.7.0.27 (Multi-role)
> > +Version: 6.5.7.0.42 (Multi-role)
> >  File: ti-connectivity/wl127x-fw-5-plt.bin
> > -Version: 6.3.10.2.115 (PLT-only)
> > +Version: 6.3.10.0.133 (PLT-only)
> >  
> >  File: ti-connectivity/wl128x-fw.bin
> >  Version: 7.1.5.50.74 (STA-only)
> > @@ -1702,11 +1702,11 @@ Version: 7.5.2.0.15 (Multi-role)
> >  File: ti-connectivity/wl128x-fw-4-plt.bin
> >  Version: 7.3.5.0.98 (PLT)
> >  File: ti-connectivity/wl128x-fw-5-sr.bin
> > -Version: 7.3.10.2.115 (Single-role)
> > +Version: 7.3.10.0.133 (Single-role)
> >  File: ti-connectivity/wl128x-fw-5-mr.bin
> > -Version: 7.5.7.0.27 (Multi-role)
> > +Version: 7.5.7.0.42 (Multi-role)
> >  File: ti-connectivity/wl128x-fw-5-plt.bin
> > -Version: 7.3.10.2.115 (PLT-only)
> > +Version: 7.3.10.2.133 (PLT-only)
> >  
> >  File: ti-connectivity/wl127x-nvs.bin
> >  File: ti-connectivity/wl128x-nvs.bin
> [...]
> 
> The commit message for this bit says:
> 
>     Update the wl127x and wl128x firmwares to *.3.10.0.133 for single-role
>     and *.5.7.0.42 for multi-role.
> 
> But for ti-connectivity/wl127x-fw-5-sr.bin,
> ti-connectivity/wl127x-fw-5-plt.bin and
> ti-connectivity/wl128x-fw-5-sr.bin this means the version is now *lower*
> than before.  For ti-connectivity/wl128x-fw-5-plt.bin the version is
> incremented to end in 2.133, but this is contrary to the commit message.
> 
> Are some of these firmware images being downgraded?  Should the version
> numbers really end in 2.133 or 0.133?

No, they are not being downgraded.  They are actually being upgraded.
The firmware versioning is rather weird.  The second last value is not
incremental, it specifies a project.  0 is the multichannel support
project.

The driver was changed a while back to take this version structure into
consideration.  Take a look at this patch:

af4e94c wlcore: change way of checking the firmware version

I hope this clarifies.

--
Cheers,
Luca.

