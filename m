Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.vmgattei.com ([77.223.18.35]:54278 "EHLO mx.vmgattei.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933635AbaCUJbA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 05:31:00 -0400
Received: from localhost (mx.vmgattei.com [127.0.0.1])
	by mx.vmgattei.com (Postfix) with ESMTP id 9613C1FF25
	for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 10:22:04 +0100 (CET)
Received: from mx.vmgattei.com ([127.0.0.1])
	by localhost (mx.vmgattei.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VXW7KVjOkhYU for <linux-wireless@vger.kernel.org>;
	Fri, 21 Mar 2014 10:22:02 +0100 (CET)
Message-ID: <532C04B7.9080900@sirius-es.it> (sfid-20140321_103118_729584_64EE0667)
Date: Fri, 21 Mar 2014 10:21:59 +0100
From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Larry.Finger@lwfinger.net
Subject: TL-WN725N with rtl8188eu chip
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to use TL-WN725N dongle with rtl8188eu chip on a beagleboard 
with kernel 3.8.13.
I cross-compiled the https://github.com/lwfinger/rtl8188eu kernel 
standalone driver and I use it with success in ap mode.

My problem is to use this wireless dongle in managed mode as normal client.
When I try to connect to my access point, wpa_supplicant (1.0) give me 
these errors:

# wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf
rfkill: Cannot open RFKILL control device
ioctl[SIOCSIWAP]: Operation not permitted
wlan0: Trying to associate with c0:ac:54:01:b0:68 (SSID='Orange-ac90' 
freq=2437 MHz)
[ 5047.522244] R8188EU: ERROR indicate disassoc
wlan0: CTRL-EVENT-DISCONNECTED bssid=c0:ac:54:01:b0:68 reason=0
wlan0: Trying to associate with c0:ac:54:01:b0:68 (SSID='Orange-ac90' 
freq=2437 MHz)
[ 5050.492941] R8188EU: ERROR indicate disassoc
wlan0: CTRL-EVENT-DISCONNECTED bssid=c0:ac:54:01:b0:68 reason=0


Is this a kernel driver problem or I have to investigate in wpa_supplicant?


Regards,
Matteo


In detail, enabling debug info to wpa_supplicant:
# wpa_supplicant -dd -Dwext -iwlan0 -c/etc/wpa_supplicant.conf

wpa_supplicant v1.0
random: Trying to read entropy from /dev/random
Initializing interface 'wlan0' conf '/etc/wpa_supplicant.conf' driver 
'wext' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant.conf' -> '/etc/wpa_supplicant.conf'
Reading configuration file '/etc/wpa_supplicant.conf'
ctrl_interface='/var/run/wpa_supplicant'
ctrl_interface_group='0'
ap_scan=1
Line: 4 - start of a new network block
ssid - hexdump_ascii(len=11):
      4f 72 61 6e 67 65 2d 61 63 39 30 Orange-ac90
proto: 0x3
key_mgmt: 0x2
pairwise: 0x18
group: 0x18
PSK (ASCII passphrase) - hexdump_ascii(len=26): [REMOVED]
PSK (from passphrase) - hexdump(len=32): [REMOVED]
Priority group 0
    id=0 ssid='Orange-ac90'
rfkill: Cannot open RFKILL con[  231.448649] R8188EU: Firmware Version 
11, SubVersion 1, Signature 0x88e1
trol device
WEXT: RFKILL status not available
[  231.797813] MAC Address = 10:fe:ed:1f:a7:5b
[  231.805615] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
SIOCGIWRANGE: WE(compiled)=22 WE(source)=16 enc_capa=0xf
   capabilities: key_mgmt 0xf enc 0xf flags 0x0
ioctl[SIOCSIWAP]: Operation not permitted
WEXT: Failed to clear BSSID selection on disconnect
netlink: Operstate: linkmode=1, operstate=5
wlan0: Own MAC address: 10:fe:ed:1f:a7:5b
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_countermeasures
wlan0: RSN: flushing PMKID list in the driver
wlan0: Setting scan request: 0 sec 100000 usec
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Using existing control interface directory.
ctrl_interface_group=0
wlan0: Added interface wlan0
random: Got 16/20 bytes from /dev/random
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=40
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 10 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=8
wlan0: Event SCAN_RESULTS (3) received
Received 3152 bytes of scan results (12 BSSes)
wlan0: BSS: Start scan result update 1
wlan0: BSS: Add new id 0 BSSID f8:8e:85:01:f2:13 SSID 'JAZZTEL_F213'
wlan0: BSS: Add new id 1 BSSID 00:19:15:c9:77:01 SSID 'WLAN_7701'
wlan0: BSS: Add new id 2 BSSID 00:1a:2b:63:8f:98 SSID 'WLAN_AC83'
wlan0: BSS: Add new id 3 BSSID c0:ac:54:01:b0:68 SSID 'Orange-ac90'
wlan0: BSS: Add new id 4 BSSID 00:19:70:32:47:6e SSID 'Orange-d7f0'
wlan0: BSS: Add new id 5 BSSID 64:16:f0:55:0c:98 SSID 'vodafone0C97'
wlan0: BSS: Add new id 6 BSSID 5c:33:8e:be:1a:28 SSID 'Orange-46b1'
wlan0: BSS: Add new id 7 BSSID d0:ae:ec:dd:30:00 SSID 'WLAN_3000'
wlan0: BSS: Add new id 8 BSSID 74:31:70:11:c0:07 SSID 'WiFi1C0878'
wlan0: BSS: Add new id 9 BSSID 00:1a:2b:86:fd:c0 SSID 'WLAN_8FBD'
wlan0: BSS: Add new id 10 BSSID 00:a0:26:7c:4e:38 SSID 'WLAN_4E38'
wlan0: BSS: Add new id 11 BSSID 00:1a:2b:8a:19:8d SSID 'RED_MARIA'
Add randomness: count=1 entropy=0
Add randomness: count=2 entropy=1
Add randomness: count=3 entropy=2
Add randomness: count=4 entropy=3
Add randomness: count=5 entropy=4
Add randomness: count=6 entropy=5
Add randomness: count=7 entropy=6
Add randomness: count=8 entropy=7
Add randomness: count=9 entropy=8
Add randomness: count=10 entropy=9
wlan0: New scan results available
wlan0: Selecting BSS from priority group 0
wlan0: 0: f8:8e:85:01:f2:13 ssid='JAZZTEL_F213' wpa_ie_len=24 
rsn_ie_len=0 caps=0x11 level=0
wlan0:    skip - SSID mismatch
wlan0: 1: 00:19:15:c9:77:01 ssid='WLAN_7701' wpa_ie_len=22 rsn_ie_len=0 
caps=0x11 level=0 wps
wlan0:    skip - SSID mismatch
wlan0: 2: 00:1a:2b:63:8f:98 ssid='WLAN_AC83' wpa_ie_len=28 rsn_ie_len=0 
caps=0x11 level=0 wps
wlan0:    skip - SSID mismatch
wlan0: 3: c0:ac:54:01:b0:68 ssid='Orange-ac90' wpa_ie_len=26 
rsn_ie_len=24 caps=0x11 level=0
wlan0:    selected based on RSN IE
wlan0:    selected BSS c0:ac:54:01:b0:68 ssid='Orange-ac90'
wlan0: Request association: reassociate: 0  selected: c0:ac:54:01:b0:68  
bssid: 00:00:00:00:00:00  pending: 00:00:00:00:00:00  wpa_state: SCANNING
wlan0: Trying to associate with c0:ac:54:01:b0:68 (SSID='Orange-ac90' 
freq=2437 MHz)
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 
02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02
WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 
0f ac 04 00 0f ac 02 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 
01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=8
wlan0: Event SCAN_RESULTS (3) received
[  234.674477] R8188EU: ERROR indicate disassoc
Received 0 bytes of scan results (0 BSSes)
wlan0: BSS: Start scan result update 2
wlan0: New scan results available
wlan0: Selecting BSS from priority group 0
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b04 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=19
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b15 len=20
Wireless event: new AP: 00:00:00:00:00:00
wlan0: Event DISASSOC (1) received
wlan0: Disassociation notification
wlan0: WPA: Auto connect enabled: try to reconnect (wps=0)
wlan0: Setting scan request: 0 sec 100000 usec
Added BSSID c0:ac:54:01:b0:68 into blacklist
wlan0: Setting scan request: 0 sec 100000 usec
wlan0: CTRL-EVENT-DISCONNECTED bssid=c0:ac:54:01:b0:68 reason=0
wlan0: Disconnect event - remove keys
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=8
wlan0: Event SCAN_RESULTS (3) received
Received 3275 bytes of scan results (14 BSSes)
wlan0: BSS: Start scan result update 3
wlan0: BSS: Add new id 12 BSSID 58:98:35:48:1c:b0 SSID 'Untouchable'
wlan0: BSS: Add new id 13 BSSID 00:1a:2b:ad:ed:52 SSID 'Refusta'
wlan0: BSS: Add new id 14 BSSID 74:88:8b:7e:40:1d SSID 'WLAN_401C'
wlan0: BSS: Add new id 15 BSSID 00:23:13:04:cf:50 SSID 'VM2'
wlan0: BSS: Add new id 16 BSSID 00:1a:2b:81:4a:3c SSID 'WLAN_5878'
wlan0: BSS: Add new id 17 BSSID 4c:ed:de:34:5b:b1 SSID 'Jazztel_A100'
wlan0: BSS: Expire BSS 5 due to no match in scan
wlan0: BSS: Remove id 5 BSSID 64:16:f0:55:0c:98 SSID 'vodafone0C97'
wlan0: BSS: Expire BSS 6 due to no match in scan
wlan0: BSS: Remove id 6 BSSID 5c:33:8e:be:1a:28 SSID 'Orange-46b1'
wlan0: BSS: Expire BSS 9 due to no match in scan
wlan0: BSS: Remove id 9 BSSID 00:1a:2b:86:fd:c0 SSID 'WLAN_8FBD'
wlan0: BSS: Expire BSS 10 due to no match in scan
wlan0: BSS: Remove id 10 BSSID 00:a0:26:7c:4e:38 SSID 'WLAN_4E38'
Add randomness: count=11 entropy=10
Add randomness: count=12 entropy=11
Add randomness: count=13 entropy=12
Add randomness: count=14 entropy=13
Add randomness: count=15 entropy=14
Add randomness: count=16 entropy=15
Add randomness: count=17 entropy=16
Add randomness: count=18 entropy=17
Add randomness: count=19 entropy=18
Add randomness: count=20 entropy=19
wlan0: New scan results available
wlan0: Selecting BSS from priority group 0
wlan0: 0: 00:19:15:c9:77:01 ssid='WLAN_7701' wpa_ie_len=22 rsn_ie_len=0 
caps=0x11 level=0 wps
wlan0:    skip - SSID mismatch
wlan0: 1: 58:98:35:48:1c:b0 ssid='Untouchable' wpa_ie_len=0 
rsn_ie_len=20 caps=0x11 level=0 wps
wlan0:    skip - SSID mismatch
...
