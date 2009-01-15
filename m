Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60510 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758472AbZAOQK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 11:10:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [b43] opensource firmware
Date: Thu, 15 Jan 2009 17:09:49 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>, kyle@infradead.org,
	linux-wireless@vger.kernel.org
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com> <200901151637.58196.mb@bu3sch.de> <496F5D4F.3020805@lwfinger.net>
In-Reply-To: <496F5D4F.3020805@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901151709.49811.mb@bu3sch.de> (sfid-20090115_171036_752341_709429F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 January 2009 16:59:11 Larry Finger wrote:
> Michael Buesch wrote:
> > Yes, please introduce a feature-bitfield at some location in SHM that's unused
> > by the proprietary firmware. This bitfields would contain a bit for QoS and
> > a bit for hwcrypto.
> > Also change your firmware so the driver detects it as open-source firmware.
> > I think that's done by writing 0xFFFF to the date/time field in SHM. I don't
> > quite remember, but it's something like that.
> > Note that this might mean that the firmware watchdog in the driver will trigger,
> > as that's enabled by the open-source-firmware-flag. We might want to temporarly
> > disable the watchdog in the driver for the time being.
> 
> I like the idea of encoding the capabilities in the firmware as it
> would be a self-documenting method as the firmware evolves.
> 
> Is using the Broadcom names for the firmware the best course of
> action? What if the opensource firmware files were named something
> like "os-ucode5.fw", etc. and b43 were coded to check for those files
> first? It would then fall back to the standard firmware if the
> opensource version is not found.

Already implemented here:
http://bu3sch.de/patches/wireless-testing/20081227-1821/patches/008-b43-probe-open-fw.patch
I just need to fix a leak in an error path before pushing that upstream.

-- 
Greetings, Michael.
