Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from correo.avancemgrup.es ([95.39.26.195]:10031 "EHLO
	correo.avancemgrup.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbbKCPbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 10:31:37 -0500
Message-ID: <1446564281.4123.17.camel@s-altop> (sfid-20151103_163233_403888_4CDFB7AE)
Subject: Encryption problems with libertas drivers, kernel 3.18 and
 wpa_supplicant using wext
From: simo <sazzalin@settopsurvey.com>
To: <linux-wireless@vger.kernel.org>
Date: Tue, 3 Nov 2015 16:24:41 +0100
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I hope this is the right place to ask for help.

I am experiencing problems when I try to create a IBSS netwoork with
wpa_supplicant.

The drivers used for the wifi hardware are the "libertas" and the
wireles adapter is a Marvell WLAN 802.11.

What happens is that when I create the network, it appears always as
unencrypted. I cannot set any encryption key (WEP, WPA etc.)

I can only connect to the IBSS network if this has been set without key.

When I execute wpa_supplicant the output is:

wpa_supplicant -D wext -i wlan0
-c/etc/wpa_supplicant/wpa_supplicant.conf -dd
wpa_supplicant v2.3
random: Trying to read entropy from /dev/random
Successfully initialized wpa_supplicant
Initializing interface 'wlan0' conf
'/etc/wpa_supplicant/wpa_supplicant.conf' driver 'wext' ctrl_interface
'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant/wpa_supplicant.conf' ->
'/etc/wpa_supplicant/wpa_supplicant.conf'
Reading configuration file '/etc/wpa_supplicant/wpa_supplicant.conf'
ap_scan=1
ctrl_interface='/var/run/wpa_supplicant'
Line: 3 - start of a new network block
ssid - hexdump_ascii(len=8):
     73 69 6d 6f 5f 6e 65 74                           simo_net        
mode=1 (0x1)
frequency=2412 (0x96c)
priority=10 (0xa)
key_mgmt: 0x4
wep_key0 - hexdump(len=5): [REMOVED]
Priority group 10
   id=0 ssid='simo_net'
WEXT: cfg80211-based driver detected
wext: interface wlan0 phy: phy2
rfkill: initial event: idx=1 type=2 op=0 soft=0 hard=0
rfkill: initial event: idx=3 type=1 op=0 soft=0 hard=0
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0x1f flags 0x0
netlink: Operstate: ifindex=5 linkmode=1 (userspace-control),
operstate=5 (IF_OPER_DORMANT)
Add interface wlan0 to a new radio phy2
wlan0: Own MAC address: xx:xx:xx:xx:xx:xx
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_countermeasures
wlan0: RSN: flushing PMKID list in the driver
wlan0: Setting scan request: 0.100000 sec
wlan0: WPS: UUID based on MAC address:
39cee858-d55e-5e3d-b589-30e2c9d32960
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
wlan0: Added interface wlan0
wlan0: State: DISCONNECTED -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: ifindex=5 linkmode=-1 (no change), operstate=5
(IF_OPER_DORMANT)
random: Got 20/20 bytes from /dev/random
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
Wireless event: cmd=0x8b1a len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
wlan0: Add radio work 'scan'@0xfa450
wlan0: First radio work item in the queue - schedule start immediately
wlan0: Starting radio work 'scan'@0xfa450 after 0.000122 second wait
Scan requested (ret=0) - scan timeout 10 seconds
EAPOL: disable timer tick
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=8
wlan0: Event SCAN_RESULTS (3) received
Received 0 bytes of scan results (0 BSSes)
wlan0: BSS: Start scan result update 1
BSS: last_scan_res_used=0/0
wlan0: New scan results available (own=0 ext=0)
wlan0: Radio work 'scan'@0xfa450 done in 1.086812 seconds
wlan0: No suitable network found
wlan0: Setup a new network
wlan0: Add radio work 'connect'@0xfa450
wlan0: First radio work item in the queue - schedule start immediately
wlan0: Starting radio work 'connect'@0xfa450 after 0.000153 second wait
wlan0: Trying to associate with SSID 'simo_net'
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: WPA: clearing AP WPA IE
wlan0: WPA: clearing AP RSN IE
wlan0: WPA: clearing own WPA/RSN IE
wpa_driver_wext_set_key: alg=1 key_idx=0 set_tx=1 seq_len=0 key_len=5
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: ifindex=5 linkmode=-1 (no change), operstate=5
(IF_OPER_DORMANT)
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
ioctl[SIOCSIWGENIE]: Operation not supported
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=ForceAuthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b04 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b15 len=20
Wireless event: new AP: xx:xx:xx:xx:xx:xx
wlan0: Event ASSOC (0) received
wlan0: State: ASSOCIATING -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: ifindex=5 linkmode=-1 (no change), operstate=5
(IF_OPER_DORMANT)
wlan0: Associated to a new BSS: BSSID=xx:xx:xx:xx:xx:xx
Received 287 bytes of scan results (1 BSSes)
wlan0: BSS: Start scan result update 2
wlan0: BSS: Add new id 0 BSSID xx:xx:xx:xx:xx:xx SSID 'simo_net'
wlan0: Associated with xx:xx:xx:xx:xx:xx
wlan0: WPA: Association event - clear replay counter
wlan0: WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state S_FORCE_AUTH
EAPOL: Supplicant port status: Authorized
EAPOL: SUPP_BE entering state IDLE
wlan0: Cancelling authentication timeout
wlan0: State: ASSOCIATED -> COMPLETED
wlan0: Radio work 'connect'@0xfa450 done in 0.092043 seconds
wlan0: CTRL-EVENT-CONNECTED - Connection to xx:xx:xx:xx:xx:xx completed
[id=0 id_str=]
wpa_driver_wext_set_operstate: operstate 0->1 (UP)
netlink: Operstate: ifindex=5 linkmode=-1 (no change), operstate=6
(IF_OPER_UP)
wlan0: Cancelling scan request
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event

For information, the wpa_supplicant conf file is:

ap_scan=1
ctrl_interface=/var/run/wpa_supplicant
network={
   ssid="simo_net"
   mode=1
   frequency=2412
   priority=10
   key_mgmt=NONE
   wep_key0="hello"
}

Problems persist also recompiling wpa_supplicant 2.5.

>From a research of similar issues through Google, I realized it could be
an issue related to the libertas driver.

At the moment I don't know how to solve. Someone has experienced the
same problems ?

Any suggestion ?

Thank you in advance.
Simon

