Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:44099 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318Ab3GKOSh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 10:18:37 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Daniel Drake' <dsd@laptop.org>
CC: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Thu, 11 Jul 2013 07:17:37 -0700
Subject: RE: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951035636367@SC-VEXCH1.marvell.com> (sfid-20130711_161845_119526_1299D3E7)
In-Reply-To: <CAMLZHHR_8Zsp2xe=9x4oJ1Rj7XLGOEza3r0uPt_Ht8TDC781aQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

Thanks for your elaborative comments. We can go with your patch which fixes the issue in a cleaner way. I ran some tests and verified remove path with it.

>Unless there is a reason to do otherwise, the norm here would be to
>tightly couple the hardware bits that enable interrupts to the Linux
>IRQ handler registration. i.e. sdio_claim_irq should be called
>immediately before mwifiex_sdio_enable_host_int, and sdio_release_irq
>should be called immediately after mwifiex_sdio_disable_host_int.
>Right now these 2 steps are very separate (sdio_release_irq is being
>called far too late, long after the point when the driver could sanely
>handle an interrupt).

Now if_ops.disable_int call is a bit closer to sdio_release_irq (in if_ops.unregister).

>Although you would never expect an interrupt to arrive after
>mwifiex_sdio_disable_host_int() has been called, the cleanliness and
>readability has value here, and maybe damaged hardware would misbehave
>and fire an interrupt anyway, which would cause the driver to go
>wrong.
mwifiex_main_process() which may go into an infinite loop is not called in this case now.

>Secondly, it should be symmetrical. If the core mwifiex driver is the
>thing that enables interrupts, it should be the component responsible
>for disabling them as well. With your patch, the core mwifiex driver
>enables interrupts, but it is up to the sdio sub-driver to disable
>them.
if_ops.disable_int call takes care of it.

Regards,
Amitkumar Karwar
