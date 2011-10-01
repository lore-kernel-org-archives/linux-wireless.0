Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59048 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab1JASyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 14:54:47 -0400
Received: by bkbzt4 with SMTP id zt4so3177020bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Oct 2011 11:54:46 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: r8712u driver - on ARM
Date: Sat, 1 Oct 2011 20:54:42 +0200
Cc: Ian Jeffray <ian@emobix.co.uk>, linux-wireless@vger.kernel.org
References: <4E81ED65.7060703@emobix.co.uk> <4E8757A8.1010302@emobix.co.uk> <4E87609E.5030002@lwfinger.net>
In-Reply-To: <4E87609E.5030002@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201110012054.42461.chunkeey@googlemail.com> (sfid-20111001_205450_932232_D0716524)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 October 2011 20:49:02 Larry Finger wrote:
> On 10/01/2011 01:10 PM, Ian Jeffray wrote:
> > On 01/10/2011 19:01, Christian Lamparter wrote:
> >> On Saturday 01 October 2011 19:52:37 Larry Finger wrote:
> >>> On 10/01/2011 11:22 AM, Christian Lamparter wrote:
> >>>> On Saturday 01 October 2011 18:01:08 Larry Finger wrote:
> >>>>> Ian,
> >>>>>
> >>>>> Most of the skb assignments in r8712u are aligned OK and most aligned on
> >>>>> 512-byte boundaries, but there was one that had the minimal offset of 14
> >>>>> bytes.
> >>>>> The attached patch should fix it. Does it help?
> >>>> Interesting, this "patch" goes in a completely different direction.
> >>>> Can you tell me where the driver aligns the frames which will be
> >>>> xmitted by the device [i.e.: which
> 
> is passed to the usb subsystem
> >>>> by usb_submit_urb]? Because that's what actually matters.
> >>>
> >>> In this driver, all references are to _usb_submit_urb(), which is defined to be
> >>> usb_submit_urb() in one of the header files. That made it easy to insert a test
> >>> for misalignment of the DMA buffer as follows:
> >
> > <snip>
> >
> >>> +static inline int _usb_submit_urb(struct urb *urb, gfp_t mem_flags)
> >>> +{
> >>> + if (urb->transfer_dma& 3) {
> >
> > <snip>
> >
> >> I think you need to check transfer_buffer and not transfer_dma.
> >
> > I tried checking both transfer_buffer and transfer_dma and all
> > were always word aligned. (At least on Blackfin)
 
> The same with x86_64.
Sure,  x86_64 and powerpc set in system.h

grep NET_IP_ALIGN * -R

microblaze/include/asm/system.h:#define NET_IP_ALIGN    2
powerpc/include/asm/system.h:#define NET_IP_ALIGN       0
x86/include/asm/system.h:#define NET_IP_ALIGN   0

well, it looks like Realtek did a better job then and unfortunately
your problem is related to something else.

Regards,
	Chr
