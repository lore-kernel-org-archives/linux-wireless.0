Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:64922 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3F0QFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 12:05:38 -0400
Received: by mail-vc0-f171.google.com with SMTP id gd11so349587vcb.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jun 2013 09:05:37 -0700 (PDT)
Message-ID: <51CC62D0.7000101@lwfinger.net> (sfid-20130627_180541_930580_1B29E09C)
Date: Thu, 27 Jun 2013 11:05:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "shiki.biomernok" <shiki.biomernok@gmail.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: Re: TP-Link 8200ND - rtl8192cu module not loading / working
References: <51A77433.2060702@lwfinger.net> <51CAD0B8.3010303@gmail.com> <51CB1356.80306@lwfinger.net> <51CB250A.3060900@gmail.com> <51CB4E31.50502@lwfinger.net> <51CC0CD1.5000801@gmail.com> <51CC3F6E.4050308@gmail.com> <51CC5541.8010003@lwfinger.net> <51CC5B26.50605@gmail.com>
In-Reply-To: <51CC5B26.50605@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/27/2013 10:32 AM, shiki.biomernok wrote:
> Hello!
>
> So I already wanted to write a letter about how the new driver won't do
> anything. Then I got Larry's message and applied the patch immediately.
>
> - The device starts up with no led activity (it should blink (slow) if plugged in)
> ^This is an annoying "feature", but... yeah.
>
> - LED goes off if you disconnect. (Actually I like this behavior a lot more.)
>
> - With this driver, I can actually connect and get a password wrong dialog.
> (it's correct.) So I suppose it's the same thing.. auth failed, just now I have
> my proper Nm-applet dialog, asking for a new password. (Oh, and finally this
> driver shows activity in the tray, as in, you can see it tries to connect. You
> know, that green orb going around. But only one of them is green and you will
> get prompted for a new password.)
>
> Here is the dmesg (hope it helps.):
> http://pastebin.com/uUsp7edb

The dmesg output shows that the device authenticated and associated. If you 
still got a password problem after that, then the device is not able to actually 
transmit data.

> I tried to compile the Linus git version of the kernel, but it comes with an
> even older wireless code than the "wireless-next" one. (Well, obviously, but you
> know.)

Of course. Wireless-next has the code that will be in 3.11. I think I told you 
to use wireless-testing, which is the tree I use. It is essentially 3.10 with a 
few changes that are in the pipeline.

> Could I go more verbose somehow?
> Maybe with THIS driver? Or somehow fiddle with my router?

You could change the line in core/debug.c that says "u32 GlobalDebugLevel = 
_drv_info_". The symbol _drv_info_ has value 7, and you could try values down to 
1; however, I am not prepared to spend a lot of time looking at such dumps.

A better approach would be to use a different computer and wireshark to capture 
the "in the air" traffic between the 8200ND and the AP.

> Ps.: That  really sucks Larry. I mean, you are the wireless wizard for Realtek
> and you don't get devices? Just what the... why? All of my why, man...

I get all PCI devices, which is why their drivers are in better shape.

Larry


