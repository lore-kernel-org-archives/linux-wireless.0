Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34215 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754154AbZJPTBu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 15:01:50 -0400
Message-ID: <4AD8C320.6030006@gmx.net>
Date: Fri, 16 Oct 2009 21:01:52 +0200
From: Jan Christoph Uhde <UhdeJC@gmx.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: possible ath9k or wpa_supplicant bug
Content-Type: multipart/mixed;
 boundary="------------030406060205000601010901"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030406060205000601010901
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
i bought a Samsung N140 with an AR9285 Wireless Network Adapter.
I am able to connect to my AP for a short time and then the connection is 
terminated. The Card works fine at other places. But everybody else seems to
be able to connect to my AP without problems.

Attached is:

- the setup of my netbook
- the log of iw
- the log of the wpa_supplicant since
- the hostap config of the AP
- the log of hostap

the logs are created at different times.
the iw event and hostapd log should be recorded simultaneously.

best regards,
jan

--------------030406060205000601010901
Content-Type: text/plain;
 name="report"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="report"

UNAME:#############################################
Linux spike 2.6.31-14-generic #47-Ubuntu SMP Thu Oct 15 02:08:08 UTC 2009 i686 GNU/Linux

LSPCI:#############################################
02:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
	Kernel driver in use: ath9k
	Kernel modules: ath9k

LSMOD:#############################################
Module                  Size  Used by
binfmt_misc             8356  1 
ppdev                   6688  0 
snd_hda_codec_realtek   203328  1 
lp                      8964  0 
parport                35340  2 ppdev,lp
snd_hda_intel          26920  0 
snd_hda_codec          75708  2 snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               7200  1 snd_hda_codec
arc4                    1660  2 
snd_pcm_oss            37920  0 
bridge                 47952  0 
joydev                 10272  0 
snd_mixer_oss          16028  1 snd_pcm_oss
ecb                     2524  2 
snd_pcm                75296  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
stp                     2272  1 bridge
ath9k                  86308  0 
bnep                   12060  2 
snd_seq_dummy           2656  0 
ath9k_hw              224720  1 ath9k
mac80211              210152  1 ath9k
ath                     8828  2 ath9k,ath9k_hw
psmouse                56180  0 
uvcvideo               59080  0 
videodev               36736  1 uvcvideo
v4l1_compat            14496  2 uvcvideo,videodev
snd_seq_oss            28576  0 
serio_raw               5280  0 
snd_seq_midi            6432  0 
cfg80211              130248  3 ath9k,mac80211,ath
led_class               4096  1 ath9k
btusb                  11856  2 
snd_rawmidi            22208  1 snd_seq_midi
snd_seq_midi_event      6940  2 snd_seq_oss,snd_seq_midi
snd_seq                50224  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              22276  2 snd_pcm,snd_seq
snd_seq_device          6920  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
iptable_filter          3100  0 
snd                    59204  12 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
soundcore               7264  1 snd
snd_page_alloc          9156  2 snd_hda_intel,snd_pcm
ip_tables              11692  1 iptable_filter
x_tables               16544  1 ip_tables
fbcon                  36640  71 
tileblit                2460  1 fbcon
font                    8124  1 fbcon
bitblit                 5372  1 fbcon
softcursor              1756  1 bitblit
r8169                  32064  0 
mii                     5212  1 r8169
i915                  221064  2 
drm                   159584  2 i915
i2c_algo_bit            5760  1 i915
intel_agp              27484  2 i915
agpgart                34988  2 drm,intel_agp
video                  19380  1 i915
output                  2780  1 video

MODINFO:###########################################
filename:       /lib/modules/2.6.31-14-generic/updates/drivers/net/wireless/ath/ath9k/ath9k.ko
license:        Dual BSD/GPL
description:    Support for Atheros 802.11n wireless LAN cards.
author:         Atheros Communications
srcversion:     BE80DF2DE1248B206C66D1C
alias:          pci:v0000168Cd0000002Esv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Dsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Bsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Asv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000029sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000027sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000024sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000023sv*sd*bc*sc*i*
depends:        ath9k_hw,mac80211,led-class,ath,cfg80211
vermagic:       2.6.31-14-generic SMP mod_unload modversions 586 
parm:           nohwcrypt:Disable hardware encryption (int)
parm:           debug:uint
parm:           ath9k_debug:Debugging mask

wpa_supplicant:####################################
version:
ii  wpasupplicant                              0.6.9-3ubuntu1                             client support for WPA and WPA2 (IEEE 802.11
config:

ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev


network={
	key_mgmt=WPA-PSK
	#bssid=00:1f:1f:52::d6:b4
	group=TKIP
	pairwise=TKIP
	proto=WPA
	ssid="Halterlose Lederhosen"
	psk="fooo"
	id_str="home"
}

network={
	ssid="halterlose Netzstruempfe"
	psk="baaar"
	id_str="home"
}

/etc/network/interfaces:###########################
auto lo
iface lo inet loopback

auto dsl-provider
iface dsl-provider inet ppp
pre-up /sbin/ifconfig eth0 up # line maintained by pppoeconf
provider dsl-provider

auto eth0
iface eth0 inet manual

iface wlan2 inet manual
	#wpa-driver wext
	wpa-driver nl80211
	wpa-roam /etc/wpa_supplicant/wpa-roam.conf

iface home inet dhcp
	mtu 1412




wpa_supplicant log:################################
Fri Oct 16 12:20:44 CEST 2009
Initializing interface 'wlan2' conf '/etc/wpa_supplicant/wpa-roam.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant/wpa-roam.conf' -> '/etc/wpa_supplicant/wpa-roam.conf'
Reading configuration file '/etc/wpa_supplicant/wpa-roam.conf'
ctrl_interface='DIR=/var/run/wpa_supplicant GROUP=netdev'
Line: 75 - start of a new network block
key_mgmt: 0x2
group: 0x8
pairwise: 0x8
proto: 0x1
ssid - hexdump_ascii(len=21):
     48 61 6c 74 65 72 6c 6f 73 65 20 4c 65 64 65 72   Halterlose Leder
     68 6f 73 65 6e                                    hosen           
PSK (ASCII passphrase) - hexdump_ascii(len=23): [REMOVED]
id_str - hexdump_ascii(len=4):
     68 6f 6d 65                                       home            
PSK (from passphrase) - hexdump(len=32): [REMOVED]
Line: 86 - start of a new network block
ssid - hexdump_ascii(len=24):
     68 61 6c 74 65 72 6c 6f 73 65 20 4e 65 74 7a 73   halterlose Netzs
     74 72 75 65 6d 70 66 65                           truempfe        
PSK (ASCII passphrase) - hexdump_ascii(len=20): [REMOVED]
id_str - hexdump_ascii(len=4):
     68 6f 6d 65                                       home            
PSK (from passphrase) - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid='Halterlose Lederhosen'
   id=1 ssid='halterlose Netzstruempfe'
Failed to set interface wlan2 mode
Could not configure driver to use managed mode
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf
WEXT: Operstate: linkmode=1, operstate=5
Own MAC address: 00:26:b6:11:62:20
wpa_driver_nl80211_set_wpa
wpa_driver_nl80211_set_key: alg=0 addr=0x80ba878 key_idx=0 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x80ba878 key_idx=1 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x80ba878 key_idx=2 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x80ba878 key_idx=3 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_countermeasures
wpa_driver_nl80211_set_drop_unencrypted
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): e2 62 f4 1c e0 42 5f c8 ab fb 5a 26 e2 ac 9c 65
WPS: Build Beacon and Probe Response IEs
WPS:  * Version
WPS:  * Wi-Fi Protected Setup State (0)
WPS:  * Version
WPS:  * Wi-Fi Protected Setup State (0)
WPS:  * Response Type (2)
WPS:  * UUID-E
WPS:  * Manufacturer
WPS:  * Model Name
WPS:  * Model Number
WPS:  * Serial Number
WPS:  * Primary Device Type
WPS:  * Device Name
WPS:  * Config Methods (0)
WPS:  * RF Bands (3)
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
ctrl_interface_group=112 (from group name 'netdev')
Added interface wlan2
CTRL_IFACE - wlan2 - wait for monitor to attach
CTRL_IFACE monitor attached - hexdump(len=21): 2f 74 6d 70 2f 77 70 61 5f 63 74 72 6c 5f 31 39 37 31 2d 31 00
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2' added
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Trying to get current scan results first without requesting a new scan to speed up initial association
Received scan results (0 BSSes)
Cached scan results are empty - not posting
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 0 sec 0 usec
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 10 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (12 BSSes)
CTRL-EVENT-SCAN-RESULTS 
CTRL_IFACE monitor send - hexdump(len=21): 2f 74 6d 70 2f 77 70 61 5f 63 74 72 6c 5f 31 39 37 31 2d 31 00
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=7
WPS: attr type=0x1023 len=15
WPS: attr type=0x1024 len=4
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=5
WPS: attr type=0x1008 len=2
WPS: attr type=0x1041 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=7
WPS: attr type=0x1023 len=15
WPS: attr type=0x1024 len=4
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=5
WPS: attr type=0x1008 len=2
WPS: attr type=0x1041 len=1
WPS-AP-AVAILABLE 
CTRL_IFACE monitor send - hexdump(len=21): 2f 74 6d 70 2f 77 70 61 5f 63 74 72 6c 5f 31 39 37 31 2d 31 00
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:1f:1f:52:d6:b4 ssid='Halterlose Lederhosen' wpa_ie_len=22 rsn_ie_len=0 caps=0x411
   selected based on WPA IE
   selected WPA AP 00:1f:1f:52:d6:b4 ssid='Halterlose Lederhosen'
Trying to associate with 00:1f:1f:52:d6:b4 (SSID='Halterlose Lederhosen' freq=2442 MHz)
CTRL_IFACE monitor send - hexdump(len=21): 2f 74 6d 70 2f 77 70 61 5f 63 74 72 6c 5f 31 39 37 31 2d 31 00
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
WPA: using IEEE 802.11i/D3.0
WPA: Selected cipher suites: group 8 pairwise 8 key_mgmt 2 proto 1
WPA: set AP WPA IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK TKIP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
No keys have been configured - skip key clearing
wpa_driver_nl80211_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_nl80211_associate
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2' added
Wireless event: cmd=0x8b19 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2' added
Wireless event: cmd=0x8b04 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2' added
Wireless event: cmd=0x8c08 len=24
AssocResp IE wireless event - hexdump(len=16): 01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2' added
Wireless event: cmd=0x8b15 len=20
Wireless event: new AP: 00:1f:1f:52:d6:b4
Association info event
resp_ies - hexdump(len=16): 01 08 82 84 8b 96 0c 12 18 24 32 04 30 48 60 6c
State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:1f:1f:52:d6:b4
No keys have been configured - skip key clearing
Associated with 00:1f:1f:52:d6:b4
CTRL_IFACE monitor send - hexdump(len=21): 2f 74 6d 70 2f 77 70 61 5f 63 74 72 6c 5f 31 39 37 31 2d 31 00
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2' added
RX EAPOL from 00:1f:1f:52:d6:b4
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 89 00 20 00 00 00 00 00 00 00 01 e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x89 (ver=1 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=32 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5a
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 89 00 20 00 00 00 00 00 00 00 01 e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:1f:1f:52:d6:b4 (ver=1)
WPA: Renewed SNonce - hexdump(len=32): c5 3a e3 cd e3 fb 04 c1 c9 c5 c7 6c f9 83 fb 93 71 3f 51 4a 75 59 07 68 dd 60 51 3a 81 02 68 56
WPA: PTK derivation - A1=00:26:b6:11:62:20 A2=00:1f:1f:52:d6:b4
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 09 00 20 00 00 00 00 00 00 00 01 c5 3a e3 cd e3 fb 04 c1 c9 c5 c7 6c f9 83 fb 93 71 3f 51 4a 75 59 07 68 dd 60 51 3a 81 02 68 56 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 34 9c 97 3f 94 61 f7 11 6b 0c d9 4f 72 2b 14 f9 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
RX EAPOL from 00:1f:1f:52:d6:b4
RX EAPOL - hexdump(len=123): 01 03 00 77 fe 01 c9 00 20 00 00 00 00 00 00 00 02 e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 d2 79 e0 2e 27 cf 35 6c fd f2 76 7b 28 13 c7 e7 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
IEEE 802.1X RX: version=1 type=3 length=119
  EAPOL-Key type=254
  key_info 0x1c9 (ver=1 keyidx=0 rsvd=0 Pairwise Install Ack MIC)
  key_length=32 key_data_length=24
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5a
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): d2 79 e0 2e 27 cf 35 6c fd f2 76 7b 28 13 c7 e7
WPA: RX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 c9 00 20 00 00 00 00 00 00 00 02 e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 d2 79 e0 2e 27 cf 35 6c fd f2 76 7b 28 13 c7 e7 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from 00:1f:1f:52:d6:b4 (ver=1)
WPA: IE KeyData - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 4/4
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 01 09 00 20 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9f 9a cc db a6 e7 6c 67 e6 73 99 69 0b a4 e4 54 00 00
WPA: Installing PTK to the driver.
WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
wpa_driver_nl80211_set_key: alg=2 addr=0x9279554 key_idx=0 set_tx=1 seq_len=6 key_len=32
   addr=00:1f:1f:52:d6:b4
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RX EAPOL from 00:1f:1f:52:d6:b4
RX EAPOL - hexdump(len=131): 01 03 00 7f fe 03 91 00 20 00 00 00 00 00 00 00 03 e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 55 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5b 2d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f 7a f7 83 c5 37 c2 8c 65 9e 7b b3 be d9 c8 3d 00 20 73 13 32 e5 60 df fb ea 62 77 6f b2 43 8b 1d b5 a2 b4 4e fe 67 32 50 63 fe 8e 47 1b ba be ad 1d
IEEE 802.1X RX: version=1 type=3 length=127
  EAPOL-Key type=254
  key_info 0x391 (ver=1 keyidx=1 rsvd=0 Group Ack MIC Secure)
  key_length=32 key_data_length=32
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 55
  key_iv - hexdump(len=16): 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5b
  key_rsc - hexdump(len=8): 2d 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 1f 7a f7 83 c5 37 c2 8c 65 9e 7b b3 be d9 c8 3d
WPA: RX EAPOL-Key - hexdump(len=131): 01 03 00 7f fe 03 91 00 20 00 00 00 00 00 00 00 03 e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 55 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5b 2d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f 7a f7 83 c5 37 c2 8c 65 9e 7b b3 be d9 c8 3d 00 20 73 13 32 e5 60 df fb ea 62 77 6f b2 43 8b 1d b5 a2 b4 4e fe 67 32 50 63 fe 8e 47 1b ba be ad 1d
WPA: RX message 1 of Group Key Handshake from 00:1f:1f:52:d6:b4 (ver=1)
State: GROUP_HANDSHAKE -> GROUP_HANDSHAKE
WPA: Group Key - hexdump(len=32): [REMOVED]
WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32).
WPA: RSC - hexdump(len=6): 2d 00 00 00 00 00
wpa_driver_nl80211_set_key: alg=2 addr=0x80ba878 key_idx=1 set_tx=0 seq_len=6 key_len=32
WPA: Sending EAPOL-Key 2/2
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 03 11 00 20 00 00 00 00 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ef d5 65 ad 8d 38 a0 8a 43 29 2f d7 1a 28 48 ff 00 00
WPA: Key negotiation completed with 00:1f:1f:52:d6:b4 [PTK=TKIP GTK=TKIP]
CTRL_IFACE monitor send - hexdump(len=21): 2f 74 6d 70 2f 77 70 61 5f 63 74 72 6c 5f 31 39 37 31 2d 31 00
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:1f:1f:52:d6:b4 completed (auth) [id=0 id_str=home]
CTRL_IFACE monitor send - hexdump(len=21): 2f 74 6d 70 2f 77 70 61 5f 63 74 72 6c 5f 31 39 37 31 2d 31 00
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
WEXT: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2' added
EAPOL: startWhen --> 0
EAPOL: disable timer tick
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX EAPOL from 00:1f:1f:52:d6:b4
RX EAPOL - hexdump(len=131): 01 03 00 7f fe 03 a1 00 20 00 00 00 00 00 00 00 04 e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5c 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 61 69 af 21 c7 0a fc ac 34 af 33 62 42 7c 41 b0 00 20 fa 0c 86 18 cd 56 6e ef 2b 64 23 a8 96 2c b2 08 eb 61 c8 87 58 0e 89 4d 84 f6 fc dd 9f ba 07 6c
IEEE 802.1X RX: version=1 type=3 length=127
  EAPOL-Key type=254
  key_info 0x3a1 (ver=1 keyidx=2 rsvd=0 Group Ack MIC Secure)
  key_length=32 key_data_length=32
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5c
  key_iv - hexdump(len=16): 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5d
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 61 69 af 21 c7 0a fc ac 34 af 33 62 42 7c 41 b0
WPA: RX EAPOL-Key - hexdump(len=131): 01 03 00 7f fe 03 a1 00 20 00 00 00 00 00 00 00 04 e8 9f ba 86 27 1a a0 fa e7 fc 35 de 61 ae f0 59 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5c 84 df 01 b3 23 a2 58 ab 88 6a a2 c8 a1 51 4b 5d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 61 69 af 21 c7 0a fc ac 34 af 33 62 42 7c 41 b0 00 20 fa 0c 86 18 cd 56 6e ef 2b 64 23 a8 96 2c b2 08 eb 61 c8 87 58 0e 89 4d 84 f6 fc dd 9f ba 07 6c
WPA: RX message 1 of Group Key Handshake from 00:1f:1f:52:d6:b4 (ver=1)
State: COMPLETED -> GROUP_HANDSHAKE
WPA: Group Key - hexdump(len=32): [REMOVED]
WPA: Installing GTK to the driver (keyidx=2 tx=0 len=32).
WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
wpa_driver_nl80211_set_key: alg=2 addr=0x80ba878 key_idx=2 set_tx=0 seq_len=6 key_len=32
WPA: Sending EAPOL-Key 2/2
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 03 21 00 20 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 b1 eb 43 9e 07 92 08 e0 f4 d8 82 85 72 02 b7 89 00 00
WPA: Group rekeying completed with 00:1f:1f:52:d6:b4 [GTK=TKIP]
CTRL_IFACE monitor send - hexdump(len=21): 2f 74 6d 70 2f 77 70 61 5f 63 74 72 6c 5f 31 39 37 31 2d 31 00
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS          
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS          
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS          
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS          
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS          
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS          
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS          
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS          
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS          
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS          
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS          
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
RX ctrl_iface - hexdump_ascii(len=4):
     50 49 4e 47                                       PING            
CTRL-EVENT-TERMINATING - signal 2 received
CTRL_IFACE monitor send - hexdump(len=21): 2f 74 6d 70 2f 77 70 61 5f 63 74 72 6c 5f 31 39 37 31 2d 31 00
Removing interface wlan2
State: COMPLETED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_nl80211_deauthenticate
wpa_driver_nl80211_set_key: alg=0 addr=0x80ba878 key_idx=0 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x80ba878 key_idx=1 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x80ba878 key_idx=2 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x80ba878 key_idx=3 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x9277640 key_idx=0 set_tx=0 seq_len=0 key_len=0
   addr=00:1f:1f:52:d6:b4
nl80211: set_key failed; err=-67
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
wpa_driver_nl80211_set_wpa
wpa_driver_nl80211_set_drop_unencrypted
wpa_driver_nl80211_set_countermeasures
No keys have been configured - skip key clearing
CTRL_IFACE wait for attached monitors to receive messages
Cancelling scan request
Cancelling authentication timeout
WEXT: Operstate: linkmode=0, operstate=6

########iw event -t############################

1255718273.323149: wlan2 (phy #0): unknown event 33
1255718274.251310: wlan2 (phy #0): scan finished
1255718274.260481: wlan2 (phy #0): deauth 00:26:b6:11:62:20 -> 00:1f:1f:52:d6:b4 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS
1255718274.260690: wlan2 (phy #0): unknown event 46
1255718274.266322: wlan2 (phy #0): auth 00:1f:1f:52:d6:b4 -> 00:26:b6:11:62:20 status: 0: Successful
1255718274.269848: wlan2 (phy #0): assoc 00:1f:1f:52:d6:b4 -> 00:26:b6:11:62:20 status: 0: Successful
1255718274.269978: wlan2 (phy #0): unknown event 46

###############################################
#####################HOST######################
###############################################



interface=wlan0
driver=nl80211
logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2
dump_file=/tmp/hostapd.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=Halterlose Lederhosen
country_code=DE
ieee80211d=1
hw_mode=g
channel=7
beacon_int=100
dtim_period=2
max_num_sta=255
rts_threshold=2347
fragm_threshold=2346
macaddr_acl=0
auth_algs=3
ignore_broadcast_ssid=0
wme_ac_bk_cwmin=4
wme_ac_bk_cwmax=10
wme_ac_bk_aifs=7
wme_ac_bk_txop_limit=0
wme_ac_bk_acm=0
wme_ac_be_aifs=3
wme_ac_be_cwmin=4
wme_ac_be_cwmax=10
wme_ac_be_txop_limit=0
wme_ac_be_acm=0
wme_ac_vi_aifs=2
wme_ac_vi_cwmin=3
wme_ac_vi_cwmax=4
wme_ac_vi_txop_limit=94
wme_ac_vi_acm=0
wme_ac_vo_aifs=2
wme_ac_vo_cwmin=2
wme_ac_vo_cwmax=3
wme_ac_vo_txop_limit=47
wme_ac_vo_acm=0
ieee8021x=0
eapol_version=1
own_ip_addr=127.0.0.1
wpa=2
wpa_psk=0fd9a61d096e97f59bda536d0d2f4bbe5fd186694b33060f113be9f4ebda146a
wpa_key_mgmt=WPA-PSK 
wpa_pairwise=TKIP 



###################hostapd.log#######################3
1255718250.071919: Configuration file: /etc/hostapd/hostapd.conf
1255718250.072410: ctrl_interface_group=0
1255718250.072519: eapol_version=1
1255718250.107587: Opening raw packet socket for ifindex 212
1255718250.107608: BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
1255718250.107635: SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
1255718250.107699: nl80211: Added 802.11b mode based on 802.11g information
1255718250.107704: Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=16 dBm
1255718250.107707: Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=16 dBm
1255718250.107711: Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=15 dBm
1255718250.107713: Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=15 dBm
1255718250.107716: Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=15 dBm
1255718250.107719: Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=14 dBm
1255718250.107722: Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=14 dBm
1255718250.107725: Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=14 dBm
1255718250.107728: Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=13 dBm
1255718250.107731: Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=13 dBm
1255718250.107733: Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=13 dBm
1255718250.107736: Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=16 dBm
1255718250.107739: Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=16 dBm
1255718250.107742: Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=15 dBm
1255718250.107745: Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=15 dBm
1255718250.107748: Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=15 dBm
1255718250.107751: Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=14 dBm
1255718250.107754: Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=14 dBm
1255718250.107757: Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=14 dBm
1255718250.107760: Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=13 dBm
1255718250.107762: Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=13 dBm
1255718250.107765: Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=13 dBm
1255718250.107790: RATE[0] rate=10 flags=0x2
1255718250.107795: RATE[1] rate=20 flags=0x6
1255718250.107798: RATE[2] rate=55 flags=0x6
1255718250.107800: RATE[3] rate=110 flags=0x6
1255718250.107803: RATE[4] rate=60 flags=0x0
1255718250.107806: RATE[5] rate=90 flags=0x0
1255718250.107809: RATE[6] rate=120 flags=0x0
1255718250.107812: RATE[7] rate=180 flags=0x0
1255718250.107814: RATE[8] rate=240 flags=0x0
1255718250.107817: RATE[9] rate=360 flags=0x0
1255718250.107820: RATE[10] rate=480 flags=0x0
1255718250.107822: RATE[11] rate=540 flags=0x0
1255718250.107825: Passive scanning not supported
1255718250.107829: Flushing old station entries
1255718250.107845: Deauthenticate all stations
1255718250.107871: Mode: IEEE 802.11g  Channel: 7  Frequency: 2442 MHz
1255718250.115235: Using interface wlan0 with hwaddr 00:1f:1f:52:d6:b4 and ssid 'Halterlose Lederhosen'
1255718250.117332: WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
1255718250.117347: GMK - hexdump(len=32): a7 08 73 55 06 6e dc cd 82 c8 d3 2c 15 a2 19 97 b0 44 f5 fc e9 de b1 ae ad d4 64 74 99 93 b3 aa
1255718250.117359: GTK - hexdump(len=32): c8 b4 96 8d c0 f1 0f 3b e1 48 3f 9d 40 28 72 9f 16 ef 4f 1c 31 c5 18 78 8c ec e6 3a c3 5e 6f ff
1255718250.117370: WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
1255718250.117586: wlan0: Setup of interface done.
1255718250.117614: MGMT (TX callback) ACK
1255718259.405747: unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
1255718259.405790: STA 00:21:00:0b:de:7d sent probe request for broadcast SSID
1255718259.407360: MGMT (TX callback) ACK
1255718259.407364: mgmt::proberesp cb
1255718259.425763: unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
1255718259.425801: STA 00:21:00:0b:de:7d sent probe request for broadcast SSID
1255718259.427373: MGMT (TX callback) ACK
1255718259.427378: mgmt::proberesp cb
1255718262.601297: unknown vendor specific information element ignored (vendor OUI 00:03:47 len=7)
1255718262.601990: unknown vendor specific information element ignored (vendor OUI 00:03:47 len=7)
1255718262.602022: STA 00:1f:3c:c3:c4:22 sent probe request for broadcast SSID
1255718262.615549: MGMT (TX callback) ACK
1255718262.615560: mgmt::proberesp cb
1255718274.172523: STA 00:26:b6:11:62:20 sent probe request for broadcast SSID
1255718274.174090: MGMT (TX callback) ACK
1255718274.174094: mgmt::proberesp cb
1255718274.614193: MGMT
1255718274.614204: mgmt::deauth
1255718274.614207: deauthentication: STA=00:26:b6:11:62:20 reason_code=3
Station 00:26:b6:11:62:20 trying to deauthenticate, but it is not authenticated.
1255718274.615521: STA 00:26:b6:11:62:20 sent probe request for our SSID
1255718274.617089: MGMT (TX callback) ACK
1255718274.617093: mgmt::proberesp cb
1255718274.617870: MGMT
1255718274.617873: mgmt::auth
1255718274.617875: authentication: STA=00:26:b6:11:62:20 auth_alg=0 auth_transaction=1 status_code=0 wep=0
1255718274.617887:   New STA
1255718274.617906: wlan0: STA 00:26:b6:11:62:20 IEEE 802.11: authentication OK (open system)
1255718274.617917: wlan0: STA 00:26:b6:11:62:20 MLME: MLME-AUTHENTICATE.indication(00:26:b6:11:62:20, OPEN_SYSTEM)
1255718274.617924: wlan0: STA 00:26:b6:11:62:20 MLME: MLME-DELETEKEYS.request(00:26:b6:11:62:20)
1255718274.617927: authentication reply: STA=00:26:b6:11:62:20 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
1255718274.619203: MGMT (TX callback) ACK
1255718274.619207: mgmt::auth cb
1255718274.619214: wlan0: STA 00:26:b6:11:62:20 IEEE 802.11: authenticated
1255718274.620545: MGMT
1255718274.620550: mgmt::assoc_req
1255718274.620553: association request: STA=00:26:b6:11:62:20 capab_info=0x431 listen_interval=10
1255718274.620566:   new AID 1
1255718274.620573: wlan0: STA 00:26:b6:11:62:20 IEEE 802.11: association OK (aid 1)
1255718274.621913: MGMT (TX callback) ACK
1255718274.621916: mgmt::assoc_resp cb
1255718274.621922: wlan0: STA 00:26:b6:11:62:20 IEEE 802.11: associated (aid 1)
1255718274.622008: wlan0: STA 00:26:b6:11:62:20 MLME: MLME-ASSOCIATE.indication(00:26:b6:11:62:20)
1255718274.622015: wlan0: STA 00:26:b6:11:62:20 MLME: MLME-DELETEKEYS.request(00:26:b6:11:62:20)
1255718274.622405: wlan0: STA 00:26:b6:11:62:20 WPA: event 1 notification
1255718274.622441: wlan0: STA 00:26:b6:11:62:20 WPA: start authentication
1255718274.622444: WPA: 00:26:b6:11:62:20 WPA_PTK entering state INITIALIZE
1255718274.622479: wlan0: STA 00:26:b6:11:62:20 IEEE 802.1X: unauthorizing port
1255718274.622482: WPA: 00:26:b6:11:62:20 WPA_PTK_GROUP entering state IDLE
1255718274.622486: WPA: 00:26:b6:11:62:20 WPA_PTK entering state AUTHENTICATION
1255718274.622490: WPA: 00:26:b6:11:62:20 WPA_PTK entering state AUTHENTICATION2
1255718274.622494: WPA: 00:26:b6:11:62:20 WPA_PTK entering state INITPSK
1255718274.622498: WPA: 00:26:b6:11:62:20 WPA_PTK entering state PTKSTART
1255718274.622504: wlan0: STA 00:26:b6:11:62:20 WPA: sending 1/4 msg of 4-Way Handshake
1255718274.622507: WPA: Send EAPOL(version=1 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
1255718274.624154: IEEE 802.1X: 00:26:b6:11:62:20 TX status - version=1 type=3 length=95 - ack=1
1255718274.659106: IEEE 802.1X: 123 bytes from 00:26:b6:11:62:20
1255718274.659118:    IEEE 802.1X: version=1 type=3 length=119
1255718274.659132: wlan0: STA 00:26:b6:11:62:20 WPA: received EAPOL-Key frame (2/4 Pairwise)
1255718274.659138: WPA: 00:26:b6:11:62:20 WPA_PTK entering state PTKCALCNEGOTIATING
1255718274.659163: WPA: PTK derivation - A1=00:1f:1f:52:d6:b4 A2=00:26:b6:11:62:20
1255718274.659168: WPA: PMK - hexdump(len=32): 0f d9 a6 1d 09 6e 97 f5 9b da 53 6d 0d 2f 4b be 5f d1 86 69 4b 33 06 0f 11 3b e9 f4 eb da 14 6a
1255718274.659178: WPA: PTK - hexdump(len=64): 92 d6 dc 74 95 94 d2 aa f8 f6 8e b2 93 1d 11 fb 5b 60 ed 91 1f c7 cf 9d 22 88 4a bc b0 23 07 59 c8 66 e4 19 44 40 d1 30 e8 49 59 08 0c 55 4b 18 53 72 1b 1d e2 ac 4c 0c 54 05 b5 d0 61 56 73 b8
1255718274.659279: WPA: 00:26:b6:11:62:20 WPA_PTK entering state PTKCALCNEGOTIATING2
1255718274.659283: WPA: 00:26:b6:11:62:20 WPA_PTK entering state PTKINITNEGOTIATING
1255718274.659356: wlan0: STA 00:26:b6:11:62:20 WPA: sending 3/4 msg of 4-Way Handshake
1255718274.659359: WPA: Send EAPOL(version=1 secure=0 mic=1 ack=1 install=1 pairwise=8 kde_len=24 keyidx=0 encr=0)
1255718274.661229: IEEE 802.1X: 00:26:b6:11:62:20 TX status - version=1 type=3 length=119 - ack=1
1255718274.661712: IEEE 802.1X: 99 bytes from 00:26:b6:11:62:20
1255718274.661716:    IEEE 802.1X: version=1 type=3 length=95
1255718274.661727: wlan0: STA 00:26:b6:11:62:20 WPA: received EAPOL-Key frame (4/4 Pairwise)
1255718274.661736: WPA: 00:26:b6:11:62:20 WPA_PTK entering state PTKINITDONE
1255718274.661799: wlan0: STA 00:26:b6:11:62:20 IEEE 802.1X: authorizing port
1255718274.661805: wlan0: STA 00:26:b6:11:62:20 RADIUS: starting accounting session 4AD8BD6A-00000000
1255718274.661960: wlan0: STA 00:26:b6:11:62:20 WPA: pairwise key handshake completed (WPA)
1255718274.662036: WPA: 00:26:b6:11:62:20 WPA_PTK_GROUP entering state REKEYNEGOTIATING
1255718274.662076: wlan0: STA 00:26:b6:11:62:20 WPA: sending 1/2 msg of Group Key Handshake
1255718274.662079: WPA: Send EAPOL(version=1 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=32 keyidx=1 encr=1)
1255718274.662085: Plaintext EAPOL-Key Key Data - hexdump(len=32): c8 b4 96 8d c0 f1 0f 3b e1 48 3f 9d 40 28 72 9f 16 ef 4f 1c 31 c5 18 78 8c ec e6 3a c3 5e 6f ff
1255718274.664818: IEEE 802.1X: 99 bytes from 00:26:b6:11:62:20
1255718274.664823:    IEEE 802.1X: version=1 type=3 length=95
1255718274.664830: wlan0: STA 00:26:b6:11:62:20 WPA: received EAPOL-Key frame (2/2 Group)
1255718274.664836: WPA: 00:26:b6:11:62:20 WPA_PTK_GROUP entering state REKEYESTABLISHED
1255718274.664843: wlan0: STA 00:26:b6:11:62:20 WPA: group key handshake completed (WPA)
1255718274.664919: WPA: 00:26:b6:11:62:20 WPA_PTK_GROUP entering state IDLE
1255718282.647676: unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
1255718282.647718: STA 04:1e:64:28:6e:e8 sent probe request for broadcast SSID
1255718282.656881: MGMT (TX callback) fail
1255718282.656886: mgmt::proberesp cb
1255718282.689270: unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
1255718282.689290: STA 04:1e:64:28:6e:e8 sent probe request for broadcast SSID
1255718282.699478: MGMT (TX callback) ACK
1255718282.699483: mgmt::proberesp cb
1255718282.707754: unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
1255718282.707782: STA 04:1e:64:28:6e:e8 sent probe request for broadcast SSID
1255718282.721864: MGMT (TX callback) fail
1255718282.721868: mgmt::proberesp cb
1255718290.622949: STA 00:18:de:38:a2:48 sent probe request for broadcast SSID
1255718290.632630: MGMT (TX callback) fail
1255718290.632635: mgmt::proberesp cb
1255718295.230991: unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
1255718295.231038: STA 04:1e:64:28:6e:e8 sent probe request for broadcast SSID
1255718295.232715: MGMT (TX callback) ACK
1255718295.232721: mgmt::proberesp cb
1255718319.406397: unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
1255718319.406441: STA 00:21:00:0b:de:7d sent probe request for broadcast SSID
1255718319.421003: MGMT (TX callback) fail
1255718319.421008: mgmt::proberesp cb
1255718329.898488: unknown vendor specific information element ignored (vendor OUI 00:03:47 len=7)
1255718329.898529: STA 00:1f:3c:c3:c4:22 sent probe request for broadcast SSID
1255718329.912168: MGMT (TX callback) fail
1255718329.912172: mgmt::proberesp cb
1255718356.190102: STA 00:18:de:38:a2:48 sent probe request for broadcast SSID
1255718356.193219: MGMT (TX callback) ACK
1255718356.193225: mgmt::proberesp cb
1255718363.068709: unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
1255718363.068751: STA 00:16:ce:29:88:30 sent probe request for broadcast SSID
1255718363.073412: MGMT (TX callback) ACK
1255718363.073417: mgmt::proberesp cb
1255718363.079184: unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
1255718363.079203: STA 00:16:ce:29:88:30 sent probe request for broadcast SSID
1255718363.080769: MGMT (TX callback) ACK
1255718363.080773: mgmt::proberesp cb
1255718378.686695: Signal 2 received - terminating
1255718378.686719: wlan0: STA 00:26:b6:11:62:20 MLME: MLME-DEAUTHENTICATE.indication(00:26:b6:11:62:20, 1)
1255718378.686726: wlan0: STA 00:26:b6:11:62:20 MLME: MLME-DELETEKEYS.request(00:26:b6:11:62:20)
1255718378.686793: Removing station 00:26:b6:11:62:20
1255718378.686825: Flushing old station entries
1255718378.686841: Deauthenticate all stations

--------------030406060205000601010901--
