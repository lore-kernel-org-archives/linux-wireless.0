Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46576 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab0JXUmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Oct 2010 16:42:00 -0400
Received: by eye27 with SMTP id 27so3546049eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Oct 2010 13:41:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CC48B84.1000506@hauke-m.de>
References: <1287857641-7882-1-git-send-email-hauke@hauke-m.de>
	<AANLkTimv9dohuKynRW3GaMUDAOtMKhf0xwr76+wc2vCW@mail.gmail.com>
	<4CC48B84.1000506@hauke-m.de>
Date: Sun, 24 Oct 2010 13:41:58 -0700
Message-ID: <AANLkTimzB3deO8FK=hP9Z5H_-sJ2J7WES_B9aHFitdey@mail.gmail.com>
Subject: Re: [PATCH 1/3] compat: fix device_lock functions on non rt kernel
From: Blaise Gassend <blaise@willowgarage.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

> in the Ubuntu 10.04 default kernel config CONFIG_PREEMPT_VOLUNTARY=y is
> set, but it does not use the RT patches, so compat-wireless build
> failed. If you are using a mainline kernel you can choose between
> CONFIG_PREEMPT_NONE, CONFIG_PREEMPT_VOLUNTARY and CONFIG_PREEMPT (all
> localed in kernel/Kconfig.preempt for a least kernel 2.6.24), so these
> options are not indicating that the RT patches are applied. The RT patch
> adds CONFIG_PREEMPT_RT and CONFIG_PREEMPT_DESKTOP and removes
> CONFIG_PREEMPT, so choosing one of these options to detect that the RT
> patch is applied is not a good idea. I do not had the time to look
> through the hole rt patch to find a better indicator if it is applied so
> I just removed the ones preventing compiling on normal kernels. I just
> looked into patch-2.6.33.7-rt29.bz2 and not the other RT patches.

OK, I see your point now. I did not realize that the mainstream
kernels also had those two options in them. I haven't had much luck
finding an config option that is always on in the RT kernels. For now
your fix sounds like the right tradeoff.

Blaise
