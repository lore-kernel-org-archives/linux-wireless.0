Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:34374 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3FZLaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 07:30:07 -0400
Received: by mail-ea0-f177.google.com with SMTP id j14so7404472eak.36
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jun 2013 04:30:06 -0700 (PDT)
Message-ID: <51CAD0B8.3010303@gmail.com> (sfid-20130626_133039_465950_78A3B95F)
Date: Wed, 26 Jun 2013 13:30:00 +0200
From: "shiki.biomernok" <shiki.biomernok@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Fwd: Re: TP-Link 8200ND - rtl8192cu module not loading / working
References: <51A77433.2060702@lwfinger.net>
In-Reply-To: <51A77433.2060702@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone!

CC'ing my original message that I sent to Larry.
It's been a while, but I've been busy and I couldn't fiddle with the 
wireless device.

Basically it's a 8192cu device. Larry suspected it's not, but I think he 
saw the advertisement displayed on top of the TP-Link page.
I even mailed TP-Link, and here is the reply:

    The chipset is Realtek RTL8192CU and you can download the driver
    from
    http://www.realtek.com/downloads/downloadsView.aspx?Langid=1&PNid=21&PFid=48&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true.
    Thank you.

Tested with many kernels, but none of them worked.
Ubuntu 13.04 (both stock + updated), Fedora (Schrodinger-1), Fedora Beta 
(Schrodinger), openSUSE (normal+tumbleweed).
I even tried the latest kernels since 3.10-rc4. (latest I tried is -rc7)

Basically this device *should* work with the 8192cu driver, but it just 
won't.
If you just plug it in, nothing happens.
You have to first:
$ modprobe 8192cu
$ echo 2357 0100 > /sys/bus/usb/drivers/rtl8192cu/new_id

Then it lights up, it shows up in NM-Applet. But it won't work.
I tried enabling the realtek debug option at the kernel driver, but it 
didn't help.
Even with that, I only see the authentication failed messages.

Dmesg shows the errors: http://pastebin.com/QCfXYCZ1


Hope you guys can come up with some tips/ideas.
Ps.: I hope you don't mind the CC Larry.

Best regards,


-------- Original Message --------
Subject: 	Re: TP-Link 8200ND - rtl8192cu module not loading / working
Date: 	Thu, 30 May 2013 10:45:55 -0500
From: 	Larry Finger <Larry.Finger@lwfinger.net>
To: 	Me <shiki.biomernok@gmail.com>
CC: 	wlanfae@realtek.com



On 05/29/2013 02:21 PM, I wrote:
> Dear Realtek!
>
> I just bought a TP-Link 8200ND wireless USB device, that uses the Realtek
> rtl8192cu driver. The driver is included in every recent kernel, but I can't use it.
>
> Things I tried:
> - Plug it in: It only shows a blank string at "lsusb".
> - Loading the module by hand: "lsusb" is still empty, but "dmesg" shows the
> module is loaded, and I can mess around under /sys/bus/usb/drivers/8192cu/
> - Adding a new ID from the Debian wiki for known devices.
> This works as far as "dmesg" is concerned. It will say I connected a new device,
> like a Realtek wifi USB device. BUT I still don't have anything in my network
> manager/ifconfig/rfkill. Nothing.
>
> This is what I see in lsusb:
> Bus 002 Device 002: ID 2357:0100
>
>
> I would be more than willing to help you guys out with this.
> Can even set up my laptop with SSH so you could debug/develop/reboot whatever
> you need.

In the future, I will refuse to answer your e-mails regarding wireless devices
*UNLESS* you also Cc a wireless mailing list. The "best" option would be
linux-wireless@vger.kernel.org. If you have any questions about why I insist on
this, please read the following two links as to why emailing a single person
directly is usually not a good thing, and causes extra work on a single person:
     http://www.arm.linux.org.uk/news/?newsitem=11
     http://www.eyrie.org/~eagle/faqs/questions.html

I cannot add you to the list as that would expose your email address on a public
forum, and I will not create a second breach of etiquette just because you
already did one.

Your device is *NOT* an RTL8192CU device. I wondered when I saw the 300 Mbps,
but I was certain when I saw it was a dual-band device.

I have a driver for your device, but I will not tell you how to get it until you
place a proper request on some mailing list!

Larry



