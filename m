Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:42912 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757458Ab3GEPbJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 11:31:09 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Daniel Drake' <dsd@laptop.org>
CC: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Fri, 5 Jul 2013 08:24:33 -0700
Subject: RE: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951035636352@SC-VEXCH1.marvell.com> (sfid-20130705_173112_380850_83E38247)
In-Reply-To: <CAMLZHHSduu3guHuw__XKZfhrFWc8r7W6DwLp3SMdtLQ56CRh6Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

>mwifiex_sdio_remove() calls mwifiex_remove_card() without having taken
>any care to finish pending commands, etc. mwifiex_remove_card()
>immediately sets surprise_removed which triggers the questionable
>"ignore all interrupts" behaviour. If there were any async commands
>pending, they complete now, with an interrupt. The interrupt doesn't
>get acked, so it becomes an interrupt storm.

>Hope that is clearer.

Thanks for the clarification.

As per our current design, mwifiex_sdio_remove() will be called in following scenarios.
1) Card is powered off / card is unplugged
As we are not allowed to interact with hardware (read/disable interrupts), other driver specific cleanup work is performed.

2) Driver is unloaded
Here apart from cleanup work in case 1, we do send SHUTDOWN etc. command to firmware to perform hardware cleanup(this code is under if(user_rmmod) check).

In your case, as card is powering off, is it ok to access hardware registers to ACK interrupts? If yes, we can disable interrupts before returning "-ENOSYS" in suspend handler.
Modifying mwifiex_sdio_remove() to fix interrupt storm issue would break card unplugged scenario. 

Please let me know your thoughts.
Thanks,
Amit
