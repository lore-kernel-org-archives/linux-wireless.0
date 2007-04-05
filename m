Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gollum.nazgul.ch ([81.221.21.253]:5249 "EHLO gollum.nazgul.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbXDEQgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 12:36:21 -0400
Date: Thu, 5 Apr 2007 18:34:34 +0200
From: Marcus Glocker <marcus@nazgul.ch>
To: Michael Buesch <mb@bu3sch.de>
Cc: Marcus Glocker <mglocker@openbsd.org>,
	Jon Simola <jsimola@gmail.com>,
	Theo de Raadt <deraadt@theos.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Martin Langer <martin-langer@gmx.de>,
	Danny van Dyk <kugelfang@gentoo.org>,
	Andreas Jaggi <andreas.jaggi@waterwave.ch>,
	Larry Finger <larry.finger@lwfinger.net>, Quaker.Fang@sun.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Joseph Jezak <josejx@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	Greg kh <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Message-ID: <20070405163434.GA18477@gollum.nazgul.ch>
References: <200704041945.21447.mb@bu3sch.de> <20070405054107.GB7660@gollum.nazgul.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070405054107.GB7660@gollum.nazgul.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 05, 2007 at 07:41:07AM +0200, Marcus Glocker wrote:

> On Wed, Apr 04, 2007 at 10:08:13PM +0200, Michael Buesch wrote:
> 
> > I, Michael Buesch, am one of the maintainers of the GPL'd Linux
> > wireless LAN driver for the Broadcom chip (bcm43xx).
> > The Copyright holders of bcm43xx (which includes me) want to talk
> > to you, OpenBSD bcw developers, about possible GPL license and therefore
> > Copyright violations in your bcw driver.
> > 
> > We believe that you might have directly copied code
> > out of bcm43xx (licensed under GPL v2), without our explicit permission,
> > into bcw (licensed under BSD license).
> > There are implementation details in bcm43xx that appear exactly
> > the same in bcw. These implementation details clearly don't come
> > from the open specifications at bcm-specs.sipsolutions.net
> > or bcm-v4.sipsolutions.net.
> > 
> > We have always made and still make a great effort to keep our code clean
> > of any Copyright issues (cleanroom design). Please make sure you also do.
> > 
> > A few examples follow of what we think might be GPL violations.
> > This list is far from being complete.
> 
> Michael,
> 
> I am aware that right now a lot of lines in bcw are written in a way
> with a too close eye to your code.  That's out of question, and I have
> already informed Theo about that fact before you got in touch with
> us.
> 
> I wanted to make some quick progress (maybe too quick), and rewrite
> the functions in question after seeing some first success, e.g.
> receivment of first frames, which isn't the case right now.  But
> still, the specs for some functions are so strict, writing tons
> of registers in a strict order, some parts will still look similar.
> 
> The last thing I want is to start a license war with you guys,
> and also I don't want to harm OpenBSD further with this issue.
> And of course we want to solve that license issue ASAP.
> 
> So, I am suggestion three options:
> 
> 	1. You give me some time and I try to rewrite the code
> 	   in question.  We keep in touch, and maybe we can split
> 	   up both parties in freedom afterwards.
> 
> 	2. Same as option one, but if my time resources keep
> 	   shrinking like they do right now, spending weekends
> 	   in the office and I can't fix up the driver soon,
> 	   I'll drop the driver.
> 
> 	3. We don't come to a point and I'll plain drop the driver
> 	   directly, very soon.
> 
> Waiting for your reaction.
> 
> Regards,
> Marcus

OK, I decided to go for option 3:

***

From: Marcus Glocker <mglocker@cvs.openbsd.org>                                 
To: source-changes@cvs.openbsd.org                                              
Date: Thu, 5 Apr 2007 10:25:25 -0600 (MDT)                                      
Subject: CVS: cvs.openbsd.org: src                                              
  
CVSROOT:        /cvs
Module name:    src
Changes by:     mglocker@cvs.openbsd.org        2007/04/05 10:25:25
  
Modified files:
        sys/conf       : files
        sys/dev/pci    : files.pci
        sys/dev/cardbus: files.cardbus
Removed files:
        share/man/man4 : bcw.4
        sys/dev/ic     : bcw.c bcwreg.h bcwvar.h
        sys/dev/pci    : if_bcw_pci.c
        sys/dev/cardbus: if_bcw_cardbus.c
  
Log message:
After been attacked by Michael Buesch <mb@bu3sch.de> because we initially
were using some of their routines in the bcw driver, I decided to stop
working on it.  To avoid any further license chit chat I plain drop the
driver.

***

Happy now?

It's a pleasure to see how the OpenSource community stands together,
and starting public wars instead of talking directly to the people
involved.

Marcus

-- 
Marcus Glocker, marcus@nazgul.ch, mglocker@openbsd.org
