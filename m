Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56204 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1GaHCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2011 03:02:32 -0400
Received: by qwk3 with SMTP id 3so2381129qwk.19
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jul 2011 00:02:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC9WiBhiBBwoBR3p23wnO5LFSe0agRMkquvy9RjhmEs8NbYGfg@mail.gmail.com>
References: <CAC9WiBhiBBwoBR3p23wnO5LFSe0agRMkquvy9RjhmEs8NbYGfg@mail.gmail.com>
Date: Sun, 31 Jul 2011 09:02:31 +0200
Message-ID: <CAOZOX0UxwbsF1Lg6vRqEx5_rM3MYKcYSSpddPmUcCih0O3EKdA@mail.gmail.com> (sfid-20110731_090235_895464_994D5AA2)
Subject: Re: v3.0 wants a firmware for rt2870 but v2.6.39 needn't
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I've just updated my kernel to 3.0 and now my wireless card using a
> rt2870 chip doesn't work anymore.
>
> It wants now a firmware rt2870.bin whereas this wasn't needed for older kernels.
>
> Is this expected ? If so why the firmware is now mandatory whereas it
> wasn't previously ?

rt2870 has always needed firmware, but what you didn't notice is that you
are not using the same driver as before. Previous kernels contained 2
drivers for the rt2870 chipset. Namely rt2800usb (as part of rt2x00) and
rt2870 (inside the staging directory). For 3.0 the rt2870 from the staging
directory has been removed, so now you are forced to use rt2800usb.

Both drivers needed firmware, however rt2870 had the firmware compiled
into the driver, while rt2800usb needed the firmware as separate file (as is
the preferred behavior for drivers which need firmware).

So you should just the rt2870.bin file from the linux-firmware package
to get started with the driver.

Ivo
