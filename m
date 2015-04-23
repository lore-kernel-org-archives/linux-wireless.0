Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18976 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756379AbbDWJse convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2015 05:48:34 -0400
From: Avinash Patil <patila@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>,
	Florian Achleitner <flo@fopen.at>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>
Date: Thu, 23 Apr 2015 02:48:05 -0700
Subject: RE: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC6A9F6836F5@SC-VEXCH2.marvell.com> (sfid-20150423_114837_828770_BE994FC9)
References: <3169170.GKjfvNuGRf@r90b40zn> <1675638.uTIoPdU2hg@r90b40zn>
 <5FF020A1CFFEEC49BD1E09530C4FF5951B16EB7A39@SC-VEXCH1.marvell.com>
 <2079721.JMnuuxDd1J@r90b40zn> <20150423084309.GL2147@us.netrek.org>
In-Reply-To: <20150423084309.GL2147@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Florian,

> -----Original Message-----
> From: quozl@laptop.org [mailto:quozl@laptop.org]
> Sent: Thursday, April 23, 2015 2:13 PM
> To: Florian Achleitner
> Cc: Amitkumar Karwar; Avinash Patil; linux-wireless@vger.kernel.org; Maithili
> Hinge
> Subject: Re: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
> 
> On Thu, Apr 23, 2015 at 10:33:02AM +0200, Florian Achleitner wrote:
> > On Friday 17 April 2015 02:45:02 Amitkumar Karwar wrote:
> > > Known firmware issues are command timeout and wakeup failure. They
> > > are not specific to SDIO. As Avinash mentioned earlier, we need to
> > > check CONFIG_MMC_DEBUG enbled dmesg logs for "write iomem (1)
> > > failed: -110" issue.
> >
> > Thx.
> > A kernel with CONFIG_MMC_DEBUG is running since 6 days on 4 devices,
> > but nothing valuable captured yet. Unfortunately, it looks like the
> > debugging code modifies the timing, such that the failure doesn't
> > occur..
> 
> Yes, I've seen something similar last year, when I began to add
> instrumentation code the problems became less reproducible.
> 
> So in my situation either there was a race condition with the firmware, or a
> signal integrity problem on the SDIO.
> 
> I wasn't able to go into full signal integrity work at the time.
> 
> I also have rather hazy memory of which particular problem I was working on.
> ;-)
> 
> Perhaps you might review the effects of CONFIG_MMC_DEBUG and remove some of
> it?

As James suggested could you please check if reducing MMC_DEBUG frequency and printks only at error conditions helps?

> --
> James Cameron
> http://quozl.linux.org.au/
