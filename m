Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38372
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbXBKQDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 11:03:33 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
Date: Sun, 11 Feb 2007 17:03:13 +0100
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <200702111514.04893.mb@bu3sch.de> <45CF3D51.5050302@lwfinger.net>
In-Reply-To: <45CF3D51.5050302@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702111703.13702.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 11 February 2007 16:59, Larry Finger wrote:
> Michael Buesch wrote:
> > On Sunday 11 February 2007 15:02, Rafael J. Wysocki wrote:
> >> PM: Removing info for No Bus:0000:30:00.0
> >> bcm43xx: IRQ_READY timeout
> >> bcm43xx: core_up for active 802.11 core failed (-19)
> > 
> > I never tried suspend to disk with the driver.
> 
> This implies that suspend to RAM works. Is that true?

No.

> > Larry, an idea why the microcode doesn't respond?
> 
> Is this code snippet supposed to keep the firmware loaded when the system is suspended?

Well, eh, no. Don't confuse suspend-to-ram with suspend-to-disk.
On suspend-to-disk the kernel is (mostly) reloaded as usual.
Just userspace is restored.
So the driver enters through the probe routine on resume from disk.

-- 
Greetings Michael.
