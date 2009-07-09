Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:40347 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbZGIS44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 14:56:56 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: Problem with p54 driver and ibss mode
Date: Thu, 9 Jul 2009 20:56:52 +0200
Cc: Alexander Wenzel <wenzel@fgan.de>, linux-wireless@vger.kernel.org
References: <4A55DB91.2070305@fgan.de> <4A560E4B.6080209@fgan.de> <200907092157.21784.jcmvbkbc@gmail.com>
In-Reply-To: <200907092157.21784.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200907092056.53055.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 July 2009 19:57:20 Max Filippov wrote:
> В сообщении от Thursday 09 July 2009 Alexander Wenzel написал(a):
^^

> > Hi!
> > >> I'm trying to get the latest p54 wireless drivers (ad-hoc mode)
> > >> to work on a Nokia N810... So far, without any success.
> > >> [ 3905.535125] WARNING: at /home/wen/work/NokiaN810/compat-wireless-2009-07-09/net/mac80211/sta_info.c:339 sta_info_insert+0x7c/0x15c [mac80211]()
> > > As far as I can see, this is check that incoming STA and your STA have
> > > different MAC addresses. If you don't set up MAC manually on both
> > > devices and make it unique, chances high that they are equal.
> > 
> > You saved my day :D Finally it works...! Thanks for the hint.
> > 
> > [  214.478668] wlan0: Selected IBSS BSSID 56:97:1a:24:11:6c based on configured SSID
> > 
> > # iw dev wlan0 station dump
> > Station 00:02:ee:c0:ff:ee (on wlan0)
> > 	inactive time:	429 ms
> > 	rx bytes:	8964
> > 	tx bytes:	408
> > 	signal:  	55 dBm
> > 	tx bitrate:	1.0 MBit/s
> > 
> > I just checked the other N810 devices and every device has
> > the same mac address. And here we go... [p54spi_eeprom.h:39]
> > 0x00, 0x02, 0xee, 0xc0, 0xff, 0xee,
> > 
> > The original kernel with default os shows the correct address.
> > When booting a different os with the with the original or custom
> > kernel it shows the 'coffee' address.
> > So is there a way to let the kernel receive and set the
> > correct mac address of the wlan device?
> > I guess my problem is this line:
> > [ 3685.320800] cx3110x spi2.0: loading default eeprom...
> 
> You're right. I guess that easiest way to deal with it is to save blob from p54spi_eeprom.h into a file
> 3826.eeprom in the same directory as 3826.arm and fix MAC address in it, according to comments in p54spi_eeprom.h
> 
> These data for sure must reside on /dev/mtdblk1 partition, but they're probably somehow coded/obfuscated.
> I couldn't find anything similar to MAC of my own n810 there.
well, this is c0ffee comes from nokia's stlc45xx-driver.
Unfortunately, they don't say how to get the device eeprom from the mtdblk1
partition. However, they certainly provide a tool stlc45xx-cal
(available at: http://stlc45xx.garage.maemo.org/ ) which can be used 
to locate the eeprom's calibration data.

and by the way. If there is no mac field inside the eeprom image,
the driver will generate a random one all the time...

Regards,
	Chr
