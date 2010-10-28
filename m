Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56529 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934118Ab0J1S0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 14:26:35 -0400
Received: by fxm16 with SMTP id 16so2223994fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 11:26:34 -0700 (PDT)
Message-ID: <4CC9C067.9040105@lwfinger.net>
Date: Thu, 28 Oct 2010 13:26:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek rtl8188 support?
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com> <201009181543.18159.s.L-H@gmx.de> <AANLkTimz6bR7mLnEgeBzBZrbKC+jp2bx3VTya=YL2KjV@mail.gmail.com> <201009212120.07914.s.L-H@gmx.de>
In-Reply-To: <201009212120.07914.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2010 02:20 PM, Stefan Lippers-Hollmann wrote:
> [ Given that I'm bound by Debian's definition of FOSS (DFSG), farray.h
>   is a quite unfortunate, as it's not only "non-free" but, given that I 
>   don't see any licensing information handling the firmware blob in 
>   staging-next or the original vendor driver, also "undistributable"...
>   So far I didn't actually have time to look up how rtl871x_open_fw()
>   could be converted to use request_firmware(), but that would at least
>   clear the source licensing for r8712u.ko ]
> 
> Thanks a lot for your efforts regarding cleaning up rtl8712, while 
> rtl8192su/ r8192s_usb works for me almost as well, improvements are
> certainly visible.

In the version in staging, farray.h is covered by the GPL license of the entire
source. It should not cause any problems with Debian.

As part of the inclusion of r8712u in staging, Greg KH asked for a TODO item to
convert the firmware to an external binary. I see this as a 2 step process: (1)
get the firmware binary accepted into linux-firmware, and (2) make it work with
the external loading mechanism. Step 1 has been completed with the following
commit message:

commit c500ee5be41b7954ba9630d7e5d409a24efaf249
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Wed Oct 20 11:49:59 2010 -0500

    Convert firmware for Realtek RTL8192SU (rtl8712u) from embedded to
    an external file.

    Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

The code for step 2 is running locally. I'm waiting for the new version of
linux-firmware to propagate through the distros before I submit the patch. If
you want to grab the new firmware package, I can send you a copy of the patch.

Larry
