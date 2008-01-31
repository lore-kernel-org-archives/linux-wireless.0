Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:41919 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbYAaUOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 15:14:12 -0500
Received: by nf-out-0910.google.com with SMTP id g13so161997nfb.21
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2008 12:14:10 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Silent crash witk 2-6.24-rc8-git4
Date: Thu, 31 Jan 2008 20:13:31 +0000
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <200801220603.02986.chris2553@googlemail.com> <200801231642.58782.chris2553@googlemail.com> <20080123190207.GB3129@tuxdriver.com>
In-Reply-To: <20080123190207.GB3129@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801312013.31220.chris2553@googlemail.com> (sfid-20080131_201435_061839_CDB08DB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wednesday 23 January 2008, John W. Linville wrote:
> On Wed, Jan 23, 2008 at 04:42:58PM +0000, Chris Clayton wrote:
> > On Wednesday 23 January 2008, Chris Clayton wrote:
> > > Hi again.
> > > 
> > > On Tuesday 22 January 2008, Chris Clayton wrote:
> > > > Hi,
> > 
> > and here's another, slightly more complete, one, this time from 2.6.24-rc8-git6
> > (the none I sent earlier was from -git4, by the way)
> > 
> > Call Trace:
> > [<c011440a>] __update_rq_clock+0x1a/0xf0
> > [<e08ff59d>] rt2x00lib_txdone+0x9d/0xd0 [rt2x00lib]
> > [<e0909573>] rt61pci_txdone+0x153/0x1f0 [rt61pci]
> > [<e09096ad>] rt61pci_interrupt+0x9d/0xb0 [rt61pci]
> 
> I suspect this could relate to this commit:
> 
> commit 62bc060b8ed5fcdafd87da5ab17bdd59a39ebcc9
> Author: Mattias Nissler <mattias.nissler@gmx.de>
> Date:   Mon Nov 12 15:03:12 2007 +0100
> 
>     rt2x00: Allow rt61 to catch up after a missing tx report
> 
> Could you revert that patch, rebuild, and try to recreate the problem?

As you will have seen, Matthias doubted whether his patch would be at the root
of the problem I am seeing. I noticed you posted some patches earlier this week.
Would any combination of those be likely to fix the bug, please? The patch
http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/upstream/0001-rt61pci-fix-up-merge-damage.patch
applies cleanly to 2.6.24 but the build fails :(

It seems that it may take a little while to get to the bottom of this bug. Should
I raise an incident on bugzilla?

Thanks

Chris
> 
> Thanks!
> 
> John



-- 
Beauty is in the eye of the beerholder.
