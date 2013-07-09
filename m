Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:53530 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3GIU2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 16:28:33 -0400
Received: by mail-qa0-f49.google.com with SMTP id hu16so3172704qab.15
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jul 2013 13:28:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951035636356@SC-VEXCH1.marvell.com>
References: <5FF020A1CFFEEC49BD1E09530C4FF5951035636354@SC-VEXCH1.marvell.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951035636356@SC-VEXCH1.marvell.com>
Date: Tue, 9 Jul 2013 14:28:32 -0600
Message-ID: <CAMLZHHR_8Zsp2xe=9x4oJ1Rj7XLGOEza3r0uPt_Ht8TDC781aQ@mail.gmail.com> (sfid-20130709_222839_656959_69093F51)
Subject: Re: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
From: Daniel Drake <dsd@laptop.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 7, 2013 at 10:15 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
>
>>We didn't test the behavior of sdio_read/sdio_write API's when hardware is >not present. But they should just return an error.
>
> I ran some tests which confirmed that there is no harm in calling these API's when hardware is removed. They returned ENOMEDIUM error.
>
> Can you please review and verify attached patch?

I gave it a quick test, didn't see any crashes. Thanks.

However, I'm concerned that this patch is worsening the confusion in
this part of the driver.

Unless there is a reason to do otherwise, the norm here would be to
tightly couple the hardware bits that enable interrupts to the Linux
IRQ handler registration. i.e. sdio_claim_irq should be called
immediately before mwifiex_sdio_enable_host_int, and sdio_release_irq
should be called immediately after mwifiex_sdio_disable_host_int.
Right now these 2 steps are very separate (sdio_release_irq is being
called far too late, long after the point when the driver could sanely
handle an interrupt).

Although you would never expect an interrupt to arrive after
mwifiex_sdio_disable_host_int() has been called, the cleanliness and
readability has value here, and maybe damaged hardware would misbehave
and fire an interrupt anyway, which would cause the driver to go
wrong.

Secondly, it should be symmetrical. If the core mwifiex driver is the
thing that enables interrupts, it should be the component responsible
for disabling them as well. With your patch, the core mwifiex driver
enables interrupts, but it is up to the sdio sub-driver to disable
them.

Daniel
