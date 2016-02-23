Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46245 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbcBWOSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 09:18:31 -0500
Message-ID: <56CC6A35.5000900@candelatech.com> (sfid-20160223_151853_741361_F8C756D4)
Date: Tue, 23 Feb 2016 06:18:29 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
CC: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] mac80211:  Let VHT work on 2.4Ghz
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com> <1456236627.9910.10.camel@sipsolutions.net>
In-Reply-To: <1456236627.9910.10.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/23/2016 06:10 AM, Johannes Berg wrote:
> On Mon, 2016-02-22 at 14:42 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> ath10k supports VHT on 2.4Ghz band.
>
> It can't. At least not formally, as this sentence is written, since VHT
> per the spec requires operating on the 5 GHz band, and it also requires
> 80 MHz bandwidth which isn't even available in 2.4 GHz in many
> countries.
>
> What you really "want" is to use VHT modulations, mostly for the
> dubious purpose of marketing benchmarks to reach 256-QAM modulations.
>
> I think the de-facto standard for this would be to use IEs similar to
> VHT ones, encapsulated in some (Broadcom?) vendor IE. We may have to
> work with that, but that's not what this patch does. Jouni had some
> better idea how this worked, I think.
>
> Also, as written, this patch has practically no effect because no
> driver can or should advertise real VHT support on 2.4 GHz band, even
> if the code structure were to allow that.

I don't recall making any changes to ath10k driver or firmware that would
enable VHT on 2.4, but it is there anyway in the 4.4 kernel.

I tested my patch, and I see 600Mbps tx rates (and other VHT encodings) reported,
and vht_capa shows up as expected, so I think it must be at least
partially working.

[root@ben-ota2 lanforge]# iw phy wiphy0 info
Wiphy wiphy0
	max # scan SSIDs: 16
	max scan IEs length: 195 bytes
	max # sched scan SSIDs: 0
	max # match sets: 0
	Retry short limit: 7
	Retry long limit: 4
	Coverage class: 0 (up to 0m)
	Device supports RSN-IBSS.
	Device supports AP-side u-APSD.
	Supported Ciphers:
		* WEP40 (00-0f-ac:1)
		* WEP104 (00-0f-ac:5)
		* TKIP (00-0f-ac:2)
		* CCMP (00-0f-ac:4)
		* CMAC (00-0f-ac:6)
	Available Antennas: TX 0x7 RX 0x7
	Configured Antennas: TX 0x7 RX 0x7
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * monitor
		 * mesh point
		 * P2P-client
		 * P2P-GO
		 * P2P-device
	Band 1:
		Capabilities: 0x19ef
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-23
		VHT Capabilities (0x338001b2):
			Max MPDU length: 11454
			Supported Channel Width: neither 160 nor 80+80
			RX LDPC
			short GI (80 MHz)
			TX STBC
			RX antenna pattern consistency
			TX antenna pattern consistency
		VHT RX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: MCS 0-9
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT RX highest supported: 0 Mbps
		VHT TX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: MCS 0-9
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT TX highest supported: 0 Mbps
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
		Frequencies:
			* 2412 MHz [1] (30.0 dBm)
			* 2417 MHz [2] (30.0 dBm)
			* 2422 MHz [3] (30.0 dBm)
			* 2427 MHz [4] (30.0 dBm)
			* 2432 MHz [5] (30.0 dBm)
			* 2437 MHz [6] (30.0 dBm)
			* 2442 MHz [7] (30.0 dBm)
			* 2447 MHz [8] (30.0 dBm)
			* 2452 MHz [9] (30.0 dBm)
			* 2457 MHz [10] (30.0 dBm)
			* 2462 MHz [11] (30.0 dBm)
			* 2467 MHz [12] (disabled)
			* 2472 MHz [13] (disabled)
			* 2484 MHz [14] (disabled)
	Band 2:
		Capabilities: 0x19ef
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-23
		VHT Capabilities (0x338001b2):
			Max MPDU length: 11454
			Supported Channel Width: neither 160 nor 80+80
			RX LDPC
			short GI (80 MHz)
			TX STBC
			RX antenna pattern consistency
			TX antenna pattern consistency
		VHT RX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: MCS 0-9
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT RX highest supported: 0 Mbps
		VHT TX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: MCS 0-9
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT TX highest supported: 0 Mbps
		Bitrates (non-HT):
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
		Frequencies:
			* 5180 MHz [36] (17.0 dBm)
			* 5200 MHz [40] (17.0 dBm)
			* 5220 MHz [44] (17.0 dBm)
			* 5240 MHz [48] (17.0 dBm)
			* 5260 MHz [52] (23.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 49710 sec)
			  DFS CAC time: 60000 ms
			* 5280 MHz [56] (23.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 49710 sec)
			  DFS CAC time: 60000 ms
			* 5300 MHz [60] (23.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 49710 sec)
			  DFS CAC time: 60000 ms
			* 5320 MHz [64] (23.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 49710 sec)
			  DFS CAC time: 60000 ms
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
			* 5720 MHz [144] (disabled)
			* 5745 MHz [149] (30.0 dBm)
			* 5765 MHz [153] (30.0 dBm)
			* 5785 MHz [157] (30.0 dBm)
			* 5805 MHz [161] (30.0 dBm)
			* 5825 MHz [165] (30.0 dBm)
	Supported commands:
		 * new_interface
		 * set_interface
		 * new_key
		 * start_ap
		 * new_station
		 * new_mpath
		 * set_mesh_config
		 * set_bss
		 * authenticate
		 * associate
		 * deauthenticate
		 * disassociate
		 * join_ibss
		 * join_mesh
		 * remain_on_channel
		 * set_tx_bitrate_mask
		 * frame
		 * frame_wait_cancel
		 * set_wiphy_netns
		 * set_channel
		 * set_wds_peer
		 * probe_client
		 * set_noack_map
		 * register_beacons
		 * start_p2p_device
		 * set_mcast_rate
		 * testmode
		 * channel_switch
		 * set_qos_map
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
		 * P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
	Supported RX frame types:
		 * IBSS: 0x40 0xb0 0xc0 0xd0
		 * managed: 0x40 0xd0
		 * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * mesh point: 0xb0 0xc0 0xd0
		 * P2P-client: 0x40 0xd0
		 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * P2P-device: 0x40 0xd0
	software interface modes (can always be added):
		 * AP/VLAN
		 * monitor
	valid interface combinations:
		 * #{ managed, P2P-client } <= 64, #{ P2P-GO } <= 3, #{ AP } <= 7, #{ IBSS } <= 1,
		   total <= 64, #channels <= 1, STA/AP BI must match, radar detect widths: { 20 MHz (no HT), 20 MHz, 40 MHz, 80 MHz }

	HT Capability overrides:
		 * MCS: ff ff ff ff ff ff ff ff ff ff
		 * maximum A-MSDU length
		 * supported channel width
		 * short GI for 40 MHz
		 * max A-MPDU length exponent
		 * min MPDU start spacing
	Device supports TX status socket option.
	Device supports HT-IBSS.
	Device supports SAE with AUTHENTICATE command
	Device supports scan flush.
	Device supports per-vif TX power setting
	Driver supports a userspace MPM
	Driver/device bandwidth changes during BSS lifetime (AP/GO mode)
	Device supports static SMPS
	Device supports configuring vdev MAC-addr on create.
	Device supports VHT-IBSS.
[root@ben-ota2 lanforge]#

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
