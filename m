Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:8614 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbZCQNSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 09:18:25 -0400
Received: by fk-out-0910.google.com with SMTP id 18so20196fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 06:18:21 -0700 (PDT)
Message-ID: <49BFA363.7050407@gmail.com> (sfid-20090317_141837_588404_42C12315)
Date: Tue, 17 Mar 2009 14:19:31 +0100
From: Hinkocevar <hinkocevar@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: bcm4311 gentoo problems
References: <49BCEBF0.8010006@gmail.com>
In-Reply-To: <49BCEBF0.8010006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hinkocevar wrote:
> Hi,
> 
> I have a dell inspiron 6400 with built-in wifi card from broadcom - 
> BCM4311:
> 
> # lspci
> 0b:00.0 Network controller: Broadcom Corporation BCM4311 802.11b/g WLAN 
> (rev 01)
> 
> # lspci -vn
> 
> 0b:00.0 0280: 14e4:4311 (rev 01)
>     Subsystem: 1028:0007
>     Flags: bus master, fast devsel, latency 0, IRQ 16
>     Memory at efdfc000 (32-bit, non-prefetchable) [size=16K]
>     Capabilities: [40] Power Management version 2
>     Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- 
> Count=1/1 Enable-
>     Capabilities: [d0] Express Legacy Endpoint, MSI 00
>     Capabilities: [100] Advanced Error Reporting
>         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
> RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
>         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
> RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
>         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
>         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>         AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
>     Capabilities: [13c] Virtual Channel <?>
>     Kernel driver in use: b43-pci-bridge
> 
> 
> Runnig gentoo kernel version 2.6.27-gentoo-r8 does not correctly work 
> with the wifi card. I can see the is detected and registered in the 
> system as wlan0 interface, but it does not get associated!
> The same goes for latest GIT wireless tree. (I followed the instructions 
> on http://linuxwireless.org/en/users/Drivers/b43.)
> 
> 
> dellboi wireless-2.6 # modprobe b43
> dellboi wireless-2.6 # ifconfig wlan0 down
> dellboi wireless-2.6 # iwconfig wlan0 mode managed channel 10
> dellboi wireless-2.6 # iwconfig wlan0 essid Prospero632_0a_55_89
> dellboi wireless-2.6 # ifconfig wlan0 up
> dellboi wireless-2.6 # iwconfig
> lo        no wireless extensions.
> 
> eth0      no wireless extensions.
> 
> wmaster0  no wireless extensions.
> 
> wlan0     IEEE 802.11bg  ESSID:"Prospero632_0a_55_89"
>           Mode:Managed  Frequency:2.457 GHz  Access Point: Not-Associated
>           Tx-Power=off
>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>           Encryption key:off
>           Power Management:off
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> dellboi wireless-2.6 # dhcpcd wlan0
> wlan0: dhcpcd 4.0.7 starting
> wlan0: waiting for carrier
>     wlan0: timed out
> 
> 
> I can confirm, that ESSID and the AP in question is indeed working, as 
> it does on another notebook in the same room.
> 
> Here is some more info:
> Mar 15 12:04:40 dellboi dhcpcd[6755]: wlan0: dhcpcd 4.0.7 starting
> Mar 15 12:04:40 dellboi [  472.204089] b43-phy0: Loading firmware 
> version 410.2160 (2007-05-26 15:32:10)
> Mar 15 12:04:40 dellboi [  472.264103] b43-phy0 debug: Chip initialized
> Mar 15 12:04:40 dellboi [  472.264266] b43-phy0 debug: 32-bit DMA 
> initialized
> Mar 15 12:04:40 dellboi [  472.284973] b43-phy0 debug: Wireless 
> interface started
> Mar 15 12:04:40 dellboi [  472.292458] b43-phy0 debug: Adding Interface 
> type 2
> Mar 15 12:04:40 dellboi dhcpcd[6755]: wlan0: waiting for carrier
> Mar 15 12:04:44 dellboi dhcpcd[6755]: wlan0: timed out
> Mar 15 12:04:56 dellboi [  487.853048] b43-phy0 debug: Removing 
> Interface type 2
> Mar 15 12:04:56 dellboi [  487.865409] b43-phy0 debug: Wireless 
> interface stopped
> Mar 15 12:04:56 dellboi [  487.865951] b43-phy0 debug: DMA-32 rx_ring: 
> Used slots 0/64, Failed frames 0/0 = 0.0%, Average tries 0.00
> Mar 15 12:04:56 dellboi [  487.866008] b43-phy0 debug: DMA-32 
> tx_ring_AC_BK: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 
> 0.00
> Mar 15 12:04:56 dellboi [  487.873073] b43-phy0 debug: DMA-32 
> tx_ring_AC_BE: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 
> 0.00
> Mar 15 12:04:56 dellboi [  487.881048] b43-phy0 debug: DMA-32 
> tx_ring_AC_VI: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 
> 0.00
> Mar 15 12:04:56 dellboi [  487.889082] b43-phy0 debug: DMA-32 
> tx_ring_AC_VO: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 
> 0.00
> Mar 15 12:04:56 dellboi [  487.897047] b43-phy0 debug: DMA-32 
> tx_ring_mcast: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 
> 0.00
> Mar 15 12:05:36 dellboi [  528.757101] cfg80211: Using static regulatory 
> domain info
> Mar 15 12:05:36 dellboi [  528.757104] cfg80211: Regulatory domain: US
> Mar 15 12:05:36 dellboi [  528.757106]     (start_freq - end_freq @ 
> bandwidth), (max_antenna_gain, max_eirp)
> Mar 15 12:05:36 dellboi [  528.757109]     (2402000 KHz - 2472000 KHz @ 
> 40000 KHz), (600 mBi, 2700 mBm)
> Mar 15 12:05:36 dellboi [  528.757112]     (5170000 KHz - 5190000 KHz @ 
> 40000 KHz), (600 mBi, 2300 mBm)
> Mar 15 12:05:36 dellboi [  528.757115]     (5190000 KHz - 5210000 KHz @ 
> 40000 KHz), (600 mBi, 2300 mBm)
> Mar 15 12:05:36 dellboi [  528.757117]     (5210000 KHz - 5230000 KHz @ 
> 40000 KHz), (600 mBi, 2300 mBm)
> Mar 15 12:05:36 dellboi [  528.757120]     (5230000 KHz - 5330000 KHz @ 
> 40000 KHz), (600 mBi, 2300 mBm)
> Mar 15 12:05:36 dellboi [  528.757122]     (5735000 KHz - 5835000 KHz @ 
> 40000 KHz), (600 mBi, 3000 mBm)
> Mar 15 12:05:36 dellboi [  528.757125] cfg80211: Calling CRDA for 
> country: US
> Mar 15 12:05:37 dellboi [  528.783251] b43-phy0: Broadcom 4311 WLAN found
> Mar 15 12:05:37 dellboi [  528.825058] b43-phy0 debug: Found PHY: Analog 
> 4, Type 2, Revision 8
> Mar 15 12:05:37 dellboi [  528.825086] b43-phy0 debug: Found Radio: 
> Manuf 0x17F, Version 0x2050, Revision 2
> Mar 15 12:05:37 dellboi [  528.848302] wmaster0 (b43): not using 
> net_device_ops yet
> Mar 15 12:05:37 dellboi [  528.848388] phy0: Selected rate control 
> algorithm 'minstrel'
> Mar 15 12:05:37 dellboi [  528.848405] wlan0 (b43): not using 
> net_device_ops yet
> Mar 15 12:05:37 dellboi [  528.848487] Broadcom 43xx driver loaded [ 
> Features: P, Firmware-ID: FW13 ]
> Mar 15 12:05:54 dellboi [  545.973084] b43 ssb0:0: firmware: requesting 
> b43/ucode5.fw
> Mar 15 12:05:54 dellboi [  545.976387] b43 ssb0:0: firmware: requesting 
> b43/pcm5.fw
> Mar 15 12:05:54 dellboi [  545.980187] b43 ssb0:0: firmware: requesting 
> b43/b0g0initvals5.fw
> Mar 15 12:05:54 dellboi [  545.983994] b43 ssb0:0: firmware: requesting 
> b43/b0g0bsinitvals5.fw
> Mar 15 12:05:54 dellboi [  546.100095] b43-phy0: Loading firmware 
> version 410.2160 (2007-05-26 15:32:10)
> Mar 15 12:05:54 dellboi [  546.172118] b43-phy0 debug: Chip initialized
> Mar 15 12:05:54 dellboi [  546.172291] b43-phy0 debug: 32-bit DMA 
> initialized
> Mar 15 12:05:54 dellboi [  546.192982] b43-phy0 debug: Wireless 
> interface started
> Mar 15 12:05:54 dellboi [  546.204492] b43-phy0 debug: Adding Interface 
> type 2
> Mar 15 12:05:54 dellboi [  546.236068] b43-phy0: Radio turned on by 
> software
> 
> Any comments?
> 

I've found the culprit!
The problem was that I had to enable internal bluetooth AND internal 
WiFi modules on my notebook as they seem to be more closely linked that 
I've suspected.

dellboi moee # /etc/init.d/net.wlan0 start
  * Starting wlan0
  *   Configuring wireless network for wlan0
  *     wlan0 connected to ESSID "Prospero632_0a_55_89" at 00:19:70:0A:55:89
  *     in managed mode on channel 10 (WEP disabled)
  *   Bringing up wlan0
  *     dhcp
  *       Running dhcpcd ...
wlan0: dhcpcd 4.0.7 starting
wlan0: broadcasting for a lease
wlan0: offered 192.168.1.5 from 192.168.1.1
wlan0: checking 192.168.1.5 is available on attached networks
wlan0: acknowledged 192.168.1.5 from 192.168.1.1
wlan0: leased 192.168.1.5 for 43200 seconds 
      [ ok ]
  *       wlan0 received address 192.168.1.5/24


And some iwlist wlan0 scan results:
dellboi moee # iwlist wlan0 scanning
wlan0     Scan completed :
           Cell 01 - Address: 00:17:31:ED:D6:EE
                     ESSID:"majkic air"
                     Mode:Master
                     Channel:1
                     Frequency:2.412 GHz (Channel 1)
                     Quality=63/100  Signal level:-72 dBm  Noise 
level=-70 dBm
                     Encryption key:on
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                               24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
                               12 Mb/s; 48 Mb/s
                     Extra:tsf=00000152a5ddb189
                     Extra: Last beacon: 592ms ago
           Cell 02 - Address: 00:19:70:0A:55:89
                     ESSID:"Prospero632_0a_55_89"
                     Mode:Master
                     Channel:10
                     Frequency:2.457 GHz (Channel 10)
                     Quality=90/100  Signal level:-45 dBm  Noise 
level=-70 dBm
                     Encryption key:off
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                               9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                               48 Mb/s; 54 Mb/s
                     Extra:tsf=0000003424f341e2
                     Extra: Last beacon: 28ms ago
           Cell 03 - Address: 00:19:70:0A:55:59
                     ESSID:"miroslav"
                     Mode:Master
                     Channel:8
                     Frequency:2.447 GHz (Channel 8)
                     Quality=56/100  Signal level:-78 dBm  Noise 
level=-70 dBm
                     Encryption key:on
                     IE: WPA Version 1
                         Group Cipher : TKIP
                         Pairwise Ciphers (1) : TKIP
                         Authentication Suites (1) : PSK
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                               9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                               48 Mb/s; 54 Mb/s
                     Extra:tsf=0000009b9d2ba1f5
                     Extra: Last beacon: 292ms ago
           Cell 04 - Address: 00:90:D0:EA:6F:23
                     ESSID:"SpeedTouch33F545"
                     Mode:Master
                     Channel:11
                     Frequency:2.462 GHz (Channel 11)
                     Quality=56/100  Signal level:-78 dBm  Noise 
level=-70 dBm
                     Encryption key:on
                     IE: WPA Version 1
                         Group Cipher : TKIP
                         Pairwise Ciphers (1) : TKIP
                         Authentication Suites (1) : PSK
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                               24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
                               12 Mb/s; 48 Mb/s
                     Extra:tsf=00000030f734a39c
                     Extra: Last beacon: 104ms ago
           Cell 05 - Address: 00:19:70:0F:37:7F
                     ESSID:"peterka"
                     Mode:Master
                     Channel:2
                     Frequency:2.417 GHz (Channel 2)
                     Quality=51/100  Signal level:-83 dBm  Noise 
level=-70 dBm
                     Encryption key:on
                     IE: WPA Version 1
                         Group Cipher : TKIP
                         Pairwise Ciphers (1) : TKIP
                         Authentication Suites (1) : PSK
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
                     Extra:tsf=00000029094921e0
                     Extra: Last beacon: 740ms ago
           Cell 06 - Address: 00:18:F8:A7:AD:A8
                     ESSID:"UNUK"
                     Mode:Master
                     Channel:11
                     Frequency:2.462 GHz (Channel 11)
                     Quality=55/100  Signal level:-80 dBm  Noise 
level=-70 dBm
                     Encryption key:on
                     IE: WPA Version 1
                         Group Cipher : TKIP
                         Pairwise Ciphers (1) : TKIP
                         Authentication Suites (1) : PSK
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                               9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                               48 Mb/s; 54 Mb/s
                     Extra:tsf=000000310137ad2f
                     Extra: Last beacon: 100ms ago
           Cell 07 - Address: 00:19:70:0A:55:67
                     ESSID:"Prospero632_0a_55_67"
                     Mode:Master
                     Channel:2
                     Frequency:2.417 GHz (Channel 2)
                     Quality=51/100  Signal level:-83 dBm  Noise 
level=-70 dBm
                     Encryption key:off
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                               9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                               48 Mb/s; 54 Mb/s
                     Extra:tsf=000000df539371e3
                     Extra: Last beacon: 704ms ago
           Cell 08 - Address: 00:0E:2E:AE:2F:44
                     ESSID:"JANTY"
                     Mode:Master
                     Channel:11
                     Frequency:2.462 GHz (Channel 11)
                     Quality=51/100  Signal level:-83 dBm  Noise 
level=-70 dBm
                     Encryption key:on
                     IE: WPA Version 1
                         Group Cipher : TKIP
                         Pairwise Ciphers (1) : TKIP
                         Authentication Suites (1) : PSK
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                               9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                               48 Mb/s; 54 Mb/s
                     Extra:tsf=000000310097a19b
                     Extra: Last beacon: 128ms ago



Thank you,
Hinko
