Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53848 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405AbZAOPil (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 10:38:41 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [b43] opensource firmware
Date: Thu, 15 Jan 2009 16:37:57 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Lorenzo Nava <navalorenx@gmail.com>, kyle@infradead.org,
	linux-wireless@vger.kernel.org
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com> <1231965922.20309.0.camel@johannes>
In-Reply-To: <1231965922.20309.0.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901151637.58196.mb@bu3sch.de> (sfid-20090115_163845_263529_359196B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 January 2009 21:45:22 Johannes Berg wrote:
> 
> > Initvals and new firmware version can be found at http://www.ing.unibs.it/openfwwf
> 
> I suggest that before this is packaged, we change it so b43 can
> recognise it and automatically disable qos and hwcrypto.

Yes, please introduce a feature-bitfield at some location in SHM that's unused
by the proprietary firmware. This bitfields would contain a bit for QoS and
a bit for hwcrypto.
Also change your firmware so the driver detects it as open-source firmware.
I think that's done by writing 0xFFFF to the date/time field in SHM. I don't
quite remember, but it's something like that.
Note that this might mean that the firmware watchdog in the driver will trigger,
as that's enabled by the open-source-firmware-flag. We might want to temporarly
disable the watchdog in the driver for the time being.

-- 
Greetings, Michael.
