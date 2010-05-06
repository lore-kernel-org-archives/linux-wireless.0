Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40839 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518Ab0EFRpG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 13:45:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OA58B-0007MP-D1
	for linux-wireless@vger.kernel.org; Thu, 06 May 2010 19:45:03 +0200
Received: from CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com ([99.234.24.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 19:45:03 +0200
Received: from senada by CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 19:45:03 +0200
To: linux-wireless@vger.kernel.org
From: seno <senada@t-online.de>
Subject: Re: RTL 8187b - naughty behaviour
Date: Thu, 6 May 2010 17:36:18 +0000 (UTC)
Message-ID: <loom.20100506T185847-345@post.gmane.org>
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com> <4BB7660A.3030900@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

I'm running Mandriva 2010 x86_64 (2.6.31.13) and have a 8187b chipset installed:

0bda:8189 Realtek Semiconductor Corp. RTL8187B Wireless 802.11g 54Mbps Network 
Adapter

As many other linux users report, this chipset is supported but offers only 
limited performance, especially compared to results when using windows.

Some time ago I connected to a Linksys wrt 54 GL router with Linksys firmware 
and recently I installed DD-wrt on that router, but perfomance remaind at the 
same (poor) level; meaning there must be something wrong with the rtl8187 linux 
modul.

Right now the router is ~10 meters away and iwconfig wlan0 output is

IEEE 802.11bg ESSID:"xxx"  
          Mode:Managed  Frequency:2.412 GHz  Access Point: 00:14:BF:4A:ED:F9   
          Bit Rate=18 Mb/s   Tx-Power=27 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:xxxx-xxxx-xxxx-xxxx-xxxx-xxxx-xxxx-xxxx [3]
          Power Management:off
          Link Quality=70/70  Signal level=-33 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Right after booting, I can reach a wireless download rate of ~ 10mbit/s (I have 
10 mbit cable internet). After a while, it seems that the wireless rate drops 
to 1 mbit/s although iwconfig wlan0 stills shows a bit rate of 11 or 18 mbit/s.
That means, I get stuck at a download speed of ~ 130 K/s  -unless I come closer 
to the router, 1 meter ie, then the wireless speed goes up again.

The router status shows 

	Wireless Packet Info
	Received (RX)
	45915806 OK, 10 errors  
	Transmitted (TX)
	81142592 OK, 746 errors 

If the machine with the 8187b chip is connected, I get a lot of TX errors on 
the router. 

While linux shows good connection quality, the router indicates a bad signal 
quality:

	Signal	Noise	SNR	Signal Quality
	-74	-94	20	24%

-I installed the latest package from linux wireless, driver loaded but for some 
reason it was not able to connect to a wpa2 network (iwconfig wlan0 never shot 
enc key), so I uninstalled that again.
-I booted a Mandirva 2010.0 x86 live cd to see if the problem is the same on 32 
bit system, and yes, it is.
-I found a 'newer' driver rtl8187B_linux_26.1056.1112.2009.release.tar.gz on 
ubuntu forum - compiled, installed but for any reason driver did not load 
correctly and something ooopsed (I blacklisted rtl8187 and set r8187 as alias 
for wlan0).

Any idea what I could do to get some better performance with the 8187b chipset?

