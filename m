Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:50191 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbXBMQ3J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 11:29:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
Date: Tue, 13 Feb 2007 17:25:43 +0100
Cc: Larry Finger <larry.finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de,
	John Linville <linville@tuxdriver.com>
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <200702130008.47684.rjw@sisk.pl> <200702130024.20876.mb@bu3sch.de>
In-Reply-To: <200702130024.20876.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702131725.45033.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, 13 February 2007 00:24, Michael Buesch wrote:
> On Tuesday 13 February 2007 00:08, Rafael J. Wysocki wrote:
> > On Monday, 12 February 2007 23:20, Larry Finger wrote:
> > > Rafael J. Wysocki wrote:
> > > > On Monday, 12 February 2007 02:18, Larry Finger wrote:
> > > >> Rafael J. Wysocki wrote:
> > > >>> It doesn't help in my case.  The behavior is similar to that without the patch,
> > > >>> but also with the patch it loses the association entirely.
> > > >> Thanks for trying.
> > > >>
> > > >> Do you have this patch installed? If you do, please try increasing the 100 to 200.
> > > > 
> > > > Hm, but it wouldn't help to get the microcode to respond after the resume ...
> > > 
> > > Yes it would. That count is how long the system waits for the firmware to respond.
> > > 
> > > > I'm still thinking the problem is with the firmware.  Where exactly is it
> > > > stored?
> > > 
> > > In the memory of the microprocessor on the card.
> > > 
> > > Please do what I asked.
> > 
> > With or without the previous patch?
> 
> Both, please.

It doesn't help in either case.  I get

albercik:~ # ifconfig eth1 down
albercik:~ # ifconfig eth1 up
SIOCSIFFLAGS: No such device

in both cases.

I think the problem is that the firmware is not present and requesting it 
doesn't work for some reason.

Greetings,
Rafael
