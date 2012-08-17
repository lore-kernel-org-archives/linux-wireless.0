Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:56290 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab2HQCaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 22:30:19 -0400
Date: Thu, 16 Aug 2012 22:30:16 -0400
From: Marco Fonseca <marco@tampabay.rr.com>
To: "Chen, Stephen" <scchen@qca.qualcomm.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: carl9170: Unintentional transmission in monitor mode?
Message-ID: <20120817023016.GA7823@192.168.1.10> (sfid-20120817_043058_581703_1B158658)
References: <20120809165434.GA13409@192.168.1.10>
 <201208092143.28506.chunkeey@googlemail.com>
 <1345144855.4665.3.camel@jlt3.sipsolutions.net>
 <201208162134.32152.chunkeey@googlemail.com>
 <124AAE9739743843BE54ED9463A8330D012EFF15@NASANEXD02D.na.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <124AAE9739743843BE54ED9463A8330D012EFF15@NASANEXD02D.na.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In my setup I had used a secondary sniffer in order to see what was going on.
I was able to reproduce the problem with a single ping with a payload of 2000
(less to look at in wireshark), but I was never able to capture a valid frame
from the AR9170.  I do know it was transmitting though, as I could see it on
the spectrum analyzer.  I just assumed whatever was going out wasn't a valid
frame...(?)

Marco


On Fri, Aug 17, 2012 at 02:03:00AM +0000, Chen, Stephen wrote:
> Can we tell what kind of unexpected frame are been transmitted? (Data frame or which kind of control frame?)
> That may give us a clue.
> 
> 
> Thank you.
> Stephen
> 
> -----Original Message-----
> From: Christian Lamparter [mailto:chunkeey@googlemail.com] 
> Sent: Friday, August 17, 2012 3:35 AM
> To: Johannes Berg
> Cc: Marco Fonseca; linux-wireless@vger.kernel.org; Chen, Stephen
> Subject: Re: carl9170: Unintentional transmission in monitor mode?
> 
> On Thursday, August 16, 2012 09:20:55 PM Johannes Berg wrote:
> > On Thu, 2012-08-09 at 21:43 +0200, Christian Lamparter wrote:
> > > On Thursday, August 09, 2012 06:54:34 PM Marco Fonseca wrote:
> > > > Hello All,
> > > > 
> > > > I've noticed unexpected transmissions from the AR9170 while in 
> > > > monitor mode and using tcpdump (and sometimes without tcpdump 
> > > > running).  These transmissions degrade (pretty significantly) 
> > > > performance of other STA/AP on the channel (as seen by iperf going 
> > > > from 60mbit/s to almost nill).  As best I can tell these 
> > > > transmissions never coalesces into an actual frame in the air (at 
> > > > least not one I'm able to pick up with a second different adapter in monitor mode).
> > > > 
> > > > Are there any known reasons/bugs on this?  Is there anyway to 
> > > > completely silence the transmitter of the AR9170 while still allowing reception?
> > > > 
> > > yes. <http://www.spinics.net/lists/linux-wireless/msg88896.html>
> > > 
> > > a solution is described in:
> > > <http://www.spinics.net/lists/linux-wireless/msg89279.html>
> > > 
> > > (iw dev wlanX set monitor none - if I'm not mistaken)
> > 
> > I've seen this before too -- what flag causes the issue, and why?
> Well that would be:
> FIF_OTHER_BSS or FIF_PROMISC_IN_BSS
> 
> either one of these will set following flags for the hardware:
> 
> AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER
> AR9170_MAC_SNIFFER_ENABLE_PROMISC
> 
> About the issue, I'm really can't tell w/o schematics of the hardware. It could be that ACK_IN_SNIFFER is more of a debug/test flag than a real feature?
> 
> (Anyway, I cc'd Stephen. Maybe he knows more)
> 
> Regards,
> 	Chr
