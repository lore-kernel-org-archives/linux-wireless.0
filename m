Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49069 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3KLTgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 14:36:06 -0500
Message-ID: <52828324.3060105@candelatech.com> (sfid-20131112_203611_473436_6FD1A9F0)
Date: Tue, 12 Nov 2013 11:36:04 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Association often fails first time when roaming with 802.11r.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am using a 3.9.11+ kernel, ath9k for stations, and some Cisco APs
and controller for the AP side of things.

It is taking on average about 150ms to complete the roam, even when
staying on the same channel.  From the supplicant logs, it seems
the main problem is that the kernel rejects the auth
with EINPROGRESS on the first attempt.

Is this a known issue?

1384284459.394808: CTRL_IFACE ROAM dc:a5:f4:ff:4f:ad
1384284459.394826: sta1: Considering connect request: reassociate: 1  selected: dc:a5:f4:ff:4f:ad  bssid: dc:a5:f4:ff:4f:ad  pending: 00:00:00:00:00:00
wpa_state: COMPLETED  ssid=0x20e8820  current_ssid=0x20e8820
1384284459.394835: sta1: Request association: reassociate: 1  selected: dc:a5:f4:ff:4f:ad  bssid: dc:a5:f4:ff:4f:ad  pending: 00:00:00:00:00:00  wpa_state:
COMPLETED
1384284459.394841: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=12): 00 0a 61 69 72 6f 6e 65 74 31 2d 35
1384284459.394846: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=20): 07 12 55 53 20 24 04 11 34 04 18 64 05 18 84 03 18 95 05 1e
1384284459.394852: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=7): 0b 05 01 00 02 8d 5b
1384284459.394856: WPA: RSN IE in EAPOL-Key - hexdump(len=26): 30 18 01 00 00 0f ac 04 01 00 00 0f ac 04 02 00 00 0f ac 01 00 0f ac 03 28 00
1384284459.394862: WPA: MDIE in EAPOL-Key - hexdump(len=5): 36 03 6f c9 00
1384284459.394866: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=24): 3d 16 24 08 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1384284459.394872: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=32): 85 1e 00 00 8f 00 0f 00 ff 03 59 00 41 50 37 63 36 39 2e 66 36 65 31 2e 63 62 33
00 01 00 00 41
1384284459.394879: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=8): 96 06 00 40 96 00 0e 00
1384284459.394884: TDLS: TDLS is allowed in the target BSS
1384284459.394889: sta1: Automatic auth_alg selection: 0x1
1384284459.394895: RSN: PMKSA cache search - network_ctx=0x20e8820 try_opportunistic=1
1384284459.394898: RSN: Search for BSSID dc:a5:f4:ff:4f:ad
1384284459.394902: RSN: Consider dc:a5:f4:ff:4f:ad for OKC
1384284459.394906: RSN: No PMKSA cache entry found
1384284459.394911: sta1: RSN: using IEEE 802.11i/D9.0
1384284459.394915: sta1: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 33 proto 2
1384284459.394919: sta1: WPA: Selected mgmt group cipher 32
1384284459.394923: sta1: WPA: clearing AP WPA IE
1384284459.394927: WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 04 01 00 00 0f ac 04 02 00 00 0f ac 01 00 0f ac 03 28 00
1384284459.394935: sta1: WPA: using GTK CCMP
1384284459.394939: sta1: WPA: using PTK CCMP
1384284459.394942: sta1: WPA: using KEY_MGMT FT/802.1X
1384284459.394946: sta1: WPA: not using MGMT group cipher
1384284459.394951: WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 03 00 00
1384284459.394958: FT: Mobility domain - hexdump(len=2): 6f c9
1384284459.394962: FT: Capability and Policy: 0x00
1384284459.394966: FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=5): 36 03 6f c9 00
1384284459.395410: SME: FT IEs - hexdump(len=135): 30 26 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 03 00 00 01 00 6e df 5d 77 51 4c ca 98 9d d8 5b 4c
98 a5 f6 cf 36 03 6f c9 00 37 58 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 6b 42 5f b9 74 0a 94 ad c9 d1 32 0d ec 33 fe e4 e2 1d 60 c6 3a 09 8e 9c 91 da 54 74 60 f7 e5 f5 03 04 c0 a8 02 0a
1384284459.395437: sta1: SME: Trying to use FT over-the-air
1384284459.395446: sta1: Cancelling scan request
1384284459.395450: sta1: P2P: Station mode scan operation not pending anymore (sta_scan_pending=0 p2p_cb_on_scan_complete=0)
1384284459.395456: sta1: SME: Trying to authenticate with dc:a5:f4:ff:4f:ad (SSID='aironet1-5' freq=5180 MHz)
1384284459.395473: wpa_driver_nl80211_set_key: ifindex=6 (sta1) alg=0 addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
1384284459.395514: wpa_driver_nl80211_set_key: ifindex=6 (sta1) alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
1384284459.395642: wpa_driver_nl80211_set_key: ifindex=6 (sta1) alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
1384284459.395692: wpa_driver_nl80211_set_key: ifindex=6 (sta1) alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
1384284459.395722: wpa_driver_nl80211_set_key: ifindex=6 (sta1) alg=0 addr=(nil) key_idx=4 set_tx=0 seq_len=0 key_len=0
1384284459.395743: wpa_driver_nl80211_set_key: ifindex=6 (sta1) alg=0 addr=(nil) key_idx=5 set_tx=0 seq_len=0 key_len=0
1384284459.395761: wpa_driver_nl80211_set_key: ifindex=6 (sta1) alg=0 addr=0x20e9710 key_idx=0 set_tx=0 seq_len=0 key_len=0
1384284459.395768:    addr=dc:a5:f4:ff:4f:ad
1384284459.395868: sta1: State: COMPLETED -> AUTHENTICATING
1384284459.395890: EAPOL: External notification - EAP success=0
1384284459.395906: EAPOL: External notification - EAP fail=0
1384284459.395918: EAPOL: External notification - portControl=Auto
1384284459.395933: nl80211: Authenticate (ifindex=6)
1384284459.395940:   * bssid=dc:a5:f4:ff:4f:ad
1384284459.395947:   * freq=5180
1384284459.395953:   * SSID - hexdump_ascii(len=10):
     61 69 72 6f 6e 65 74 31 2d 35                     aironet1-5
1384284459.395966:   * IEs - hexdump(len=135): 30 26 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 03 00 00 01 00 6e df 5d 77 51 4c ca 98 9d d8 5b 4c 98 a5
f6 cf 36 03 6f c9 00 37 58 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 6b 42 5f b9 74 0a 94 ad c9 d1 32 0d ec 33 fe e4 e2 1d 60 c6 3a 09 8e 9c 91 da 54 74 60 f7 e5 f5 03 04 c0 a8 02 0a
1384284459.395987:   * Auth Type 2
1384284459.396010: sta1: nl80211: MLME command failed (auth): ret=-114 (Operation already in progress)
1384284459.396017: sta1: SME: Authentication request to the driver failed
1384284459.396021: Added BSSID dc:a5:f4:ff:4f:ad into blacklist
1384284459.396028: sta1: Another BSS in this ESS has been seen; try it next
1384284459.396031: BSSID dc:a5:f4:ff:4f:ad blacklist count incremented to 2
1384284459.396036: sta1: Blacklist count 1 --> request scan in 100 ms

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

