Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34701 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbZAPPNR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 10:13:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: [b43] opensource firmware
Date: Fri, 16 Jan 2009 16:12:23 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>, kyle@infradead.org,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com> <496F5D4F.3020805@lwfinger.net> <65BB63A7-75ED-464D-AD81-E34F3AD560BE@ing.unibs.it>
In-Reply-To: <65BB63A7-75ED-464D-AD81-E34F3AD560BE@ing.unibs.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901161612.24288.mb@bu3sch.de> (sfid-20090116_161323_579607_A66C859A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 January 2009 00:01:41 Francesco Gringoli wrote:
> On Jan 15, 2009, at 4:59 PM, Larry Finger wrote:
> 
> > Michael Buesch wrote:
> >> Yes, please introduce a feature-bitfield at some location in SHM  
> >> that's unused
> >> by the proprietary firmware. This bitfields would contain a bit for  
> >> QoS and
> >> a bit for hwcrypto.
> >> Also change your firmware so the driver detects it as open-source  
> >> firmware.
> >> I think that's done by writing 0xFFFF to the date/time field in  
> >> SHM. I don't
> >> quite remember, but it's something like that.
> >> Note that this might mean that the firmware watchdog in the driver  
> >> will trigger,
> >> as that's enabled by the open-source-firmware-flag. We might want  
> >> to temporarly
> >> disable the watchdog in the driver for the time being.
> >
> > I like the idea of encoding the capabilities in the firmware as it
> > would be a self-documenting method as the firmware evolves.
> >
> > Is using the Broadcom names for the firmware the best course of
> > action? What if the opensource firmware files were named something
> > like "os-ucode5.fw", etc. and b43 were coded to check for those files
> > first? It would then fall back to the standard firmware if the
> > opensource version is not found.
> >
> > Larry
> It could be interesting to also not separate the initvalues in two  
> different files, everything could be coded in a single file. Never  
> understood why original init values are split in two files.

The normal initvalues have to be uploaded at init and the bandswitch init
values have to be uploaded on bandswitch. That's a different thing.
We currently implement bandswitch by re-initing, but that doesn't matter. We could
easily change that in future.
So don't put the initvals into one file.

> Michael: SHM(0x0014) (16bit) is not used by the open source firmware,  

Eh no. You need to find an offset that's not used by the PROPRIETARY firmware.

> A question: is the standard kernel aware that date set to FFFF  
> indicates an opensource firmware 

Yes.

-- 
Greetings, Michael.
