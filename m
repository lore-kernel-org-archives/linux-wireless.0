Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64252 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891AbaEMNxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 09:53:34 -0400
Received: by mail-lb0-f172.google.com with SMTP id l4so297647lbv.31
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2014 06:53:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43860A184C2C6446B49A5DEBD1F0DA6B815E766D@PDIMBX.PDIARM.local>
References: <43860A184C2C6446B49A5DEBD1F0DA6B815E766D@PDIMBX.PDIARM.local>
Date: Tue, 13 May 2014 16:53:32 +0300
Message-ID: <CANUX_P0N6oqDHOSJ-=bM11uf730ishMxwWD_yLtwYZrK02qp=Q@mail.gmail.com> (sfid-20140513_155338_016258_E58BE12F)
Subject: Re: Integrate Intel 3160 Freescale imx.6 with AOSP 4.3 (3.0.35
 kernel) and backports 3.14.1
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Michael Robbeloth <mrobbeloth@pdiarm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2014 at 4:16 PM, Michael Robbeloth
<mrobbeloth@pdiarm.com> wrote:
> I have been trying without success to integrate the Intel 3160 PCI-e module into a Freescale imx.6 based board from BCM Advanced Research running AOSP 4.3 with 3.0.35 kernel and backports 3.14.1. The driver loads fines, but is missing the p2p0 netdev required by the wpa supplicant. I subsequently integrated the Johannes Berg Android P2P Workaround Hack patch into backports 3.14.1 and added the iw utility for adding the p2p0 interface. However, the command from that patch thread for adding the interface fails to create the netdev (no error message given, seems to return fine). The logcat still shows the following output related to p2p0, which is probably familiar to some on this list:

can you make sure you have the Kconfig in Johannes's patch set?
can you send the output of iw dev?

>
> D/wpa_supplicant( 2565): Initializing interface 'p2p0' conf '/data/misc/wifi/p2p_supplicant.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
> D/wpa_supplicant( 2565): Could not open file /sys/class/net/p2p0/phy80211/name: No such file or directory
> E/wpa_supplicant( 2565): Could not read interface p2p0 flags: No such device
> E/wpa_supplicant( 2565): p2p0: Failed to initialize driver interface
> D/wpa_supplicant( 2565): Failed to add interface p2p0
> D/wpa_supplicant( 2565): p2p0: Cancelling scan request
> D/wpa_supplicant( 2565): p2p0: P2P: Station mode scan operation not pending anymore (sta_scan_pending=0 p2p_cb_on_scan_complete=0)
> D/wpa_supplicant( 2565): p2p0: Cancelling authentication timeout
>
> lsmod  provides me with the following:
>
> iwlmvm 173805 0 - Live 0x00000000
> iwldvm 216512 0 - Live 0x00000000
> iwlwifi 88443 2 iwlmvm,iwldvm, Live 0x00000000


This is weird, why do you have iwldvm?
You don't really need it - since Android doesn't have udev, I guess
you just insmoded it?

> btsdio 3848 0 - Live 0x00000000
> hci_vhci 3195 0 - Live 0x00000000
> btusb 16510 0 - Live 0x00000000
> bnep 11653 0 - Live 0x00000000
> hidp 14250 0 - Live 0x00000000
> rfcomm 34150 0 - Live 0x00000000
> bluetooth 312434 8 btsdio,hci_vhci,btusb,bnep,hidp,rfcomm, Live 0x00000000
> 6lowpan_iphc 9530 1 bluetooth, Live 0x00000000
> cordic 763 0 - Live 0x00000000
> mac80211 313120 2 iwlmvm,iwldvm, Live 0x00000000
> cfg80211 176607 4 iwlmvm,iwldvm,iwlwifi,mac80211, Live 0x00000000
> compat 19882 12 iwlmvm,iwldvm,iwlwifi,btsdio,hci_vhci,btusb,bnep,hidp,rfcomm,bluetooth,mac80211,cfg80211, Live 0x00000000
>
> I realize some of those drivers are unnecessary (I have an experimenting with various setups).
>
> dmesg shows the Intel driver found the firmware:
>
> <6>[    4.457220] iwlwifi 0000:01:00.0: loaded firmware version 22.24.8.0 op_mode iwlmvm
> <6>[    4.498872] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band Wireless AC 3160, REV=0x164
> <6>[    4.553591] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
> <6>[    4.577482] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
> <7>[    4.833079] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
>
> iw shows:
>
> root@ar6mx:/ # iw wlan0 info
> Interface wlan0
>         ifindex 6
>         wdev 0x1
>         addr a0:88:69:0d:aa:34
>         type managed
>         wiphy 0
> root@ar6mx:/ # iw phy0 info
> Wiphy phy0
>         max # scan SSIDs: 20
>         max scan IEs length: 393 bytes
>         Retry short limit: 7
>         Retry long limit: 4
>         Coverage class: 0 (up to 0m)
>         Device supports RSN-IBSS.
>         Supported Ciphers:
>                 * CCMP (00-0f-ac:4)
>                 * TKIP (00-0f-ac:2)
>                 * WEP40 (00-0f-ac:1)
>                 * WEP104 (00-0f-ac:5)
>                 * CMAC (00-0f-ac:6)
>                 * WPI-SMS4 (00-14-72:1)
>         Available Antennas: TX 0 RX 0
>         Supported interface modes:
>                  * IBSS
>                  * managed
>                  * AP
>                  * AP/VLAN
>                  * monitor
>                  * P2P-client
>                  * P2P-GO
>                  * P2P-device
>         Band 1:
>                 Capabilities: 0x1162
>                         HT20/HT40
>                         Static SM Power Save
>                         RX HT20 SGI
>                         RX HT40 SGI
>                         RX STBC 1-stream
>                         Max AMSDU length: 3839 bytes
>                         DSSS/CCK HT40
>                 Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
>                 Minimum RX AMPDU time spacing: 4 usec (0x05)
>                 HT TX/RX MCS rate indexes supported: 0-7, 32
>                 Bitrates (non-HT):
>                         * 1.0 Mbps
>                         * 2.0 Mbps (short preamble supported)
>                         * 5.5 Mbps (short preamble supported)
>                         * 11.0 Mbps (short preamble supported)
>                         * 6.0 Mbps
>                         * 9.0 Mbps
>                         * 12.0 Mbps
>                         * 18.0 Mbps
>                         * 24.0 Mbps
>                         * 36.0 Mbps
>                         * 48.0 Mbps
>                         * 54.0 Mbps
>                 Frequencies:
>                         * 5180 MHz [36] (16.0 dBm) (no IR)
>                         * 5200 MHz [40] (16.0 dBm) (no IR)
>                         * 5220 MHz [44] (16.0 dBm) (no IR)
>                         * 5240 MHz [48] (16.0 dBm) (no IR)
>                         * 5260 MHz [52] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5280 MHz [56] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5300 MHz [60] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5320 MHz [64] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5500 MHz [100] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5520 MHz [104] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5540 MHz [108] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5560 MHz [112] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5580 MHz [116] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5600 MHz [120] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5620 MHz [124] (16.0 dBm) (no IR, radar detection)
>                          DFS state: usable (for 349 sec)
>                         * 5640 MHz [128] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5660 MHz [132] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5680 MHz [136] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5700 MHz [140] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5720 MHz [144] (16.0 dBm) (no IR, radar detection)
>                           DFS state: usable (for 349 sec)
>                         * 5745 MHz [149] (16.0 dBm) (no IR)
>                         * 5765 MHz [153] (16.0 dBm) (no IR)
>                         * 5785 MHz [157] (16.0 dBm) (no IR)
>                         * 5805 MHz [161] (16.0 dBm) (no IR)
>                         * 5825 MHz [165] (16.0 dBm) (no IR)
>         Supported commands:
>                  * new_interface
>                  * set_interface
>                  * new_key
>                  * start_ap
>                  * new_station
>                  * set_bss
>                  * authenticate
>                  * associate
>                  * deauthenticate
>                  * disassociate
>                  * join_ibss
>                  * remain_on_channel
>                  * set_tx_bitrate_mask
>                  * frame
>                  * frame_wait_cancel
>                  * set_wiphy_netns
>                  * set_channel
>                  * set_wds_peer
>                  * probe_client
>                 * set_noack_map
>                  * register_beacons
>                  * start_p2p_device
>                  * set_mcast_rate
>                  * Unknown command (104)
>                  * connect
>                  * disconnect
>         Supported TX frame types:
>                  * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                  * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                  * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                  * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                  * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                  * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                  * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                  * P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>         Supported RX frame types:
>                  * IBSS: 0x40 0xb0 0xc0 0xd0
>                  * managed: 0x40 0xd0
>                  * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
>                  * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
>                  * mesh point: 0xb0 0xc0 0xd0
>                  * P2P-client: 0x40 0xd0
>                  * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
>                  * P2P-device: 0x40 0xd0
>         WoWLAN support:
>                  * wake up on disconnect
>                  * wake up on magic packet
>                  * wake up on pattern match, up to 20 patterns of 16-128 bytes,
>                    maximum packet offset 0 bytes
>                  * can do GTK rekeying
>                  * wake up on GTK rekey failure
>                  * wake up on EAP identity request
>                  * wake up on 4-way handshake
>                  * wake up on rfkill release
>                  * wake up on TCP connection
>         software interface modes (can always be added):
>                  * AP/VLAN
>                  * monitor
>         valid interface combinations:
>                  * #{ managed } <= 1, #{ AP, P2P-client, P2P-GO } <= 1, #{ P2P-device } <= 1,
>                    total <= 3, #channels <= 1
>         HT Capability overrides:
>                  * MCS: ff ff ff ff ff ff ff ff ff ff
>                  * maximum A-MSDU length
>                  * supported channel width
>                  * short GI for 40 MHz
>                  * max A-MPDU length exponent
>                  * min MPDU start spacing
>         Device supports HT-IBSS.
>         Device supports low priority scan.
>         Device supports scan flush
>
> My sys/clas/net listing shows the following:
>
> 1|root@ar6mx:/system/lib/modules # ls /sys/class/net
> eth0
> ip6tnl0
> lo
> sit0
> tunl0
> wlan0
>
> wlan0 has the following listing from ifconfig and netcfg:
>
> root@ar6mx:/system/lib/modules # busybox ifconfig wlan0
> wlan0     Link encap:Ethernet  HWaddr A0:88:69:0D:AA:34
>           BROADCAST MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>
> lo       UP                                   127.0.0.1/8   0x00000049 00:00:00:00:00:00
> eth0     UP                                     0.0.0.0/0   0x00001043 00:02:6b:10:f0:93
> tunl0    DOWN                                   0.0.0.0/0   0x00000080 00:00:00:00:00:00
> sit0     DOWN                                   0.0.0.0/0   0x00000080 00:00:00:00:00:00
> ip6tnl0  DOWN                                   0.0.0.0/0   0x00000080 00:00:00:00:00:00
> wlan0    DOWN                                   0.0.0.0/0   0x00001002 a0:88:69:0d:aa:34
>
> If anyone could assist me with getting this board working, I would appreciate it. Thank you.
>
> Michael Robbeloth
> Embedded Software Engineer
>
> PDi Communication Systems, Inc.
> mrobbeloth@pdiarm.com | www.pdiarm.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
