Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:16372 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab0GGPqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 11:46:53 -0400
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 07 Jul 2010 11:46:51 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Madhusudhan <madhu.cr@ti.com>
Cc: 'Roger Quadros' <roger.quadros@nokia.com>,
	"'Hunter Adrian (Nokia-MS/Helsinki)'" <adrian.hunter@nokia.com>,
	'Ohad Ben-Cohen' <ohad@wizery.com>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux@arm.linux.org.uk,
	"'Coelho Luciano (Nokia-MS/Helsinki)'" <Luciano.Coelho@nokia.com>,
	akpm@linux-foundation.org, 'San Mehat' <san@google.com>
Subject: RE: [PATCH 11/15] wireless: wl1271: introduce platform device support
In-reply-to: <E6AFC02D8D114C129C8140932818E578@am.dhcp.ti.com>
Message-id: <alpine.LFD.2.00.1007071120351.6020@xanadu.home>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
 <1278376666-3509-12-git-send-email-ohad@wizery.com>
 <4C32EF19.1000604@nokia.com>
 <AANLkTintIz-N7MwwtqhVq2LR3Ln5JTNYSbJUBSSClcA-@mail.gmail.com>
 <4C3306F4.8060907@nokia.com>
 <AANLkTin5W52fPzWToRrAzm56SLZI-taSuI16rCEhLWqH@mail.gmail.com>
 <4C333E0D.2070601@nokia.com> <alpine.LFD.2.00.1007061316010.6020@xanadu.home>
 <4C338927.5020400@nokia.com> <4C34347F.8030000@nokia.com>
 <alpine.LFD.2.00.1007070954010.6020@xanadu.home>
 <E6AFC02D8D114C129C8140932818E578@am.dhcp.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 7 Jul 2010, Madhusudhan wrote:

> 
> 
> > -----Original Message-----
> > From: Nicolas Pitre [mailto:nico@fluxnic.net]
> > Sent: Wednesday, July 07, 2010 9:03 AM
> > To: Roger Quadros
> > Cc: Hunter Adrian (Nokia-MS/Helsinki); Ohad Ben-Cohen; linux-
> > wireless@vger.kernel.org; linux-mmc@vger.kernel.org; linux-
> > omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> > linux@arm.linux.org.uk; Chikkature Rajashekar Madhusudhan; Coelho Luciano
> > (Nokia-MS/Helsinki); akpm@linux-foundation.org; San Mehat
> > Subject: Re: [PATCH 11/15] wireless: wl1271: introduce platform device
> > support
> > 
> > On Wed, 7 Jul 2010, Roger Quadros wrote:
> > 
> > > On 07/06/2010 10:51 PM, Hunter Adrian (Nokia-MS/Helsinki) wrote:
> > > > For eMMC in omap_hsmmc, this is all done via claim_host / release_host
> > > > which call ->enable() / ->disable() methods.  omap_hsmmc makes use of
> > > > mmc_power_restore_host() which calls host->bus_ops->power_restore()
> > > > which is not implemented for SDIO, but for MMC and SD it reinitializes
> > > > the card.
> > 
> > This is IMHO a really bad design.  The power control decision has to
> > come from the top, not from the bottom.  And certainly not with a
> > U-turn dependency the omap_hsmmc is using.
> > 
> > I regret to say this, but the omap_hsmmc driver is becoming a total
> > mess.  The host controller driver has to be a dumb interface serving
> > requests from the hardware used by the upper layer stack, not the place
> > where decisions such as power handling should be made.  Think of it like
> > an ethernet driver.  No ethernet driver in Linux is telling the IP stack
> > when to shut down.
> > 
> 
> The point is that MMC/SD core files were patched to provide this kind of a
> support. Any controller driver can use that framework today, right?. As an
> example omap_hsmmc driver was patched and it works fine.

It is not because you are twisting the layers and customizing the core 
stack around your own controller that it is good software design.

And the presence of the mmc_power_restore_host() code doesn't mean it is 
sane.  My point is that no one should ever use that, not even 
omap_hsmmc.

Proof: it works so fine that now you must come up with yet another 
contorted hack piled on top called "fake^H^H^H^Hsoftware insert/remove 
events" to support power handling with SDIO cards.

This MMC_CAP_DISABLE is ridiculous.  Why would this have to be a host 
capability?  This should be a core feature that should be _transparent_ 
to all hosts with no changes to any of the host drivers.  When the core 
code knows that the card can be shut down after some idle period, it 
should do so with the *existing* API calls, namely the set_ios method.  
In the SDIO case it would be a simple matter of mapping the 
sdio_release_power() onto that.  Instead, some contorted power 
management support was sneaked in, which is misdesigned to the point of 
breaking proper SDIO support for which more misdesigned features are now 
needed to work around the former ones.

Now the OMAP driver is becoming a stack of its own, making decisions 
that clearly should be made at a higher level of abstraction.  To me 
this denotes some laziness from the involved developers who didn't take 
the time to design something sensible and generic in the core code, but 
rather hacked a quick solution specific to omap_hmmc.c.  Of course the 
former would require a greater understanding of common code and some 
additional effort to make the solution truly generic.  Instead, the easy 
solution was taken which is to stuff magic behaviors in a host driver 
while other people are not paying as much attention to it than core 
code.

Needless to say that I'm not impressed at all.


Nicolas
