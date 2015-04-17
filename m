Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23698 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932457AbbDQJpK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 05:45:10 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Florian Achleitner <achleitner.florian@fronius.com>
CC: Avinash Patil <patila@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>
Date: Fri, 17 Apr 2015 02:45:02 -0700
Subject: RE: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B16EB7A39@SC-VEXCH1.marvell.com> (sfid-20150417_114523_043893_B80F38C5)
References: <3169170.GKjfvNuGRf@r90b40zn>
 <5FF020A1CFFEEC49BD1E09530C4FF5951B16EB768F@SC-VEXCH1.marvell.com>
 <2293982.N26UvI80V5@r90b40zn> <1675638.uTIoPdU2hg@r90b40zn>
In-Reply-To: <1675638.uTIoPdU2hg@r90b40zn>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Florian,

> From: Florian Achleitner [mailto:achleitner.florian@fronius.com]
> Sent: Friday, April 17, 2015 2:00 PM
> To: Amitkumar Karwar
> Cc: Avinash Patil; linux-wireless@vger.kernel.org; Maithili Hinge
> Subject: Re: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
> 
> On Thursday 16 April 2015 15:19:27 Florian Achleitner wrote:
> > I will try to figure out whether the root cause is the MMC interface.
> > Probably in this case, the reset actually recovers from a bug in the
> > mmc driver.
> 
> Anyways, we have a virtually identical hardware with a Marvell SD8688
> based wireless module, which uses the libertas driver. Running kernel
> 3.10.41 we have no problems for 50 days.
> 
> Running the same kernel with mwifiex with the SD8788 we see a freeze
> which requires a hw-reset within about a day. Similar to the most recent
> kernel.
> 
> Are there known sdio issues with SD8788?
> Will try to get useful information from the mmc system..

Known firmware issues are command timeout and wakeup failure. They are not specific to SDIO. As Avinash mentioned earlier, we need to check CONFIG_MMC_DEBUG enbled dmesg logs for "write iomem (1) failed: -110" issue.

Regards,
Amitkumar

