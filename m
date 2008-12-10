Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57554 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbYLJSEd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 13:04:33 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] b43: rework rfkill code
Date: Wed, 10 Dec 2008 19:04:06 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
References: <20081210150935.GA10927@srcf.ucam.org> <1228930643.15837.48.camel@johannes.berg> <20081210175102.GA14282@srcf.ucam.org>
In-Reply-To: <20081210175102.GA14282@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812101904.07809.mb@bu3sch.de> (sfid-20081210_190442_983014_9E17FC41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 December 2008 18:51:02 Matthew Garrett wrote:
> On Wed, Dec 10, 2008 at 06:37:23PM +0100, Johannes Berg wrote:
> 
> > Ok. I think the fundamental flaw here is assuming that there's just a
> > single state. There isn't. The device can be turned off in hardware (in
> > which case sw won't be able do anything about it, but we want to know)
> > or in software (which we want to handle). Pretending that there's just a
> > single state that's either hw-off, sw-off or on is plain wrong. The
> > device can be hw-off and sw-off at the same time, and then if you turn
> > off the hw-off button it won't turn on (however, unless your system
> > integrator totally screwed up, you won't have a hw and a sw button on
> > your system)
> 
> They may not be physical buttons, but we can often control this anyway. 

But we do not _want_ it.
If you can do it, keep it private to the driver. Do not export it to other layers.
If you need to to sw-rfkill through it, do it in the driver and multiplex
the hw-sw-states in the driver.

-- 
Greetings, Michael.
