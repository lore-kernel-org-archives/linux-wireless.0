Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:42336 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3IVOUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 10:20:25 -0400
Received: by mail-ea0-f178.google.com with SMTP id a15so1198771eae.9
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 07:20:24 -0700 (PDT)
From: Detlev Casanova <detlev.casanova@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: NetworkManager not listing access points
Date: Sun, 22 Sep 2013 16:20:35 +0200
Message-ID: <3006906.Q9n0kfrGGo@naboo> (sfid-20130922_162030_281346_40A6CECC)
In-Reply-To: <1379796719.4699.0.camel@jlt4.sipsolutions.net>
References: <31357461.i5mG9q5IfA@naboo> <5951977.8jla5cTcNa@naboo> <1379796719.4699.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2314669.GzRRsCAAVG"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart2314669.GzRRsCAAVG
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Le samedi 21 septembre 2013 22:51:59 Johannes Berg a =E9crit :
> On Thu, 2013-09-19 at 07:58 +0200, Detlev Casanova wrote:
> > Here is the output (attached file for formatting)
>=20
> Was that from the good case? The bad case would have been=20
more
> interesting.

This is both cases. I made another one and here, I can give more=20
details:

Network manager is trying to list APs and fails until time=20
1379858724.386569
The The first "iwlist wlan0 scan" is done juste after the log line=20
(1379858738.682054). It lists the APs in range in the console but=20
not in the Network Manager ui.

The second "iwlist wlan0 scan" is done at time 1379858739.802067=20
and APs are being listed in the console and in the Network Manager=20
UI.

After that, NM will connect to the acces point with SSID "Maison".

It also looks like the listing in Network Manager comes between the=20
moment "iwlist wlan0 scan" is run for the second time and the=20
moment is shows its output on the console.

Detlev.
--nextPart2314669.GzRRsCAAVG
Content-Disposition: attachment; filename="output"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="output"

1379858664.668605: dbus: Register D-Bus object '/fi/w1/wpa_supplicant1'                                                                                                                                              
1379858664.668901: Providing DBus service 'fi.w1.wpa_supplicant1'.                                                                                                                                                   
1379858664.669460: Providing DBus service 'fi.epitest.hostap.WPASupplicant'.                                                                                                                                         
1379858664.669902: dbus: fi.w1.wpa_supplicant1.CreateInterface (/fi/w1/wpa_supplicant1)                                                                                                                              
1379858664.669941: Initializing interface 'wlan0' conf 'N/A' driver 'nl80211,wext' ctrl_interface 'N/A' bridge 'N/A'
1379858666.245151: netlink: Operstate: linkmode=1, operstate=5
1379858666.250112: Own MAC address: 00:16:44:f1:d3:07
1379858666.250272: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=0 set_tx=0 seq_len=0 key_len=0
1379858666.250395: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=1 set_tx=0 seq_len=0 key_len=0
1379858666.250480: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=2 set_tx=0 seq_len=0 key_len=0
1379858666.250566: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=3 set_tx=0 seq_len=0 key_len=0
1379858666.250654: RSN: flushing PMKID list in the driver
1379858666.250683: State: DISCONNECTED -> INACTIVE
1379858666.255458: EAPOL: SUPP_PAE entering state DISCONNECTED
1379858666.255500: EAPOL: Supplicant port status: Unauthorized
1379858666.255607: EAPOL: KEY_RX entering state NO_KEY_RECEIVE
1379858666.255641: EAPOL: SUPP_BE entering state INITIALIZE
1379858666.255685: EAP: EAP entering state DISABLED
1379858666.255712: EAPOL: Supplicant port status: Unauthorized
1379858666.255792: EAPOL: Supplicant port status: Unauthorized
1379858666.255901: dbus: Register interface object '/fi/w1/wpa_supplicant1/Interfaces/1'
1379858666.256308: Added interface wlan0
1379858666.256421: dbus: org.freedesktop.DBus.Properties.GetAll (/fi/w1/wpa_supplicant1)
1379858666.256562: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379858666.256583: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858666.257323: dbus: org.freedesktop.DBus.Properties.GetAll (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858666.257579: dbus: fi.w1.wpa_supplicant1.Interface.NetworkReply (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858666.257600: no method handler for fi.w1.wpa_supplicant1.Interface.NetworkReply on /fi/w1/wpa_supplicant1/Interfaces/1
1379858666.257640: dbus: org.freedesktop.DBus.Introspectable.Introspect (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858666.258307: dbus: org.freedesktop.DBus.Properties.GetAll (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858666.262958: dbus: fi.w1.wpa_supplicant1.Interface.Scan (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858666.263399: Scan requested (ret=0) - scan timeout 10 seconds
1379858666.263464: dbus: fi.w1.wpa_supplicant1.Interface.Scan (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858666.263501: nl80211: Scan trigger failed: ret=-16 (Device or resource busy)
1379858666.263562: nl80211: Event message available
1379858666.263574: nl80211: Scan trigger
1379858667.256109: EAPOL: disable timer tick
1379858667.256144: EAPOL: Supplicant port status: Unauthorized
1379858667.945211: nl80211: Event message available
1379858667.945255: nl80211: New scan results available
1379858667.945300: Received scan results (0 BSSes)
1379858667.945313: BSS: Start scan result update 1
1379858667.945320: New scan results available
1379858667.945386: No suitable network found
1379858667.945393: State: INACTIVE -> INACTIVE
1379858667.945404: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379858667.945410: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858689.697832: dbus: fi.w1.wpa_supplicant1.Interface.Scan (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858689.698343: Scan requested (ret=0) - scan timeout 30 seconds
1379858689.698479: nl80211: Event message available
1379858689.698514: nl80211: Scan trigger
1379858691.380452: nl80211: Event message available
1379858691.380499: nl80211: New scan results available
1379858691.380809: Received scan results (0 BSSes)
1379858691.380817: BSS: Start scan result update 2
1379858691.380821: New scan results available
1379858691.380844: No suitable network found
1379858691.380849: State: INACTIVE -> INACTIVE
1379858691.380878: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379858691.380891: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858691.385848: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379858722.696534: dbus: fi.w1.wpa_supplicant1.Interface.Scan (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858722.697210: Scan requested (ret=0) - scan timeout 30 seconds
1379858722.697277: nl80211: Event message available
1379858722.697293: nl80211: Scan trigger
1379858724.381370: nl80211: Event message available
1379858724.381434: nl80211: New scan results available
1379858724.381522: Received scan results (0 BSSes)
1379858724.381528: BSS: Start scan result update 3
1379858724.381532: New scan results available
1379858724.381553: No suitable network found
1379858724.381558: State: INACTIVE -> INACTIVE
1379858724.381566: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379858724.381571: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858724.386569: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379858738.682054: nl80211: Event message available
1379858738.682102: nl80211: Scan trigger
1379858739.801286: nl80211: Event message available
1379858739.801350: nl80211: New scan results available
1379858739.801388: Received scan results (0 BSSes)
1379858739.801393: BSS: Start scan result update 4
1379858739.801397: New scan results available
1379858739.801452: No suitable network found
1379858739.801457: State: INACTIVE -> INACTIVE
1379858739.802055: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379858739.802067: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858745.833897: nl80211: Event message available
1379858745.833942: nl80211: Scan trigger
1379858746.953796: nl80211: Event message available
1379858746.953847: nl80211: New scan results available
1379858746.953924: Received scan results (3 BSSes)
1379858746.953934: BSS: Start scan result update 5
1379858746.953940: BSS: Add new id 0 BSSID 78:54:2e:a6:e3:80 SSID 'Maison'
1379858746.953949: dbus: Register BSS object '/fi/w1/wpa_supplicant1/Interfaces/1/BSSs/0'
1379858746.954277: BSS: Add new id 1 BSSID 00:19:70:ad:71:6e SSID 'bbox2-ec38'
1379858746.954288: dbus: Register BSS object '/fi/w1/wpa_supplicant1/Interfaces/1/BSSs/1'
1379858746.954466: BSS: Add new id 2 BSSID 06:19:70:ad:71:6e SSID 'FON_BELGACOM'
1379858746.954475: dbus: Register BSS object '/fi/w1/wpa_supplicant1/Interfaces/1/BSSs/2'
1379858746.954633: New scan results available
1379858746.954661: No suitable network found
1379858746.954667: State: INACTIVE -> INACTIVE
1379858746.955083: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379858746.955096: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858746.959338: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379858765.699913: dbus: fi.w1.wpa_supplicant1.Interface.Scan (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858765.700345: Scan requested (ret=0) - scan timeout 30 seconds
1379858765.700429: nl80211: Event message available
1379858765.700447: nl80211: Scan trigger
1379858767.383335: nl80211: Event message available
1379858767.383419: nl80211: New scan results available
1379858767.383576: Received scan results (4 BSSes)
1379858767.383586: BSS: Start scan result update 6
1379858767.383607: BSS: Add new id 3 BSSID 9c:d3:6d:98:2a:7c SSID 'VOO-264889'
1379858767.383613: dbus: Register BSS object '/fi/w1/wpa_supplicant1/Interfaces/1/BSSs/3'
1379858767.383807: New scan results available
1379858767.383829: No suitable network found
1379858767.383833: State: INACTIVE -> INACTIVE
1379858767.383842: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379858767.383846: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858767.388587: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379858767.388662: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1/BSSs/0
1379858767.388681: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1/BSSs/1
1379858768.422358: dbus: org.freedesktop.DBus.Properties.Set (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858768.424213: dbus: fi.w1.wpa_supplicant1.Interface.AddNetwork (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858768.424256: dbus: Register network object '/fi/w1/wpa_supplicant1/Interfaces/1/Networks/0'
1379858768.424381: scan_ssid=1 (0x1)
1379858768.424394: ssid - hexdump_ascii(len=6):
     4d 61 69 73 6f 6e                                 Maison          
1379858768.424410: key_mgmt: 0x2
1379858768.424418: PSK (ASCII passphrase) - hexdump_ascii(len=10): [REMOVED]
1379858768.444880: PSK (from passphrase) - hexdump(len=32): [REMOVED]
1379858768.445480: dbus: fi.w1.wpa_supplicant1.Interface.SelectNetwork (/fi/w1/wpa_supplicant1/Interfaces/1)
1379858768.445529: Setting scan request: 0 sec 0 usec
1379858768.445910: State: INACTIVE -> SCANNING
1379858768.445986: Scan SSID - hexdump_ascii(len=6):
     4d 61 69 73 6f 6e                                 Maison          
1379858768.446012: Starting AP scan for wildcard SSID
1379858768.446086: nl80211: Scan SSID - hexdump_ascii(len=6):
     4d 61 69 73 6f 6e                                 Maison          
1379858768.446113: nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
1379858768.446457: Scan requested (ret=0) - scan timeout 30 seconds
1379858768.446474: nl80211: Event message available
1379858768.446491: nl80211: Scan trigger
1379858768.451057: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379858769.565110: nl80211: Event message available
1379858769.565180: nl80211: New scan results available
1379858769.565298: Received scan results (4 BSSes)
1379858769.565308: BSS: Start scan result update 7
1379858769.565315: New scan results available
1379858769.565335: Selecting BSS from priority group 0
1379858769.565338: Try to find WPA-enabled AP
1379858769.565340: 0: 78:54:2e:a6:e3:80 ssid='Maison' wpa_ie_len=26 rsn_ie_len=24 caps=0x431
1379858769.565346:    selected based on RSN IE
1379858769.565349:    selected WPA AP 78:54:2e:a6:e3:80 ssid='Maison'
1379858769.565354: Automatic auth_alg selection: 0x1
1379858769.565360: RSN: using IEEE 802.11i/D9.0
1379858769.565362: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
1379858769.565365: WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 02 00 50 f2 04 01 00 00 50 f2 02
1379858769.565373: WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 02 00 0f ac 04 01 00 00 0f ac 02 00 00
1379858769.565380: WPA: using GTK TKIP
1379858769.565382: WPA: using PTK CCMP
1379858769.565384: WPA: using KEY_MGMT WPA-PSK
1379858769.565387: WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1379858769.565393: Cancelling scan request
1379858769.565396: Trying to authenticate with 78:54:2e:a6:e3:80 (SSID='Maison' freq=2457 MHz)
1379858769.565399: No keys have been configured - skip key clearing
1379858769.565401: State: SCANNING -> AUTHENTICATING
1379858769.565421: EAPOL: External notification - EAP success=0
1379858769.565426: EAPOL: Supplicant port status: Unauthorized
1379858769.565464: EAPOL: External notification - EAP fail=0
1379858769.565467: EAPOL: Supplicant port status: Unauthorized
1379858769.565482: EAPOL: External notification - portControl=Auto
1379858769.565485: EAPOL: Supplicant port status: Unauthorized
1379858769.565508: nl80211: Authenticate (ifindex=6)
1379858769.565512:   * bssid=78:54:2e:a6:e3:80
1379858769.565515:   * freq=2457
1379858769.565517:   * SSID - hexdump_ascii(len=6):
     4d 61 69 73 6f 6e                                 Maison          
1379858769.565523:   * IEs - hexdump(len=0): [NULL]
1379858769.565525:   * Auth Type 0
1379858769.574701: nl80211: Authentication request send successfully
1379858769.574736: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379858769.574825: nl80211: Event message available
1379858769.574845: nl80211: Ignored unknown event (cmd=19)
1379858769.574855: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379858769.574861: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858769.576530: nl80211: Event message available
1379858769.576580: nl80211: MLME event 37
1379858769.576593: nl80211: MLME event frame - hexdump(len=30): b0 00 3a 01 00 16 44 f1 d3 07 78 54 2e a6 e3 80 78 54 2e a6 e3 80 30 77 00 00 02 00 00 00
1379858769.576631: SME: Authentication response: peer=78:54:2e:a6:e3:80 auth_type=0 status_code=0
1379858769.576636: SME: Authentication response IEs - hexdump(len=0): [NULL]
1379858769.576644: Trying to associate with 78:54:2e:a6:e3:80 (SSID='Maison' freq=2457 MHz)
1379858769.576648: State: AUTHENTICATING -> ASSOCIATING
1379858769.576652: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1379858769.576657: netlink: Operstate: linkmode=-1, operstate=5
1379858769.576723: WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1379858769.576738: nl80211: Associate (ifindex=6)
1379858769.576746:   * bssid=78:54:2e:a6:e3:80
1379858769.576750:   * freq=2457
1379858769.576753:   * SSID - hexdump_ascii(len=6):
     4d 61 69 73 6f 6e                                 Maison          
1379858769.576761:   * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1379858769.576801: nl80211: Association request send successfully
1379858769.581815: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379858769.583316: RX EAPOL from 78:54:2e:a6:e3:80
1379858769.583340: RX EAPOL - hexdump(len=121): 01 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 01 53 ea 56 86 27 43 6a 33 f0 46 24 cd b8 95 e7 40 5e 1f 09 19 dc 69 c3 53 e8 48 c1 49 09 26 e8 a8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379858769.583434: Not associated - Delay processing of received EAPOL frame
1379858769.584422: nl80211: Event message available
1379858769.584455: nl80211: MLME event 38
1379858769.584460: nl80211: MLME event frame - hexdump(len=106): 10 00 3a 01 00 16 44 f1 d3 07 78 54 2e a6 e3 80 78 54 2e a6 e3 80 40 77 31 04 00 00 04 c0 01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 18 00 50 f2 04 10 4a 00 01 10 10 3b 00 01 03 10 49 00 06 00 37 2a 00 01 20 dd 06 00 e0 4c 02 01 60
1379858769.584495: Association info event
1379858769.584498: resp_ies - hexdump(len=76): 01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 18 00 50 f2 04 10 4a 00 01 10 10 3b 00 01 03 10 49 00 06 00 37 2a 00 01 20 dd 06 00 e0 4c 02 01 60
1379858769.584522: freq=2457 MHz
1379858769.584526: State: ASSOCIATING -> ASSOCIATED
1379858769.584530: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1379858769.584535: netlink: Operstate: linkmode=-1, operstate=5
1379858769.584597: Associated to a new BSS: BSSID=78:54:2e:a6:e3:80
1379858769.584606: No keys have been configured - skip key clearing
1379858769.584613: Associated with 78:54:2e:a6:e3:80
1379858769.584617: WPA: Association event - clear replay counter
1379858769.584625: WPA: Clear old PTK
1379858769.584628: EAPOL: External notification - portEnabled=0
1379858769.584633: EAPOL: Supplicant port status: Unauthorized
1379858769.584689: EAPOL: External notification - portValid=0
1379858769.584695: EAPOL: Supplicant port status: Unauthorized
1379858769.584721: EAPOL: External notification - EAP success=0
1379858769.584726: EAPOL: Supplicant port status: Unauthorized
1379858769.584749: EAPOL: External notification - portEnabled=1
1379858769.584755: EAPOL: SUPP_PAE entering state CONNECTING
1379858769.584758: EAPOL: enable timer tick
1379858769.584762: EAPOL: SUPP_BE entering state IDLE
1379858769.584767: Setting authentication timeout: 10 sec 0 usec
1379858769.584772: Cancelling scan request
1379858769.584775: Process pending EAPOL frame that was received just before association notification
1379858769.584778: RX EAPOL from 78:54:2e:a6:e3:80
1379858769.584782: RX EAPOL - hexdump(len=121): 01 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 01 53 ea 56 86 27 43 6a 33 f0 46 24 cd b8 95 e7 40 5e 1f 09 19 dc 69 c3 53 e8 48 c1 49 09 26 e8 a8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379858769.584821: Setting authentication timeout: 10 sec 0 usec
1379858769.584826: IEEE 802.1X RX: version=1 type=3 length=117
1379858769.584830:   EAPOL-Key type=2
1379858769.584833:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
1379858769.584838:   key_length=16 key_data_length=22
1379858769.584841:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
1379858769.584847:   key_nonce - hexdump(len=32): 53 ea 56 86 27 43 6a 33 f0 46 24 cd b8 95 e7 40 5e 1f 09 19 dc 69 c3 53 e8 48 c1 49 09 26 e8 a8
1379858769.584858:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379858769.584866:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
1379858769.584872:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1379858769.584877:   key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379858769.584886: WPA: RX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 01 53 ea 56 86 27 43 6a 33 f0 46 24 cd b8 95 e7 40 5e 1f 09 19 dc 69 c3 53 e8 48 c1 49 09 26 e8 a8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379858769.584926: State: ASSOCIATED -> 4WAY_HANDSHAKE
1379858769.584963: WPA: RX message 1 of 4-Way Handshake from 78:54:2e:a6:e3:80 (ver=2)
1379858769.584970: RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379858769.584982: WPA: PMKID in EAPOL-Key - hexdump(len=22): dd 14 00 0f ac 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379858769.584991: RSN: PMKID from Authenticator - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379858769.585000: RSN: no matching PMKID found
1379858769.585688: WPA: Renewed SNonce - hexdump(len=32): 22 d5 20 3f 56 53 24 77 de ba 71 d1 d0 51 ff c3 31 d7 f4 b0 dd 95 ef fb c4 25 32 88 00 34 3f b6
1379858769.585725: WPA: PTK derivation - A1=00:16:44:f1:d3:07 A2=78:54:2e:a6:e3:80
1379858769.585732: WPA: PMK - hexdump(len=32): [REMOVED]
1379858769.585735: WPA: PTK - hexdump(len=48): [REMOVED]
1379858769.585741: WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1379858769.585756: WPA: Sending EAPOL-Key 2/4
1379858769.585764: WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 22 d5 20 3f 56 53 24 77 de ba 71 d1 d0 51 ff c3 31 d7 f4 b0 dd 95 ef fb c4 25 32 88 00 34 3f b6 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 6b 51 84 fb c9 a7 ee 04 c3 fc 8b 7f 87 14 3c 7d 00 16 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1379858769.585836: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1379858769.585844: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858769.585851: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1379858769.585856: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858769.585861: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1379858769.585866: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858769.585875: nl80211: Event message available
1379858769.585889: nl80211: Ignore connect event (cmd=46) when using userspace SME
1379858769.589663: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379858769.609580: RX EAPOL from 78:54:2e:a6:e3:80
1379858769.609611: RX EAPOL - hexdump(len=179): 01 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 02 53 ea 56 86 27 43 6a 33 f0 46 24 cd b8 95 e7 40 5e 1f 09 19 dc 69 c3 53 e8 48 c1 49 09 26 e8 a8 53 ea 56 86 27 43 6a 33 f0 46 24 cd b8 95 e7 40 53 c2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e eb bd 70 ba 12 f5 37 82 fa 0b 71 66 f2 45 24 00 50 27 48 00 14 dd 93 c4 b7 5c c0 f7 26 c2 3a b4 68 8b 69 83 4f 88 bc 32 c2 1f 7c 8c c8 f1 3f a9 42 33 ad cc e7 54 32 23 e1 ed be 62 7a ed 58 78 a4 93 c5 fb c8 68 c0 3e de c2 51 73 64 34 14 4c 05 aa 01 4f 43 c9 8b b3 12 39 78 80 1a 28 94 8b d5
1379858769.609646: IEEE 802.1X RX: version=1 type=3 length=175
1379858769.609649:   EAPOL-Key type=2
1379858769.609652:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
1379858769.609656:   key_length=16 key_data_length=80
1379858769.609658:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
1379858769.609661:   key_nonce - hexdump(len=32): 53 ea 56 86 27 43 6a 33 f0 46 24 cd b8 95 e7 40 5e 1f 09 19 dc 69 c3 53 e8 48 c1 49 09 26 e8 a8
1379858769.609668:   key_iv - hexdump(len=16): 53 ea 56 86 27 43 6a 33 f0 46 24 cd b8 95 e7 40
1379858769.609672:   key_rsc - hexdump(len=8): 53 c2 00 00 00 00 00 00
1379858769.609675:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1379858769.609679:   key_mic - hexdump(len=16): 0e eb bd 70 ba 12 f5 37 82 fa 0b 71 66 f2 45 24
1379858769.609686: WPA: RX EAPOL-Key - hexdump(len=179): 01 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 02 53 ea 56 86 27 43 6a 33 f0 46 24 cd b8 95 e7 40 5e 1f 09 19 dc 69 c3 53 e8 48 c1 49 09 26 e8 a8 53 ea 56 86 27 43 6a 33 f0 46 24 cd b8 95 e7 40 53 c2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e eb bd 70 ba 12 f5 37 82 fa 0b 71 66 f2 45 24 00 50 27 48 00 14 dd 93 c4 b7 5c c0 f7 26 c2 3a b4 68 8b 69 83 4f 88 bc 32 c2 1f 7c 8c c8 f1 3f a9 42 33 ad cc e7 54 32 23 e1 ed be 62 7a ed 58 78 a4 93 c5 fb c8 68 c0 3e de c2 51 73 64 34 14 4c 05 aa 01 4f 43 c9 8b b3 12 39 78 80 1a 28 94 8b d5
1379858769.609730: RSN: encrypted key data - hexdump(len=80): 27 48 00 14 dd 93 c4 b7 5c c0 f7 26 c2 3a b4 68 8b 69 83 4f 88 bc 32 c2 1f 7c 8c c8 f1 3f a9 42 33 ad cc e7 54 32 23 e1 ed be 62 7a ed 58 78 a4 93 c5 fb c8 68 c0 3e de c2 51 73 64 34 14 4c 05 aa 01 4f 43 c9 8b b3 12 39 78 80 1a 28 94 8b d5
1379858769.609784: WPA: decrypted EAPOL-Key key data - hexdump(len=72): [REMOVED]
1379858769.609788: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
1379858769.609791: WPA: RX message 3 of 4-Way Handshake from 78:54:2e:a6:e3:80 (ver=2)
1379858769.609794: WPA: IE KeyData - hexdump(len=72): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 02 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 26 00 0f ac 01 01 00 fe 6d db d5 84 95 d2 a7 56 0a 53 ac 6a 89 1f 81 7c 5b 8f 57 9d ba fa 0d 78 af eb 50 13 4b 34 26 dd 00 00 00 00 00
1379858769.609808: WPA: RSN IE in EAPOL-Key - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 02 00 0f ac 04 01 00 00 0f ac 02 00 00
1379858769.609814: WPA: GTK in EAPOL-Key - hexdump(len=40): [REMOVED]
1379858769.609819: WPA: Sending EAPOL-Key 4/4
1379858769.609824: WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 50 90 7b d3 93 f4 92 c9 de d8 de 36 41 03 e3 65 00 00
1379858769.609868: WPA: Installing PTK to the driver.
1379858769.610100: wpa_driver_nl80211_set_key: ifindex=6 alg=3 addr=0x26468e0 key_idx=0 set_tx=1 seq_len=6 key_len=16
1379858769.610119:    addr=78:54:2e:a6:e3:80
1379858769.610425: EAPOL: External notification - portValid=1
1379858769.610432: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
1379858769.610499: RSN: received GTK in pairwise handshake - hexdump(len=34): [REMOVED]
1379858769.610503: WPA: Group Key - hexdump(len=32): [REMOVED]
1379858769.610506: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32).
1379858769.610508: WPA: RSC - hexdump(len=6): 53 c2 00 00 00 00
1379858769.610519: wpa_driver_nl80211_set_key: ifindex=6 alg=2 addr=0x45ca89 key_idx=1 set_tx=0 seq_len=6 key_len=32
1379858769.610541: WPA: Key negotiation completed with 78:54:2e:a6:e3:80 [PTK=CCMP GTK=TKIP]
1379858769.610546: Cancelling authentication timeout
1379858769.610549: State: GROUP_HANDSHAKE -> COMPLETED
1379858769.610554: CTRL-EVENT-CONNECTED - Connection to 78:54:2e:a6:e3:80 completed (auth) [id=0 id_str=]
1379858769.610558: wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
1379858769.610610: netlink: Operstate: linkmode=-1, operstate=6
1379858769.610678: EAPOL: External notification - portValid=1
1379858769.610685: EAPOL: External notification - EAP success=1
1379858769.610688: EAPOL: SUPP_PAE entering state AUTHENTICATING
1379858769.610691: EAPOL: SUPP_BE entering state SUCCESS
1379858769.610694: EAP: EAP entering state DISABLED
1379858769.610697: EAPOL: SUPP_PAE entering state AUTHENTICATED
1379858769.610699: EAPOL: Supplicant port status: Authorized
1379858769.610725: EAPOL: SUPP_BE entering state IDLE
1379858769.610730: EAPOL authentication completed successfully
1379858769.610738: RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
1379858769.610742: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379858769.615560: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379858770.390146: nl80211: Event message available
1379858771.400206: nl80211: Event message available
^C1379858772.112717: CTRL-EVENT-TERMINATING - signal 2 received
1379858772.112739: Removing interface wlan0
1379858772.112745: wpa_driver_nl80211_deauthenticate
1379858772.115743: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=0 set_tx=0 seq_len=0 key_len=0
1379858772.115817: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=1 set_tx=0 seq_len=0 key_len=0
1379858772.115879: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=2 set_tx=0 seq_len=0 key_len=0
1379858772.115937: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=3 set_tx=0 seq_len=0 key_len=0
1379858772.115995: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x2646120 key_idx=0 set_tx=0 seq_len=0 key_len=0
1379858772.116076:    addr=78:54:2e:a6:e3:80
1379858772.116116: State: COMPLETED -> DISCONNECTED
1379858772.116129: wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
1379858772.116139: netlink: Operstate: linkmode=-1, operstate=5
1379858772.116372: EAPOL: External notification - portEnabled=0
1379858772.116387: EAPOL: SUPP_PAE entering state DISCONNECTED
1379858772.116401: EAPOL: Supplicant port status: Unauthorized
1379858772.116432: EAPOL: SUPP_BE entering state INITIALIZE
1379858772.116440: EAPOL: Supplicant port status: Unauthorized
1379858772.116464: EAPOL: External notification - portValid=0
1379858772.116469: EAPOL: Supplicant port status: Unauthorized
1379858772.116528: EAPOL: External notification - EAP success=0
1379858772.116540: EAPOL: Supplicant port status: Unauthorized
1379858772.116603: No keys have been configured - skip key clearing
1379858772.131079: dbus: Unregister network object '/fi/w1/wpa_supplicant1/Interfaces/1/Networks/0'
1379858772.131517: BSS: Remove id 0 BSSID 78:54:2e:a6:e3:80 SSID 'Maison'
1379858772.131527: dbus: Unregister BSS object '/fi/w1/wpa_supplicant1/Interfaces/1/BSSs/0'
1379858772.131593: BSS: Remove id 1 BSSID 00:19:70:ad:71:6e SSID 'bbox2-ec38'
1379858772.131614: dbus: Unregister BSS object '/fi/w1/wpa_supplicant1/Interfaces/1/BSSs/1'
1379858772.131669: BSS: Remove id 3 BSSID 9c:d3:6d:98:2a:7c SSID 'VOO-264889'
1379858772.131687: dbus: Unregister BSS object '/fi/w1/wpa_supplicant1/Interfaces/1/BSSs/3'
1379858772.131734: BSS: Remove id 2 BSSID 06:19:70:ad:71:6e SSID 'FON_BELGACOM'
1379858772.131741: dbus: Unregister BSS object '/fi/w1/wpa_supplicant1/Interfaces/1/BSSs/2'
1379858772.131833: Cancelling scan request
1379858772.131841: Cancelling authentication timeout
1379858772.131849: dbus: Unregister interface object '/fi/w1/wpa_supplicant1/Interfaces/1'
1379858772.131875: netlink: Operstate: linkmode=0, operstate=6
1379858772.163542: dbus: Unregister D-Bus object '/fi/w1/wpa_supplicant1'
--nextPart2314669.GzRRsCAAVG--

