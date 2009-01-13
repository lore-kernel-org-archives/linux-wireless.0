Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:47828 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbZAMSGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 13:06:09 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Tue, 13 Jan 2009 19:06:13 +0100
Cc: linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <200901131449.41189.chunkeey@web.de> <496CC514.3030307@gmail.com>
In-Reply-To: <496CC514.3030307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901131906.13096.chunkeey@web.de> (sfid-20090113_190615_374032_8468A02D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 January 2009 17:45:08 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Monday 12 January 2009 18:09:47 Artur Skawina wrote:
> >> kernel: phy0: p54 detected a LM86 firmware
> >> kernel: p54: rx_mtu reduced from 3240 to 2392
> >> kernel: phy0: FW rev 2.13.1.0 - Softmac protocol 5.5
> > Well, I guess you got the latest wireless-testing tree, right?
[...] 
> will do, after upgrading the kernel (could take a few days).
hmm... OT: who old is your hostapd version? As far as I can tell AP-mode is still WIP.
Maybe you can save you alot trouble if your mobile can connect to ad-hoc wifis.

> >> so to test the device further i set up hostapd, which mostly worked; after 
> >> a few tweaks (eg patching out country code setting in hostapd)
> > patching out country code?! why that?
> > currently, hostapd is the only thing that works out-of-the-box :-D
> 
> hostapd was aborting no matter what country code i configured, so i
> disabled that, leaving figuring this out for later.
have you installed crda and udev on your box?
( http://wireless.kernel.org/en/developers/Regulatory/CRDA )

> [also hostapd is reporting some TX failures, didn't investigate yet]
TX failures? do you have hostapd's log of it?

> it certainly looks like a leak, at first i suspected memory fragmentation, but
> Larrys patch didn't help; later the order-0 alloc failures appeared.
well, you have a 32-bit architecture, unlike me or larry.
So, with a bit of luck the skbs always fitted into a single page and you never
had problems with memory fragmentation. 

> The machine has 512M, ~100M should be (usually is) free, is under constant light
> load (typically <2k ints/s, 60% idle) and is running fine for weeks/months between
> reboots, but locks up after only a few packets go over the hostap driven
> p54usb device. I need the box to be up, that limits the number of tests i can
> run, at least as long as the lockups w/o any diagnostics happen...
Do keyboard-leds "flash" when it locks up, or does console respond 
if you press alt-sysrq-m / alt-sysrq-w on the connected keyboard?
( If your box has a serial port, you can try to get the logs from there...  )

Regards,
	Chr
