Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56808.mail.re3.yahoo.com ([66.196.97.82]:45440 "HELO
	web56808.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751322Ab0DQM02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 08:26:28 -0400
Message-ID: <364037.65667.qm@web56808.mail.re3.yahoo.com>
Date: Sat, 17 Apr 2010 05:26:27 -0700 (PDT)
From: Walter <goldenstranger@yahoo.com>
Subject: [rt2x00] rt3070 fails to initialize with rt2800usb
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been monitoring the community's work for the rt3070 chips and especially your recent success towards improving the driver.

I would like to share something with the rt2x00 development team which may or may not be known.

The rt3070 card I own fails to initialize with the latest (working) compat-wireless release. When I plug the USB card, rt2800usb doesn't automatically load and when I manually modprobe the driver it does not recognize it as well.

Looking in to the rt2800usb.c file I found the 'problem'. The VIDs aren't properly set. Mine shows 148f:3070. Although a line is included in the "#ifdef CONFIG_RT2800USB_RT30XX", the module won't initialize the card.

I fixed the problem by adding my device here:

	/* Ralink */
	{ USB_DEVICE(0x148f, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
	{ USB_DEVICE(0x148f, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
	/* Samsung */ 

which now looks like:

	/* Ralink */
	{ USB_DEVICE(0x148f, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
	{ USB_DEVICE(0x148f, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
        { USB_DEVICE(0x148f, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) },
	/* Samsung */

This pertains to the rt3071 as well.

Regards.


      
