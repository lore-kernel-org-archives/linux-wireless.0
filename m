Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37611 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968441Ab0B0O73 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 09:59:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA  errors
Date: Sat, 27 Feb 2010 15:59:20 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <alpine.LFD.2.00.1002261337460.4513@localhost.localdomain> <alpine.LFD.2.00.1002261345300.4513@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002261345300.4513@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002271559.20531.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 February 2010 22:50:35 Linus Torvalds wrote:
> 
> On Fri, 26 Feb 2010, Linus Torvalds wrote:
> > 
> > so even if mmiotrace fixes it for others, it's not working for me.
> 
> Side note: In case this is timing-related: the machine in question is a 
> dual-core 1.3Ghz CPU (Core 2 Duo U1400). I think SMP has always been 
> enabled, I don't think I ever tried UP.
> 
> Also, in addition to the PIO fallback code, that particular mmiotrace test 
> was done with the "udelay(10)" added to the b43_write*() functions. So it 
> was even slower.
> 
> Maybe the bug only happens on slow machines (and then the udelay obviously 
> wouldn't help!),

I'm pretty sure it's triggered by some kind of BIOS background service.
Power saving or something like that. There must be some interference
that fucks up the memory link between machine->ssb->wireless.

However, did you add the udelay to b43_write()? Please try to add it
further down in the callchain into the lowlevel SSB read and write functions.
drivers/ssb/pci.c

I don't think it'll help at all, but it's worth a try.

-- 
Greetings, Michael.
