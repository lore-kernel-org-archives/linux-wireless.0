Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51791 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbbG1SzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 14:55:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ZKA1p-0000z1-24
	for linux-wireless@vger.kernel.org; Tue, 28 Jul 2015 20:55:05 +0200
Received: from 110.Red-81-34-111.dynamicIP.rima-tde.net ([81.34.111.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 20:55:05 +0200
Received: from occam25 by 110.Red-81-34-111.dynamicIP.rima-tde.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 20:55:05 +0200
To: linux-wireless@vger.kernel.org
From: Javi <occam25@yahoo.es>
Subject: ath9k get too few networks when scanning
Date: Tue, 28 Jul 2015 17:12:46 +0000 (UTC)
Message-ID: <loom.20150728T185500-729@post.gmane.org> (sfid-20150728_205514_732430_969E6CA3)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,
I am working with a SR71 and R11E miniPCIe wifi cards on an embedded system 
running Debian wheezy (3.2.68-rt99).

Something is wrong because when I scan with my laptop I get around 15 
networks and when I do it on the system I just get only two or three. I 
have tried different kernel configs and driver versions with same result, 
and I have no idea what else I can try.

Does anyone know what it could be or how to debug the issue? I am stuck


System information:


uname -a
Linux Debian 3.2.68-rt99 #16 SMP Tue Jul 28 16:06:32 CEST 2015 i686 
GNU/Linux

lspci | grep -i wireless
04:00.0 Network controller: Atheros Communications Inc. AR928X Wireless 
Network Adapter (PCI-Express) (rev 01)
06:00.0 Network controller: Atheros Communications Inc. AR9580 Wireless 
Network Adapter (rev 01)

lsmod | grep ath9k
ath9k                  99265  0 
ath9k_common            1500  1 ath9k
ath9k_hw              377206  2 ath9k_common,ath9k
mac80211              207625  1 ath9k
ath                    12275  3 ath9k_hw,ath9k_common,ath9k
cfg80211              146315  3 ath,mac80211,ath9k


modinfo ath9k
filename:       /lib/modules/3.2.68-
rt99/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
license:        Dual BSD/GPL
description:    Support for Atheros 802.11n wireless LAN cards.
author:         Atheros Communications
alias:          platform:ar934x_wmac
alias:          platform:ar933x_wmac
alias:          platform:ath9k
alias:          pci:v0000168Cd00000037sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000034sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000033sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000032sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000030sv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Esv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Dsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Csv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Bsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Asv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000029sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000027sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000024sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000023sv*sd*bc*sc*i*
depends:        ath9k_hw,ath9k_common,mac80211,cfg80211,ath
intree:         Y
vermagic:       3.2.68-rt99 SMP mod_unload 686 
parm:           debug:Debugging mask (uint)
parm:           nohwcrypt:Disable hardware encryption (int)
parm:           blink:Enable LED blink on activity (int)
parm:           btcoex_enable:Enable wifi-BT coexistence (int)
parm:           ps_enable:Enable WLAN PowerSave (int)


iw list (just shown phy0)

Wiphy phy0
	Band 1:
		Capabilities: 0x11ce
			HT20/HT40
			SM Power Save disabled
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-15
		Frequencies:
			* 2412 MHz [1] (16.0 dBm)
			* 2417 MHz [2] (16.0 dBm)
			* 2422 MHz [3] (16.0 dBm)
			* 2427 MHz [4] (16.0 dBm)
			* 2432 MHz [5] (16.0 dBm)
			* 2437 MHz [6] (16.0 dBm)
			* 2442 MHz [7] (16.0 dBm)
			* 2447 MHz [8] (16.0 dBm)
			* 2452 MHz [9] (16.0 dBm)
			* 2457 MHz [10] (16.0 dBm)
			* 2462 MHz [11] (16.0 dBm)
			* 2467 MHz [12] (16.0 dBm) (passive scanning)
			* 2472 MHz [13] (16.0 dBm) (passive scanning)
			* 2484 MHz [14] (disabled)
		Bitrates (non-HT):
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
		Capabilities: 0x11ce
			HT20/HT40
			SM Power Save disabled
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-15
		Frequencies:
			* 5180 MHz [36] (15.0 dBm) (passive scanning, no 
IBSS)
			* 5200 MHz [40] (15.0 dBm) (passive scanning, no 
IBSS)
			* 5220 MHz [44] (15.0 dBm) (passive scanning, no 
IBSS)
			* 5240 MHz [48] (15.0 dBm) (passive scanning, no 
IBSS)
			* 5260 MHz [52] (17.0 dBm) (passive scanning, no 
IBSS, radar detection)
			* 5280 MHz [56] (14.0 dBm) (passive scanning, no 
IBSS, radar detection)
			* 5300 MHz [60] (14.0 dBm) (passive scanning, no 
IBSS, radar detection)
			* 5320 MHz [64] (14.0 dBm) (passive scanning, no 
IBSS, radar detection)
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
			* 5745 MHz [149] (17.0 dBm) (passive scanning, no 
IBSS)
			* 5765 MHz [153] (17.0 dBm) (passive scanning, no 
IBSS)
			* 5785 MHz [157] (17.0 dBm) (passive scanning, no 
IBSS)
			* 5805 MHz [161] (17.0 dBm) (passive scanning, no 
IBSS)
			* 5825 MHz [165] (17.0 dBm) (passive scanning, no 
IBSS)
		Bitrates (non-HT):
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	max # scan SSIDs: 4
	max scan IEs length: 2257 bytes
	Coverage class: 0 (up to 0m)
	Supported Ciphers:
		* WEP40 (00-0f-ac:1)
		* WEP104 (00-0f-ac:5)
		* TKIP (00-0f-ac:2)
		* CCMP (00-0f-ac:4)
		* CMAC (00-0f-ac:6)
	Available Antennas: TX 0x3 RX 0x3
	Configured Antennas: TX 0x3 RX 0x3
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * WDS
		 * monitor
		 * P2P-client
		 * P2P-GO
	software interface modes (can always be added):
		 * AP/VLAN
		 * monitor
	interface combinations are not supported
	Supported commands:
		 * new_interface
		 * set_interface
		 * new_key
		 * new_beacon
		 * new_station
		 * set_bss
		 * authenticate
		 * associate
		 * deauthenticate
		 * disassociate
		 * join_ibss
		 * remain_on_channel
		 * set_tx_bitrate_mask
		 * action
		 * frame_wait_cancel
		 * set_wiphy_netns
		 * set_channel
		 * set_wds_peer
		 * connect
		 * disconnect
	Supported TX frame types:
		 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
	Supported RX frame types:
		 * IBSS: 0xd0
		 * managed: 0x40 0xd0
		 * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * mesh point: 0xb0 0xc0 0xd0
		 * P2P-client: 0x40 0xd0
		 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
	Device supports RSN-IBSS.

