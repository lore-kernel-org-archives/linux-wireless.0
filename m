Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50885 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab0CEW0q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 17:26:46 -0500
Subject: Re: Kernel 2.6.33: ar9170.fw firmware file not found
From: Pavel Roskin <proski@gnu.org>
To: Malte Gell <malte.gell@gmx.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201003040835.29387.malte.gell@gmx.de>
References: <201003040835.29387.malte.gell@gmx.de>
Content-Type: text/plain
Date: Fri, 05 Mar 2010 17:26:35 -0500
Message-Id: <1267827995.3068.33.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-04 at 08:35 +0100, Malte Gell wrote:
> Hello,
> 
> I just upgraded from Kernel 2.6.32 to 2.6.33 and the ar9170 driver suddenly 
> says "firmware file not found". Of course, I have the one stage and the two two 
> stage files in /lib/firmware. What does this error occur? Do I have to update 
> the firmware? Does kernel 2.6.33 need more recent firmware files? Or what is the 
> reason? Or is it a bug?

I checked the sources of Linux 2.6.33.  My understanding is that
"firmware file not found" (a very uninformative message, by the way)
would only be printed if following happens:

- ar9170.fw cannot be loaded
- the device is not AVM FRITZ!WLAN USB Stick N 2.4
- ar9170-1.fw can be loaded
- ar9170-2.fw cannot be loaded

Moreover, I checked the differences between 2.6.32 and 2.6.33, and I
don't see any changes that could affect the firmware download.

I suggest that you check what you have in /lib/firmware.  Looks at the
file sizes.  Maybe OpenSUSE only loads firmware from directories with
the kernel version, such as /lib/firmware/2.6.33?

You could try compat-wireless.  It the has some changes to the firmware
load code.

If you have any further problems, please give the exact kernel log
messages as reported by dmesg, as they can contain some clues.

-- 
Regards,
Pavel Roskin
