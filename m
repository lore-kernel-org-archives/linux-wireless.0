Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59302 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbZAURhL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 12:37:11 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: [b43] opensource firmware
Date: Wed, 21 Jan 2009 18:36:03 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>, kyle@infradead.org,
	linux-wireless@vger.kernel.org
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com> <200901161612.24288.mb@bu3sch.de> <FBC507F3-1CD3-4AD7-9A6D-4D61A5B63DF0@ing.unibs.it>
In-Reply-To: <FBC507F3-1CD3-4AD7-9A6D-4D61A5B63DF0@ing.unibs.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901211836.04281.mb@bu3sch.de> (sfid-20090121_183716_932003_B7F08D78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 January 2009 18:29:40 Francesco Gringoli wrote:
> Hello everyone,
> 
> we just made available a new opensource firmware version, download at http://www.ing.unibs.it/openfwwf
> 
> New features:
> - initvals source code added, initvals files are encoded by make process
> - firmware is now recognized as opensource, though still as version  
> 351 (old format). Firmware's date switched to FFFF
> - watchdog implemented

Note that the debug-IRQ feature is now also available to you.
It enables you to panic, dump SHM, dump regs and print a marker message
from within the firmware. See my openfw repository and handle_irq_ucode_debug() in b43 for details.
Note that the debug-IRQ is synchronous, so it will disturb MAC functionality.
But you only want to use it for debugging anyway. And for debugging it is _very_ convenient
to be able to issue printks and memory dumps from within the firmware code.

-- 
Greetings, Michael.
