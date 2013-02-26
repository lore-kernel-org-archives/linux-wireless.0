Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61381 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab3BZSG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 13:06:58 -0500
Received: by mail-ia0-f174.google.com with SMTP id u20so3649425iag.5
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2013 10:06:58 -0800 (PST)
Message-ID: <512CF9BF.8020302@lwfinger.net> (sfid-20130226_190703_624082_10648503)
Date: Tue, 26 Feb 2013 12:06:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Juan Carlos Garza Fernandez <juancarlosgarza@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Performance of Ralink 3072 USB Sticks 300Mbit
References: <CAMEN=G7J08P2+tG85zMXFj3LhmXL9Nv2YO2p8whB8U-b1zjjTA@mail.gmail.com>
In-Reply-To: <CAMEN=G7J08P2+tG85zMXFj3LhmXL9Nv2YO2p8whB8U-b1zjjTA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2013 10:15 AM, Juan Carlos Garza Fernandez wrote:
> Hi all,
>
> I am evaluating the performance of some USB sticks, some of them have
> a Ralink chipset,  yet I don't get thoughputs anything near the
> 300Mbit that all of the sticks advertise and I would like to ask this
> forum if anyone has any hints about why.
>
> I will describe my system and my test procedure.
>
> I basically build an access point using HostAPD (0.7.3) using DHCP and
> I transfer a file using Samba for the shared folders functionality,
> from a Linux 3.4.7 system into a Windows system. If the trasfer is
> done via our Gigabit network, I get transfer rates of 100 Mbit (which
> is the maximum that the Linux box can deliver as it has a 100 Mbit
> adapter). When transfering the file via Wireless, and after tweaking
> the HostAPD conf file a bit I could get a maximum of 3.3 MBps (~ 27
> Mbit) which is 10% from the advertised speed. My Windows PC has an
> Atheros AR9287 which is 2T2R as well and thus is be able to handle the
> 300 Mbit. Both devices are 1m apart and I chose channel 6 which is the
> least polluted one in my environment.
>
> I am mainly interested in the Access Point transfers, yet I have
> tested the Ad-Hoc connection as well (yet only 802.11.g 54Mbit) and
> with that I get even slower transfer rates.
>
> USB Chipset
> Ralink 3072
>
> Linux box:
> Kernel 3.4.7 Vanilla
>
> HostAPD conf:
> #===============================
> interface=wlan2
> driver=nl80211
> ssid=LLS0610007xx
> channel=6
> hw_mode=g
> max_num_sta=5
> ctrl_interface=/var/run/hostapd
> ignore_broadcast_ssid=0
> rts_threshold=2347
> fragm_threshold=2346
> macaddr_acl=0
> logger_syslog=-1
> logger_syslog_level=0
> logger_stdout=-1
> logger_stdout_level=0
> dump_file=/tmp/hostapd.dump
> ieee80211n=1
> ht_capab=[HT40-][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC12]
>
> auth_algs=1
> wpa=2
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=CCMP
> wpa_group_rekey=86400
> wpa_gmk_rekey=86400
> wpa_passphrase=0123456789
> #===============================
>
>
> iw list:
>
> Wiphy phy4
>          Band 1:
>                  Capabilities: 0x2f2
>                          HT20/HT40
>                          Static SM Power Save
>                          RX Greenfield
>                          RX HT20 SGI
>                          RX HT40 SGI
>                          TX STBC
>                          RX STBC 2-streams
>                          Max AMSDU length: 3839 bytes
>                          No DSSS/CCK HT40
>                  Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
>                  Minimum RX AMPDU time spacing: 2 usec (0x04)
>                  HT RX MCS rate indexes supported: 0-15, 32
>                  TX unequal modulation not supported
>                  HT TX Max spatial streams: 2
>                  HT TX MCS rate indexes supported may differ
>                  Frequencies:
>                          * 2412 MHz [1] (0.0 dBm)
>                          * 2417 MHz [2] (0.0 dBm)
>                          * 2422 MHz [3] (0.0 dBm)
>                          * 2427 MHz [4] (0.0 dBm)
>                          * 2432 MHz [5] (0.0 dBm)
>                          * 2437 MHz [6] (0.0 dBm)
>                          * 2442 MHz [7] (0.0 dBm)
>                          * 2447 MHz [8] (0.0 dBm)
>                          * 2452 MHz [9] (0.0 dBm)
>                          * 2457 MHz [10] (0.0 dBm)
>                          * 2462 MHz [11] (0.0 dBm)
>                          * 2467 MHz [12] (0.0 dBm) (passive scanning, no IBSS)
>                          * 2472 MHz [13] (0.0 dBm) (passive scanning, no IBSS)
>                          * 2484 MHz [14] (0.0 dBm) (passive scanning, no IBSS)
>                  Bitrates (non-HT):
>                          * 1.0 Mbps
>                          * 2.0 Mbps (short preamble supported)
>                          * 5.5 Mbps (short preamble supported)
>                          * 11.0 Mbps (short preamble supported)
>                          * 6.0 Mbps
>                          * 9.0 Mbps
>                          * 12.0 Mbps
>                          * 18.0 Mbps
>                          * 24.0 Mbps
>                          * 36.0 Mbps
>                          * 48.0 Mbps
>                          * 54.0 Mbps
>          max # scan SSIDs: 4
>          max scan IEs length: 2257 bytes
>          Coverage class: 0 (up to 0m)
>          Supported Ciphers:
>                  * WEP40 (00-0f-ac:1)
>                  * WEP104 (00-0f-ac:5)
>                  * TKIP (00-0f-ac:2)
>                  * CCMP (00-0f-ac:4)
>          Available Antennas: TX 0 RX 0
>          Supported interface modes:
>                   * IBSS
>                   * managed
>                   * AP
>                   * AP/VLAN
>                   * WDS
>                   * monitor
>          software interface modes (can always be added):
>                   * AP/VLAN
>                   * monitor
>          interface combinations are not supported
>          Supported commands:
>                   * new_interface
>                   * set_interface
>                   * new_key
>                   * new_beacon
>                   * new_station
>                   * set_bss
>                   * authenticate
>                   * associate
>                   * deauthenticate
>                   * disassociate
>                   * join_ibss
>                   * remain_on_channel
>                   * set_tx_bitrate_mask
>                   * action
>                   * frame_wait_cancel
>                   * set_wiphy_netns
>                   * set_channel
>                   * set_wds_peer
>                   * Unknown command (84)
>                   * Unknown command (87)
>                   * Unknown command (85)
>                   * connect
>                   * disconnect
>          Supported TX frame types:
>                   * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
> 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                   * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
> 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                   * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
> 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                   * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
> 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                   * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
> 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                   * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
> 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>                   * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
> 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
>          Supported RX frame types:
>                   * IBSS: 0xd0
>                   * managed: 0x40 0xd0
>                   * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
>                   * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
>                   * mesh point: 0xb0 0xc0 0xd0
>                   * P2P-client: 0x40 0xd0
>                   * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
>          HT Capability overrides:
>                   * MCS: ff ff ff ff ff ff ff ff ff ff
>                   * maximum A-MSDU length
>                   * supported channel width
>                   * short GI for 40 MHz
>                   * max A-MPDU length exponent
>                   * min MPDU start spacing
>          Device supports TX status socket option.
>          Device supports HT-IBSS.
>
>
> Does anyone have a clue?

First of all, 802.11 is a half-duplex medium, thus your throughput is limited to 
roughly half the reported rate. In addition, many conditions will prevent even 
reaching that value for 802.11n.

Read http://compnetworking.about.com/od/wireless/f/80211n-300-mbps.htm for a 
description of what it takes to reach the value.

My best performance has been ~70 Mbps on a TP-Link TL-WN722N, which uses ath9k_htc.

Larry


