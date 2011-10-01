Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64456 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1JASBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 14:01:10 -0400
Received: by bkbzt4 with SMTP id zt4so3134865bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Oct 2011 11:01:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: r8712u driver - on ARM
Date: Sat, 1 Oct 2011 20:01:04 +0200
Cc: Ian Jeffray <ian@emobix.co.uk>, linux-wireless@vger.kernel.org
References: <4E81ED65.7060703@emobix.co.uk> <201110011822.00637.chunkeey@googlemail.com> <4E875365.50206@lwfinger.net>
In-Reply-To: <4E875365.50206@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201110012001.05111.chunkeey@googlemail.com> (sfid-20111001_200113_928358_DD13A67E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 October 2011 19:52:37 Larry Finger wrote:
> On 10/01/2011 11:22 AM, Christian Lamparter wrote:
> > On Saturday 01 October 2011 18:01:08 Larry Finger wrote:
> >> Ian,
> >>
> >> Most of the skb assignments in r8712u are aligned OK and most aligned on
> >> 512-byte boundaries, but there was one that had the minimal offset of 14 bytes.
> >> The attached patch should fix it. Does it help?
> > Interesting, this "patch" goes in a completely different direction.
> > Can you tell me where the driver aligns the frames which will be
> > xmitted by the device [i.e.: which is passed to the usb subsystem
> > by usb_submit_urb]? Because that's what actually matters.
> 
> In this driver, all references are to _usb_submit_urb(), which is defined to be 
> usb_submit_urb() in one of the header files. That made it easy to insert a test 
> for misalignment of the DMA buffer as follows:
> 
> Index: wireless-testing-new/drivers/staging/rtl8712/osdep_service.h
> ===================================================================
> --- wireless-testing-new.orig/drivers/staging/rtl8712/osdep_service.h
> +++ wireless-testing-new/drivers/staging/rtl8712/osdep_service.h
> @@ -34,7 +34,7 @@
>   #include <linux/if_arp.h>
>   #include <linux/firmware.h>
>   #define   _usb_alloc_urb(x, y)       usb_alloc_urb(x, y)
> -#define   _usb_submit_urb(x, y)     usb_submit_urb(x, y)
> +//#define   _usb_submit_urb(x, y)     usb_submit_urb(x, y)
> 
>   struct __queue {
>          struct  list_head       queue;
> @@ -232,5 +232,13 @@ static inline u32 _RND512(u32 sz)
>          return ((sz >> 9) + ((sz & 511) ? 1 : 0)) << 9;
>   }
> 
> +static inline int _usb_submit_urb(struct urb *urb, gfp_t mem_flags)
> +{
> +       if (urb->transfer_dma & 3) {
> +               pr_info("Transfer_dma 0x%x not on 4-byte boundary\n", 
> (uint)urb->transfer_dma);
> +               dump_stack();
> +       }
> +       return usb_submit_urb(urb, mem_flags);
> +}
>   #endif

I think you need to check transfer_buffer and not transfer_dma.

Regards,
	Christian
