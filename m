Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cwm83.internetdsl.tpnet.pl ([83.19.120.83]:1438 "EHLO
	szyszka.in.waw.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYCAKqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 05:46:32 -0500
Received: from zbyszek by szyszka.in.waw.pl with local (Exim 4.67)
	(envelope-from <zbyszek@in.waw.pl>)
	id 1JVOwP-0004ul-Qk
	for linux-wireless@vger.kernel.org; Sat, 01 Mar 2008 11:27:41 +0100
Date: Sat, 1 Mar 2008 11:27:41 +0100
To: linux-wireless@vger.kernel.org
Subject: problem with b43 (bcm43xx works)
Message-ID: <20080301102741.GA18825@szyszka.in.waw.pl> (sfid-20080301_104636_607793_7E949E67)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Zbyszek Szmek <zbyszek@in.waw.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I have trouble getting b43 to work with my card. The trouble 
seems to be with the transmit/receive power, but I have no 
idea what to try next.

The card is:
lspci -vvnn -s 01:06.0
01:06.0 Network controller [0280]: Broadcom Corporation BCM4318 [AirForce One 54g] 802.11g Wireless LAN 
Controller [14e4:4318] (rev 02)
	Subsystem: ASUSTeK Computer Inc. Unknown device [1043:100f]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fdffe000 (32-bit, non-prefetchable) [size=8K]

When I use the old driver, in dmesg I get:
bcm43xx: Chip ID 0x4318, rev 0x2
bcm43xx: Number of cores: 4
bcm43xx: Core 0: ID 0x800, rev 0xd, vendor 0x4243
bcm43xx: Core 1: ID 0x812, rev 0x9, vendor 0x4243
bcm43xx: Core 2: ID 0x804, rev 0xc, vendor 0x4243
bcm43xx: Core 3: ID 0x80d, rev 0x7, vendor 0x4243
bcm43xx: PHY connected
bcm43xx: Detected PHY: Analog: 3, Type 2, Revision 7
bcm43xx: Detected Radio: ID: 8205017f (Manuf: 17f Ver: 2050 Rev: 8)
bcm43xx: Radio initialized
bcm43xx: Radio initialized
bcm43xx: Microcode rev 0x127, pl 0xe (2005-04-18  02:36:27)
bcm43xx: Radio turned on
bcm43xx: Radio enabled by hardware
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at: 
/home/asia/linuxx/2625/drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1489:bcm43xx_find_lopair()
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at: 
/home/asia/linuxx/2625/drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1489:bcm43xx_find_lopair()
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at: 
/home/asia/linuxx/2625/drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1489:bcm43xx_find_lopair()
bcm43xx: Chip initialized
bcm43xx: 32-bit DMA initialized
bcm43xx: Keys cleared
bcm43xx: Selected 802.11 core (phytype 2)
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at: 
/home/asia/linuxx/2625/drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1489:bcm43xx_find_lopair()
SoftMAC: Scanning finished: scanned 13 channels starting with channel 1
SoftMAC: Associate: Scanning for networks first.
SoftMAC: Scanning finished: scanned 13 channels starting with channel 1
SoftMAC: Queueing Authentication Request to 00:1a:70:6e:cc:24
SoftMAC: Cannot associate without being authenticated, requested authentication
SoftMAC: Sent Authentication Request to 00:1a:70:6e:cc:24.
SoftMAC: Open Authentication completed with 00:1a:70:6e:cc:24
SoftMAC: sent association request!
SoftMAC: associated!

and iwlist scan gives me:
wlan0     Scan completed :
          Cell 01 - Address: 00:1A:70:6E:CC:24
                    ESSID:"linksys"
                    Protocol:IEEE 802.11bg
                    Mode:Master
                    Frequency:2.462 GHz (Channel 11)
                    Encryption key:off
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
                              11 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                              48 Mb/s; 54 Mb/s
                    Quality=90/100  Signal level=-41 dBm  Noise level=-62 dBm
                    Extra: Last beacon: 96ms ago
          Cell 02 - Address: 00:18:4D:8A:F8:20
                    ESSID:"ishar"
                    Protocol:IEEE 802.11bg
                    Mode:Master
                    Frequency:2.462 GHz (Channel 11)
                    Encryption key:off
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
                              11 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                              48 Mb/s; 54 Mb/s
                    Quality=80/100  Signal level=-58 dBm  Noise level=-62 dBm
                    Extra: Last beacon: 24ms ago

When I try the new driver:
b43-phy0: Broadcom 4318 WLAN found
b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 8
b43-phy0 debug: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 debug: Tuning TX-power to bbatt(2), rfatt(10), tx_control(0x00), tx_bias(0x00), tx_magn(0x00)
b43-phy0 debug: Tuning TX-power to bbatt(11), rfatt(15), tx_control(0x00), tx_bias(0x00), tx_magn(0x70)
b43-phy0 debug: Tuning TX-power to bbatt(2), rfatt(10), tx_control(0x00), tx_bias(0x00), tx_magn(0x70)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
b43-phy0 debug: Wireless interface started
HW CONFIG: channel=1 freq=2412 phymode=2
b43-phy0 debug: Adding Interface type 2
ADDRCONF(NETDEV_UP): wlan0: link is not ready
b43-phy0 debug: max_used_slots increased to 1 on RX ring 0
HW CONFIG: channel=1 freq=2412 phymode=2
b43-phy0 debug: max_used_slots increased to 1 on TX ring 1
b43-phy0 debug: max_used_slots increased to 2 on TX ring 1
b43-phy0 debug: Injecting TX ring overflow on DMA controller 1
b43-phy0 debug: Stopped TX ring 1
HW CONFIG: channel=2 freq=2417 phymode=2
HW CONFIG: channel=3 freq=2422 phymode=2
HW CONFIG: channel=4 freq=2427 phymode=2
HW CONFIG: channel=5 freq=2432 phymode=2
HW CONFIG: channel=6 freq=2437 phymode=2
HW CONFIG: channel=7 freq=2442 phymode=2
HW CONFIG: channel=8 freq=2447 phymode=2
HW CONFIG: channel=9 freq=2452 phymode=2
HW CONFIG: channel=10 freq=2457 phymode=2
HW CONFIG: channel=11 freq=2462 phymode=2
HW CONFIG: channel=1 freq=2412 phymode=2
HW CONFIG: channel=11 freq=2462 phymode=2
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1a:70:6e:cc:24
wlan0: authenticate with AP 00:1a:70:6e:cc:24
wlan0: authenticate with AP 00:1a:70:6e:cc:24
wlan0: authentication with AP 00:1a:70:6e:cc:24 timed out

and iwlist scan:
wlan0     Scan completed :
          Cell 01 - Address: 00:1A:70:6E:CC:24
                    ESSID:"linksys"
                    Mode:Master
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=46/100  Signal level=-66 dBm  Noise level=0 dBm
                    Encryption key:off
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
                              12 Mb/s; 48 Mb/s
                    Extra:tsf=000000076600118b
          Cell 02 - Address: 00:18:4D:8A:F8:20
                    ESSID:"ishar"
                    Mode:Master
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=60/100  Signal level=-52 dBm  Noise level=0 dBm
                    Encryption key:off
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
                              12 Mb/s; 48 Mb/s
                    Extra:tsf=0000009c7a9b2185


Any ideas?

Thanks,
Zbyszek Szmek

