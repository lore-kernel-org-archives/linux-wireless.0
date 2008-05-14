Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:50362 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbYENDO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 23:14:27 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3025456wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 20:14:27 -0700 (PDT)
Message-ID: <c785bba30805132014y56aafa7bi8788503f67a7c809@mail.gmail.com> (sfid-20080514_051434_355556_8D94AE6A)
Date: Tue, 13 May 2008 20:14:26 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: newbie rtl8187 question
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am trying to get the Trendnet TEW-424UB to work. I have hardware
version 3.1R which is based on the Realtek RTL8187B chip. I got the
latest wireless-testing git version. I added the Trendnet PID & VID to
drivers/net/wireless/rtl8187_dev.c (shown below) but I still can't it
to work.

static struct usb_device_id rtl8187_table[] __devinitdata = {
        /* Realtek */
        {USB_DEVICE(0x0bda, 0x8187)},
        /* Netgear */
        {USB_DEVICE(0x0846, 0x6100)},
        {USB_DEVICE(0x0846, 0x6a00)},
        /* HP */
        {USB_DEVICE(0x03f0, 0xca02)},
        /*Trendnet Vendor=0bda ProdID=8189*/
        {USB_DEVICE(0x0bda, 0x8189)},
        /* Sitecom */
        {USB_DEVICE(0x0df6, 0x000d)},
        {}
};

When I plug the adapter in I get this under /proc/bus/usb/devices

T:  Bus=02 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  3 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=8189 Rev= 2.00
S:  Manufacturer=Manufacturer_Realtek
S:  Product=RTL8187B_WLAN_Adapter
S:  SerialNumber=00e04c000001
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 9 Cls=ff(vend.) Sub=ff Prot=ff Driver=rtl8187
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0c(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

The only other time I used wireless stuff under linux I used a distros
built in tools, so I hope I'm doing the config correctly. Here is what
I'm doing:

/sbin/iwconfig wlan0 key restricted MYKEY essid "ssid"
/sbin/ifconfig wlan0 up
/sbin/dhclient wlan0

Now #/sbin/iwconfig gives me this:
wlan0     IEEE 802.11  ESSID:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
          Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:XXXX-XXXX-XX
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

I am using Fedora 8 on a x86_64 system. My initial goal in all this
was to get the adapter to work with my embedded linux project
(http://opencircuits.com/Linuxstamp), but when it didn't work there I
figured I'd try it on my host machine.

Has anyone else gotten the TEW-424UB to work?

thanks
Paul
