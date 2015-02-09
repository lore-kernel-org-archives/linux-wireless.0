Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:58629 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbbBICGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 21:06:30 -0500
Received: by mail-oi0-f47.google.com with SMTP id a141so20352799oig.6
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2015 18:06:29 -0800 (PST)
Message-ID: <54D81624.9070705@lwfinger.net> (sfid-20150209_030635_049070_55AE5F3B)
Date: Sun, 08 Feb 2015 20:06:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Simon Raffeiner (SCC)" <simon.raffeiner@kit.edu>,
	linux-wireless@vger.kernel.org
CC: users@rt2x00.serialmonkey.com
Subject: Re: Ralink RT5390/RT5370 no longer works on more recent kernels
References: <54D64337.7080005@kit.edu>
In-Reply-To: <54D64337.7080005@kit.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2015 10:54 AM, Simon Raffeiner (SCC) wrote:
> Hello everyone,
>
> one of my USB wireless adapters, based on the Ralink RT5390/RT5370
> chipset and RF, no longer works on more recent kernels. It doesn't
> report any networks on "iw dev wlan0 scan" and doesn't associate if told
> to do so.
>
> Tested kernels are:
>
> 3.16.0-30-generic (Ubuntu 14.10): Works
> 3.18.0-12-generic (Ubuntu 15.04): Does not work
> 3.19.0-rc7 (built manually): Does not work
>
>
> Firmware md5sums (rt2870.bin is loaded):
>
> 99bce75086ea635a2f8288d9b835f787  /lib/firmware/rt2561.bin
> 2878d5eaa4ff907d4df36a834915aa53  /lib/firmware/rt2561s.bin
> 9998485bc152cf0f39dd61a33b92ad9b  /lib/firmware/rt2661.bin
> 75a1da3caa0b1c95e81dfba207f834c6  /lib/firmware/rt2860.bin
> 36c944c3138125605d28c0a3a1338be9  /lib/firmware/rt2870.bin
> 36c944c3138125605d28c0a3a1338be9  /lib/firmware/rt3070.bin
> 75a1da3caa0b1c95e81dfba207f834c6  /lib/firmware/rt3090.bin
> f8d8051e24cd4c8c298bc84c7309fe1a  /lib/firmware/rt3290.bin
> bd733372ae21a010bf8a5511d7711c2d  /lib/firmware/rt73.bin
>
>
> A dmesg output for the non-working kernel 3.18.0-12-generic is attached.

I do not maintain these drivers, but as no one else has answered, I will offer 
some suggestions.

First of all, it would be helpful if you posted the USB ID as shown by lsusb. As 
the kernel loaded the module, it must be one in the tables, but that info is 
usually needed.

The second thing to verify is that your configuration contains the line 
"CONFIG_RT2800USB_RT53XX=y". This parameter is marked as depending on 
EXPERIMENTAL, and I'm not sure that Ubuntu enables those parameters in their 
kernels. Again as the module was loaded, I think your kernel is OK, but that 
parameter is something to check.

Finally, if your kernel configuration is OK, you will probably need to bisect 
the problem between v3.18 and v3.16. I have a device that uses rt2800usb, but it 
is not a 53XX. FWIW, it works.


Larry


