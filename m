Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42994 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZEVPMH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 11:12:07 -0400
Subject: Re: libertas firmware naming confusing
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242979352.4212.27.camel@johannes.local>
References: <1242979352.4212.27.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 22 May 2009 11:11:59 -0400
Message-Id: <1243005119.2461.15.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-05-22 at 10:02 +0200, Johannes Berg wrote:
> Hi,
> 
> I noticed yesterday that you updated the page at
> http://wireless.kernel.org/en/users/Drivers/libertas to say the
> following two things about firmware:

I'm the main source of the firmware naming scheme in linux-firmware.
There is one major reason for this; the drivers support multiple
firmware versions, and for various reasons we'd like to keep multiple
firmware versions around and available.  When I added all the libertas
firmware to linux-firmware, I was not quite sure how to handle this
case.

> 
> USB 
>       * The Linux firmware tree contains libertas/usb8388_v5.bin and
>         libertas/usb8388_v9.bin. The firmware image must be placed
>         in /lib/firmware/usb8688.bin. The firmware image can also be
>         downloaded from OLPC's libertas firmware page. 
> 
> GSPI 
>       * The GSPI firmware is available in the Linux firmware tree. Copy
>         libertas/gspi8686_v9_helper.bin
>         to /lib/firmware/libertas/gspi8686_hlp.bin and
>         libertas/gspi8686_v9.bin
>         to /lib/firmware/libertas/gspi8686.bin. 
> 
> 
> This runs counter to the entire idea of the linux-firmware tree that the
> tree is a drop-in for /lib/firmware/ (or wherever you need it on your
> distribution) -- the tree should always contain the exact filenames as
> required by the kernel drivers. Maybe this needs to be clarified more.
> Additionally, if there's a need for different versions of a firmware,
> then the driver should detect which one is required for the device, if
> it's for different features it should select a good default and possibly
> give the option to override it.
> 
> In this case, I suspect two things are needed:
>  1) rename the GSPI firmware files in the linux-firmware tree to match
>     what the driver loads, and document outside the filename what
>     version they are;

The problem with that is that then we can't have different firmware
versions in linux-firmware really.

>  2) in the USB case change the driver to load libertas/usb8688.bin
>     instead of just usb8688.bin and move one of the versions to that
>     filename in the linux-firmware tree.

Yes, this should be done.  I was unsure what the policy of breaking
firmware filenames is, however.

> The current situation is very stupid -- users can find the firmware in a
> proper repository but it doesn't work out of the box!

Nope, though these cards aren't usually found by "normal" users anyway.
However, I'd like to preserve the the distribution of different firmware
versions in linux-firmware, so maybe we should simply point the drivers
at specific versions and use module parameters to change the firmware
version?

modprobe libertas_sdio fwver=8

would select libertas/86xx_v8_helper.bin for example, but by default we
use v9 or something like that.  Would that be acceptable?

Dan

