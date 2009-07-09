Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:43999 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760012AbZGIPft (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 11:35:49 -0400
Message-ID: <4A560E4B.6080209@fgan.de>
Date: Thu, 09 Jul 2009 17:35:39 +0200
From: Alexander Wenzel <wenzel@fgan.de>
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Problem with p54 driver and ibss mode
References: <4A55DB91.2070305@fgan.de> <73aaf0dd0907090620i752b7f9cq60563f8e22c02d75@mail.gmail.com>
In-Reply-To: <73aaf0dd0907090620i752b7f9cq60563f8e22c02d75@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!
>> I'm trying to get the latest p54 wireless drivers (ad-hoc mode)
>> to work on a Nokia N810... So far, without any success.
>> [ 3905.535125] WARNING: at /home/wen/work/NokiaN810/compat-wireless-2009-07-09/net/mac80211/sta_info.c:339 sta_info_insert+0x7c/0x15c [mac80211]()
> As far as I can see, this is check that incoming STA and your STA have
> different MAC addresses. If you don't set up MAC manually on both
> devices and make it unique, chances high that they are equal.

You saved my day :D Finally it works...! Thanks for the hint.

[  214.478668] wlan0: Selected IBSS BSSID 56:97:1a:24:11:6c based on configured SSID

# iw dev wlan0 station dump
Station 00:02:ee:c0:ff:ee (on wlan0)
	inactive time:	429 ms
	rx bytes:	8964
	tx bytes:	408
	signal:  	55 dBm
	tx bitrate:	1.0 MBit/s

I just checked the other N810 devices and every device has
the same mac address. And here we go... [p54spi_eeprom.h:39]
0x00, 0x02, 0xee, 0xc0, 0xff, 0xee,

The original kernel with default os shows the correct address.
When booting a different os with the with the original or custom
kernel it shows the 'coffee' address.
So is there a way to let the kernel receive and set the
correct mac address of the wlan device?
I guess my problem is this line:
[ 3685.320800] cx3110x spi2.0: loading default eeprom...

Anyway, i'm happy that it's working now.

Regards,
AleX
-- 
**********************************************
Dipl.-Inform. (FH) Alexander Wenzel
Forschungsgesellschaft fuer
Angewandte Naturwissenschaften e. V. (FGAN)
Neuenahrer Str. 20, 53343 Wachtberg, Germany
Tel.  : 0049 (0)228 9435-263
Fax   : 0049 (0)228 9435-685
E-Mail: wenzel@fgan.de
Web   : http://www.fgan.de/
**********************************************
Sitz der Gesellschaft: Bonn
Registergericht: Amtsgericht Bonn VR 2530
Vorstand: Prof. Dr. Maurus Tacke (komm. Vors.)
          Prof. Dr. Joachim Ender (Stellv.)
