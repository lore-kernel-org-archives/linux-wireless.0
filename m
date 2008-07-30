Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:53881 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097AbYG3Kxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 06:53:47 -0400
Received: from [192.168.1.60] (81.235.177.218) by pne-smtpout1-sn2.hy.skanova.net (7.3.129) (authenticated as u82908731)
        id 4873C98300403D01 for linux-wireless@vger.kernel.org; Wed, 30 Jul 2008 11:44:21 +0200
Message-ID: <489037EC.4020306@gmail.com> (sfid-20080730_125358_206953_C269049D)
Date: Wed, 30 Jul 2008 11:44:12 +0200
From: johan henriksson <jhn98032@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: RTL8187: RTL8187B with id 0bda:8198
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I am trying to get the wireless card on a Toshiba Satellite L350
to work. The laptop uses a RTL8187b chip but unfortunately with an id of 0bda:8198.
I have tried the RTL8187 driver in the 2.6.27-rc1 release.
To make the driver accept the card I had to add the productid 8198 to the driver.
Now the card is detected and seems to work. I can ping another computer on the network
but for some reason the network just stops working after about 6 seconds.
There are no errors in the kernel log and if I reconnect with "iwconfig wlan0 essid myNet" the card 
works again for another 6 seconds.
I am starting to suspect that the RTL8187b has a watchdog timer like the RTL8181 that times out?
Does anybody have the datasheet for the RTL8187b?

Regards
Johan Henriksson

    /proc/bus/usb/devices
-------------------------
T:  Bus=02 Lev=01 Prnt=01 Port=05 Cnt=01 Dev#=  2 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=8198 Rev= 2.00
S:  Manufacturer=Manufacturer_Realtek
S:  Product=RTL8187B_WLAN_Adapter
S:  SerialNumber=00e04c000001
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 9 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0c(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

   kernel log
---------------------------
[   25.947358] rtl8187: 8187B chip detected. Support is EXPERIMENTAL, and could damage your
[   25.947363]          hardware, use at your own risk
[   25.958701] phy0: Selected rate control algorithm 'pid'
[   26.044629] phy0: hwaddr 00:1b:9e:ff:f4:03, RTL8187BvE V0 + rtl8225z2
[   26.057455] usbcore: registered new interface driver rtl8187
[   39.147086] wlan0: authenticate with AP 00:1b:2f:6b:48:4e
[   39.148826] wlan0: authenticated
[   39.148949] wlan0: associate with AP 00:1b:2f:6b:48:4e
[   39.151006] wlan0: RX AssocResp from 00:1b:2f:6b:48:4e (capab=0x431 status=0 aid=1)
[   39.151098] wlan0: associated



