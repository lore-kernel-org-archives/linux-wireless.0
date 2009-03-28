Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:50682 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZC1Mor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 08:44:47 -0400
Date: Sat, 28 Mar 2009 12:44:43 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] rfkill/rfkill-input userspace API
Message-ID: <20090328124443.GA25759@srcf.ucam.org> (sfid-20090328_134449_554273_C9592E19)
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br> <20090327221147.GA499@srcf.ucam.org> <20090328123645.GD7439@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090328123645.GD7439@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 28, 2009 at 09:36:45AM -0300, Henrique de Moraes Holschuh wrote:
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

It'll only call the ioctl if the user explicitly passes the GrabDevice
option, and if they do that they can deal with the breakage. Default 
behaviour is not to grab. From the source:

   /* Grabbing the event device stops in-kernel event forwarding. In other     
       words, it disables rfkill and the "Macintosh mouse button emulation".
       Note that this needs a server that sets the console to RAW mode. */

-- 
Matthew Garrett | mjg59@srcf.ucam.org
