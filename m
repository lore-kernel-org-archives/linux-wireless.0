Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.freestuffjunction.co.uk ([109.169.51.71]:31418 "EHLO
	mail.freestuffjunction.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329Ab2KFPew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 10:34:52 -0500
Message-ID: <50992E0E.3040606@ehuk.net> (sfid-20121106_163509_434689_EFF28ABD)
Date: Tue, 06 Nov 2012 15:34:38 +0000
From: Eddie Chapman <eddie@ehuk.net>
Reply-To: Eddie Chapman <eddie@ehuk.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 3.6.5
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>   <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>   (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>  <509838F4.4010301@ehuk.net> <1352188621.9440.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352188621.9440.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Yeah, I forgot to ask about the AP. Can you show the output of "iw wlan0
> scan dump" for your AP while you're connected? It should show something
> like this (note the "associated" indication):
>
> BSS 02:00:00:00:00:00 (on wlan1) -- associated
> 	TSF: 1352188517669470 usec (15650d, 07:55:17)
> 	freq: 2432
> 	[...]
>
> I'm particularly interested in the "freq" (as above) and the HT
> capabilities/operation information.

The AP is a Netgear WNR2000v3 running DD-WRT v24-sp2 (03/19/12) std.

After sshing into it and playing around with the iw command, the phy is 
phy0 and the device is ath0.

"iw ath0 scan dump" returns nothing unfortunately.

In case it helps, on the laptop (the client) I do get output from "iw 
wlan0 scan dump":

BSS 82:e1:fa:1a:65:00 (on wlan0) -- associated
	TSF: 2791936678 usec (0d, 00:46:31)
	freq: 2452
	beacon interval: 100
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -37.00 dBm
	last seen: 98451 ms ago
	Information elements from Probe Response frame:
	SSID: e79164285
	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
	DS Parameter set: channel 9
	ERP: Barker_Preamble_Mode
	Extended supported rates: 24.0 36.0 48.0 54.0
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC (0x000c)
	HT capabilities:
		Capabilities: 0x11ee
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
		HT TX/RX MCS rate indexes supported: 0-15
	HT operation:
		 * primary channel: 9
		 * secondary channel offset: above
		 * STA channel width: any
		 * RIFS: 0
		 * HT protection: no
		 * non-GF present: 0
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	WMM:	 * Parameter version 1
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec


Back on the AP, I played around and below is the output of some of the 
commands I ran that seemed to return useful information, as well as 
dmesg output. Many of the commands I tried either returned nothing or 
some error like "not supported". Do any of them give you the info you 
need? If not any other command you want me to run?

All this was done with the HT20/HT40 patch NOT applied.

thanks again for investigating this and all your dev efforts :-)

regards,
Eddie

root@DD-WRT:~# iwconfig ath0
ath0      IEEE 802.11bgn  Mode:Master  Frequency:2.452 GHz  Tx-Power=17 
dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Power Management:off


root@DD-WRT:~# iwlist ath0 power
ath0      Current mode:off


root@DD-WRT:~# iw ath0 info
Interface ath0
	ifindex 6
	type AP
	wiphy 3


root@DD-WRT:~# iw phy0 info
Wiphy phy0
	Band 1:
		Capabilities: 0x11ee
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
		HT TX/RX MCS rate indexes supported: 0-15
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
	Coverage class: 5 (up to 2250m)
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
		 * Unknown command (82)
		 * Unknown command (81)
		 * Unknown command (84)
		 * Unknown command (87)
		 * Unknown command (85)
		 * connect
		 * disconnect
	Supported TX frame types:
		 * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 
0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
	Supported RX frame types:
		 * IBSS: 0x00d0
		 * managed: 0x0040 0x00d0
		 * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
		 * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
		 * mesh point: 0x00b0 0x00c0 0x00d0
		 * P2P-client: 0x0040 0x00d0
		 * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
	Device supports RSN-IBSS.
	HT Capability overrides:
		 * MCS: ff ff ff ff ff ff ff ff ff ff
		 * maximum A-MSDU length
		 * supported channel width
		 * short GI for 40 MHz
		 * max A-MPDU length exponent
		 * min MPDU start spacing
	Device supports HT-IBSS.




root@DD-WRT:~# iw ath0 survey dump
Survey data from ath0
	frequency:			2412 MHz
	noise:				-94 dBm
	channel active time:		51 ms
	channel busy time:		0 ms
	channel receive time:		0 ms
	channel transmit time:		0 ms
Survey data from ath0
	frequency:			2417 MHz
	noise:				-94 dBm
	channel active time:		58 ms
	channel busy time:		0 ms
	channel receive time:		0 ms
	channel transmit time:		0 ms
Survey data from ath0
	frequency:			2422 MHz
	noise:				-95 dBm
	channel active time:		58 ms
	channel busy time:		12 ms
	channel receive time:		3 ms
	channel transmit time:		0 ms
Survey data from ath0
	frequency:			2427 MHz
	noise:				-95 dBm
	channel active time:		58 ms
	channel busy time:		1 ms
	channel receive time:		0 ms
	channel transmit time:		0 ms
Survey data from ath0
	frequency:			2432 MHz
	noise:				-95 dBm
	channel active time:		58 ms
	channel busy time:		11 ms
	channel receive time:		2 ms
	channel transmit time:		0 ms
Survey data from ath0
	frequency:			2437 MHz
	noise:				-95 dBm
	channel active time:		58 ms
	channel busy time:		1 ms
	channel receive time:		0 ms
	channel transmit time:		0 ms
Survey data from ath0
	frequency:			2442 MHz
	noise:				-95 dBm
	channel active time:		58 ms
	channel busy time:		4 ms
	channel receive time:		0 ms
	channel transmit time:		0 ms
Survey data from ath0
	frequency:			2447 MHz
	noise:				-95 dBm
	channel active time:		58 ms
	channel busy time:		8 ms
	channel receive time:		0 ms
	channel transmit time:		0 ms
Survey data from ath0
	frequency:			2452 MHz [in use]
	noise:				-95 dBm
	channel active time:		244549336 ms
	channel busy time:		19353849 ms
	channel receive time:		1387651 ms
	channel transmit time:		10752120 ms
Survey data from ath0
	frequency:			2457 MHz
	noise:				-95 dBm
	channel active time:		58 ms
	channel busy time:		4 ms
	channel receive time:		0 ms
	channel transmit time:		0 ms
Survey data from ath0
	frequency:			2462 MHz
	noise:				-95 dBm
	channel active time:		58 ms
	channel busy time:		17 ms
	channel receive time:		9 ms
	channel transmit time:		0 ms
Survey data from ath0
	frequency:			2467 MHz
	noise:				-95 dBm
	channel active time:		58 ms
	channel busy time:		17 ms
	channel receive time:		6 ms
	channel transmit time:		0 ms
Survey data from ath0
	frequency:			2472 MHz
	noise:				-95 dBm
	channel active time:		58 ms
	channel busy time:		16 ms
	channel receive time:		8 ms
	channel transmit time:		0 ms


root@DD-WRT:~# iwlist ath0 frequency
ath0      13 channels in total; available frequencies :
           Channel 01 : 2.412 GHz
           Channel 02 : 2.417 GHz
           Channel 03 : 2.422 GHz
           Channel 04 : 2.427 GHz
           Channel 05 : 2.432 GHz
           Channel 06 : 2.437 GHz
           Channel 07 : 2.442 GHz
           Channel 08 : 2.447 GHz
           Channel 09 : 2.452 GHz
           Channel 10 : 2.457 GHz
           Channel 11 : 2.462 GHz
           Channel 12 : 2.467 GHz
           Channel 13 : 2.472 GHz
           Current Frequency=2.452 GHz (Channel 9)



Finally, here is dmesg output on the AP:

<5>[    0.000000] Linux version 3.2.12-rc1-svn18774 (root@dd-wrt) (gcc 
version 4.6.3 20120201 (prerelease) (Linaro GCC 4.6-2012.02) ) #1482 Mon 
Mar 19 11:54:29 CET 2012
<4>[    0.000000] flash_size passed from bootloader = 4
<6>[    0.000000] bootconsole [early0] enabled
<6>[    0.000000] CPU revision is: 00019374 (MIPS 24Kc)
<6>[    0.000000] Determined physical RAM map:
<6>[    0.000000]  memory: 02000000 @ 00000000 (usable)
<4>[    0.000000] Zone PFN ranges:
<4>[    0.000000]   Normal   0x00000000 -> 0x00002000
<4>[    0.000000] Movable zone start PFN for each node
<4>[    0.000000] early_node_map[1] active PFN ranges
<4>[    0.000000]     0: 0x00000000 -> 0x00002000
<7>[    0.000000] On node 0 totalpages: 8192
<7>[    0.000000] free_area_init_node: node 0, pgdat 8026e830, 
node_mem_map 81000000
<7>[    0.000000]   Normal zone: 64 pages used for memmap
<7>[    0.000000]   Normal zone: 0 pages reserved
<7>[    0.000000]   Normal zone: 8128 pages, LIFO batch:0
<7>[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
<7>[    0.000000] pcpu-alloc: [0] 0
<4>[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
  Total pages: 8128
<5>[    0.000000] Kernel command line: console=ttyS0,115200 root=1f02 
rootfstype=squashfs noinitrd init=/sbin/init
<6>[    0.000000] PID hash table entries: 128 (order: -3, 512 bytes)
<6>[    0.000000] Dentry cache hash table entries: 4096 (order: 2, 16384 
bytes)
<6>[    0.000000] Inode-cache hash table entries: 2048 (order: 1, 8192 
bytes)
<4>[    0.000000] Primary instruction cache 64kB, VIPT, 4-way, linesize 
32 bytes.
<4>[    0.000000] Primary data cache 32kB, 4-way, VIPT, cache aliases, 
linesize 32 bytes
<6>[    0.000000] Writing ErrCtl register=00000000
<6>[    0.000000] Readback ErrCtl register=00000000
<6>[    0.000000] Memory: 29528k/32768k available (2081k kernel code, 
3240k reserved, 402k data, 160k init, 0k highmem)
<6>[    0.000000] NR_IRQS:80
<6>[    0.000000] Calibrating delay loop... 239.61 BogoMIPS (lpj=1198080)
<6>[    0.070000] pid_max: default: 32768 minimum: 301
<6>[    0.070000] Mount-cache hash table entries: 512
<6>[    0.080000] NET: Registered protocol family 16
<6>[    0.100000] found calibration data for slot 0 on 0xBF3F1000
<4>[    0.310000] registering PCI controller with io_map_base unset
<6>[    0.330000] bio: create slab <bio-0> at 0
<7>[    0.330000] pci 0000:00:00.0: [168c:ff1c] type 0 class 0x000200
<6>[    0.330000] pci 0000:00:00.0: fixup device configuration
<0>[    0.340000] bootstrap returns device 168C:2E
<7>[    0.340000] pci 0000:00:00.0: reg 10: [mem 0x00000000-0x0000ffff 
64bit]
<7>[    0.340000] pci 0000:00:00.0: supports D1
<7>[    0.340000] pci 0000:00:00.0: PME# supported from D0 D1 D3hot
<7>[    0.340000] pci 0000:00:00.0: PME# disabled
<6>[    0.340000] pci 0000:00:00.0: BAR 0: assigned [mem 
0x10000000-0x1000ffff 64bit]
<6>[    0.350000] pci 0000:00:00.0: BAR 0: set to [mem 
0x10000000-0x1000ffff 64bit] (PCI address [0x10000000-0x1000ffff])
<6>[    0.360000] PCI: mapping irq 72 to pin1@0000:00:00.0
<6>[    0.360000] Switching to clocksource MIPS
<6>[    0.370000] NET: Registered protocol family 2
<6>[    0.370000] IP route cache hash table entries: 1024 (order: 0, 
4096 bytes)
<6>[    0.380000] TCP established hash table entries: 1024 (order: 1, 
8192 bytes)
<6>[    0.390000] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
<6>[    0.390000] TCP: Hash tables configured (established 1024 bind 1024)
<6>[    0.400000] TCP reno registered
<6>[    0.400000] UDP hash table entries: 256 (order: 0, 4096 bytes)
<6>[    0.410000] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
<6>[    0.420000] NET: Registered protocol family 1
<7>[    0.420000] PCI: CLS 0 bytes, default 32
<5>[    0.420000] gpio_proc: module loaded and /proc/gpio/ created
<5>[    0.430000] wl0gpio_proc: module loaded and /proc/wl0gpio/ created
<6>[    0.440000] squashfs: version 3.0 (2006/03/15) Phillip Lougher
<6>[    0.440000] msgmni has been set to 57
<6>[    0.450000] io scheduler noop registered
<6>[    0.450000] io scheduler deadline registered (default)
<6>[    0.460000] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
<6>[    0.480000] serial8250.0: ttyS0 at MMIO 0x18020000 (irq = 11) is a 
16550A
<6>[    0.490000] console [ttyS0] enabled, bootconsole disabled
<0>[    0.500000] guessed flashsize = 4M
<0>[    0.510000] scanning for root partition
<0>[    0.510000] WNR2000 uboot detected
<0>[    0.510000] guessed bootloader size = 50000
<0>[    0.520000]
<0>[    0.520000] found squashfs at 150000
<5>[    0.530000] Creating 8 MTD partitions on "ar7240-nor0":
<5>[    0.530000] 0x000000000000-0x000000050000 : "RedBoot"
<5>[    0.540000] 0x000000050000-0x0000003e0000 : "linux"
<5>[    0.550000] 0x000000150000-0x0000003e0000 : "rootfs"
<5>[    0.550000] mtd: partition "rootfs" set to be root filesystem
<5>[    0.560000] 0x0000003e0000-0x000000400000 : "ddwrt"
<5>[    0.570000] 0x0000003e0000-0x0000003f0000 : "nvram"
<5>[    0.570000] 0x0000003f0000-0x000000400000 : "board_config"
<5>[    0.580000] 0x000000000000-0x000000400000 : "fullflash"
<5>[    0.590000] 0x000000000000-0x000000050000 : "fullboot"
<6>[    0.600000] tun: Universal TUN/TAP device driver, 1.6
<6>[    0.600000] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
<6>[    1.010000] PPP generic driver version 2.4.2
<6>[    1.010000] PPP BSD Compression module registered
<6>[    1.020000] PPP Deflate Compression module registered
<6>[    1.020000] PPP MPPE Compression module registered
<6>[    1.030000] NET: Registered protocol family 24
<6>[    1.030000] Software Watchdog Timer: 0.07 initialized. 
soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout= 0)
<7>[    1.040000] Registered led device: generic_0
<7>[    1.040000] Registered led device: generic_1
<7>[    1.050000] Registered led device: generic_2
<7>[    1.050000] Registered led device: generic_3
<7>[    1.050000] Registered led device: generic_4
<7>[    1.050000] Registered led device: generic_5
<7>[    1.050000] Registered led device: generic_6
<7>[    1.050000] Registered led device: generic_7
<7>[    1.050000] Registered led device: generic_8
<7>[    1.050000] Registered led device: generic_9
<7>[    1.050000] Registered led device: generic_10
<7>[    1.050000] Registered led device: generic_11
<7>[    1.050000] Registered led device: generic_12
<7>[    1.050000] Registered led device: generic_13
<7>[    1.050000] Registered led device: generic_14
<7>[    1.050000] Registered led device: generic_15
<7>[    1.050000] Registered led device: generic_16
<7>[    1.050000] Registered led device: generic_17
<7>[    1.050000] Registered led device: generic_18
<7>[    1.050000] Registered led device: generic_19
<7>[    1.050000] Registered led device: generic_20
<7>[    1.050000] Registered led device: generic_21
<7>[    1.050000] Registered led device: generic_22
<7>[    1.050000] Registered led device: generic_23
<7>[    1.050000] Registered led device: generic_24
<7>[    1.050000] Registered led device: generic_25
<7>[    1.050000] Registered led device: generic_26
<7>[    1.050000] Registered led device: generic_27
<7>[    1.050000] Registered led device: generic_28
<7>[    1.050000] Registered led device: generic_29
<7>[    1.060000] Registered led device: generic_30
<7>[    1.060000] Registered led device: generic_31
<7>[    1.060000] Registered led device: wireless_generic_0
<7>[    1.060000] Registered led device: wireless_generic_1
<7>[    1.060000] Registered led device: wireless_generic_2
<7>[    1.060000] Registered led device: wireless_generic_3
<7>[    1.060000] Registered led device: wireless_generic_4
<7>[    1.060000] Registered led device: wireless_generic_5
<7>[    1.060000] Registered led device: wireless_generic_6
<7>[    1.060000] Registered led device: wireless_generic_7
<7>[    1.060000] Registered led device: wireless_generic_8
<7>[    1.060000] Registered led device: wireless_generic_9
<7>[    1.060000] Registered led device: wireless_generic_10
<7>[    1.060000] Registered led device: wireless_generic_11
<7>[    1.060000] Registered led device: wireless_generic_12
<7>[    1.060000] Registered led device: wireless_generic_13
<7>[    1.060000] Registered led device: wireless_generic_14
<7>[    1.060000] Registered led device: wireless_generic_15
<6>[    1.060000] u32 classifier
<6>[    1.060000]     input device check on
<6>[    1.070000]     Actions configured
<6>[    1.070000] Netfilter messages via NETLINK v0.30.
<6>[    1.080000] nf_conntrack version 0.5.0 (461 buckets, 1844 max)
<4>[    1.080000] nf_conntrack_rtsp v0.6.21 loading
<4>[    1.090000] nf_nat_rtsp v0.6.21 loading
<6>[    1.090000] ip_tables: (C) 2000-2006 Netfilter Core Team
<6>[    1.100000] IPP2P v0.8.2 loading
<6>[    1.100000] TCP westwood registered
<6>[    1.100000] TCP hybla registered
<6>[    1.110000] TCP vegas registered
<6>[    1.110000] NET: Registered protocol family 17
<6>[    1.120000] 8021q: 802.1Q VLAN Support v1.8
<6>[    1.120000] searching for nvram
<6>[    1.120000] nvram size = 0
<6>[    1.160000] VFS: Mounted root (squashfs filesystem) readonly on 
device 31:2.
<6>[    1.170000] Freeing unused kernel memory: 160k freed
<6>[    4.250000] ag71xx_mdio: probed
<6>[    4.250000] eth0: Atheros AG71xx at 0xb9000000, irq 4
<7>[    4.850000] eth0: connected to PHY at ag71xx-mdio.1:04 
[uid=004dd041, driver=Generic PHY]
<6>[    4.850000] eth1: Atheros AG71xx at 0xba000000, irq 5
<6>[    5.440000] eth1: Found an AR7240/AR9330 built-in switch
<6>[    5.730000] Compat-wireless backport release: 
compat-wireless-2012-02-23-9-g3e5b1f0
<6>[    5.730000] Backport based on wireless-testing.git master-2012-02-27
<6>[    5.910000] cfg80211: Calling CRDA to update world regulatory domain
<6>[    6.300000] cfg80211: World regulatory domain updated:
<6>[    6.310000] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
<6>[    6.320000] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
<6>[    6.320000] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
<6>[    6.330000] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
<6>[    6.340000] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
<6>[    6.350000] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
<6>[    6.590000] eth1: link up (1000Mbps/Full duplex)
<7>[    6.780000] PCI: Setting latency timer of device 0000:00:00.0 to 64
<3>[    6.780000] ath: eeprom contains invalid mac address: 
ff:ff:ff:ff:ff:ff
<3>[    6.790000] ath: random mac address will be used: 42:83:03:c5:15:55
<7>[    6.800000] ath: EEPROM regdomain: 0x0
<7>[    6.800000] ath: EEPROM indicates default country code should be used
<7>[    6.800000] ath: doing EEPROM country->regdmn map search
<7>[    6.800000] ath: country maps to regdmn code: 0x3a
<7>[    6.800000] ath: Country alpha2 being used: US
<7>[    6.800000] ath: Regpair used: 0x3a
<7>[    6.810000] ieee80211 phy0: Selected rate control algorithm 
'minstrel_ht'
<7>[    6.810000] Registered led device: ath9k-phy0
<6>[    6.810000] ieee80211 phy0: Atheros AR9287 Rev:2 mem=0xb0000000, 
irq=72
<6>[    6.820000] cfg80211: Calling CRDA for country: US
<6>[    6.940000] cfg80211: Regulatory domain changed to country: US
<6>[    6.950000] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
<6>[    6.960000] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), 
(300 mBi, 2700 mBm)
<6>[    6.970000] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(300 mBi, 1700 mBm)
<6>[    6.970000] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
<6>[    6.980000] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
<6>[    6.990000] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
<6>[    7.000000] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), 
(300 mBi, 3000 mBm)
<6>[    9.010000] device eth0 entered promiscuous mode
<6>[    9.020000] eth1: link down
<6>[    9.090000] device eth1 entered promiscuous mode
<6>[    9.180000] cfg80211: Calling CRDA to update world regulatory domain
<6>[    9.210000] eth1: link up (1000Mbps/Full duplex)
<6>[    9.210000] br0: port 2(eth1) entering forwarding state
<6>[    9.220000] br0: port 2(eth1) entering forwarding state
<6>[    9.230000] cfg80211: World regulatory domain updated:
<6>[    9.230000] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
<6>[    9.240000] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
<6>[    9.250000] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
<6>[    9.260000] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
<6>[    9.260000] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
<6>[    9.270000] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
<6>[    9.280000] cfg80211: Calling CRDA for country: GB
<6>[    9.300000] cfg80211: Regulatory domain changed to country: GB
<6>[    9.310000] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
<6>[    9.320000] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
<6>[    9.320000] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
<6>[    9.330000] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
<6>[    9.340000] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), 
(N/A, 2700 mBm)
<6>[   11.220000] br0: port 2(eth1) entering forwarding state
<6>[   30.490000] device ath0 entered promiscuous mode
<6>[   30.490000] br0: port 3(ath0) entering forwarding state
<6>[   30.500000] br0: port 3(ath0) entering forwarding state
<6>[   32.420000] device ath0.1 entered promiscuous mode
<6>[   32.420000] br0: port 4(ath0.1) entering forwarding state
<6>[   32.430000] br0: port 4(ath0.1) entering forwarding state
<6>[   32.500000] br0: port 3(ath0) entering forwarding state
<6>[   32.810000] device eth1 left promiscuous mode
<6>[   32.810000] br0: port 2(eth1) entering forwarding state
<6>[   32.890000] device eth1.2 entered promiscuous mode
<6>[   32.890000] device eth1 entered promiscuous mode
<6>[   32.900000] br0: port 2(eth1.2) entering forwarding state
<6>[   32.900000] br0: port 2(eth1.2) entering forwarding state
<6>[   32.970000] device eth1.6 entered promiscuous mode
<6>[   32.970000] br1: port 1(eth1.6) entering forwarding state
<6>[   32.980000] br1: port 1(eth1.6) entering forwarding state
<6>[   32.990000] device ath0.1 left promiscuous mode
<6>[   33.000000] br0: port 4(ath0.1) entering forwarding state
<6>[   33.010000] device ath0.1 entered promiscuous mode
<6>[   33.020000] br1: port 2(ath0.1) entering forwarding state
<6>[   33.020000] br1: port 2(ath0.1) entering forwarding state
<6>[   34.900000] br0: port 2(eth1.2) entering forwarding state
<6>[   48.000000] br1: port 1(eth1.6) entering forwarding state
<6>[   48.040000] br1: port 2(ath0.1) entering forwarding state
