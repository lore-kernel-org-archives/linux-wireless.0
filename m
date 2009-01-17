Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:65255 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbZAQIKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 03:10:20 -0500
Received: by bwz14 with SMTP id 14so6047287bwz.13
        for <linux-wireless@vger.kernel.org>; Sat, 17 Jan 2009 00:10:18 -0800 (PST)
To: Christian Lamparter <chunkeey@web.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] p54spi: remove arch specific dependencies
References: <E1LNgyq-0006iZ-0M@sipsolutions.net>
	<200901161929.30204.chunkeey@web.de> <87k58vxcyw.fsf@litku.valot.fi>
	<200901162234.15946.chunkeey@web.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 17 Jan 2009 10:10:15 +0200
In-Reply-To: <200901162234.15946.chunkeey@web.de> (Christian Lamparter's message of "Fri\, 16 Jan 2009 22\:34\:15 +0100")
Message-ID: <87r6322w0o.fsf@litku.valot.fi> (sfid-20090117_091026_035983_31FBDCF3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@web.de> writes:

> On Friday 16 January 2009 20:33:43 Kalle Valo wrote:
>> N800 and N810 support is not on mainline yet, for stlc45xx I decided
>> to add module parameters for the gpio numbers. Here's the commit from
>> stlc45xx repo:
>> 
>> http://gitorious.org/projects/stlc45xx/repos/mainline/commits/35afc5df0027d02d49e6f5bf986dcc4deb4ee6cf
>
> This is the same patch for p54spi.
> It removes all N800/N810 specific code from p54spi, so the driver can be used on
> other architectures, or configurations as well.
>
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> All in favour with these changes?

No complaints from me.

> +/*
> + * gpios should be handled in board files and provided via platform data,
> + * but because it's currently impossible for p54spi to have a header file
> + * in include/linux, let's use module paramaters for now
> + */

For stlc45xx, being an out-of-tree driver, it was impossible to have a
header file for the platform data. But p54spi is a proper in-tree
driver and it shouldn't have that problem. But that's the next step,
it shouldn't hold off this patch.

-- 
Kalle Valo
