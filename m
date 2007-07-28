Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:47649 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756228AbXG1Uxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2007 16:53:33 -0400
Message-ID: <46ABACC1.1020107@lwfinger.net>
Date: Sat, 28 Jul 2007 15:53:21 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
Subject: Re: bcm43xx-mac80211: a fix for the shared interrupt problem
References: <46aab9a4.pmEWFfaWaaFDLvZd%Larry.Finger@lwfinger.net> <200707281848.02554.mb@bu3sch.de>
In-Reply-To: <200707281848.02554.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> That's not the right bugfix.
> If the interface is not STAT_STARTED, it should _not_ generate IRQs.
> The bug is elsewhere in the init routines.
> Please find out which IRQ bits are generated for these spurious IRQs.
> 

I trapped those entries where the interface was not STAT_STARTED and got 2 such interrupts, each 
with the IRQ bits set to 0x00000001 (READY). They occur between the "30-bit DMA initialized" and the 
"Wireless interface started" messages.

Larry

