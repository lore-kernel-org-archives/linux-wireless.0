Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kwall.cngroup.cz ([194.213.192.9]:31002 "EHLO kwall.cngroup.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab1KVKog (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 05:44:36 -0500
Received: from asterix.domain.local (unknown [172.28.71.3])
	by kwall.cngroup.cz (Postfix) with ESMTP id 33A6C325BA
	for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 11:34:33 +0100 (CET)
Date: Tue, 22 Nov 2011 11:34:27 +0100
From: Jan =?UTF-8?B?RHZvxZnDoWs=?= <dvorakj@cngroup.dk>
To: linux-wireless@vger.kernel.org
Subject: rtl8192cu not working with Edimax EW-7811Un
Message-Id: <20111122113427.3d332b00776546d5ebac11de@cngroup.dk> (sfid-20111122_114441_492472_6F549A69)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Tue__22_Nov_2011_11_34_27_+0100_Lp2mueQ1Oc4Lnavy"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Tue__22_Nov_2011_11_34_27_+0100_Lp2mueQ1Oc4Lnavy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi,

I have Edimax EW-7811Un USB dongle.

The reason I purchased it was that I needed as small close-range AP to
connect my laptop to my work PC. Now, I have not managed to make it even
connect as client.

I have attached various logs and information about the HW from when I
was attempting to use it as AP. The client kept repeating

  wlan0: authenticate with 00:1f:1f:e4:5b:67 (try 1)
  wlan0: authenticated
  wlan0: waiting for beacon from 00:1f:1f:e4:5b:67

over and over, but never really connected.

Can you give me some advice on how to debug this? Where can I create a
formal bug report, with kernel bugzilla down?

Oh, this is with 3.1.0-5.fc16.x86_64 (Fedora 16).

Thanks for your help,
	Jan Dvorak

--Multipart=_Tue__22_Nov_2011_11_34_27_+0100_Lp2mueQ1Oc4Lnavy
Content-Type: text/plain;
 name="dmesg.txt"
Content-Disposition: attachment;
 filename="dmesg.txt"
Content-Transfer-Encoding: 7bit

[ 2915.695039] usb 1-3: new high speed USB device number 5 using ehci_hcd
[ 2915.810561] usb 1-3: New USB device found, idVendor=7392, idProduct=7811
[ 2915.810568] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 2915.810573] usb 1-3: Product: 802.11n WLAN Adapter
[ 2915.810577] usb 1-3: Manufacturer: Realtek
[ 2915.810581] usb 1-3: SerialNumber: 00e04c000001
[ 2916.177961] cfg80211: Calling CRDA to update world regulatory domain
[ 2916.243818] cfg80211: World regulatory domain updated:
[ 2916.243823] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 2916.243827] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 2916.243830] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 2916.243834] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 2916.243837] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 2916.243840] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 2916.404945] rtl8192cu: MAC address: 00:1f:1f:e4:5b:67
[ 2916.404954] rtl8192cu: Board Type 0
[ 2916.440318] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[ 2916.478141] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[ 2916.478850] usbcore: registered new interface driver rtl8192cu
[ 2916.592701] cfg80211: Calling CRDA for country: CZ
[ 2916.596969] cfg80211: Regulatory domain changed to country: CZ
[ 2916.596974] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 2916.596977] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 2916.596980] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[ 2916.596983] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 2916.596986] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[ 2983.894180] rtl8192cu: MAC auto ON okay!
[ 2983.930451] rtl8192cu: Tx queue select: 0x05
[ 2983.931216] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin

--Multipart=_Tue__22_Nov_2011_11_34_27_+0100_Lp2mueQ1Oc4Lnavy
Content-Type: text/plain;
 name="hostapd.conf"
Content-Disposition: attachment;
 filename="hostapd.conf"
Content-Transfer-Encoding: base64

Y3RybF9pbnRlcmZhY2U9L3Zhci9ydW4vaG9zdGFwZA0KY3RybF9pbnRlcmZhY2VfZ3JvdXA9d2hl
ZWwNCg0KbWFjYWRkcl9hY2w9MA0KYXV0aF9hbGdzPTENCmlnbm9yZV9icm9hZGNhc3Rfc3NpZD0w
DQoNCmRyaXZlcj1ubDgwMjExDQoNCmludGVyZmFjZT13bGFuMA0KaHdfbW9kZT1nDQpjaGFubmVs
PTMNCnNzaWQ9ZHZvcmFrag0KDQo=

--Multipart=_Tue__22_Nov_2011_11_34_27_+0100_Lp2mueQ1Oc4Lnavy
Content-Type: text/plain;
 name="hostapd.txt"
Content-Disposition: attachment;
 filename="hostapd.txt"
Content-Transfer-Encoding: 7bit

Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=10 (from group name 'wheel')
nl80211: Add own interface ifindex 6
nl80211: New interface mon.wlan0 created: ifindex=7
nl80211: Add own interface ifindex 7
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Added 802.11b mode based on 802.11g information
RATE[0] rate=10 flags=0x1
RATE[1] rate=20 flags=0x1
RATE[2] rate=55 flags=0x1
RATE[3] rate=110 flags=0x1
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Completing interface initialization
Mode: IEEE 802.11g  Channel: 3  Frequency: 2422 MHz
Flushing old station entries
Deauthenticate all stations
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=(nil) key_idx=0 set_tx=1 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
Using interface wlan0 with hwaddr 00:1f:1f:e4:5b:67 and ssid 'dvorakj'
nl80211: Set beacon (beacon_set=0)
wlan0: Setup of interface done.
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::auth
authentication: STA=a0:88:b4:a5:5b:4c auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
wlan0: STA a0:88:b4:a5:5b:4c IEEE 802.11: authentication OK (open system)
wlan0: STA a0:88:b4:a5:5b:4c MLME: MLME-AUTHENTICATE.indication(a0:88:b4:a5:5b:4c, OPEN_SYSTEM)
wlan0: STA a0:88:b4:a5:5b:4c MLME: MLME-DELETEKEYS.request(a0:88:b4:a5:5b:4c)
authentication reply: STA=a0:88:b4:a5:5b:4c auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
mgmt::auth cb
wlan0: STA a0:88:b4:a5:5b:4c IEEE 802.11: authenticated
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb


--Multipart=_Tue__22_Nov_2011_11_34_27_+0100_Lp2mueQ1Oc4Lnavy
Content-Type: text/plain;
 name="iw-phy0-info.txt"
Content-Disposition: attachment;
 filename="iw-phy0-info.txt"
Content-Transfer-Encoding: 7bit

Wiphy phy0
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
	max # scan SSIDs: 4
	max scan IEs length: 2257 bytes
	RTS threshold: 2347
	Coverage class: 0 (up to 0m)
	Available Antennas: TX 0 RX 0
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * monitor
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

--Multipart=_Tue__22_Nov_2011_11_34_27_+0100_Lp2mueQ1Oc4Lnavy
Content-Type: text/plain;
 name="lsusb-v.txt"
Content-Disposition: attachment;
 filename="lsusb-v.txt"
Content-Transfer-Encoding: 7bit

Bus 001 Device 005: ID 7392:7811 Edimax Technology Co., Ltd EW-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x7392 Edimax Technology Co., Ltd
  idProduct          0x7811 EW-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]
  bcdDevice            2.00
  iManufacturer           1 Realtek
  iProduct                2 802.11n WLAN Adapter
  iSerial                 3 00e04c000001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
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
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
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


--Multipart=_Tue__22_Nov_2011_11_34_27_+0100_Lp2mueQ1Oc4Lnavy--
