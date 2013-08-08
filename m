Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:37643 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966146Ab3HHTJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 15:09:10 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Oleksij Rempel <linux@rempel-privat.de>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: FUSB200 xhci issue
Date: Thu, 8 Aug 2013 21:09:03 +0200
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	"ath9k_htc_fw" <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	linux-wireless@vger.kernel.org
References: <51ED4E12.8030006@rempel-privat.de> <51F8B42F.102@rempel-privat.de> <5203BAC6.8070905@rempel-privat.de>
In-Reply-To: <5203BAC6.8070905@rempel-privat.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201308082109.04485.chunkeey@googlemail.com> (sfid-20130808_210922_151502_D7AB814C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 August 2013 17:35:34 Oleksij Rempel wrote:
> Am 31.07.2013 08:52, schrieb Oleksij Rempel:
> > Am 28.07.2013 22:41, schrieb Christian Lamparter:
> >> On Sunday, July 28, 2013 04:28:25 PM Oleksij Rempel wrote:
> >>> Am 28.07.2013 14:12, schrieb Oleksij Rempel:
> >>>> Am 28.07.2013 13:38, schrieb Christian Lamparter:
> >>>>
> >>>>>>     before  rmmod.
> >>>>> Oh, I it was on the latest wireless-testing. (And the "ath9k_htc"
> >>>>> module
> >>>>> had the patch "ath9k_htc: reboot firmwware if it was loaded").
> >>>>>
> >>>>> Furthermore, I did the same test with one of the ehci-only ports
> >>>>> and it worked. Both, devices (one had a AR7015, the other a AR9271)
> >>>>> came back after autosuspend there.
> >>>>
> >>>> Grrr... so it brings us back to xhci issue. Even EP4 workaround wont
> >>>> work here :( Suddenly i have no more ideas.
> >>>>
> >>>> Sarah, it's your turn now.
> >>>
> >>> Christian,
> >>> can you please provide some more info about your xhci controller. I'll
> >>> try to get me same.
> >>
> >> Well, it's a laptop (HP DV6-6003EG). I recon that getting 100% the
> >> same setup will be difficult. However, since the uPD720200 was/is
> >> very popular, it should be very easy to find one. [It's probably
> >> on all of these "10 euro usb-3.0 pcie-adapters". So as long as you
> >> got a free 1x-pcie port you should be good.]
> >>
> >> Here's the lspci summary:
> >>
> >> 19:00.0 USB controller [0c03]: NEC Corporation uPD720200 USB 3.0 Host
> >> Controller [1033:0194] (rev 04) (prog-if 30 [XHCI])
> >>          Subsystem: Hewlett-Packard Company Device [103c:1657]
> >>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> >> ParErr- Stepping- SERR- FastB2B- DisINTx+
> >>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >>          Latency: 0, Cache Line Size: 64 bytes
> >>          Interrupt: pin A routed to IRQ 19
> >>          Region 0: Memory at d3400000 (64-bit, non-prefetchable)
> >> [size=8K]
> >>          Capabilities: <access denied>
> >>          Kernel driver in use: xhci_hcd
> >>
> >
> > Thx... i purchased on random on ebay, will see what i get.
> >
> > I know now why carl9170 don't triggering this bug. Carl uses EP4 as
> > Interrupt with packet size 64. ath9k-htc initially have EP4=Intr,
> > Interval=1, but will reconfigure it to Bulk, Interval=0.
> > It mean, before usb suspend EP4=Bulk, Interval=0 and after resume
> > EP4=Intr, Inter=?. May be xhci can't handle some thing like this? Or may
> > be interval stay 0, and xhci will overfill usb buffer on adapter - at
> > least it looks so.
> 
> Christian,
> can you please test one more patch. It is working for me, but who knows. 
> More testing is never bad idea ;)

It sort of works, but not without a hiccup: 

I get the following messages when I try to load the driver
again after an autosuspend cycle (ar9271, NEC xhci):

ath: phy6: Reading Magic # failed
ath9k_htc: Failed to Initialize the device
usb 2-1: ath9k_htc: USB layer deinitialized
....

However, the device is resetted automatically and it
comes back on the second probe attempt.



Anyway, I do have a question about something else too.

in ath9k_htc's hif_usb:

> struct usb_host_interface *alt = &hif_dev->interface->altsetting[0];
> struct usb_endpoint_descriptor *endp;
> ...
> /* On downloading the firmware to the target, the USB descriptor of EP4
>  * is 'patched' to change the type of the endpoint to Bulk. This will
>  * bring down CPU usage during the scan period. */
>
> for (idx = 0; idx < alt->desc.bNumEndpoints; idx++) {
>   endp = &alt->endpoint[idx].desc;
>   if ((endp->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT) {
>     endp->bmAttributes &= ~USB_ENDPOINT_XFERTYPE_MASK;
>     endp->bmAttributes |= USB_ENDPOINT_XFER_BULK;
>//     endp->bInterval = 0;
>   }
> }

Alan, can you please tell us, if it is really safe to
override the bmAttributes this way? After all (according to
the comment) the device has "morphed" (EP4 has changed).

Or, is it necessary for the driver call "usb_reset_device"
or (usb_reset_configuration) in this case? 

Regards,
   Chr
