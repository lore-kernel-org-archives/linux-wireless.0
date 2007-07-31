Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:56076 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbXGaMTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 08:19:49 -0400
Message-ID: <46AF28E2.9050905@warmcat.com>
Date: Tue, 31 Jul 2007 13:19:46 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
References: <20070731115446.5717.37617.stgit@localhost> <200707311412.30340.IvDoorn@gmail.com>
In-Reply-To: <200707311412.30340.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

>> +	/* BlueNEXT */
>> +	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
> 
> This USB ID is already in the List under the Label "Ralink"
> 
> 	/* Ralink */
> 	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },

Gah!  I guess I jumped to the wrong conclusion when it didn't work,
because rt2500usb.ko also claims this ID.  Blacklisting rt2500usb and
"adding" the ID in rt73usb got me able to do monitor mode, but I guess
blacklisting rt2500usb was what did the trick.

Sorry for the noise, but maybe the same ID in rt2500usb should be
removed, unless there is some story here about ID reuse...

-Andy
