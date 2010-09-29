Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:64614 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0I2Jug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 05:50:36 -0400
Subject: Re: [PATCH 0/2] wl1271: Packet aggregation optimizations
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285741684.11177.98.camel@wimaxnb.nmp.nokia.com>
References: <1285686464-8668-1-git-send-email-ido@wizery.com>
	 <1285741684.11177.98.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 12:50:23 +0300
Message-ID: <1285753823.11177.113.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 08:28 +0200, ext Juuso Oikarinen wrote:
> On Tue, 2010-09-28 at 17:07 +0200, ext Ido Yariv wrote:
> > The WL1271 HW supports sending and receiving multiple packets within
> > a single transaction. This can substantially reduce CPU usage and
> > increase network throughput.
> > 
> > The following patches add support for RX and TX packet aggregation.
> > An opportunistic approach was taken - all packets that are currently
> > available for sending/receiving are aggregated and transferred
> > in a single transaction.
> > 
> > The patches were tested on a Zoom2 platform (SDIO only).
> > 
> > Ido Yariv (2):
> >   wl1271: Support firmware RX packet aggregation
> >   wl1271: Support firmware TX packet aggregation
> > 
> 
> Thanks for these patches! 
> 
> We are testing them now.

I did some desktop-testing for these patches. For SDIO, I can see some
definite improvements in CPU usage during data transfers with these
patches despite the added memcpy operations.

However, the SPI is totally broken with these patches. I did some
debugging and noticed, that once the SPI transfers exceed 4500 bytes or
so, the hardware crashes.

Excerpt from syslog. I repeated this several times, and each time the
hardware went unresponsive after the larger transfer, like here:

[   44.847198] TX length:
1552                                                                                                                                       
[   44.876983] RX length:
272                                                                                                                                        
[   46.265014] TX length:
1552                                                                                                                                       
[   46.270416] RX length:
120                                                                                                                                        
[   46.270629] TX length:
3104                                                                                                                                       
[   46.274963] RX length:
120                                                                                                                                        
[   46.275177] TX length:
4656                                                                                                                                       
[   46.285339] wl1271: ERROR SPI read busy-word
timeout!                              

-Juuso

