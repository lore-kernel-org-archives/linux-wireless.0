Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51271 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbYFENfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 09:35:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: b43 opensource firmware for monitor mode
Date: Thu, 5 Jun 2008 15:35:13 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200806041716.53771.mb@bu3sch.de> <1212633988.26365.42.camel@dv>
In-Reply-To: <1212633988.26365.42.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806051535.14340.mb@bu3sch.de> (sfid-20080605_153543_940569_D8221F4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 June 2008 04:46:28 Pavel Roskin wrote:
> On Wed, 2008-06-04 at 17:16 +0200, Michael Buesch wrote:
> > Release early, release often.
> > Here's the first testing release of the b43 opensource firmware.
> > http://bu3sch.de/misc/b43-openfw-20080604.tar.bz2
> > 
> > Currently only the receive path is partially implemented. So that
> > means we can only run it in monitor mode for now. This firmware is
> > able to receive packets and push them without special handling (like
> > decrypting) to the driver.
> > There are lots of bugs, of course. Sometimes the PLCP header is corrupted.
> > That will result in a kernel driver warning in xmit.c.
> > 
> > This firmware does _only_ work on wireless core revisions 5, 6, 7, 8 or 10.
> 
> That's great news!  Having distributable firmware would simplify
> installation, placing b43 to the same league as Intel devices.  But
> having free firmware would be unique to Broadcom card and extremely
> attractive for research in wireless communications and development of
> novel devices using non-standard protocol extensions.
> 
> As a short term goal, maybe bcm4328 could be dumbed down to work with
> b43?
> 
> I've tried it with bcm4318 first, and it hung hard on module load.  Even
> Alt-SysRq would not work.  It turns out it was revision 9 missing in
> your list.
> 
> Then I tries a bcm4306 device with rev 5 core.  The module loaded.  I
> brought it up in managed mode first.  Scanning didn't work.  I brought
> the device down and set monitor mode.  But the system hung when I tried
> to bring the interface back up.

There shouldn't be a reason for a freeze. It might crash, yes, but it always
prints out useful messages first for me.

-- 
Greetings Michael.
