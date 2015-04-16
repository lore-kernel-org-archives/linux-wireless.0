Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fopen.at ([151.236.7.194]:38321 "EHLO fopen.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbbDPJRN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 05:17:13 -0400
From: Florian Achleitner <flo@fopen.at>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Subject: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Date: Thu, 16 Apr 2015 11:10:02 +0200
Message-ID: <3169170.GKjfvNuGRf@r90b40zn> (sfid-20150416_111720_328960_392A6DCE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we are using a Marvell SD8787-based module by Lesswire, which is connected to 
an imx28 through sdio. We are testing with the most recent kernel from
wireless-drivers-next and Firmware 14.66.35.p52.

Frequently, we see 'glitches' between driver and Firmware. The most recent 
driver answers most of them with an attempt to reset the module, reload the 
firmware, and start over. 

However, this only works for us, because our sdio interface triggers a 
hardware reset for the wireless module whenever it probes the device. Without 
this hardware reset (sdio reset only), the module fails to restart.

Is the necessity of frequent hardware resets a commonly known issue with this 
chip/firmware? Anybody else experiencing these?

Currently, we see three different scenarios. One of them is currently not 
answered by  reset. Refer to the upcoming patch.

(1)  mwifiex_cmd_timeout_func: Timeout cmd .. Ok, after reset.
(2)  Firmware wakeup failed.. Ok, after reset.
(3) DNLD_CMD: host to card failed. No reset triggered. See patch.

I can provide detailed logs, if you want.

Regards,
Florian

