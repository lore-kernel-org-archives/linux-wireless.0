Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f196.google.com ([209.85.212.196]:65039 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaJNA7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 20:59:36 -0400
Received: by mail-wi0-f196.google.com with SMTP id n3so3419085wiv.7
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2014 17:59:34 -0700 (PDT)
Message-ID: <543C7573.30701@gmail.com> (sfid-20141014_025948_122328_6EAAD855)
Date: Tue, 14 Oct 2014 02:59:31 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Joshua Roys <Joshua.Roys@gtri.gatech.edu>,
	Dan Williams <dcbw@redhat.com>,
	Network Manager <networkmanager-list@gnome.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	lizhaoming <chaoming_li@realsil.com.cn>,
	Realtek WlanFAE <wlanfae@realtek.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8188SU(rtl8192su) & rtl8192sufw-ap.bin
References: <54292675.4090607@gmail.com>	<1412019981.5379.2.camel@dcbw.local>	<542CCA4B.7030201@gmail.com> <CAAd0S9ARKg4RSQ_CYrEu8ggm3mWqL8a3ODgJDMnaKbHXpMZPCA@mail.gmail.com> <542D697B.40502@gmail.com> <5432FCB6.5010900@gmail.com>
In-Reply-To: <5432FCB6.5010900@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Realtek RTL8188SU/RTL8191SU/RTL8192SU driver
https://github.com/chunkeey/rtl8192su
&
RTL8188SU

~~~~~~~

- lsusb

Bus 002 Device 003: ID 0bda:8171 Realtek Semiconductor Corp. RTL8188SU 802.11n WLAN Adapter

~~~~~~~~~~

- lsusb -t

/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/6p, 480M
    ...
    |__ Port 3: Dev 3, If 0, Class=Vendor Specific Class, Driver=rtl8192su, 480M

~~~~~~~~~~~~~~~~~~~~~~~

- ethtool -i wlp0s4f1u3

driver: rtl8192su
...

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- /usr/lib/firmware/rtlwifi/rtl8192sufw.bin
  eq
  https://github.com/chunkeey/rtl8192su/raw/master/firmwares/rtl8192sufw-ap.bin

~~~~~~~~~~~~~~~~~~~~~

- iwconfig wlp0s4f1u3

wlp0s4f1u3  IEEE 802.11bgn  Mode:Master  Tx-Power=20 dBm   
          Retry short limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:off

~~~~~~~~~~~~~~~~~~~~~

- ifconfig wlp0s4f1u3

wlp0s4f1u3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.42.0.1  netmask 255.255.255.0  broadcast 10.42.0.255
        inet6 fe80::201:2ff:fe03:405  prefixlen 64  scopeid 0x20<link>
        ether 00:01:02:03:04:05  txqueuelen 1000  (Ethernet)
        RX packets 77  bytes 7421 (7.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 126  bytes 27469 (26.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
          
~~~~~~~~~~~~~~~~~~~~

- iw wlp0s4f1u3 info

Interface wlp0s4f1u3
	ifindex 5
	wdev 0x100000001
	addr 00:01:02:03:04:05
	ssid RTL8188SU(rtl8192su)
	type AP
	wiphy 1
	channel 1 (2412 MHz), width: 20 MHz, center1: 2412 MHz

~~~~~~~~~

- iw list

Wiphy phy1
	max # scan SSIDs: 4
	max scan IEs length: 2257 bytes
	RTS threshold: 2347
	Coverage class: 0 (up to 0m)
	Device supports RSN-IBSS.
	Supported Ciphers:
		* WEP40 (00-0f-ac:1)
		* WEP104 (00-0f-ac:5)
		* TKIP (00-0f-ac:2)
		* CCMP (00-0f-ac:4)
		* CMAC (00-0f-ac:6)
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
	Band 1:
		Capabilities: 0x1862
			HT20/HT40
			Static SM Power Save
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 16 usec (0x07)
		HT TX/RX MCS rate indexes supported: 0-7, 32
		Bitrates (non-HT):
			* 1.0 Mbps
			* 2.0 Mbps
			* 5.5 Mbps
			* 11.0 Mbps
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
			* 2467 MHz [12] (20.0 dBm)
			* 2472 MHz [13] (20.0 dBm)
			* 2484 MHz [14] (disabled)
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
	interface combinations are not supported
	HT Capability overrides:
		 * MCS: ff ff ff ff ff ff ff ff ff ff
		 * maximum A-MSDU length
		 * supported channel width
		 * short GI for 40 MHz
		 * max A-MPDU length exponent
		 * min MPDU start spacing
	Device supports TX status socket option.
	Device supports HT-IBSS.
	Device supports low priority scan.
	Device supports scan flush.
	Device supports AP scan.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- iw wlp0s4f1u3 station dump

Station 00:22:44:66:88:aa (on wlp0s4f1u3)
	inactive time:	15052 ms
	rx bytes:	36692
	rx packets:	349
	tx bytes:	67232
	tx packets:	282
	tx retries:	0
	tx failed:	0
	signal:  	-30 dBm
	signal avg:	-30 dBm
	tx bitrate:	72.2 MBit/s MCS 7 short GI
	rx bitrate:	6.0 MBit/s
	authorized:	yes
	authenticated:	yes
	preamble:	long
	WMM/WME:	yes
	MFP:		no
	TDLS peer:	no

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- /etc/NetworkManager/system-connections/AP

[connection]
id=AP
uuid=12345678-1234-5678-9abc-123456789abc
type=wifi
autoconnect=true

[wifi]
ssid=RTL8188SU(rtl8192su)
mode=ap
mac-address=00:01:02:03:04:05
security=802-11-wireless-security

[wifi-security]
key-mgmt=wpa-psk
proto=rsn
pairwise=ccmp
psk=passphrase

[ipv4]
method=shared

[ipv6]
method=ignore

~~~~~~~~~~~~~~~~~~~~~~~~~~~

- journalctl NetworkManager

[   25.277724] systemd[1]: Starting Network Manager...
[   25.616088] NM[820]: <info> NetworkManager (version 0.9.10.0-5.git20140704.fc21) is starting...
[   25.616296] NM[820]: <info> Read config: /etc/NetworkManager/NetworkManager.conf and conf.d: keyfile-plugin.conf
[   25.616468] NM[820]: <info> WEXT support is enabled
[   26.111881] NM[820]: <info> Loaded plugin keyfile: (c) 2007 - 2013 Red Hat, Inc.  To report bugs please use the NetworkManager mailing list.
[   26.137541] NM[820]: <info> new connection /etc/NetworkManager/system-connections/enp3s0
[   26.271517] NM[820]: <info> new connection /etc/NetworkManager/system-connections/AP
[   26.281099] NM[820]: <info> new connection /etc/NetworkManager/system-connections/MBB
[   26.296694] NM[820]: <info> monitoring kernel firmware directory '/lib/firmware'.
[   26.298418] NM[820]: <info> rfkill0: found WiFi radio killswitch (at /sys/devices/pci0000:00/0000:00:04.1/usb2/2-3/2-3:1.0/ieee80211/phy0/rfkill0) (driver rtl8192su)
[   26.298898] NM[820]: <info> WiFi hardware radio set enabled
[   26.299359] NM[820]: <info> WWAN hardware radio set enabled
[   26.301854] NM[820]: <info> Loaded device plugin: /usr/lib64/NetworkManager/libnm-device-plugin-wwan.so
[   26.302361] NM[820]: <info> Loaded device plugin: /usr/lib64/NetworkManager/libnm-device-plugin-wifi.so
[   26.302818] NM[820]: <info> WiFi enabled by radio killswitch; enabled by state file
[   26.303284] NM[820]: <info> WWAN enabled by radio killswitch; enabled by state file
[   26.303754] NM[820]: <info> WiMAX enabled by radio killswitch; enabled by state file
[   26.304255] NM[820]: <info> Networking is enabled by state file
[   26.304632] systemd[1]: Started Network Manager.
[   26.313508] NM[820]: <info> (lo): link connected
[   26.313671] NM[820]: <info> (lo): carrier is ON
[   26.313817] NM[820]: <info> (lo): new Generic device (driver: 'unknown' ifindex: 1)
[   26.313967] NM[820]: <info> (lo): exported as /org/freedesktop/NetworkManager/Devices/0
[   26.347836] NM[820]: <info> (enp3s0): carrier is OFF
[   26.365975] NM[820]: <info> (enp3s0): new Ethernet device (driver: 'r8169' ifindex: 3)
[   26.366704] NM[820]: <info> (enp3s0): exported as /org/freedesktop/NetworkManager/Devices/1
[   26.367298] NM[820]: <info> (enp3s0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
[   26.389929] NM[820]: <info> (enp3s0): preparing device
[   26.391212] NM[820]: <info> (wlp0s4f1u3): using nl80211 for WiFi device control
[   26.391720] NM[820]: <info> (wlp0s4f1u3): driver supports Access Point (AP) mode
[   26.392201] NM[820]: <info> (wlp0s4f1u3): new 802.11 WiFi device (driver: 'rtl8192su' ifindex: 4)
[   26.392649] NM[820]: <info> (wlp0s4f1u3): exported as /org/freedesktop/NetworkManager/Devices/2
[   26.393123] NM[820]: <info> (wlp0s4f1u3): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
[   27.348116] NM[820]: <info> (wlp0s4f1u3): preparing device
[   27.357681] NM[820]: <info> ModemManager available in the bus
[   28.033860] NM[820]: <info> (enp3s0): link connected
[   28.035054] NM[820]: <info> (enp3s0): device state change: unavailable -> disconnected (reason 'carrier-changed') [20 30 40]
[   28.035713] NM[820]: <info> Auto-activating connection 'enp3s0'.
[   28.040332] NM[820]: <info> Activation (enp3s0) starting connection 'enp3s0'
[   28.040846] NM[820]: <info> Activation (enp3s0) Stage 1 of 5 (Device Prepare) scheduled...
[   28.041318] NM[820]: <info> Activation (enp3s0) Stage 1 of 5 (Device Prepare) started...
[   28.041776] NM[820]: <info> (enp3s0): device state change: disconnected -> prepare (reason 'none') [30 40 0]
[   28.042246] NM[820]: <info> NetworkManager state is now CONNECTING
[   28.042698] NM[820]: <info> Activation (enp3s0) Stage 2 of 5 (Device Configure) scheduled...
[   28.043182] NM[820]: <info> Activation (enp3s0) Stage 1 of 5 (Device Prepare) complete.
[   28.043634] NM[820]: <info> Activation (enp3s0) Stage 2 of 5 (Device Configure) starting...
[   28.044072] NM[820]: <info> (enp3s0): device state change: prepare -> config (reason 'none') [40 50 0]
[   28.061851] NM[820]: <info> Activation (enp3s0) Stage 2 of 5 (Device Configure) successful.
[   28.062348] NM[820]: <info> Activation (enp3s0) Stage 2 of 5 (Device Configure) complete.
[   28.325821] NM[820]: <info> wpa_supplicant started
[   28.466946] NM[820]: <info> (wlp0s4f1u3) supports 4 scan SSIDs
[   28.467471] NM[820]: <info> (wlp0s4f1u3): supplicant interface state: starting -> ready
[   28.467930] NM[820]: <info> (wlp0s4f1u3): device state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
[   28.468893] NM[820]: <info> (wlp0s4f1u3): supplicant interface state: ready -> disconnected
[   28.469370] NM[820]: <info> (wlp0s4f1u3) supports 4 scan SSIDs
[   28.469837] NM[820]: <info> Auto-activating connection 'AP'.
[   28.475692] NM[820]: <info> Activation (wlp0s4f1u3) starting connection 'AP'
[   28.476128] NM[820]: <info> Activation (wlp0s4f1u3) Stage 1 of 5 (Device Prepare) scheduled...
[   28.476311] NM[820]: <info> Activation (wlp0s4f1u3) Stage 1 of 5 (Device Prepare) started...
[   28.476491] NM[820]: <info> (wlp0s4f1u3): device state change: disconnected -> prepare (reason 'none') [30 40 0]
[   28.476672] NM[820]: <info> Activation (wlp0s4f1u3) Stage 2 of 5 (Device Configure) scheduled...
[   28.476852] NM[820]: <info> Activation (wlp0s4f1u3) Stage 1 of 5 (Device Prepare) complete.
[   28.477047] NM[820]: <info> Activation (wlp0s4f1u3) Stage 2 of 5 (Device Configure) starting...
[   28.477225] NM[820]: <info> (wlp0s4f1u3): device state change: prepare -> config (reason 'none') [40 50 0]
[   28.477400] NM[820]: <info> Activation (wlp0s4f1u3/wireless): connection 'AP' has security, and secrets exist.  No new secrets needed.
[   28.477574] NM[820]: <info> Config: added 'ssid' value 'RTL8188SU(rtl8192su)'
[   28.477750] NM[820]: <info> Config: added 'mode' value '2'
[   28.477925] NM[820]: <info> Config: added 'frequency' value '2412'
[   28.478111] NM[820]: <info> Config: added 'key_mgmt' value 'WPA-PSK'
[   28.478286] NM[820]: <info> Config: added 'psk' value '<omitted>'
[   28.478459] NM[820]: <info> Config: added 'proto' value 'RSN'
[   28.478632] NM[820]: <info> Config: added 'pairwise' value 'CCMP'
[   28.478809] NM[820]: <info> Activation (wlp0s4f1u3) Stage 2 of 5 (Device Configure) complete.
[   28.478982] NM[820]: <info> Config: set interface ap_scan to 2
[   28.738684] NM[820]: <info> (wlp0s4f1u3): supplicant interface state: disconnected -> completed
[   28.738891] NM[820]: <info> Activation (wlp0s4f1u3/wireless) Stage 2 of 5 (Device Configure) successful.  Started Wi-Fi Hotspot 'RTL8188SU(rtl8192su)'.
[   34.977083] NM[820]: <info> Activation (enp3s0) Stage 3 of 5 (IP Configure Start) scheduled.
[   34.977610] NM[820]: <info> Activation (enp3s0) Stage 3 of 5 (IP Configure Start) started...
[   34.978096] NM[820]: <info> (enp3s0): device state change: config -> ip-config (reason 'none') [50 70 0]
[   34.978554] NM[820]: <info> Activation (enp3s0) Beginning DHCPv4 transaction (timeout in 45 seconds)
[   35.304547] NM[820]: <info> dhclient started with pid 1395
[   35.305087] NM[820]: <info> Activation (enp3s0) Stage 3 of 5 (IP Configure Start) complete.
[   35.306502] NM[820]: <info> Activation (wlp0s4f1u3) Stage 3 of 5 (IP Configure Start) scheduled.
[   35.306985] NM[820]: <info> Activation (wlp0s4f1u3) Stage 3 of 5 (IP Configure Start) started...
[   35.307480] NM[820]: <info> (wlp0s4f1u3): device state change: config -> ip-config (reason 'none') [50 70 0]
[   35.307976] NM[820]: <info> Activation (wlp0s4f1u3) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
[   35.308447] NM[820]: <info> Activation (wlp0s4f1u3) Stage 3 of 5 (IP Configure Start) complete.
[   35.308937] NM[820]: <info> Activation (wlp0s4f1u3) Stage 5 of 5 (IPv4 Commit) started...
[   35.490657] dhclient[1395]: Internet Systems Consortium DHCP Client 4.3.1
[   35.491211] dhclient[1395]: Copyright 2004-2014 Internet Systems Consortium.
[   35.491674] dhclient[1395]: All rights reserved.
[   35.492147] dhclient[1395]: For info, please visit https://www.isc.org/software/dhcp/
[   35.492592] dhclient[1395]: 
[   35.493078] NM[820]: Internet Systems Consortium DHCP Client 4.3.1
[   35.493519] NM[820]: Copyright 2004-2014 Internet Systems Consortium.
[   35.493950] NM[820]: All rights reserved.
[   35.494211] NM[820]: For info, please visit https://www.isc.org/software/dhcp/
[   36.725988] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert INPUT --in-interface wlp0s4f1u3 --protocol tcp --destination-port 53 --jump ACCEPT
[   36.733764] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert INPUT --in-interface wlp0s4f1u3 --protocol udp --destination-port 53 --jump ACCEPT
[   36.752064] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert INPUT --in-interface wlp0s4f1u3 --protocol tcp --destination-port 67 --jump ACCEPT
[   36.757195] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert INPUT --in-interface wlp0s4f1u3 --protocol udp --destination-port 67 --jump ACCEPT
[   36.776083] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert FORWARD --in-interface wlp0s4f1u3 --jump REJECT
[   36.781590] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert FORWARD --out-interface wlp0s4f1u3 --jump REJECT
[   36.786875] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert FORWARD --in-interface wlp0s4f1u3 --out-interface wlp0s4f1u3 --jump ACCEPT
[   36.789805] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert FORWARD --source 10.42.0.0/255.255.255.0 --in-interface wlp0s4f1u3 --jump ACCEPT
[   36.792748] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert FORWARD --destination 10.42.0.0/255.255.255.0 --out-interface wlp0s4f1u3 --match state --state ESTABLISHED,RELATED --jump ACCEPT
[   38.812843] NM[820]: <info> Executing: /usr/sbin/iptables --table nat --insert POSTROUTING --source 10.42.0.0/255.255.255.0 ! --destination 10.42.0.0/255.255.255.0 --jump MASQUERADE
[   38.816972] NM[820]: <info> Starting dnsmasq...
[   38.818556] NM[820]: <info> (wlp0s4f1u3): device state change: ip-config -> ip-check (reason 'none') [70 80 0]
[   38.818941] NM[820]: <info> Activation (wlp0s4f1u3) Stage 5 of 5 (IPv4 Commit) complete.
[   38.822707] NM[820]: <info> (enp3s0): DHCPv4 state changed nbi -> preinit
[   38.825233] NM[820]: <info> (wlp0s4f1u3): device state change: ip-check -> secondaries (reason 'none') [80 90 0]
[   38.826026] NM[820]: <info> (wlp0s4f1u3): device state change: secondaries -> activated (reason 'none') [90 100 0]
[   38.881776] dhclient[1395]: Listening on LPF/enp3s0/00:12:34:56:78:30
[   38.882317] dhclient[1395]: Sending on   LPF/enp3s0/00:12:34:56:78:30
[   38.882777] dhclient[1395]: Sending on   Socket/fallback
[   38.883995] dhclient[1395]: DHCPREQUEST on enp3s0 to 255.255.255.255 port 67 (xid=0x9c4e1f)
[   38.884524] dhclient[1395]: DHCPACK from 192.168.2.1 (xid=0x9c4e1f)
[   38.885027] NM[820]: Listening on LPF/enp3s0/00:12:34:56:78:30
[   38.885471] NM[820]: Sending on   LPF/enp3s0/00:12:34:56:78:30
[   38.885903] NM[820]: Sending on   Socket/fallback
[   38.886356] NM[820]: DHCPREQUEST on enp3s0 to 255.255.255.255 port 67 (xid=0x9c4e1f)
[   38.886787] NM[820]: DHCPACK from 192.168.2.1 (xid=0x9c4e1f)
[   39.008666] dnsmasq[1416]: started, version 2.72 cachesize 150
[   39.009255] dnsmasq[1416]: compile time options: IPv6 GNU-getopt DBus no-i18n IDN DHCP DHCPv6 no-Lua TFTP no-conntrack ipset auth DNSSEC loop-detect
[   39.009719] dnsmasq-dhcp[1416]: DHCP, IP range 10.42.0.10 -- 10.42.0.254, lease time 1h
[   39.010186] dnsmasq[1416]: reading /etc/resolv.conf
[   39.010634] dnsmasq[1416]: using nameserver 192.168.2.1#53
[   39.012048] dnsmasq[1416]: cleared cache
[   44.464210] NM[820]: <info> Activation (wlp0s4f1u3) successful, device activated.
[   44.470643] NM[820]: <info> (enp3s0): DHCPv4 state changed preinit -> reboot
[   44.472389] NM[820]: <info>   address 192.168.2.35
[   44.472910] NM[820]: <info>   plen 24 (255.255.255.0)
[   44.473421] NM[820]: <info>   gateway 192.168.2.1
[   44.473892] NM[820]: <info>   server identifier 192.168.2.1
[   44.474382] NM[820]: <info>   lease time 600
[   44.474841] NM[820]: <info>   nameserver '192.168.2.1'
[   44.476312] NM[820]: <info> Activation (enp3s0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
[   44.476428] NM[820]: <info> Activation (enp3s0) Stage 5 of 5 (IPv4 Commit) started...
[   44.476548] NM[820]: <info> (enp3s0): device state change: ip-config -> ip-check (reason 'none') [70 80 0]
[   44.476664] NM[820]: <info> Activation (enp3s0) Stage 5 of 5 (IPv4 Commit) complete.
[   44.476782] NM[820]: <info> (enp3s0): device state change: ip-check -> secondaries (reason 'none') [80 90 0]
[   44.476897] NM[820]: <info> (enp3s0): device state change: secondaries -> activated (reason 'none') [90 100 0]
[   44.477060] NM[820]: <info> NetworkManager state is now CONNECTED_LOCAL
[   44.671564] dhclient[1395]: bound to 192.168.2.35 -- renewal in 253 seconds.
[   44.672104] NM[820]: bound to 192.168.2.35 -- renewal in 253 seconds.
[   44.672581] NM[820]: <info> NetworkManager state is now CONNECTED_GLOBAL
[   44.673074] NM[820]: <info> Policy set 'enp3s0' (enp3s0) as default for IPv4 routing and DNS.
[   44.719277] NM[820]: <info> Activation (enp3s0) successful, device activated.
[   44.721265] NM[820]: <info> startup complete
[   95.712977] dnsmasq[1416]: reading /etc/resolv.conf
[   95.713657] dnsmasq[1416]: using nameserver 192.168.2.1#53
[   95.715255] dnsmasq[1416]: cleared cache
[  217.044170] dnsmasq-dhcp[1416]: DHCPREQUEST(wlp0s4f1u3) 10.42.0.77 00:22:44:66:88:aa
[  217.044896] dnsmasq-dhcp[1416]: DHCPACK(wlp0s4f1u3) 10.42.0.77 00:22:44:66:88:aa android-0123456789abcdef
...
[ 1240.752553] dnsmasq-dhcp[1416]: DHCPREQUEST(wlp0s4f1u3) 10.42.0.77 00:22:44:66:88:aa
[ 1240.813416] dnsmasq-dhcp[1416]: DHCPACK(wlp0s4f1u3) 10.42.0.77 00:22:44:66:88:aa android-0123456789abcdef
...
[ 1408.894826] dnsmasq-dhcp[1416]: DHCPREQUEST(wlp0s4f1u3) 10.42.0.77 00:22:44:66:88:aa
[ 1408.895557] dnsmasq-dhcp[1416]: DHCPACK(wlp0s4f1u3) 10.42.0.77 00:22:44:66:88:aa android-0123456789abcdef

- systemctl suspend
          & resume(S3)

[ 1689.325793] NM[820]: <info> (wlp0s4f1u3): device state change: activated -> unmanaged (reason 'removed') [100 10 36]
[ 1689.325961] NM[820]: <info> (wlp0s4f1u3): deactivating device (reason 'removed') [36]
[ 1689.326448] NM[820]: <info> radio killswitch /sys/devices/pci0000:00/0000:00:04.1/usb2/2-3/2-3:1.0/ieee80211/phy0/rfkill0 disappeared
[ 1689.326580] NM[820]: <info> (wlp0s4f1u3): using nl80211 for WiFi device control
[ 1689.326709] NM[820]: <info> (wlp0s4f1u3): driver supports Access Point (AP) mode
[ 1689.326834] NM[820]: <info> (wlp0s4f1u3): new 802.11 WiFi device (driver: 'rtl8192su' ifindex: 5)
[ 1689.326966] NM[820]: <info> (wlp0s4f1u3): exported as /org/freedesktop/NetworkManager/Devices/3
[ 1689.327098] NM[820]: <info> (wlp0s4f1u3): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
[ 1689.327223] NM[820]: <info> (wlp0s4f1u3): preparing device
[ 1689.328176] NM[820]: <info> rfkill1: found WiFi radio killswitch (at /sys/devices/pci0000:00/0000:00:04.1/usb2/2-3/2-3:1.0/ieee80211/phy1/rfkill1) (driver rtl8192su)
[ 1689.329155] NM[820]: <info> Executing: /usr/sbin/iptables --table nat --delete POSTROUTING --source 10.42.0.0/255.255.255.0 ! --destination 10.42.0.0/255.255.255.0 --jump MASQUERADE
[ 1689.331088] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --delete FORWARD --destination 10.42.0.0/255.255.255.0 --out-interface wlp0s4f1u3 --match state --state ESTABLISHED,RELATED --jump ACCEPT
[ 1689.334823] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --delete FORWARD --source 10.42.0.0/255.255.255.0 --in-interface wlp0s4f1u3 --jump ACCEPT
[ 1689.336627] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --delete FORWARD --in-interface wlp0s4f1u3 --out-interface wlp0s4f1u3 --jump ACCEPT
[ 1689.338561] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --delete FORWARD --out-interface wlp0s4f1u3 --jump REJECT
[ 1689.341038] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --delete FORWARD --in-interface wlp0s4f1u3 --jump REJECT
[ 1689.343125] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --delete INPUT --in-interface wlp0s4f1u3 --protocol udp --destination-port 67 --jump ACCEPT
[ 1689.380119] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --delete INPUT --in-interface wlp0s4f1u3 --protocol tcp --destination-port 67 --jump ACCEPT
[ 1689.385774] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --delete INPUT --in-interface wlp0s4f1u3 --protocol udp --destination-port 53 --jump ACCEPT
[ 1690.325415] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --delete INPUT --in-interface wlp0s4f1u3 --protocol tcp --destination-port 53 --jump ACCEPT
[ 1690.336827] NM[820]: <info> (wlp0s4f1u3) supports 4 scan SSIDs
[ 1690.337091] NM[820]: <info> (wlp0s4f1u3): supplicant interface state: starting -> ready
[ 1690.337297] NM[820]: <info> (wlp0s4f1u3): device state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
[ 1690.337493] NM[820]: <info> (wlp0s4f1u3): supplicant interface state: ready -> disconnected
[ 1690.337686] NM[820]: <info> (wlp0s4f1u3) supports 4 scan SSIDs
[ 1690.337884] NM[820]: <info> Auto-activating connection 'AP'.
[ 1690.338085] NM[820]: <info> Activation (wlp0s4f1u3) starting connection 'AP'
[ 1690.338281] NM[820]: <info> Activation (wlp0s4f1u3) Stage 1 of 5 (Device Prepare) scheduled...
[ 1690.338472] NM[820]: <info> Activation (wlp0s4f1u3) Stage 1 of 5 (Device Prepare) started...
[ 1690.338672] NM[820]: <info> (wlp0s4f1u3): device state change: disconnected -> prepare (reason 'none') [30 40 0]
[ 1690.338865] NM[820]: <info> Activation (wlp0s4f1u3) Stage 2 of 5 (Device Configure) scheduled...
[ 1690.339062] NM[820]: <info> Activation (wlp0s4f1u3) Stage 1 of 5 (Device Prepare) complete.
[ 1690.339257] NM[820]: <info> Activation (wlp0s4f1u3) Stage 2 of 5 (Device Configure) starting...
[ 1690.339452] NM[820]: <info> (wlp0s4f1u3): device state change: prepare -> config (reason 'none') [40 50 0]
[ 1690.343841] NM[820]: <info> Activation (wlp0s4f1u3/wireless): access point 'AP' has security, but secrets are required.
[ 1690.344110] NM[820]: <info> (wlp0s4f1u3): device state change: config -> need-auth (reason 'none') [50 60 0]
[ 1690.344304] NM[820]: <info> Activation (wlp0s4f1u3) Stage 2 of 5 (Device Configure) complete.
[ 1690.344436] NM[820]: <info> Activation (wlp0s4f1u3) Stage 1 of 5 (Device Prepare) scheduled...
[ 1690.348812] NM[820]: <info> Activation (wlp0s4f1u3) Stage 1 of 5 (Device Prepare) started...
[ 1690.348980] NM[820]: <info> (wlp0s4f1u3): device state change: need-auth -> prepare (reason 'none') [60 40 0]
[ 1690.349130] NM[820]: <info> Activation (wlp0s4f1u3) Stage 2 of 5 (Device Configure) scheduled...
[ 1690.349260] NM[820]: <info> Activation (wlp0s4f1u3) Stage 1 of 5 (Device Prepare) complete.
[ 1690.349389] NM[820]: <info> Activation (wlp0s4f1u3) Stage 2 of 5 (Device Configure) starting...
[ 1690.349519] NM[820]: <info> (wlp0s4f1u3): device state change: prepare -> config (reason 'none') [40 50 0]
[ 1690.349653] NM[820]: <info> Activation (wlp0s4f1u3/wireless): connection 'AP' has security, and secrets exist.  No new secrets needed.
[ 1690.349783] NM[820]: <info> Config: added 'ssid' value 'RTL8188SU(rtl8192su)'
[ 1690.349911] NM[820]: <info> Config: added 'mode' value '2'
[ 1690.350052] NM[820]: <info> Config: added 'frequency' value '2412'
[ 1690.350186] NM[820]: <info> Config: added 'key_mgmt' value 'WPA-PSK'
[ 1690.350311] NM[820]: <info> Config: added 'psk' value '<omitted>'
[ 1690.350440] NM[820]: <info> Config: added 'proto' value 'RSN'
[ 1690.350567] NM[820]: <info> Config: added 'pairwise' value 'CCMP'
[ 1690.350692] NM[820]: <info> Activation (wlp0s4f1u3) Stage 2 of 5 (Device Configure) complete.
[ 1690.355138] NM[820]: <info> Config: set interface ap_scan to 2
[ 1690.439942] NM[820]: <info> (wlp0s4f1u3): supplicant interface state: disconnected -> completed
[ 1690.440552] NM[820]: <info> Activation (wlp0s4f1u3/wireless) Stage 2 of 5 (Device Configure) successful.  Started Wi-Fi Hotspot 'RTL8188SU(rtl8192su)'.
[ 1690.496432] NM[820]: <info> Activation (wlp0s4f1u3) Stage 3 of 5 (IP Configure Start) scheduled.
[ 1690.497084] NM[820]: <info> Activation (wlp0s4f1u3) Stage 3 of 5 (IP Configure Start) started...
[ 1690.497617] NM[820]: <info> (wlp0s4f1u3): device state change: config -> ip-config (reason 'none') [50 70 0]
[ 1690.498145] NM[820]: <info> Activation (wlp0s4f1u3) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
[ 1690.498669] NM[820]: <info> Activation (wlp0s4f1u3) Stage 3 of 5 (IP Configure Start) complete.
[ 1690.499196] NM[820]: <info> Activation (wlp0s4f1u3) Stage 5 of 5 (IPv4 Commit) started...
[ 1690.519773] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert INPUT --in-interface wlp0s4f1u3 --protocol tcp --destination-port 53 --jump ACCEPT
[ 1690.522189] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert INPUT --in-interface wlp0s4f1u3 --protocol udp --destination-port 53 --jump ACCEPT
[ 1690.550111] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert INPUT --in-interface wlp0s4f1u3 --protocol tcp --destination-port 67 --jump ACCEPT
[ 1690.555813] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert INPUT --in-interface wlp0s4f1u3 --protocol udp --destination-port 67 --jump ACCEPT
[ 1690.573980] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert FORWARD --in-interface wlp0s4f1u3 --jump REJECT
[ 1690.577369] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert FORWARD --out-interface wlp0s4f1u3 --jump REJECT
[ 1690.580764] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert FORWARD --in-interface wlp0s4f1u3 --out-interface wlp0s4f1u3 --jump ACCEPT
[ 1690.585441] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert FORWARD --source 10.42.0.0/255.255.255.0 --in-interface wlp0s4f1u3 --jump ACCEPT
[ 1690.587979] NM[820]: <info> Executing: /usr/sbin/iptables --table filter --insert FORWARD --destination 10.42.0.0/255.255.255.0 --out-interface wlp0s4f1u3 --match state --state ESTABLISHED,RELATED --jump ACCEPT
[ 1690.590492] NM[820]: <info> Executing: /usr/sbin/iptables --table nat --insert POSTROUTING --source 10.42.0.0/255.255.255.0 ! --destination 10.42.0.0/255.255.255.0 --jump MASQUERADE
[ 1690.592764] NM[820]: <info> Starting dnsmasq...
[ 1690.593692] NM[820]: <info> (wlp0s4f1u3): device state change: ip-config -> ip-check (reason 'none') [70 80 0]
[ 1690.594290] NM[820]: <info> Activation (wlp0s4f1u3) Stage 5 of 5 (IPv4 Commit) complete.
[ 1690.595395] dnsmasq[3442]: started, version 2.72 cachesize 150
[ 1690.595629] dnsmasq[3442]: compile time options: IPv6 GNU-getopt DBus no-i18n IDN DHCP DHCPv6 no-Lua TFTP no-conntrack ipset auth DNSSEC loop-detect
[ 1690.595822] dnsmasq-dhcp[3442]: DHCP, IP range 10.42.0.10 -- 10.42.0.254, lease time 1h
[ 1690.596021] dnsmasq[3442]: reading /etc/resolv.conf
[ 1690.596216] dnsmasq[3442]: using nameserver 192.168.2.1#53
[ 1690.596793] dnsmasq[3442]: cleared cache
[ 1690.596982] NM[820]: <info> (wlp0s4f1u3): device state change: ip-check -> secondaries (reason 'none') [80 90 0]
[ 1690.597182] NM[820]: <info> (wlp0s4f1u3): device state change: secondaries -> activated (reason 'none') [90 100 0]
[ 1691.068838] NM[820]: <info> Activation (wlp0s4f1u3) successful, device activated.
[ 1698.780512] dnsmasq-dhcp[3442]: DHCPREQUEST(wlp0s4f1u3) 10.42.0.77 00:22:44:66:88:aa
[ 1698.781136] dnsmasq-dhcp[3442]: DHCPACK(wlp0s4f1u3) 10.42.0.77 00:22:44:66:88:aa android-0123456789abcdef

~~~~~~~

- dmesg

[    2.126073] usb 2-3: new high-speed USB device number 3 using ehci-pci
[    2.242873] usb 2-3: New USB device found, idVendor=0bda, idProduct=8171
[    2.242880] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.242883] usb 2-3: Product: RTL8188S WLAN Adapter 
[    2.242885] usb 2-3: Manufacturer: Manufacturer Realtek 
[    2.242887] usb 2-3: SerialNumber: 00e04c000001
[   20.134415] rtlwifi: module verification failed: signature and/or  required key missing - tainting kernel
[   20.517392] rtl8192s_common: Chip version 0x3
[   20.686391] rtl_usb: rx_max_size 9100, rx_urb_num 8, in_ep 3
[   20.687057] rtl8192su: Power Save off (module option)
[   20.687639] rtl8192su: FW Power Save off (module option)
[   20.688394] rtl8192su: Driver for Realtek RTL8192SU/RTL8191SU
Loading firmware rtlwifi/rtl8192sufw.bin
[   20.689751] usbcore: registered new interface driver rtl8192su
[   20.850838] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[   20.854551] rtl8192su 2-3:1.0 wlp0s4f1u3: renamed from wlan0

- systemctl suspend

[ 1679.990678] PM: Preparing system for mem sleep
[ 1680.178832] Freezing user space processes ... (elapsed 0.048 seconds) done.
[ 1680.226937] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[ 1680.228270] PM: Entering mem sleep
[ 1680.228299] Suspending console(s) (use no_console_suspend to debug)
[ 1682.772451] PM: suspend of devices complete after 2543.533 msecs
[ 1682.773864] PM: late suspend of devices complete after 1.407 msecs
[ 1682.775348] ehci-pci 0000:00:02.1: System wakeup enabled by ACPI
[ 1682.786410] PM: noirq suspend of devices complete after 12.536 msecs
[ 1682.787692] ACPI: Preparing to enter system sleep state S3
[ 1682.788861] PM: Saving platform NVS memory

          & resume(S3)

[ 1682.798859] ACPI: Low-level resume complete
[ 1682.798924] PM: Restoring platform NVS memory
[ 1682.844566] ACPI: Waking up from system sleep state S3
[ 1682.855147] ehci-pci 0000:00:02.1: System wakeup disabled by ACPI
[ 1682.856186] PM: noirq resume of devices complete after 11.457 msecs
[ 1682.856759] PM: early resume of devices complete after 0.531 msecs
[ 1683.074063] PM: resume of devices complete after 217.286 msecs
[ 1683.074332] rtl8192s_common: Chip version 0x3
[ 1683.218439] rtl_usb: rx_max_size 9100, rx_urb_num 8, in_ep 3
[ 1683.218484] rtl8192su: Power Save off (module option)
[ 1683.218485] rtl8192su: FW Power Save off (module option)
[ 1683.218694] rtl8192su: Driver for Realtek RTL8192SU/RTL8191SU
Loading firmware rtlwifi/rtl8192sufw.bin
[ 1683.219176] ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
[ 1683.234998] PM: Finishing wakeup.
[ 1683.235003] Restarting tasks ... done.
[ 1683.258259] rtl8192su 2-3:1.0 wlp0s4f1u3: renamed from wlan0
[ 1683.270928] IPv6: ADDRCONF(NETDEV_UP): wlp0s4f1u3: link is not ready
[ 1684.238973] IPv6: ADDRCONF(NETDEV_UP): wlp0s4f1u3: link is not ready
[ 1684.401143] r8169 0000:03:00.0 enp3s0: link up
[ 1691.249718] IPv6: ADDRCONF(NETDEV_UP): wlp0s4f1u3: link is not ready
[ 1691.376981] IPv6: ADDRCONF(NETDEV_CHANGE): wlp0s4f1u3: link becomes ready

~~~~~~~~~~~~~~~~~~~~

http://goo.gl/3O3Tz4


poma


