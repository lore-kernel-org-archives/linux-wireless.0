Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45723 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbYDEDG3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 23:06:29 -0400
Subject: Re: [PATCH RFT] b43: We need lots of regression testing
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200804041612.18840.mb@bu3sch.de>
References: <200804041612.18840.mb@bu3sch.de>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 23:06:27 -0400
Message-Id: <1207364787.2115.16.camel@dv> (sfid-20080405_040635_154207_9EE40F90)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-04-04 at 16:12 +0200, Michael Buesch wrote:
> Hi b43 users,
> 
> Please be so kind to run lots of regression tests on the following
> patch. This patch is supposed to make the LO calibration a _lot_ more
> lightweight and avoid a long MAC-disable period every 120 seconds.
> 
> We need a lot of regression testing with this patch on lots of different
> devices to make sure we don't introduce regressions.
> 
> I tested this on a 4306 and a 4318 card. So far it seems to work great
> on these cards.

Tested on this:

b43-phy0: Broadcom 4306 WLAN found
b43-phy0 debug: Found PHY: Analog 2, Type 2, Revision 2
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
phy0: Selected rate control algorithm 'pid'
Broadcom 43xx driver loaded [ Features: PMLR, Firmware-ID: FW13 ]

It's actually Fedora development kernel 2.6.25-0.195.rc8.git1.fc9.i686
with patched compat-wireless installed.

It's working better than I could possibly expect.  The range is on the
par with another laptop with ipw3945 running Linux or Windows XP.  It's
working through 4 walls and 30 meters on top of that.  I understand that
there are many random factors involved, but my impression is very
positive.  Basically, it's good enough to go outside with the laptop
without having an AP installed near a window.  I haven't seen any
significant interruptions in the connection.

Unfortunately, I hit that nasty circular lock dependency bug (already
discussed in another thread) when I killed wpa_supplicant to try another
AP.  The CPU utilization went to 100%, but the driver kept working.

Another unrelated bug (sorry, testing often finds unrelated bugs) is
that scanning with specific ESSID was returning non-matching APs.  I
mean "iwlist wlan0 scan my_essid", which would still report many
different ESSIDs.  It's inconvenient when the driver can sense 22 APs at
once :)

I'll try to get 4318 tested over the weekend.

-- 
Regards,
Pavel Roskin
