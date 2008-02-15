Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:36036 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYBOVPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 16:15:53 -0500
Received: by fg-out-1718.google.com with SMTP id e21so595069fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 13:15:52 -0800 (PST)
Message-ID: <efe7343f0802151315y568cf783obd3381142b2da7d3@mail.gmail.com> (sfid-20080215_211605_297834_7EA551CF)
Date: Fri, 15 Feb 2008 21:15:51 +0000
From: "Luis Correia" <luis.f.correia@gmail.com>
To: "Adam Turk" <bofh1234@hotmail.com>
Subject: Re: kernel 2.6.25-rc1 and no /dev/rt73usb
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <BAY101-W378CC14C633084DBF091A6C8260@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <BAY101-W101FB386E1EF7402881964C8260@phx.gbl>
	 <20080215050358.GA10363@gondor.apana.org.au>
	 <BAY101-W21A064889BC2442893B63BC8260@phx.gbl>
	 <200802152146.06364.IvDoorn@gmail.com>
	 <BAY101-W378CC14C633084DBF091A6C8260@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2008 at 9:08 PM, Adam Turk <bofh1234@hotmail.com> wrote:
>
>  > You are completely missing the point of the concept "modules",
>  > the module rt73usb is intended to support devices with the rt73 chipset.
>  >
>  > The rt73usb driver registers the device and creates an network interface
>  > inside the kernel. This interface is visible to you as user. The name of this
>  > interface is wlan, depending on the number of wireless network cards in
>  > your system the interface number is attached to it so in your case wlan0.
>
>  Yep, I could be missing the concept of modules entirely.
>
>  The driver I was using before had the interface name of rt73.  When I see
>
> usbcore: registered new interface driver rt73usb
>  I think the interface name is rt73usb.  Maybe change the line to read
>  usbcore: registered new interface driver rt73usb using name wlan0
>  so there is no confusing us newbies.

You are mixing module name with whatever resource this module provides.

"usbcore: registered new interface driver rt73usb" simply means that
an "interface driver" called rt73usb (the module name) has registered
some device name (wlan0 in your case) with the "usbcore" subsystem.

As simple as that!

Luis Correia
rt2x00 project admin
