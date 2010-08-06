Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63312 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123Ab0HFHHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 03:07:49 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Dqs_qg=BsoNBTjvJbG+ub+zMv8ctbrJSGPJJJ@mail.gmail.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<1279733634-21974-4-git-send-email-ohad@wizery.com>
	<AANLkTimzA_JJ-byTDWznbL3YzeJ8LAP4M50onf2_3fBF@mail.gmail.com>
	<AANLkTi=Oy8X1xMOwWL_cKBB1LWULT6=p+adUgB+AuSJS@mail.gmail.com>
	<AANLkTi=BUX59heXAW2Uf4wZo2dSS19Je54dkQ5u2YGAW@mail.gmail.com>
	<AANLkTimZQKj7H_GeE=+O9cwxEMTR+LhfFbt=AyXGzN3d@mail.gmail.com>
	<AANLkTikfRja-h9mz7uyRXCZNZjKdU_yB8e58XQucUzrn@mail.gmail.com>
	<AANLkTi=vhWV1RNyemtfppfjvLYAbzd3aRjFOVgLLpG3Z@mail.gmail.com>
	<AANLkTin4m8gJR50zwMB2b0jRMHdNA6CQToKBTAhOL9wF@mail.gmail.com>
	<AANLkTinu2S19r8fueM-jVkc35XL2G0Z16BddE92Ci9KB@mail.gmail.com>
	<20100804114147.GB6852@n2100.arm.linux.org.uk>
	<AANLkTi=Dqs_qg=BsoNBTjvJbG+ub+zMv8ctbrJSGPJJJ@mail.gmail.com>
Date: Fri, 6 Aug 2010 09:07:47 +0200
Message-ID: <AANLkTimrb5P9cVo30y_udoi4+vu3cM4YzfpDaYCfwGEA@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] mmc: support embedded data field in mmc_host
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>,
	linux-wireless@vger.kernel.org,
	Roger Quadros <roger.quadros@nokia.com>,
	linux-mmc@vger.kernel.org, San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	linux-omap@vger.kernel.org, akpm@linux-foundation.org,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/8/4 Ohad Ben-Cohen <ohad@wizery.com>:
> On Wed, Aug 4, 2010 at 2:41 PM, Russell King - ARM Linux
>>
>> Why not arrange for a small piece of code to be built into the kernel
>> when this driver is selected as a module or built-in, which handles
>> the passing of platform data to the driver?
>
> It's interesting.
>
> The only drawback I can see is that it has an inherent limitation of
> having only a single wl1271 device on board,

...which is exactly what the *_board_info scheme in the spi
and i2c subsystems is designed to solve.

This is an established design pattern in the kernel with two
precedents, what makes it so hard to implement this idea?
There are plenty of examples all over the place.

What mainly matters to me is that the stuff can be separated
cleanly and in a nicely structured manner into board-xxx.c files
in the mach-xxx dirs, which is possible also with the simpler
approach so whatever...

Yours,
Linus Walleij
