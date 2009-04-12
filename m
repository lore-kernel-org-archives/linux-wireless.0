Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:43848 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZDLFoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2009 01:44:37 -0400
Message-ID: <49E17FB4.4050807@lwfinger.net> (sfid-20090412_074440_888953_47040243)
Date: Sun, 12 Apr 2009 00:44:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT/RFC] rtl8187: Implement TX/RX blink for LED
References: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net>	 <3ace41890904091453o158f5c00ldad58da3d002180e@mail.gmail.com>	 <49DE7E42.5020700@lwfinger.net>	 <3ace41890904102123o3e280edau933c8235649879c5@mail.gmail.com>	 <3ace41890904102129n2b62001clff35027088bedcd1@mail.gmail.com>	 <49E0C713.4040507@lwfinger.net> <3ace41890904112157r2037946xddd8fca9222fd97e@mail.gmail.com>
In-Reply-To: <3ace41890904112157r2037946xddd8fca9222fd97e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> Thanks for the explanation. Depending (silently) on other kernel
> requirements is certainly fine.
> I am just thinking we can keep it simple, and wondering if we need
> another user-configurable option.

It is not user configurable. The revised Kconfig selects it automatically if
MAC80211_LEDS is set and LEDS_CLASS is y or m. The user never sees it in the
configuration process.

> BTW, I had a hard lock-up on suspend - it hasn't happened for
> months... while the module doesn't suspend properly, I have
> unload-on-sleep configured and it has work mostly fine for some
> months.  The vendor code is quite lacking in suspend/resume support,
> and if you are going to prepare another iteration of the LED patch,
> please give this a thought.
> on possible problem with this.

Thanks for the heads up. I have not been able to suspend my computer due to
other problems, but I'll see what I can find.

On another subject, I have been working with the vendor driver from
rtl8187B_linux_26.1036.0708.2008. I stripped out a lot of the dead code and made
the modifications so that it compiles cleanly with kernel 2.6.30-rc1. I also
modified it to handle my RTL8187B stick with the 8187 ID. The driver scans OK,
but so far it has not associated with my WPA2 AP. My hope is to get it running
so that I can compare throughput with the current Linux driver.

Larry

