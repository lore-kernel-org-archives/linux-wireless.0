Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47648 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758565AbYLPPZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 10:25:09 -0500
Subject: Re: Fuijtsu Lifebook RFKILL support
From: Dan Williams <dcbw@redhat.com>
To: tony@linx.net
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Len Brown <lenb@kernel.org>, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-acpi@vger.kernel.org, jwoithe@physics.adelaide.edu.au,
	Peter Gruber <nokos@gmx.net>, linux-wireless@vger.kernel.org
In-Reply-To: <1229435444.4246.11.camel@localhost>
References: <1228957506.4045.11.camel@localhost>
	 <20081211165247.GA4844@khazad-dum.debian.net>
	 <1229016827.6446.6.camel@localhost>
	 <20081211194734.GA18132@khazad-dum.debian.net>
	 <1229046602.4030.13.camel@localhost>
	 <20081212195331.GA12679@khazad-dum.debian.net>
	 <alpine.LFD.2.00.0812121532580.4064@localhost.localdomain>
	 <1229172465.4010.11.camel@localhost>
	 <20081213132857.GA11428@khazad-dum.debian.net>
	 <1229274343.6775.15.camel@localhost.localdomain>
	 <20081215115336.GD17648@khazad-dum.debian.net>
	 <1229354348.12163.20.camel@localhost.localdomain>
	 <1229361241.13400.1.camel@localhost>
	 <1229363984.12163.114.camel@localhost.localdomain>
	 <1229435444.4246.11.camel@localhost>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 10:23:53 -0500
Message-Id: <1229441034.7307.22.camel@localhost.localdomain> (sfid-20081216_162531_532371_ACB5CBA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-12-16 at 13:50 +0000, Tony Vroon wrote:
> On Mon, 2008-12-15 at 12:59 -0500, Dan Williams wrote:
> > > P.S. Did you get my e-mail about the Sierra Wireless MC8790?
> > 
> > Yes; it's hal-info commit 8912ec2b5d0a221a74156c047b18a26b2d916e13.
> 
> That uses USB interface 0 like on the other cards. On the MC8790 you
> should be using USB interface 3. Unfortunately 0, 1 & 2 are duds that
> just time out.
> You can tell them apart from the "real" ones by them only having two
> endpoints instead of three. I'm not sure whether this is a bug or a
> feature yet.

Unfortunately, it might actually be any of the interfaces depending on
hotplug ordering.  These days, having hal-info do static tagging based
on USB port numbering is somewhat broken; we need to do modem probing
(I've got that half-done) *and* start tagging the ports in the driver
itself.  So you may be out of luck until then.

Dan


