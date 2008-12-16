Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:38289 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbYLPOKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 09:10:06 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Tue, 16 Dec 2008 15:10:09 +0100
Cc: linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <200812161415.09365.chunkeey@web.de> <4947B1E3.4080008@gmail.com>
In-Reply-To: <4947B1E3.4080008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812161510.09499.chunkeey@web.de> (sfid-20081216_151011_458063_33709C68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 16 December 2008 14:49:23 Artur Skawina wrote:
> 
> I've looked at that commit more closely in the mean time;
> this patch makes the card reappear:

> -	hdr->len = cpu_to_le16(skb->len + sizeof(struct p54_hdr));
> +	hdr->len = cpu_to_le16(skb->len - sizeof(*hdr));

right.

> > Dec 16 14:32:44 kernel: usb 1-7: new high speed USB device using ehci_hcd and address 14
> > Dec 16 14:32:44 kernel: usb 1-7: configuration #1 chosen from 1 choice
> > Dec 16 14:32:44 kernel: usb 1-7: firmware: requesting isl3886usb
> > Dec 16 14:32:44 kernel: usb 1-7: New USB device found, idVendor=0846, idProduct=4200
> > Dec 16 14:32:44 kernel: usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > Dec 16 14:32:44 kernel: phy1: p54 detected a LM86 firmware
> > Dec 16 14:32:44 kernel: phy1: FW rev 2.5.6.0 - Softmac protocol 3.0
> > Dec 16 14:32:44 kernel: phy1: you are using an obsolete firmware. visit http://wireless.kernel.org/en/users/Drivers/p54 and grab one for "kernel >= 2.6.28"!
> > Dec 16 14:32:44 kernel: phy1: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:no
> > Dec 16 14:32:47 kernel: phy1: hwaddr 00:30:f1:12:34:56, MAC:isl3886 RF:Frisbee
> > Dec 16 14:32:47 kernel: phy1: Selected rate control algorithm 'minstrel'
> > Dec 16 14:32:47 kernel: usbcore: registered new interface driver p54usb
> > Dec 16 14:32:47 kernel: udev: renamed network interface wlan0 to wlan1
> 
> Did not do any further testing yet.

Do the new firmwares work as well?
Because I'll dropping support for the old firmwares in the future.
The reason are bugs which can be triggered remotely...
(e.g.: frames with a "special" length etc...)

> > Can you please revert it and add this one?
> > it adds a few printks that should help.
> 
> I assume this is no longer needed, but i'll be happy test any p54usb/2280 related patches.
> 
while you're on it, can you please enable slub/slab debug (e.g: slub_debug=ZUPF )
and check if the device still works, or if you pc freeze/crash/burn ?

Regards,
	Chr
