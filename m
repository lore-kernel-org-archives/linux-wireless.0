Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:45457 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3IXWoA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 18:44:00 -0400
Received: by mail-oa0-f50.google.com with SMTP id j1so64864oag.23
        for <linux-wireless@vger.kernel.org>; Tue, 24 Sep 2013 15:44:00 -0700 (PDT)
Message-ID: <524215AD.6060300@lwfinger.net> (sfid-20130925_004420_971297_753B65EB)
Date: Tue, 24 Sep 2013 17:43:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com>  <522E4315.4040806@lwfinger.net> <1378764913.31180.9.camel@dcbw.foobar.com>
In-Reply-To: <1378764913.31180.9.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/2013 05:15 PM, Dan Williams wrote:
> On Mon, 2013-09-09 at 16:52 -0500, Larry Finger wrote:

>> I have been running rtl8192cu for the past 24 hours without a permanent
>> disconnect. Under NetworkManager, I see some reason 7 deauthentications, but
>
> Running wpa_supplicant with debugging on might shed some light on these;
> basically:
>
> mv /usr/sbin/wpa_supplicant /
> killall -TERM wpa_supplicant
> /wpa_supplicant -dddtu <piped to your favorite log file>
>
> and NM should automatically reconnect, and then we can figure out what's
> going on in the supplicant.

Dan,

The log of wpa_supplicant associated with the reason 7 disconnects are as follows:

1380060983.255499: RTM_NEWLINK: operstate=1 ifi_flags=0x1003 ([UP])
1380060983.255516: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
1380060983.255588: nl80211: if_removed already cleared - ignore event
1380060983.255600: Ignore event for foreign ifindex 22
1380060983.272257: nl80211: Event message available
1380060983.272307: nl80211: Delete station 20:e5:2a:01:f7:ea
1380060983.280211: nl80211: Event message available
1380060983.280228: nl80211: MLME event 39
1380060983.280230: nl80211: MLME event frame - hexdump(len=26): c0 00 3a 01 1c 
65 9d 5a c3 9d 20 e5 2a 01 f7 ea 20 e5 2a 01 f7 ea 30 d2 07 00
1380060983.280248: wlan3: Event DEAUTH (12) received
1380060983.280252: wlan3: Deauthentication notification
1380060983.280255: wlan3:  * reason 7
1380060983.280258: wlan3:  * address 20:e5:2a:01:f7:ea
1380060983.280260: Deauthentication frame IE(s) - hexdump(len=0): [NULL]
1380060983.280264: wlan3: WPA: Auto connect enabled: try to reconnect (wps=0)
1380060983.280267: wlan3: Setting scan request: 0 sec 100000 usec
1380060983.280271: Added BSSID 20:e5:2a:01:f7:ea into blacklist
1380060983.280276: wlan3: Not rescheduling scan to ensure that specific SSID 
scans occur
1380060983.280281: wlan3: CTRL-EVENT-DISCONNECTED bssid=20:e5:2a:01:f7:ea reason=7
1380060983.280283: wlan3: Disconnect event - remove keys
1380060983.280362: wpa_driver_nl80211_set_key: ifindex=22 alg=0 addr=(nil) 
key_idx=0 set_tx=0 seq_len=0 key_len=0
1380060983.290262: wpa_driver_nl80211_set_key: ifindex=22 alg=0 addr=(nil) 
key_idx=1 set_tx=0 seq_len=0 key_len=0
1380060983.292660: wpa_driver_nl80211_set_key: ifindex=22 alg=0 addr=(nil) 
key_idx=2 set_tx=0 seq_len=0 key_len=0
1380060983.292791: wpa_driver_nl80211_set_key: ifindex=22 alg=0 addr=(nil) 
key_idx=3 set_tx=0 seq_len=0 key_len=0
1380060983.292896: wpa_driver_nl80211_set_key: ifindex=22 alg=0 addr=(nil) 
key_idx=4 set_tx=0 seq_len=0 key_len=0
1380060983.292992: wpa_driver_nl80211_set_key: ifindex=22 alg=0 addr=(nil) 
key_idx=5 set_tx=0 seq_len=0 key_len=0
1380060983.293104: wpa_driver_nl80211_set_key: ifindex=22 alg=0 addr=0x6f7710 
key_idx=0 set_tx=0 seq_len=0 key_len=0
1380060983.293110:    addr=20:e5:2a:01:f7:ea
1380060983.293174: wlan3: State: COMPLETED -> DISCONNECTED
1380060983.293178: wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
1380060983.293182: netlink: Operstate: linkmode=-1, operstate=5
1380060983.293329: EAPOL: External notification - portEnabled=0
1380060983.293333: EAPOL: SUPP_PAE entering state DISCONNECTED
1380060983.293335: EAPOL: Supplicant port status: Unauthorized
1380060983.293445: EAPOL: SUPP_BE entering state INITIALIZE
1380060983.293449: EAPOL: Supplicant port status: Unauthorized
1380060983.293548: EAPOL: External notification - portValid=0
1380060983.293551: EAPOL: Supplicant port status: Unauthorized
1380060983.293862: EAPOL: External notification - EAP success=0
1380060983.293866: EAPOL: Supplicant port status: Unauthorized
1380060983.293998: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1380060983.294004: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
1380060983.294049: nl80211: if_removed already cleared - ignore event
1380060983.294071: Ignore event for foreign ifindex 22
1380060983.294075: nl80211: Event message available
1380060983.294096: nl80211: Ignore disconnect event when using userspace SME
1380060983.298420: dbus: flush_object_timeout_handler: Timeout - sending changed 
properties of object /fi/w1/wpa_supplicant1/Interfaces/3
1380060983.300119: nl80211: Event message available
1380060983.300155: nl80211: Regulatory domain change
1380060983.300163: wlan3: Event CHANNEL_LIST_CHANGED (31) received
1380060983.306633: nl80211: Regulatory information - country=00
1380060983.306642: nl80211: 2402-2472 @ 40 MHz
1380060983.306645: nl80211: 2457-2482 @ 20 MHz
1380060983.306647: nl80211: 2474-2494 @ 20 MHz
1380060983.306649: nl80211: 5170-5250 @ 40 MHz
1380060983.306652: nl80211: 5735-5835 @ 40 MHz
1380060983.306665: nl80211: Added 802.11b mode based on 802.11g information
1380060983.312952: nl80211: Event message available
1380060983.313006: nl80211: Regulatory domain change
1380060983.313014: wlan3: Event CHANNEL_LIST_CHANGED (31) received
1380060983.313294: nl80211: Regulatory information - country=US
1380060983.313298: nl80211: 2402-2472 @ 40 MHz
1380060983.313301: nl80211: 5170-5250 @ 40 MHz
1380060983.313303: nl80211: 5250-5330 @ 40 MHz
1380060983.313306: nl80211: 5490-5600 @ 40 MHz
1380060983.313308: nl80211: 5650-5710 @ 40 MHz
1380060983.313311: nl80211: 5735-5835 @ 40 MHz
1380060983.313325: nl80211: Added 802.11b mode based on 802.11g information
1380060983.380401: wlan3: State: DISCONNECTED -> SCANNING
1380060983.380519: Scan SSID - hexdump_ascii(len=9):
      4e 45 54 47 45 41 52 38 31                        NETGEAR81
1380060983.380530: wlan3: Starting AP scan for wildcard SSID
1380060983.380594: nl80211: Scan SSID - hexdump_ascii(len=9):
      4e 45 54 47 45 41 52 38 31                        NETGEAR81
1380060983.380601: nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
1380060983.711836: Scan requested (ret=0) - scan timeout 30 seconds
1380060983.711858: dbus: flush_object_timeout_handler: Timeout - sending changed 
properties of object /fi/w1/wpa_supplicant1/Interfaces/3
1380060983.711979: nl80211: Event message available
1380060983.711996: nl80211: Scan trigger
1380060984.417923: nl80211: Event message available
1380060984.417967: nl80211: New scan results available
1380060984.417978: wlan3: Event SCAN_RESULTS (3) received
1380060984.418197: nl80211: Received scan results (5 BSSes)
1380060984.418259: Sorted scan results
1380060984.418262: 00:e0:4c:81:86:86 freq=2462 qual=0 noise=0 level=-38 flags=0xb
1380060984.418267: c0:3f:0e:be:2b:44 freq=2422 qual=0 noise=0 level=-50 flags=0xb
1380060984.418271: 20:e5:2a:01:f7:ea freq=2437 qual=0 noise=0 level=-54 flags=0xb
1380060984.418274: 00:1a:70:46:ba:b1 freq=2462 qual=0 noise=0 level=-72 flags=0xb
1380060984.418278: 00:14:bf:85:49:fa freq=2412 qual=0 noise=0 level=-48 flags=0xb
1380060984.418283: wlan3: BSS: Start scan result update 15
1380060984.418325: Add randomness: count=213 entropy=148
1380060984.418328: random pool - hexdump(len=128): [REMOVED]
1380060984.418330: random_mix_pool - hexdump(len=16): [REMOVED]
1380060984.418333: random_mix_pool - hexdump(len=5): [REMOVED]
1380060984.418335: random pool - hexdump(len=128): [REMOVED]
1380060984.418337: Add randomness: count=214 entropy=149
1380060984.418340: random pool - hexdump(len=128): [REMOVED]
1380060984.418341: random_mix_pool - hexdump(len=16): [REMOVED]
1380060984.418343: random_mix_pool - hexdump(len=5): [REMOVED]
1380060984.418345: random pool - hexdump(len=128): [REMOVED]
1380060984.418347: Add randomness: count=215 entropy=150
1380060984.418350: random pool - hexdump(len=128): [REMOVED]
1380060984.418352: random_mix_pool - hexdump(len=16): [REMOVED]
1380060984.418486: random_mix_pool - hexdump(len=5): [REMOVED]
1380060984.418489: random pool - hexdump(len=128): [REMOVED]
1380060984.418491: Add randomness: count=216 entropy=151
1380060984.418494: random pool - hexdump(len=128): [REMOVED]
1380060984.418496: random_mix_pool - hexdump(len=16): [REMOVED]
1380060984.418498: random_mix_pool - hexdump(len=5): [REMOVED]
1380060984.418500: random pool - hexdump(len=128): [REMOVED]
1380060984.418502: Add randomness: count=217 entropy=152
1380060984.418505: random pool - hexdump(len=128): [REMOVED]
1380060984.418507: random_mix_pool - hexdump(len=16): [REMOVED]
1380060984.418510: random_mix_pool - hexdump(len=5): [REMOVED]
1380060984.418512: random pool - hexdump(len=128): [REMOVED]
1380060984.418516: wlan3: New scan results available
1380060984.418555: WPS: attr type=0x104a len=1
1380060984.418559: WPS: attr type=0x1044 len=1
1380060984.418561: WPS: attr type=0x104a len=1
1380060984.418563: WPS: attr type=0x1044 len=1
1380060984.418565: WPS: attr type=0x104a len=1
1380060984.418567: WPS: attr type=0x1044 len=1
1380060984.418570: WPS: attr type=0x104a len=1
1380060984.418572: WPS: attr type=0x1044 len=1
1380060984.418573: WPS: attr type=0x103b len=1
1380060984.418575: WPS: attr type=0x1047 len=16
1380060984.418578: WPS: attr type=0x1021 len=13
1380060984.418580: WPS: attr type=0x1023 len=10
1380060984.418582: WPS: attr type=0x1024 len=10
1380060984.418584: WPS: attr type=0x1042 len=2
1380060984.418586: WPS: attr type=0x1054 len=8
1380060984.418588: WPS: attr type=0x1011 len=10
1380060984.418590: WPS: attr type=0x1008 len=2
1380060984.418592: WPS: attr type=0x103c len=1
1380060984.418594: WPS: attr type=0x1049 len=6
1380060984.418596: WPS: WFA subelement id=0 len=1
1380060984.418598: WPS: attr type=0x104a len=1
1380060984.418600: WPS: attr type=0x1044 len=1
1380060984.418602: WPS: attr type=0x103b len=1
1380060984.418604: WPS: attr type=0x1047 len=16
1380060984.418606: WPS: attr type=0x1021 len=13
1380060984.418608: WPS: attr type=0x1023 len=10
1380060984.418610: WPS: attr type=0x1024 len=10
1380060984.418611: WPS: attr type=0x1042 len=2
1380060984.418613: WPS: attr type=0x1054 len=8
1380060984.418615: WPS: attr type=0x1011 len=10
1380060984.418617: WPS: attr type=0x1008 len=2
1380060984.418619: WPS: attr type=0x103c len=1
1380060984.418621: WPS: attr type=0x1049 len=6
1380060984.418623: WPS: WFA subelement id=0 len=1
1380060984.418625: WPS: attr type=0x104a len=1
1380060984.418627: WPS: attr type=0x1044 len=1
1380060984.418629: WPS: attr type=0x103b len=1
1380060984.418631: WPS: attr type=0x1047 len=16
1380060984.418632: WPS: attr type=0x1021 len=13
1380060984.418634: WPS: attr type=0x1023 len=10
1380060984.418636: WPS: attr type=0x1024 len=10
1380060984.418638: WPS: attr type=0x1042 len=2
1380060984.418640: WPS: attr type=0x1054 len=8
1380060984.418642: WPS: attr type=0x1011 len=10
1380060984.418644: WPS: attr type=0x1008 len=2
1380060984.418646: WPS: attr type=0x103c len=1
1380060984.418648: WPS: attr type=0x1049 len=6
1380060984.418650: WPS: WFA subelement id=0 len=1
1380060984.418688: wlan3: Selecting BSS from priority group 0
1380060984.418695: wlan3: 0: 00:e0:4c:81:86:86 ssid='OpenWrt' wpa_ie_len=0 
rsn_ie_len=20 caps=0x11 level=-38
1380060984.418698: wlan3:    skip - SSID mismatch
1380060984.418703: wlan3: 1: c0:3f:0e:be:2b:44 ssid='lwfdjf-n' wpa_ie_len=0 
rsn_ie_len=20 caps=0x411 level=-50 wps
1380060984.418706: wlan3:    skip - SSID mismatch
1380060984.418710: wlan3: 2: 20:e5:2a:01:f7:ea ssid='NETGEAR81' wpa_ie_len=0 
rsn_ie_len=20 caps=0x411 level=-54 wps
1380060984.418714: wlan3:    skip - blacklisted (count=1 limit=0)
1380060984.418719: wlan3: 3: 00:1a:70:46:ba:b1 ssid='Larry_wpa1' wpa_ie_len=24 
rsn_ie_len=0 caps=0x411 level=-72
1380060984.418721: wlan3:    skip - SSID mismatch
1380060984.418726: wlan3: 4: 00:14:bf:85:49:fa ssid='radius' wpa_ie_len=0 
rsn_ie_len=0 caps=0x411 level=-48
1380060984.418728: wlan3:    skip - SSID mismatch
1380060984.418731: wlan3: No APs found - clear blacklist and try again
1380060984.418733: Removed BSSID 20:e5:2a:01:f7:ea from blacklist (clear)
1380060984.418799: wlan3: Selecting BSS from priority group 0
1380060984.418804: wlan3: 0: 00:e0:4c:81:86:86 ssid='OpenWrt' wpa_ie_len=0 
rsn_ie_len=20 caps=0x11 level=-38
1380060984.418807: wlan3:    skip - SSID mismatch
1380060984.418811: wlan3: 1: c0:3f:0e:be:2b:44 ssid='lwfdjf-n' wpa_ie_len=0 
rsn_ie_len=20 caps=0x411 level=-50 wps
1380060984.418814: wlan3:    skip - SSID mismatch
1380060984.418818: wlan3: 2: 20:e5:2a:01:f7:ea ssid='NETGEAR81' wpa_ie_len=0 
rsn_ie_len=20 caps=0x411 level=-54 wps
1380060984.418823: wlan3:    selected based on RSN IE
1380060984.418828: wlan3:    selected BSS 20:e5:2a:01:f7:ea ssid='NETGEAR81'
1380060984.418837: wlan3: Request association: reassociate: 0  selected: 
20:e5:2a:01:f7:ea  bssid: 00:00:00:00:00:00  pending: 00:00:00:00:00:00 
wpa_state: SCANNING
1380060984.418841: wlan3: Automatic auth_alg selection: 0x1
1380060984.418845: wlan3: RSN: using IEEE 802.11i/D9.0
1380060984.418848: wlan3: WPA: Selected cipher suites: group 16 pairwise 16 
key_mgmt 2 proto 2
1380060984.418852: wlan3: WPA: clearing AP WPA IE
1380060984.418854: WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 
01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
1380060984.418865: wlan3: WPA: using GTK CCMP
1380060984.418867: wlan3: WPA: using PTK CCMP
1380060984.418870: wlan3: WPA: using KEY_MGMT WPA-PSK
1380060984.418872: wlan3: WPA: not using MGMT group cipher
1380060984.418875: WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 
0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1380060984.418886: wlan3: Cancelling scan request
1380060984.418890: wlan3: SME: Trying to authenticate with 20:e5:2a:01:f7:ea 
(SSID='NETGEAR81' freq=2437 MHz)
1380060984.418893: wlan3: No keys have been configured - skip key clearing
1380060984.418896: wlan3: State: SCANNING -> AUTHENTICATING
1380060984.418956: EAPOL: External notification - EAP success=0
1380060984.418959: EAPOL: Supplicant port status: Unauthorized
1380060984.419094: EAPOL: External notification - EAP fail=0
1380060984.419097: EAPOL: Supplicant port status: Unauthorized
1380060984.419195: EAPOL: External notification - portControl=Auto
1380060984.419198: EAPOL: Supplicant port status: Unauthorized
1380060984.419294: nl80211: Authenticate (ifindex=22)
1380060984.419298:   * bssid=20:e5:2a:01:f7:ea
1380060984.419301:   * freq=2437
1380060984.419303:   * SSID - hexdump_ascii(len=9):
      4e 45 54 47 45 41 52 38 31                        NETGEAR81
1380060984.419311:   * IEs - hexdump(len=0): [NULL]
1380060984.419313:   * Auth Type 0
1380060984.439811: nl80211: Authentication request send successfully
1380060984.439836: wlan3: Checking for other virtual interfaces sharing same 
radio (phy0) in event_scan_results
1380060984.439857: dbus: flush_object_timeout_handler: Timeout - sending changed 
properties of object /fi/w1/wpa_supplicant1/Interfaces/3
1380060984.440017: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1380060984.440022: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
1380060984.440171: nl80211: if_removed already cleared - ignore event
1380060984.440192: Ignore event for foreign ifindex 22
1380060984.440196: nl80211: Event message available
1380060984.440215: nl80211: New station 20:e5:2a:01:f7:ea
1380060984.440229: dbus: flush_object_timeout_handler: Timeout - sending changed 
properties of object /fi/w1/wpa_supplicant1/Interfaces/3/BSSs/0
1380060984.440340: dbus: flush_object_timeout_handler: Timeout - sending changed 
properties of object /fi/w1/wpa_supplicant1/Interfaces/3/BSSs/6
1380060984.440478: dbus: flush_object_timeout_handler: Timeout - sending changed 
properties of object /fi/w1/wpa_supplicant1/Interfaces/3/BSSs/1
1380060984.440628: dbus: flush_object_timeout_handler: Timeout - sending changed 
properties of object /fi/w1/wpa_supplicant1/Interfaces/3/BSSs/3
1380060984.441086: nl80211: Event message available
1380060984.441103: nl80211: MLME event 37
1380060984.441106: nl80211: MLME event frame - hexdump(len=41): b0 00 3a 01 1c 
65 9d 5a c3 9d 20 e5 2a 01 f7 ea 20 e5 2a 01 f7 ea 60 d3 00 00 02 00 00 00 dd 09 
00 10 18 02 00 f0 04 00 00
1380060984.441251: wlan3: Event AUTH (11) received
1380060984.441257: wlan3: SME: Authentication response: peer=20:e5:2a:01:f7:ea 
auth_type=0 status_code=0
1380060984.441259: SME: Authentication response IEs - hexdump(len=11): dd 09 00 
10 18 02 00 f0 04 00 00
1380060984.441269: wlan3: Trying to associate with 20:e5:2a:01:f7:ea 
(SSID='NETGEAR81' freq=2437 MHz)
1380060984.441272: wlan3: State: AUTHENTICATING -> ASSOCIATING
1380060984.441275: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1380060984.441278: netlink: Operstate: linkmode=-1, operstate=5
1380060984.441370: WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f 
ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1380060984.441383: nl80211: Associate (ifindex=22)
1380060984.441388:   * bssid=20:e5:2a:01:f7:ea
1380060984.441391:   * freq=2437
1380060984.441393:   * SSID - hexdump_ascii(len=9):
      4e 45 54 47 45 41 52 38 31                        NETGEAR81
1380060984.441400:   * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 
0f ac 04 01 00 00 0f ac 02 00 00
1380060984.441408:   * pairwise=0xfac04
1380060984.441410:   * group=0xfac04
1380060984.441412:   * prev_bssid=20:e5:2a:01:f7:ea
1380060984.441506: nl80211: Association request send successfully
1380060984.446458: dbus: flush_object_timeout_handler: Timeout - sending changed 
properties of object /fi/w1/wpa_supplicant1/Interfaces/3
1380060984.447729: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1380060984.447745: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
1380060984.447824: nl80211: if_removed already cleared - ignore event
1380060984.447832: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1380060984.447835: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
1380060984.447882: nl80211: if_removed already cleared - ignore event
1380060984.447888: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1380060984.447891: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
1380060984.447934: nl80211: if_removed already cleared - ignore event
1380060984.447944: Ignore event for foreign ifindex 22
1380060984.447950: Ignore event for foreign ifindex 22
1380060984.447955: Ignore event for foreign ifindex 22
1380060984.447959: nl80211: Event message available
1380060984.447990: nl80211: MLME event 38
1380060984.447992: nl80211: MLME event frame - hexdump(len=180): 30 00 3a 01 1c 
65 9d 5a c3 9d 20 e5 2a 01 f7 ea 20 e5 2a 01 f7 ea 70 d3 11 04 00 00 02 c0 01 08 
82 84 0b 16 24 30 48 6c 32 04 0c 12 18 60 2d 1a fc 18 1f ff ff 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 06 00 17 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 4a 0e 14 00 0a 00 2c 01 c8 00 14 00 
05 00 19 00 dd 18 00 50 f2 04 10 4a 00 01 10 10 3b 00 01 03 10 49 00 06 00 37 2a 
00 01 20 dd 09 00 10 18 02 00 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 
00 27 a4 00 00 42 43 5e 00 62 32 2f 00
1380060984.448058: wlan3: Event ASSOC (0) received
1380060984.448062: wlan3: Association info event
1380060984.448064: resp_ies - hexdump(len=150): 01 08 82 84 0b 16 24 30 48 6c 32 
04 0c 12 18 60 2d 1a fc 18 1f ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 3d 16 06 00 17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 7f 01 01 4a 0e 14 00 0a 00 2c 01 c8 00 14 00 05 00 19 00 dd 18 00 50 f2 
04 10 4a 00 01 10 10 3b 00 01 03 10 49 00 06 00 37 2a 00 01 20 dd 09 00 10 18 02 
00 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 
62 32 2f 00
1380060984.448115: wlan3: freq=2437 MHz
1380060984.448119: wlan3: State: ASSOCIATING -> ASSOCIATED
1380060984.448122: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1380060984.448125: netlink: Operstate: linkmode=-1, operstate=5
1380060984.448252: wlan3: Associated to a new BSS: BSSID=20:e5:2a:01:f7:ea
1380060984.448254: Add randomness: count=218 entropy=153
1380060984.448257: random pool - hexdump(len=128): [REMOVED]
1380060984.448259: random_mix_pool - hexdump(len=16): [REMOVED]
1380060984.448262: random_mix_pool - hexdump(len=6): [REMOVED]
1380060984.448264: random pool - hexdump(len=128): [REMOVED]
1380060984.448403: wlan3: No keys have been configured - skip key clearing
1380060984.448408: wlan3: Associated with 20:e5:2a:01:f7:ea
1380060984.448411: wlan3: WPA: Association event - clear replay counter
1380060984.448414: wlan3: WPA: Clear old PTK
1380060984.448416: EAPOL: External notification - portEnabled=0
1380060984.448419: EAPOL: Supplicant port status: Unauthorized
1380060984.448614: EAPOL: External notification - portValid=0
1380060984.448617: EAPOL: Supplicant port status: Unauthorized
1380060984.448725: EAPOL: External notification - EAP success=0
1380060984.448728: EAPOL: Supplicant port status: Unauthorized
1380060984.448833: EAPOL: External notification - portEnabled=1
1380060984.448836: EAPOL: SUPP_PAE entering state CONNECTING
1380060984.448838: EAPOL: enable timer tick
1380060984.448841: EAPOL: SUPP_BE entering state IDLE
1380060984.448845: wlan3: Setting authentication timeout: 10 sec 0 usec
1380060984.448849: wlan3: Cancelling scan request
1380060984.448873: nl80211: Event message available
1380060984.448888: nl80211: Ignore connect event (cmd=46) when using userspace SME
1380060984.452421: wlan3: RX EAPOL from 20:e5:2a:01:f7:ea
1380060984.452428: RX EAPOL - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 
00 00 00 00 00 92 b8 c6 f1 75 b2 15 37 c3 eb 49 b9 2d fa 54 49 83 42 4e b9 00 32 
b8 68 2d 17 83 c6 8a 55 d7 cc 6e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 16 dd 14 00 0f ac 04 9a 21 ff 5f 52 07 69 ba 95 e1 53 81 98 50 
2f 73
1380060984.452472: wlan3: Setting authentication timeout: 10 sec 0 usec
1380060984.452479: wlan3: IEEE 802.1X RX: version=2 type=3 length=117
1380060984.452482: wlan3:   EAPOL-Key type=2
1380060984.452487: wlan3:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
1380060984.452490: wlan3:   key_length=16 key_data_length=22
1380060984.452492:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 92
1380060984.452497:   key_nonce - hexdump(len=32): b8 c6 f1 75 b2 15 37 c3 eb 49 
b9 2d fa 54 49 83 42 4e b9 00 32 b8 68 2d 17 83 c6 8a 55 d7 cc 6e
1380060984.452508:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
1380060984.452515:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
1380060984.452520:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1380060984.452525:   key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
1380060984.452535: WPA: RX EAPOL-Key - hexdump(len=121): 02 03 00 75 02 00 8a 00 
10 00 00 00 00 00 00 00 92 b8 c6 f1 75 b2 15 37 c3 eb 49 b9 2d fa 54 49 83 42 4e 
b9 00 32 b8 68 2d 17 83 c6 8a 55 d7 cc 6e 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 9a 21 ff 5f 52 07 69 ba 95 e1 53 
81 98 50 2f 73
1380060984.452579: wlan3: State: ASSOCIATED -> 4WAY_HANDSHAKE
1380060984.452689: wlan3: WPA: RX message 1 of 4-Way Handshake from 
20:e5:2a:01:f7:ea (ver=2)
1380060984.452691: RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 9a 
21 ff 5f 52 07 69 ba 95 e1 53 81 98 50 2f 73
1380060984.452700: WPA: PMKID in EAPOL-Key - hexdump(len=22): dd 14 00 0f ac 04 
9a 21 ff 5f 52 07 69 ba 95 e1 53 81 98 50 2f 73
1380060984.452708: RSN: PMKID from Authenticator - hexdump(len=16): 9a 21 ff 5f 
52 07 69 ba 95 e1 53 81 98 50 2f 73
1380060984.452715: wlan3: RSN: no matching PMKID found
1380060984.452718: Get randomness: len=32 entropy=154
1380060984.453343: random from os_get_random - hexdump(len=32): [REMOVED]
1380060984.453359: random_mix_pool - hexdump(len=20): [REMOVED]
1380060984.453364: random from internal pool - hexdump(len=16): [REMOVED]
1380060984.453369: random_mix_pool - hexdump(len=20): [REMOVED]
1380060984.453373: random from internal pool - hexdump(len=16): [REMOVED]
1380060984.453375: mixed random - hexdump(len=32): [REMOVED]
1380060984.453378: WPA: Renewed SNonce - hexdump(len=32): 01 ea 42 a8 4d 73 75 
b7 40 11 7e 37 2d b5 10 f1 11 96 23 e4 6c ee fb 3e 12 1b 8d c6 34 05 e5 06
1380060984.453498: WPA: PTK derivation - A1=1c:65:9d:5a:c3:9d A2=20:e5:2a:01:f7:ea
1380060984.453502: WPA: Nonce1 - hexdump(len=32): 01 ea 42 a8 4d 73 75 b7 40 11 
7e 37 2d b5 10 f1 11 96 23 e4 6c ee fb 3e 12 1b 8d c6 34 05 e5 06
1380060984.453514: WPA: Nonce2 - hexdump(len=32): b8 c6 f1 75 b2 15 37 c3 eb 49 
b9 2d fa 54 49 83 42 4e b9 00 32 b8 68 2d 17 83 c6 8a 55 d7 cc 6e
1380060984.453526: WPA: PMK - hexdump(len=32): [REMOVED]
1380060984.453528: WPA: PTK - hexdump(len=48): [REMOVED]
1380060984.453530: WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f 
ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1380060984.453541: WPA: Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 92
1380060984.453547: wlan3: WPA: Sending EAPOL-Key 2/4
1380060984.453553: WPA: KCK - hexdump(len=16): [REMOVED]
1380060984.453555: WPA: Derived Key MIC - hexdump(len=16): 82 a7 a9 83 fa 60 f2 
6d 62 4c f5 04 0f f8 af 34
1380060984.453562: WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 
00 00 00 00 00 00 00 00 92 01 ea 42 a8 4d 73 75 b7 40 11 7e 37 2d b5 10 f1 11 96 
23 e4 6c ee fb 3e 12 1b 8d c6 34 05 e5 06 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 82 a7 a9 83 fa 60 f2 6d 
62 4c f5 04 0f f8 af 34 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 
0f ac 02 00 00
1380060984.453700: dbus: flush_object_timeout_handler: Timeout - sending changed 
properties of object /fi/w1/wpa_supplicant1/Interfaces/3
1380060984.469955: wlan3: RX EAPOL from 20:e5:2a:01:f7:ea
1380060984.469961: RX EAPOL - hexdump(len=155): 02 03 00 97 02 13 ca 00 10 00 00 
00 00 00 00 00 93 b8 c6 f1 75 b2 15 37 c3 eb 49 b9 2d fa 54 49 83 42 4e b9 00 32 
b8 68 2d 17 83 c6 8a 55 d7 cc 6e 42 4e b9 00 32 b8 68 2d 17 83 c6 8a 55 d7 cc 6f 
61 44 1a 00 00 00 00 00 00 00 00 00 00 00 00 00 54 f2 53 22 36 cd f1 52 c4 9c 5b 
d4 94 7b 44 e9 00 38 5f 3e 85 a3 4a 51 74 0d 57 d5 cb 71 63 65 8b ac 25 22 59 67 
6b 18 6c ae f7 97 ba 0a 64 f2 1c 98 78 e7 8b b2 24 c9 6f b5 b7 f9 73 e2 e8 e4 dc 
6c 14 a9 fd 50 58 20 11 d8
1380060984.470007: wlan3: IEEE 802.1X RX: version=2 type=3 length=151
1380060984.470010: wlan3:   EAPOL-Key type=2
1380060984.470015: wlan3:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise 
Install Ack MIC Secure Encr)
1380060984.470018: wlan3:   key_length=16 key_data_length=56
1380060984.470020:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 93
1380060984.470025:   key_nonce - hexdump(len=32): b8 c6 f1 75 b2 15 37 c3 eb 49 
b9 2d fa 54 49 83 42 4e b9 00 32 b8 68 2d 17 83 c6 8a 55 d7 cc 6e
1380060984.470036:   key_iv - hexdump(len=16): 42 4e b9 00 32 b8 68 2d 17 83 c6 
8a 55 d7 cc 6f
1380060984.470043:   key_rsc - hexdump(len=8): 61 44 1a 00 00 00 00 00
1380060984.470048:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1380060984.470052:   key_mic - hexdump(len=16): 54 f2 53 22 36 cd f1 52 c4 9c 5b 
d4 94 7b 44 e9
1380060984.470062: WPA: RX EAPOL-Key - hexdump(len=155): 02 03 00 97 02 13 ca 00 
10 00 00 00 00 00 00 00 93 b8 c6 f1 75 b2 15 37 c3 eb 49 b9 2d fa 54 49 83 42 4e 
b9 00 32 b8 68 2d 17 83 c6 8a 55 d7 cc 6e 42 4e b9 00 32 b8 68 2d 17 83 c6 8a 55 
d7 cc 6f 61 44 1a 00 00 00 00 00 00 00 00 00 00 00 00 00 54 f2 53 22 36 cd f1 52 
c4 9c 5b d4 94 7b 44 e9 00 38 5f 3e 85 a3 4a 51 74 0d 57 d5 cb 71 63 65 8b ac 25 
22 59 67 6b 18 6c ae f7 97 ba 0a 64 f2 1c 98 78 e7 8b b2 24 c9 6f b5 b7 f9 73 e2 
e8 e4 dc 6c 14 a9 fd 50 58 20 11 d8
1380060984.470127: RSN: encrypted key data - hexdump(len=56): 5f 3e 85 a3 4a 51 
74 0d 57 d5 cb 71 63 65 8b ac 25 22 59 67 6b 18 6c ae f7 97 ba 0a 64 f2 1c 98 78 
e7 8b b2 24 c9 6f b5 b7 f9 73 e2 e8 e4 dc 6c 14 a9 fd 50 58 20 11 d8
1380060984.470163: WPA: decrypted EAPOL-Key key data - hexdump(len=48): [REMOVED]
1380060984.470168: wlan3: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
1380060984.470172: wlan3: WPA: RX message 3 of 4-Way Handshake from 
20:e5:2a:01:f7:ea (ver=2)
1380060984.470174: WPA: IE KeyData - hexdump(len=48): 30 14 01 00 00 0f ac 04 01 
00 00 0f ac 04 01 00 00 0f ac 02 0c 00 dd 16 00 0f ac 01 01 00 6a 84 ef c7 88 2e 
78 30 d8 21 9e 13 f1 72 05 55 dd 00
1380060984.470304: WPA: RSN IE in EAPOL-Key - hexdump(len=22): 30 14 01 00 00 0f 
ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
1380060984.470314: WPA: GTK in EAPOL-Key - hexdump(len=24): [REMOVED]
1380060984.470321: wlan3: WPA: Sending EAPOL-Key 4/4
1380060984.470328: WPA: KCK - hexdump(len=16): [REMOVED]
1380060984.470330: WPA: Derived Key MIC - hexdump(len=16): 8a 6a 7c fb 7d 2f 8b 
d1 33 d7 57 fe 7f 31 35 b4
1380060984.470337: WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 
00 00 00 00 00 00 00 00 93 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8a 6a 7c fb 7d 2f 8b d1 
33 d7 57 fe 7f 31 35 b4 00 00
1380060984.470457: wlan3: WPA: Installing PTK to the driver
1380060984.470552: wpa_driver_nl80211_set_key: ifindex=22 alg=3 addr=0x6f9ec8 
key_idx=0 set_tx=1 seq_len=6 key_len=16
1380060984.470568:    addr=20:e5:2a:01:f7:ea
1380060984.471873: EAPOL: External notification - portValid=1
1380060984.471879: wlan3: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
1380060984.471981: RSN: received GTK in pairwise handshake - hexdump(len=18): 
[REMOVED]
1380060984.471985: WPA: Group Key - hexdump(len=16): [REMOVED]
1380060984.471989: wlan3: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=16)
1380060984.471991: WPA: RSC - hexdump(len=6): 61 44 1a 00 00 00
1380060984.472044: wpa_driver_nl80211_set_key: ifindex=22 alg=3 addr=0x492909 
key_idx=1 set_tx=0 seq_len=6 key_len=16
1380060984.472051:    broadcast key
1380060984.473171: wlan3: WPA: Key negotiation completed with 20:e5:2a:01:f7:ea 
[PTK=CCMP GTK=CCMP]
1380060984.473174: wlan3: Cancelling authentication timeout
1380060984.473178: wlan3: State: GROUP_HANDSHAKE -> COMPLETED
1380060984.473183: wlan3: CTRL-EVENT-CONNECTED - Connection to 20:e5:2a:01:f7:ea 
completed (reauth) [id=0 id_str=]
1380060984.473185: wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
1380060984.473189: netlink: Operstate: linkmode=-1, operstate=6
1380060984.473598: EAPOL: External notification - portValid=1
1380060984.473604: EAPOL: External notification - EAP success=1
1380060984.473607: EAPOL: SUPP_PAE entering state AUTHENTICATING
1380060984.473609: EAPOL: SUPP_BE entering state SUCCESS
1380060984.473611: EAP: EAP entering state DISABLED
1380060984.473613: EAPOL: SUPP_PAE entering state AUTHENTICATED
1380060984.473614: EAPOL: Supplicant port status: Authorized
1380060984.473733: EAPOL: SUPP_BE entering state IDLE
1380060984.473737: EAPOL authentication completed successfully
1380060984.473866: RTM_NEWLINK: operstate=1 ifi_flags=0x11043 
([UP][RUNNING][LOWER_UP])
1380060984.473870: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
1380060984.473917: nl80211: if_removed already cleared - ignore event
1380060984.473929: Ignore event for foreign ifindex 22
1380060984.477063: dbus: flush_object_timeout_handler: Timeout - sending changed 
properties of object /fi/w1/wpa_supplicant1/Interfaces/3
1380060985.449860: EAPOL: startWhen --> 0
1380060985.449872: EAPOL: disable timer tick

Any advice on how to debug this will be appreciated.

Thanks,

Larry

