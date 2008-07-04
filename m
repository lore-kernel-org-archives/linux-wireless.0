Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:53484 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbYGDRyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 13:54:46 -0400
From: Chr <chunkeey@web.de>
To: Ivo Couckuyt <iv0co@yahoo.co.uk>, linux-usb@vger.kernel.org
Subject: Re: PROBLEM: p54usb doesn't work with my Philips CPWUA054 usb adapter
Date: Fri, 4 Jul 2008 19:56:32 +0200
Cc: linux-wireless@vger.kernel.org
References: <486BB5D4.4010701@yahoo.co.uk> <200807021926.29266.chunkeey@web.de> <486BE592.6040006@yahoo.co.uk>
In-Reply-To: <486BE592.6040006@yahoo.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807041956.34051.chunkeey@web.de> (sfid-20080704_195451_416258_C57D17A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 July 2008 22:31:14 Ivo Couckuyt wrote:

(Please keep the CC if you want to answer, Thanks!)

> Chr wrote:
> > On Wednesday 02 July 2008 19:07:32 Ivo Couckuyt wrote:
> [...]
> >> In the very beginning I used ndiswrapper without any problem (still
> >> works now), but at the moment i'm using the old islsm driver together
> >> with kernel 2.6.9 and firmware 2.5.6.0 (only one that works), [...]
> I also added some prints to narrow it down (tedious work, have to
> restart everytime i make a change). dmesg log is attached (ILM:
> statements were added).
>
> snippet of changed code where it seems to fail, it is in p54usc.c
> function p54u_upload_firmware_net2280:
> ...
>     printk(KERN_INFO "ILM: usb_interrupt...\n" );
>
>     err = usb_interrupt_msg(priv->udev,
>                 usb_rcvbulkpipe(priv->udev, P54U_PIPE_INT),
>                 buf, sizeof(__le32), &alen, 1000);
>     printk(KERN_INFO "ILM: call finished (error %i)
> (sizeof(__le32)=%i=%i)...\n", err, sizeof(__le32), alen );
>     if (err || alen != sizeof(__le32))
>         goto fail;
> [...]
>-> dmesg output: <-
>ILM: usb_interrupt...
>ehci_hcd 0000:00:02.2: HC died; cleaning up
>usb 1-1: USB disconnect, address 4
> ...
>
> so the usb_interrupt thing might be related somehow (causes the HC
> failed), or it is just that the usb stick should send 'keep-alive' irq's
> but doesn't because initialization before that has actually failed ?
> (don't know anything about kernel dev, just guessing here).
>

Well, since the USB stack from 2.6.9 differs a lot from the current 2.6.25  
and the p54usb is a _copy_ of islsm (in that regard) and unless my eyes are 
really that bad. the p54usb driver "should" work as good as islsm/ndiswrapper.

So, maybe someone of the linux-usb people knows why this happens?!
How to fix it, or how to DEBUG?! (any tips/hints? or is there a util like 
strace/usbsnopper which can monitor/compare the function-calls and
the resulting traffic of ndiswrapper AND the p54usb driver?)
(Chipset seems to be a nForce 2 OHCI/EHCI):

ehci_hcd 0000:00:02.2: HC died; cleaning up
irq 11: nobody cared (try booting with the "irqpoll" option) 
Pid: 0, comm: swapper Not tainted 2.6.25-gentoo-r4-BARTON #1 
[<c0149ee7>] __report_bad_irq+0x27/0x90
[<c014a218>] note_interrupt+0x2c8/0x300
[<c01493e1>] ? handle_IRQ_event+0x31/0x70
[<c014aced>] handle_level_irq+0xdd/0x110
[<c0105e26>] do_IRQ+0x46/0x80
[...]
handlers:
[<c02fef00>] (usb_hcd_irq+0x0/0x60) 
[<c02fef00>] (usb_hcd_irq+0x0/0x60) Disabling IRQ #11
(full: http://article.gmane.org/gmane.linux.kernel.wireless.general/15841)
"

More References (including lsusb -v, lspci -v and many more):
http://www.spinics.net/lists/linux-wireless/msg15834.html
http://article.gmane.org/gmane.linux.kernel.wireless.general/11525
http://article.gmane.org/gmane.linux.kernel.wireless.general/17170

Regards,
	Chr.
