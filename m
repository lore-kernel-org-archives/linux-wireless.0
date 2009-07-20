Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9738 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZGTMWS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 08:22:18 -0400
Subject: Re: any controller working in AP mode ?
From: Pavel Roskin <proski@gnu.org>
To: Ram kumar <ramkumar.research@gmail.com>
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <6306c640907200503h19dcfdd1o8fc69cd94ebdc44f@mail.gmail.com>
References: <6306c640907142221o27c257aaw12f73da8118376f@mail.gmail.com>
	 <445f43ac0907151344q6d80ddeckc0c586b34d8ca7c5@mail.gmail.com>
	 <6306c640907152338k4a5fb474h481d5adba97507b1@mail.gmail.com>
	 <1247843954.25608.62.camel@mj>
	 <6306c640907200503h19dcfdd1o8fc69cd94ebdc44f@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 08:22:16 -0400
Message-Id: <1248092536.13859.20.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-20 at 17:33 +0530, Ram kumar wrote:
> hi,
> 
> > 5 minute search finds that Zonet ZEW2502 is what you need.  There is
> > only one driver for that device on the Zonet site, and it's clearly for
> > Marvell.
> >
> Thanks for the reply.
> but when i visited the zonet website the ZEW2502 is under discontinued
> products.But they have come up with higher versions of wireless usb
> adapters like.
> 
> 1.ZEW2542
> http://www.zonetusa.com/products-140.aspx
> 
> ZEW2542 it uses Ralink RT2770+RT2720.
> When i study the user manual of ZEW2542 it says it can support
> software AP mode.The device uses Ralink wireless configuration tool
> instead of the native windows wireless configuration tool to configure
> the device.
> 
> but linux wireless website doesn't specify any info about RT2770.It
> would he helpful if you can tell me whether the ZEW2542 can be
> configured with hostapd ?

I think it's in staging now.  See drivers/staging/rt2870/rt2870.h:

       {USB_DEVICE(0x148F,0x2770)}, /* Ralink */               \

I don't know the status of that driver and whether it will be converted
to a regular driver any time soon, but since it's a modern device,
chances are high.

> 2.ZEW2507
> http://www.zonetusa.com/products-54.aspx
> 
> ZEW2507 uses Chipset  	Ralink RT2571 + RT2528
> 
> I am assuming this device can be easily configured in linux using
> hostapd.please correct me if i am wrong.

Yes, this should work.  But I'm not sure it would work in AP mode with
clients using power saving.  There was a recent discussion about it.

-- 
Regards,
Pavel Roskin
