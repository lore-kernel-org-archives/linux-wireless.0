Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46011 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab0CVIiD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 04:38:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Calvin Walton <calvin.walton@gmail.com>
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
Date: Mon, 22 Mar 2010 09:37:54 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <1269239303.12836.17.camel@ayu>
In-Reply-To: <1269239303.12836.17.camel@ayu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003220937.55133.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 March 2010 07:28:23 Calvin Walton wrote:
> Hi,
> 
> On Sat, 2010-03-20 at 19:14 -0500, Larry Finger wrote:
> Some recent BCM43XX devices lack an on-board SPROM. The pertinent data
> > from the SPROM could be included in the kernel; however, this presents
> > a problem in the generation of a unique, reproducible MAC address. The
> > solution has been to create a utility that generates a virtual SPROM
> > image with a random MAC address. This image is stored in the firmware
> > area, and loaded using the asyncronous firmware load facility.
> 
> I'm curious, how would this firmware-loading scheme deal with having
> multiple cards of this type installed? This seems like an unusual
> situation, but it looks like this patch will cause all of the cards to
> start up with the same MAC address due to the fixed filename.
> 
> Instead of using a firmware file to load in the MAC address, might it be
> possible to move the persistent MAC setting to a simple udev rule which
> generates a persistent MAC address, saves it, then sets it each boot
> using a command like "ip link set wlan0 address XX:XX:XX:XX:XX:XX" ?
> 
> This would remove the need to have this "fake" firmware file available
> at boot, provided that the driver can handle leaving the address
> unconfigured until userspace gets around to setting it. As well, it
> could be written to work with multiple cards easily, saving a different
> MAC for each.
> 
> Some thoughts for your consideration,
> 

I think this actually is a very good idea.
This way we could live without a user-supplied sprom image, which I would _really_
prefer. 

-- 
Greetings, Michael.
