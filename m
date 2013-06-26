Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:58699 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab3FZQOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 12:14:16 -0400
Received: by mail-vb0-f49.google.com with SMTP id 12so10746346vbf.22
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jun 2013 09:14:16 -0700 (PDT)
Message-ID: <51CB1356.80306@lwfinger.net> (sfid-20130626_181419_821248_7FA57ED6)
Date: Wed, 26 Jun 2013 11:14:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "shiki.biomernok" <shiki.biomernok@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fwd: Re: TP-Link 8200ND - rtl8192cu module not loading / working
References: <51A77433.2060702@lwfinger.net> <51CAD0B8.3010303@gmail.com>
In-Reply-To: <51CAD0B8.3010303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/26/2013 06:30 AM, shiki.biomernok wrote:
> Hello everyone!
>
> CC'ing my original message that I sent to Larry.
> It's been a while, but I've been busy and I couldn't fiddle with the wireless
> device.
>
> Basically it's a 8192cu device. Larry suspected it's not, but I think he saw the
> advertisement displayed on top of the TP-Link page.
> I even mailed TP-Link, and here is the reply:
>
>     The chipset is Realtek RTL8192CU and you can download the driver
>     from
>
> http://www.realtek.com/downloads/downloadsView.aspx?Langid=1&PNid=21&PFid=48&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true.
>
>     Thank you.
>
> Tested with many kernels, but none of them worked.
> Ubuntu 13.04 (both stock + updated), Fedora (Schrodinger-1), Fedora Beta
> (Schrodinger), openSUSE (normal+tumbleweed).
> I even tried the latest kernels since 3.10-rc4. (latest I tried is -rc7)
>
> Basically this device *should* work with the 8192cu driver, but it just won't.
> If you just plug it in, nothing happens.
> You have to first:
> $ modprobe 8192cu
> $ echo 2357 0100 > /sys/bus/usb/drivers/rtl8192cu/new_id
>
> Then it lights up, it shows up in NM-Applet. But it won't work.
> I tried enabling the realtek debug option at the kernel driver, but it didn't help.
> Even with that, I only see the authentication failed messages.
>
> Dmesg shows the errors: http://pastebin.com/QCfXYCZ1
>
>
> Hope you guys can come up with some tips/ideas.
> Ps.: I hope you don't mind the CC Larry.

No, that is what I told you to do.

A patch has been submitted to add that device to the USB_DEVICE table. It is 
included in the wireless-testing git tree, but it is not in the mainline code 
(yet). After that patch was applied, the device worked for that reported.

I noticed that you are getting an oops from iwlwifi, and an ehci-hcd error. Are 
you also exploring these problems?

If possible, could you use the wireless-testing repo? That will get you the 
latest code for all wireless drivers, and the USB code will match mainline.

Larry


