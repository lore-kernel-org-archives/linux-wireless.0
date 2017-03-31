Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:34429 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754132AbdCaSpY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 14:45:24 -0400
Received: by mail-vk0-f41.google.com with SMTP id z204so101361924vkd.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Mar 2017 11:45:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJeuY7-SGOERd5Rtu-X3Bzb+MQ9aiFnn75n+pZAEf0NwxCk66Q@mail.gmail.com>
References: <CAJeuY7-SGOERd5Rtu-X3Bzb+MQ9aiFnn75n+pZAEf0NwxCk66Q@mail.gmail.com>
From: Hao Zhang <hao5781286@gmail.com>
Date: Sat, 1 Apr 2017 02:45:22 +0800
Message-ID: <CAJeuY78LEJztzvicQ5HofsZVuEbo9WS6TVW+GB6wO2+z7L7uBA@mail.gmail.com> (sfid-20170331_204541_554077_3ACAA1B4)
Subject: Fwd: Have been tested with 4 usb wifi adaptor, all loss packet when
 ping to router
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---------- Forwarded message ----------
From: Hao Zhang <hao5781286@gmail.com>
Date: 2017-04-01 2:14 GMT+08:00
Subject: Have been tested with 4 usb wifi adaptor, all loss packet
when ping to router
To: kernelnewbies@kernelnewbies.org


hi all,
i use usb wifi dongle rt5370/rt3070/rtl8192cus/rtl8178 on embeded
board based kernel 3.10.0 , they all loss packet when ping to router,
and then ifconfig can show below that
it seem some packet were been dropped, What does that dropped means?
is it mean the receive buffer is too small to receive packet=EF=BC=9F how c=
an
i trace it and fix it?

some info from ifconfig
(sometime it loss packet when ping to router, but that count of
dropped didnt increase and
sometime i do nothing to it , but it will increase automatic.)

# ifconfig
wlan0     Link encap:Ethernet  HWaddr 00:19:86:41:1A:54
          inet addr:10.0.0.110  Bcast:10.255.255.255  Mask:255.0.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:235 errors:0 dropped:4 overruns:0 frame:0
          TX packets:86 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:63770 (62.2 KiB)  TX bytes:9976 (9.7 KiB)




some info from dmesg:

cfg80211: Calling CRDA to update world regulatory domain
usb 1-2: reset high-speed USB device number 3 using hiusb-ehci
ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 5390, rev 0502 detected
ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 5370 detected
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
usbcore: registered new interface driver rt2800usb
ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading firmware
file 'rt2870.bin'
ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware detected -
version: 0.22
wlan0: authenticate with 20:76:93:37:60:04
wlan0: send auth to 20:76:93:37:60:04 (try 1/3)
wlan0: authenticated
wlan0: associate with 20:76:93:37:60:04 (try 1/3)
wlan0: RX AssocResp from 20:76:93:37:60:04 (capab=3D0x411 status=3D0 aid=3D=
1)
wlan0: associated


when connect to router:

/home/wifi-tool/ap_client_tool #
/home/wifi-tool/ap_client_tool # ./wpa_supplicant -d -Dwext -i wlan0 -c ./w=
pa_su
pplicant.conf -t -d ./log.txt &
/home/wifi-tool/ap_client_tool # 133.647693: wpa_supplicant
v0.8.x_rtw_r7475.20130812_beta
133.650368: random: Trying to read entropy from /dev/random
133.650447: Initializing interface 'wlan0' conf
'./wpa_supplicant.conf' driver 'wext' ctrl_interface 'N/A' bri'
133.650527: Configuration file './wpa_supplicant.conf' ->
'/home/wifi-tool/ap_client_tool/./wpa_supplicant.con'
133.650565: Reading configuration file
'/home/wifi-tool/ap_client_tool/./wpa_supplicant.conf'
133.651341: ctrl_interface=3D'/var/run/wpa_supplicant'
133.651394: Line: 3 - start of a new network block
133.651455: ssid - hexdump_ascii(len=3D8):
     44 72 65 61 6d 62 6f 78                           Dreambox
133.651532: PSK (ASCII passphrase) - hexdump_ascii(len=3D10): [REMOVED]
133.783164: PSK (from passphrase) - hexdump(len=3D32): [REMOVED]
133.783275: Priority group 0
133.783299:    id=3D0 ssid=3D'Dreambox'
133.783490: WEXT: cfg80211-based driver detected
133.783636: wext: interface wlan0 phy: phy0
133.783783: rfkill: Cannot open RFKILL control device
133.783828: WEXT: RFKILL status not available
133.783985: SIOCGIWRANGE: WE(compiled)=3D22 WE(source)=3D21 enc_capa=3D0xf
133.784027:   capabilities: key_mgmt 0xf enc 0xf flags 0x0
133.793058: netlink: Operstate: linkmode=3D1, operstate=3D5
133.793300: wlan0: Own MAC address: 00:19:86:41:1a:54
133.793343: wpa_driver_wext_set_key: alg=3D0 key_idx=3D0 set_tx=3D0
seq_len=3D0 key_len=3D0
133.793402: wpa_driver_wext_set_key: alg=3D0 key_idx=3D1 set_tx=3D0
seq_len=3D0 key_len=3D0
133.793443: wpa_driver_wext_set_key: alg=3D0 key_idx=3D2 set_tx=3D0
seq_len=3D0 key_len=3D0
133.793480: wpa_driver_wext_set_key: alg=3D0 key_idx=3D3 set_tx=3D0
seq_len=3D0 key_len=3D0
133.793517: wpa_driver_wext_set_countermeasures
133.793561: wlan0: RSN: flushing PMKID list in the driver
133.793621: wlan0: Setting scan request: 0 sec 100000 usec
133.793666: WPS: Set UUID for interface wlan0
133.793713: WPS: UUID based on MAC address - hexdump(len=3D16): 7f 85 0b
16 18 c7 58 66 97 b9 4e 08 a0 0f b9 e2
133.793829: EAPOL: SUPP_PAE entering state DISCONNECTED
133.793863: EAPOL: Supplicant port status: Unauthorized
133.793888: EAPOL: KEY_RX entering state NO_KEY_RECEIVE
133.793903: EAPOL: SUPP_BE entering state INITIALIZE
133.793924: EAP: EAP entering state DISABLED
133.793952: EAPOL: Supplicant port status: Unauthorized
133.793973: EAPOL: Supplicant port status: Unauthorized
133.795262: wlan0: Added interface wlan0
133.795439: random: Got 20/20 bytes from /dev/random
133.795532: RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
133.795574: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
133.795641: wlan0: Event 5 received on interface wlan0
133.795669: Wireless event: cmd=3D0x8b06 len=3D8
133.795698: RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
133.795728: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
133.795760: wlan0: Event 5 received on interface wlan0
133.795780: Wireless event: cmd=3D0x8b1a len=3D8
133.900079: wlan0: State: DISCONNECTED -> SCANNING
133.900128: wlan0: Starting AP scan for wildcard SSID
133.900273: Scan requested (ret=3D0) - scan timeout 5 seconds
134.800042: EAPOL: disable timer tick
134.800113: EAPOL: Supplicant port status: Unauthorized
135.170113: RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
135.170211: RTM_NEwlan0: authenticate with 20:76:93:37:60:04
WLINK, IFLA_IFNAME: Interface 'wlan0' added
135.170255: wlan0: Event 5 received on interface wlan0
135.170280: Wireless event: cmd=3D0x8b19 len=3D8
135.170312: wlan0: Event 3 received on interface wlan0
135.170478: Scan results did not fit - trying larger buffer (8192 bytes)
135.170845: Received 7179 bytes of scan results (15 BSSes)
135.170969: wlan0: BSS: Start scan result update 1
135.171027: wlan0: BSS: Add new id 0 BSSID 20:76:93:37:60:04 SSID 'Dreambox=
'
135.171099: wlan0: BSS: Add new id 1 BSSID 14:b8:37:25:cb:5b SSID
'ChinaNet-hd4r'
135.171164: wlan0: BSS: Add new id 2 BSSID fc:37:2b:50:9a:41 SSID
'ChinaNet-y7cf'
135.171227: wlan0: BSS: Add new id 3 BSSID c8:3wlan0: send auth to
20:76:93:37:60:04 (try 1/3)
a:35:4b:db:b0 SSID 'Tenda_4BDBB0'
135.171289: wlan0: BSS: Add new id 4 BSSID 40:f4:20:ewlan0: authenticated
1:26:3a SSID 'ChinaNet-yH4T'
135.171353: wlan0: BSS: Add new id 5 BSSID d8:15:0d:68:ed:ba SSID '703'
135.17141wlan0: associate with 20:76:93:37:60:04 (try 1/3)
7: wlan0: BSS: Add new id 6 BSSID 1c:60:de:d6:58:60 SSID ''
135.171479: wlan0: BSS: Add new id 7 BSSID wlan0: RX AssocResp from
20:76:93:37:60:04 (capab=3D0x411 status=3D0 ai)
5c:63:bf:d0:90:9c SSID 'TP-LINK_707'
135.171551: wlan0: BSS: Add new id 8 BSSID 8c:f2:28:52:94:1c SSID
'SZBKT2'wlan0: associated

135.171616: wlan0: BSS: Add new id 9 BSSID c8:3a:35:3c:0b:78 SSID 'Tenda_3C=
0B78'
135.171679: wlan0: BSS: Add new id 10 BSSID 38:83:45:94:8d:a0 SSID 'hzb'
135.171742: wlan0: BSS: Add new id 11 BSSID 00:bd:82:56:32:d2 SSID
'ChinaNet-jVKG'
135.171805: wlan0: BSS: Add new id 12 BSSID 8c:f2:28:62:d8:74 SSID
'MERCURY_D874'
135.171868: wlan0: BSS: Add new id 13 BSSID 1c:60:de:bb:e0:f0 SSID '503'
135.171930: wlan0: BSS: Add new id 14 BSSID ec:26:ca:4c:80:00 SSID 'lyy'
135.171980: Add randomness: count=3D1 entropy=3D0
135.172012: Add randomness: count=3D2 entropy=3D1
135.172031: Add randomness: count=3D3 entropy=3D2
135.172050: Add randomness: count=3D4 entropy=3D3
135.172069: Add randomness: count=3D5 entropy=3D4
135.172088: Add randomness: count=3D6 entropy=3D5
135.172106: Add randomness: count=3D7 entropy=3D6
135.172125: Add randomness: count=3D8 entropy=3D7
135.172144: Add randomness: count=3D9 entropy=3D8
135.172162: Add randomness: count=3D10 entropy=3D9
135.172195: wlan0: New scan results available
135.172302: wlan0: Selecting BSS from priority group 0
135.172363: wlan0: 0: 20:76:93:37:60:04 ssid=3D'Dreambox' wpa_ie_len=3D22
rsn_ie_len=3D20 caps=3D0x11 level=3D-45
135.172406: wlan0:    selected based on RSN IE
135.172453: wlan0:    selected BSS 20:76:93:37:60:04 ssid=3D'Dreambox'
135.172533: wlan0: Request association: reassociate: 0  selected:
20:76:93:37:60:04  bssid: 00:00:00:00:00:00 G
135.172582: wlan0: Trying to associate with 20:76:93:37:60:04
(SSID=3D'Dreambox' freq=3D2412 MHz)
135.172607: wlan0: Cancelling scan request
135.172631: wlan0: WPA: clearing own WPA/RSN IE
135.172655: wlan0: Automatic auth_alg selection: 0x1
135.172694: wlan0: RSN: using IEEE 802.11i/D9.0
135.172731: wlan0: WPA: Selected cipher suites: group 16 pairwise 16
key_mgmt 2 proto 2
135.172751: WPA: set AP WPA IE - hexdump(len=3D24): dd 16 00 50 f2 01 01
00 00 50 f2 04 01 00 00 50 f2 04 01 00 2
135.172844: WPA: set AP RSN IE - hexdump(len=3D22): 30 14 01 00 00 0f ac
04 01 00 00 0f ac 04 01 00 00 0f ac 02 0
135.172944: wlan0: WPA: using GTK CCMP
135.172966: wlan0: WPA: using PTK CCMP
135.172989: wlan0: WPA: using KEY_MGMT WPA-PSK
135.173010: WPA: Set own WPA IE default - hexdump(len=3D22): 30 14 01 00
00 0f ac 04 01 00 00 0f ac 04 01 00 00 0
135.173102: wlan0: No keys have been configured - skip key clearing
135.173130: wlan0: State: SCANNING -> ASSOCIATING
135.173149: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
135.173174: netlink: Operstate: linkmode=3D-1, operstate=3D5
135.173227: wpa_driver_wext_associate
135.173341: wpa_driver_wext_set_drop_unencrypted
135.173443: wpa_driver_wext_set_psk
ioctl[SIOCSIWFREQ]: Device or resource busy
135.244635: wlan0: Association request to the driver failed
135.244695: wlan0: Setting authentication timeout: 5 sec 0 usec
135.244725: EAPOL: External notification - EAP success=3D0
135.244747: EAPOL: Supplicant port status: Unauthorized
135.244769: EAPOL: External notification - EAP fail=3D0
135.244787: EAPOL: Supplicant port status: Unauthorized
135.244804: EAPOL: External notification - portControl=3DAuto
135.244822: EAPOL: Supplicant port status: Unauthorized
135.244851: wlan0: Checking for other virtual interfaces sharing same
radio (phy0) in event_scan_results
135.244899: RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
135.244933: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
135.244966: wlan0: Event 5 received on interface wlan0
135.244987: Wireless event: cmd=3D0x8b1a len=3D8
135.245010: RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
135.245038: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
135.245070: wlan0: Event 5 received on interface wlan0
135.245089: Wireless event: cmd=3D0x8b06 len=3D8
135.592544: RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
135.592605: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
135.592649: wlan0: Event 5 received on interface wlan0
135.592673: Wireless event: cmd=3D0x8b1a len=3D16
135.592701: RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])
135.592731: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
135.592763: wlan0: Event 5 received on interface wlan0
135.592787: RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])
135.592817: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
135.592848: wlan0: Event 5 received on interface wlan0
135.592867: Wireless event: cmd=3D0x8c08 len=3D187
135.592885: AssocResp IE wireless event - hexdump(len=3D179): 01 08 82
84 8b 96 12 24 48 6c 32 04 0c 18 30 60 dd0
135.593447: RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])
135.593479: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
135.593511: wlan0: Event 5 received on interface wlan0
135.593530: Wireless event: cmd=3D0x8b15 len=3D20
135.593548: Wireless event: new AP: 20:76:93:37:60:04
135.593588: wlan0: Event 4 received on interface wlan0
135.593611: wlan0: Association info event
135.593629: resp_ies - hexdump(len=3D179): 01 08 82 84 8b 96 12 24 48 6c
32 04 0c 18 30 60 dd 18 00 50 f2 02 01 0
135.594195: wlan0: Event 0 received on interface wlan0
135.594223: wlan0: State: ASSOCIATING -> ASSOCIATED
135.594242: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
135.594268: netlink: Operstate: linkmode=3D-1, operstate=3D5
135.594349: wlan0: Associated to a new BSS: BSSID=3D20:76:93:37:60:04
135.594373: Add randomness: count=3D11 entropy=3D10
135.594403: wlan0: No keys have been configured - skip key clearing
135.594443: wlan0: Associated with 20:76:93:37:60:04
135.594468: wlan0: WPA: Association event - clear replay counter
135.594491: wlan0: WPA: Clear old PTK
135.594510: EAPOL: External notification - portEnabled=3D0
135.594529: EAPOL: Supplicant port status: Unauthorized
135.594551: EAPOL: External notification - portValid=3D0
135.594568: EAPOL: Supplicant port status: Unauthorized
135.594594: EAPOL: External notification - EAP success=3D0
135.594611: EAPOL: Supplicant port status: Unauthorized
135.594628: EAPOL: External notification - portEnabled=3D1
135.594644: EAPOL: SUPP_PAE entering state CONNECTING
135.594658: EAPOL: enable timer tick
135.594677: EAPOL: SUPP_BE entering state IDLE
135.594705: wlan0: Setting authentication timeout: 10 sec 0 usec
135.594732: wlan0: Cancelling scan request
135.594835: wlan0: RX EAPOL from 20:76:93:37:60:04
135.594861: RX EAPOL - hexdump(len=3D99): 01 03 00 5f 02 00 8a 00 10 00
00 00 00 00 00 00 01 2f be 0d 1c 3e 3a e0
135.927831: wlan0: Setting authentication timeout: 10 sec 0 usec
135.927917: wlan0: IEEE 802.1X RX: version=3D1 type=3D3 length=3D95
135.927954: wlan0:   EAPOL-Key type=3D2
135.928001: wlan0:   key_info 0x8a (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Ac=
k)
135.928029: wlan0:   key_length=3D16 key_data_length=3D0
135.928047:   replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 01
135.928091:   key_nonce - hexdump(len=3D32): 2f be 0d 1c 3e 3a e4 a1 85
c9 e6 e5 5d 03 4d 5a a2 c2 9c 35 75 9b 26
135.928201:   key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
135.928267:   key_rsc - hexdump(len=3D8): 00 00 00 00 00 00 00 00
135.928309:   key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00
135.928351:   key_mic - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
135.928423: WPA: RX EAPOL-Key - hexdump(len=3D99): 01 03 00 5f 02 00 8a
00 10 00 00 00 00 00 00 00 01 2f be 0d 10
135.928796: wlan0: State: ASSOCIATED -> 4WAY_HANDSHAKE
135.928845: wlan0: WPA: RX message 1 of 4-Way Handshake from
20:76:93:37:60:04 (ver=3D2)
135.928866: RSN: msg 1/4 key data - hexdump(len=3D0):
135.928886: Get randomness: len=3D32 entropy=3D11
135.929133: WPA: Renewed SNonce - hexdump(len=3D32): ca 30 c8 f1 9a 25
2f 64 dc d4 ac 69 c3 dc 5c c1 18 5c b4 e3c
135.929330: WPA: PTK derivation - A1=3D00:19:86:41:1a:54 A2=3D20:76:93:37:6=
0:04
135.929378: WPA: Nonce1 - hexdump(len=3D32): ca 30 c8 f1 9a 25 2f 64 dc
d4 ac 69 c3 dc 5c c1 18 5c b4 e3 b3 aa 5c
135.929490: WPA: Nonce2 - hexdump(len=3D32): 2f be 0d 1c 3e 3a e4 a1 85
c9 e6 e5 5d 03 4d 5a a2 c2 9c 35 75 9b 26
135.929600: WPA: PMK - hexdump(len=3D32): [REMOVED]
135.929619: WPA: PTK - hexdump(len=3D48): [REMOVED]
135.929638: WPA: WPA IE for msg 2/4 - hexdump(len=3D22): 30 14 01 00 00
0f ac 04 01 00 00 0f ac 04 01 00 00 0f a0
135.929726: WPA: Replay Counter - hexdump(len=3D8): 00 00 00 00 00 00 00 01
135.929777: wlan0: WPA: Sending EAPOL-Key 2/4
135.929821: WPA: KCK - hexdump(len=3D16): [REMOVED]
135.929842: WPA: Derived Key MIC - hexdump(len=3D16): 12 33 63 9c 55 75
e6 42 8c 03 3d c2 6b 75 77 97
135.929914: WPA: TX EAPOL-Key - hexdump(len=3D121): 01 03 00 75 02 01 0a
00 00 00 00 00 00 00 00 00 01 ca 30 c8 0
136.050174: wlan0: RX EAPOL from 20:76:93:37:60:04
136.050216: RX EAPOL - hexdump(len=3D155): 01 03 00 97 02 13 ca 00 10 00
00 00 00 00 00 00 02 2f be 0d 1c 3e 3a 6
136.050861: wlan0: IEEE 802.1X RX: version=3D1 type=3D3 length=3D151
136.050928: wlan0:   EAPOL-Key type=3D2
136.050976: wlan0:   key_info 0x13ca (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise
Install Ack MIC Secure Encr)
136.051041: wlan0:   key_length=3D16 key_data_length=3D56
136.051062:   replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 02
136.051105:   key_nonce - hexdump(len=3D32): 2f be 0d 1c 3e 3a e4 a1 85
c9 e6 e5 5d 03 4d 5a a2 c2 9c 35 75 9b 26
136.051276:   key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
136.051354:   key_rsc - hexdump(len=3D8): 1e 06 00 00 00 00 00 00
136.051426:   key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00
136.051470:   key_mic - hexdump(len=3D16): fe 44 dc 7c 79 6a 75 ac d8 ab
eb 37 0c 43 bd 92
136.051575: WPA: RX EAPOL-Key - hexdump(len=3D155): 01 03 00 97 02 13 ca
00 10 00 00 00 00 00 00 00 02 2f be 0d 6
136.052227: RSN: encrypted key data - hexdump(len=3D56): 75 ae 6b ee 05
75 84 e4 60 f1 b0 19 d2 15 0c da ed aa 66
136.052661: WPA: decrypted EAPOL-Key key data - hexdump(len=3D48): [REMOVED=
]
136.052713: wlan0: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
136.052799: wlan0: WPA: RX message 3 of 4-Way Handshake from
20:76:93:37:60:04 (ver=3D2)
136.052823: WPA: IE KeyData - hexdump(len=3D48): 30 14 01 00 00 0f ac 04
01 00 00 0f ac 04 01 00 00 0f ac 02 00 0
136.385952: WPA: RSN IE in EAPOL-Key - hexdump(len=3D22): 30 14 01 00 00
0f ac 04 01 00 00 0f ac 04 01 00 00 0f 0
136.386064: WPA: GTK in EAPOL-Key - hexdump(len=3D24): [REMOVED]
136.386105: wlan0: WPA: Sending EAPOL-Key 4/4
136.386161: WPA: KCK - hexdump(len=3D16): [REMOVED]
136.386185: WPA: Derived Key MIC - hexdump(len=3D16): c8 01 93 34 66 d9
4e 6f 64 20 ad fc b2 11 39 81
136.386251: WPA: TX EAPOL-Key - hexdump(len=3D99): 01 03 00 5f 02 03 0a
00 00 00 00 00 00 00 00 00 02 00 00 00 00
136.386690: wlan0: WPA: Installing PTK to the driver
136.386724: wpa_driver_wext_set_key: alg=3D3 key_idx=3D0 set_tx=3D1
seq_len=3D6 key_len=3D16
136.389764: EAPOL: External notification - portValid=3D1
136.389823: wlan0: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
136.389846: RSN: received GTK in pairwise handshake - hexdump(len=3D18): [R=
EMOVED]
136.389870: WPA: Group Key - hexdump(len=3D16): [REMOVED]
136.389902: wlan0: WPA: Installing GTK to the driver (keyidx=3D1 tx=3D0 len=
=3D16)
136.389921: WPA: RSC - hexdump(len=3D6): 1e 06 00 00 00 00
136.389958: wpa_driver_wext_set_key: alg=3D3 key_idx=3D1 set_tx=3D0
seq_len=3D6 key_len=3D16
136.391302: wlan0: WPA: Key negotiation completed with
20:76:93:37:60:04 [PTK=3DCCMP GTK=3DCCMP]
136.391345: wlan0: Cancelling authentication timeout
136.391377: wlan0: State: GROUP_HANDSHAKE -> COMPLETED
136.391422: wlan0: CTRL-EVENT-CONNECTED - Connection to
20:76:93:37:60:04 completed (auth) [id=3D0 id_str=3D]
136.391445: wpa_driver_wext_set_operstate: operstate 0->1 (UP)
136.391470: netlink: Operstate: linkmode=3D-1, operstate=3D6
136.391560: EAPOL: External notification - portValid=3D1
136.391591: EAPOL: External notification - EAP success=3D1
136.391611: EAPOL: SUPP_PAE entering state AUTHENTICATING
136.391626: EAPOL: SUPP_BE entering state SUCCESS
136.391641: EAP: EAP entering state DISABLED
136.391655: EAPOL: SUPP_PAE entering state AUTHENTICATED
136.391670: EAPOL: Supplicant port status: Authorized
136.391687: EAPOL: SUPP_BE entering state IDLE
136.391703: EAPOL authentication completed successfully
136.391769: RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][L=
OWER_UP])
136.391806: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
136.391843: wlan0: Event 5 received on interface wlan0
136.600042: EAPOL: startWhen --> 0
136.600091: EAPOL: disable timer tick
324.170085: wlan0: BSS: Expire BSS 1 due to age
324.170174: wlan0: BSS: Remove id 1 BSSID 14:b8:37:25:cb:5b SSID
'wwwwwwwwww-hd4r'
324.170224: wlan0: BSS: Expire BSS 2 due to age
324.170266: wlan0: BSS: Remove id 2 BSSID fc:37:2b:50:9a:41 SSID
'wwwwwwwww-y7cf'
324.170311: wlan0: BSS: Expire BSS 3 due to age
324.170351: wlan0: BSS: Remove id 3 BSSID c8:3a:35:4b:db:b0 SSID 'xxxxxxx'
324.170395: wlan0: BSS: Expire BSS 4 due to age
324.170435: wlan0: BSS: Remove id 4 BSSID 40:f4:20:e1:26:3a SSID 'xxxxxxxx-=
yH4T'
324.170478: wlan0: BSS: Expire BSS 5 due to age
324.170518: wlan0: BSS: Remove id 5 BSSID d8:15:0d:68:ed:ba SSID 'xxxxxxxxx=
x'
324.170562: wlan0: BSS: Expire BSS 6 due to age
324.170602: wlan0: BSS: Remove id 6 BSSID 1c:60:de:d6:58:60 SSID 'xxxx'
324.170645: wlan0: BSS: Expire BSS 7 due to age
324.170685: wlan0: BSS: Remove id 7 BSSID 5c:63:bf:d0:90:9c SSID
'xxxxxxxx-xxxxx'
324.170736: wlan0: BSS: Expire BSS 8 due to age
324.170777: wlan0: BSS: Remove id 8 BSSID 8c:f2:28:52:94:1c SSID 'xxxxxxxxx=
'
324.170821: wlan0: BSS: Expire BSS 9 due to age
324.170862: wlan0: BSS: Remove id 9 BSSID c8:3a:35:3c:0b:78 SSID 'xxxxxxxxx=
x'
324.170905: wlan0: BSS: Expire BSS 10 due to age
324.170945: wlan0: BSS: Remove id 10 BSSID 38:83:45:94:8d:a0 SSID 'xxxxxxxx=
xxxx'
324.170989: wlan0: BSS: Expire BSS 11 due to age
324.171029: wlan0: BSS: Remove id 11 BSSID 00:bd:82:56:32:d2 SSID
'xxxxxxxxx-jVKG'
324.171074: wlan0: BSS: Expire BSS 12 due to age
324.171114: wlan0: BSS: Remove id 12 BSSID 8c:f2:28:62:d8:74 SSID 'xxxxxxxx=
'
324.171158: wlan0: BSS: Expire BSS 13 due to age
324.171198: wlan0: BSS: Remove id 13 BSSID 1c:60:de:bb:e0:f0 SSID 'xxxxxxxx=
xx'
324.171242: wlan0: BSS: Expire BSS 14 due to age
324.171282: wlan0: BSS: Remove id 14 BSSID ec:26:ca:4c:80:00 SSID 'lyy'





Regards :)
