Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55026 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab1ETWWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 18:22:46 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p4KMMjcN003263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 15:22:45 -0700
Message-ID: <4DD6E9B5.3020905@candelatech.com> (sfid-20110521_002250_581818_85BD6C7C)
Date: Fri, 20 May 2011 15:22:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k  9380:  All 5Ghz channels flagged as passive-scanning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is on 2.6.39-wl+

All the 5Ghz channels are showing as passive scanning, which
makes them unusable for APs if nothing else.

Any idea why this is happening?

On a previous boot, I had an STA associated on channel
40 and that was the single 5Ghz channel that didn't
show 'passive scanning'.  I removed it's configuration
so that it wouldn't associate and upon reboot I see
the output below.

More than happy to provide more details...

[root@lec-ath9k-9380 ~]# iw phy wiphy0 info
Wiphy wiphy0
	Band 1:
		Capabilities: 0x11ef
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-23
		Frequencies:
			* 2412 MHz [1] (17.0 dBm)
			* 2417 MHz [2] (17.0 dBm)
			* 2422 MHz [3] (17.0 dBm)
			* 2427 MHz [4] (17.0 dBm)
			* 2432 MHz [5] (17.0 dBm)
			* 2437 MHz [6] (17.0 dBm)
			* 2442 MHz [7] (17.0 dBm)
			* 2447 MHz [8] (17.0 dBm)
			* 2452 MHz [9] (17.0 dBm)
			* 2457 MHz [10] (17.0 dBm)
			* 2462 MHz [11] (17.0 dBm)
			* 2467 MHz [12] (17.0 dBm) (passive scanning)
			* 2472 MHz [13] (17.0 dBm) (passive scanning)
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
		Capabilities: 0x11ef
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-23
		Frequencies:
			* 5180 MHz [36] (18.0 dBm) (passive scanning, no IBSS)
			* 5200 MHz [40] (18.0 dBm) (passive scanning, no IBSS)
			* 5220 MHz [44] (18.0 dBm) (passive scanning, no IBSS)
			* 5240 MHz [48] (18.0 dBm) (passive scanning, no IBSS)
			* 5260 MHz [52] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5280 MHz [56] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5300 MHz [60] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5320 MHz [64] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5500 MHz [100] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5520 MHz [104] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5540 MHz [108] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5560 MHz [112] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5580 MHz [116] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5600 MHz [120] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5620 MHz [124] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5640 MHz [128] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5660 MHz [132] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5680 MHz [136] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5700 MHz [140] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5745 MHz [149] (18.0 dBm) (passive scanning, no IBSS)
			* 5765 MHz [153] (18.0 dBm) (passive scanning, no IBSS)
			* 5785 MHz [157] (18.0 dBm) (passive scanning, no IBSS)
			* 5805 MHz [161] (18.0 dBm) (passive scanning, no IBSS)
			* 5825 MHz [165] (18.0 dBm) (passive scanning, no IBSS)
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
	Available Antennas: TX 0 RX 0
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * WDS
		 * monitor
		 * mesh point
		 * P2P-client
		 * P2P-GO
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
		 * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
	Supported RX frame types:
		 * IBSS: 0x00d0
		 * managed: 0x0040 0x00d0
		 * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
		 * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
		 * mesh point: 0x00b0 0x00c0 0x00d0
		 * P2P-client: 0x0040 0x00d0
		 * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

