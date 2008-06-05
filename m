Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:52206 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYFECqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 22:46:35 -0400
Subject: Re: b43 opensource firmware for monitor mode
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200806041716.53771.mb@bu3sch.de>
References: <200806041716.53771.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 22:46:28 -0400
Message-Id: <1212633988.26365.42.camel@dv> (sfid-20080605_044639_632025_A19EA443)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-04 at 17:16 +0200, Michael Buesch wrote:
> Release early, release often.
> Here's the first testing release of the b43 opensource firmware.
> http://bu3sch.de/misc/b43-openfw-20080604.tar.bz2
> 
> Currently only the receive path is partially implemented. So that
> means we can only run it in monitor mode for now. This firmware is
> able to receive packets and push them without special handling (like
> decrypting) to the driver.
> There are lots of bugs, of course. Sometimes the PLCP header is corrupted.
> That will result in a kernel driver warning in xmit.c.
> 
> This firmware does _only_ work on wireless core revisions 5, 6, 7, 8 or 10.

That's great news!  Having distributable firmware would simplify
installation, placing b43 to the same league as Intel devices.  But
having free firmware would be unique to Broadcom card and extremely
attractive for research in wireless communications and development of
novel devices using non-standard protocol extensions.

As a short term goal, maybe bcm4328 could be dumbed down to work with
b43?

I've tried it with bcm4318 first, and it hung hard on module load.  Even
Alt-SysRq would not work.  It turns out it was revision 9 missing in
your list.

Then I tries a bcm4306 device with rev 5 core.  The module loaded.  I
brought it up in managed mode first.  Scanning didn't work.  I brought
the device down and set monitor mode.  But the system hung when I tried
to bring the interface back up.

Anyway, I'm glad to see progress in that direction.

-- 
Regards,
Pavel Roskin
