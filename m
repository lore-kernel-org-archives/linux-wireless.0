Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33090 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbbINP2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 11:28:52 -0400
Received: by oixx17 with SMTP id x17so78645180oix.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 08:28:52 -0700 (PDT)
Subject: Re: Firmware works only if kernel source drivers are built as
 modules.
To: rhubarbpieguy@gmail.com, linux-wireless@vger.kernel.org
References: <55F6E028.9010809@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55F6E7B1.3070209@lwfinger.net> (sfid-20150914_172856_237038_D2C7754F)
Date: Mon, 14 Sep 2015 10:28:49 -0500
MIME-Version: 1.0
In-Reply-To: <55F6E028.9010809@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2015 09:56 AM, rhubarbpieguy@gmail.com wrote:
>
> I'm attempting to load iwlwifi-3160 firmware.  It works only if I build the
> following drivers as modules.
>
>      Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate
>
>       Intel Wireless WiFi MVM Firmware Support
>
> If I compile them into the kernel the firmware is not found.  This is my first
> experience with firmware.  Does firmware require drivers built as modules?  I
> see nothing at https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi stating
> modules must be used.

No, having firmware does not require the driver to be a module; however, user 
space may cause a problem.

To load firmware, the user-space portions needed to read a file must be running. 
If the driver is a module *not in the initrd image*, then one is assured that a 
file can be loaded as those routines were used to get the driver file. For the 
case where the driver is built-in, it is possible for a synchronous 
request_firmware() call to timeout before user space is ready to deliver the 
file. The safe way is to request an asynchronous load of at least the first 
firmware file using request_firmware_nowait(). When the load completes, the 
callback routine will set a completion event with all other operations held 
until that event is set.

Note that iwlwifi is correctly coded. It does load a second firmware file 
synchronously, but only after the first one is available.

The built-in driver will also fail unless the dependent drivers are also built 
in, but the kernel build process should take care of that.

The bottom line is that I do not know why your system is failing. It should 
work. (TM) :)

Larry


