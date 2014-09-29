Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.hundeboll.net ([88.198.92.70]:45396 "EHLO
	mail.hundeboll.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbaI2NiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 09:38:01 -0400
Date: Mon, 29 Sep 2014 15:27:48 +0200
From: Martin =?iso-8859-1?q?Hundeb=F8ll?= <martin@hundeboll.net>
Subject: iwlwifi: ibss on 6205 always stuck at 1 Mbps
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <1411997268.1663.0@smtp.hundeboll.net> (sfid-20140929_153833_408801_2CDAABF6)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-9F4AWkS31WNfOYSJ0pBg"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-9F4AWkS31WNfOYSJ0pBg
Content-Type: text/plain; charset=utf-8; format=flowed

Hi,

I get bad performance with IBSS on my 6205 devices running iwlwifi. 
They seem to be stuck on 1 Mbps and through bisecting, it comes down to 
this bad commit:

3ac40edadcb7799391452ffaa1745084c3e4c747
('iwlwifi: calculate active legacy rates per station')
https://github.com/torvalds/linux/commit/3ac40edadcb7799391452ffaa1745084c3e4c747

I have tested the issue on a few different settings:
iwlwifi (6205) => iwlwifi (6205): BAD
iwlwifi (6205) => ath9k_htc:      BAD
iwlwifi (6205) => iwlwifi (6300): BAD
iwlwifi (6300) => iwlwifi (6205): GOOD
ath9k_htc      => iwlwifi (6205): GOOD

So, as the first bad commit and the simple tests indicate, the issue is 
related to the rate selection for 6205 devices.

dmesg and phy-info from an affected device is attached. Let me know if 
more information is needed.

Thanks,
Martin

core@core01:~$ sudo iw wlan0 info
Interface wlan0
	ifindex 3
	wdev 0x1
	addr a0:88:b4:bf:f4:cc
	ssid core-test
	type IBSS
	wiphy 0
	channel 6 (2437 MHz), width: 20 MHz (no HT), center1: 2437 MHz

core@core01:~$ sudo iw wlan0 station dump
Station 24:77:03:d7:6a:7c (on wlan0)
	inactive time:	32 ms
	rx bytes:	11009701
	rx packets:	24719
	tx bytes:	1264256
	tx packets:	4032
	tx retries:	501
	tx failed:	0
	signal:  	-44 dBm
	signal avg:	-43 dBm
	tx bitrate:	1.0 MBit/s
	rx bitrate:	54.0 MBit/s
	authorized:	yes
	authenticated:	yes
	preamble:	long
	WMM/WME:	yes
	MFP:		no
	TDLS peer:	no
Station f8:d1:11:0c:3f:2b (on wlan0)
	inactive time:	4 ms
	rx bytes:	13269604
	rx packets:	33953
	tx bytes:	1332906
	tx packets:	4831
	tx retries:	765
	tx failed:	0
	signal:  	-46 dBm
	signal avg:	-47 dBm
	tx bitrate:	1.0 MBit/s
	rx bitrate:	1.0 MBit/s
	authorized:	yes
	authenticated:	yes
	preamble:	long
	WMM/WME:	yes
	MFP:		no
	TDLS peer:	no
Station a0:88:b4:d8:b0:d8 (on wlan0)
	inactive time:	20 ms
	rx bytes:	7199547
	rx packets:	86184
	tx bytes:	135242
	tx packets:	1573
	tx retries:	323
	tx failed:	0
	signal:  	-41 dBm
	signal avg:	-40 dBm
	tx bitrate:	54.0 MBit/s
	rx bitrate:	1.0 MBit/s
	authorized:	yes
	authenticated:	yes
	preamble:	long
	WMM/WME:	yes
	MFP:		no
	TDLS peer:	no
Station 08:11:96:06:22:48 (on wlan0)
	inactive time:	76 ms
	rx bytes:	3290846
	rx packets:	83190
	tx bytes:	0
	tx packets:	0
	tx retries:	0
	tx failed:	0
	signal:  	-12 dBm
	signal avg:	-11 dBm
	tx bitrate:	1.0 MBit/s
	rx bitrate:	1.0 MBit/s
	authorized:	yes
	authenticated:	yes
	preamble:	long
	WMM/WME:	yes
	MFP:		no
	TDLS peer:	no
Station a0:88:b4:dc:f1:e0 (on wlan0)
	inactive time:	104 ms
	rx bytes:	3092949
	rx packets:	78249
	tx bytes:	0
	tx packets:	0
	tx retries:	0
	tx failed:	0
	signal:  	-24 dBm
	signal avg:	-23 dBm
	tx bitrate:	1.0 MBit/s
	rx bitrate:	1.0 MBit/s
	authorized:	yes
	authenticated:	yes
	preamble:	long
	WMM/WME:	yes
	MFP:		no
	TDLS peer:	no

--=-9F4AWkS31WNfOYSJ0pBg
Content-Type: multipart/mixed; boundary="=-xT8kmBF9taTOS2dF+UCn"

--=-xT8kmBF9taTOS2dF+UCn
Content-Type: text/plain
Content-Disposition: attachment; filename=phy.info

Wiphy phy0
	max # scan SSIDs: 20
	max scan IEs length: 195 bytes
	Coverage class: 0 (up to 0m)
	Device supports RSN-IBSS.
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
		 * monitor
	Band 1:
		Capabilities: 0x1072
			HT20/HT40
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT TX/RX MCS rate indexes supported: 0-15, 32
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
			* 2412 MHz [1] (15.0 dBm)
			* 2417 MHz [2] (15.0 dBm)
			* 2422 MHz [3] (15.0 dBm)
			* 2427 MHz [4] (15.0 dBm)
			* 2432 MHz [5] (15.0 dBm)
			* 2437 MHz [6] (15.0 dBm)
			* 2442 MHz [7] (15.0 dBm)
			* 2447 MHz [8] (15.0 dBm)
			* 2452 MHz [9] (15.0 dBm)
			* 2457 MHz [10] (15.0 dBm)
			* 2462 MHz [11] (15.0 dBm)
			* 2467 MHz [12] (15.0 dBm) (no IR)
			* 2472 MHz [13] (15.0 dBm) (no IR)
	Band 2:
		Capabilities: 0x1072
			HT20/HT40
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT TX/RX MCS rate indexes supported: 0-15, 32
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
			* 5180 MHz [36] (15.0 dBm) (no IR)
			* 5200 MHz [40] (15.0 dBm) (no IR)
			* 5220 MHz [44] (15.0 dBm) (no IR)
			* 5240 MHz [48] (15.0 dBm) (no IR)
			* 5260 MHz [52] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5280 MHz [56] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5300 MHz [60] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5320 MHz [64] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5500 MHz [100] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5520 MHz [104] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5540 MHz [108] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5560 MHz [112] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5580 MHz [116] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5600 MHz [120] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5620 MHz [124] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5640 MHz [128] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5660 MHz [132] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5680 MHz [136] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5700 MHz [140] (15.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 4080 sec)
			* 5745 MHz [149] (15.0 dBm) (no IR)
			* 5765 MHz [153] (15.0 dBm) (no IR)
			* 5785 MHz [157] (15.0 dBm) (no IR)
			* 5805 MHz [161] (15.0 dBm) (no IR)
			* 5825 MHz [165] (15.0 dBm) (no IR)
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
		 * Unknown command (104)
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
		 * #{ managed } <= 1, #{ AP } <= 1,
		   total <= 2, #channels <= 1, STA/AP BI must match
		 * #{ managed } <= 2,
		   total <= 2, #channels <= 1
	HT Capability overrides:
		 * MCS: ff ff ff ff ff ff ff ff ff ff
		 * maximum A-MSDU length
		 * supported channel width
		 * short GI for 40 MHz
		 * max A-MPDU length exponent
		 * min MPDU start spacing
	Device supports TX status socket option.
	Device supports HT-IBSS.
	Device supports scan flush.

--=-xT8kmBF9taTOS2dF+UCn
Content-Type: text/x-log
Content-Disposition: attachment; filename=dmesg.log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.14-2-amd64 (debian-kernel@lists.debian.org) (gcc version 4.8.3 (Debian 4.8.3-7) ) #1 SMP Debian 3.14.15-2 (2014-08-09)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.14-2-amd64 root=UUID=96100e50-8deb-404a-988b-681856ef65f9 ro quiet
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000da99efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da99f000-0x00000000dae9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd20000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021e5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: LENOVO 4290A11/4290A11, BIOS 8DET50WW (1.20 ) 07/07/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x21e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   5 base 100000000 mask F00000000 write-back
[    0.000000]   6 base 200000000 mask FE0000000 write-back
[    0.000000]   7 base 21F000000 mask FFF000000 uncachable
[    0.000000]   8 base 21E800000 mask FFF800000 uncachable
[    0.000000]   9 base 21E600000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdb000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01aaf000, 0x01aaffff] PGTABLE
[    0.000000] BRK [0x01ab0000, 0x01ab0fff] PGTABLE
[    0.000000] BRK [0x01ab1000, 0x01ab1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21e400000-0x21e5fffff]
[    0.000000]  [mem 0x21e400000-0x21e5fffff] page 2M
[    0.000000] BRK [0x01ab2000, 0x01ab2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21c000000-0x21e3fffff]
[    0.000000]  [mem 0x21c000000-0x21e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21bffffff]
[    0.000000]  [mem 0x200000000-0x21bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xda99efff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xda7fffff] page 2M
[    0.000000]  [mem 0xda800000-0xda99efff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdafff000-0xdaffffff]
[    0.000000]  [mem 0xdafff000-0xdaffffff] page 4k
[    0.000000] BRK [0x01ab3000, 0x01ab3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] BRK [0x01ab4000, 0x01ab4fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x3657e000-0x372b6fff]
[    0.000000] ACPI: RSDP 00000000000f00e0 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000daffe120 0000A4 (v01 LENOVO TP-8D    00001200 PTEC 00000002)
[    0.000000] ACPI: FACP 00000000dafe7000 0000F4 (v04 LENOVO TP-8D    00001200 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000dafea000 00F322 (v01 LENOVO TP-8D    00001200 INTL 20061109)
[    0.000000] ACPI: FACS 00000000daf2d000 000040
[    0.000000] ACPI: SLIC 00000000daffd000 000176 (v01 LENOVO TP-8D    00001200 PTEC 00000001)
[    0.000000] ACPI: SSDT 00000000daffc000 000249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffb000 000033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffa000 0007A7 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 00000000dafe6000 000038 (v01 LENOVO TP-8D    00001200 PTL  00000002)
[    0.000000] ACPI: APIC 00000000dafe5000 000098 (v01 LENOVO TP-8D    00001200 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dafe4000 00003C (v01 LENOVO TP-8D    00001200 PTL  00000002)
[    0.000000] ACPI: ECDT 00000000dafe3000 000052 (v01 LENOVO TP-8D    00001200 PTL  00000002)
[    0.000000] ACPI: ASF! 00000000dafe9000 0000A5 (v32 LENOVO TP-8D    00001200 PTL  00000002)
[    0.000000] ACPI: TCPA 00000000dafe2000 000032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 00000000dafe1000 000A27 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dafe0000 000996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 00000000dafdf000 00003E (v01 LENOVO TP-8D    00001200 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafde000 000042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: UEFI 00000000dafdd000 00027E (v01 LENOVO TP-8D    00001200 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21e5fffff]
[    0.000000]   NODE_DATA [mem 0x21e5f4000-0x21e5f8fff]
[    0.000000]  [ffffea0000000000-ffffea00077fffff] PMD -> [ffff880215c00000-ffff88021cdfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xda99efff]
[    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x21e5fffff]
[    0.000000] On node 0 totalpages: 2068284
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 156 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12186 pages used for memmap
[    0.000000]   DMA32 zone: 891296 pages, LIFO batch:31
[    0.000000]   Normal zone: 16037 pages used for memmap
[    0.000000]   Normal zone: 1172992 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xda99f000-0xdae9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdae9f000-0xdaf9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdaf9f000-0xdaffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed07fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffd1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffd20000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88021e200000 s86080 r8192 d24512 u262144
[    0.000000] pcpu-alloc: s86080 r8192 d24512 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2039849
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.14-2-amd64 root=UUID=96100e50-8deb-404a-988b-681856ef65f9 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8063968K/8273136K available (4957K kernel code, 747K rwdata, 1724K rodata, 1008K init, 960K bss, 209168K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:33024 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2492.119 MHz processor
[    0.000030] Calibrating delay loop (skipped), value calculated using timer frequency.. 4984.23 BogoMIPS (lpj=9968476)
[    0.000032] pid_max: default: 32768 minimum: 301
[    0.000039] ACPI: Core revision 20131218
[    0.005789] ACPI: All ACPI Tables successfully acquired
[    0.006668] Security Framework initialized
[    0.006675] AppArmor: AppArmor disabled by boot time parameter
[    0.006676] Yama: disabled by default; enable with sysctl kernel.yama.*
[    0.007124] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.008710] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.009403] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.009413] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.009588] Initializing cgroup subsys memory
[    0.009592] Initializing cgroup subsys devices
[    0.009594] Initializing cgroup subsys freezer
[    0.009595] Initializing cgroup subsys net_cls
[    0.009596] Initializing cgroup subsys blkio
[    0.009597] Initializing cgroup subsys perf_event
[    0.009618] Disabled fast string operations
[    0.009619] CPU: Physical Processor ID: 0
[    0.009620] CPU: Processor Core ID: 0
[    0.009624] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.009624] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.009627] mce: CPU supports 7 MCE banks
[    0.009638] CPU0: Thermal monitoring enabled (TM1)
[    0.009646] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.009646] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.009646] tlb_flushall_shift: 6
[    0.009720] Freeing SMP alternatives memory: 20K (ffffffff819b8000 - ffffffff819bd000)
[    0.011216] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.050909] smpboot: CPU0: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz (fam: 06, model: 2a, stepping: 07)
[    0.050917] TSC deadline timer enabled
[    0.050924] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
[    0.050929] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.050931] ... version:                3
[    0.050932] ... bit width:              48
[    0.050933] ... generic registers:      4
[    0.050934] ... value mask:             0000ffffffffffff
[    0.050934] ... max period:             0000ffffffffffff
[    0.050935] ... fixed-purpose events:   3
[    0.050936] ... event mask:             000000070000000f
[    0.051434] x86: Booting SMP configuration:
[    0.051436] .... node  #0, CPUs:      #1
[    0.062375] Disabled fast string operations
[    0.064579] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.064672]  #2
[    0.075709] Disabled fast string operations
[    0.077911]  #3<6>[    0.088947] Disabled fast string operations
[    0.091068] x86: Booted up 1 node, 4 CPUs
[    0.091072] smpboot: Total of 4 processors activated (19936.95 BogoMIPS)
[    0.094075] devtmpfs: initialized
[    0.098182] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
[    0.098326] pinctrl core: initialized pinctrl subsystem
[    0.098377] NET: Registered protocol family 16
[    0.098463] cpuidle: using governor ladder
[    0.098464] cpuidle: using governor menu
[    0.098490] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.098491] ACPI: bus type PCI registered
[    0.098493] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.098738] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.098741] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.098818] PCI: Using configuration type 1 for base access
[    0.099650] bio: create slab <bio-0> at 0
[    0.099755] ACPI: Added _OSI(Module Device)
[    0.099757] ACPI: Added _OSI(Processor Device)
[    0.099758] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.099759] ACPI: Added _OSI(Processor Aggregator Device)
[    0.101040] ACPI : EC: EC description table is found, configuring boot EC
[    0.104978] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.139630] ACPI: SSDT 00000000dae8c018 0008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.139953] ACPI: Dynamic OEM Table Load:
[    0.139955] ACPI: SSDT           (null) 0008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.151395] ACPI: SSDT 00000000dae8da98 000303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.151742] ACPI: Dynamic OEM Table Load:
[    0.151744] ACPI: SSDT           (null) 000303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.163282] ACPI: SSDT 00000000dae8bd98 000119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.163595] ACPI: Dynamic OEM Table Load:
[    0.163596] ACPI: SSDT           (null) 000119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.175744] ACPI: Interpreter enabled
[    0.175749] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
[    0.175753] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
[    0.175764] ACPI: (supports S0 S3 S4 S5)
[    0.175765] ACPI: Using IOAPIC for interrupt routing
[    0.175787] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.176635] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.191698] ACPI: Power Resource [PUBS] (on)
[    0.196182] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.196255] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 9 10 11)
[    0.196326] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.196395] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.196464] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11)
[    0.196518] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.196588] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11)
[    0.196658] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
[    0.196685] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.196690] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.196845] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.196917] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.196919] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.196920] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.196922] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.196947] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.197089] PCI host bridge to bus 0000:00
[    0.197091] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.197093] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.197094] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.197096] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.197097] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
[    0.197098] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.197105] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.197182] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
[    0.197192] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.197197] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.197201] pci 0000:00:02.0: reg 0x20: [io  0x5000-0x503f]
[    0.197292] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.197313] pci 0000:00:16.0: reg 0x10: [mem 0xf2525000-0xf252500f 64bit]
[    0.197377] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.197444] pci 0000:00:16.3: [8086:1c3d] type 00 class 0x070002
[    0.197461] pci 0000:00:16.3: reg 0x10: [io  0x50b0-0x50b7]
[    0.197469] pci 0000:00:16.3: reg 0x14: [mem 0xf252c000-0xf252cfff]
[    0.197595] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.197613] pci 0000:00:19.0: reg 0x10: [mem 0xf2500000-0xf251ffff]
[    0.197621] pci 0000:00:19.0: reg 0x14: [mem 0xf252b000-0xf252bfff]
[    0.197629] pci 0000:00:19.0: reg 0x18: [io  0x5080-0x509f]
[    0.197691] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.197722] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.197766] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.197787] pci 0000:00:1a.0: reg 0x10: [mem 0xf252a000-0xf252a3ff]
[    0.197875] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.197907] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.197952] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.197967] pci 0000:00:1b.0: reg 0x10: [mem 0xf2520000-0xf2523fff 64bit]
[    0.198042] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.198078] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.198124] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.198248] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.198330] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.198465] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.198548] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.198683] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.198726] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.198769] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
[    0.198903] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.198990] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.199010] pci 0000:00:1d.0: reg 0x10: [mem 0xf2529000-0xf25293ff]
[    0.199099] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.199129] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.199171] pci 0000:00:1f.0: [8086:1c4f] type 00 class 0x060100
[    0.199337] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.199354] pci 0000:00:1f.2: reg 0x10: [io  0x50a8-0x50af]
[    0.199362] pci 0000:00:1f.2: reg 0x14: [io  0x50bc-0x50bf]
[    0.199370] pci 0000:00:1f.2: reg 0x18: [io  0x50a0-0x50a7]
[    0.199378] pci 0000:00:1f.2: reg 0x1c: [io  0x50b8-0x50bb]
[    0.199385] pci 0000:00:1f.2: reg 0x20: [io  0x5060-0x507f]
[    0.199393] pci 0000:00:1f.2: reg 0x24: [mem 0xf2528000-0xf25287ff]
[    0.199437] pci 0000:00:1f.2: PME# supported from D3hot
[    0.199501] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.199517] pci 0000:00:1f.3: reg 0x10: [mem 0xf2524000-0xf25240ff 64bit]
[    0.199537] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    0.199686] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.199942] pci 0000:03:00.0: [8086:0085] type 00 class 0x028000
[    0.200105] pci 0000:03:00.0: reg 0x10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.200821] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.207329] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.207338] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.207451] acpiphp: Slot [1] registered
[    0.207458] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.207463] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.207468] pci 0000:00:1c.3:   bridge window [mem 0xf1c00000-0xf23fffff]
[    0.207476] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.207787] pci 0000:0d:00.0: [1180:e822] type 00 class 0x088001
[    0.207806] pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
[    0.207831] pci 0000:0d:00.0: reg 0x10: [mem 0xf1400000-0xf14000ff]
[    0.208044] pci 0000:0d:00.0: supports D1 D2
[    0.208045] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.215286] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.215296] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.215305] pci 0000:00:1c.4:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.215318] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.216156] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.216222] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.216301] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.216304] vgaarb: loaded
[    0.216305] vgaarb: bridge control possible 0000:00:02.0
[    0.216341] PCI: Using ACPI for IRQ routing
[    0.218035] PCI: pci_cache_line_size set to 64 bytes
[    0.218532] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.218533] e820: reserve RAM buffer [mem 0xda99f000-0xdbffffff]
[    0.218535] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.218536] e820: reserve RAM buffer [mem 0x21e600000-0x21fffffff]
[    0.218641] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.218646] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.220669] Switched to clocksource hpet
[    0.222295] pnp: PnP ACPI init
[    0.222310] ACPI: bus type PNP registered
[    0.222661] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.222663] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.222665] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.222666] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.222668] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.222669] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.222671] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.222672] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.222674] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.222676] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.222677] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.222679] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.222680] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.222681] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.222683] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.222685] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.222686] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.222689] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.222784] system 00:01: [io  0x0400-0x047f] could not be reserved
[    0.222785] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.222787] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.222788] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.222790] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.222792] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.222794] system 00:01: [mem 0x00000000-0x00000fff] could not be reserved
[    0.222795] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.222797] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.222798] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.222800] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.222802] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.222803] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.222856] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.222865] pnp 00:03: [dma 4]
[    0.222883] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.222906] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.222938] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.222964] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.222990] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.223017] pnp 00:08: Plug and Play ACPI device, IDs LEN0020 PNP0f13 (active)
[    0.223061] pnp 00:09: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.223534] pnp: PnP ACPI: found 10 devices
[    0.223536] ACPI: bus type PNP unregistered
[    0.229983] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.230002] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.230009] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.230020] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.230023] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.230029] pci 0000:00:1c.3:   bridge window [mem 0xf1c00000-0xf23fffff]
[    0.230034] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.230043] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.230046] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.230053] pci 0000:00:1c.4:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.230058] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.230067] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.230068] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.230069] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.230071] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
[    0.230072] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.230074] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.230075] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.230076] pci_bus 0000:05: resource 1 [mem 0xf1c00000-0xf23fffff]
[    0.230078] pci_bus 0000:05: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.230079] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.230081] pci_bus 0000:0d: resource 1 [mem 0xf1400000-0xf1bfffff]
[    0.230082] pci_bus 0000:0d: resource 2 [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.230137] NET: Registered protocol family 2
[    0.230308] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.230459] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.230581] TCP: Hash tables configured (established 65536 bind 65536)
[    0.230607] TCP: reno registered
[    0.230617] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.230646] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.230733] NET: Registered protocol family 1
[    0.230746] pci 0000:00:02.0: Boot video device
[    0.231175] PCI: CLS 64 bytes, default 64
[    0.231216] Unpacking initramfs...
[    0.469133] Freeing initrd memory: 13540K (ffff88003657e000 - ffff8800372b7000)
[    0.469137] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.469139] software IO TLB [mem 0xd699f000-0xda99f000] (64MB) mapped at [ffff8800d699f000-ffff8800da99efff]
[    0.469345] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.469386] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x18
[    0.469393] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x18
[    0.469402] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x18
[    0.469409] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x18
[    0.469475] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.469772] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.469826] audit: initializing netlink subsys (disabled)
[    0.469845] audit: type=2000 audit(1411992801.468:1): initialized
[    0.482410] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.482591] VFS: Disk quotas dquot_6.5.2
[    0.482611] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.482661] msgmni has been set to 15776
[    0.482874] alg: No test for stdrng (krng)
[    0.482898] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.482934] io scheduler noop registered
[    0.482936] io scheduler deadline registered
[    0.482952] io scheduler cfq registered (default)
[    0.483500] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.483514] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.483548] intel_idle: MWAIT substates: 0x21120
[    0.483550] intel_idle: v0.4 model 0x2A
[    0.483551] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.483725] GHES: HEST is not enabled!
[    0.483781] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.504396] 0000:00:16.3: ttyS0 at I/O 0x50b0 (irq = 19, base_baud = 115200) is a 16550A
[    0.504550] Linux agpgart interface v0.103
[    0.504640] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.507802] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.507806] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.507907] mousedev: PS/2 mouse device common for all mice
[    0.507948] rtc_cmos 00:06: RTC can wake from S4
[    0.508079] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.508107] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.508116] Intel P-state driver initializing.
[    0.508125] Intel pstate controlling: cpu 0
[    0.508143] Intel pstate controlling: cpu 1
[    0.508162] Intel pstate controlling: cpu 2
[    0.508176] Intel pstate controlling: cpu 3
[    0.508198] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[    0.508199] AMD IOMMUv2 functionality not available on this system
[    0.508290] TCP: cubic registered
[    0.508355] NET: Registered protocol family 10
[    0.508565] mip6: Mobile IPv6
[    0.508567] NET: Registered protocol family 17
[    0.508569] mpls_gso: MPLS GSO support
[    0.508824] registered taskstats version 1
[    0.509383] rtc_cmos 00:06: setting system clock to 2014-09-29 12:13:22 UTC (1411992802)
[    0.509440] PM: Hibernation image not present or could not be loaded.
[    0.509993] Freeing unused kernel memory: 1008K (ffffffff818bc000 - ffffffff819b8000)
[    0.509995] Write protecting the kernel read-only data: 8192k
[    0.514246] Freeing unused kernel memory: 1176K (ffff8800014da000 - ffff880001600000)
[    0.514903] Freeing unused kernel memory: 324K (ffff8800017af000 - ffff880001800000)
[    0.516182] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.523351] systemd-udevd[69]: starting version 208
[    0.523572] random: systemd-udevd urandom read with 2 bits of entropy available
[    0.533486] pps_core: LinuxPPS API ver. 1 registered
[    0.533490] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.533693] PTP clock support registered
[    0.534354] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    0.534357] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    0.534358] ACPI: bus type USB registered
[    0.534385] usbcore: registered new interface driver usbfs
[    0.534397] usbcore: registered new interface driver hub
[    0.534504] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.534526] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[    0.535290] sdhci: Secure Digital Host Controller Interface driver
[    0.535293] sdhci: Copyright(c) Pierre Ossman
[    0.535504] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 7)
[    0.536046] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[    0.538157] SCSI subsystem initialized
[    0.538429] thermal LNXTHERM:00: registered as thermal_zone0
[    0.538432] ACPI: Thermal Zone [THM0] (57 C)
[    0.540213] libata version 3.00 loaded.
[    0.543281] usbcore: registered new device driver usb
[    0.543602] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.543725] ehci-pci: EHCI PCI platform driver
[    0.733372] e1000e 0000:00:19.0 eth0: registered PHC clock
[    0.733380] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) f0:de:f1:7c:02:c3
[    0.733384] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    0.733440] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
[    0.733488] ahci 0000:00:1f.2: version 3.0
[    0.733652] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.733685] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    0.748904] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x13 impl SATA mode
[    0.748911] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    0.766181] scsi0 : ahci
[    0.766441] scsi1 : ahci
[    0.766663] scsi2 : ahci
[    0.766854] scsi3 : ahci
[    0.767044] scsi4 : ahci
[    0.767227] scsi5 : ahci
[    0.767334] ata1: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528100 irq 41
[    0.767339] ata2: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528180 irq 41
[    0.767341] ata3: DUMMY
[    0.767343] ata4: DUMMY
[    0.767346] ata5: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528300 irq 41
[    0.767348] ata6: DUMMY
[    0.767614] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.767625] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.767645] ehci-pci 0000:00:1a.0: debug port 2
[    0.771577] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.771586] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf252a000
[    0.780795] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.780961] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.780964] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.780966] usb usb1: Product: EHCI Host Controller
[    0.780967] usb usb1: Manufacturer: Linux 3.14-2-amd64 ehci_hcd
[    0.780969] usb usb1: SerialNumber: 0000:00:1a.0
[    0.781228] hub 1-0:1.0: USB hub found
[    0.781244] hub 1-0:1.0: 3 ports detected
[    0.781500] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.781506] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.781523] ehci-pci 0000:00:1d.0: debug port 2
[    0.785434] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.785453] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf2529000
[    0.796809] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.796869] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.796872] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.796874] usb usb2: Product: EHCI Host Controller
[    0.796876] usb usb2: Manufacturer: Linux 3.14-2-amd64 ehci_hcd
[    0.796878] usb usb2: SerialNumber: 0000:00:1d.0
[    0.797049] hub 2-0:1.0: USB hub found
[    0.797062] hub 2-0:1.0: 3 ports detected
[    1.088953] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.090131] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.090142] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.090147] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.091213] ata1.00: ATA-8: HITACHI HTS723232A7A364, EC2ZB70B, max UDMA/100
[    1.091222] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.092468] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.092478] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.092483] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.093057] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.093625] ata1.00: configured for UDMA/100
[    1.094059] scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS72323 EC2Z PQ: 0 ANSI: 5
[    1.225845] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.225854] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.226590] hub 1-1:1.0: USB hub found
[    1.226915] hub 1-1:1.0: 6 ports detected
[    1.340957] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.413003] ata2: SATA link down (SStatus 0 SControl 300)
[    1.469007] tsc: Refined TSC clocksource calibration: 2491.909 MHz
[    1.473739] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.473748] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.474335] hub 2-1:1.0: USB hub found
[    1.474525] hub 2-1:1.0: 8 ports detected
[    1.549294] usb 1-1.4: new full-speed USB device number 3 using ehci-pci
[    1.648155] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
[    1.648164] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.648169] usb 1-1.4: Product: Broadcom Bluetooth Device
[    1.648172] usb 1-1.4: Manufacturer: Broadcom Corp
[    1.648176] usb 1-1.4: SerialNumber: CCAF78EEDB01
[    1.721318] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
[    1.741049] ata5: SATA link down (SStatus 0 SControl 300)
[    1.747975] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.748072] sd 0:0:0:0: [sda] Write Protect is off
[    1.748081] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.748137] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.805378]  sda: sda1 sda2 < sda5 >
[    1.806401] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.807555] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.820628] usb 1-1.6: New USB device found, idVendor=04f2, idProduct=b217
[    1.820636] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.820641] usb 1-1.6: Product: Integrated Camera
[    1.820644] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    2.065505] PM: Starting manual resume from disk
[    2.065515] PM: Hibernation image partition 8:5 present
[    2.065518] PM: Looking for hibernation image.
[    2.065816] PM: Image not found (code -22)
[    2.065819] PM: Hibernation image not present or could not be loaded.
[    2.115119] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    2.469450] Switched to clocksource tsc
[    2.940370] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    3.175701] systemd[1]: Inserted module 'autofs4'
[    3.188790] systemd[1]: Set hostname to <core01>.
[    3.480387] random: nonblocking pool is initialized
[    4.099027] systemd[1]: Starting Syslog Socket.
[    4.099115] systemd[1]: Listening on Syslog Socket.
[    4.099144] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    4.099248] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    4.099269] systemd[1]: Starting Remote File Systems (Pre).
[    4.099289] systemd[1]: Reached target Remote File Systems (Pre).
[    4.099306] systemd[1]: Starting Delayed Shutdown Socket.
[    4.099345] systemd[1]: Listening on Delayed Shutdown Socket.
[    4.099362] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    4.099410] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    4.099435] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    4.099489] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    4.099507] systemd[1]: Starting Paths.
[    4.099524] systemd[1]: Reached target Paths.
[    4.099547] systemd[1]: Starting udev Kernel Socket.
[    4.099579] systemd[1]: Listening on udev Kernel Socket.
[    4.099600] systemd[1]: Starting udev Control Socket.
[    4.099635] systemd[1]: Listening on udev Control Socket.
[    4.099652] systemd[1]: Starting Encrypted Volumes.
[    4.099668] systemd[1]: Reached target Encrypted Volumes.
[    4.099718] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    4.099874] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    4.099898] systemd[1]: Starting Journal Socket.
[    4.099967] systemd[1]: Listening on Journal Socket.
[    4.100000] systemd[1]: Mounting POSIX Message Queue File System...
[    4.100887] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    4.161282] systemd[1]: Started Set Up Additional Binary Formats.
[    4.161390] systemd[1]: Starting udev Coldplug all Devices...
[    4.162091] systemd[1]: Starting Syslog.
[    4.162114] systemd[1]: Reached target Syslog.
[    4.162156] systemd[1]: Starting Journal Service...
[    4.162822] systemd[1]: Started Journal Service.
[    4.383347] fuse init (API version 7.22)
[    5.409081] systemd-udevd[179]: starting version 208
[    7.017964] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    7.026996] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    7.049793] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    7.051694] ACPI: Lid Switch [LID]
[    7.051773] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    7.051777] ACPI: Sleep Button [SLPB]
[    7.051839] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    7.051861] ACPI: Power Button [PWRF]
[    7.054836] ACPI: Battery Slot [BAT0] (battery present)
[    7.093109] tpm_tis 00:09: 1.2 TPM (device-id 0x0, rev-id 78)
[    7.131508] ACPI: AC Adapter [AC] (on-line)
[    7.185558] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    7.290526] wmi: Mapper loaded
[    7.301088] mei_me 0000:00:16.0: irq 42 for MSI/MSI-X
[    7.306349] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\_SB_.PCI0.LPC_.PMIO) (20131218/utaddress-258)
[    7.306356] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.306377] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) (20131218/utaddress-258)
[    7.306380] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.306382] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) (20131218/utaddress-258)
[    7.306385] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.306386] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) (20131218/utaddress-258)
[    7.306389] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.306390] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    7.402854] [drm] Initialized drm 1.1.0 20060810
[    7.419054] iTCO_vendor_support: vendor-support=0
[    7.419389] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    7.419420] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
[    7.419479] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.813508] Non-volatile memory driver v1.3
[    7.838415] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[    7.838422] thinkpad_acpi: http://ibm-acpi.sf.net/
[    7.838425] thinkpad_acpi: ThinkPad BIOS 8DET50WW (1.20 ), EC unknown
[    7.838428] thinkpad_acpi: Lenovo ThinkPad X220, model 4290A11
[    7.839136] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[    7.839322] thinkpad_acpi: radio switch found; radios are enabled
[    7.839487] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[    7.839715] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    7.839720] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    7.842540] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    7.843197] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[    7.843373] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    7.846282] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input7
[    7.874998] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    7.876920] [drm] Memory usable by graphics device = 2048M
[    7.902072] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[    7.902371] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    7.902373] [drm] Driver supports precise vblank timestamp query.
[    7.902469] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    7.950365] [drm] Wrong MCH_SSKPD value: 0x16040307
[    7.950370] [drm] This can cause pipe underruns and display issues.
[    7.950372] [drm] Please upgrade your BIOS to fix this.
[    8.022012] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    8.039271] fbcon: inteldrmfb (fb0) is primary device
[    8.188128] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.0, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x120c00, board id: 1611, fw id: 774180
[    8.188145] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    8.218774] AVX version of gcm_enc/dec engaged.
[    8.222333] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    8.238345] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input6
[    8.463420] Bluetooth: Core ver 2.18
[    8.463459] NET: Registered protocol family 31
[    8.463460] Bluetooth: HCI device and connection manager initialized
[    8.463469] Bluetooth: HCI socket layer initialized
[    8.463471] Bluetooth: L2CAP socket layer initialized
[    8.463485] Bluetooth: SCO socket layer initialized
[    8.579240] cfg80211: Calling CRDA to update world regulatory domain
[    8.656662] systemd-journald[155]: Received request to flush runtime journal from PID 1
[    8.684573] usbcore: registered new interface driver btusb
[    8.772628] Console: switching to colour frame buffer device 170x48
[    8.778589] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    8.778592] i915 0000:00:02.0: registered panic notifier
[    8.814796] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    8.831678] acpi device:01: registered as cooling_device4
[    8.831784] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input9
[    8.832217] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    8.832831] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[    8.887029] alg: No test for crc32 (crc32-pclmul)
[    8.967302] systemd-journald[155]: Received request to flush runtime journal from PID 1
[    9.090415] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    9.090421] Copyright(c) 2003- 2014 Intel Corporation
[    9.090671] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    9.090893] iwlwifi 0000:03:00.0: irq 45 for MSI/MSI-X
[    9.105325] iwlwifi 0000:03:00.0: firmware: failed to load iwlwifi-6000g2a-6.ucode (-2)
[    9.105411] iwlwifi 0000:03:00.0: Direct firmware load failed with error -2
[    9.105414] iwlwifi 0000:03:00.0: Falling back to user helper
[    9.125634] iwlwifi 0000:03:00.0: firmware: direct-loading firmware iwlwifi-6000g2a-5.ucode
[    9.125829] iwlwifi 0000:03:00.0: loaded firmware version 17.168.5.1 build 33993 op_mode iwldvm
[    9.202754] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    9.202764] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    9.202770] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    9.202776] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, REV=0xB0
[    9.202878] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    9.301160] media: Linux media interface: v0.10
[    9.320599] Linux video capture interface: v2.00
[    9.331463] hda_codec: CX20590: BIOS auto-probing.
[    9.332974] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input10
[    9.502160] kvm: disabled by bios
[    9.511160] kvm: disabled by bios
[    9.534816] kvm: disabled by bios
[    9.567482] kvm: disabled by bios
[    9.618658] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    9.643876] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[    9.643955] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[    9.644009] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[    9.644060] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    9.644109] input: HDA Intel PCH Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    9.644158] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    9.644206] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    9.794680] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   10.022162] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b217)
[   10.024974] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input18
[   10.025141] usbcore: registered new interface driver uvcvideo
[   10.025145] USB Video Class driver (1.1.1)
[   10.346763] cfg80211: World regulatory domain updated:
[   10.346767] cfg80211:  DFS Master region: unset
[   10.346768] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   10.346770] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   10.346772] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   10.346773] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[   10.346774] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm)
[   10.346775] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm)
[   10.346776] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm)
[   10.741616] Adding 12683260k swap on /dev/sda5.  Priority:-1 extents:1 across:12683260k 
[   11.734533] RPC: Registered named UNIX socket transport module.
[   11.734541] RPC: Registered udp transport module.
[   11.734543] RPC: Registered tcp transport module.
[   11.734545] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   11.778586] FS-Cache: Loaded
[   11.797374] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[   11.806410] FS-Cache: Netfs 'nfs' registered for caching
[   11.856292] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   13.323916] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   13.576951] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input8
[   15.002641] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   15.002651] Bluetooth: BNEP filters: protocol multicast
[   15.002668] Bluetooth: BNEP socket layer initialized
[   16.800017] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[   16.903599] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[   16.903848] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.393735] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[   18.393750] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
[   18.393795] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   47.472351] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   47.472569] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   47.740136] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   47.740355] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   47.848504] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   49.147163] iwlwifi 0000:03:00.0: failed to remove IBSS station ba:b6:e2:b3:da:0f
[   51.829621] wlan0: Trigger new scan to find an IBSS to join
[   52.104138] wlan0: Selected IBSS BSSID ba:b6:e2:b3:da:0f based on configured SSID
[   52.127811] iwlwifi 0000:03:00.0: Unable to find TIM Element in beacon
[   52.130359] iwlwifi 0000:03:00.0: Unable to find TIM Element in beacon
[   52.130636] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

--=-xT8kmBF9taTOS2dF+UCn--

--=-9F4AWkS31WNfOYSJ0pBg--

