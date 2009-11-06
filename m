Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:35308 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759691AbZKFUwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 15:52:38 -0500
Received: by ewy3 with SMTP id 3so1466646ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 12:52:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911062133.38842.chunkeey@googlemail.com>
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com>
	 <200911062014.19363.chunkeey@googlemail.com>
	 <167ae39b0911061137m72a1e7e9le0e2b59b64be2821@mail.gmail.com>
	 <200911062133.38842.chunkeey@googlemail.com>
Date: Fri, 6 Nov 2009 14:52:42 -0600
Message-ID: <167ae39b0911061252x790d69fei9e798e8c6080f175@mail.gmail.com>
Subject: Re: Prism54/p54pci
From: James Grossmann <cctsurf@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

my caps lock & scroll lock leds are not blinking, and yet the computer
is frozen.  (I'm not the best at terminology, I guess that might not
be defined as a hard lock.)  I get no odd messages in my syslog.  I am
using Ubuntu right now, so I'm guessing that they have all the
prettyness going that they can, covering the important messages, but
as it's not an actual oops, I'm not certain that's hurting us.
I am using network-manager, so it does reconnect, however, I find that
to be less than optimal.
Thanks,
James


On Fri, Nov 6, 2009 at 2:33 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Friday 06 November 2009 20:37:00 James Grossmann wrote:
>> Doing it from the console doesn't seem to give a kernel oops... it
>> just locks up the computer such that I can't even change the caps lock
>> status. It starts the connection, and then the activity light on the
>> card goes on and the computer is locked up.
> well, there are other ways to capture the oops, but I don't think
> your laptop has a serial console or a real reset button?!
>
> does your caps lock & scroll lock LED blink? (they should)
>
> does the kernel reboot itself (after ~10 seconds), if you add
> panic=10
> to the kernel-parameters in grub configuration?
>
> do you have some sort of bootsplash or frame buffer console?
> (e.g. KMS/vesa/etc...) because these advanced features can make it
> really hard to get the message to the screen before it goes black.
>
> is there nothing in /var/log/syslog after a crash?
>
>> With regard to the losing connection/timing out, I'm seeing that a
>> fair amount, when I have data transferring (watching an active ssh
>> connection, or streaming audio), and especially when I'm not doing
>> anything...
> well, there could be several different things, I hope you're using
> services like Network-manager, wpa_supplicant to manage your connection.
> Because they will automatically reconnect as soon as the link dies.
>
> what could be interesting: iw dev wlanX scan / iwlist wlanX scan
> dump from your AP... especially the TSF/tsf value,
> (it's a hexadecimal value which acts like a uptime for the AP)
>
> Regards,
>        Chr
>
