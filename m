Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:44120 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0DQMpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 08:45:18 -0400
Received: by ewy20 with SMTP id 20so1088520ewy.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Apr 2010 05:45:16 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Walter <goldenstranger@yahoo.com>
Subject: Re: [rt2x00] rt3070 fails to initialize with rt2800usb
Date: Sat, 17 Apr 2010 14:45:13 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <364037.65667.qm@web56808.mail.re3.yahoo.com>
In-Reply-To: <364037.65667.qm@web56808.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201004171445.13785.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 April 2010, Walter wrote:
> I've been monitoring the community's work for the rt3070 chips and especially your recent success towards improving the driver.
> 
> I would like to share something with the rt2x00 development team which may or may not be known.
> 
> The rt3070 card I own fails to initialize with the latest (working) compat-wireless release. When I plug the USB card, rt2800usb doesn't automatically load and when I manually modprobe the driver it does not recognize it as well.
> 
> Looking in to the rt2800usb.c file I found the 'problem'. The VIDs aren't properly set. Mine shows 148f:3070. Although a line is included in the "#ifdef CONFIG_RT2800USB_RT30XX", the module won't initialize the card.
> 
> I fixed the problem by adding my device here:
> 
> 	/* Ralink */
> 	{ USB_DEVICE(0x148f, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
> 	{ USB_DEVICE(0x148f, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
> 	/* Samsung */ 
> 
> which now looks like:
> 
> 	/* Ralink */
> 	{ USB_DEVICE(0x148f, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
> 	{ USB_DEVICE(0x148f, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
>         { USB_DEVICE(0x148f, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) },
> 	/* Samsung */
> 
> This pertains to the rt3071 as well.

That USB ID is already known, did you compile the driver with support
for CONFIG_RT2800USB_RT30XX enabled?

Ivo
