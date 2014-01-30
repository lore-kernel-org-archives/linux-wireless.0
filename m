Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ax4.adsl.tnnet.fi ([217.112.254.4]:53578 "EHLO mail.opinsys.fi"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753049AbaA3MiM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 07:38:12 -0500
Date: Thu, 30 Jan 2014 12:33:42 +0000 (UTC)
From: Tuomas =?utf-8?B?UsOkc8OkbmVu?= <tuomasjjrasanen@opinsys.fi>
To: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	tuomasjjrasanen@tjjr.fi, Veli-Matti Lintu <vmlintu@opinsys.fi>
Message-ID: <879434908.52885.1391085222657.JavaMail.zimbra@opinsys.fi> (sfid-20140130_133815_753435_E775912D)
In-Reply-To: <2018379362.52866.1391084425810.JavaMail.zimbra@opinsys.fi>
Subject: PROBLEM: skb_push called from rt2x00 panics occasionally
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=================================================
 skb_push called from rt2x00 panics occasionally
=================================================

We have been experiencing occasional skb_push panics with rt2x00 driver
throughout the stable v3.10 -series. Problems occur with hosts acting as
accesspoints, managed by hostapd 2.0. Some hosts panic reportedly
several times per week, some almost never. All hosts have identical
kernels and WiFi adapters.

We have not been able to reproduce panics in a controlled manner.

I'd be very happy to get some advice how to proceed in debugging and fixing
this problem and even better, to understand the whole issue
thoroughly. Unfortunately, all I know now is that the skb headroom is
not big enough for the frame the AP is trying to transmit, right?
Hopefully someone can shed some light on this problem.

Kernel version
==============

The latest tested and affected is stable v3.10.23, earlier v3.10
-kernels are affected as well. We do not have reliable test results from
newer kernels due to random nature of this bug.

Output
======

Unfortunately, we don't have textual traces, just photos. Here is one:
http://i.imgur.com/2XD8X3r.jpg

Environment
===========

USB Wifi adapter
----------------

Bus 001 Device 003: ID 148f:3070 Ralink Technology, Corp. RT2870/RT3070 Wireless Adapter

wlan0     Link encap:Ethernet  HWaddr 00:1e:ab:20:56:30  
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

Wiphy phy0
	Band 1:
		Capabilities: 0x172
			HT20/HT40
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 2 usec (0x04)
		HT RX MCS rate indexes supported: 0-7, 32
		TX unequal modulation not supported
		HT TX Max spatial streams: 1
		HT TX MCS rate indexes supported may differ
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
			* 2467 MHz [12] (20.0 dBm)
			* 2472 MHz [13] (20.0 dBm)
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
	max # scan SSIDs: 4
	max scan IEs length: 2257 bytes
	Coverage class: 0 (up to 0m)
	Supported Ciphers:
		* WEP40 (00-0f-ac:1)
		* WEP104 (00-0f-ac:5)
		* TKIP (00-0f-ac:2)
		* CCMP (00-0f-ac:4)
	Available Antennas: TX 0 RX 0
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * WDS
		 * monitor
		 * mesh point
	software interface modes (can always be added):
		 * AP/VLAN
		 * monitor
	valid interface combinations:
		 * #{ AP, mesh point } <= 8,
		   total <= 8, #channels <= 1
	Supported commands:
		 * new_interface
		 * set_interface
		 * new_key
		 * new_beacon
		 * new_station
		 * new_mpath
		 * set_mesh_params
		 * set_bss
		 * authenticate
		 * associate
		 * deauthenticate
		 * disassociate
		 * join_ibss
		 * join_mesh
		 * set_tx_bitrate_mask
		 * action
		 * frame_wait_cancel
		 * set_wiphy_netns
		 * set_channel
		 * set_wds_peer
		 * Unknown command (84)
		 * Unknown command (87)
		 * Unknown command (85)
		 * Unknown command (89)
		 * Unknown command (92)
		 * testmode
		 * connect
		 * disconnect
	Supported TX frame types:
		 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * Unknown mode (10): 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
	Supported RX frame types:
		 * IBSS: 0x40 0xb0 0xc0 0xd0
		 * managed: 0x40 0xd0
		 * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * mesh point: 0xb0 0xc0 0xd0
		 * P2P-client: 0x40 0xd0
		 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * Unknown mode (10): 0x40 0xd0
	Device supports RSN-IBSS.
	HT Capability overrides:
		 * MCS: ff ff ff ff ff ff ff ff ff ff
		 * maximum A-MSDU length
		 * supported channel width
		 * short GI for 40 MHz
		 * max A-MPDU length exponent
		 * min MPDU start spacing
	Device supports TX status socket option.
	Device supports HT-IBSS.

-- 
Tuomas
