Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55642 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYLJUHs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 15:07:48 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC] b43: rework rfkill code
Date: Wed, 10 Dec 2008 21:07:08 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
References: <20081210150935.GA10927@srcf.ucam.org> <1228932343.15837.57.camel@johannes.berg> <1228933790.28590.29.camel@localhost.localdomain>
In-Reply-To: <1228933790.28590.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812102107.09568.mb@bu3sch.de> (sfid-20081210_210751_529747_21B3D08D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 December 2008 19:29:50 Dan Williams wrote:
> On Wed, 2008-12-10 at 19:05 +0100, Johannes Berg wrote:
> > On Wed, 2008-12-10 at 17:51 +0000, Matthew Garrett wrote:
> > 
> > > They may not be physical buttons, but we can often control this anyway. 
> > > For instance, my HP has a button that will perform a hardware disable of 
> > > the wifi card. However, I can control that button's state through 
> > > software with the hp-wmi driver. 
> > 
> > That's indeed a complication I wasn't aware of.
> > 
> > > The way we currently handle that (and, 
> > > I think, the only way we *can* handle that) is to provide two separate 
> > > rfkill interfaces - one tied to the wireless device, one tied to the 
> > > platform device.
> > 
> > Yes, but how do we currently do this?
> > 
> > Does the wireless driver get the notification about this from the
> > hardware, like it would if this was a real physical switch? Then it's
> > probably pretty simple: provide a rfkill struct from the driver that
> > updates hard-kill and provide a second rfkill struct for the platform
> > device that doesn't get hard-killed, but also provide a soft-kill input
> > form the platform device. That way, you can toggle that button, but you
> > can also software-enable the platform rfkill device and that in turn
> > re-enables the wifi-rfkill "hw" switch device.
> 
> This sort of sucks for userspace, because we see the actual wifi card as
> hardblocked, but some other random button as softblocked.  There's no
> indication that changing the softblock one will affect the hardblocked
> one.  What are userspace processes supposed to do here, assume that if a
> non-radio-associated softblocked switch exists, that it can re-enable a
> hardblocked radio of some random wifi card?

I don't see the problem.
If userspace wants to enable wifi, it should simply _try_ to do so:
Userspace sees hw-block and sw-block state:
- Unblock the sw state
- Re-fetch hw-block and sw-block state
- If either one is blocked, we can't enable the radio.
- Notify user.

-- 
Greetings, Michael.
