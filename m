Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host.zinkconsulting.com ([209.59.162.221]:48006 "EHLO
	host.zinkconsulting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761663AbZE2QLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 12:11:35 -0400
Received: from c-24-20-185-90.hsd1.wa.comcast.net ([24.20.185.90] helo=[192.168.77.3])
	by host.zinkconsulting.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.69)
	(envelope-from <galen@zinkconsulting.com>)
	id 1MA4gC-0005jX-BT
	for linux-wireless@vger.kernel.org; Fri, 29 May 2009 12:11:36 -0400
Message-Id: <74C73DFF-F3D6-487F-A279-1F6D142846A5@zinkconsulting.com>
From: Galen P Zink <galen@zinkconsulting.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Ath9k Can't Detect 802.11n Access Points / Refuses To Use Channels 100-140
Date: Fri, 29 May 2009 09:11:34 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under stock Ubuntu 9.04, my AR5008 card is picked up and sees my 5 GHz  
802.11n access points, as well as my 802.11g access points. I do not  
know the precise driver configuration (just booted live disc) but  
clearly this demonstrates the card is working fine. OS X also agrees.

Under Debian with a 2.6.29-2 kernel and compat-wireless built from  
yesterday's nightly, CRDA and regulatory.bin, I cannot pick up my  
802.11n access points on channels 149 and 157. Moreover, I am having  
weird problems with channels being disabled that should not be  
disabled, e.g. everything from 100 to 140 is disabled, even though my  
regulatory domain allows those channels. I thought this was a DFS  
issue, but 52-64 requires DFS and those channels ARE enabled, so I  
doubt that's the case.

Can anybody clarify the situation here?!

-Galen

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below follows output from the machine:

hackbookpro-debian:~# uname -a
Linux hackbookpro-debian 2.6.29-2-686-bigmem #1 SMP Sun May 17  
19:06:25 UTC 2009 i686 GNU/Linux

hackbookpro-debian:~# modinfo ath9k
filename:       /lib/modules/2.6.29-2-686-bigmem/updates/drivers/net/ 
wireless/ath/ath9k/ath9k.ko
license:        Dual BSD/GPL
description:    Support for Atheros 802.11n wireless LAN cards.
author:         Atheros Communications
alias:          pci:v0000168Cd0000002Bsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Asv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000029sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000027sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000024sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000023sv*sd*bc*sc*i*
depends:        led-class,mac80211,ath,rfkill,cfg80211
vermagic:       2.6.29-2-686-bigmem SMP mod_unload modversions 686
parm:           nohwcrypt:Disable hardware encryption (int)
parm:           btcoex_enable:Enable Bluetooth coexistence support  
(bool)

hackbookpro-debian:~# iw reg get
country US:
	(2402 - 2472 @ 40), (3, 27)
	(5170 - 5250 @ 40), (3, 17)
	(5250 - 5330 @ 40), (3, 20), DFS
	(5490 - 5710 @ 40), (3, 20), DFS
	(5735 - 5835 @ 40), (3, 30)

dmesg output of interest:
[    8.808216] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) ->  
IRQ 17
[    8.808231] ath9k 0000:03:00.0: setting latency timer to 64
[    8.937198] ath: Country alpha2 being used: 00
[    8.937201] ath: Regpair detected: 0x64
[    8.963127] phy0: Selected rate control algorithm  
'ath9k_rate_control'
[    8.963407] Registered led device: ath9k-phy0::radio
[    8.963422] Registered led device: ath9k-phy0::assoc
[    8.963436] Registered led device: ath9k-phy0::tx
[    8.963451] Registered led device: ath9k-phy0::rx
[    8.963470] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81:  
mem=0xf8560000, irq=17
[    7.596099] cfg80211: Using static regulatory domain info
[    7.596104] cfg80211: Regulatory domain: US
[    7.596108] 	(start_freq - end_freq @ bandwidth),  
(max_antenna_gain, max_eirp)
[    7.596114] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,  
2700 mBm)
[    7.596120] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi,  
2300 mBm)
[    7.596125] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi,  
2300 mBm)
[    7.596160] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi,  
2300 mBm)
[    7.596166] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi,  
2300 mBm)
[    7.596171] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi,  
3000 mBm)
[    7.596287] cfg80211: Calling CRDA for country: US

hackbookpro-debian:~# ls -l /usr/lib/crda
total 4
-rw-r--r-- 1 root root 3084 2009-05-28 15:28 regulatory.bin

hackbookpro-debian:~# iw list
Wiphy phy0
	Band 1:
		HT capabilities: 0x104e
			* 20/40 MHz operation
			* SM PS disabled
			* 40 MHz short GI
			* max A-MSDU len 3839
			* DSSS/CCK 40 MHz
		HT A-MPDU factor: 0x0003 (65535 bytes)
		HT A-MPDU density: 0x0006 (8 usec)
		HT MCS set: ff ff 00 00 00 00 00 00 00 00 00 00 01 00 00 00
		HT TX/RX MCS rate indexes supported:
			MCS index 0
			MCS index 1
			MCS index 2
			MCS index 3
			MCS index 4
			MCS index 5
			MCS index 6
			MCS index 7
			MCS index 8
			MCS index 9
			MCS index 10
			MCS index 11
			MCS index 12
			MCS index 13
			MCS index 14
			MCS index 15
		Frequencies:
			* 2412 MHz [1] (20.0 dBm)
			* 2417 MHz [2] (20.0 dBm)
			* 2422 MHz [3] (20.0 dBm)
			* 2427 MHz [4] (20.0 dBm)
			* 2432 MHz [5] (20.0 dBm)
			* 2437 MHz [6] (20.0 dBm)
			* 2442 MHz [7] (20.0 dBm)
			* 2447 MHz [8] (20.0 dBm)
			* 2452 MHz [9] (20.0 dBm)
			* 2457 MHz [10] (20.0 dBm)
			* 2462 MHz [11] (20.0 dBm)
			* 2467 MHz [12] (disabled)
			* 2472 MHz [13] (disabled)
			* 2484 MHz [14] (disabled)
		Bitrates:
			* 1.0 Mbps
			* 2.0 Mbps (short preamble supported)
			* 5.5 Mbps (short preamble supported)
			* 11.0 Mbps (short preamble supported)
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	Band 2:
		HT capabilities: 0x104e
			* 20/40 MHz operation
			* SM PS disabled
			* 40 MHz short GI
			* max A-MSDU len 3839
			* DSSS/CCK 40 MHz
		HT A-MPDU factor: 0x0003 (65535 bytes)
		HT A-MPDU density: 0x0006 (8 usec)
		HT MCS set: ff ff 00 00 00 00 00 00 00 00 00 00 01 00 00 00
		HT TX/RX MCS rate indexes supported:
			MCS index 0
			MCS index 1
			MCS index 2
			MCS index 3
			MCS index 4
			MCS index 5
			MCS index 6
			MCS index 7
			MCS index 8
			MCS index 9
			MCS index 10
			MCS index 11
			MCS index 12
			MCS index 13
			MCS index 14
			MCS index 15
		Frequencies:
			* 5180 MHz [36] (30.0 dBm) (passive scanning, no IBSS)
			* 5200 MHz [40] (30.0 dBm) (passive scanning, no IBSS)
			* 5220 MHz [44] (30.0 dBm) (passive scanning, no IBSS)
			* 5240 MHz [48] (30.0 dBm) (passive scanning, no IBSS)
			* 5260 MHz [52] (30.0 dBm) (passive scanning, no IBSS, radar  
detection)
			* 5280 MHz [56] (30.0 dBm) (passive scanning, no IBSS, radar  
detection)
			* 5300 MHz [60] (30.0 dBm) (passive scanning, no IBSS, radar  
detection)
			* 5320 MHz [64] (30.0 dBm) (passive scanning, no IBSS, radar  
detection)
			* 5500 MHz [100] (disabled)
			* 5520 MHz [104] (disabled)
			* 5540 MHz [108] (disabled)
			* 5560 MHz [112] (disabled)
			* 5580 MHz [116] (disabled)
			* 5600 MHz [120] (disabled)
			* 5620 MHz [124] (disabled)
			* 5640 MHz [128] (disabled)
			* 5660 MHz [132] (disabled)
			* 5680 MHz [136] (disabled)
			* 5700 MHz [140] (disabled)
			* 5745 MHz [149] (30.0 dBm) (passive scanning, no IBSS)
			* 5765 MHz [153] (30.0 dBm) (passive scanning, no IBSS)
			* 5785 MHz [157] (30.0 dBm) (passive scanning, no IBSS)
			* 5805 MHz [161] (30.0 dBm) (passive scanning, no IBSS)
			* 5825 MHz [165] (30.0 dBm) (passive scanning, no IBSS)
		Bitrates:
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	max # scan SSIDs: 4
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * monitor
		 * mesh point

