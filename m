Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45252 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbYDFFqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2008 01:46:51 -0400
Subject: Re: [PATCH RFT] b43: We need lots of regression testing
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <1207364787.2115.16.camel@dv>
References: <200804041612.18840.mb@bu3sch.de>  <1207364787.2115.16.camel@dv>
Content-Type: text/plain
Date: Sun, 06 Apr 2008 01:46:49 -0400
Message-Id: <1207460809.7146.73.camel@dv> (sfid-20080406_064657_255142_01FD636B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-04-04 at 23:06 -0400, Pavel Roskin wrote:

> I'll try to get 4318 tested over the weekend.

It's just as good as bcm4306.

b43-phy0: Broadcom 4318 WLAN found
b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 8

It was the same laptop in the same place, and I could even go a couple
of steps further than with bcm4306.  It's a place with 22 APs in range,
and the AP I was connecting to is installed in a brick building away
from any windows.  Yet I could maintain connection at the far end of the
paring lot nearby.

I realize that the unpatched drive could probably perform as well.  But
I wanted to use this opportunity to test the driver and the patch at
once in some real life conditions, and the results are great!

Another thing I noticed today is that the quality next to the AP is
normally from 65/100 to 75/100.  But sometimes it jumps to a higher
number momentarily, up to 130/100.  Yet I don't see corresponding
changes in the signal and noise when it happens.  Signal level is
jumping randomly from -55 dBm to -15 dBm, and noise level is always -72
dBm (rarely -71 dBm).

When at the place when the connection breaks, the quality is 30/100,
the signal level is -84 dBm and the noise level is still -72 dBm.

Perhaps the quality could be calibrated so that 30 becomes 0 and 70
becomes 100 (and we should never get quality over 100).  The noise level
is probably too high.  And the signal jumping 40 dBm without me even
touching anything may indicate that the driver probably fails to make
some adjustments in the signal value.

-- 
Regards,
Pavel Roskin
