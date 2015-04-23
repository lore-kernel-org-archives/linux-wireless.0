Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:37357 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426AbbDWInX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2015 04:43:23 -0400
Date: Thu, 23 Apr 2015 18:43:09 +1000
From: James Cameron <quozl@laptop.org>
To: Florian Achleitner <flo@fopen.at>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>
Subject: Re: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Message-ID: <20150423084309.GL2147@us.netrek.org> (sfid-20150423_104329_398089_2F11E403)
References: <3169170.GKjfvNuGRf@r90b40zn>
 <1675638.uTIoPdU2hg@r90b40zn>
 <5FF020A1CFFEEC49BD1E09530C4FF5951B16EB7A39@SC-VEXCH1.marvell.com>
 <2079721.JMnuuxDd1J@r90b40zn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2079721.JMnuuxDd1J@r90b40zn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 23, 2015 at 10:33:02AM +0200, Florian Achleitner wrote:
> On Friday 17 April 2015 02:45:02 Amitkumar Karwar wrote:
> > Known firmware issues are command timeout and wakeup failure. They
> > are not specific to SDIO. As Avinash mentioned earlier, we need to
> > check CONFIG_MMC_DEBUG enbled dmesg logs for "write iomem (1)
> > failed: -110" issue.
> 
> Thx.
> A kernel with CONFIG_MMC_DEBUG is running since 6 days on 4 devices,
> but nothing valuable captured yet. Unfortunately, it looks like the
> debugging code modifies the timing, such that the failure doesn't
> occur..

Yes, I've seen something similar last year, when I began to add
instrumentation code the problems became less reproducible.

So in my situation either there was a race condition with the
firmware, or a signal integrity problem on the SDIO.

I wasn't able to go into full signal integrity work at the time.

I also have rather hazy memory of which particular problem I was
working on.  ;-)

Perhaps you might review the effects of CONFIG_MMC_DEBUG and remove
some of it?

-- 
James Cameron
http://quozl.linux.org.au/
