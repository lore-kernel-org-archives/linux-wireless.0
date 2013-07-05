Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:60498 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776Ab3GEQs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 12:48:27 -0400
Received: by mail-qc0-f175.google.com with SMTP id k14so1326362qcv.20
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jul 2013 09:48:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951035636353@SC-VEXCH1.marvell.com>
References: <CAMLZHHQuHAZGW0M0qhQi5PoCW78jgF8rw2ZsmbApT2REBRXZtA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951035636353@SC-VEXCH1.marvell.com>
Date: Fri, 5 Jul 2013 10:48:25 -0600
Message-ID: <CAMLZHHSZvKWnaBXycNsh64oExhpa0amcUi-6eC-FOaeNZ-TP1A@mail.gmail.com> (sfid-20130705_184830_038146_C6CBAB29)
Subject: Re: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
From: Daniel Drake <dsd@laptop.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 5, 2013 at 10:43 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
>
> Hi Daniel,
>
>>I don't see any external reason why we are not allowed to communicate to
>>the hardware here. The other suspend paths do run some communication.
>
> The reason is mwifiex_sdio_remove() gets called even if user removes an externally connected wifi card. In that case the hardware is not present so there is no point in reading/writing hardware registers.

There is no point in the one case that you mention. But there is a
very good reason to do so in the case that I am talking about. So why
not do it? There is no harm to do it if the hardware is not present,
right?

> This approach looks correct to me. While returning failure in suspend handler, 'pm_flag & MMC_PM_KEEP_POWER' is false. Card is going to be powered off soon. There won't be any further communication with card, so disabling interrupts at this point of time is logical.
> When system is resumed, bus rescan etc. will happen and card will be redetected.

This doesn't make much sense to me either. Why don't we just disable
the interrupt handler at the point when interrupts can no longer be
correctly handled by the driver?

Daniel
