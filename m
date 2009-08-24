Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42179 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbZHXUWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 16:22:39 -0400
Received: by bwz19 with SMTP id 19so1671235bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2009 13:22:39 -0700 (PDT)
Subject: Re: driver_nl80211 broken again
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1251122885.12007.12.camel@johannes.local>
References: <1251117161.22951.4.camel@maxim-laptop>
	 <1251122885.12007.12.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 23:06:21 +0300
Message-Id: <1251144381.9374.4.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-08-24 at 16:08 +0200, Johannes Berg wrote:
> On Mon, 2009-08-24 at 15:32 +0300, Maxim Levitsky wrote:
> > First connection works fine, but all following connections hang
> > wpa_supplicant hard, and more than that, this is first time,
> > NetworkManager confused that much that it refuses flat to connect to my
> > network, even if I  reload the wireless stack.
> > 
> > Only way to connect again, is to reload wireless stack, restart
> > wpa_supplicant, and restart NM, and this helps, only for one more shot.
> > 
> > My network is WPA2 protected, I use iwl3945, this is quite recent
> > regression (of course I use tip of wireless-testing)
> 
> Need more info, works ok here (hwsim).
> 
> johannes

This is typical output of iwconfig, after failure
(and I know that this output means trouble):


wlan0     IEEE 802.11bg  Mode:Managed  Access Point: Not-Associated   
          Tx-Power=15 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:on
          
Best regards,
	Maxim Levitsky


PS: This is wpa_supplicant log:

sudo wpa_supplicant -ddd -u
Providing DBus service 'fi.epitest.hostap.WPASupplicant'.
Initializing interface 'wlan0' conf 'N/A' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
nl80211: Operstate: linkmode=1, operstate=5
Own MAC address: 00:1b:77:f1:7c:29
nl_set_encr: ifindex=5 alg=0 addr=0x451355 key_idx=0 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67 Link has been severed)
nl_set_encr: ifindex=5 alg=0 addr=0x451355 key_idx=1 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67 Link has been severed)
nl_set_encr: ifindex=5 alg=0 addr=0x451355 key_idx=2 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67 Link has been severed)
nl_set_encr: ifindex=5 alg=0 addr=0x451355 key_idx=3 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67 Link has been severed)
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Added interface wlan0
Setting scan request: 0 sec 0 usec
Setting scan request: 0 sec 0 usec
Trying to get current scan results first without requesting a new scan to speed up initial association
Received scan results (0 BSSes)
Cached scan results are empty - not posting
No suitable AP found.
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 10 seconds
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
nl80211: Event message available
nl80211: New scan results available
Received scan results (9 BSSes)
CTRL-EVENT-SCAN-RESULTS 
No suitable AP found.
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
nl80211: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
key_mgmt: 0x2
scan_ssid=1 (0x1)
PSK (ASCII passphrase) - hexdump_ascii(len=15): [REMOVED]
ssid - hexdump_ascii(len=6):
     31 32 33 34 35 36                                 <SSID>          
PSK (from passphrase) - hexdump(len=32): [REMOVED]
Not rescheduling scan to ensure that specific SSID scans occur
State: DISCONNECTED -> SCANNING
Scan SSID - hexdump_ascii(len=6):
     31 32 33 34 35 36                                 <SSID>          
Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (10 BSSes)
CTRL-EVENT-SCAN-RESULTS 
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: <BSSID> ssid='<SSID>' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
   selected based on RSN IE
   selected WPA AP <BSSID> ssid='<SSID>'
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
Cancelling scan request
Trying to authenticate with <BSSID> (SSID='<SSID>' freq=2412 MHz)
No keys have been configured - skip key clearing
State: SCANNING -> AUTHENTICATING
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
nl80211: Authenticate (ifindex=5)
  * bssid=<BSSID>
  * freq=2412
  * SSID - hexdump_ascii(len=6):
     31 32 33 34 35 36                                 <SSID>          
  * IEs - hexdump(len=0): [NULL]
  * Auth Type 0
nl80211: Authentication request send successfully
RSN: Ignored PMKID candidate without preauth flag
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: Event message available
nl80211: MLME event 37
nl80211: MLME event frame - hexdump(len=41): b0 00 3a 01 00 1b 77 f1 7c 29 00 1b 9e d8 77 02 00 1b 9e d8 77 02 40 1d 00 00 02 00 00 00 dd 09 00 10 18 02 01 f0 00 00 00
SME: Authentication response: peer=<BSSID> auth_type=0 status_code=0
SME: Authentication response IEs - hexdump(len=11): dd 09 00 10 18 02 01 f0 00 00 00
Trying to associate with <BSSID> (SSID='<SSID>' freq=2412 MHz)
State: AUTHENTICATING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
nl80211: Operstate: linkmode=-1, operstate=5
nl80211: Associate (ifindex=5)
  * bssid=<BSSID>
  * freq=2412
  * SSID - hexdump_ascii(len=6):
     31 32 33 34 35 36                                 <SSID>          
  * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Association request send successfully
nl80211: Event message available
nl80211: MLME event 38
nl80211: MLME event frame - hexdump(len=83): 10 00 3a 01 00 1b 77 f1 7c 29 00 1b 9e d8 77 02 00 1b 9e d8 77 02 50 1d 11 04 00 00 02 c0 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 dd 09 00 10 18 02 01 f0 00 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
Association info event
resp_ies - hexdump(len=53): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 dd 09 00 10 18 02 01 f0 00 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
nl80211: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=<BSSID>
No keys have been configured - skip key clearing
Associated with <BSSID>
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RX EAPOL from <BSSID>
RX EAPOL - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 11 9d cd cc d2 b9 eb 29 ea c0 da 67 a1 7d ab 13 79 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 df d4 f3 46 61 e6 31 96 a0 f2 46 5f 59 18 f4 8d
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=117
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=22
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 11
  key_nonce - hexdump(len=32): 9d cd cc d2 b9 eb 29 ea c0 da 67 a1 7d ab 13 79 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d3
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 11 9d cd cc d2 b9 eb 29 ea c0 da 67 a1 7d ab 13 79 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 df d4 f3 46 61 e6 31 96 a0 f2 46 5f 59 18 f4 8d
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from <BSSID> (ver=2)
RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 df d4 f3 46 61 e6 31 96 a0 f2 46 5f 59 18 f4 8d
RSN: PMKID from Authenticator - hexdump(len=16): df d4 f3 46 61 e6 31 96 a0 f2 46 5f 59 18 f4 8d
RSN: no matching PMKID found
WPA: Renewed SNonce - hexdump(len=32): 72 df d1 36 e0 74 e3 19 c3 06 bf 6f 43 6e 58 f9 60 7c d6 bc 6b 71 17 12 1c ae 47 12 11 4f 00 bf
WPA: PTK derivation - A1=00:1b:77:f1:7c:29 A2=<BSSID>
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 11 72 df d1 36 e0 74 e3 19 c3 06 bf 6f 43 6e 58 f9 60 7c d6 bc 6b 71 17 12 1c ae 47 12 11 4f 00 bf 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 45 a5 28 88 2d a0 ff 00 ce 3a 48 00 6b 6b fc de 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from <BSSID>
RX EAPOL - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 12 9d cd cc d2 b9 eb 29 ea c0 da 67 a1 7d ab 13 79 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 df d4 f3 46 61 e6 31 96 a0 f2 46 5f 59 18 f4 8d
IEEE 802.1X RX: version=2 type=3 length=117
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=22
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 12
  key_nonce - hexdump(len=32): 9d cd cc d2 b9 eb 29 ea c0 da 67 a1 7d ab 13 79 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d3
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 12 9d cd cc d2 b9 eb 29 ea c0 da 67 a1 7d ab 13 79 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 df d4 f3 46 61 e6 31 96 a0 f2 46 5f 59 18 f4 8d
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from <BSSID> (ver=2)
RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 df d4 f3 46 61 e6 31 96 a0 f2 46 5f 59 18 f4 8d
RSN: PMKID from Authenticator - hexdump(len=16): df d4 f3 46 61 e6 31 96 a0 f2 46 5f 59 18 f4 8d
RSN: no matching PMKID found
WPA: PTK derivation - A1=00:1b:77:f1:7c:29 A2=<BSSID>
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 12 72 df d1 36 e0 74 e3 19 c3 06 bf 6f 43 6e 58 f9 60 7c d6 bc 6b 71 17 12 1c ae 47 12 11 4f 00 bf 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 6f d3 5c 1e ba 58 76 34 f1 21 8f 01 52 ca 70 c0 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from <BSSID>
RX EAPOL - hexdump(len=155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 00 00 13 9d cd cc d2 b9 eb 29 ea c0 da 67 a1 7d ab 13 79 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d3 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d4 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1a ef fb 38 19 68 f7 76 fd 5e e5 0b 1d a5 29 7b 00 38 7f 12 e3 d2 69 1b 60 31 a0 cf 8d 8c 3b 11 8f e4 9e 0f c8 6e 68 b9 e1 05 43 e3 39 fe d4 0f a3 da b3 09 59 bb 8f 38 b2 d3 d4 5e 1f e9 b8 b4 d1 2a e2 b3 3c 94 ee 27 d2 97
IEEE 802.1X RX: version=2 type=3 length=151
  EAPOL-Key type=2
  key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
  key_length=16 key_data_length=56
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 13
  key_nonce - hexdump(len=32): 9d cd cc d2 b9 eb 29 ea c0 da 67 a1 7d ab 13 79 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d3
  key_iv - hexdump(len=16): 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d4
  key_rsc - hexdump(len=8): 1f 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 1a ef fb 38 19 68 f7 76 fd 5e e5 0b 1d a5 29 7b
WPA: RX EAPOL-Key - hexdump(len=155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 00 00 13 9d cd cc d2 b9 eb 29 ea c0 da 67 a1 7d ab 13 79 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d3 07 46 27 ce 70 06 00 98 e9 d9 15 e4 a2 41 b2 d4 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1a ef fb 38 19 68 f7 76 fd 5e e5 0b 1d a5 29 7b 00 38 7f 12 e3 d2 69 1b 60 31 a0 cf 8d 8c 3b 11 8f e4 9e 0f c8 6e 68 b9 e1 05 43 e3 39 fe d4 0f a3 da b3 09 59 bb 8f 38 b2 d3 d4 5e 1f e9 b8 b4 d1 2a e2 b3 3c 94 ee 27 d2 97
RSN: encrypted key data - hexdump(len=56): 7f 12 e3 d2 69 1b 60 31 a0 cf 8d 8c 3b 11 8f e4 9e 0f c8 6e 68 b9 e1 05 43 e3 39 fe d4 0f a3 da b3 09 59 bb 8f 38 b2 d3 d4 5e 1f e9 b8 b4 d1 2a e2 b3 3c 94 ee 27 d2 97
WPA: decrypted EAPOL-Key key data - hexdump(len=48): [REMOVED]
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from <BSSID> (ver=2)
WPA: IE KeyData - hexdump(len=48): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 dd 16 00 0f ac 01 01 00 c5 27 25 bf 6e 60 1f 97 76 9e 6a 1b a4 76 73 6a dd 00
WPA: Sending EAPOL-Key 4/4
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 00 13 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a7 23 5f 5a ac 1f 73 28 6c 75 44 eb c4 f7 e7 93 00 00
WPA: Installing PTK to the driver.
nl_set_encr: ifindex=5 alg=3 addr=0x6a48b8 key_idx=0 set_tx=1 seq_len=6 key_len=16
   addr=<BSSID>
EAPOL: External notification - portValid=1
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RSN: received GTK in pairwise handshake - hexdump(len=18): [REMOVED]
WPA: Group Key - hexdump(len=16): [REMOVED]
WPA: Installing GTK to the driver (keyidx=1 tx=0 len=16).
WPA: RSC - hexdump(len=6): 1f 00 00 00 00 00
nl_set_encr: ifindex=5 alg=3 addr=0x451355 key_idx=1 set_tx=0 seq_len=6 key_len=16
WPA: Key negotiation completed with <BSSID> [PTK=CCMP GTK=CCMP]
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to <BSSID> completed (auth) [id=0 id_str=]
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
nl80211: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: Supplicant port status: Authorized
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
EAPOL: startWhen --> 0
EAPOL: disable timer tick
Setting scan request: 0 sec 0 usec
Scan SSID - hexdump_ascii(len=6):
     31 32 33 34 35 36                                 <SSID>          
Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (9 BSSes)
CTRL-EVENT-SCAN-RESULTS 
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: <BSSID> ssid='<SSID>' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
   selected based on RSN IE
   selected WPA AP <BSSID> ssid='<SSID>'
Already associated with the selected AP.
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
wpa_driver_nl80211_disassociate
nl_set_encr: ifindex=5 alg=0 addr=0x451355 key_idx=0 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67 Link has been severed)
nl_set_encr: ifindex=5 alg=0 addr=0x451355 key_idx=1 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67 Link has been severed)
nl_set_encr: ifindex=5 alg=0 addr=0x451355 key_idx=2 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67 Link has been severed)
nl_set_encr: ifindex=5 alg=0 addr=0x451355 key_idx=3 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67 Link has been severed)
nl_set_encr: ifindex=5 alg=0 addr=0x6a2dd8 key_idx=0 set_tx=0 seq_len=0 key_len=0
   addr=<BSSID>
nl80211: set_key failed; err=-67 Link has been severed)
State: COMPLETED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
nl80211: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
nl80211: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
key_mgmt: 0x2
scan_ssid=1 (0x1)
PSK (ASCII passphrase) - hexdump_ascii(len=15): [REMOVED]
ssid - hexdump_ascii(len=6):
     31 32 33 34 35 36                                 <SSID>          
PSK (from passphrase) - hexdump(len=32): [REMOVED]
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Scan SSID - hexdump_ascii(len=6):
     31 32 33 34 35 36                                 <SSID>          
Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Setting scan request: 0 sec 0 usec
Scan SSID - hexdump_ascii(len=6):
     31 32 33 34 35 36                                 <SSID>          
Starting AP scan for wildcard SSID
nl80211: Scan trigger failed: ret=-16 (Device or resource busy)
Failed to initiate AP scan.
Setting scan request: 10 sec 0 usec
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
nl80211: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
nl80211: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
No keys have been configured - skip key clearing
State: DISCONNECTED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
nl80211: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
Scan timeout - try to get results
Received scan results (1 BSSes)
CTRL-EVENT-SCAN-RESULTS 
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
nl80211: Scan trigger failed: ret=-16 (Device or resource busy)
Failed to initiate AP scan.
Setting scan request: 10 sec 0 usec
Setting scan request: 0 sec 0 usec
Starting AP scan for wildcard SSID
nl80211: Scan trigger failed: ret=-16 (Device or resource busy)
Failed to initiate AP scan.
Setting scan request: 10 sec 0 usec
Setting scan request: 0 sec 0 usec
Starting AP scan for wildcard SSID
nl80211: Scan trigger failed: ret=-16 (Device or resource busy)
Failed to initiate AP scan.
Setting scan request: 10 sec 0 usec
Setting scan request: 0 sec 0 usec
Starting AP scan for wildcard SSID
nl80211: Scan trigger failed: ret=-16 (Device or resource busy)
Failed to initiate AP scan.
Setting scan request: 10 sec 0 usec




