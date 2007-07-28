Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48895
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbXG1XEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2007 19:04:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: bcm43xx-mac80211: a fix for the shared interrupt problem
Date: Sun, 29 Jul 2007 01:03:49 +0200
Cc: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
References: <46aab9a4.pmEWFfaWaaFDLvZd%Larry.Finger@lwfinger.net> <200707281848.02554.mb@bu3sch.de> <46ABACC1.1020107@lwfinger.net>
In-Reply-To: <46ABACC1.1020107@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707290103.50077.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 28 July 2007 22:53:21 Larry Finger wrote:
> Michael Buesch wrote:
> > 
> > That's not the right bugfix.
> > If the interface is not STAT_STARTED, it should _not_ generate IRQs.
> > The bug is elsewhere in the init routines.
> > Please find out which IRQ bits are generated for these spurious IRQs.
> > 
> 
> I trapped those entries where the interface was not STAT_STARTED and got 2 such interrupts, each 
> with the IRQ bits set to 0x00000001 (READY). They occur between the "30-bit DMA initialized" and the 
> "Wireless interface started" messages.

Ok, seems like we are missing some dummy reads to drain
this IRQ. I'll look at this tomorrow.
Thanks for tracking this down.

-- 
Greetings Michael.
