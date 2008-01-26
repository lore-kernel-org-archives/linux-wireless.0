Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:3385 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbYAZUX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 15:23:57 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1110448fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2008 12:23:55 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: Silent crash witk 2-6.24-rc8-git4
Date: Sat, 26 Jan 2008 20:23:19 +0000
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <200801220603.02986.chris2553@googlemail.com> <200801240003.31666.chris2553@googlemail.com> <1201165422.7472.8.camel@localhost>
In-Reply-To: <1201165422.7472.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801262023.19918.chris2553@googlemail.com> (sfid-20080126_202402_005746_70A22CAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 January 2008, Mattias Nissler wrote:
> 
> On Thu, 2008-01-24 at 00:03 +0000, Chris Clayton wrote:
> > Thanks for the reply, John.
> > 
> > On Wednesday 23 January 2008, John W. Linville wrote:
> > > On Wed, Jan 23, 2008 at 04:42:58PM +0000, Chris Clayton wrote:
> > > > On Wednesday 23 January 2008, Chris Clayton wrote:
> > > > > Hi again.
> > > > > 
> > > > > On Tuesday 22 January 2008, Chris Clayton wrote:
> > > > > > Hi,
> > > > 
> > > > and here's another, slightly more complete, one, this time from 2.6.24-rc8-git6
> > > > (the none I sent earlier was from -git4, by the way)
> > > > 
> > > > Call Trace:
> > > > [<c011440a>] __update_rq_clock+0x1a/0xf0
> > > > [<e08ff59d>] rt2x00lib_txdone+0x9d/0xd0 [rt2x00lib]
> > > > [<e0909573>] rt61pci_txdone+0x153/0x1f0 [rt61pci]
> > > > [<e09096ad>] rt61pci_interrupt+0x9d/0xb0 [rt61pci]
> > > 
> > > I suspect this could relate to this commit:
> > > 
> > > commit 62bc060b8ed5fcdafd87da5ab17bdd59a39ebcc9
> > > Author: Mattias Nissler <mattias.nissler@gmx.de>
> > > Date:   Mon Nov 12 15:03:12 2007 +0100
> > > 
> > >     rt2x00: Allow rt61 to catch up after a missing tx report
> > > 
> > > Could you revert that patch, rebuild, and try to recreate the problem?
> > > 
> > 
> > I've reverted the patch by hand - the original patch on linux-wireless doesn't match the present state of the code
> > in rt61pci.c and I'm not a git user. I'm pretty sure I've got it right, however.
> > 
> > Problem now is that we are back where we were a few weeks ago because my wireless connection dies
> > almost immediately after I start the download and from dmesg I see:
> > 
> > phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 2.
> > Please file bug report to http://rt2x00.serialmonkey.com.
> 
> As the patches author, I'm not very surprised :-) The patch just adds
> additional processing that should have happened in a different call of
> the interrupt handler. I don't think it can be related at all to the
> trouble you're seeing.
> 
> When I find time, I'll try the Linus tree on my rt61 to see what
> happens.
> 

OK, thanks. I look forward to seeing how things go. In the meantime, I'll use the out-of-tree module from serialmonkey.

Chris
> Mattias
> 
> 



-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin
