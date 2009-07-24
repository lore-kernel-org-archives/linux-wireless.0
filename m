Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:42580 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZGXIN7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 04:13:59 -0400
Message-ID: <4A696D33.8050606@promwad.com>
Date: Fri, 24 Jul 2009 11:13:39 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
Reply-To: ivan.kuten@promwad.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: WPA2, compat-wireless-2.6.31-rc3, kernel 2.6.28 - rtl8187 -
 association works but no ping
References: <4A682BBD.90101@promwad.com> <43e72e890907230917w226c4697v41f907623e5f7d8@mail.gmail.com>
In-Reply-To: <43e72e890907230917w226c4697v41f907623e5f7d8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu, Jul 23, 2009 at 2:22 AM, Ivan Kuten<ivan.kuten@promwad.com> wrote:
>> compat-wireless-2.6.31-rc3
> 
> compat-wireless-2.6.31-rc4 is out, please try that.
> 
>   Luis
> 

Here is what I get for compat-wireless-2.6.31-rc4:


<6>cfg80211: Using static regulatory domain info
<6>cfg80211: Regulatory domain: US
<6>     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
<6>     (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
<6>     (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
<6>     (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
<6>     (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
<6>     (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
<6>     (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
<6>usb 1-1: new high speed USB device using isp1761 and address 2
<6>cfg80211: Calling CRDA for country: US
<6>usbcore: registered new interface driver rtl8187
<6>usb 1-1: configuration #1 chosen from 1 choice
<6>hub 1-1:1.0: USB hub found
<6>hub 1-1:1.0: 3 ports detected
<6>usb 1-1.1: new high speed USB device using isp1761 and address 3
<6>usb 1-1.1: configuration #1 chosen from 1 choice
<7>phy0: Selected rate control algorithm 'minstrel'
<6>phy0: hwaddr 00277080, RTL8187vB (default) V1 + rtl8225z2
<7>phy0: device now idle
<7>phy0: device no longer idle - scanning
<7>phy0: device now idle
<7>phy0: device no longer idle - in use
<7>wlan0: authenticate with AP 01a4b568
<7>wlan0: authenticated
<7>wlan0: associate with AP 01a4b568
<7>wlan0: RX AssocResp from 003e101a (capab=0x411 status=0 aid=2)
<7>wlan0: associated
<7>phy0: Allocated STA 002fbfc4
<7>phy0: Inserted STA 002fbfc4
<7>wlan0: switched to short slot time (BSSID=01a4b568)

iwconfig output:

lo        no wireless extensions.

eth0      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"ACORP"
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:02:72:74:AC:85
          Bit Rate=1 Mb/s   Tx-Power=27 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:2BAC-63B9-5D99-CF9A-4D39-079F-BB55-5D39 [2]
          Power Management:off
          Link Quality=61/70  Signal level=-49 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


ifconfig:

eth0      Link encap:Ethernet  HWaddr 02:80:AD:20:31:EB
          inet addr:192.168.5.1  Bcast:192.168.5.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:40 errors:0 dropped:0 overruns:0 frame:0
          TX packets:188 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:4077 (3.9 KiB)  TX bytes:17012 (16.6 KiB)

wlan0     Link encap:Ethernet  HWaddr 00:12:0E:98:67:FC
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:2 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:304 (304.0 B)  TX bytes:3932 (3.8 KiB)

wmaster0  Link encap:UNSPEC  HWaddr 00-12-0E-98-67-FC-00-00-00-00-00-00-00-00-00-00
          UP RUNNING  MTU:0  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

Neither dhcp nor setting static IP for wlan0 - no ping.

Regards,
Ivan
