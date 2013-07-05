Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f44.google.com ([209.85.128.44]:62746 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3GEPhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 11:37:54 -0400
Received: by mail-qe0-f44.google.com with SMTP id 5so1305308qeb.17
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jul 2013 08:37:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951035636352@SC-VEXCH1.marvell.com>
References: <CAMLZHHSduu3guHuw__XKZfhrFWc8r7W6DwLp3SMdtLQ56CRh6Q@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951035636352@SC-VEXCH1.marvell.com>
Date: Fri, 5 Jul 2013 09:37:53 -0600
Message-ID: <CAMLZHHQuHAZGW0M0qhQi5PoCW78jgF8rw2ZsmbApT2REBRXZtA@mail.gmail.com> (sfid-20130705_173800_996688_82E4F891)
Subject: Re: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
From: Daniel Drake <dsd@laptop.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 5, 2013 at 9:24 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> In your case, as card is powering off, is it ok to access hardware registers to ACK interrupts? If yes, we can disable interrupts before returning "-ENOSYS" in suspend handler.

You tell me - you know the hardware and the driver better than I do. I
don't see any external reason why we are not allowed to communicate to
the hardware here. The other suspend paths do run some communication.

However, disabling interrupts at this point does seem like a bad
solution to me, and something that would come back and bite us in the
future. mwifiex_sdio_suspend() is not directly related to the cause of
the problem.

The problem that we should focus on is that mwifiex_remove_card()
makes the driver enter a state where if an interrupt arrives, it will
be handled badly. Therefore it should be mwifiex_remove_card() or
something directly related to it (maybe the callsite,
mwifiex_sdio_remove) that takes the necessary steps to make sure that
interrupts will not arrive in future.

> Modifying mwifiex_sdio_remove() to fix interrupt storm issue would break card unplugged scenario.

Why would it break that scenario?

Daniel
