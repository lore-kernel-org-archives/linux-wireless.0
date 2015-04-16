Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29207 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbbDPLLv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 07:11:51 -0400
From: Avinash Patil <patila@marvell.com>
To: Florian Achleitner <flo@fopen.at>, James Cameron <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Date: Thu, 16 Apr 2015 04:11:23 -0700
Subject: RE: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC6A8928261D@SC-VEXCH2.marvell.com> (sfid-20150416_131154_839543_C3B9339A)
References: <3169170.GKjfvNuGRf@r90b40zn>
 <20150416101913.GA26748@us.netrek.org> <3204550.d2SRA167I8@r90b40zn>
In-Reply-To: <3204550.d2SRA167I8@r90b40zn>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Florian,


> -----Original Message-----
> From: Florian Achleitner [mailto:flo@fopen.at]
> Sent: Thursday, April 16, 2015 4:13 PM
> To: James Cameron
> Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Avinash Patil; Maithili
> Hinge
> Subject: Re: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
> 
> On Thursday 16 April 2015 20:19:13 James Cameron wrote:
> > On Thu, Apr 16, 2015 at 11:10:02AM +0200, Florian Achleitner wrote:
> > > Is the necessity of frequent hardware resets a commonly known issue
> > > with this chip/firmware? Anybody else experiencing these?
> >
> > Yes, but how frequent?
> 
> Depends on the specific hardware. Averages follow.
> 
> >
> > > Currently, we see three different scenarios. One of them is
> > > currently not answered by reset. Refer to the upcoming patch.
> > >
> > > (1)  mwifiex_cmd_timeout_func: Timeout cmd .. Ok, after reset.
> >
> > See this a lot during heavy testing.
> 
> Also a lot, maybe once a day in low load.

Can this be related to SDHCI or MMC host controller?
Could you please collect logs with CONFIG_MMC_DEBUG enbled?

> >
> > > (2)  Firmware wakeup failed.. Ok, after reset.
> >
> > Never see this.
> 
> Once a day.
> 
> >
> > > (3) DNLD_CMD: host to card failed. No reset triggered. See patch.
> >
> > Very rarely see this.
> 
> Also very rarely. Once a week, probably.
> 
> >
> > However, our experience may not be comparable; we are using 8787 with
> > a 3.5 kernel, because we haven't the resources to use a later kernel
> > or get backports working.
> >
> > Also, we use WOL (wake on lan) heavily; frequent automatic suspends,
> > with a GPIO wakeup in addition to the SDHCI.
> 
> We don't use WOL or suspends.
> 
> Regards,
> Florian

