Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:45776 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZAMTDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:03:00 -0500
Received: by ewy10 with SMTP id 10so202733ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:02:58 -0800 (PST)
Message-ID: <496CE55F.2080506@gmail.com> (sfid-20090113_200306_815714_725BEC4F)
Date: Tue, 13 Jan 2009 20:02:55 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901131449.41189.chunkeey@web.de> <496CC514.3030307@gmail.com> <200901131906.13096.chunkeey@web.de>
In-Reply-To: <200901131906.13096.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Tuesday 13 January 2009 17:45:08 Artur Skawina wrote:
>> Christian Lamparter wrote:
>>> On Monday 12 January 2009 18:09:47 Artur Skawina wrote:
>>>> kernel: phy0: p54 detected a LM86 firmware
>>>> kernel: p54: rx_mtu reduced from 3240 to 2392
>>>> kernel: phy0: FW rev 2.13.1.0 - Softmac protocol 5.5
>>> Well, I guess you got the latest wireless-testing tree, right?
> [...] 
>> will do, after upgrading the kernel (could take a few days).
> hmm... OT: who old is your hostapd version? As far as I can tell AP-mode is still WIP.

hostap-0_6_6-148-g3cf8523 ie git build from ~ dec 24.

> Maybe you can save you alot trouble if your mobile can connect to ad-hoc wifis.

It can, but i'd like to try to get hostap running w/ this hw anyway...

>>>> so to test the device further i set up hostapd, which mostly worked; after 
>>>> a few tweaks (eg patching out country code setting in hostapd)
>>> patching out country code?! why that?
>>> currently, hostapd is the only thing that works out-of-the-box :-D
>> hostapd was aborting no matter what country code i configured, so i
>> disabled that, leaving figuring this out for later.
> have you installed crda and udev on your box?
> ( http://wireless.kernel.org/en/developers/Regulatory/CRDA )

yes, but only after patching hostapd; the lockups prevented further
testing...

>> [also hostapd is reporting some TX failures, didn't investigate yet]
> TX failures? do you have hostapd's log of it?

I'll send it in a few minutes, as soon as i'll reproduce it.

>> The machine has 512M, ~100M should be (usually is) free, is under constant light
>> load (typically <2k ints/s, 60% idle) and is running fine for weeks/months between
>> reboots, but locks up after only a few packets go over the hostap driven
>> p54usb device. I need the box to be up, that limits the number of tests i can
>> run, at least as long as the lockups w/o any diagnostics happen...
> Do keyboard-leds "flash" when it locks up, or does console respond 
> if you press alt-sysrq-m / alt-sysrq-w on the connected keyboard?

most of the times it happened there was no kbd attached. At least once
when it _was_ connected, sysrq was working, and i saw 0*8KB; that's why
i initially suspected fragmentation.

> ( If your box has a serial port, you can try to get the logs from there...  )

I'll consider setting up another similar machine for testing, so that i'll
be able to run w/ more debugging enabled. I was hoping to avoid it, esp.
as i'm not sure i'll be able to reproduce the problems w/o the load.

thanks,

artur

 

