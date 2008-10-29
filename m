Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:42564 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbYJ2MNc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 08:13:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.28-rc2: new PCMCIA device instance after resume - orinoco can't download firmware
Date: Wed, 29 Oct 2008 13:18:04 +0100
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org,
	orinoco-devel@lists.sourceforge.net
References: <200810282219.51492.arvidjaar@mail.ru> <20081029004235.GA17879@isilmar.linta.de> <200810290643.54707.arvidjaar@mail.ru>
In-Reply-To: <200810290643.54707.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810291318.05373.rjw@sisk.pl> (sfid-20081029_131338_352722_BBC6A20D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, 29 of October 2008, Andrey Borzenkov wrote:
> On Wednesday 29 October 2008, Dominik Brodowski wrote:
> > Hi,
> > 
> > On Tue, Oct 28, 2008 at 10:19:50PM +0300, Andrey Borzenkov wrote:
> > > I am running PCMCIA based orinoco with WPA support (external firmware)
> > > and two patches to cache it after request_firmware to use in resume.
> > > 
> > > This worked fine in 27 and wtopped working in 28-rc. The apparent difference
> > > I see:
> > 
> > Hm, can't find any suspect patch which would change this behaviour in PCMCIA
> > land. Could you try to bisect it on {drivers/base/ kernel/power
> > drivers/pcmcia drivers/net/wireless/orinoco*.c} possibly?
> > 
> 
> Yes, I too checked log for drivers/pcmcia and could not find anything
> spectacular.
> 
> I am afraid I can't estimate when (if) I will be able to do bisect :(
> 
> Rafael, it looks like some serious changes in suspend/resume framework?

Nope.  Almost nothing has changed in this area, except for the patch that
reworks the disabling of user mode helpers:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1bfcf1304ea79c46efc3724e548b13b4b442b418
and several bug fixes.

You can try to revert it, but I really don't expect it to have such an effect.

> Do you have any idea what could it be? Original message is here:
> http://marc.info/?l=linux-wireless&m=122522165719760&w=2

This probably is a result of the fact that we don't include firmware blobs
into modular drivers any more.  Please try to compile your driver directly
into the kernel and enable CONFIG_FIRMWARE_IN_KERNEL.

If this helps, we'll know what the problem is.

Thanks,
Rafael
