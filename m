Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f185.google.com ([209.85.222.185]:51233 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab0FETzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jun 2010 15:55:00 -0400
Received: by pzk15 with SMTP id 15so1607005pzk.15
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jun 2010 12:55:00 -0700 (PDT)
Message-ID: <4C0AABA8.9010401@lwfinger.net>
Date: Sat, 05 Jun 2010 14:55:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jason Dravet <dravet@hotmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] add support for Dell WLA3310 USB card
References: <SNT144-w4640D712F57F1472EF0A16DFD30@phx.gbl>
In-Reply-To: <SNT144-w4640D712F57F1472EF0A16DFD30@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2010 02:04 PM, Jason Dravet wrote:
> 
> Hi,
> 
> The Dell WLA3310 USB wireless card has a Z-Com XG-705A chipset that p54 supports with this patch.  You also have to get the firmware from
> http://wireless.kernel.org/en/users/Drivers/p54 
> download 2.13.24.0.lm87.arm (USB 2nd generation (ISL3887)), rename it to
> isl3887usb and put it in /lib/firmware.
> 
> The only problem I see is the LED light goes on when I plug the card in and it goes out when I get a dhcp address (dhclient).  The LED doesn't flicker when I ping the router either.  The other funny thing it has two LEDs, one on top and one on the bottom.  It appears they do the same thing i.e. they are both on or both off.
> 
> Please consider applying for 2.6.35 and stable depending on if you can distribute the firmware.  If you need anything else please let me know.
> 
> Thanks,
> Jason Dravet
> 
> Signed-off-by: Jason Dravet <dravet@hotmail.com>
> Tested-by: Richard Gregory Tillmore <rtillmore@gmail.com>
> 
> diff -c p54usb2.c p54usb.c>wla3310.patch
> 
> *** p54usb2.c    Fri Jun  4 21:54:16 2010
> --- p54usb.c    Fri Jun  4 21:54:06 2010
> ***************
> *** 82,87 ****
> --- 82,88 ----
>       {USB_DEVICE(0x2001, 0x3704)},    /* DLink DWL-G122 rev A2 */
>       {USB_DEVICE(0x413c, 0x8102)},    /* Spinnaker DUT */
>       {USB_DEVICE(0x413c, 0x8104)},    /* Cohiba Proto board */
> +     {USB_DEVICE(0x413c, 0x5513)},    /* Dell WLA3310 USB Wireless Adapter */
>       {}
>   };

Thanks for looking to this, but you need read
Documentation/SubmittingPatches and follow the guidelines, otherwise you
cause considerable extra work for John Linville.

This time, I will reformat the patch for you.

Larry
