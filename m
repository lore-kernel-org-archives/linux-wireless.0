Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:51767 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750855AbcACH33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 02:29:29 -0500
Message-ID: <1451806163.4334.36.camel@perches.com> (sfid-20160103_083041_959818_1051F49F)
Subject: Re: [PATCH 1/3] NFC-mei_phy: Refactoring for mei_nfc_connect()
From: Joe Perches <joe@perches.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
	Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Date: Sat, 02 Jan 2016 23:29:23 -0800
In-Reply-To: <5688C712.3070900@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
	 <56883849.2080304@users.sourceforge.net>
	 <5688390B.3080800@users.sourceforge.net>
	 <CAGRGNgWiHKLrHMUySnCpfiF1+C=QV-i4C4KNmziga3-E1CLfKA@mail.gmail.com>
	 <5688C712.3070900@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-01-03 at 08:00 +0100, SF Markus Elfring wrote:
> > >         r = 0;
> > > -
> > > -err:
> > > +free_reply:
> > >         kfree(reply);
> > > +free_cmd:
> > >         kfree(cmd);
> > > -
> > 
> > Why are you deleting the two blank lines here?
> 
> Can they be unnecessary at this source code place
> according to the Linux coding style convention?

As far as I know, there's no linux specific accepted
convention for blank lines preceding labels.

My personal preference is for a blank line before a
new block, but not before the second and subsequent
labels in an error handling block.

