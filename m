Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53416 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab3AUH5L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 02:57:11 -0500
Message-ID: <1358754973.6252.131.camel@cumari.coelho.fi> (sfid-20130121_085715_502147_A7E534FF)
Subject: Re: wl12xx: does not connect to WPA2-personal
From: Luciano Coelho <coelho@ti.com>
To: Ketan Kamat <ketan_kamat@persistent.co.in>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 21 Jan 2013 09:56:13 +0200
In-Reply-To: <loom.20130120T094649-416@post.gmane.org>
References: <loom.20130120T094649-416@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ketan,

On Sun, 2013-01-20 at 08:47 +0000, Ketan Kamat wrote:
> Hello Luciano,
> 
> we are facing a problem with wl1271 module when connecting to WPA2-personal
> network with ciper AES.It connects after successful authentication (without
> getting IP address) and keeps retrying for IP address after connecting (and
> suddenly disconnects as well).

This sounds like an encryption problem.


> We are using ubuntu 12.04 with linux kernel 3.4.7 built using stable-kernel
> tree. wl12xx firmware loaded for wl12xx is 6.3.5.0.98. Hardware setup consists
> of beagle board connected to the chipsee module that has touchscreen and the
> wl1271 module.
> 
> I am mentioning two scenarios here:
> 1. Here we use a router that we can configure to different wifi security. If we
> set the wifi network to open i.e security=None, wl1271 module gets connected.
> Hence does not seem to be problem related to antenna or range.

What is the model of the AP you're using?


> 2. If i remove driver for wl12xx and connect a USB dongle (r8712u), and try to
> connect to the same WPA2-personal network.It works and gets the IP
> address.However we want to use on board wl12xx module.
> 
> Is it the problem with the wl12xx driver? Any fix for this?

It could be a problem with the firmware. 


> Does wpa2-personal work with wl12xx with latest Linux kernel (3.7.2)?

Yes, AES works with 3.7.


> Any pointers towards this would be of great help.

Did you try TKIP instead of AES? Just to find out if the problem only
happens with AES.

You could also try compat.  There are lots of fixes and improvements in
newer versions of the driver and firmware it uses.

I'll try a newer firmware for 3.4 that I found here and let you know how
it goes.

--
Cheers,
Luca.

