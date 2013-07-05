Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:40595 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756153Ab3GEQoX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 12:44:23 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Daniel Drake' <dsd@laptop.org>
CC: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Fri, 5 Jul 2013 09:43:24 -0700
Subject: RE: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951035636353@SC-VEXCH1.marvell.com> (sfid-20130705_184426_947361_53338228)
In-Reply-To: <CAMLZHHQuHAZGW0M0qhQi5PoCW78jgF8rw2ZsmbApT2REBRXZtA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Daniel,

>I don't see any external reason why we are not allowed to communicate to
>the hardware here. The other suspend paths do run some communication.

The reason is mwifiex_sdio_remove() gets called even if user removes an externally connected wifi card. In that case the hardware is not present so there is no point in reading/writing hardware registers.

If mwifiex_sdio_remove() is called when card is not powered off or unplugged, we do take care of hardware de-initialization using user_rmmod flag. Interrupt storm issue doesn't exist there.

>However, disabling interrupts at this point does seem like a bad
>solution to me, and something that would come back and bite us in the
>future. mwifiex_sdio_suspend() is not directly related to the cause of
>the problem.

This approach looks correct to me. While returning failure in suspend handler, 'pm_flag & MMC_PM_KEEP_POWER' is false. Card is going to be powered off soon. There won't be any further communication with card, so disabling interrupts at this point of time is logical.
When system is resumed, bus rescan etc. will happen and card will be redetected.

Can you please try this change?

Thanks and regards,
Amitkumar Karwar
