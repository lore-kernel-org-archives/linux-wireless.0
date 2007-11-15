Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:53848 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbXKOWcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 17:32:45 -0500
Received: by nf-out-0910.google.com with SMTP id g13so638787nfb
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2007 14:32:43 -0800 (PST)
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
Date: Thu, 15 Nov 2007 23:59:29 +0100
Cc: Will Dyson <will.dyson@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Florian Lohoff <flo@rfc822.org>,
	Marcus Better <marcus@better.se>,
	linux-wireless@vger.kernel.org,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>
References: <20071111102315.GC10486@paradigm.rfc822.org> <200711152058.40520.IvDoorn@gmail.com> <1195156136.28648.84.camel@localhost>
In-Reply-To: <1195156136.28648.84.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711152359.31416.IvDoorn@gmail.com> (sfid-20071115_223251_526673_A1D8D560)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Perhaps we should test if clearing the ENTRY_TXD_ACK unconditionally
> > for cts and rts frames would help. (patch located at the bottom).
> > In fact I wonder if clearing that flag would fix the rt61pci to run txdone
> > for all frames (opposed to skipping an occasional entry).
> 
> Hm, I would think we actually should *set* the flag for rts frames,
> cause we expected them to be acked by cts, right? IIRC, this actually is
> what the legacy driver does.

True we expect them to be acked, but we also set the RTS flag which
*could* mean that setting that flag tells the device to wait for the cts response.
So perhaps it is worth a shot to see if not setting the ACK flag actually
helps in the responsiveness.

> Concerning the rt61 problem, I've done an experiment: I changed the
> code to drop out of the interrupt handler on every second interrupt
> without doing anything. That way, the driver doesn't execute the txdone
> logic for some txdone interrupts. This change triggered the missing tx
> report messages. So the rt61 hardware probably proceeds to the next
> entry after the interrupt is handled by the host. Question now is
> whether it is possible that we actually miss an interrupt? This would be
> an explanation for the missing tx status reports. I plan to have a
> closer look at interrupt handling in the kernel to see whether I can
> find something.

Ivo
