Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:37146 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdHQLMk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 07:12:40 -0400
Received: by mail-lf0-f47.google.com with SMTP id f7so8340021lfg.4
        for <linux-wireless@vger.kernel.org>; Thu, 17 Aug 2017 04:12:39 -0700 (PDT)
Received: from debian (c83-253-195-111.bredband.comhem.se. [83.253.195.111])
        by smtp.gmail.com with ESMTPSA id r70sm728156lfr.48.2017.08.17.04.12.36
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Aug 2017 04:12:36 -0700 (PDT)
Received: from iveqy by debian with local (Exim 4.84)
        (envelope-from <iveqy@paksenarrion.iveqy.com>)
        id 1diIoO-0004Ot-Kn
        for linux-wireless@vger.kernel.org; Thu, 17 Aug 2017 13:18:04 +0200
Date: Thu, 17 Aug 2017 13:18:04 +0200
From: Fredrik Gustafsson <iveqy@iveqy.com>
To: linux-wireless@vger.kernel.org
Subject: iw not finding physical interface
Message-ID: <20170817111804.GE24362@paksenarrion.iveqy.com> (sfid-20170817_131245_223175_D9EB18BA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've a dwlink dwi-131 usb wifi adapter that I'm trying to use with buildroot (for a sama5d2xplained board) for hostadp.

I use a driver from github:
https://github.com/Mange/rtl8192eu-linux-driver

The driver works and I can successfully connect to my AP. But setting up hostapd on the device itself fails. I suppose this is because the physical network device is not found by iw. However it is found by ip, iwconfig and ipconfig.

How can I debug this?

    # uname -a
    Linux buildroot 4.9.30-linux4sam_5.6 #1 Wed Aug 16 12:59:06 CEST 2017 armv7l GNU/Linux
    # ifconfig -a
    can0      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  
    		  NOARP  MTU:16  Metric:1
    		  RX packets:0 errors:0 dropped:0 overruns:0 frame:0
    		  TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
    		  collisions:0 txqueuelen:10 
    		  RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
    		  Interrupt:39 

    can1      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  
    		  NOARP  MTU:16  Metric:1
    		  RX packets:0 errors:0 dropped:0 overruns:0 frame:0
    		  TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
    		  collisions:0 txqueuelen:10 
    		  RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
    		  Interrupt:50 

    eth0      Link encap:Ethernet  HWaddr FC:C2:3D:02:EC:32  
    		  inet addr:192.168.0.109  Bcast:192.168.0.255  Mask:255.255.255.0
    		  BROADCAST MULTICAST  MTU:1500  Metric:1
    		  RX packets:924 errors:0 dropped:0 overruns:0 frame:0
    		  TX packets:380 errors:0 dropped:0 overruns:0 carrier:0
    		  collisions:0 txqueuelen:1000 
    		  RX bytes:1147892 (1.0 MiB)  TX bytes:37366 (36.4 KiB)
    		  Interrupt:30 Base address:0x8000 

    hwsim0    Link encap:UNSPEC  HWaddr 12-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  
    		  BROADCAST MULTICAST  MTU:1500  Metric:1
    		  RX packets:0 errors:0 dropped:0 overruns:0 frame:0
    		  TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
    		  collisions:0 txqueuelen:1000 
    		  RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

    lo        Link encap:Local Loopback  
    		  inet addr:127.0.0.1  Mask:255.0.0.0
    		  inet6 addr: ::1/128 Scope:Host
    		  UP LOOPBACK RUNNING  MTU:65536  Metric:1
    		  RX packets:0 errors:0 dropped:0 overruns:0 frame:0
    		  TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
    		  collisions:0 txqueuelen:1 
    		  RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

    sit0      Link encap:IPv6-in-IPv4  
    		  NOARP  MTU:1480  Metric:1
    		  RX packets:0 errors:0 dropped:0 overruns:0 frame:0
    		  TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
    		  collisions:0 txqueuelen:1 
    		  RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

    wlan0     Link encap:Ethernet  HWaddr 02:00:00:00:00:00  
    		  BROADCAST MULTICAST  MTU:1500  Metric:1
    		  RX packets:0 errors:0 dropped:0 overruns:0 frame:0
    		  TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
    		  collisions:0 txqueuelen:1000 
    		  RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

    wlan1     Link encap:Ethernet  HWaddr 02:00:00:00:01:00  
    		  BROADCAST MULTICAST  MTU:1500  Metric:1
    		  RX packets:0 errors:0 dropped:0 overruns:0 frame:0
    		  TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
    		  collisions:0 txqueuelen:1000 
    		  RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

    wlan2     Link encap:Ethernet  HWaddr 54:2A:A2:A7:0D:C8  
    		  BROADCAST MULTICAST  MTU:1500  Metric:1
    		  RX packets:0 errors:0 dropped:0 overruns:0 frame:0
    		  TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
    		  collisions:0 txqueuelen:1000 
    		  RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

    # iwconfig 
    wlan1     IEEE 802.11  ESSID:off/any  
    		  Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm   
    		  Retry short limit:7   RTS thr:off   Fragment thr:off
    		  Encryption key:off
    		  Power Management:on
    		  
    sit0      no wireless extensions.

    lo        no wireless extensions.

    wlan0     IEEE 802.11  ESSID:off/any  
    		  Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm   
    		  Retry short limit:7   RTS thr:off   Fragment thr:off
    		  Encryption key:off
    		  Power Management:on
    		  
    can0      no wireless extensions.

    wlan2     unassociated  Nickname:"<WIFI@REALTEK>"
    		  Mode:Managed  Frequency=2.412 GHz  Access Point: Not-Associated   
    		  Sensitivity:0/0  
    		  Retry:off   RTS thr:off   Fragment thr:off
    		  Encryption key:off
    		  Power Management:off
    		  Link Quality:0  Signal level:0  Noise level:0
    		  Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
    		  Tx excessive retries:0  Invalid misc:0   Missed beacon:0

    hwsim0    no wireless extensions.

    can1      no wireless extensions.

    eth0      no wireless extensions.


    # cat /etc/hostapd.conf 
    interface=wlan2
    driver=nl80211
    ssid=myssid
    hw_mode=g
    channel=1
    wpa=3
    wpa_passphrase=secret
    wpa_key_mgmt=WPA-PSK
    wpa_pairwise=TKIP
    rsn_pairwise=CCMP
    # hostapd -dd /etc/hostapd.conf 
    random: Trying to read entropy from /dev/random
    Configuration file: /etc/hostapd.conf
    nl80211: TDLS supported
    nl80211: TDLS external setup
    nl80211: Supported cipher 00-0f-ac:1
    nl80211: Supported cipher 00-0f-ac:5
    nl80211: Supported cipher 00-0f-ac:2
    nl80211: Supported cipher 00-0f-ac:4
    nl80211: Supported cipher 00-0f-ac:10
    nl80211: Supported cipher 00-0f-ac:8
    nl80211: Supported cipher 00-0f-ac:9
    nl80211: Supported cipher 00-0f-ac:6
    nl80211: Supported cipher 00-0f-ac:13
    nl80211: Supported cipher 00-0f-ac:11
    nl80211: Supported cipher 00-0f-ac:12
    nl80211: Using driver-based off-channel TX
    nl80211: Driver-advertised extended capabilities (default) - hexdump(len=8): 04 00 00 00 00 00 00 40
    nl80211: Driver-advertised extended capabilities mask (default) - hexdump(len=8): 04 00 00 00 00 00 00 40
    nl80211: Supported vendor command: vendor_id=0x1374 subcmd=1
    nl80211: Supported vendor event: vendor_id=0x1374 subcmd=1
    nl80211: TDLS supported
    nl80211: TDLS external setup
    nl80211: Supported cipher 00-0f-ac:1
    nl80211: Supported cipher 00-0f-ac:5
    nl80211: Supported cipher 00-0f-ac:2
    nl80211: Supported cipher 00-0f-ac:4
    nl80211: Supported cipher 00-0f-ac:10
    nl80211: Supported cipher 00-0f-ac:8
    nl80211: Supported cipher 00-0f-ac:9
    nl80211: Supported cipher 00-0f-ac:6
    nl80211: Supported cipher 00-0f-ac:13
    nl80211: Supported cipher 00-0f-ac:11
    nl80211: Supported cipher 00-0f-ac:12
    nl80211: Using driver-based off-channel TX
    nl80211: Supported vendor command: vendor_id=0x1374 subcmd=1
    nl80211: Supported vendor event: vendor_id=0x1374 subcmd=1
    nl80211: Use separate P2P group interface (driver advertised support)
    nl80211: use P2P_DEVICE support
    nl80211: interface wlan2 in phy phy0
    nl80211: Set mode ifindex 10 iftype 3 (AP)
    nl80211: Failed to set interface 10 to mode 3: -19 (No such device)
    nl80211: Could not configure driver mode
    nl80211: deinit ifname=wlan2 disabled_11b_rates=0
    nl80211: Remove monitor interface: refcount=0
    netlink: Operstate: ifindex=10 linkmode=0 (kernel-control), operstate=6 (IF_OPER_UP)
    nl80211: Set mode ifindex 10 iftype 2 (STATION)
    nl80211: Failed to set interface 10 to mode 2: -19 (No such device)
    nl80211 driver initialization failed.
    hostapd_interface_deinit_free(0x7f2e0)
    hostapd_interface_deinit_free: num_bss=1 conf->num_bss=1
    hostapd_interface_deinit(0x7f2e0)
    wlan2: interface state UNINITIALIZED->DISABLED
    hostapd_bss_deinit: deinit bss wlan2
    wlan2: AP-DISABLED 
    hostapd_cleanup(hapd=0x80110 (wlan2))
    hostapd_free_hapd_data: Interface wlan2 wasn't started
    hostapd_interface_deinit_free: driver=(nil) drv_priv=(nil) -> hapd_deinit
    hostapd_interface_free(0x7f2e0)
    hostapd_interface_free: free hapd 0x80110
    hostapd_cleanup_iface(0x7f2e0)
    hostapd_cleanup_iface_partial(0x7f2e0)
    hostapd_cleanup_iface: free iface=0x7f2e0
    # 
    Wiphy phy1
    	max # scan SSIDs: 4
    	max scan IEs length: 2243 bytes
    	max # sched scan SSIDs: 0
    	max # match sets: 0
    	max # scan plans: 1
    	max scan plan interval: -1
    	max scan plan iterations: 0
    	Retry short limit: 7
    	Retry long limit: 4
    	Coverage class: 0 (up to 0m)
    	Device supports RSN-IBSS.
    	Device supports AP-side u-APSD.
    	Device supports T-DLS.
    	Supported Ciphers:
    		* WEP40 (00-0f-ac:1)
    		* WEP104 (00-0f-ac:5)
    		* TKIP (00-0f-ac:2)
    		* CCMP-128 (00-0f-ac:4)
    		* CCMP-256 (00-0f-ac:10)
    		* GCMP-128 (00-0f-ac:8)
    		* GCMP-256 (00-0f-ac:9)
    		* CMAC (00-0f-ac:6)
    		* CMAC-256 (00-0f-ac:13)
    		* GMAC-128 (00-0f-ac:11)
    		* GMAC-256 (00-0f-ac:12)
    	Available Antennas: TX 0 RX 0
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
    		Minimum RX AMPDU time spacing: 8 usec (0x06)
    		HT TX/RX MCS rate indexes supported: 0-15
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
    			* 2467 MHz [12] (20.0 dBm) (no IR)
    			* 2472 MHz [13] (20.0 dBm) (no IR)
    			* 2484 MHz [14] (20.0 dBm) (no IR)
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
    		Minimum RX AMPDU time spacing: 8 usec (0x06)
    		HT TX/RX MCS rate indexes supported: 0-15
    		VHT Capabilities (0x038007fa):
    			Max MPDU length: 11454
    			Supported Channel Width: 160 MHz, 80+80 MHz
    			RX LDPC
    			short GI (80 MHz)
    			short GI (160/80+80 MHz)
    			TX STBC
    		VHT RX MCS set:
    			1 streams: MCS 0-9
    			2 streams: MCS 0-9
    			3 streams: MCS 0-9
    			4 streams: MCS 0-9
    			5 streams: MCS 0-9
    			6 streams: MCS 0-9
    			7 streams: MCS 0-9
    			8 streams: MCS 0-9
    		VHT RX highest supported: 0 Mbps
    		VHT TX MCS set:
    			1 streams: MCS 0-9
    			2 streams: MCS 0-9
    			3 streams: MCS 0-9
    			4 streams: MCS 0-9
    			5 streams: MCS 0-9
    			6 streams: MCS 0-9
    			7 streams: MCS 0-9
    			8 streams: MCS 0-9
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
    			* 5180 MHz [36] (20.0 dBm) (no IR)
    			* 5200 MHz [40] (20.0 dBm) (no IR)
    			* 5220 MHz [44] (20.0 dBm) (no IR)
    			* 5240 MHz [48] (20.0 dBm) (no IR)
    			* 5260 MHz [52] (20.0 dBm) (no IR, radar detection)
    			* 5280 MHz [56] (20.0 dBm) (no IR, radar detection)
    			* 5300 MHz [60] (20.0 dBm) (no IR, radar detection)
    			* 5320 MHz [64] (20.0 dBm) (no IR, radar detection)
    			* 5500 MHz [100] (20.0 dBm) (no IR, radar detection)
    			* 5520 MHz [104] (20.0 dBm) (no IR, radar detection)
    			* 5540 MHz [108] (20.0 dBm) (no IR, radar detection)
    			* 5560 MHz [112] (20.0 dBm) (no IR, radar detection)
    			* 5580 MHz [116] (20.0 dBm) (no IR, radar detection)
    			* 5600 MHz [120] (20.0 dBm) (no IR, radar detection)
    			* 5620 MHz [124] (20.0 dBm) (no IR, radar detection)
    			* 5640 MHz [128] (20.0 dBm) (no IR, radar detection)
    			* 5660 MHz [132] (20.0 dBm) (no IR, radar detection)
    			* 5680 MHz [136] (20.0 dBm) (no IR, radar detection)
    			* 5700 MHz [140] (20.0 dBm) (no IR, radar detection)
    			* 5745 MHz [149] (20.0 dBm) (no IR)
    			* 5765 MHz [153] (20.0 dBm) (no IR)
    			* 5785 MHz [157] (20.0 dBm) (no IR)
    			* 5805 MHz [161] (20.0 dBm) (no IR)
    			* 5825 MHz [165] (20.0 dBm) (no IR)
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
    		 * tdls_mgmt
    		 * tdls_oper
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
    		 * #{ IBSS } <= 1, #{ managed, AP, mesh point, P2P-client, P2P-GO } <= 2048, #{ P2P-device } <= 1,
    		   total <= 2048, #channels <= 1, radar detect widths: { 20 MHz (no HT), 20 MHz, 40 MHz, 80 MHz, 160 MHz }

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
    	Device supports low priority scan.
    	Device supports scan flush.
    	Device supports AP scan.
    	Device supports per-vif TX power setting
    	Driver supports full state transitions for AP/GO clients
    	Driver supports a userspace MPM
    	Device supports active monitor (which will ACK incoming frames)
    	Driver/device bandwidth changes during BSS lifetime (AP/GO mode)
    	Device supports static SMPS
    	Device supports dynamic SMPS
    	Device supports configuring vdev MAC-addr on create.
    	Device supports VHT-IBSS.
    Wiphy phy0
    	max # scan SSIDs: 4
    	max scan IEs length: 2243 bytes
    	max # sched scan SSIDs: 0
    	max # match sets: 0
    	max # scan plans: 1
    	max scan plan interval: -1
    	max scan plan iterations: 0
    	Retry short limit: 7
    	Retry long limit: 4
    	Coverage class: 0 (up to 0m)
    	Device supports RSN-IBSS.
    	Device supports AP-side u-APSD.
    	Device supports T-DLS.
    	Supported Ciphers:
    		* WEP40 (00-0f-ac:1)
    		* WEP104 (00-0f-ac:5)
    		* TKIP (00-0f-ac:2)
    		* CCMP-128 (00-0f-ac:4)
    		* CCMP-256 (00-0f-ac:10)
    		* GCMP-128 (00-0f-ac:8)
    		* GCMP-256 (00-0f-ac:9)
    		* CMAC (00-0f-ac:6)
    		* CMAC-256 (00-0f-ac:13)
    		* GMAC-128 (00-0f-ac:11)
    		* GMAC-256 (00-0f-ac:12)
    	Available Antennas: TX 0 RX 0
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
    		Minimum RX AMPDU time spacing: 8 usec (0x06)
    		HT TX/RX MCS rate indexes supported: 0-15
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
    			* 2467 MHz [12] (20.0 dBm) (no IR)
    			* 2472 MHz [13] (20.0 dBm) (no IR)
    			* 2484 MHz [14] (20.0 dBm) (no IR)
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
    		Minimum RX AMPDU time spacing: 8 usec (0x06)
    		HT TX/RX MCS rate indexes supported: 0-15
    		VHT Capabilities (0x038007fa):
    			Max MPDU length: 11454
    			Supported Channel Width: 160 MHz, 80+80 MHz
    			RX LDPC
    			short GI (80 MHz)
    			short GI (160/80+80 MHz)
    			TX STBC
    		VHT RX MCS set:
    			1 streams: MCS 0-9
    			2 streams: MCS 0-9
    			3 streams: MCS 0-9
    			4 streams: MCS 0-9
    			5 streams: MCS 0-9
    			6 streams: MCS 0-9
    			7 streams: MCS 0-9
    			8 streams: MCS 0-9
    		VHT RX highest supported: 0 Mbps
    		VHT TX MCS set:
    			1 streams: MCS 0-9
    			2 streams: MCS 0-9
    			3 streams: MCS 0-9
    			4 streams: MCS 0-9
    			5 streams: MCS 0-9
    			6 streams: MCS 0-9
    			7 streams: MCS 0-9
    			8 streams: MCS 0-9
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
    			* 5180 MHz [36] (20.0 dBm) (no IR)
    			* 5200 MHz [40] (20.0 dBm) (no IR)
    			* 5220 MHz [44] (20.0 dBm) (no IR)
    			* 5240 MHz [48] (20.0 dBm) (no IR)
    			* 5260 MHz [52] (20.0 dBm) (no IR, radar detection)
    			* 5280 MHz [56] (20.0 dBm) (no IR, radar detection)
    			* 5300 MHz [60] (20.0 dBm) (no IR, radar detection)
    			* 5320 MHz [64] (20.0 dBm) (no IR, radar detection)
    			* 5500 MHz [100] (20.0 dBm) (no IR, radar detection)
    			* 5520 MHz [104] (20.0 dBm) (no IR, radar detection)
    			* 5540 MHz [108] (20.0 dBm) (no IR, radar detection)
    			* 5560 MHz [112] (20.0 dBm) (no IR, radar detection)
    			* 5580 MHz [116] (20.0 dBm) (no IR, radar detection)
    			* 5600 MHz [120] (20.0 dBm) (no IR, radar detection)
    			* 5620 MHz [124] (20.0 dBm) (no IR, radar detection)
    			* 5640 MHz [128] (20.0 dBm) (no IR, radar detection)
    			* 5660 MHz [132] (20.0 dBm) (no IR, radar detection)
    			* 5680 MHz [136] (20.0 dBm) (no IR, radar detection)
    			* 5700 MHz [140] (20.0 dBm) (no IR, radar detection)
    			* 5745 MHz [149] (20.0 dBm) (no IR)
    			* 5765 MHz [153] (20.0 dBm) (no IR)
    			* 5785 MHz [157] (20.0 dBm) (no IR)
    			* 5805 MHz [161] (20.0 dBm) (no IR)
    			* 5825 MHz [165] (20.0 dBm) (no IR)
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
    		 * tdls_mgmt
    		 * tdls_oper
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
    		 * #{ IBSS } <= 1, #{ managed, AP, mesh point, P2P-client, P2P-GO } <= 2048, #{ P2P-device } <= 1,
    		   total <= 2048, #channels <= 1, radar detect widths: { 20 MHz (no HT), 20 MHz, 40 MHz, 80 MHz, 160 MHz }

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
    	Device supports low priority scan.
    	Device supports scan flush.
    	Device supports AP scan.
    	Device supports per-vif TX power setting
    	Driver supports full state transitions for AP/GO clients
    	Driver supports a userspace MPM
    	Device supports active monitor (which will ACK incoming frames)
    	Driver/device bandwidth changes during BSS lifetime (AP/GO mode)
    	Device supports static SMPS
    	Device supports dynamic SMPS
    	Device supports configuring vdev MAC-addr on create.
    	Device supports VHT-IBSS.

-- 
Fredrik Gustafsson

phone: +46 733-608274
e-mail: iveqy@iveqy.com
website: http://www.iveqy.com
