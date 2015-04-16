Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fopen.at ([151.236.7.194]:54190 "EHLO fopen.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327AbbDPNTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 09:19:30 -0400
From: Florian Achleitner <flo@fopen.at>
To: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>
Subject: Re: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Date: Thu, 16 Apr 2015 15:19:27 +0200
Message-ID: <2293982.N26UvI80V5@r90b40zn> (sfid-20150416_151936_951604_D5B6CD3F)
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951B16EB768F@SC-VEXCH1.marvell.com>
References: <3169170.GKjfvNuGRf@r90b40zn> <1743827.ElKz8IjFhJ@r90b40zn> <5FF020A1CFFEEC49BD1E09530C4FF5951B16EB768F@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Avanish, Amitkumar,

Thx for your ideas to check the mmc interface.

On Thursday 16 April 2015 04:21:50 Amitkumar Karwar wrote:
> "host_to_card, write iomem (1) failed: -110" error indicates that MMC
> subsystem's sdio_writesb() API failed with timeout error.
> 
> WLAN driver or FW has nothing to do with this. This seems to be your MMC
> host controller/hardware problem. Adding a recovering mechanism in WLAN
> driver doesn't look correct here. We should rather need to root cause the
> problem. Our "DNLD_CMD: host to card failed" error message is displayed for
> other failures also. As explained earlier, if it's write data port not
> available problem. It will automatically resolve after sometimes.
> Triggering reset would be unnecessary for that case.

I will try to figure out whether the root cause is the MMC interface.
Probably in this case, the reset actually recovers from a bug in the mmc 
driver.

> 
> Regards,
> Amitkumar

Regards,
Florian

