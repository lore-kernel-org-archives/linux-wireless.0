Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailhost.actiasodielec.fr ([217.108.146.49]:42720 "EHLO
	mailhost.actiasodielec.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab1DNJpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 05:45:03 -0400
Received: (from uucp@localhost)
	by mailhost.actiasodielec.fr id p3E9W2En027121
	for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 11:32:02 +0200
From: =?iso-8859-1?Q?C=E9dric_MOLINIER?= <c.molinier@actiasodielec.fr>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 14 Apr 2011 11:31:07 +0200
Subject: Problem Mesh security with ath9k and hostap-sae: mesh points can't
 authenticate
Message-ID: <EE97821C81277E459BEA5C6384C6F24101086A274525@srvexch01.SODIELEC.local>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On my embedded system, I'm trying to use the tools for authenticated MESH. 
I am using the fork of wpa_supplicant available that can authenticate mesh peers, available here:https://github.com/cozybit/hostap-sae.
I followed what is described in the open80211s HOW page (http://o11s.org/trac/wiki/HOWTO#Testing).

But, none Mesh Point does not authenticate.

So can someone tell me what is the problem, please? 

Below, you can see my configuration and the output debug of wpa_supplicant (SAE).
You can see a station (MP) is detected ("nl80211: New station 00:15:61:10:4f:7d"),
but wpa_supplicant reject it:
   mesh0: 0: 00:15:61:10:4f:7d ssid='' wpa_ie_len=0 rsn_ie_len=20 caps=0x0 level=-67
   mesh0:    skip - SSID not known


Thanks. 

C. Molinier



I have two Mesh Point (MP) (with the same configuration):
- MP(A) with MAC address 00:0B:6B:B5:EC:37
- MP(B) with MAC address 00:15:61:10:4f:7d

I use:
- kernel 2.6.27
- compat-wireless 2.6.39-rc1-3 for ath9k driver
- hostapd-sae 


The wpa_supplicant configuration (mesh.conf) is:
ctrl_interface=/var/run/wpa_supplicant
# Mesh network with SAE authentication
network={
	ssid="test"
	mode=5
	frequency=5180
	proto=RSN
	key_mgmt=SAE
	pairwise=CCMP
	group=CCMP
	psk="this is a secret place"
	sae_group_list=19 26 21 25 20
}



To start the mesh point, I do:

iw dev wlan0 interface add mesh0 type mp mesh_id test
iw dev mesh0 set channel 36
ifconfig mesh0 up 
ifconfig mesh0 <ip address>
wpa_supplicant -Dnl80211 -imesh0 -c mesh.conf -dd &



The output debug on MP(A) is:

[    7.083217] kfifo: module license 'unspecified' taints kernel.
[    7.142819] Compat-wireless backport release: compat-wireless-v2.6.39-rc1-3
[    7.150047] Backport based on linux-2.6-allstable.git v2.6.39-rc1
[    7.344937] Calling CRDA to update world regulatory domain
[    9.460659] Registered led device: ath9k-phy0
[    9.465220] ieee80211 phy0: Atheros AR9160 MAC/BB Rev:1 AR5133 RF Rev:b0 mem=0xd20c0000, irq=66
wpa_supplicant v0.8.x
Initializing interface 'mesh0' conf '/mnt/flash-config/mesh.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/mnt/flash-config/mesh.conf' -> '/mnt/flash-config/mesh.conf'
Reading configuration file '/mnt/flash-config/mesh.conf'
ctrl_interface='/var/run/wpa_supplicant'
Line: 3 - start of a new network block
ssid - hexdump_ascii(len=4):
     74 65 73 74                                       test            
mode=5 (0x5)
frequency=5180 (0x143c)
proto: 0x2
key_mgmt: 0x400
pairwise: 0x10
group: 0x10
PSK (ASCII passphrase) - hexdump_ascii(len=22): [REMOVED]
Priority group 0
   id=0 ssid='test'
nl80211: interface mesh0 in phy phy0
rfkill: Cannot open RFKILL control device
nl80211: RFKILL status not available
nl80211: Failed to set interface 4 to mode 2: -16 (Device or resource busy)
nl80211: Try mode change after setting interface down
nl80211: Mode change succeeded while interface is down
nl80211: Using driver-based off-channel TX
netlink: Operstate: linkmode=1, operstate=5
nl80211: driver param='(null)'
mesh0: Own MAC address: 00:0b:6b:b5:ec:37
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
mesh0: RSN: flushing PMKID list in the driver
mesh0: Setting scan request: 0 sec 100000 usec
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Mesh: Looking for a mesh network config entry
mesh0: Trying to associate with 00:00:00:00:00:00 (SSID='test' freq=5180 MHz)
mesh0: Cancelling scan request
mesh0: WPA: clearing own WPA/RSN IE
mesh0: Automatic auth_alg selection: 0x1
mesh0: RSN: using IEEE 802.11i/D9.0
mesh0: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 1024 proto 2
mesh0: WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 08 00 00
mesh0: WPA: using GTK CCMP
mesh0: WPA: using PTK CCMP
mesh0: WPA: using KEY_MGMT SAE
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 08 00 00
mesh0: No keys have been configured - skip key clearing
mesh0: State: DISCONNECTED -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
nl80211: Failed to set interface 4 to mode 7: -16 (Device or resource busy)
nl80211: Try mode change after setting interface down
nl80211: Mode change succeeded while interface is down
nl80211: Register frame command failed (type=176): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=1): 03
nl80211: Failed to register Auth frame processing - ignore for now
meshd: Starting mesh with mesh id = test
mesh0: Cancelling authentication timeout
EAPOL: External notification - portControl=ForceAuthorized
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=1
EAPOL: Supplicant port status: Unauthorized
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
Mesh: Intialization completed
mesh0: Added interface mesh0
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
nl80211: Interface down
mesh0: Event 30 received on interface mesh0
mesh0: Interface was disabled
mesh0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
mesh0: State: DISCONNECTED -> INTERFACE_DISABLED
RTM_NEWLINK, IFLA_IFNAME: Interface 'mesh0' added
mesh0: Event 5 received on interface mesh0
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
nl80211: Interface up
mesh0: Event 29 received on interface mesh0
mesh0: Interface was enabled
mesh0: State: INTERFACE_DISABLED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
mesh0: Setting scan request: 0 sec 0 usec
RTM_NEWLINK, IFLA_IFNAME: Interface 'mesh0' added
mesh0: Event 5 received on interface mesh0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'mesh0' added
mesh0: Event 5 received on interface mesh0
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
nl80211: Interface down
mesh0: Event 30 received on interface mesh0
mesh0: Interface was disabled
mesh0: State: DISCONNECTED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
mesh0: State: DISCONNECTED -> INTERFACE_DISABLED
RTM_NEWLINK, IFLA_IFNAME: Interface 'mesh0' added
mesh0: Event 5 received on interface mesh0
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
nl80211: Interface up
mesh0: Event 29 received on interface mesh0
mesh0: Interface was enabled
mesh0: State: INTERFACE_DISABLED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
mesh0: Setting scan request: 0 sec 0 usec
RTM_NEWLINK, IFLA_IFNAME: Interface 'mesh0' added
mesh0: Event 5 received on interface mesh0
l2_packet_receive - recvfrom: Network is down
mesh0: State: DISCONNECTED -> SCANNING
mesh0: Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 10 seconds
nl80211: Event message available
nl80211: Scan trigger
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'mesh0' added
mesh0: Event 5 received on interface mesh0
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
nl80211: Event message available
nl80211: New scan results available
mesh0: Event 3 received on interface mesh0
Received scan results (1 BSSes)
mesh0: BSS: Start scan result update 1
mesh0: BSS: Add new id 0 BSSID 00:15:61:10:4f:7d SSID ''
Add randomness: count=1 entropy=0
mesh0: New scan results available
mesh0: Selecting BSS from priority group 0
mesh0: 0: 00:15:61:10:4f:7d ssid='' wpa_ie_len=0 rsn_ie_len=20 caps=0x0 level=-67
mesh0:    skip - SSID not known
mesh0: No suitable network found
mesh0: Setting scan request: 5 sec 0 usec
mesh0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'mesh0' added
mesh0: Event 5 received on interface mesh0
nl80211: Event message available
nl80211: New station 00:15:61:10:4f:7d
mesh0: Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
mesh0: Event 3 received on interface mesh0
Received scan results (1 BSSes)
mesh0: BSS: Start scan result update 2
Add randomness: count=2 entropy=1
mesh0: New scan results available
mesh0: Selecting BSS from priority group 0
mesh0: 0: 00:15:61:10:4f:7d ssid='' wpa_ie_len=0 rsn_ie_len=20 caps=0x0 level=-67
mesh0:    skip - SSID not known
mesh0: No suitable network found
mesh0: Setting scan request: 5 sec 0 usec


