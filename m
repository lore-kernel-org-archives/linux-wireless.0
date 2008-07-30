Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:55102 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755755AbYG3MR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 08:17:29 -0400
Message-ID: <48905BD8.3030100@lwfinger.net> (sfid-20080730_141733_182665_6CE27FF9)
Date: Wed, 30 Jul 2008 07:17:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: johan henriksson <jhn98032@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187: RTL8187B with id 0bda:8198
References: <489037EC.4020306@gmail.com>
In-Reply-To: <489037EC.4020306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

johan henriksson wrote:
> Hi!
> 
> I am trying to get the wireless card on a Toshiba Satellite L350
> to work. The laptop uses a RTL8187b chip but unfortunately with an id of 
> 0bda:8198.
> I have tried the RTL8187 driver in the 2.6.27-rc1 release.
> To make the driver accept the card I had to add the productid 8198 to 
> the driver.
> Now the card is detected and seems to work. I can ping another computer 
> on the network
> but for some reason the network just stops working after about 6 seconds.
> There are no errors in the kernel log and if I reconnect with "iwconfig 
> wlan0 essid myNet" the card works again for another 6 seconds.
> I am starting to suspect that the RTL8187b has a watchdog timer like the 
> RTL8181 that times out?
> Does anybody have the datasheet for the RTL8187b?

To quote the RealTek engineers, "The rtl8187B card with VID 8198 is only for 
Toshiba. But It is regrettable that we can't provide open source of that, 
because we have some agreements with Toshiba." All that they will say is that 
the part is different.

We have the data sheet for the RTL8187B, but I have seen nothing about a 
watchdog timer. I would send you the data sheet, but it is not clear that I have 
the right to do so. I'll explore that aspect separately.

Have you run this card with ndiswrapper? If so, you should be able to use usbmon 
to dump the traffic and find what is being sent to the chip by the Windows 
driver that the native driver does not. Perhaps a timer reset will be found that 
way.

The open-source RTL8187 driver is still very much a work in progress. We have a 
couple of patches on their way to mainline that you should try before you do 
much further work. I'll be sending them to you separately.

Larry

