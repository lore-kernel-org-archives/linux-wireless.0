Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:10329 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbYBDUWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 15:22:31 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2042858fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 12:22:30 -0800 (PST)
Message-ID: <12385bbd0802041222y3dfbbfc7rd5e44bd1597e918d@mail.gmail.com> (sfid-20080204_202237_785984_79E84A98)
Date: Mon, 4 Feb 2008 23:22:30 +0300
From: "Ivan Volosyuk" <ivan.volosyuk@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: b43 fails to associate
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have wifi card on BCM4318 chipset which is supported by b43 modules.
Still it fails to associate with my wireless access point (open/no
keys setup). I have another linux box which works fine with the access
point using ipw2200 module. iwevent shows in a loop:
 23:12:28.932580   wlan0    Scan request completed
23:12:28.932684   wlan0    Set Mode:Managed
23:12:28.941850   wlan0    Set Frequency:2.422 GHz (Channel 3)
23:12:28.941866   wlan0    Set ESSID:"Home2"

iwconfig:
wlan0     IEEE 802.11  ESSID:"Home2"
          Mode:Managed  Frequency:2.422 GHz  Access Point: 00:1A:92:7E:1D:93
          Tx-Power=0 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
           Encryption key:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

iwlist finds the access point:
wlan0     Scan completed :
          Cell 01 - Address: 00:1A:92:7E:1D:93
                    ESSID:"Home2"
                    Mode:Master
                    Frequency:2.422 GHz (Channel 3)
                     Channel:3
                    Quality=60/100  Signal level=-52 dBm  Noise level=-51 dBm
                    Encryption key:off
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                               24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
                              12 Mb/s; 48 Mb/s
                    Extra:tsf=000000172559118a

I have already tried vanila 2.6.24 and patch set 'everything' from
wireless-dev.git, no luck. I have no idea how to get more debug info,
to track down the problem. Is it know problem with the driver or
should I try some tweaks?

-- 
Thanks,
Ivan

p.s. Here is a snippet from dmesg:

b43-phy0 debug: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
 b43-phy0 debug: Wireless interface started
phy0: HW CONFIG: freq=2412
b43-phy0 debug: Adding Interface type 2
phy0: HW CONFIG: freq=2412
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2417
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2422
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2427
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2432
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2437
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2442
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2447
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2452
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2457
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2462
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2412
phy0: HW CONFIG: freq=2412
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2417
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2422
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2427
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2432
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2437
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2442
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2447
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2452
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2457
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2462
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2412
phy0: HW CONFIG: freq=2412
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2417
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2422
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2427
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2432
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2437
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2442
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2447
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2452
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2457
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2462
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2412
phy0: HW CONFIG: freq=2412
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2417
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2422
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2427
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2432
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2437
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2442
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2447
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2452
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2457
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2462
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2412
phy0: HW CONFIG: freq=2412
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2417
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2422
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2427
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2432
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2437
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2442
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2447
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2452
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2457
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2462
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2412
phy0: HW CONFIG: freq=2422
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1a:92:7e:1d:93
phy0: TX to low-level driver (len=30) FC=0x00b0 DUR=0x013a
A1=00:1a:92:7e:1d:93 A2=00:1d:60:eb:a4:4a A3=00:1a:92:7e:1d:93
 wlan0: authenticate with AP 00:1a:92:7e:1d:93
phy0: TX to low-level driver (len=30) FC=0x00b0 DUR=0x013a
A1=00:1a:92:7e:1d:93 A2=00:1d:60:eb:a4:4a A3=00:1a:92:7e:1d:93
wlan0: authenticate with AP 00:1a:92:7e:1d:93
 phy0: TX to low-level driver (len=30) FC=0x00b0 DUR=0x013a
A1=00:1a:92:7e:1d:93 A2=00:1d:60:eb:a4:4a A3=00:1a:92:7e:1d:93
wlan0: authentication with AP 00:1a:92:7e:1d:93 timed out
phy0: HW CONFIG: freq=2412
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2417
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2422
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2427
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2432
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
 phy0: HW CONFIG: freq=2437
phy0: TX to low-level driver (len=42) FC=0x0040 DUR=0x0000
A1=ff:ff:ff:ff:ff:ff A2=00:1d:60:eb:a4:4a A3=ff:ff:ff:ff:ff:ff
phy0: HW CONFIG: freq=2442
phy0: HW CONFIG: freq=2447
phy0: HW CONFIG: freq=2452
 phy0: HW CONFIG: freq=2457
phy0: HW CONFIG: freq=2462
phy0: HW CONFIG: freq=2422
phy0: HW CONFIG: freq=2422
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1a:92:7e:1d:93
wlan0: Initial auth_alg=0
 wlan0: authenticate with AP 00:1a:92:7e:1d:93
wlan0: authenticate with AP 00:1a:92:7e:1d:93
wlan0: authenticate with AP 00:1a:92:7e:1d:93
wlan0: authentication with AP 00:1a:92:7e:1d:93 timed out
phy0: HW CONFIG: freq=2412
 phy0: HW CONFIG: freq=2417
phy0: HW CONFIG: freq=2422
phy0: HW CONFIG: freq=2427
phy0: HW CONFIG: freq=2432
phy0: HW CONFIG: freq=2437
phy0: HW CONFIG: freq=2442
phy0: HW CONFIG: freq=2447
phy0: HW CONFIG: freq=2452
 phy0: HW CONFIG: freq=2457
phy0: HW CONFIG: freq=2462
phy0: HW CONFIG: freq=2422
phy0: HW CONFIG: freq=2422
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1a:92:7e:1d:93
wlan0: Initial auth_alg=0
 wlan0: authenticate with AP 00:1a:92:7e:1d:93
wlan0: authenticate with AP 00:1a:92:7e:1d:93
wlan0: authenticate with AP 00:1a:92:7e:1d:93
wlan0: authentication with AP 00:1a:92:7e:1d:93 timed out
phy0: HW CONFIG: freq=2412
 phy0: HW CONFIG: freq=2417
phy0: HW CONFIG: freq=2422
phy0: HW CONFIG: freq=2427
phy0: HW CONFIG: freq=2432
phy0: HW CONFIG: freq=2437
phy0: HW CONFIG: freq=2442
