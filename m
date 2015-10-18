Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33406 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbbJRSpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 14:45:07 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailout.nyi.internal (Postfix) with ESMTP id 03BD62021A
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2015 14:45:05 -0400 (EDT)
Date: Sun, 18 Oct 2015 11:45:04 -0700
From: Greg KH <greg@kroah.com>
To: Frans van de Wiel <fvdw@fvdw.eu>
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.10-3.18] Driver, staging rtl8712,  add support for
 sitecom WLA2100
Message-ID: <20151018184504.GA6332@kroah.com> (sfid-20151018_204535_647642_CC0B6A16)
References: <D805188AF08F4EC2A19325C1329525E0@FransW7>
 <20151018154547.GA8553@kroah.com>
 <5845ADB79D70437C90C0CF7433F3D180@FransW7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5845ADB79D70437C90C0CF7433F3D180@FransW7>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 18, 2015 at 07:58:30PM +0200, Frans van de Wiel wrote:
> The staging driver rtl8712 lacks support for dongles based on sitecom
> WLA2100.
> The current driver doesn't contain the usb id for this device, this patch
> add it.
> 
> reported by: Frans van de Wiel  <fvdw@fvdw.eu>
> Signed-off-by: Frans van de Wiel  <fvdw@fvdw.eu>
> ---
> This patch is for stable kernels 3.14 to 3.18
> Patch for 3.14.2 is included

We can only apply new patches to the latest kernel version, not older
ones, as we can't go back in time :)

If you want a patch like this backported to older kernels, please read
Documentation/stable_kernel_rules.txt for how to do that.

> 
> --- linux-3.14.2/drivers/staging/rtl8712/usb_intf.c.orig    2014-04-27
> 02:19:26.000000000 +0200
> +++ linux-3.14.2/drivers/staging/rtl8712/usb_intf.c    2014-03-25
> 22:31:33.000000000 +0100
> @@ -144,6 +144,7 @@ static struct usb_device_id rtl871x_usb_
>     {USB_DEVICE(0x0DF6, 0x0058)},
>     {USB_DEVICE(0x0DF6, 0x0049)},
>     {USB_DEVICE(0x0DF6, 0x004C)},
> +    {USB_DEVICE(0x0DF6, 0x006C)},
>     {USB_DEVICE(0x0DF6, 0x0064)},
>     /* Skyworth */
>     {USB_DEVICE(0x14b2, 0x3300)},

Your patch was line-wrapped and the whitespace all messed up, and can't
be applied :(

Please make the patch against the linux-next tree and resend it so that
we have a chance to apply it.

thanks,

greg k-h
