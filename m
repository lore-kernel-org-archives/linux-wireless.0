Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34880 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbYLJTAO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 14:00:14 -0500
Subject: Re: [RFC] b43: rework rfkill code
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Michael Buesch <mb@bu3sch.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
In-Reply-To: <1228934039.15837.59.camel@johannes.berg>
References: <20081210150935.GA10927@srcf.ucam.org>
	 <1228929529.15837.34.camel@johannes.berg>
	 <1228929820.15837.40.camel@johannes.berg> <200812101831.13526.mb@bu3sch.de>
	 <1228930643.15837.48.camel@johannes.berg>
	 <20081210175102.GA14282@srcf.ucam.org>
	 <1228932343.15837.57.camel@johannes.berg>
	 <1228933790.28590.29.camel@localhost.localdomain>
	 <1228934039.15837.59.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 13:59:05 -0500
Message-Id: <1228935546.28590.37.camel@localhost.localdomain> (sfid-20081210_200028_622948_BFE36DBE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-10 at 19:33 +0100, Johannes Berg wrote:
> On Wed, 2008-12-10 at 13:29 -0500, Dan Williams wrote:
> 
> > > Does the wireless driver get the notification about this from the
> > > hardware, like it would if this was a real physical switch? Then it's
> > > probably pretty simple: provide a rfkill struct from the driver that
> > > updates hard-kill and provide a second rfkill struct for the platform
> > > device that doesn't get hard-killed, but also provide a soft-kill input
> > > form the platform device. That way, you can toggle that button, but you
> > > can also software-enable the platform rfkill device and that in turn
> > > re-enables the wifi-rfkill "hw" switch device.
> > 
> > This sort of sucks for userspace, because we see the actual wifi card as
> > hardblocked, but some other random button as softblocked.  There's no
> > indication that changing the softblock one will affect the hardblocked
> > one.  What are userspace processes supposed to do here, assume that if a
> > non-radio-associated softblocked switch exists, that it can re-enable a
> > hardblocked radio of some random wifi card?
> 
> The other question is whether we actually care? So what if the hardware
> can only be enabled with the button, why does that matter?

I guess it doesn't, as long as in Matthew's case, the actual radio
rfkill state is only ever softblocked, because it actually *can* be
re-enabled with the platform button or something.

Dan


