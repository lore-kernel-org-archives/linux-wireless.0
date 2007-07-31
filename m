Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:34725 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858AbXGaMYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 08:24:10 -0400
Received: by ug-out-1314.google.com with SMTP id j3so68898ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 05:24:08 -0700 (PDT)
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
Date: Tue, 31 Jul 2007 14:27:58 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070731115446.5717.37617.stgit@localhost> <200707311412.30340.IvDoorn@gmail.com> <46AF28E2.9050905@warmcat.com>
In-Reply-To: <46AF28E2.9050905@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707311427.58948.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 July 2007, Andy Green wrote:
> Somebody in the thread at some point said:
> 
> >> +	/* BlueNEXT */
> >> +	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
> > 
> > This USB ID is already in the List under the Label "Ralink"
> > 
> > 	/* Ralink */
> > 	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
> 
> Gah!  I guess I jumped to the wrong conclusion when it didn't work,
> because rt2500usb.ko also claims this ID.  Blacklisting rt2500usb and
> "adding" the ID in rt73usb got me able to do monitor mode, but I guess
> blacklisting rt2500usb was what did the trick.

:)

> Sorry for the noise, but maybe the same ID in rt2500usb should be
> removed, unless there is some story here about ID reuse...

Unfortunately there have been reports about devices with that USB ID
that contains a rt2500usb chipset. There are a number of duplicate USB ID's
between rt2500usb and rt73usb.
Some manufacturers like to release new revisions of their wireless USB stick
with different chipsets but with the same USB ID.

Ivo
