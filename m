Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbcERDdQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 23:33:16 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Lenski <dlenski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Make firmware startup polling timeout configurable, and increase default
References: <1463525295-10818-1-git-send-email-dlenski@gmail.com>
	<1463525295-10818-2-git-send-email-dlenski@gmail.com>
Date: Tue, 17 May 2016 23:33:12 -0400
In-Reply-To: <1463525295-10818-2-git-send-email-dlenski@gmail.com> (Dan
	Lenski's message of "Tue, 17 May 2016 15:48:15 -0700")
Message-ID: <wrfjeg903urr.fsf@redhat.com> (sfid-20160518_053319_769016_0B7224E9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Lenski <dlenski@gmail.com> writes:
> This patch:
>
> - increases the default value for the maximum number of polling loops to
>   wait for the rtl8xxxu MCU to start after the firmware is loaded (from
>   1000 to 5000)
> - makes this a configurable module parameter
>
> With RTL8723AU chipset, I frequently encounter "Firmware failed to start"
> errors from rtl8xxxu after a cold boot.
>
> It appears that other chipsets supported by the driver have the same
> problem. Here are a couple of relevant bug reports:
> - http://ubuntuforums.org/showthread.php?t=2321756
> - https://www.mail-archive.com/ubuntu-bugs-nLRlyDuq1AZFpShjVBNYrg <at> public.gmane.org/msg4942468.html
>
> This issue seems to occur because RTL8XXXU_FIRMWARE_POLL_MAX (1000) is
> too short, and the MCU fails to start up as quickly as expected.
>
> With a longer value (5000), the driver starts up consistently and
> successfully after cold-boot.

I am not against increasing the maximum value here, however I would like
more details about the system where you see these problems. I have used
this driver extensively for a long time with my Lenovo Yoga 13 laptop
and not seen this issue.

Second, I really don't think this warrants a module parameter. Bumping
the value should suffice.

Please clean up your patch message to have the required information
included, as previously pointed out on the list.

Note that the patch should at least be relative to
wireless-drivers-next, or preferably my rtl8xxxu-devel tree. In both of
these trees, the rtl8xxxu driver has been split into multiple files and
your patch will not apply.

Last, neither of the links you included for external bug reports work.

Jes
