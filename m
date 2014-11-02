Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60760 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaKBF7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2014 01:59:19 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so8392732wgh.11
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2014 22:59:17 -0700 (PDT)
Message-ID: <5455C833.2080706@gmail.com> (sfid-20141102_065925_549166_C201B689)
Date: Sun, 02 Nov 2014 06:59:15 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Ralink RT3070(rt2800usb) - The Tortoise and the Hare
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Network throughput is, to put it mildly, half-baked.
Higher values, are they even possible via rt2800usb.ko & Co.?


°°°°°°°°°°°°°°°

$ iperf -s -i 1
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.2.5 port 5001 connected with 192.168.2.52 port 57150
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0- 1.0 sec  1.56 MBytes  13.1 Mbits/sec
[  4]  1.0- 2.0 sec  1.82 MBytes  15.3 Mbits/sec
[  4]  2.0- 3.0 sec  1.74 MBytes  14.6 Mbits/sec
[  4]  3.0- 4.0 sec  1.86 MBytes  15.6 Mbits/sec
[  4]  4.0- 5.0 sec  1.94 MBytes  16.3 Mbits/sec
[  4]  5.0- 6.0 sec  1.92 MBytes  16.1 Mbits/sec
[  4]  6.0- 7.0 sec  1.85 MBytes  15.5 Mbits/sec
[  4]  7.0- 8.0 sec  1.82 MBytes  15.2 Mbits/sec
[  4]  8.0- 9.0 sec  1.75 MBytes  14.7 Mbits/sec
[  4]  9.0-10.0 sec  1.82 MBytes  15.2 Mbits/sec
[  4]  0.0-10.4 sec  18.9 MBytes  15.2 Mbits/sec

°°°°°°°°°°°°°°°°°°°°°°°°°°°

$ iperf -c 192.168.2.5 -i 1
------------------------------------------------------------
Client connecting to 192.168.2.5, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.52 port 57150 connected with 192.168.2.5 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  1.75 MBytes  14.7 Mbits/sec
[  3]  1.0- 2.0 sec  2.00 MBytes  16.8 Mbits/sec
[  3]  2.0- 3.0 sec  1.75 MBytes  14.7 Mbits/sec
[  3]  3.0- 4.0 sec  1.88 MBytes  15.7 Mbits/sec
[  3]  4.0- 5.0 sec  2.00 MBytes  16.8 Mbits/sec
[  3]  5.0- 6.0 sec  1.88 MBytes  15.7 Mbits/sec
[  3]  6.0- 7.0 sec  1.75 MBytes  14.7 Mbits/sec
[  3]  7.0- 8.0 sec  2.25 MBytes  18.9 Mbits/sec
[  3]  8.0- 9.0 sec  1.38 MBytes  11.5 Mbits/sec
[  3]  9.0-10.0 sec  2.12 MBytes  17.8 Mbits/sec
[  3]  0.0-10.1 sec  18.9 MBytes  15.6 Mbits/sec

°°°°°°°°°°°°°°°

$ iperf -s -i 1
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.2.52 port 5001 connected with 192.168.2.5 port 49178
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0- 1.0 sec  3.24 MBytes  27.2 Mbits/sec
[  4]  1.0- 2.0 sec  3.58 MBytes  30.0 Mbits/sec
[  4]  2.0- 3.0 sec  4.11 MBytes  34.5 Mbits/sec
[  4]  3.0- 4.0 sec  4.44 MBytes  37.2 Mbits/sec
[  4]  4.0- 5.0 sec  4.71 MBytes  39.5 Mbits/sec
[  4]  5.0- 6.0 sec  4.64 MBytes  39.0 Mbits/sec
[  4]  6.0- 7.0 sec  4.49 MBytes  37.7 Mbits/sec
[  4]  7.0- 8.0 sec  4.61 MBytes  38.6 Mbits/sec
[  4]  8.0- 9.0 sec  4.43 MBytes  37.2 Mbits/sec
[  4]  9.0-10.0 sec  4.66 MBytes  39.1 Mbits/sec
[  4]  0.0-10.1 sec  43.5 MBytes  36.0 Mbits/sec

°°°°°°°°°°°°°°°°°°°°°°°°°°°°

$ iperf -c 192.168.2.52 -i 1
------------------------------------------------------------
Client connecting to 192.168.2.52, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.5 port 49178 connected with 192.168.2.52 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  3.62 MBytes  30.4 Mbits/sec
[  3]  1.0- 2.0 sec  3.62 MBytes  30.4 Mbits/sec
[  3]  2.0- 3.0 sec  4.12 MBytes  34.6 Mbits/sec
[  3]  3.0- 4.0 sec  4.38 MBytes  36.7 Mbits/sec
[  3]  4.0- 5.0 sec  4.88 MBytes  40.9 Mbits/sec
[  3]  5.0- 6.0 sec  4.75 MBytes  39.8 Mbits/sec
[  3]  6.0- 7.0 sec  4.38 MBytes  36.7 Mbits/sec
[  3]  7.0- 8.0 sec  4.88 MBytes  40.9 Mbits/sec
[  3]  8.0- 9.0 sec  4.25 MBytes  35.7 Mbits/sec
[  3]  9.0-10.0 sec  4.50 MBytes  37.7 Mbits/sec
[  3]  0.0-10.0 sec  43.5 MBytes  36.5 Mbits/sec

°°°°°°°°°°°°°°°°°°°°°°°°

# lsusb -d 148f:3070 -v

Bus 002 Device 003: ID 148f:3070 Ralink Technology, Corp. RT2870/RT3070 Wireless Adapter
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x148f Ralink Technology, Corp.
  idProduct          0x3070 RT2870/RT3070 Wireless Adapter
  bcdDevice            1.01
  iManufacturer           1 Ralink
  iProduct                2 802.11 n WLAN
  iSerial                 3 1.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           67
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              450mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           7
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              5 1.0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x06  EP 6 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

°°°°°°°°°°°°°°°°°°°°°°
$ modinfo rt2800usb -n
/lib/modules/3.17.2-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2800usb.ko.xz

°°°°°°°°°°°°°°°°°°°°°°°°°°°°

# dmesg -t | grep 'rt2\|2-3'
usb 2-3: new high-speed USB device number 3 using ehci-pci
usb 2-3: New USB device found, idVendor=148f, idProduct=3070
usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-3: Product: 802.11 n WLAN
usb 2-3: Manufacturer: Ralink
usb 2-3: SerialNumber: 1.0
usb 2-3: reset high-speed USB device number 3 using ehci-pci
ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 3070, rev 0201 detected
ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0005 detected
usbcore: registered new interface driver rt2800usb
rt2800usb 2-3:1.0 wlp0s4f1u3: renamed from wlan0
ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'
ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.29

°°°°°°°°°°°°°°°°°°°°°

# iwconfig wlp0s4f1u3
wlp0s4f1u3  IEEE 802.11bgn  ESSID:"AP1"  
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:01:02:03:04:05   
          Bit Rate=45 Mb/s   Tx-Power=20 dBm   
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=70/70  Signal level=-17 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:1414  Invalid misc:18505   Missed beacon:0

°°°°°°°°°°°°°°°°°°°°

# iw wlp0s4f1u3 info
Interface wlp0s4f1u3
	ifindex 5
	wdev 0x1
	addr 00:02:04:08:04:02
	type managed
	wiphy 0
	channel 6 (2437 MHz), width: 40 MHz, center1: 2427 MHz

°°°°°°°°°°°°°°°°°°°°

# iw wlp0s4f1u3 link
Connected to 00:01:02:03:04:05 (on wlp0s4f1u3)
	SSID: AP1
	freq: 2437
	RX: 3943127090 bytes (5404885 packets)
	TX: 235612402 bytes (2728395 packets)
	signal: -17 dBm
	tx bitrate: 45.0 MBit/s MCS 2 40MHz short GI

	bss flags:	short-slot-time
	dtim period:	1
	beacon int:	100

°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

# iw wlp0s4f1u3 station dump
Station 00:01:02:03:04:05 (on wlp0s4f1u3)
	inactive time:	0 ms
	rx bytes:	3943288404
	rx packets:	5404992
	tx bytes:	235616874
	tx packets:	2728447
	tx retries:	567959
	tx failed:	1414
	signal:  	-17 dBm
	signal avg:	-17 dBm
	tx bitrate:	45.0 MBit/s MCS 2 40MHz short GI
	rx bitrate:	108.0 MBit/s MCS 5 40MHz
	authorized:	yes
	authenticated:	yes
	preamble:	long
	WMM/WME:	yes
	MFP:		no
	TDLS peer:	no

°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

# iw wlp0s4f1u3 scan | grep associated -A50
BSS 00:01:02:03:04:05(on wlp0s4f1u3) -- associated
	TSF: 132040964986 usec (1d, 12:40:40)
	freq: 2437
	beacon interval: 100 TUs
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -13.00 dBm
	last seen: 176 ms ago
	Information elements from Probe Response frame:
	SSID: AP1
	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 
	DS Parameter set: channel 6
	ERP: <no flags>
	Extended supported rates: 24.0 36.0 48.0 54.0 
	HT capabilities:
		Capabilities: 0x186e
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 32767 bytes (exponent: 0x002)
		Minimum RX AMPDU time spacing: 16 usec (0x07)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 6
		 * secondary channel offset: below
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
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)
	WMM:	 * Parameter version 1
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec

°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

# iw list / iw phy0 info
Wiphy phy0
	max # scan SSIDs: 4
	max scan IEs length: 2257 bytes
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
		 * WDS
		 * monitor
		 * mesh point
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
	valid interface combinations:
		 * #{ AP, mesh point } <= 8,
		   total <= 8, #channels <= 1
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

°°°°°°°°


poma

