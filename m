Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47651 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbZC1MrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 08:47:24 -0400
Date: Sat, 28 Mar 2009 09:47:19 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] rfkill/rfkill-input userspace API
Message-ID: <20090328124719.GF7439@khazad-dum.debian.net> (sfid-20090328_134727_449215_BA2F819A)
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br> <20090327221147.GA499@srcf.ucam.org> <20090328123645.GD7439@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090328123645.GD7439@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matthew!

On Sat, 28 Mar 2009, Henrique de Moraes Holschuh wrote:

> On Fri, 27 Mar 2009, Matthew Garrett wrote:
> > On Fri, Mar 27, 2009 at 12:58:01PM -0300, Henrique de Moraes Holschuh wrote:
> > > Note: unless something is done to change the way X.org deals with
> > > input devices, rfkill-input is _useless_ in a large number of setups
> > > as far as input event handling goes, because it will never get any
> > > events after X.org evdev grabs the input device.
> > 
> > X.org evdev doesn't grab the input device. We fixed that precisely 
> > because it broke rfkill-input.
> 
> Eh? What is that ioctl in the git version doing there, then?  Did I
> get the code from the wrong branch or something?

Ok, more on this: the ioctl _is_ needed for privacy reasons, it wasn't
added there just for the kick of it AFAIK.  Instead of just breaking
things the other way, can we configure evdev to sometimes do the grab,
and sometimes not, depending on a config option for that particular
device? 

Keyboards should be grabbed. Platform driver event sources shouldn't
(most of the time, anyway).  Adding flags to the input devices so that
the kernel can hint to userspace what should be done by default for a
given device is easy, and I offer to do the work.  I already want to
add flags to tell the joystick and mouse emulation to keep clear of
hdaps, anyway...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
