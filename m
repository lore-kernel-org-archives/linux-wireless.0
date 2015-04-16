Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20887 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753354AbbDPJbF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 05:31:05 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Florian Achleitner <flo@fopen.at>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Date: Thu, 16 Apr 2015 02:30:59 -0700
Subject: RE: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B16DFC5A9@SC-VEXCH1.marvell.com> (sfid-20150416_113114_532107_50E41E0F)
References: <3169170.GKjfvNuGRf@r90b40zn>
In-Reply-To: <3169170.GKjfvNuGRf@r90b40zn>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Florian,

> 
> Hi,
> 
> we are using a Marvell SD8787-based module by Lesswire, which is
> connected to an imx28 through sdio. We are testing with the most recent
> kernel from wireless-drivers-next and Firmware 14.66.35.p52.
> 
> Frequently, we see 'glitches' between driver and Firmware. The most
> recent driver answers most of them with an attempt to reset the module,
> reload the firmware, and start over.
> 
> However, this only works for us, because our sdio interface triggers a
> hardware reset for the wireless module whenever it probes the device.
> Without this hardware reset (sdio reset only), the module fails to
> restart.

We haven't seen this behavior yet. Could you please share complete log?

> 
> Is the necessity of frequent hardware resets a commonly known issue with
> this chip/firmware? Anybody else experiencing these?
> 
> Currently, we see three different scenarios. One of them is currently
> not answered by  reset. Refer to the upcoming patch.
> 
> (1)  mwifiex_cmd_timeout_func: Timeout cmd .. Ok, after reset.
> (2)  Firmware wakeup failed.. Ok, after reset.

This is ok. Reset at these places helps us recover if a corner case firmware bug is hit. 

> (3) DNLD_CMD: host to card failed. No reset triggered. See patch.
> 
> I can provide detailed logs, if you want.

"DNLD_CMD: host to card failed" error is expected during heavy Tx traffic if data write port is not available. Traffic will be resumed once the port is available.
Please share detailed logs. It would help us find root cause for the problem.

Regards,
Amitkumar

