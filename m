Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59468 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970AbZK1Mlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 07:41:55 -0500
Date: Sat, 28 Nov 2009 10:41:58 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ian Molton <ian.molton@collabora.co.uk>,
	linux-acpi@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>
Subject: rfkill: persistent device suspend/resume
Message-ID: <20091128124158.GB17373@khazad-dum.debian.net>
References: <4A37A3E1.8060606@tuffmail.co.uk>
 <1245161645.13461.3.camel@johannes.local>
 <4A37AEB7.6060405@tuffmail.co.uk>
 <20090618030806.GE29569@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090618030806.GE29569@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Jun 2009, Henrique de Moraes Holschuh wrote:
> > The setting of the "persistent" flag is also made more explicit using
> > a new rfkill_init_sw_state() function, instead of special-casing
> > rfkill_set_sw_state() when it is called before registration.
> > 
> > Suspend is a bit of a corner case so we try to get away without adding
> > another hack to rfkill-input - it's going to be removed soon.
> > If the state does change over suspend, users will simply have to prod
> > rfkill-input twice in order to toggle the state.

Well, I acked it, but I didn't do my job properly and didn't notice the
above.

Suspend/resume is not much of a corner case at all:  unless overriden by
some weird policy that doesn't even exist right now (the only one that comes
to mind is to have it always off upon resume in highly-critical
environments), we really want to restore the hardware to the previous soft
state, subject to any changes on any hard state that happened while the
machine was sleeping.

And any "weird policy" we might implement would have to come through the
core anyway.  So, we really should be taking advantage of the fact that the
rfkill class will resume *after* the device, and let the core call the
backend (unconditionally, so it is also a way to make sure the
firmware/hardware is in sync with the core) to set the proper state after a
resume.

The backend will be able to update any hard states before the rfkill class
resume code runs, so this will always work fine.   It also allows the
backend driver to ask the platform to resume with radios disabled, so that
if we _ever_ decide to change the core to have a different policy to what
should be done to radios on resume (e.g. leave them off and wait for
userspace to tell us what to do :) ), that will need no change to drivers
(and radios won't get turned on just to be turned off, etc).

It will also let us remove a few LOC from eeepc-laptop and avoid adding a
few LOC to thinkpad-acpi (which has a regression since 2.6.30 because failed
to notice I would have to handle resume).

What do you guys think?   I will cook up a patch to implement the above, but
if there are any objections to the idea, I'd like to hear it ASAP, as I do
have a regression to fix :)

Note: eeepc-laptop and thinkpad-acpi are the only rfkill persistent devices
in-tree.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
