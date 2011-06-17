Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.calamp.com ([207.71.209.228]:53979 "EHLO MX1.Calamp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932552Ab1FQPXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 11:23:51 -0400
Received: from oxn-mx1.PD.CalAmpCorp.com ([10.6.0.30]) by MX1.Calamp.com with ESMTP id GnlFQ629CxK76UWx (version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 08:23:50 -0700 (PDT)
From: =?iso-8859-1?Q?Fr=E9d=E9ric_Lamorce?= <FLamorce@CalAmp.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 17 Jun 2011 08:23:47 -0700
Subject: nl80211: set_key failed; err=-67 Link has been severed
Message-ID: <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0D4065B927@oxn-mx01.PD.CalAmpCorp.com> (sfid-20110617_172355_144137_7070136A)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Group,

I am using a small evaluation board with an ARM on it, it runs kernel 2.6.27.9. I have an atheros AR9271 wifi card connected via USB.

I successfully compiled compat-wireless, inserted .ko, it works. I then compiled iw, openssl and wpa_supplicant.

If I use iw to connect to a WEP network, it works and I can take an IP address via DHCP and ping the AP.

But with wpa_supplicant, it seems it connects RF wise, seems to authenticate, but I cannot take an IP address nor ping the AP even if I set a static one. I tried with WEP, WPA-TKIP and WPA2-AES, same thing.

My config is simple:

country=CA
ctrl_interface=/var/run/wpa_supplicant
network={
        ssid="wireless"
        key_mgmt=NONE
        wep_key0=0011223344
        wep_tx_keyidx=0
}

iw event logs this:
wlan0 (phy #0): scan started
wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462, ""
wlan0 (phy #0): auth 00:25:9c:d1:d3:85 -> 00:19:70:2c:ef:6d status: 0: Successful
wlan0: new station 00:25:9c:d1:d3:85
wlan0 (phy #0): assoc 00:25:9c:d1:d3:85 -> 00:19:70:2c:ef:6d status: 0: Successful
wlan0 (phy #0): connected to 00:25:9c:d1:d3:85

I enabled -dd with wpa_supplicant, here it is, the only error is "nl80211: set_key failed; err=-67 Link has been severed)", fatal? Why this error? It means the link is down?

14518.692489: Initializing interface 'wlan0' conf '/etc/wpa_supplicant.conf' driver 'default' ctrl_interface 'N/A' bridge 'N/A'
14518.693891: Configuration file '/etc/wpa_supplicant.conf' -> '/etc/wpa_supplicant.conf'
14518.694104: Reading configuration file '/etc/wpa_supplicant.conf'
14518.695415: country='CA'
14518.695690: ctrl_interface='/var/run/wpa_supplicant'
14518.695781: Line: 5 - start of a new network block
14518.696178: ssid - hexdump_ascii(len=8):
     77 69 72 65 6c 65 73 73                           wireless        
14518.696665: key_mgmt: 0x4
14518.697001: wep_key0 - hexdump(len=5): [REMOVED]
14518.697428: wep_tx_keyidx=0 (0x0)
14518.698159: Priority group 0
14518.698281:    id=0 ssid='wireless'
14521.393403: netlink: Operstate: linkmode=1, operstate=5
14521.394958: nl80211: Register Action command failed: ret=-114 (Operation already in progress)
14521.395110: nl80211: Register Action match - hexdump(len=1): 06
14521.395171: nl80211: Failed to register Action frame processing - ignore for now
14521.420812: Own MAC address: 00:19:70:2c:ef:6d
14521.422001: wpa_driver_nl80211_set_key: ifindex=5 alg=0 addr=0xc3aec key_idx=0 set_tx=0 seq_len=0 key_len=0
14521.423464: wpa_driver_nl80211_set_key: ifindex=5 alg=0 addr=0xc3aec key_idx=1 set_tx=0 seq_len=0 key_len=0
14521.424562: wpa_driver_nl80211_set_key: ifindex=5 alg=0 addr=0xc3aec key_idx=2 set_tx=0 seq_len=0 key_len=0
14521.425629: wpa_driver_nl80211_set_key: ifindex=5 alg=0 addr=0xc3aec key_idx=3 set_tx=0 seq_len=0 key_len=0
14521.426421: RSN: flushing PMKID list in the driver
14521.426696: Setting scan request: 0 sec 100000 usec
14521.429775: Added interface wlan0
14521.453830: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
14521.454043: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
14521.530446: State: DISCONNECTED -> SCANNING
14521.530598: Starting AP scan for wildcard SSID
14521.530964: nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
14522.298525: Scan requested (ret=0) - scan timeout 10 seconds
14522.298830: nl80211: Event message available
14522.299623: nl80211: Scan trigger
14526.824318: nl80211: Event message available
14526.824836: nl80211: New scan results available
14526.827184: Received scan results (7 BSSes)
14526.827489: BSS: Start scan result update 1
14526.827641: BSS: Add new id 0 BSSID 00:17:c5:41:8b:35 SSID 'CalAmp-Public'
14526.827854: BSS: Add new id 1 BSSID 00:17:c5:41:8b:34 SSID 'CalAmp-Corp'
14526.828037: BSS: Add new id 2 BSSID 00:22:6b:5e:a5:d4 SSID 'Softline Wireless'
14526.828159: BSS: Add new id 3 BSSID 00:15:70:8f:c0:44 SSID ''
14526.828281: BSS: Add new id 4 BSSID 00:25:9c:d1:d3:85 SSID 'wireless'
14526.828373: BSS: Add new id 5 BSSID 00:15:6d:55:a6:18 SSID 'SENTRY-AP'
14526.828495: BSS: Add new id 6 BSSID 00:21:29:a1:91:6e SSID 'charles'
14526.828586: New scan results available
14526.828647: Selecting BSS from priority group 0
14526.828647: Try to find WPA-enabled AP
14526.828708: 0: 00:17:c5:41:8b:35 ssid='CalAmp-Public' wpa_ie_len=22 rsn_ie_len=0 caps=0x411
14526.828921:    skip - SSID mismatch
14526.828982: 1: 00:17:c5:41:8b:34 ssid='CalAmp-Corp' wpa_ie_len=22 rsn_ie_len=0 caps=0x411
14526.829440:    skip - SSID mismatch
14526.829501: 2: 00:22:6b:5e:a5:d4 ssid='Softline Wireless' wpa_ie_len=28 rsn_ie_len=24 caps=0x411
14526.829592:    skip - SSID mismatch
14526.829623: 3: 00:15:70:8f:c0:44 ssid='' wpa_ie_len=24 rsn_ie_len=20 caps=0x2011
14526.829653:    skip - SSID mismatch
14526.829684: 4: 00:25:9c:d1:d3:85 ssid='wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x411
14526.829745:    skip - no WPA/RSN IE
14526.829775: 5: 00:15:6d:55:a6:18 ssid='SENTRY-AP' wpa_ie_len=0 rsn_ie_len=0 caps=0x421
14526.829836:    skip - no WPA/RSN IE
14526.829836: 6: 00:21:29:a1:91:6e ssid='charles' wpa_ie_len=0 rsn_ie_len=0 caps=0x401
14526.829897:    skip - no WPA/RSN IE
14526.829928: Try to find non-WPA AP
14526.830568: 0: 00:17:c5:41:8b:35 ssid='CalAmp-Public' wpa_ie_len=22 rsn_ie_len=0 caps=0x411
14526.830751:    skip - SSID mismatch
14526.830812: 1: 00:17:c5:41:8b:34 ssid='CalAmp-Corp' wpa_ie_len=22 rsn_ie_len=0 caps=0x411
14526.830873:    skip - SSID mismatch
14526.831300: 2: 00:22:6b:5e:a5:d4 ssid='Softline Wireless' wpa_ie_len=28 rsn_ie_len=24 caps=0x411
14526.831391:    skip - SSID mismatch
14526.831452: 3: 00:15:70:8f:c0:44 ssid='' wpa_ie_len=24 rsn_ie_len=20 caps=0x2011
14526.831513:    skip - SSID mismatch
14526.831513: 4: 00:25:9c:d1:d3:85 ssid='wireless' wpa_ie_len=0 rsn_ie_len=0 caps=0x411
14526.831604:    selected non-WPA AP 00:25:9c:d1:d3:85 ssid='wireless'
14526.831848: Automatic auth_alg selection: 0x1
14526.831940: WPA: clearing AP WPA IE
14526.831970: WPA: clearing AP RSN IE
14526.832001: WPA: clearing own WPA/RSN IE
14526.832123: Cancelling scan request
14526.832214: Trying to authenticate with 00:25:9c:d1:d3:85 (SSID='wireless' freq=2412 MHz)
14526.832245: No keys have been configured - skip key clearing
14526.832275: State: SCANNING -> AUTHENTICATING
14526.833312: nl80211: Authenticate (ifindex=5)
14526.833800: wpa_driver_nl80211_set_key: ifindex=5 alg=1 addr=(nil) key_idx=0 set_tx=1 seq_len=0 key_len=5
14526.834867: nl80211: set_key failed; err=-67 Link has been severed)
14526.835659:   * bssid=00:25:9c:d1:d3:85
14526.835751:   * freq=2412
14526.835781:   * SSID - hexdump_ascii(len=8):
     77 69 72 65 6c 65 73 73                           wireless        
14526.835903:   * IEs - hexdump(len=0): [NULL]
14526.835934:   * Auth Type 0
14528.720751: nl80211: Authentication request send successfully
14528.721025: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
14528.721117: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
14529.930751: nl80211: Event message available
14529.931269: nl80211: MLME event 37
14529.931360: nl80211: MLME event frame - hexdump(len=41): b0 00 3a 01 00 19 70 2c ef 6d 00 25 9c d1 d3 85 00 25 9c d1 d3 85 40 80 00 00 02 00 00 00 dd 09 00 10 18 02 00 f0 05 00 00
14529.931665: SME: Authentication response: peer=00:25:9c:d1:d3:85 auth_type=0 status_code=0
14529.931726: SME: Authentication response IEs - hexdump(len=11): dd 09 00 10 18 02 00 f0 05 00 00
14529.931909: Trying to associate with 00:25:9c:d1:d3:85 (SSID='wireless' freq=2412 MHz)
14529.932336: State: AUTHENTICATING -> ASSOCIATING
14529.932428: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
14529.932489: netlink: Operstate: linkmode=-1, operstate=5
14529.932702: SME: Could not parse own IEs?!
14529.932793: WPA: clearing own WPA/RSN IE
14529.932915: nl80211: Associate (ifindex=5)
14529.933007:   * bssid=00:25:9c:d1:d3:85
14529.933068:   * freq=2412
14529.933098:   * SSID - hexdump_ascii(len=8):
     77 69 72 65 6c 65 73 73                           wireless        
14529.933220:   * IEs - hexdump(len=0): [NULL]
14530.731086: nl80211: Association request send successfully
14531.746208: nl80211: Event message available
14531.746726: nl80211: Ignored unknown event (cmd=19)
14532.909287: nl80211: Event message available
14532.909806: nl80211: MLME event 38
14532.909897: nl80211: MLME event frame - hexdump(len=135): 10 00 3a 01 00 19 70 2c ef 6d 00 25 9c d1 d3 85 00 25 9c d1 d3 85 70 81 11 04 00 00 01 c0 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a ee 18 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 01 0d 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 00 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
14532.911787: Association info event
14532.911848: resp_ies - hexdump(len=105): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a ee 18 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 01 0d 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 00 f0 05 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
14532.912458: freq=2412 MHz
14532.912489: State: ASSOCIATING -> ASSOCIATED
14532.912550: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
14532.912580: netlink: Operstate: linkmode=-1, operstate=5
14532.912946: Associated to a new BSS: BSSID=00:25:9c:d1:d3:85
14532.913068: Associated with 00:25:9c:d1:d3:85
14532.913251: WPA: Association event - clear replay counter
14532.913678: WPA: Clear old PTK
14532.913830: Cancelling authentication timeout
14532.913891: State: ASSOCIATED -> COMPLETED
14532.913982: CTRL-EVENT-CONNECTED - Connection to 00:25:9c:d1:d3:85 completed (auth) [id=0 id_str=]
14532.914043: wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
14532.914074: netlink: Operstate: linkmode=-1, operstate=6
14532.914318: Cancelling scan request
14532.914745: wpa_driver_nl80211_set_key: ifindex=5 alg=1 addr=0xc3aec key_idx=0 set_tx=1 seq_len=0 key_len=5
14532.919806: RTM_NEWLINK: operstate=1 ifi_flags=0x11003 ([UP][LOWER_UP])
14532.930415: netlink: Operstate: linkmode=-1, operstate=6
14532.931269: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
14532.931482: RTM_NEWLINK: operstate=1 ifi_flags=0x11003 ([UP][LOWER_UP])
14532.931543: netlink: Operstate: linkmode=-1, operstate=6
14532.931726: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
14532.931848: RTM_NEWLINK: operstate=1 ifi_flags=0x11003 ([UP][LOWER_UP])
14532.931909: netlink: Operstate: linkmode=-1, operstate=6
14532.932550: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
14532.932732: RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
14532.932793: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
14532.933007: nl80211: Event message available
14532.933403: nl80211: Ignore connect event (cmd=46) when using userspace SME

