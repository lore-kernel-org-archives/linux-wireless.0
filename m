Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbXKGPUg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 10:20:36 -0500
Subject: Re: airo WPA
From: Dan Williams <dcbw@redhat.com>
To: Matteo Croce <rootkit85@yahoo.it>
Cc: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>,
	Matthieu Castet <castet.matthieu@free.fr>,
	Fabrice Bellet <fabrice@bellet.info>,
	"John W. Linville" <linville@tuxdriver.com>,
	PReDaCoN <alessandroferrari@gmail.com>,
	Benjamin Reed <breed@users.sourceforge.net>,
	Javier Achirica <achirica@users.sourceforge.net>,
	Jean Tourrilhes <jt@hpl.hp.com>,
	linux-wireless@vger.kernel.org, linux-net@vger.kernel.org
In-Reply-To: <200711071559.47916.rootkit85@yahoo.it>
References: <200711070307.09832.rootkit85@yahoo.it>
	 <200711071515.16623.rootkit85@yahoo.it>
	 <1194446460.23444.6.camel@localhost.localdomain>
	 <200711071559.47916.rootkit85@yahoo.it>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 10:13:08 -0500
Message-Id: <1194448388.23721.0.camel@localhost.localdomain> (sfid-20071107_152043_634048_BB7598F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-11-07 at 15:59 +0100, Matteo Croce wrote:
> Il Wednesday 07 November 2007 15:41:00 hai scritto:
> > On Wed, 2007-11-07 at 15:15 +0100, Matteo Croce wrote:
> > > New patch against current git
> > 
> > NAK at the moment; we've got too many patches for this floating around.
> > I'm currently working out some issues with WPA with a pull from
> > Matthieu's svn repo plus a set from Fabrice.  There's an issue with that
> > set (that your patch also has) that causes WPA associations to fail
> > because frames are driver-MIC-ed at the wrong times.  The patches also
> > have some style issues that I'd like to clean up.
> > 
> > So here's what I'd like to do with the airo WPA patches.  They need to
> > go through _one_ place.  Either I'll volunteer the time to handle them
> > and people can feed them through me, or we need some other place where
> > people can coordinate the work.  I'm happy to push this stuff through
> > since it seems like most of the dual-mode issues have been solved.
> > 
> > The immediate bug is that the driver mis-MICs the first few EAPOL frames
> > that come back during the 4-way handshake, failing the WPA association
> > for PCMCIA cards at least.  I haven't tested with my mini-PCI part yet
> > and won't until this can be fixed.  Once that appears to work, I'd like
> > to run through a bunch of setups and make sure the driver behaves as
> > expected for both WPA-capable and non-WPA-capable firmware versions, and
> > with a number of different RADIUS setups and encryption modes including
> > Dynamic WEP.
> > 
> > Dan
> > 
> 
> So where to put the developing sources? Made the _one_ place
> and me (i hope also others) could help.

Well, ideally we push the patch upstream and then people can send
updates to this list...  I think it's really close and I feel like it
can be submitted for 2.6.25.

Dan

