Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:15569 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbYH1O3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 10:29:10 -0400
Received: by ey-out-2122.google.com with SMTP id 6so117971eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 07:29:08 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 5/5] rfkill: remove transmitter blocking on suspend
Date: Thu, 28 Aug 2008 16:29:00 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
	Andrew Bird <ajb@spheresystems.co.uk>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
	Philip Langdale <philipl@overt.org>
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br> <200808261813.56050.IvDoorn@gmail.com> <20080827230111.GA18081@khazad-dum.debian.net>
In-Reply-To: <20080827230111.GA18081@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808281629.01139.IvDoorn@gmail.com> (sfid-20080828_162914_573479_22C3E44C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 August 2008, Henrique de Moraes Holschuh wrote:
> On Tue, 26 Aug 2008, Ivo van Doorn wrote:
> > > 	drivers/net/wireless/rt2x00/* (USB might need it?)
> > 
> > rt2x00 doesn't have rfkill support for the USB drivers, only the PCI drivers,
> > (because only those cards could have an actual rfkill switch.
> 
> Well, rfkill support is not related only to input devices, but also to
> transmitters.  And EVERY transmitter MUST have one (and a single one) rfkill
> class attached to it, unless the hardware is completely and utterly unable
> to block its transmitter(s).  I hope no rt2x00 device is like that...

True, but at the moment the rt2x00 implementation is limited to the PCI devices
which indicate they have the input device. Extending it to register the rfkill
structure for all rt2x00 hardware is on my todo list.

> > Other then that no changes are required in rt2x00 with this patch.
> 
> Which I will take to mean that all rt2x00 drivers, be them USB or PCI, will
> do whatever is needed (including shutting down transmitters explicitly, when
> the hardware doesn't do it implicitly because of something else the driver
> is doing) on their own suspend() methods.
> 
> Is that correct?  Because that's all patch 5 of 5 is concerned with.

That is correct, all rt2x00 drivers (with or without rfkill) will do this correctly.

Ivo
