Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64941 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbbAZCAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 21:00:43 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so6946080wid.5
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 18:00:42 -0800 (PST)
MIME-Version: 1.0
From: "Christopher M. Penalver" <christopher.m.penalver@gmail.com>
Date: Sun, 25 Jan 2015 20:00:01 -0600
Message-ID: <CAF4BKcCggD23NHD_1156bqLsqMjDWp+8ASJaxJdLXUXcXaaddQ@mail.gmail.com> (sfid-20150126_030047_971309_9908E594)
Subject: Inquiry on sudo iw dev wlan1 set txpower fixed 14 -> command failed:
 Invalid argument (-22)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Attempting to follow
http://wireless.kernel.org/en/users/Documentation/iw#Setting_TX_power
I get:
sudo iw dev wlan1 set txpower fixed 14
command failed: Invalid argument (-22)

Same error if I raise or lower this number.

My environment:

+ Ubuntu 14.10 (also reproducible in 14.04)

+ (Also reproducible in 3.13.x)
uname -a
Linux acer-pc 3.16.0-29-generic #39-Ubuntu SMP Mon Dec 15 22:27:29 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux

+ I am in the US regulatory domain.

+ wlan1
usb-devices
T:  Bus=02 Lev=02 Prnt=02 Port=01 Cnt=01 Dev#=  3 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=050d ProdID=845a Rev=02.00
S:  Manufacturer=Manufacturer Realtek
S:  Product=Belkin USB Wireless Adaptor
S:  SerialNumber=00e04c000001
C:  #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=ff Prot=ff Driver=r8712u

+ wlan0
lspci -vvnn
03:00.0 Network controller [0280]: Qualcomm Atheros AR9287 Wireless
Network Adapter (PCI-Express) [168c:002e] (rev 01)
        Subsystem: Foxconn International, Inc. Device [105b:e034]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at c0500000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: <access denied>
        Kernel driver in use: ath9k

+ I don't have network-manager or wicd installed. I've configured both
wlan0 and wlan1 in /etc/network/interfaces :
# interfaces(5) file used by ifup(8) and ifdown(8)
auto lo wlan0 wlan1
iface lo inet loopback
# wlan0 access point
iface wlan0 inet static
address 10.0.0.1
netmask 255.255.255.240
gateway 10.0.0.1
wireless-mode Master
# wlan1 managed mode
iface wlan1 inet static
address 192.168.1.10
network 192.168.1.0
netmask 255.255.255.0
gateway 192.168.1.1
wpa-bssid XX:XX:XX:XX:XX:XX
wpa-ssid SSID
wpa-psk PASSWORD

+ Strangely, the following does not show a phy0 and a phy1, but both
wlan0 and wlan1 work fine:
iw list
Wiphy phy0
        max # scan SSIDs: 4
        max scan IEs length: 2257 bytes
        Coverage class: 0 (up to 0m)
        Device supports RSN-IBSS.
        Device supports AP-side u-APSD.
        Device supports T-DLS.
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
                 * mesh point
                 * P2P-client
                 * P2P-GO
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
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
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
                 * Unknown command (104)
                 * connect
                 * disconnect
        Supported TX frame types:
                 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
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
                 * #{ managed } <= 2048, #{ AP, mesh point } <= 8, #{
P2P-client, P2P-GO } <= 1,
                   total <= 2048, #channels <= 1, STA/AP BI must match
                 * #{ WDS } <= 2048,
                   total <= 2048, #channels <= 1, STA/AP BI must match
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

When I run wavemon -i wlan1 it does not show a tx-power. However, if I
run wavemon on a different computer with the following chipset, it
does show tx-power:
lspci -vvnn
02:00.0 Network controller [0280]: Qualcomm Atheros QCA9565 / AR9565
Wireless Network Adapter [168c:0036] (rev 01)
    Subsystem: Lenovo Device [17aa:3026]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 36
    Region 0: Memory at f0800000 (64-bit, non-prefetchable) [size=512K]
    Expansion ROM at f0880000 [disabled] [size=64K]
    Capabilities: <access denied>
    Kernel driver in use: ath9k

However, this chipset also cannot have the txpower changed for a
different reason:
sudo iw dev wlan0 set txpower fixed 14
command failed: Operation not supported (-95)

I've spent the better part of this weekend looking through countless
forums, mailing lists, man pages, etc. and have not been provided a
clear answer to any of this. Anything you could do to clear this up is
greatly appreciated.

Thank you for your time and consideration in this matter.

Christopher M. Penalver
E-Mail: christopher.m.penalver@gmail.com
