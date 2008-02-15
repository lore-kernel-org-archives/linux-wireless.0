Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:64519 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYBOUqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 15:46:15 -0500
Received: by mu-out-0910.google.com with SMTP id i10so869253mue.5
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 12:46:13 -0800 (PST)
To: Adam Turk <bofh1234@hotmail.com>
Subject: Re: kernel 2.6.25-rc1 and no /dev/rt73usb
Date: Fri, 15 Feb 2008 21:46:06 +0100
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-wireless@vger.kernel.org
References: <BAY101-W101FB386E1EF7402881964C8260@phx.gbl> <20080215050358.GA10363@gondor.apana.org.au> <BAY101-W21A064889BC2442893B63BC8260@phx.gbl>
In-Reply-To: <BAY101-W21A064889BC2442893B63BC8260@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802152146.06364.IvDoorn@gmail.com> (sfid-20080215_204622_278449_0534C132)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 February 2008, Adam Turk wrote:
> 
> > You need to enable KMOD. Otherwise you must manually preload
> > the relevant modules.
> 
> I thought that was what udev was for?  Anyway I recompiled with KMOD enabled and I have partial success.  I nolonger get any errors when I plug in my wireless card.  
> dmesg says:
> usbcore: registered new interface driver rt73usb
> 
> I do a ifconfig rt73usb up and I get a device not found.
> I do a ifconfig -a and see the card is called wlan0 and wmaster0.
> So there is a disparity having somewhere.  wlan0 or rt73usb?  Which is it?

You are completely missing the point of the concept "modules",
the module rt73usb is intended to support devices with the rt73 chipset.

The rt73usb driver registers the device and creates an network interface
inside the kernel. This interface is visible to you as user. The name of this
interface is wlan, depending on the number of wireless network cards in
your system the interface number is attached to it so in your case wlan0.

Ivo
