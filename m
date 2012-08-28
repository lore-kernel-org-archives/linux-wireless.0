Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([125.18.18.171]:13902 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2H1Ozm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 10:55:42 -0400
From: Girish Bn <Girish.BN@lnties.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Crash with Wl12xx driver while Concurrent operation(P2P and Wi-Fi
 legacy)
Date: Tue, 28 Aug 2012 14:45:37 +0000
Message-ID: <45566970CF58C74CB52107862E0541CD1D1AC80D@POCITMSEXMB03.LntUniverse.com> (sfid-20120828_165548_257607_4F457397)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
We have backported the latest compat wireless package (compat-wireless-2012-08-26) to Linux 2.6.28.2 kernel running on LPC3130 platform.
The firmware version used -  Rev 6.3.10.2.115
Wpa Supplicant ver -1.0
We need to operate the wl1271 in concurrent mode.
The supplicant configuration is as follows
ctrl_interface=/var/run/wpa_supplicant
ap_scan=1
driver_param=use_p2p_group_interface=1
device_name=TI-WILINK-P2P
device_type=1-0050F204-1
#sec_device_type=1-0050F204-1
# If you need to modify the group owner intent, 0-15, the higher
# number indicates preference to become the GO
p2p_go_intent=15
# optional, can be useful for monitoring, forces
# wpa_supplicant to use only channel 1 rather than
# 1, 6 and 11:
p2p_listen_reg_class=81
p2p_listen_channel=1
p2p_oper_reg_class=81
p2p_oper_channel=1

network={
        mode=3
        disabled=2
        ssid="DIRECT-AB"
        key_mgmt=WPA-PSK
        proto=RSN
        pairwise=CCMP
        group=CCMP TKIP
        psk="12345678"
}
#####
I am starting the supplicant with the following command
./wpa_supplicant -Dnl80211 -i wlan0 -c /wlan/wpa_supplicant.conf -d &
Starting the supplicant is successful.
However, while making the device in Persistent Group Owner mode using the command( ./wpa_cli -i wlan0 p2p_group_add persistent=0), the driver crashes
The log as follows

/wlan # rz[J
/wlan # ls -l[J
/wlan # clear[J
/wlan # dmesg -c[J
/wlan # clear[J
/wlan # rm -rf wpa_supplicant.conf [J
/wlan # ls -l[J
/wlan # kill 392[J
/wlan # ps[J
/wlan # ./wpa_supplicant -Dnl80211 -i wlan0 -c /wlan/wpa_supplicant.conf -d &[J
/wlan # wpa_supplicant v1.0
random: Trying to read entropy from /dev/random
Initializing interface 'wlan0' conf '/wlan/wpa_supplicant.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/wlan/wpa_supplicant.conf' -> '/wlan/wpa_supplicant.conf'
Reading configuration file '/wlan/wpa_supplicant.conf'
ctrl_interface='/var/run/wpa_supplicant'
ap_scan=1
driver_param='use_p2p_group_interface=1'
device_name='TI-WILINK-P2P'
p2p_go_intent=15
p2p_listen_reg_class=81
p2p_listen_channel=1
p2p_oper_reg_class=81
p2p_oper_channel=1
Priority group 0
   id=0 ssid='DIRECT-AB'
nl80211: interface wlan0 in phy phy0
rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
nl80211: Set mode ifindex 2 iftype 2 (STATION)
netlink: Operstate: linkmode=1, operstate=5
nl80211: Using driver-based off-channel TX
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: Register frame command failed (type=208): ret=-114 (Operation already in progress)
nl80211: Register frame match - hexdump(len=2): 04 0a
nl80211: Failed to register Action frame processing - ignore for now
nl80211: driver param='use_p2p_group_interface=1'
nl80211: Use separate P2P group interface
nl80211: Regulatory information - country=00
nl80211: 2402-2472 @ 40 MHz
nl80211: 2457-2482 @ 20 MHz
nl80211: 2474-2494 @ 20 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5735-5835 @ 40 MHz
nl80211: 57240-63720 @ 2160 MHz
wlan0: Own MAC address: 00:12:34:56:78:90
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
wlan0: RSN: flushing PMKID list in the driver
nl80211: Flush PMKIDs
wlan0: State: DISCONNECTED -> INACTIVE
WPS: Set UUID for interface wlan0
WPS: UUID based on MAC address - hexdump(len=16): e8 f0 1f 99 6e b1 52 34 bf 7b 31 ba d1 79 f7 e8
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
P2P: Own listen channel: 1
P2P: Configured operating channel: 81:1
P2P: Add operating class 81
P2P: Channels - hexdump(len=11): 01 02 03 04 05 06 07 08 09 0a 0b
wlan0: Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: if_removed already cleared - ignore event
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized

/wlan # ./wpa_cli -i wlan0 p2p_group_add persistent=0 freq=2412
RX ctrl_iface - hexdump_ascii(len=36):
     50 32 50 5f 47 52 4f 55 50 5f 41 44 44 20 70 65   P2P_GROUP_ADD pe
     72 73 69 73 74 65 6e 74 3d 30 20 66 72 65 71 3d   rsistent=0 freq=
     32 34 31 32                                       2412
wlan0: P2P: Stopping find
wlan0: P2P: Clear timeout (state=IDLE)
wlan0: P2P: State IDLE -> IDLE
P2P: Set GO freq based on forced frequency 2412 MHz
P2P: Create a new interface p2p-wlan0-0 for the group
nl80211: Create interface iftype 9 (P2P_GO)
nl80211: New interface p2p-wlan0-0 created: ifindex=3
nl80211: Set TX rates failed: ret=-100 (Network is down)
P2P: Created pending virtual interface p2p-wlan0-0 addr 00:12:34:56:78:91
Initializing interface 'p2p-wlan0-0' conf 'N/A' driver 'nl80211' ctrl_interface '/var/run/wpa_supplicant' bridge 'N/A'
nl80211: interface p2p-wlan0-0 in phy phy0
rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
netlink: Operstate: linkmode=1, operstate=5
nl80211: Using driver-based off-channel TX
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: driver param='use_p2p_group_interface=1'
nl80211: Use separate P2P group interface
nl80211: Regulatory information - country=00
nl80211: 2402-2472 @ 40 MHz
nl80211: 2457-2482 @ 20 MHz
nl80211: 2474-2494 @ 20 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5735-5835 @ 40 MHz
nl80211: 57240-63720 @ 2160 MHz
p2p-wlan0-0: Own MAC address: 00:12:34:56:78:91
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
p2p-wlan0-0: RSN: flushing PMKID list in the driver
nl80211: Flush PMKIDs
p2p-wlan0-0: State: DISCONNECTED -> INACTIVE
WPS: Set UUID for interface p2p-wlan0-0
WPS: UUID from the first interface - hexdump(len=16): e8 f0 1f 99 6e b1 52 34 bf 7b 31 ba d1 79 f7 e8
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Using existing control interface directory.
p2p-wlan0-0: Added interface p2p-wlan0-0
p2p-wlan0-0: Setting scan request: 0 sec 0 usec
p2p-wlan0-0: State: INACTIVE -> SCANNING
Start a pre-selected network without scan step
Setting up AP (SSID='DIRECT-AB')
nl80211: Setup AP operations for P2P group (GO)
nl80211: Set mode ifindex 3 iftype 9 (P2P_GO)
nl80211: Create interface iftype 6 (MONITOR)
OK
/wlan # nl80211: New interface mon-wlan0-0 created: ifindex=4
nl80211: Set freq 2412 (ht_enabled=0 sec_channel_offset=0)
P2P: * P2P IE header
P2P: * Capability dev=21 group=4b
P2P: * Device Info
P2P: * P2P IE header
P2P: * Capability dev=21 group=4b
P2P: * Device ID: 00:12:34:56:78:90
P2P: GO - group idle
P2P: * P2P IE header
P2P: * Capability dev=21 group=0b
P2P: * Device Info
P2P: * P2P IE header
P2P: * Capability dev=21 group=0b
P2P: * Device ID: 00:12:34:56:78:90
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Regulatory information - country=00
nl80211: 2402-2472 @ 40 MHz
nl80211: 2457-2482 @ 20 MHz
nl80211: 2474-2494 @ 20 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5735-5835 @ 40 MHz
nl80211: 57240-63720 @ 2160 MHz
Completing interface initialization
Mode: IEEE 802.11g  Channel: 1  Frequency: 2412 MHz
nl80211: Set freq 2412 (ht_enabled=0 sec_channel_offset=0)
RATE[0] rate=60 flags=0x1
RATE[1] rate=90 flags=0x0
RATE[2] rate=120 flags=0x1
RATE[3] rate=180 flags=0x0
RATE[4] rate=240 flags=0x1
RATE[5] rate=360 flags=0x0
RATE[6] rate=480 flags=0x0
RATE[7] rate=540 flags=0x0
Flushing old station entries
Deauthenticate all stations
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
Using interface p2p-wlan0-0 with hwaddr 00:12:34:56:78:91 and ssid 'DIRECT-AB'
Deriving WPA PSK based on passphrase
SSID - hexdump_ascii(len=9):
     44 49 52 45 43 54 2d 41 42                        DIRECT-AB
PSK (ASCII passphrase) - hexdump_ascii(len=8): [REMOVED]
PSK (from passphrase) - hexdump(len=32): [REMOVED]
WPS: Use configured UUID - hexdump(len=16): e8 f0 1f 99 6e b1 52 34 bf 7b 31 ba d1 79 f7 e8
WPS: Build Beacon IEs
WPS:  * Version (hardcoded 0x10)
WPS:  * Wi-Fi Protected Setup State (2)
WPS:  * Version2 (0x20)
WPS:  * Device Name
WPS:  * Primary Device Type
WPS: Build Probe Response IEs
WPS:  * Version (hardcoded 0x10)
WPS:  * Wi-Fi Protected Setup State (2)
WPS:  * Response Type (3)
WPS:  * UUID-E
WPS:  * Manufacturer
WPS:  * Model Name
WPS:  * Model Number
WPS:  * Serial Number
WPS:  * Primary Device Type
WPS:  * Device Name
WPS:  * Config Methods (2108)
WPS:  * RF Bands (1)
WPS:  * Version2 (0x20)
random: Cannot read from /dev/random: Resource temporarily unavailable
random: Got 0/20 bytes from /dev/random
random: Only 0/20 bytes of strong random data available from /dev/random
random: Not enough entropy pool available for secure operations
WPA: Not enough entropy in random pool for secure operations - update keys later when the first station connects
GMK - hexdump(len=32): [REMOVED]
Key Counter - hexdump(len=32): [REMOVED]
WPA: Delay group state machine start until Beacon frames have been configured
WPS: Building WPS IE for (Re)Association Response
WPS:  * Version (hardcoded 0x10)
WPS:  * Response Type (3)
WPS:  * Version2 (0x20)
nl80211: Set beacon (beacon_set=0)
WPA: Start group state machine to set initial keys
WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
GTK - hexdump(len=16): [REMOVED]
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
wpa_driver_nl80211_set_key: ifindex=3 alg=3 addr=0x8f326 key_idx=1 set_tx=1 seq_len=0 key_len=16
   broadcast key
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
netlink: Operstate: linkmode=-1, operstate=6
p2p-wlan0-0: State: SCANNING -> COMPLETED
p2p-wlan0-0: CTRL-EVENT-CONNECTED - Connection to 00:12:34:56:78:91 completed (auth) [id=0 id_str=]
wpa_driver_nl80211_set_operstate: operstate 1->1 (UP)
netlink: Operstate: linkmode=-1, operstate=6
P2P: Group setup without provisioning
wlan0: P2P-GROUP-STARTED p2p-wlan0-0 GO ssid="DIRECT-AB" freq=2412 passphrase="12345678" go_dev_addr=00:12:34:56:78:90 [PERSISTENT]
P2P: Storing credentials for a persistent group (GO Dev Addr 00:12:34:56:78:90)
P2P: Create a new persistent group entry
p2p-wlan0-0: Setup of interface done.
RTM_NEWLINK: operstate=1 ifi_flags=0x1002 ()
nl80211: Ignore interface down event since interface p2p-wlan0-0 is up
RTM_NEWLINK: operstate=1 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan0-0' added
nl80211: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=1 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan0-0' added
nl80211: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=1 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan0-0' added
nl80211: if_removed already cleared - ignore event
nl80211: Ignore event for foreign ifindex 4
nl80211: Ignore event for foreign ifindex 4
RTM_NEWLINK: operstate=1 ifi_flags=0x11003 ([UP][LOWER_UP])
netlink: Operstate: linkmode=-1, operstate=6
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan0-0' added
nl80211: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan0-0' added
nl80211: if_removed already cleared - ignore event
EAPOL: disable timer tick
AP mode active - skip EAPOL Supplicant port status: Unauthorized
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received
p2p-wlan0-0: Event RX_MGMT (20) received

/wlan # ./wp
/wlan # ./wpa_[Jcl
/wlan # ./wpa_cli [Jstatus
Selected interface 'p2p-wlan0-0'
RX ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS
bssid=00:12:34:56:78:91
ssid=DIRECT-AB
id=0
mode=P2P GO
pairwise_cipher=CCMP
group_cipher=CCMP
key_mgmt=WPA2-PSK
wpa_state=COMPLETED
p2p_device_address=00:12:34:56:78:90
address=00:12:34:56:78:91
/wlan # dmesg
Powering on wl12xx<6>Powering up MMC Slot<6>wl12xx: firmware booted (Rev 6.3.10.2.115)
[  724.990000] wl12xx: down
[  724.990000] Powering off wl12xx<6>Powering down MMC Slot<6>ieee80211 phy0: Hardware restart was requested
[  725.030000] Powering on wl12xx<6>Powering up MMC Slot<6>wl12xx: firmware booted (Rev 6.5.7.0.27)
[  725.900000] ------------[ cut here ]------------
[  725.900000] WARNING: at /home/bps/compat-wireless-2012-08-26/drivers/net/wireless/ti/wlcore/tx.c:1114 wl1271_tx_min_rate_get+0x28/0x54 [wlcore]()
[  725.900000] Modules linked in: wlcore_sdio wl12xx wlcore compat_firmware_class mac80211 cfg80211 rfkill_backport compat lpc313x_mmc g_serial nxp_usb2_udc
[  725.900000] [<c0205590>] (dump_stack+0x0/0x1c) from [<c0037b80>] (warn_on_slowpath+0x54/0x70)
[  725.900000] [<c0037b2c>] (warn_on_slowpath+0x0/0x70) from [<bf0c0e98>] (wl1271_tx_min_rate_get+0x28/0x54 [wlcore])
[  725.900000]  r6:c161a890 r5:c159d780 r4:00000000
[  725.900000] [<bf0c0e70>] (wl1271_tx_min_rate_get+0x0/0x54 [wlcore]) from [<bf0b8d00>] (wl1271_op_bss_info_changed+0xdc/0xc24 [wlcore])
[  725.900000]  r5:c159d780 r4:c161a928
[  725.900000] [<bf0b8c24>] (wl1271_op_bss_info_changed+0x0/0xc24 [wlcore]) from [<bf06a56c>] (ieee80211_bss_info_change_notify+0x1dc/0x200 [mac80211])
[  725.900000] [<bf06a390>] (ieee80211_bss_info_change_notify+0x0/0x200 [mac80211]) from [<bf089b98>] (ieee80211_reconfig+0x584/0x9a0 [mac80211])
[  725.900000]  r7:c161a888 r6:c15f07d0 r5:c161a3a0 r4:c159cb00
[  725.900000] [<bf089614>] (ieee80211_reconfig+0x0/0x9a0 [mac80211]) from [<bf06b460>] (ieee80211_restart_work+0x7c/0x94 [mac80211])
[  725.910000] [<bf06b3e4>] (ieee80211_restart_work+0x0/0x94 [mac80211]) from [<c00487a4>] (run_workqueue+0xc4/0x14c)
[  725.910000]  r7:00000000 r6:bf06b3e4 r5:c14d2000 r4:c1fef280
[  725.910000] [<c00486e0>] (run_workqueue+0x0/0x14c) from [<c0048f18>] (worker_thread+0x10c/0x120)
[  725.910000]  r7:c1fef288 r6:c14d3fa4 r5:c14d2000 r4:c1fef280
[  725.910000] [<c0048e0c>] (worker_thread+0x0/0x120) from [<c004c888>] (kthread+0x60/0x9c)
[  725.910000]  r7:00000000 r6:c1fef280 r5:c0048e0c r4:c14d2000
[  725.910000] [<c004c828>] (kthread+0x0/0x9c) from [<c003ab6c>] (do_exit+0x0/0x734)
[  725.910000]  r7:00000000 r6:00000000 r5:00000000 r4:00000000
[  725.910000] ---[ end trace 1cd0b968bc5f5a81 ]---
[  725.910000] wl12xx: ERROR AP rate policy change failed -22
Can you please let me know the reason behind crash? Also confirm the driver and firmware version being used is right or not?

Thanks
Girish


Larsen & Toubro Limited

www.larsentoubro.com

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
