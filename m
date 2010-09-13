Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59791 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab0IMWiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 18:38:14 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o8DMcEII005481
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 15:38:14 -0700
Message-ID: <4C8EA7D6.4040101@candelatech.com>
Date: Mon, 13 Sep 2010 15:38:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k, virtual stations, and WPA:  No luck so far.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm having no luck getting WPA to work with two STA interfaces
on the same ath9k NIC.

So far, I've done a bunch of hacking to only scan on the one
channel that we're currently using if 1+ stations are associated,
and some other logic to not call change-channel logic unnecessarily.

Currently, I see wlan0 able to associate and authenticate with wpa_supplicant,
but sta1 (the other STA interface), won't work.  A snippet from it's supplicant
log is below.  No-encryption and WEP seems to work fine.
If anyone has any suggestions as to where I should look to debug this,
I'd welcome the pointers!

I'll work on cleaning up the scan patch for review as well.

Thanks,
Ben


1284416669.889587: Authentication with 00:14:d1:c6:d2:54 timed out.
1284416669.889662: BSSID 00:14:d1:c6:d2:54 blacklist count incremented to 2
1284416669.889703: wpa_driver_wext_disassociate
1284416669.898212: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
1284416669.898277: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
1284416669.898323: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
1284416669.898391: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
1284416669.898438: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
1284416669.898484: State: GROUP_HANDSHAKE -> DISCONNECTED
1284416669.898521: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
1284416669.898559: WEXT: Operstate: linkmode=-1, operstate=5
1284416669.898613: EAPOL: External notification - portEnabled=0
1284416669.898650: EAPOL: SUPP_PAE entering state DISCONNECTED
1284416669.898686: EAPOL: SUPP_BE entering state INITIALIZE
1284416669.898722: EAPOL: External notification - portValid=0
1284416669.898759: EAPOL: External notification - EAP success=0
1284416669.898800: Setting scan request: 0 sec 0 usec
1284416669.898852: State: DISCONNECTED -> SCANNING
1284416669.898888: Starting AP scan (broadcast SSID)
1284416669.899035: Scan requested (ret=-1) - scan timeout 30 seconds
1284416669.899085: Failed to initiate AP scan.
1284416669.899123: Setting scan request: 10 sec 0 usec
1284416669.906146: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1284416669.906200: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1284416669.906980: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1284416669.907045: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1284416669.907084: Wireless event: cmd=0x8b15 len=20
1284416669.907121: Wireless event: new AP: 00:00:00:00:00:00
1284416669.907160: BSSID 00:00:00:00:00:00 blacklist count incremented to 2
1284416669.907203: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
1284416669.907242: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
1284416669.907299: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
1284416669.907348: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
1284416669.907395: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
1284416669.907443: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
1284416669.907489: State: SCANNING -> DISCONNECTED
1284416669.907528: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
1284416669.907566: WEXT: Operstate: linkmode=-1, operstate=5
1284416669.907622: EAPOL: External notification - portEnabled=0
1284416669.907662: EAPOL: External notification - portValid=0
1284416669.907699: EAPOL: External notification - EAP success=0
1284416669.907746: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1284416669.907784: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1284416669.907822: Wireless event: cmd=0x8b1a len=40
1284416669.988293: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1284416669.988344: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1284416669.988383: Wireless event: cmd=0x8b19 len=8
1284416669.988613: Received 610 bytes of scan results (1 BSSes)
1284416669.988658: CTRL-EVENT-SCAN-RESULTS
1284416669.988717: wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
1284416669.988755: Selecting BSS from priority group 0
1284416669.988791: Try to find WPA-enabled AP
1284416669.988828: 0: 00:14:d1:c6:d2:54 ssid='candela-n' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
1284416669.988868:    skip - blacklisted
1284416669.988904: Try to find non-WPA AP
1284416669.988967: 0: 00:14:d1:c6:d2:54 ssid='candela-n' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
1284416669.989007:    skip - blacklisted
1284416669.989044: No APs found - clear blacklist and try again
1284416669.989081: Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
1284416669.989119: Removed BSSID 00:14:d1:c6:d2:54 from blacklist (clear)
1284416669.989158: Selecting BSS from priority group 0
1284416669.989195: Try to find WPA-enabled AP
1284416669.989231: 0: 00:14:d1:c6:d2:54 ssid='candela-n' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
1284416669.989343:    selected based on WPA IE
1284416669.989380:    selected WPA AP 00:14:d1:c6:d2:54 ssid='candela-n'
1284416669.989423: Trying to associate with 00:14:d1:c6:d2:54 (SSID='candela-n' freq=2437 MHz)
1284416669.989461: Cancelling scan request
1284416669.989499: WPA: clearing own WPA/RSN IE
1284416669.989598: Automatic auth_alg selection: 0x1
1284416669.989652: WPA: using IEEE 802.11i/D3.0
1284416669.989690: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 1
1284416669.989729: WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 02 00 50 f2 04 01 00 00 50 f2 02
1284416669.989781: WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 02 00 0f ac 04 01 00 00 0f ac 02 00 00
1284416669.989829: WPA: using GTK TKIP
1284416669.989869: WPA: using PTK CCMP
1284416669.989909: WPA: using KEY_MGMT WPA-PSK
1284416669.989968: WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
1284416669.990027: No keys have been configured - skip key clearing
1284416669.990065: wpa_driver_wext_set_drop_unencrypted
1284416669.990107: State: DISCONNECTED -> ASSOCIATING
1284416669.990146: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
1284416669.990185: WEXT: Operstate: linkmode=-1, operstate=5
1284416669.990239: wpa_driver_wext_associate
1284416669.990299: wpa_driver_wext_set_psk
1284416669.990493: Setting authentication timeout: 20 sec 0 usec
1284416669.990543: EAPOL: External notification - EAP success=0
1284416669.990583: EAPOL: External notification - EAP fail=0
1284416669.990620: EAPOL: External notification - portControl=Auto
1284416669.990957: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1284416669.991009: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1284416669.991046: Wireless event: cmd=0x8b06 len=8
1284416669.991133: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1284416669.991172: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1284416669.991209: Wireless event: cmd=0x8b04 len=12
1284416669.991488: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1284416669.991528: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1284416669.991566: Wireless event: cmd=0x8b1a len=17
1284416670.080206: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1284416670.080272: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1284416670.080316: Wireless event: cmd=0x8b19 len=8
1284416670.081492: Received 606 bytes of scan results (1 BSSes)
1284416670.081547: CTRL-EVENT-SCAN-RESULTS
1284416670.081628: wpa_supplicant_select_bss_and_associate: qual 0 (0)  qv=0  bv=0
1284416670.081673: Selecting BSS from priority group 0
1284416670.081728: Try to find WPA-enabled AP
1284416670.081768: 0: 00:14:d1:c6:d2:54 ssid='candela-n' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
1284416670.081812:    selected based on WPA IE
1284416670.081854:    selected WPA AP 00:14:d1:c6:d2:54 ssid='candela-n'
1284416670.081896: Already associated with the selected AP.
1284416670.092029: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1284416670.092094: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1284416670.092296: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1284416670.092344: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1284416670.092383: Wireless event: cmd=0x8c08 len=162
1284416670.092421: AssocResp IE wireless event - hexdump(len=154): 01 04 82 84 8b 96 32 08 0c 12 18 24 30 48 60 6c dd 1e 00 90 4c 33 4c 10 1f ff ff 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 06 00 05 00 00 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4c 10 1f ff ff 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 3d 16 06 00 01 00 00 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 18 00 50 f2 02 01 01 00 
00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
1284416670.092631: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1284416670.092670: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1284416670.092708: Wireless event: cmd=0x8b15 len=20
1284416670.092745: Wireless event: new AP: 00:14:d1:c6:d2:54
1284416670.092783: Association info event
1284416670.092819: resp_ies - hexdump(len=154): 01 04 82 84 8b 96 32 08 0c 12 18 24 30 48 60 6c dd 1e 00 90 4c 33 4c 10 1f ff ff 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 06 00 05 00 00 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4c 10 1f ff ff 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 04 00 00 00 00 00 00 3d 16 06 00 01 00 00 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 
a4 00 00 42 43 5e 00 62 32 2f 00
1284416670.092943: State: ASSOCIATING -> ASSOCIATED
1284416670.092986: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
1284416670.093024: WEXT: Operstate: linkmode=-1, operstate=5
1284416670.093429: Associated to a new BSS: BSSID=00:14:d1:c6:d2:54
1284416670.093482: No keys have been configured - skip key clearing
1284416670.093526: Associated with 00:14:d1:c6:d2:54
1284416670.093565: WPA: Association event - clear replay counter
1284416670.093605: WPA: Clear old PTK
1284416670.093643: EAPOL: External notification - portEnabled=0
1284416670.093684: EAPOL: External notification - portValid=0
1284416670.093723: EAPOL: External notification - EAP success=0
1284416670.093782: EAPOL: External notification - portEnabled=1
1284416670.093821: EAPOL: SUPP_PAE entering state CONNECTING
1284416670.093868: EAPOL: SUPP_BE entering state IDLE
1284416670.093908: Setting authentication timeout: 10 sec 0 usec
1284416670.093975: Cancelling scan request
1284416672.868452: EAPOL: startWhen --> 0
1284416672.868536: EAPOL: disable timer tick
1284416672.868578: EAPOL: SUPP_PAE entering state CONNECTING
1284416672.868615: EAPOL: enable timer tick
1284416672.868658: EAPOL: txStart
1284416672.868696: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
1284416673.087889: RX EAPOL from 00:14:d1:c6:d2:54
1284416673.087971: RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 02 11 a8 cd 54 ac 52 fd 77 cc af 20 af 20 56 b7 8e b5 88 df b4 b0 f8 
cf e0 a6 31 f2 cb 68 9d 98 86 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00
1284416673.088050: Setting authentication timeout: 10 sec 0 usec
1284416673.088095: IEEE 802.1X RX: version=1 type=3 length=95
1284416673.088152:   EAPOL-Key type=254
1284416673.088193:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
1284416673.088234:   key_length=16 key_data_length=0
1284416673.088273:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 02 11
1284416673.088316:   key_nonce - hexdump(len=32): a8 cd 54 ac 52 fd 77 cc af 20 af 20 56 b7 8e b5 88 df b4 b0 f8 cf e0 a6 31 f2 cb 68 9d 98 86 0a
1284416673.088363:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1284416673.088407:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
1284416673.088455:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1284416673.088497:   key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1284416673.088542: WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 02 11 a8 cd 54 ac 52 fd 77 cc af 20 af 20 56 b7 8e b5 88 df 
b4 b0 f8 cf e0 a6 31 f2 cb 68 9d 98 86 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00
1284416673.088635: State: ASSOCIATED -> 4WAY_HANDSHAKE
1284416673.088685: WPA: RX message 1 of 4-Way Handshake from 00:14:d1:c6:d2:54 (ver=2)
1284416673.090477: WPA: Renewed SNonce - hexdump(len=32): bb 1a aa 97 fd 92 e2 71 6f 96 5b b9 16 3b 8b e8 45 aa 08 4d 7b ea a4 70 12 ab d1 58 75 79 ac 92
1284416673.090553: WPA: PTK derivation - A1=00:15:69:84:23:0c A2=00:14:d1:c6:d2:54
1284416673.090598: WPA: PMK - hexdump(len=32): [REMOVED]
1284416673.090638: WPA: PTK - hexdump(len=64): [REMOVED]
1284416673.090682: WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
1284416673.090732: WPA: Sending EAPOL-Key 2/4
1284416673.090775: WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 0a 00 10 00 00 00 00 00 00 02 11 bb 1a aa 97 fd 92 e2 71 6f 96 5b b9 16 3b 8b e8 45 
aa 08 4d 7b ea a4 70 12 ab d1 58 75 79 ac 92 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9b d7 d5 9d b6 fd 
5c bc 93 a1 3f e3 ba f6 21 2c 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
1284416673.094868: RX EAPOL from 00:14:d1:c6:d2:54
1284416673.094938: RX EAPOL - hexdump(len=127): 01 03 00 7b fe 01 ca 00 10 00 00 00 00 00 00 02 12 a8 cd 54 ac 52 fd 77 cc af 20 af 20 56 b7 8e b5 88 df b4 b0 
f8 cf e0 a6 31 f2 cb 68 9d 98 86 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7e 20 44 ba 1d b9 1c e0 83 
a0 24 86 5e 1b f0 51 00 1c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 02 00 50 f2 04 01 00 00 50 f2 02
1284416673.095023: IEEE 802.1X RX: version=1 type=3 length=123
1284416673.095063:   EAPOL-Key type=254
1284416673.095102:   key_info 0x1ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC)
1284416673.095144:   key_length=16 key_data_length=28
1284416673.095182:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 02 12
1284416673.095223:   key_nonce - hexdump(len=32): a8 cd 54 ac 52 fd 77 cc af 20 af 20 56 b7 8e b5 88 df b4 b0 f8 cf e0 a6 31 f2 cb 68 9d 98 86 0a
1284416673.095270:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1284416673.095313:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
1284416673.095354:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1284416673.095395:   key_mic - hexdump(len=16): 7e 20 44 ba 1d b9 1c e0 83 a0 24 86 5e 1b f0 51
1284416673.095438: WPA: RX EAPOL-Key - hexdump(len=127): 01 03 00 7b fe 01 ca 00 10 00 00 00 00 00 00 02 12 a8 cd 54 ac 52 fd 77 cc af 20 af 20 56 b7 8e b5 88 
df b4 b0 f8 cf e0 a6 31 f2 cb 68 9d 98 86 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7e 20 44 ba 1d b9 
1c e0 83 a0 24 86 5e 1b f0 51 00 1c dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 02 00 50 f2 04 01 00 00 50 f2 02
1284416673.095522: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
1284416673.095562: WPA: RX message 3 of 4-Way Handshake from 00:14:d1:c6:d2:54 (ver=2)
1284416673.095619: WPA: IE KeyData - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 02 00 50 f2 04 01 00 00 50 f2 02
1284416673.095670: WPA: Sending EAPOL-Key 4/4
1284416673.095712: WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 01 0a 00 10 00 00 00 00 00 00 02 12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 49 2e c9 d0 c3 b0 85 
93 bb 93 cc f7 72 a0 dd 24 00 00
1284416673.095821: WPA: Installing PTK to the driver.
1284416673.095866: WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
1284416673.095906: wpa_driver_wext_set_key: alg=3 key_idx=0 set_tx=1 seq_len=6 key_len=16
1284416673.096161: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE


1284416683.088335: Authentication with 00:14:d1:c6:d2:54 timed out.
1284416683.088433: Added BSSID 00:14:d1:c6:d2:54 into blacklist
1284416683.088489: wpa_driver_wext_disassociate
1284416683.096215: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
1284416683.096295: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
1284416683.096351: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
1284416683.096406: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
1284416683.096460: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
1284416683.096516: State: GROUP_HANDSHAKE -> DISCONNECTED



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

