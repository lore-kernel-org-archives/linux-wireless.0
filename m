Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63642 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0JYTZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 15:25:11 -0400
Received: by eye27 with SMTP id 27so4552420eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 12:25:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinZK=aam2Kqy9B-YiqE8AaLBX37GWT7Od+xBUcy@mail.gmail.com>
References: <1287857641-7882-1-git-send-email-hauke@hauke-m.de>
	<AANLkTimv9dohuKynRW3GaMUDAOtMKhf0xwr76+wc2vCW@mail.gmail.com>
	<4CC48B84.1000506@hauke-m.de>
	<AANLkTimzB3deO8FK=hP9Z5H_-sJ2J7WES_B9aHFitdey@mail.gmail.com>
	<AANLkTinZK=aam2Kqy9B-YiqE8AaLBX37GWT7Od+xBUcy@mail.gmail.com>
Date: Mon, 25 Oct 2010 12:24:51 -0700
Message-ID: <AANLkTimD9XDWeL0h7D5DNSrC1_SoLj=O0oUmvejjTR5_@mail.gmail.com>
Subject: Re: [PATCH 1/3] compat: fix device_lock functions on non rt kernel
From: Blaise Gassend <blaise@willowgarage.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct, as far as I know. However, after I saw the parent->mutex bug,
I did some digging, and found that in compat-wireless only one Atheros
driver, which I do not use, actually uses those function calls (and
doesn't use the trylock one). So I can't say that this code has
actually been run.

On Mon, Oct 25, 2010 at 9:49 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Sun, Oct 24, 2010 at 1:41 PM, Blaise Gassend <blaise@willowgarage.com> wrote:
>> Hi Hauke,
>>
>>> in the Ubuntu 10.04 default kernel config CONFIG_PREEMPT_VOLUNTARY=y is
>>> set, but it does not use the RT patches, so compat-wireless build
>>> failed. If you are using a mainline kernel you can choose between
>>> CONFIG_PREEMPT_NONE, CONFIG_PREEMPT_VOLUNTARY and CONFIG_PREEMPT (all
>>> localed in kernel/Kconfig.preempt for a least kernel 2.6.24), so these
>>> options are not indicating that the RT patches are applied. The RT patch
>>> adds CONFIG_PREEMPT_RT and CONFIG_PREEMPT_DESKTOP and removes
>>> CONFIG_PREEMPT, so choosing one of these options to detect that the RT
>>> patch is applied is not a good idea. I do not had the time to look
>>> through the hole rt patch to find a better indicator if it is applied so
>>> I just removed the ones preventing compiling on normal kernels. I just
>>> looked into patch-2.6.33.7-rt29.bz2 and not the other RT patches.
>>
>> OK, I see your point now. I did not realize that the mainstream
>> kernels also had those two options in them. I haven't had much luck
>> finding an config option that is always on in the RT kernels. For now
>> your fix sounds like the right tradeoff.
>
> Just so we're clear, no further patch is needed ay?
>
>  Luis
>
