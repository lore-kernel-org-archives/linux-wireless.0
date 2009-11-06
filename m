Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51014 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759562AbZKFUdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 15:33:38 -0500
Received: by bwz27 with SMTP id 27so1592652bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 12:33:43 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: James Grossmann <cctsurf@gmail.com>
Subject: Re: Prism54/p54pci
Date: Fri, 6 Nov 2009 21:33:38 +0100
Cc: linux-wireless@vger.kernel.org
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com> <200911062014.19363.chunkeey@googlemail.com> <167ae39b0911061137m72a1e7e9le0e2b59b64be2821@mail.gmail.com>
In-Reply-To: <167ae39b0911061137m72a1e7e9le0e2b59b64be2821@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911062133.38842.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 November 2009 20:37:00 James Grossmann wrote:
> Doing it from the console doesn't seem to give a kernel oops... it
> just locks up the computer such that I can't even change the caps lock
> status. It starts the connection, and then the activity light on the
> card goes on and the computer is locked up.
well, there are other ways to capture the oops, but I don't think
your laptop has a serial console or a real reset button?!

does your caps lock & scroll lock LED blink? (they should)

does the kernel reboot itself (after ~10 seconds), if you add 
panic=10
to the kernel-parameters in grub configuration?

do you have some sort of bootsplash or frame buffer console?
(e.g. KMS/vesa/etc...) because these advanced features can make it
really hard to get the message to the screen before it goes black.

is there nothing in /var/log/syslog after a crash?

> With regard to the losing connection/timing out, I'm seeing that a
> fair amount, when I have data transferring (watching an active ssh
> connection, or streaming audio), and especially when I'm not doing
> anything...
well, there could be several different things, I hope you're using
services like Network-manager, wpa_supplicant to manage your connection.
Because they will automatically reconnect as soon as the link dies.

what could be interesting: iw dev wlanX scan / iwlist wlanX scan
dump from your AP... especially the TSF/tsf value, 
(it's a hexadecimal value which acts like a uptime for the AP)

Regards,
	Chr
