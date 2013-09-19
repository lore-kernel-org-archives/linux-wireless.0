Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45189 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3ISF6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 01:58:02 -0400
Received: by mail-ee0-f50.google.com with SMTP id d51so3868663eek.23
        for <linux-wireless@vger.kernel.org>; Wed, 18 Sep 2013 22:58:01 -0700 (PDT)
From: Detlev Casanova <detlev.casanova@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	laurent.pinchart@ideasonboard.com
Subject: Re: NetworkManager not listing access points
Date: Thu, 19 Sep 2013 07:58:14 +0200
Message-ID: <5951977.8jla5cTcNa@naboo> (sfid-20130919_075808_189917_B5387F5D)
In-Reply-To: <1379564168.13091.6.camel@dcbw.foobar.com>
References: <31357461.i5mG9q5IfA@naboo> <1379564168.13091.6.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart4302190.2fd8W3kv0g"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart4302190.2fd8W3kv0g
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Le mercredi 18 septembre 2013 23:16:08 Dan Williams a =E9crit :
> On Wed, 2013-09-18 at 22:47 +0200, Detlev Casanova wrote:
> > Hello,
> >=20
> > After a bisection on the kernel, it seems that a patch is causing=20=

a
> > problem with NetworkManager:
> >=20
> > commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8=20
("cfg80211:
> > use DS or HT operation IEs to determine BSS channel")
> >=20
> > The Wifi access points are not listed in the KDE plasma widget=20
and it
> > won't even connect to the saved ones even if they are in range.
> >=20
> > There is a fix though: running "iwlist wlan0 scan" twice as root=20=

(which
> > properly lists APs in reach) and the second time must be run=20
about two
> > seconds after the first time.
> >=20
> > Then NetworkManager lists the access points and connects to=20
the
> > prefered one if possible (normal behavior).
> >=20
> > This also happens with nm-applet in Gnome.
> >=20
> > The hardware is: 14e4:4315 (Network controller: Broadcom=20
Corporation
> > BCM4312 802.11b/g LP-PHY (rev 01)) on an Intel Core i3 M370=20
CPU (64
> > bits) computer.
> >=20
> > The abnormal behaviour is not random, it happens every time.
>=20
> Can you run wpa_supplicant with debugging output?  The quick=20
and dirty
> way is to:
>=20
> mv /usr/sbin/wpa_supplicant /
> killall -TERM wpa_supplicant
> /wpa_supplicant -dddtu
>=20
> and then wait for the problem to happen, and grab the log output=20
for us
> to analyze.
>=20
> Dan

Here is the output (attached file for formatting)

--nextPart4302190.2fd8W3kv0g
Content-Disposition: attachment; filename="output"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="output"

1379569812.462808: dbus: Register D-Bus object '/fi/w1/wpa_supplicant1'
1379569812.463387: Providing DBus service 'fi.w1.wpa_supplicant1'.
1379569812.463961: Providing DBus service 'fi.epitest.hostap.WPASupplicant'.
1379569812.464204: dbus: fi.w1.wpa_supplicant1.CreateInterface (/fi/w1/wpa_supplicant1)
1379569812.464274: Initializing interface 'wlan0' conf 'N/A' driver 'nl80211,wext' ctrl_interface 'N/A' bridge 'N/A'
1379569812.465509: netlink: Operstate: linkmode=1, operstate=5
1379569812.473709: Own MAC address: 00:16:44:f1:d3:07
1379569812.473746: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=0 set_tx=0 seq_len=0 key_len=0
1379569812.473803: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=1 set_tx=0 seq_len=0 key_len=0
1379569812.473840: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=2 set_tx=0 seq_len=0 key_len=0
1379569812.473872: wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x45ca89 key_idx=3 set_tx=0 seq_len=0 key_len=0
1379569812.473889: RSN: flushing PMKID list in the driver
1379569812.473894: State: DISCONNECTED -> INACTIVE
1379569812.477830: EAPOL: SUPP_PAE entering state DISCONNECTED
1379569812.477840: EAPOL: Supplicant port status: Unauthorized
1379569812.477876: EAPOL: KEY_RX entering state NO_KEY_RECEIVE
1379569812.477881: EAPOL: SUPP_BE entering state INITIALIZE
1379569812.477884: EAP: EAP entering state DISABLED
1379569812.477887: EAPOL: Supplicant port status: Unauthorized
1379569812.477903: EAPOL: Supplicant port status: Unauthorized
1379569812.477929: dbus: Register interface object '/fi/w1/wpa_supplicant1/Interfaces/1'
1379569812.478202: Added interface wlan0
1379569812.478284: dbus: org.freedesktop.DBus.Properties.GetAll (/fi/w1/wpa_supplicant1)
1379569812.479406: dbus: org.freedesktop.DBus.Properties.GetAll (/fi/w1/wpa_supplicant1/Interfaces/1)
1379569812.479828: dbus: fi.w1.wpa_supplicant1.Interface.NetworkReply (/fi/w1/wpa_supplicant1/Interfaces/1)
1379569812.479848: no method handler for fi.w1.wpa_supplicant1.Interface.NetworkReply on /fi/w1/wpa_supplicant1/Interfaces/1
1379569812.479985: dbus: org.freedesktop.DBus.Introspectable.Introspect (/fi/w1/wpa_supplicant1/Interfaces/1)
1379569812.480838: dbus: org.freedesktop.DBus.Properties.GetAll (/fi/w1/wpa_supplicant1/Interfaces/1)
1379569812.482196: dbus: fi.w1.wpa_supplicant1.Interface.Scan (/fi/w1/wpa_supplicant1/Interfaces/1)
1379569812.482692: Scan requested (ret=0) - scan timeout 10 seconds
1379569812.482872: dbus: fi.w1.wpa_supplicant1.Interface.Scan (/fi/w1/wpa_supplicant1/Interfaces/1)
1379569812.482915: nl80211: Scan trigger failed: ret=-16 (Device or resource busy)
1379569812.483555: nl80211: Event message available
1379569812.483581: nl80211: Scan trigger
1379569813.478983: EAPOL: disable timer tick
1379569813.479019: EAPOL: Supplicant port status: Unauthorized
1379569814.163044: nl80211: Event message available
1379569814.163106: nl80211: New scan results available
1379569814.163159: Received scan results (0 BSSes)
1379569814.163173: BSS: Start scan result update 1
1379569814.163178: New scan results available
1379569814.163450: No suitable network found
1379569814.163457: State: INACTIVE -> INACTIVE
1379569814.163471: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379569814.163480: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379569835.357239: dbus: fi.w1.wpa_supplicant1.Interface.Scan (/fi/w1/wpa_supplicant1/Interfaces/1)
1379569835.357744: Scan requested (ret=0) - scan timeout 30 seconds
1379569835.357880: nl80211: Event message available
1379569835.357914: nl80211: Scan trigger
1379569837.039966: nl80211: Event message available
1379569837.040031: nl80211: New scan results available
1379569837.040140: Received scan results (0 BSSes)
1379569837.040149: BSS: Start scan result update 2
1379569837.040154: New scan results available
1379569837.040186: No suitable network found
1379569837.040193: State: INACTIVE -> INACTIVE
1379569837.040409: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379569837.040426: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379569837.045232: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379569868.358662: dbus: fi.w1.wpa_supplicant1.Interface.Scan (/fi/w1/wpa_supplicant1/Interfaces/1)
1379569868.359106: Scan requested (ret=0) - scan timeout 30 seconds
1379569868.359206: nl80211: Event message available
1379569868.359224: nl80211: Scan trigger
1379569870.038738: nl80211: Event message available
1379569870.038808: nl80211: New scan results available
1379569870.038915: Received scan results (0 BSSes)
1379569870.038925: BSS: Start scan result update 3
1379569870.038928: New scan results available
1379569870.038947: No suitable network found
1379569870.038953: State: INACTIVE -> INACTIVE
1379569870.038964: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379569870.038969: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379569870.044029: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379569883.691230: nl80211: Event message available
1379569883.691292: nl80211: Scan trigger
1379569884.810881: nl80211: Event message available
1379569884.810949: nl80211: New scan results available
1379569884.810989: Received scan results (0 BSSes)
1379569884.810996: BSS: Start scan result update 4
1379569884.811000: New scan results available
1379569884.811064: No suitable network found
1379569884.811070: State: INACTIVE -> INACTIVE
1379569884.811381: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379569884.811393: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379569889.035023: nl80211: Event message available
1379569889.035086: nl80211: Scan trigger
1379569890.153956: nl80211: Event message available
1379569890.154007: nl80211: New scan results available
1379569890.154073: Received scan results (2 BSSes)
1379569890.154082: BSS: Start scan result update 5
1379569890.154087: BSS: Add new id 0 BSSID 78:54:2e:a6:e3:80 SSID 'Maison'
1379569890.154096: dbus: Register BSS object '/fi/w1/wpa_supplicant1/Interfaces/1/BSSs/0'
1379569890.154310: BSS: Add new id 1 BSSID 9c:d3:6d:98:2a:7c SSID 'VOO-264889'
1379569890.154317: dbus: Register BSS object '/fi/w1/wpa_supplicant1/Interfaces/1/BSSs/1'
1379569890.154450: New scan results available
1379569890.154477: No suitable network found
1379569890.154483: State: INACTIVE -> INACTIVE
1379569890.154498: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379569890.154505: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379569890.159375: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379569890.358936: dbus: org.freedesktop.DBus.Properties.Set (/fi/w1/wpa_supplicant1/Interfaces/1)
1379569890.360391: dbus: fi.w1.wpa_supplicant1.Interface.AddNetwork (/fi/w1/wpa_supplicant1/Interfaces/1)
1379569890.360437: dbus: Register network object '/fi/w1/wpa_supplicant1/Interfaces/1/Networks/0'
1379569890.360557: scan_ssid=1 (0x1)
1379569890.360569: ssid - hexdump_ascii(len=6):
     4d 61 69 73 6f 6e                                 Maison          
1379569890.360584: key_mgmt: 0x2
1379569890.360594: PSK (ASCII passphrase) - hexdump_ascii(len=10): [REMOVED]
1379569890.372592: PSK (from passphrase) - hexdump(len=32): [REMOVED]
1379569890.373053: dbus: fi.w1.wpa_supplicant1.Interface.SelectNetwork (/fi/w1/wpa_supplicant1/Interfaces/1)
1379569890.373104: Setting scan request: 0 sec 0 usec
1379569890.373198: State: INACTIVE -> SCANNING
1379569890.373240: Scan SSID - hexdump_ascii(len=6):
     4d 61 69 73 6f 6e                                 Maison          
1379569890.373264: Starting AP scan for wildcard SSID
1379569890.373306: nl80211: Scan SSID - hexdump_ascii(len=6):
     4d 61 69 73 6f 6e                                 Maison          
1379569890.373340: nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
1379569890.374211: Scan requested (ret=0) - scan timeout 30 seconds
1379569890.374231: nl80211: Event message available
1379569890.374252: nl80211: Scan trigger
1379569890.378304: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379569891.493950: nl80211: Event message available
1379569891.494003: nl80211: New scan results available
1379569891.494124: Received scan results (2 BSSes)
1379569891.494133: BSS: Start scan result update 6
1379569891.494150: New scan results available
1379569891.494170: Selecting BSS from priority group 0
1379569891.494173: Try to find WPA-enabled AP
1379569891.494176: 0: 78:54:2e:a6:e3:80 ssid='Maison' wpa_ie_len=26 rsn_ie_len=24 caps=0x431
1379569891.494182:    selected based on RSN IE
1379569891.494184:    selected WPA AP 78:54:2e:a6:e3:80 ssid='Maison'
1379569891.494190: Automatic auth_alg selection: 0x1
1379569891.494195: RSN: using IEEE 802.11i/D9.0
1379569891.494198: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
1379569891.494201: WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 02 00 50 f2 04 01 00 00 50 f2 02
1379569891.494209: WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 02 00 0f ac 04 01 00 00 0f ac 02 00 00
1379569891.494216: WPA: using GTK TKIP
1379569891.494218: WPA: using PTK CCMP
1379569891.494220: WPA: using KEY_MGMT WPA-PSK
1379569891.494223: WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1379569891.494230: Cancelling scan request
1379569891.494233: Trying to authenticate with 78:54:2e:a6:e3:80 (SSID='Maison' freq=2447 MHz)
1379569891.494236: No keys have been configured - skip key clearing
1379569891.494239: State: SCANNING -> AUTHENTICATING
1379569891.494259: EAPOL: External notification - EAP success=0
1379569891.494264: EAPOL: Supplicant port status: Unauthorized
1379569891.494309: EAPOL: External notification - EAP fail=0
1379569891.494312: EAPOL: Supplicant port status: Unauthorized
1379569891.494327: EAPOL: External notification - portControl=Auto
1379569891.494330: EAPOL: Supplicant port status: Unauthorized
1379569891.494353: nl80211: Authenticate (ifindex=6)
1379569891.494357:   * bssid=78:54:2e:a6:e3:80
1379569891.494360:   * freq=2447
1379569891.494362:   * SSID - hexdump_ascii(len=6):
     4d 61 69 73 6f 6e                                 Maison          
1379569891.494368:   * IEs - hexdump(len=0): [NULL]
1379569891.494370:   * Auth Type 0
1379569891.503619: nl80211: Authentication request send successfully
1379569891.503677: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379569891.503763: nl80211: Event message available
1379569891.503778: nl80211: Ignored unknown event (cmd=19)
1379569891.503786: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1379569891.503792: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379569891.503800: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1/BSSs/0
1379569891.503829: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1/BSSs/1
1379569891.505465: nl80211: Event message available
1379569891.505482: nl80211: MLME event 37
1379569891.505485: nl80211: MLME event frame - hexdump(len=30): b0 00 3a 01 00 16 44 f1 d3 07 78 54 2e a6 e3 80 78 54 2e a6 e3 80 50 a1 00 00 02 00 00 00
1379569891.505494: SME: Authentication response: peer=78:54:2e:a6:e3:80 auth_type=0 status_code=0
1379569891.505497: SME: Authentication response IEs - hexdump(len=0): [NULL]
1379569891.505502: Trying to associate with 78:54:2e:a6:e3:80 (SSID='Maison' freq=2447 MHz)
1379569891.505505: State: AUTHENTICATING -> ASSOCIATING
1379569891.505507: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1379569891.505511: netlink: Operstate: linkmode=-1, operstate=5
1379569891.505548: WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1379569891.505561: nl80211: Associate (ifindex=6)
1379569891.505567:   * bssid=78:54:2e:a6:e3:80
1379569891.505571:   * freq=2447
1379569891.505574:   * SSID - hexdump_ascii(len=6):
     4d 61 69 73 6f 6e                                 Maison          
1379569891.505583:   * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1379569891.505611: nl80211: Association request send successfully
1379569891.510618: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379569891.512395: RX EAPOL from 78:54:2e:a6:e3:80
1379569891.512418: RX EAPOL - hexdump(len=121): 01 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 01 38 95 71 ca a5 53 62 64 60 94 a9 0a 02 fe 5b 0e 0e c5 26 3f 76 43 50 d8 90 d4 06 b4 df fa d1 a0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379569891.512515: Not associated - Delay processing of received EAPOL frame
1379569891.512541: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1379569891.512546: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379569891.512684: nl80211: Event message available
1379569891.512913: nl80211: MLME event 38
1379569891.512918: nl80211: MLME event frame - hexdump(len=106): 10 00 3a 01 00 16 44 f1 d3 07 78 54 2e a6 e3 80 78 54 2e a6 e3 80 60 a1 31 04 00 00 03 c0 01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 18 00 50 f2 04 10 4a 00 01 10 10 3b 00 01 03 10 49 00 06 00 37 2a 00 01 20 dd 06 00 e0 4c 02 01 60
1379569891.512949: Association info event
1379569891.512952: resp_ies - hexdump(len=76): 01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 18 00 50 f2 04 10 4a 00 01 10 10 3b 00 01 03 10 49 00 06 00 37 2a 00 01 20 dd 06 00 e0 4c 02 01 60
1379569891.512986: freq=2447 MHz
1379569891.512998: State: ASSOCIATING -> ASSOCIATED
1379569891.513008: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1379569891.513018: netlink: Operstate: linkmode=-1, operstate=5
1379569891.513137: Associated to a new BSS: BSSID=78:54:2e:a6:e3:80
1379569891.513159: No keys have been configured - skip key clearing
1379569891.513173: Associated with 78:54:2e:a6:e3:80
1379569891.513181: WPA: Association event - clear replay counter
1379569891.513198: WPA: Clear old PTK
1379569891.513207: EAPOL: External notification - portEnabled=0
1379569891.513215: EAPOL: Supplicant port status: Unauthorized
1379569891.513309: EAPOL: External notification - portValid=0
1379569891.513323: EAPOL: Supplicant port status: Unauthorized
1379569891.513381: EAPOL: External notification - EAP success=0
1379569891.513394: EAPOL: Supplicant port status: Unauthorized
1379569891.513437: EAPOL: External notification - portEnabled=1
1379569891.513445: EAPOL: SUPP_PAE entering state CONNECTING
1379569891.513450: EAPOL: enable timer tick
1379569891.513456: EAPOL: SUPP_BE entering state IDLE
1379569891.513464: Setting authentication timeout: 10 sec 0 usec
1379569891.513471: Cancelling scan request
1379569891.513477: Process pending EAPOL frame that was received just before association notification
1379569891.513482: RX EAPOL from 78:54:2e:a6:e3:80
1379569891.513488: RX EAPOL - hexdump(len=121): 01 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 01 38 95 71 ca a5 53 62 64 60 94 a9 0a 02 fe 5b 0e 0e c5 26 3f 76 43 50 d8 90 d4 06 b4 df fa d1 a0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379569891.513543: Setting authentication timeout: 10 sec 0 usec
1379569891.513551: IEEE 802.1X RX: version=1 type=3 length=117
1379569891.513557:   EAPOL-Key type=2
1379569891.513562:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
1379569891.513569:   key_length=16 key_data_length=22
1379569891.513575:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
1379569891.513583:   key_nonce - hexdump(len=32): 38 95 71 ca a5 53 62 64 60 94 a9 0a 02 fe 5b 0e 0e c5 26 3f 76 43 50 d8 90 d4 06 b4 df fa d1 a0
1379569891.513600:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379569891.513611:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
1379569891.513620:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1379569891.513628:   key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379569891.513687: WPA: RX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 01 38 95 71 ca a5 53 62 64 60 94 a9 0a 02 fe 5b 0e 0e c5 26 3f 76 43 50 d8 90 d4 06 b4 df fa d1 a0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379569891.513763: State: ASSOCIATED -> 4WAY_HANDSHAKE
1379569891.513818: WPA: RX message 1 of 4-Way Handshake from 78:54:2e:a6:e3:80 (ver=2)
1379569891.513824: RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379569891.513834: WPA: PMKID in EAPOL-Key - hexdump(len=22): dd 14 00 0f ac 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379569891.513844: RSN: PMKID from Authenticator - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1379569891.513852: RSN: no matching PMKID found
1379569891.514277: WPA: Renewed SNonce - hexdump(len=32): 9b 1d 73 09 5a c7 3a 2c b3 91 4d 52 d1 02 08 4b d0 ad da 74 b0 0c 76 f6 3c 1f dc b2 7b 50 29 c1
1379569891.514303: WPA: PTK derivation - A1=00:16:44:f1:d3:07 A2=78:54:2e:a6:e3:80
1379569891.514307: WPA: PMK - hexdump(len=32): [REMOVED]
1379569891.514309: WPA: PTK - hexdump(len=48): [REMOVED]
1379569891.514313: WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1379569891.514321: WPA: Sending EAPOL-Key 2/4
1379569891.514326: WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 9b 1d 73 09 5a c7 3a 2c b3 91 4d 52 d1 02 08 4b d0 ad da 74 b0 0c 76 f6 3c 1f dc b2 7b 50 29 c1 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 b2 27 2b b9 d1 57 b8 ca 94 d0 00 47 ad b5 3d 08 00 16 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1379569891.514373: nl80211: Event message available
1379569891.514577: nl80211: Ignore connect event (cmd=46) when using userspace SME
1379569891.514583: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1379569891.514587: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379569891.514591: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1379569891.514593: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379569891.518190: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379569891.518547: RX EAPOL from 78:54:2e:a6:e3:80
1379569891.518568: RX EAPOL - hexdump(len=179): 01 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 02 38 95 71 ca a5 53 62 64 60 94 a9 0a 02 fe 5b 0e 0e c5 26 3f 76 43 50 d8 90 d4 06 b4 df fa d1 a0 38 95 71 ca a5 53 62 64 60 94 a9 0a 02 fe 5b 0e 13 62 07 00 00 00 00 00 00 00 00 00 00 00 00 00 b8 d4 c6 fa 60 3e c7 57 bb 19 33 00 4e 6b 1a 9d 00 50 9d 0f 44 b0 9e 21 3b f3 3f 17 32 3d 92 45 cd 84 b3 56 07 af d1 81 44 22 8e d4 1d fc 16 cb a3 a3 0b 24 7c 04 95 f7 b7 c4 54 0e 56 6a 31 d6 61 c3 2d 56 84 04 a8 99 78 07 22 0e 4a 61 7f a1 6b 3d 19 c8 7d 22 de 5d 96 e9 93 be 90 ce 66 9c d6 02
1379569891.518677: IEEE 802.1X RX: version=1 type=3 length=175
1379569891.518682:   EAPOL-Key type=2
1379569891.518685:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
1379569891.518690:   key_length=16 key_data_length=80
1379569891.518693:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
1379569891.518698:   key_nonce - hexdump(len=32): 38 95 71 ca a5 53 62 64 60 94 a9 0a 02 fe 5b 0e 0e c5 26 3f 76 43 50 d8 90 d4 06 b4 df fa d1 a0
1379569891.518705:   key_iv - hexdump(len=16): 38 95 71 ca a5 53 62 64 60 94 a9 0a 02 fe 5b 0e
1379569891.518709:   key_rsc - hexdump(len=8): 13 62 07 00 00 00 00 00
1379569891.518712:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1379569891.518715:   key_mic - hexdump(len=16): b8 d4 c6 fa 60 3e c7 57 bb 19 33 00 4e 6b 1a 9d
1379569891.518721: WPA: RX EAPOL-Key - hexdump(len=179): 01 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 02 38 95 71 ca a5 53 62 64 60 94 a9 0a 02 fe 5b 0e 0e c5 26 3f 76 43 50 d8 90 d4 06 b4 df fa d1 a0 38 95 71 ca a5 53 62 64 60 94 a9 0a 02 fe 5b 0e 13 62 07 00 00 00 00 00 00 00 00 00 00 00 00 00 b8 d4 c6 fa 60 3e c7 57 bb 19 33 00 4e 6b 1a 9d 00 50 9d 0f 44 b0 9e 21 3b f3 3f 17 32 3d 92 45 cd 84 b3 56 07 af d1 81 44 22 8e d4 1d fc 16 cb a3 a3 0b 24 7c 04 95 f7 b7 c4 54 0e 56 6a 31 d6 61 c3 2d 56 84 04 a8 99 78 07 22 0e 4a 61 7f a1 6b 3d 19 c8 7d 22 de 5d 96 e9 93 be 90 ce 66 9c d6 02
1379569891.518768: RSN: encrypted key data - hexdump(len=80): 9d 0f 44 b0 9e 21 3b f3 3f 17 32 3d 92 45 cd 84 b3 56 07 af d1 81 44 22 8e d4 1d fc 16 cb a3 a3 0b 24 7c 04 95 f7 b7 c4 54 0e 56 6a 31 d6 61 c3 2d 56 84 04 a8 99 78 07 22 0e 4a 61 7f a1 6b 3d 19 c8 7d 22 de 5d 96 e9 93 be 90 ce 66 9c d6 02
1379569891.518825: WPA: decrypted EAPOL-Key key data - hexdump(len=72): [REMOVED]
1379569891.518830: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
1379569891.518832: WPA: RX message 3 of 4-Way Handshake from 78:54:2e:a6:e3:80 (ver=2)
1379569891.518835: WPA: IE KeyData - hexdump(len=72): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 02 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 26 00 0f ac 01 01 00 e7 67 6b e9 f6 cd 28 01 26 73 14 61 45 d8 db 44 90 79 47 6b 3c df f4 85 55 4a 5e 5b 87 37 69 8b dd 00 00 00 00 00
1379569891.518848: WPA: RSN IE in EAPOL-Key - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 02 00 0f ac 04 01 00 00 0f ac 02 00 00
1379569891.518855: WPA: GTK in EAPOL-Key - hexdump(len=40): [REMOVED]
1379569891.518858: WPA: Sending EAPOL-Key 4/4
1379569891.518863: WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 da 41 37 9d fa e7 2a 6c 88 9d 37 e1 e5 fd b2 d3 00 00
1379569891.518890: WPA: Installing PTK to the driver.
1379569891.518916: wpa_driver_nl80211_set_key: ifindex=6 alg=3 addr=0xbcec60 key_idx=0 set_tx=1 seq_len=6 key_len=16
1379569891.518924:    addr=78:54:2e:a6:e3:80
1379569891.519171: EAPOL: External notification - portValid=1
1379569891.519180: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
1379569891.519219: RSN: received GTK in pairwise handshake - hexdump(len=34): [REMOVED]
1379569891.519226: WPA: Group Key - hexdump(len=32): [REMOVED]
1379569891.519229: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32).
1379569891.519233: WPA: RSC - hexdump(len=6): 13 62 07 00 00 00
1379569891.519247: wpa_driver_nl80211_set_key: ifindex=6 alg=2 addr=0x45ca89 key_idx=1 set_tx=0 seq_len=6 key_len=32
1379569891.519272: WPA: Key negotiation completed with 78:54:2e:a6:e3:80 [PTK=CCMP GTK=TKIP]
1379569891.519278: Cancelling authentication timeout
1379569891.519282: State: GROUP_HANDSHAKE -> COMPLETED
1379569891.519287: CTRL-EVENT-CONNECTED - Connection to 78:54:2e:a6:e3:80 completed (auth) [id=0 id_str=]
1379569891.519291: wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
1379569891.519295: netlink: Operstate: linkmode=-1, operstate=6
1379569891.519355: EAPOL: External notification - portValid=1
1379569891.519361: EAPOL: External notification - EAP success=1
1379569891.519365: EAPOL: SUPP_PAE entering state AUTHENTICATING
1379569891.519368: EAPOL: SUPP_BE entering state SUCCESS
1379569891.519371: EAP: EAP entering state DISABLED
1379569891.519374: EAPOL: SUPP_PAE entering state AUTHENTICATED
1379569891.519377: EAPOL: Supplicant port status: Authorized
1379569891.519406: EAPOL: SUPP_BE entering state IDLE
1379569891.519411: EAPOL authentication completed successfully
1379569891.519421: RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
1379569891.519427: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1379569891.524282: dbus: flush_object_timeout_handler: Timeout - sending changed properties of object /fi/w1/wpa_supplicant1/Interfaces/1
1379569893.049791: nl80211: Event message available
1379569894.059793: nl80211: Event message available
1379569894.515643: EAPOL: startWhen --> 0
1379569894.515671: EAPOL: disable timer tick
1379569895.059803: nl80211: Event message available
1379569896.049785: nl80211: Event message available
1379569897.059991: nl80211: Event message available
1379569898.059787: nl80211: Event message available
1379569899.059786: nl80211: Event message available
1379569900.049789: nl80211: Event message available
1379569901.059764: nl80211: Event message available
1379569902.053868: nl80211: Event message available

--nextPart4302190.2fd8W3kv0g--

