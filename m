Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49368 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757856AbXKOTtT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 14:49:19 -0500
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Will Dyson <will.dyson@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Florian Lohoff <flo@rfc822.org>,
	Marcus Better <marcus@better.se>,
	linux-wireless@vger.kernel.org,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>
In-Reply-To: <200711152058.40520.IvDoorn@gmail.com>
References: <20071111102315.GC10486@paradigm.rfc822.org>
	 <8e6f94720711141840g7346f4eak577477d735b72f39@mail.gmail.com>
	 <1195121518.28648.46.camel@localhost>
	 <200711152058.40520.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 20:48:56 +0100
Message-Id: <1195156136.28648.84.camel@localhost> (sfid-20071115_194922_591731_D1C4F4B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2007-11-15 at 20:58 +0100, Ivo van Doorn wrote:
> 
> Perhaps we should test if clearing the ENTRY_TXD_ACK unconditionally
> for cts and rts frames would help. (patch located at the bottom).
> In fact I wonder if clearing that flag would fix the rt61pci to run txdone
> for all frames (opposed to skipping an occasional entry).

Hm, I would think we actually should *set* the flag for rts frames,
cause we expected them to be acked by cts, right? IIRC, this actually is
what the legacy driver does.

Concerning the rt61 problem, I've done an experiment: I changed the
code to drop out of the interrupt handler on every second interrupt
without doing anything. That way, the driver doesn't execute the txdone
logic for some txdone interrupts. This change triggered the missing tx
report messages. So the rt61 hardware probably proceeds to the next
entry after the interrupt is handled by the host. Question now is
whether it is possible that we actually miss an interrupt? This would be
an explanation for the missing tx status reports. I plan to have a
closer look at interrupt handling in the kernel to see whether I can
find something.

Mattias

