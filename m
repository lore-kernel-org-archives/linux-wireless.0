Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:47445 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890AbYIVSiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 14:38:10 -0400
Message-ID: <CB9B2237C21D46F3B852E45F75E91C52@soleil> (sfid-20080922_203816_878598_AC98161B)
From: "Philippe Waroquiers" <philippe.waroquiers@skynet.be>
To: <linux-wireless@vger.kernel.org>
Subject: prism54 stopped working after upgrade from kernel 2.6.25.14-69.fc8 to 2.6.26.3-14.fc8
Date: Mon, 22 Sep 2008 20:38:04 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new kernel 2.6.26.3-14.fc8, I see that the prism54 card looks in a correct working mode
(e.g. /sbin/iwlist wlan0 scan shows good scan results).
But after that, wpa_supplicant cannot associate (gets a timeout)
(while it works ok with 2.6.25.14-69.fc8)
I have put below the output of wpa_supplicant for the bad case
and for the good case.

What can I do to further see what is going wrong ?

Thanks



02:00.0 Network controller: Intersil Corporation ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
        Subsystem: Z-Com, Inc. Unknown device 0036
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 32 (2500ns min, 7000ns max), Cache Line Size: 128 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fa400000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: prism54pci
        Kernel modules: p54pci, prism54

bad:
*******************************
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - Initializing interface 'wlan0' conf '/etc/wpa_supplicant/wpa_supplicant.conf' driver 'default' 
ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant/wpa_supplicant.conf' -> '/etc/wpa_supplicant/wpa_supplicant.conf'
Reading configuration file '/etc/wpa_supplicant/wpa_supplicant.conf'
ctrl_interface='/var/run/wpa_supplicant'
ctrl_interface_group='wheel' (DEPRECATED)
Priority group 0
   id=0 ssid='USR9111'
Initializing interface (2) 'wlan0'
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf
WEXT: Operstate: linkmode=1, operstate=5
Own MAC address: 00:60:b3:a1:8b:81
wpa_driver_wext_set_wpa
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_countermeasures
wpa_driver_wext_set_drop_unencrypted
Setting scan request: 0 sec 100000 usec
ctrl_interface_group=10 (from group name 'wheel')
Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b06 len=8
State: DISCONNECTED -> SCANNING
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=7):
     55 53 52 39 31 31 31                              USR9111
Trying to get current scan results first without requesting a new scan to speed up initial association
Received 312 bytes of scan results (1 BSSes)
Scan results: 1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:14:c1:2a:38:12 ssid='USR9111' wpa_ie_len=24 rsn_ie_len=22 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:14:c1:2a:38:12 ssid='USR9111'
Try to find non-WPA AP
Trying to associate with 00:14:c1:2a:38:12 (SSID='USR9111' freq=2462 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 04 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 01 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RSN: added PMKSA cache candidate 00:14:c1:2a:38:12 prio 1000
RSN: processing PMKSA candidate list
RSN: not in suitable state for new pre-authentication
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b04 len=12
Authentication with 00:14:c1:2a:38:12 timed out.
Added BSSID 00:14:c1:2a:38:12 into blacklist
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 5 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b19 len=8
Received 311 bytes of scan results (1 BSSes)
Scan results: 1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:14:c1:2a:38:12 ssid='USR9111' wpa_ie_len=24 rsn_ie_len=22 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:14:c1:2a:38:12 ssid='USR9111'
Try to find non-WPA AP
Trying to associate with 00:14:c1:2a:38:12 (SSID='USR9111' freq=2462 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 04 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 01 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RSN: added PMKSA cache candidate 00:14:c1:2a:38:12 prio 1000
RSN: processing PMKSA candidate list
RSN: not in suitable state for new pre-authentication
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b04 len=12
Authentication with 00:14:c1:2a:38:12 timed out.
BSSID 00:14:c1:2a:38:12 blacklist count incremented to 2
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=7):
     55 53 52 39 31 31 31                              USR9111
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b19 len=8
Received 312 bytes of scan results (1 BSSes)
Scan results: 1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:14:c1:2a:38:12 ssid='USR9111' wpa_ie_len=24 rsn_ie_len=22 caps=0x11
   skip - blacklisted
Try to find non-WPA AP
0: 00:14:c1:2a:38:12 ssid='USR9111' wpa_ie_len=24 rsn_ie_len=22 caps=0x11
   skip - blacklisted
No APs found - clear blacklist and try again
Removed BSSID 00:14:c1:2a:38:12 from blacklist (clear)
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:14:c1:2a:38:12 ssid='USR9111' wpa_ie_len=24 rsn_ie_len=22 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:14:c1:2a:38:12 ssid='USR9111'
Try to find non-WPA AP
Trying to associate with 00:14:c1:2a:38:12 (SSID='USR9111' freq=2462 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 04 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 01 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RSN: added PMKSA cache candidate 00:14:c1:2a:38:12 prio 1000
RSN: processing PMKSA candidate list
RSN: not in suitable state for new pre-authentication
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b04 len=12
Authentication with 00:14:c1:2a:38:12 timed out.
Added BSSID 00:14:c1:2a:38:12 into blacklist
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b19 len=8
Received 311 bytes of scan results (1 BSSes)
Scan results: 1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:14:c1:2a:38:12 ssid='USR9111' wpa_ie_len=24 rsn_ie_len=22 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:14:c1:2a:38:12 ssid='USR9111'
Try to find non-WPA AP
Trying to associate with 00:14:c1:2a:38:12 (SSID='USR9111' freq=2462 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 04 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 01 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RSN: added PMKSA cache candidate 00:14:c1:2a:38:12 prio 1000
RSN: processing PMKSA candidate list
RSN: not in suitable state for new pre-authentication
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b04 len=12
Authentication with 00:14:c1:2a:38:12 timed out.
BSSID 00:14:c1:2a:38:12 blacklist count incremented to 2
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=7):
     55 53 52 39 31 31 31                              USR9111
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b19 len=8
Received 311 bytes of scan results (1 BSSes)
Scan results: 1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:14:c1:2a:38:12 ssid='USR9111' wpa_ie_len=24 rsn_ie_len=22 caps=0x11
   skip - blacklisted
Try to find non-WPA AP
0: 00:14:c1:2a:38:12 ssid='USR9111' wpa_ie_len=24 rsn_ie_len=22 caps=0x11
   skip - blacklisted
No APs found - clear blacklist and try again
Removed BSSID 00:14:c1:2a:38:12 from blacklist (clear)
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:14:c1:2a:38:12 ssid='USR9111' wpa_ie_len=24 rsn_ie_len=22 caps=0x11
   selected based on RSN IE
   sell2_packet_receive - recvfrom: Network is down
ected WPA AP 00:14:c1:2a:38:12 ssid='USR9111'
Try to find non-WPA AP
Trying to associate with 00:14:c1:2a:38:12 (SSID='USR9111' freq=2462 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 04 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 01 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RSN: added PMKSA cache candidate 00:14:c1:2a:38:12 prio 1000
RSN: processing PMKSA candidate list
RSN: not in suitable state for new pre-authentication
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b04 len=12
Authentication with 00:14:c1:2a:38:12 timed out.
Added BSSID 00:14:c1:2a:38:12 into blacklist
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b19 len=8
Received 311 bytes of scan results (1 BSSes)
Scan results: 1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:14:c1:2a:38:12 ssid='USR9111' wpa_ie_len=24 rsn_ie_len=22 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:14:c1:2a:38:12 ssid='USR9111'
Try to find non-WPA AP
Trying to associate with 00:14:c1:2a:38:12 (SSID='USR9111' freq=2462 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 04 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 01 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RSN: added PMKSA cache candidate 00:14:c1:2a:38:12 prio 1000
RSN: processing PMKSA candidate list
RSN: not in suitable state for new pre-authentication
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b04 len=12
Ignore event for foreign ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
CTRL-EVENT-TERMINATING - signal 15 received
Removing interface wlan0
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Opeioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - rstate: linkmode=-1, operstate=5
No keys have been configured - skip key clearing
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
wpa_driver_wext_set_wpa
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_countermeasures
No keys have been configured - skip key clearing
Removed BSSID 00:14:c1:2a:38:12 from blacklist (clear)
Cancelling scan request
Cancelling authentication timeout
WEXT: Operstate: linkmode=0, operstate=6



good:
**********************************************
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - Initializing interface 'wlan0' conf '/etc/wpa_supplicant/wpa_supplicant.conf' driver 'default' 
ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant/wpa_supplicant.conf' -> '/etc/wpa_supplicant/wpa_supplicant.conf'
Reading configuration file '/etc/wpa_supplicant/wpa_supplicant.conf'
ctrl_interface='/var/run/wpa_supplicant'
ctrl_interface_group='wheel' (DEPRECATED)
Priority group 0
   id=0 ssid='USR9111'
Initializing interface (2) 'wlan0'
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf
WEXT: Operstate: linkmode=1, operstate=5
Own MAC address: 00:60:b3:a1:8b:81
wpa_driver_wext_set_wpa
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_countermeasures
wpa_driver_wext_set_drop_unencrypted
Setting scan request: 0 sec 100000 usec
ctrl_interface_group=10 (from group name 'wheel')
Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b06 len=8
State: DISCONNECTED -> SCANNING
Starting AP scan (specific SSID)
Scan SSID - hexdump_ascii(len=7):
     55 53 52 39 31 31 31                              USR9111
Trying to get current scan results first without requesting a new scan to speed up initial association
Received 312 bytes of scan results (1 BSSes)
Scan results: 1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:14:c1:2a:38:12 ssid='USR9111' wpa_ie_len=24 rsn_ie_len=22 caps=0x11
   selected based on RSN IE
   selected WPA AP 00:14:c1:2a:38:12 ssid='USR9111'
Try to find non-WPA AP
Trying to associate with 00:14:c1:2a:38:12 (SSID='USR9111' freq=2462 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 04 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 01 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
Setting authentication timeout: 20 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RSN: added PMKSA cache candidate 00:14:c1:2a:38:12 prio 1000
RSN: processing PMKSA candidate list
RSN: not in suitable state for new pre-authentication
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b04 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8c02 len=161
Association info event
req_ies - hexdump(len=47): 00 07 55 53 52 39 31 31 31 01 08 02 04 0b 16 0c 12 18 24 32 04 30 48 60 6c 30 14 01 00 00 0f ac 04 01 00 
00 0f ac 04 01 00 00 0f ac 02 00 00
resp_ies - hexdump(len=16): 01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Wireless event: cmd=0x8b15 len=20
Wireless event: new AP: 00:14:c1:2a:38:12
State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:14:c1:2a:38:12
No keys have been configured - skip key clearing
Associated with 00:14:c1:2a:38:12
WPA: Association event - clear replay counter
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RX EAPOL from 00:14:c1:2a:38:12
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=1 type=3 length=117
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=22
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 02 91
  key_nonce - hexdump(len=32): d8 8b 4f 2a 57 96 ef 62 ed 9c 0d 33 fb 0a 15 5e fe 3a 66 e3 a7 bf 49 09 e9 fd 7b d2 a7 46 c7 98
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:14:c1:2a:38:12 (ver=2)
RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 36 2d b4 7d a8 db 2b 82 2c d2 ed dc 01 5f 2a 40
RSN: PMKID from Authenticator - hexdump(len=16): 36 2d b4 7d a8 db 2b 82 2c d2 ed dc 01 5f 2a 40
RSN: no matching PMKID found
WPA: Renewed SNonce - hexdump(len=32): 8b e6 d2 87 c3 7c cd eb 78 f6 49 6b 78 75 c7 14 3d b8 7a 7d dc 17 51 37 d7 04 0d f8 4f 28 35 
61
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
RX EAPOL from 00:14:c1:2a:38:12
IEEE 802.1X RX: version=1 type=3 length=151
  EAPOL-Key type=2
  key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
  key_length=16 key_data_length=56
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 02 92
  key_nonce - hexdump(len=32): d8 8b 4f 2a 57 96 ef 62 ed 9c 0d 33 fb 0a 15 5e fe 3a 66 e3 a7 bf 49 09 e9 fd 7b d2 a7 46 c7 98
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 68 00 60 9a 0a 9d f3 43 9d 56 dc 95 c4 fa eb 7f
RSN: encrypted key data - hexdump(len=56): 85 00 74 bf e3 30 0d 7f 1a 61 0b af 88 8a a1 18 eb a7 41 27 dc e8 7f 66 a4 9e 25 79 50 8b 
ca 7d 85 44 a8 3d ae fc ec bb c7 ca 3c ad 61 47 fb 47 a6 60 ff 2d 89 02 63 0c
WPA: decrypted EAPOL-Key key data - hexdump(len=48): [REMOVED]
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from 00:14:c1:2a:38:12 (ver=2)
WPA: IE KeyData - hexdump(len=48): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 01 00 dd 16 00 0f ac 01 02 00 cb 69 
43 2d 9f eb ae 44 7d 2e 92 85 8e b7 d0 ac dd 00
WPA: Sending EAPOL-Key 4/4
WPA: Installing PTK to the driver.
wpa_driver_wext_set_key: alg=3 key_idx=0 set_tx=1 seq_len=6 key_len=16
EAPOL: External notification - portValid=1
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RSN: received GTK in pairwise handshake - hexdump(len=18): [REMOVED]
WPA: Group Key - hexdump(len=16): [REMOVED]
WPA: Installing GTK to the driver (keyidx=2 tx=0).
WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
wpa_driver_wext_set_key: alg=3 key_idx=2 set_tx=0 seq_len=6 key_len=16
WPA: Key negotiation completed with 00:14:c1:2a:38:12 [PTK=CCMP GTK=CCMP]
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:14:c1:2a:38:12 completed (auth) [id=0 id_str=]
wpa_driver_wext_set_operstate: operstate 0->1 (UP)
WEXT: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: SUPP_BE entering state IDLE
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RSN: processing PMKSA candidate list
RSN: not in suitable state for new pre-authentication
EAPOL: startWhen --> 0
RX EAPOL from 00:14:c1:2a:38:12
IEEE 802.1X RX: version=1 type=3 length=127
  EAPOL-Key type=2
  key_info 0x1382 (ver=2 keyidx=0 rsvd=0 Group Ack MIC Secure Encr)
  key_length=0 key_data_length=32
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 02 93
  key_nonce - hexdump(len=32): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): d6 a2 eb bb 78 d0 00 fe d7 c8 6c 9d d6 d0 b6 a2
RSN: encrypted key data - hexdump(len=32): d0 a1 f4 c4 17 be 4d 26 5f eb 1f 08 fb 7c cd 3a a4 16 de 9a 99 12 70 76 5a 1c 49 37 88 d9 
4d 50
WPA: decrypted EAPOL-Key key data - hexdump(len=24): [REMOVED]
WPA: RX message 1 of Group Key Handshake from 00:14:c1:2a:38:12 (ver=2)
RSN: msg 1/2 key data - hexdump(len=24): dd 16 00 0f ac 01 03 00 03 ea f8 37 c1 df 36 ae 54 65 ca 9a 0b 87 44 23
RSN: received GTK in group key handshake - hexdump(len=18): 03 00 03 ea f8 37 c1 df 36 ae 54 65 ca 9a 0b 87 44 23
State: COMPLETED -> GROUP_HANDSHAKE
WPA: Group Key - hexdump(len=16): [REMOVED]
WPA: Installing GTK to the driver (keyidx=3 tx=0).
WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
wpa_driver_wext_set_key: alg=3 key_idx=3 set_tx=0 seq_len=6 key_len=16
WPA: Sending EAPOL-Key 2/2
WPA: Group rekeying completed with 00:14:c1:2a:38:12 [GTK=CCMP]
State: GROUP_HANDSHAKE -> COMPLETED
RX EAPOL from 00:14:c1:2a:38:12
IEEE 802.1X RX: version=1 type=3 length=127
  EAPOL-Key type=2
  key_info 0x1382 (ver=2 keyidx=0 rsvd=0 Group Ack MIC Secure Encr)
  key_length=0 key_data_length=32
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 02 94
  key_nonce - hexdump(len=32): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): b7 2f f0 aa 0b 0f 9b 1e 10 21 46 a2 c0 42 7b 58
RSN: encrypted key data - hexdump(len=32): a7 b3 e8 31 81 8d 2c b6 2f 9c 16 46 00 5a 93 10 5a a3 1c c9 1a ba 59 72 9a be e3 4c 1a 7e 
b8 ae
WPA: decrypted EAPOL-Key key data - hexdump(len=24): [REMOVED]
WPA: RX message 1 of Group Key Handshake from 00:14:c1:2a:38:12 (ver=2)
RSN: msg 1/2 key data - hexdump(len=24): dd 16 00 0f ac 01 02 00 8d 82 fd a0 fe 23 09 16 44 7b d3 7d e2 75 ea 57
RSN: received GTK in group key handshake - hexdump(len=18): 02 00 8d 82 fd a0 fe 23 09 16 44 7b d3 7d e2 75 ea 57
State: COMPLETED -> GROUP_HANDSHAKE
WPA: Group Key - hexdump(len=16): [REMOVED]
WPA: Installing GTK to the driver (keyidx=2 tx=0).
WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
wpa_driver_wext_set_key: alg=3 key_idx=2 set_tx=0 seq_len=6 key_len=16
WPA: Sending EAPOL-Key 2/2
WPA: Group rekeying completed with 00:14:c1:2a:38:12 [GTK=CCMP]
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-TERMINATING - signal 15 received
Removing interface wlan0
State: COMPLETED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 1->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_deauthenticate
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idxioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - =0 set_tx=0 seq_len=0 key_len=0
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
wpa_driver_wext_set_wpa
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_countermeasures
No keys have been configured - skip key clearing
Cancelling scan request
Cancelling authentication timeout
WEXT: Operstate: linkmode=0, operstate=6

