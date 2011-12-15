Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34484 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab1LOHfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 02:35:19 -0500
Received: by yenm11 with SMTP id m11so1274042yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 23:35:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKeTQ4adxsEiEzL1DXUvKCF6odfZkQTFhVFJC4AFwBshU-YHFw@mail.gmail.com>
References: <CAKeTQ4aVzp3GTmzR0zv1j5fWyCUrQLUk9EHHBvZFpDYiQSC1=g@mail.gmail.com>
	<CAD2nsn0jgoUDf02UrajQyOKZiETMEbP6ikBAtBNdmcgT6m34yw@mail.gmail.com>
	<CAKeTQ4adxsEiEzL1DXUvKCF6odfZkQTFhVFJC4AFwBshU-YHFw@mail.gmail.com>
Date: Thu, 15 Dec 2011 13:05:18 +0530
Message-ID: <CAKeTQ4Y9iNSKcpYFWSqu89Y5--zcqznh2AuLoTn36jzSaFxedw@mail.gmail.com> (sfid-20111215_083552_131884_8C9C2E85)
Subject: Re: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Ashwin Mendonca <ashwinloyal@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried the bleeding edge build of compat-wireless
(compat-wireless-2011-12-14 build) on Linux-3.1.5. It still leads to
kernel panic. I manually got the AP up with these steps:

1. Removed ip from eth0
2. Created a bridge with brctl
3. Added eth0 to br0
4. Ran hostapd with my con file. And it showed this error:
    l2_packet_receive - recvfrom: Network is down
5. Tried to connect my client devices. None were getting authenticated.
6. I assigned an ip to br0. Client got authenticated. System on AP mode froze.

My hostapd.conf:
...............................................
interface=wlan0
bridge=br0
driver=nl80211
logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2
dump_file=/tmp/hostapd.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=test
hw_mode=g
channel=1
beacon_int=100
dtim_period=2
max_num_sta=255
rts_threshold=2347
fragm_threshold=2346
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wmm_enabled=1
wmm_ac_bk_cwmin=4
wmm_ac_bk_cwmax=10
wmm_ac_bk_aifs=7
wmm_ac_bk_txop_limit=0
wmm_ac_bk_acm=0
wmm_ac_be_aifs=3
wmm_ac_be_cwmin=4
wmm_ac_be_cwmax=10
wmm_ac_be_txop_limit=0
wmm_ac_be_acm=0
wmm_ac_vi_aifs=2
wmm_ac_vi_cwmin=3
wmm_ac_vi_cwmax=4
wmm_ac_vi_txop_limit=94
wmm_ac_vi_acm=0
wmm_ac_vo_aifs=2
wmm_ac_vo_cwmin=2
wmm_ac_vo_cwmax=3
wmm_ac_vo_txop_limit=47
wmm_ac_vo_acm=0
eapol_key_index_workaround=0
eap_server=0
own_ip_addr=127.0.0.1
wpa=3
wpa_passphrase=ashwinalwyn
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP

...............................................

hostapd log file:

..............................................

Configuration file: /home/user/test/hostapd.conf
ctrl_interface_group=0
nl80211: Register Action command failed: ret=-114 (Operation already
in progress)
nl80211: Register Action match - hexdump(len=1): 06
nl80211: Failed to register Action frame processing - ignore for now
nl80211: Add own interface ifindex 12
nl80211: Add own interface ifindex 3
nl80211: New interface mon.wlan0 created: ifindex=13
nl80211: Add own interface ifindex 13
nl80211: Adding interface wlan0 into bridge br0
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=14 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=14 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=14 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=14 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=14 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=14 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=14 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=14 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=14 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=14 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=14 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=14 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=14 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=14 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=14 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=14 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=14 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=14 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=14 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=14 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=14 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=14 dBm
RATE[0] rate=10 flags=0x1
RATE[1] rate=20 flags=0x1
RATE[2] rate=55 flags=0x1
RATE[3] rate=110 flags=0x1
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Completing interface initialization
Mode: IEEE 802.11g  Channel: 1  Frequency: 2412 MHz
Flushing old station entries
Deauthenticate all stations
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=0
set_tx=1 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=1
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=2
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=3
set_tx=0 seq_len=0 key_len=0
Using interface wlan0 with hwaddr 1c:4b:d6:e7:8c:f8 and ssid 'test'
Deriving WPA PSK based on passphrase
SSID - hexdump_ascii(len=4):
     74 65 73 74                                       test
PSK (ASCII passphrase) - hexdump_ascii(len=11): [REMOVED]
PSK (from passphrase) - hexdump(len=32): [REMOVED]
WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
wpa_driver_nl80211_set_key: ifindex=3 alg=2 addr=(nil) key_idx=1
set_tx=1 seq_len=0 key_len=32
nl80211: Set beacon (beacon_set=0)
wlan0: Setup of interface done.
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 12 for bridge br0
nl80211: Add own interface ifindex 12
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'br0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 12 for bridge br0
nl80211: Add own interface ifindex 12
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 12 for bridge br0
nl80211: Add own interface ifindex 12
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
mgmt::auth
authentication: STA=5c:da:d4:d9:25:f2 auth_alg=0 auth_transaction=1
status_code=0 wep=0
  New STA
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: authentication OK (open system)
wlan0: STA 5c:da:d4:d9:25:f2 MLME:
MLME-AUTHENTICATE.indication(5c:da:d4:d9:25:f2, OPEN_SYSTEM)
wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-DELETEKEYS.request(5c:da:d4:d9:25:f2)
authentication reply: STA=5c:da:d4:d9:25:f2 auth_alg=0
auth_transaction=2 resp=0 (IE len=0)
mgmt::auth cb
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: authenticated
mgmt::assoc_req
association request: STA=5c:da:d4:d9:25:f2 capab_info=0x431 listen_interval=10
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
WMM IE - hexdump(len=7): 00 50 f2 02 00 01 00
Validating WMM IE: OUI 00:50:f2  OUI type 2  OUI sub-type 0  version 1
 QoS info 0x0
  new AID 1
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: association OK (aid 1)
mgmt::assoc_resp cb
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: associated (aid 1)
wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-ASSOCIATE.indication(5c:da:d4:d9:25:f2)
wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-DELETEKEYS.request(5c:da:d4:d9:25:f2)
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=5c:da:d4:d9:25:f2
wlan0: STA 5c:da:d4:d9:25:f2 WPA: event 1 notification
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=5c:da:d4:d9:25:f2
wlan0: STA 5c:da:d4:d9:25:f2 WPA: start authentication
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=5c:da:d4:d9:25:f2
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.1X: unauthorizing port
WPA: 5c:da:d4:d9:25:f2 WPA_PTK_GROUP entering state IDLE
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state AUTHENTICATION
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state AUTHENTICATION2
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITPSK
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
wlan0: STA 5c:da:d4:d9:25:f2 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
IEEE 802.1X: 5c:da:d4:d9:25:f2 TX status - version=2 type=3 length=95 - ack=1
wlan0: STA 5c:da:d4:d9:25:f2 WPA: EAPOL-Key timeout
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
wlan0: STA 5c:da:d4:d9:25:f2 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 5c:da:d4:d9:25:f2 TX status - version=2 type=3 length=95 - ack=1
wlan0: STA 5c:da:d4:d9:25:f2 WPA: EAPOL-Key timeout
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
wlan0: STA 5c:da:d4:d9:25:f2 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 5c:da:d4:d9:25:f2 TX status - version=2 type=3 length=95 - ack=1
wlan0: STA 5c:da:d4:d9:25:f2 WPA: EAPOL-Key timeout
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
wlan0: STA 5c:da:d4:d9:25:f2 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 5c:da:d4:d9:25:f2 TX status - version=2 type=3 length=95 - ack=1
wlan0: STA 5c:da:d4:d9:25:f2 WPA: EAPOL-Key timeout
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state DISCONNECT
hostapd_wpa_auth_disconnect: WPA authenticator requests disconnect:
STA 5c:da:d4:d9:25:f2 reason 2
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state DISCONNECTED
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=5c:da:d4:d9:25:f2
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.1X: unauthorizing port
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: deauthenticated due to local
deauth request
nl80211: Event message available
nl80211: Ignored unknown event (cmd=20)
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
mgmt::proberesp cb
mgmt::auth
authentication: STA=5c:da:d4:d9:25:f2 auth_alg=0 auth_transaction=1
status_code=0 wep=0
  New STA
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: authentication OK (open system)
wlan0: STA 5c:da:d4:d9:25:f2 MLME:
MLME-AUTHENTICATE.indication(5c:da:d4:d9:25:f2, OPEN_SYSTEM)
wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-DELETEKEYS.request(5c:da:d4:d9:25:f2)
authentication reply: STA=5c:da:d4:d9:25:f2 auth_alg=0
auth_transaction=2 resp=0 (IE len=0)
mgmt::auth cb
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: authenticated
mgmt::reassoc_req
reassociation request: STA=5c:da:d4:d9:25:f2 capab_info=0x431
listen_interval=10 current_ap=1c:4b:d6:e7:8c:f8
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
WMM IE - hexdump(len=7): 00 50 f2 02 00 01 00
Validating WMM IE: OUI 00:50:f2  OUI type 2  OUI sub-type 0  version 1
 QoS info 0x0
  new AID 1
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: association OK (aid 1)
mgmt::reassoc_resp cb
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: associated (aid 1)
wlan0: STA 5c:da:d4:d9:25:f2 MLME:
MLME-REASSOCIATE.indication(5c:da:d4:d9:25:f2)
wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-DELETEKEYS.request(5c:da:d4:d9:25:f2)
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=5c:da:d4:d9:25:f2
wlan0: STA 5c:da:d4:d9:25:f2 WPA: event 1 notification
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=5c:da:d4:d9:25:f2
wlan0: STA 5c:da:d4:d9:25:f2 WPA: start authentication
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=5c:da:d4:d9:25:f2
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.1X: unauthorizing port
WPA: 5c:da:d4:d9:25:f2 WPA_PTK_GROUP entering state IDLE
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state AUTHENTICATION
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state AUTHENTICATION2
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITPSK
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
wlan0: STA 5c:da:d4:d9:25:f2 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
IEEE 802.1X: 5c:da:d4:d9:25:f2 TX status - version=2 type=3 length=95 - ack=1
mgmt::disassoc
disassocation: STA=5c:da:d4:d9:25:f2 reason_code=8
AP-STA-DISCONNECTED 5c:da:d4:d9:25:f2
wlan0: STA 5c:da:d4:d9:25:f2 WPA: event 2 notification
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=5c:da:d4:d9:25:f2
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state DISCONNECTED
WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=5c:da:d4:d9:25:f2
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.1X: unauthorizing port
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: disassociated
wlan0: STA 5c:da:d4:d9:25:f2 MLME:
MLME-DISASSOCIATE.indication(5c:da:d4:d9:25:f2, 8)
wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-DELETEKEYS.request(5c:da:d4:d9:25:f2)
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=5c:da:d4:d9:25:f2
nl80211: Event message available
nl80211: Ignored unknown event (cmd=20)
wlan0: STA 5c:da:d4:d9:25:f2 WPA: EAPOL-Key timeout
Sending deauthentication info to STA 5c:da:d4:d9:25:f2
wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802

...................................................................


On Thu, Dec 15, 2011 at 12:55 PM, Ashwin Mendonca <ashwinloyal@gmail.com> wrote:
>
> I tried the bleeding edge build of compat-wireless (compat-wireless-2011-12-14 build) on Linux-3.1.5. It still leads to kernel panic. I manually got the AP up with these steps:
>
> 1. Removed ip from eth0
> 2. Created a bridge with brctl
> 3. Added eth0 to br0
> 4. Ran hostapd with my con file. And it showed this error:
>     l2_packet_receive - recvfrom: Network is down
> 5. Tried to connect my client devices. None were getting authenticated.
> 6. I assigned an ip to br0. Client got authenticated. System on AP mode froze.
>
> My hostapd.conf:
>
> ################################################
> interface=wlan0
> bridge=br0
> driver=nl80211
> logger_syslog=-1
> logger_syslog_level=2
> logger_stdout=-1
> logger_stdout_level=2
> dump_file=/tmp/hostapd.dump
> ctrl_interface=/var/run/hostapd
> ctrl_interface_group=0
> ssid=test
> hw_mode=g
> channel=1
> beacon_int=100
> dtim_period=2
> max_num_sta=255
> rts_threshold=2347
> fragm_threshold=2346
> macaddr_acl=0
> auth_algs=1
> ignore_broadcast_ssid=0
> wmm_enabled=1
> wmm_ac_bk_cwmin=4
> wmm_ac_bk_cwmax=10
> wmm_ac_bk_aifs=7
> wmm_ac_bk_txop_limit=0
> wmm_ac_bk_acm=0
> wmm_ac_be_aifs=3
> wmm_ac_be_cwmin=4
> wmm_ac_be_cwmax=10
> wmm_ac_be_txop_limit=0
> wmm_ac_be_acm=0
> wmm_ac_vi_aifs=2
> wmm_ac_vi_cwmin=3
> wmm_ac_vi_cwmax=4
> wmm_ac_vi_txop_limit=94
> wmm_ac_vi_acm=0
> wmm_ac_vo_aifs=2
> wmm_ac_vo_cwmin=2
> wmm_ac_vo_cwmax=3
> wmm_ac_vo_txop_limit=47
> wmm_ac_vo_acm=0
> eapol_key_index_workaround=0
> eap_server=0
> own_ip_addr=127.0.0.1
> wpa=3
> wpa_passphrase=ashwinalwyn
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=TKIP
> rsn_pairwise=CCMP
>
> ####################################################
>
> hostapd log file:
>
> #####################################################
>
> Configuration file: /home/user/test/hostapd.conf
> ctrl_interface_group=0
> nl80211: Register Action command failed: ret=-114 (Operation already in progress)
> nl80211: Register Action match - hexdump(len=1): 06
> nl80211: Failed to register Action frame processing - ignore for now
> nl80211: Add own interface ifindex 12
> nl80211: Add own interface ifindex 3
> nl80211: New interface mon.wlan0 created: ifindex=13
> nl80211: Add own interface ifindex 13
> nl80211: Adding interface wlan0 into bridge br0
> BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
> nl80211: Added 802.11b mode based on 802.11g information
> Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=14 dBm
> Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=14 dBm
> Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=14 dBm
> RATE[0] rate=10 flags=0x1
> RATE[1] rate=20 flags=0x1
> RATE[2] rate=55 flags=0x1
> RATE[3] rate=110 flags=0x1
> RATE[4] rate=60 flags=0x0
> RATE[5] rate=90 flags=0x0
> RATE[6] rate=120 flags=0x0
> RATE[7] rate=180 flags=0x0
> RATE[8] rate=240 flags=0x0
> RATE[9] rate=360 flags=0x0
> RATE[10] rate=480 flags=0x0
> RATE[11] rate=540 flags=0x0
> Completing interface initialization
> Mode: IEEE 802.11g  Channel: 1  Frequency: 2412 MHz
> Flushing old station entries
> Deauthenticate all stations
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=0 set_tx=1 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
> Using interface wlan0 with hwaddr 1c:4b:d6:e7:8c:f8 and ssid 'test'
> Deriving WPA PSK based on passphrase
> SSID - hexdump_ascii(len=4):
>      74 65 73 74                                       test
> PSK (ASCII passphrase) - hexdump_ascii(len=11): [REMOVED]
> PSK (from passphrase) - hexdump(len=32): [REMOVED]
> WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
> GMK - hexdump(len=32): [REMOVED]
> GTK - hexdump(len=32): [REMOVED]
> WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
> wpa_driver_nl80211_set_key: ifindex=3 alg=2 addr=(nil) key_idx=1 set_tx=1 seq_len=0 key_len=32
> nl80211: Set beacon (beacon_set=0)
> wlan0: Setup of interface done.
> RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Unknown event 5
> RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
> RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
> Unknown event 5
> RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
> Unknown event 5
> RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Unknown event 5
> nl80211: Add ifindex 12 for bridge br0
> nl80211: Add own interface ifindex 12
> RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
> RTM_NEWLINK, IFLA_IFNAME: Interface 'br0' added
> Unknown event 5
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Unknown event 5
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Unknown event 5
> nl80211: Add ifindex 12 for bridge br0
> nl80211: Add own interface ifindex 12
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Unknown event 5
> nl80211: Add ifindex 12 for bridge br0
> nl80211: Add own interface ifindex 12
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Unknown event 5
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> mgmt::auth
> authentication: STA=5c:da:d4:d9:25:f2 auth_alg=0 auth_transaction=1 status_code=0 wep=0
>   New STA
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: authentication OK (open system)
> wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-AUTHENTICATE.indication(5c:da:d4:d9:25:f2, OPEN_SYSTEM)
> wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-DELETEKEYS.request(5c:da:d4:d9:25:f2)
> authentication reply: STA=5c:da:d4:d9:25:f2 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
> mgmt::auth cb
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: authenticated
> mgmt::assoc_req
> association request: STA=5c:da:d4:d9:25:f2 capab_info=0x431 listen_interval=10
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> WMM IE - hexdump(len=7): 00 50 f2 02 00 01 00
> Validating WMM IE: OUI 00:50:f2  OUI type 2  OUI sub-type 0  version 1  QoS info 0x0
>   new AID 1
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: association OK (aid 1)
> mgmt::assoc_resp cb
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: associated (aid 1)
> wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-ASSOCIATE.indication(5c:da:d4:d9:25:f2)
> wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-DELETEKEYS.request(5c:da:d4:d9:25:f2)
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=5c:da:d4:d9:25:f2
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: event 1 notification
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=5c:da:d4:d9:25:f2
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: start authentication
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=5c:da:d4:d9:25:f2
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.1X: unauthorizing port
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK_GROUP entering state IDLE
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state AUTHENTICATION
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state AUTHENTICATION2
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITPSK
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: sending 1/4 msg of 4-Way Handshake
> WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
> nl80211: Event message available
> nl80211: Ignored unknown event (cmd=19)
> IEEE 802.1X: 5c:da:d4:d9:25:f2 TX status - version=2 type=3 length=95 - ack=1
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: EAPOL-Key timeout
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: sending 1/4 msg of 4-Way Handshake
> WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
> IEEE 802.1X: 5c:da:d4:d9:25:f2 TX status - version=2 type=3 length=95 - ack=1
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: EAPOL-Key timeout
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: sending 1/4 msg of 4-Way Handshake
> WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
> IEEE 802.1X: 5c:da:d4:d9:25:f2 TX status - version=2 type=3 length=95 - ack=1
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: EAPOL-Key timeout
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: sending 1/4 msg of 4-Way Handshake
> WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
> IEEE 802.1X: 5c:da:d4:d9:25:f2 TX status - version=2 type=3 length=95 - ack=1
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: EAPOL-Key timeout
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state DISCONNECT
> hostapd_wpa_auth_disconnect: WPA authenticator requests disconnect: STA 5c:da:d4:d9:25:f2 reason 2
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state DISCONNECTED
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=5c:da:d4:d9:25:f2
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.1X: unauthorizing port
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: deauthenticated due to local deauth request
> nl80211: Event message available
> nl80211: Ignored unknown event (cmd=20)
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for broadcast SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> STA 5c:da:d4:d9:25:f2 sent probe request for our SSID
> mgmt::proberesp cb
> mgmt::auth
> authentication: STA=5c:da:d4:d9:25:f2 auth_alg=0 auth_transaction=1 status_code=0 wep=0
>   New STA
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: authentication OK (open system)
> wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-AUTHENTICATE.indication(5c:da:d4:d9:25:f2, OPEN_SYSTEM)
> wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-DELETEKEYS.request(5c:da:d4:d9:25:f2)
> authentication reply: STA=5c:da:d4:d9:25:f2 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
> mgmt::auth cb
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: authenticated
> mgmt::reassoc_req
> reassociation request: STA=5c:da:d4:d9:25:f2 capab_info=0x431 listen_interval=10 current_ap=1c:4b:d6:e7:8c:f8
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
> WMM IE - hexdump(len=7): 00 50 f2 02 00 01 00
> Validating WMM IE: OUI 00:50:f2  OUI type 2  OUI sub-type 0  version 1  QoS info 0x0
>   new AID 1
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: association OK (aid 1)
> mgmt::reassoc_resp cb
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: associated (aid 1)
> wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-REASSOCIATE.indication(5c:da:d4:d9:25:f2)
> wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-DELETEKEYS.request(5c:da:d4:d9:25:f2)
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=5c:da:d4:d9:25:f2
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: event 1 notification
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=5c:da:d4:d9:25:f2
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: start authentication
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=5c:da:d4:d9:25:f2
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.1X: unauthorizing port
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK_GROUP entering state IDLE
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state AUTHENTICATION
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state AUTHENTICATION2
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITPSK
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state PTKSTART
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: sending 1/4 msg of 4-Way Handshake
> WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
> nl80211: Event message available
> nl80211: Ignored unknown event (cmd=19)
> IEEE 802.1X: 5c:da:d4:d9:25:f2 TX status - version=2 type=3 length=95 - ack=1
> mgmt::disassoc
> disassocation: STA=5c:da:d4:d9:25:f2 reason_code=8
> AP-STA-DISCONNECTED 5c:da:d4:d9:25:f2
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: event 2 notification
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=5c:da:d4:d9:25:f2
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state DISCONNECTED
> WPA: 5c:da:d4:d9:25:f2 WPA_PTK entering state INITIALIZE
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=5c:da:d4:d9:25:f2
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.1X: unauthorizing port
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802.11: disassociated
> wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-DISASSOCIATE.indication(5c:da:d4:d9:25:f2, 8)
> wlan0: STA 5c:da:d4:d9:25:f2 MLME: MLME-DELETEKEYS.request(5c:da:d4:d9:25:f2)
> wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x8c5f588 key_idx=0 set_tx=1 seq_len=0 key_len=0
>    addr=5c:da:d4:d9:25:f2
> nl80211: Event message available
> nl80211: Ignored unknown event (cmd=20)
> wlan0: STA 5c:da:d4:d9:25:f2 WPA: EAPOL-Key timeout
> Sending deauthentication info to STA 5c:da:d4:d9:25:f2
> wlan0: STA 5c:da:d4:d9:25:f2 IEEE 802
>
> #####################################################
>
>
> On Thu, Dec 15, 2011 at 11:18 AM, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>>
>> On Wed, Dec 14, 2011 at 10:53 PM, Ashwin Mendonca <ashwinloyal@gmail.com> wrote:
>> > I can enable AP mode on my netbook. But when I turn on a wireless
>> > client device, then the sytem on AP mode freezes. It has happened
>> > since 2.3.38. When I installaed ath9k driver compiled from
>> > compat-wireless on linux 2.3.38, the issue got disappered. But the
>> > ath9k driver packed with the kernel still has the issue. On Ubuntu
>> > 11.10, all linux 3.0 releases (the current stable release  Ubuntu
>> > 3.0.14) have the issue. I compiled 3.1.5 stable kernel from sources,
>> > which also has the issue. I recently compiled
>> > compat-wireless-3.2-rc1-1, which also got my system frozen. This is
>> > the bug that I filled at Launchpad:
>> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/875503
>>
>> some time back the STA mode itself had this issue, but was fixed by
>> https://lkml.org/lkml/2011/4/12/269
>> could you please let us know whether this issue happens in
>> http://linuxwireless.org/en/users/Download#Where_to_download_bleeding_edge
>>
>> i just tried to put AR2427 in AP mode and then connected a STA, did
>> not seem to cause any issue in 3.2.0-rc5-wl. please also post your
>> hostapd.conf and your hostapd --version
>>
>>
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> shafi
>
>
