Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65234 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2HPTer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 15:34:47 -0400
Received: by bkwj10 with SMTP id j10so1050559bkw.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2012 12:34:45 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: carl9170: Unintentional transmission in monitor mode?
Date: Thu, 16 Aug 2012 21:34:31 +0200
Cc: Marco Fonseca <marco@tampabay.rr.com>,
	linux-wireless@vger.kernel.org,
	"Chen, Stephen" <scchen@qca.qualcomm.com>
References: <20120809165434.GA13409@192.168.1.10> <201208092143.28506.chunkeey@googlemail.com> <1345144855.4665.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1345144855.4665.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201208162134.32152.chunkeey@googlemail.com> (sfid-20120816_213452_050595_D42C7EAF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, August 16, 2012 09:20:55 PM Johannes Berg wrote:
> On Thu, 2012-08-09 at 21:43 +0200, Christian Lamparter wrote:
> > On Thursday, August 09, 2012 06:54:34 PM Marco Fonseca wrote:
> > > Hello All,
> > > 
> > > I've noticed unexpected transmissions from the AR9170 while in monitor mode
> > > and using tcpdump (and sometimes without tcpdump running).  These
> > > transmissions degrade (pretty significantly) performance of other STA/AP on
> > > the channel (as seen by iperf going from 60mbit/s to almost nill).  As best I
> > > can tell these transmissions never coalesces into an actual frame in the air
> > > (at least not one I'm able to pick up with a second different adapter in
> > > monitor mode).
> > > 
> > > Are there any known reasons/bugs on this?  Is there anyway to completely
> > > silence the transmitter of the AR9170 while still allowing reception?
> > > 
> > yes. <http://www.spinics.net/lists/linux-wireless/msg88896.html>
> > 
> > a solution is described in:
> > <http://www.spinics.net/lists/linux-wireless/msg89279.html>
> > 
> > (iw dev wlanX set monitor none - if I'm not mistaken)
> 
> I've seen this before too -- what flag causes the issue, and why?
Well that would be:
FIF_OTHER_BSS or FIF_PROMISC_IN_BSS

either one of these will set following flags
for the hardware:

AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER
AR9170_MAC_SNIFFER_ENABLE_PROMISC

About the issue, I'm really can't tell w/o schematics
of the hardware. It could be that ACK_IN_SNIFFER is
more of a debug/test flag than a real feature?

(Anyway, I cc'd Stephen. Maybe he knows more)

Regards,
	Chr
