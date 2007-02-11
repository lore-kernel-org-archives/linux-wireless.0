Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39890
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbXBKQRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 11:17:06 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
Date: Sun, 11 Feb 2007 17:16:51 +0100
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <45CF3D51.5050302@lwfinger.net> <200702111703.13702.mb@bu3sch.de>
In-Reply-To: <200702111703.13702.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702111716.51539.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 11 February 2007 17:03, Michael Buesch wrote:
> On Sunday 11 February 2007 16:59, Larry Finger wrote:
> > Michael Buesch wrote:
> > > On Sunday 11 February 2007 15:02, Rafael J. Wysocki wrote:
> > >> PM: Removing info for No Bus:0000:30:00.0
> > >> bcm43xx: IRQ_READY timeout
> > >> bcm43xx: core_up for active 802.11 core failed (-19)
> > > 
> > > I never tried suspend to disk with the driver.
> > 
> > This implies that suspend to RAM works. Is that true?
> 
> No.
> 
> > > Larry, an idea why the microcode doesn't respond?
> > 
> > Is this code snippet supposed to keep the firmware loaded when the system is suspended?
> 
> Well, eh, no. Don't confuse suspend-to-ram with suspend-to-disk.
> On suspend-to-disk the kernel is (mostly) reloaded as usual.
> Just userspace is restored.
> So the driver enters through the probe routine on resume from disk.

I've been told this is wrong.
Well, ok. Anyway. I don't think we need to re-request the fw,
as it's restored, too.

Can you try bcm43xx-d80211 from my tree? There it reinitializes the
device completely on resume. So it might work there.

-- 
Greetings Michael.
