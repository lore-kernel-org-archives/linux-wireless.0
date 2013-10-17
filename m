Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hero.com ([66.180.170.64]:44795 "EHLO hero.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758245Ab3JQTyX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 15:54:23 -0400
Date: Thu, 17 Oct 2013 11:23:24 -0700 (PDT)
From: Kenneth Berland <ken@hero.com>
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Centrino Wireless-N 2200 authentication time-outs and unexpected
 deauthentication
Message-ID: <alpine.LFD.2.00.1310171107460.9527@hero.com> (sfid-20131017_215427_423175_1EC35ACF)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

I'm having a hard time keeping a connection to a Ruckus ZoneFlex 7982 AP. 
The SSID is running WPA2/PSK/AES.  I'm running a recent iwlwifi kernel 
(3.12.0-rc3-wl+) and have a Centrino chipset.  After an hour or so, the 
interface is disconnected.  It can only reauthenticate when the iwlwifi 
module is removed and re-inserted.

Thanks in advance,
Ken

I'm running a recent wpa_supplicant with nl80211 like this:

/sbin/wpa_supplicant -Dnl80211 -s -i wlan0 -c ./gr-test.conf

The relevant log output is the following (I think):

Oct 17 10:39:26 ken-x230 wpa_supplicant[15828]: Successfully initialized wpa_supplicant
Oct 17 10:39:26 ken-x230 kernel: [19456.093074] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
Oct 17 10:39:26 ken-x230 kernel: [19456.100991] iwlwifi 0000:03:00.0: Radio type=0x2-0x0-0x0
Oct 17 10:39:26 ken-x230 kernel: [19456.173751] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Oct 17 10:39:27 ken-x230 wpa_supplicant[15828]: wlan0: SME: Trying to authenticate with 2c:e6:cc:84:8d:98 (SSID='GR-Test' freq=2457 MHz)
Oct 17 10:39:27 ken-x230 kernel: [19456.930480] wlan0: authenticate with 2c:e6:cc:84:8d:98
Oct 17 10:39:27 ken-x230 kernel: [19456.935141] wlan0: send auth to 2c:e6:cc:84:8d:98 (try 1/3)
Oct 17 10:39:28 ken-x230 kernel: [19458.156795] wlan0: send auth to 2c:e6:cc:84:8d:98 (try 2/3)
Oct 17 10:39:29 ken-x230 kernel: [19459.169462] wlan0: send auth to 2c:e6:cc:84:8d:98 (try 3/3)
Oct 17 10:39:30 ken-x230 kernel: [19460.170078] wlan0: authentication with 2c:e6:cc:84:8d:98 timed out
Oct 17 10:39:31 ken-x230 wpa_supplicant[15828]: wlan0: SME: Trying to authenticate with 2c:e6:cc:84:8d:98 (SSID='GR-Test' freq=2457 MHz)
Oct 17 10:39:31 ken-x230 kernel: [19460.932095] wlan0: authenticate with 2c:e6:cc:84:8d:98
Oct 17 10:39:31 ken-x230 kernel: [19460.935224] wlan0: send auth to 2c:e6:cc:84:8d:98 (try 1/3)
Oct 17 10:39:32 ken-x230 kernel: [19462.159432] wlan0: send auth to 2c:e6:cc:84:8d:98 (try 2/3)
Oct 17 10:39:33 ken-x230 kernel: [19463.148066] wlan0: send auth to 2c:e6:cc:84:8d:98 (try 3/3)
Oct 17 10:39:34 ken-x230 kernel: [19464.148711] wlan0: authentication with 2c:e6:cc:84:8d:98 timed out
Oct 17 10:39:35 ken-x230 wpa_supplicant[15828]: wlan0: SME: Trying to authenticate with 2c:e6:cc:84:8d:98 (SSID='GR-Test' freq=2457 MHz)
Oct 17 10:39:35 ken-x230 kernel: [19465.307056] wlan0: authenticate with 2c:e6:cc:84:8d:98
Oct 17 10:39:35 ken-x230 kernel: [19465.311719] wlan0: send auth to 2c:e6:cc:84:8d:98 (try 1/3)
Oct 17 10:39:36 ken-x230 kernel: [19466.162056] wlan0: send auth to 2c:e6:cc:84:8d:98 (try 2/3)
Oct 17 10:39:37 ken-x230 kernel: [19467.162688] wlan0: send auth to 2c:e6:cc:84:8d:98 (try 3/3)
Oct 17 10:39:38 ken-x230 kernel: [19468.139372] wlan0: authentication with 2c:e6:cc:84:8d:98 timed out

or, sometimes, like this:

Oct 16 18:35:20 ken-x230 wpa_supplicant[5490]: wlan0: CTRL-EVENT-CONNECTED - Connection to 2c:e6:cc:84:8d:98 completed [id=0 id_str=]
Oct 16 18:35:22 ken-x230 kernel: [ 5141.751420] wlan0: deauthenticated from 2c:e6:cc:84:8d:98 (Reason: 6)
Oct 16 18:35:22 ken-x230 wpa_supplicant[5490]: wlan0: CTRL-EVENT-DISCONNECTED bssid=2c:e6:cc:84:8d:98 reason=6
Oct 16 18:35:22 ken-x230 wpa_supplicant[5490]: wlan0: SME: Trying to authenticate with 2c:e6:cc:84:8d:98 (SSID='GR-Test' freq=2457 MHz)
Oct 16 18:35:22 ken-x230 kernel: [ 5141.806347] wlan0: authenticate with 2c:e6:cc:84:8d:98
Oct 16 18:35:22 ken-x230 wpa_supplicant[5490]: wlan0: Trying to associate with 2c:e6:cc:84:8d:98 (SSID='GR-Test' freq=2457 MHz)
Oct 16 18:35:22 ken-x230 kernel: [ 5141.810436] wlan0: send auth to 2c:e6:cc:84:8d:98 (try 1/3)
Oct 16 18:35:22 ken-x230 kernel: [ 5141.812469] wlan0: authenticated
Oct 16 18:35:22 ken-x230 kernel: [ 5141.813760] wlan0: associate with 2c:e6:cc:84:8d:98 (try 1/3)
Oct 16 18:35:22 ken-x230 kernel: [ 5141.817635] wlan0: RX AssocResp from 2c:e6:cc:84:8d:98 (capab=0x431 status=0 aid=3)
Oct 16 18:35:22 ken-x230 wpa_supplicant[5490]: wlan0: Associated with 2c:e6:cc:84:8d:98
Oct 16 18:35:22 ken-x230 kernel: [ 5141.836654] wlan0: associated
Oct 16 18:35:22 ken-x230 wpa_supplicant[5490]: wlan0: WPA: Key negotiation completed with 2c:e6:cc:84:8d:98 [PTK=CCMP GTK=CCMP]
Oct 16 18:35:22 ken-x230 wpa_supplicant[5490]: wlan0: CTRL-EVENT-CONNECTED - Connection to 2c:e6:cc:84:8d:98 completed [id=0 id_str=]
Oct 16 18:35:25 ken-x230 kernel: [ 5144.220601] wlan0: deauthenticated from 2c:e6:cc:84:8d:98 (Reason: 6)
Oct 16 18:35:25 ken-x230 wpa_supplicant[5490]: wlan0: CTRL-EVENT-DISCONNECTED bssid=2c:e6:cc:84:8d:98 reason=6
Oct 16 18:35:25 ken-x230 wpa_supplicant[5490]: wlan0: SME: Trying to authenticate with 2c:e6:cc:84:8d:98 (SSID='GR-Test' freq=2457 MHz)
Oct 16 18:35:25 ken-x230 kernel: [ 5144.263904] wlan0: authenticate with 2c:e6:cc:84:8d:98
Oct 16 18:35:25 ken-x230 wpa_supplicant[5490]: wlan0: Trying to associate with 2c:e6:cc:84:8d:98 (SSID='GR-Test' freq=2457 MHz)
Oct 16 18:35:25 ken-x230 kernel: [ 5144.268060] wlan0: send auth to 2c:e6:cc:84:8d:98 (try 1/3)
Oct 16 18:35:25 ken-x230 kernel: [ 5144.269809] wlan0: authenticated
Oct 16 18:35:25 ken-x230 kernel: [ 5144.271371] wlan0: associate with 2c:e6:cc:84:8d:98 (try 1/3)
Oct 16 18:35:25 ken-x230 kernel: [ 5144.275280] wlan0: RX AssocResp from 2c:e6:cc:84:8d:98 (capab=0x431 status=0 aid=3)
Oct 16 18:35:25 ken-x230 wpa_supplicant[5490]: wlan0: Associated with 2c:e6:cc:84:8d:98
Oct 16 18:35:25 ken-x230 kernel: [ 5144.294692] wlan0: associated
Oct 16 18:35:25 ken-x230 wpa_supplicant[5490]: wlan0: WPA: Key negotiation completed with 2c:e6:cc:84:8d:98 [PTK=CCMP GTK=CCMP]
Oct 16 18:35:25 ken-x230 wpa_supplicant[5490]: wlan0: CTRL-EVENT-CONNECTED - Connection to 2c:e6:cc:84:8d:98 completed [id=0 id_str=]
Oct 16 18:35:26 ken-x230 kernel: [ 5145.809824] wlan0: deauthenticated from 2c:e6:cc:84:8d:98 (Reason: 6)
Oct 16 18:35:26 ken-x230 wpa_supplicant[5490]: wlan0: CTRL-EVENT-DISCONNECTED bssid=2c:e6:cc:84:8d:98 reason=6

Here is the other, I hope relevant, info:

$ uname -a
Linux ken-x230 3.12.0-rc3-wl+ #1 SMP Tue Oct 8 11:47:43 PDT 2013 x86_64 x86_64 x86_64 GNU/Linux # git-sha 1f117d

# wpa_supplicant version:
$ git remote -v | head -1
origin        git://w1.fi/srv/git/hostap.git (fetch)
$ git log --decorate | head -1
commit 5bfd7e91685e65977c8db72afdca0cab310f8667 (HEAD, origin/master, origin/HEAD, master)

$ lspci -v # edited
03:00.0 Network controller: Intel Corporation Centrino Wireless-N 2200 (rev c4)
         Subsystem: Intel Corporation Centrino Wireless-N 2200 BGN
         Flags: bus master, fast devsel, latency 0, IRQ 46
         Memory at f1c00000 (64-bit, non-prefetchable) [size=8K]
         Capabilities: <access denied>
         Kernel driver in use: iwlwifi
         Kernel modules: iwlwifi

$ iw dev wlan0 info  # before it locks up
Interface wlan0
           ifindex 14
           type managed
           wiphy 0
$ iw dev wlan0 link  #again, before it locks up
Connected to 2c:e6:cc:84:8d:98 (on wlan0)
           SSID: GR-Test
           freq: 2457
           RX: 14757340 bytes (45075 packets)
           TX: 2596610 bytes (8879 packets)
           signal: -37 dBm
           tx bitrate: 130.0 MBit/s MCS 14 short GI

           bss flags:  short-preamble short-slot-time
           dtim period:               0
           beacon int:                100

$ iw list

Wiphy phy0
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
             * 2457 MHz [10] (16.0 dBm)
             * 2462 MHz [11] (15.0 dBm)
             * 2467 MHz [12] (15.0 dBm) (passive scanning, no IBSS)
             * 2472 MHz [13] (15.0 dBm) (passive scanning, no IBSS)
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
     max # scan SSIDs: 20
     max scan IEs length: 195 bytes
     Coverage class: 0 (up to 0m)
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
     software interface modes (can always be added):
          * AP/VLAN
          * monitor
     valid interface combinations:
          * #{ managed } <= 1, #{ AP } <= 1,
            total <= 2, #channels <= 1, STA/AP BI must match
          * #{ managed } <= 2,
            total <= 2, #channels <= 1
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
          * set_tx_bitrate_mask
          * action
          * frame_wait_cancel
          * set_wiphy_netns
          * set_channel
          * set_wds_peer
          * Unknown command (84)
          * Unknown command (87)
          * Unknown command (85)
          * Unknown command (89)
          * Unknown command (92)
          * testmode
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
          * Unknown mode (10): 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
     Supported RX frame types:
          * IBSS: 0x40 0xb0 0xc0 0xd0
          * managed: 0x40 0xd0
          * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
          * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
          * mesh point: 0xb0 0xc0 0xd0
          * P2P-client: 0x40 0xd0
          * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
          * Unknown mode (10): 0x40 0xd0
     Device supports RSN-IBSS.
     WoWLAN support:
          * wake up on disconnect
          * wake up on magic packet
          * wake up on pattern match, up to 20 patterns of 16-128 bytes
          * can do GTK rekeying
          * wake up on GTK rekey failure
          * wake up on EAP identity request
          * wake up on rfkill release
     HT Capability overrides:
          * MCS: ff ff ff ff ff ff ff ff ff ff
          * maximum A-MSDU length
          * supported channel width
          * short GI for 40 MHz
          * max A-MPDU length exponent
          * min MPDU start spacing
     Device supports TX status socket option.
     Device supports HT-IBSS.

$ lsmod | grep iwlwifi
iwlwifi               165203  1 iwldvm
cfg80211              494159  3 iwldvm,mac80211,iwlwifi

