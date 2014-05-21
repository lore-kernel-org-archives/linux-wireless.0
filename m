Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.dewberryfields.co.uk ([217.41.92.67]:54411 "EHLO
	mail.dewberryfields.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaEULEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 07:04:04 -0400
Message-ID: <537C8821.6070507@dewberryfields.co.uk> (sfid-20140521_130408_747633_F9FAA5D5)
Date: Wed, 21 May 2014 12:04:01 +0100
From: Michael Howard <mike@dewberryfields.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Mwifiex driver on Globalscale Mirabox
References: <5346DED8.2030704@free.fr>
	<CAJwzM1k=OOBa7C3u0+TzmRUBwMYfJSMgB+smbORfKmPE6KnF2g@mail.gmail.com>
	<53480138.2080805@free.fr>	<53733AB4.7010500@free.fr>
	<20140514215126.GA15419@us.netrek.org>
	<CAJwzM1k+75qRJaONyehMNPaOqOHyBhryMGBtZ4NpD6jGHk-cHQ@mail.gmail.com>
	<5374F638.6000505@dewberryfields.co.uk>
	<CAJwzM1mvK1i3ENrQyVZNoiwYFiopWGRaOVe5iGTr61TQVXdaMQ@mail.gmail.com>
 <CAJwzM1mg5KVZFev4Gs9Qw43H5OwiLF3fmhwv8-3y9mEvWM6b6g@mail.gmail.com>
In-Reply-To: <CAJwzM1mg5KVZFev4Gs9Qw43H5OwiLF3fmhwv8-3y9mEvWM6b6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 16/05/2014 13:27, Avinash Patil wrote:
>
> Hi Michael,
>
> We are not able to reproduce this issue in our setup with sd8787 p96. 
> Could you please share hostapd config file, console logs and driver 
> debug logs?
>
> Thanks,
> -Avinash
>
>
H Avinash,

I was incorrect in my last message, the sd8787 AP had not started 
working when I installed the AR9287. So, here is my config;

interface=uap0
bridge=br0
driver=nl80211
ssid=TEST
hw_mode=g
channel=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=3
wpa_passphrase=????????????????
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
logger_syslog=-1
logger_syslog_level=0
logger_stdout=-1
logger_stdout_level=0
country_code=GB

dmesg;
ieee80211 phy0: ignoring F/W country code US
mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0 (14.66.9.p96)

console output;

root@mirabox:~# usr/sbin/hostapd -ddd /etc/hostapd/hostapd.conf
-bash: usr/sbin/hostapd: No such file or directory
root@mirabox:~# /usr/sbin/hostapd -ddd /etc/hostapd/hostapd.conf
random: Trying to read entropy from /dev/random
Configuration file: /etc/hostapd/hostapd.conf
nl80211: interface uap0 in phy phy0
rfkill: Cannot open RFKILL control device
nl80211: RFKILL status not available
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: Add own interface ifindex 6
nl80211: Add own interface ifindex 7
nl80211: Set mode ifindex 7 iftype 3 (AP)
nl80211: Create interface iftype 6 (MONITOR)
Failed to create interface mon.uap0: -95 (Operation not supported)
nl80211: Driver does not support monitor interface type - try to run 
without it
nl80211: Adding interface uap0 into bridge br0
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Regulatory information - country=00
nl80211: 2402-2472 @ 40 MHz
nl80211: 2457-2482 @ 40 MHz
nl80211: 2474-2494 @ 20 MHz
nl80211: 5170-5250 @ 160 MHz
nl80211: 5250-5330 @ 160 MHz
nl80211: 5490-5730 @ 160 MHz
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
Completing interface initialization
Mode: IEEE 802.11g  Channel: 1  Frequency: 2412 MHz
nl80211: Set freq 2412 (ht_enabled=0 sec_channel_offset=0)
Failed to update rate sets in kernel module
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
Flushing old station entries
Deauthenticate all stations
nl80211: Frame command failed: ret=-22 (Invalid argument) (freq=0 wait=0)
wpa_driver_nl80211_set_key: ifindex=7 alg=0 addr=(nil) key_idx=0 
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=7 alg=0 addr=(nil) key_idx=1 
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=7 alg=0 addr=(nil) key_idx=2 
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=7 alg=0 addr=(nil) key_idx=3 
set_tx=0 seq_len=0 key_len=0
Using interface uap0 with hwaddr 94:db:c9:cd:5a:46 and ssid 'TEST'
Deriving WPA PSK based on passphrase
SSID - hexdump_ascii(len=4):
      54 45 53 54                                       TEST
PSK (ASCII passphrase) - hexdump_ascii(len=14): [REMOVED]
PSK (from passphrase) - hexdump(len=32): [REMOVED]
random: Got 15/20 bytes from /dev/random
random: Only 15/20 bytes of strong random data available from /dev/random
random: Not enough entropy pool available for secure operations
WPA: Not enough entropy in random pool for secure operations - update 
keys later when the first station connects
Get randomness: len=32 entropy=0
random from os_get_random - hexdump(len=32): [REMOVED]
random_mix_pool - hexdump(len=20): [REMOVED]
random from internal pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=20): [REMOVED]
random from internal pool - hexdump(len=16): [REMOVED]
mixed random - hexdump(len=32): [REMOVED]
GMK - hexdump(len=32): [REMOVED]
Get randomness: len=32 entropy=0
random from os_get_random - hexdump(len=32): [REMOVED]
random_mix_pool - hexdump(len=20): [REMOVED]
random from internal pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=20): [REMOVED]
random from internal pool - hexdump(len=16): [REMOVED]
mixed random - hexdump(len=32): [REMOVED]
Key Counter - hexdump(len=32): [REMOVED]
WPA: Delay group state machine start until Beacon frames have been 
configured
VLAN: vlan_set_name_type(name_type=2)
nl80211: Set beacon (beacon_set=0)
nl80211: Ignore AP isolation configuration error since isolation is not used
WPA: Start group state machine to set initial keys
WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
Get randomness: len=16 entropy=0
random from os_get_random - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=20): [REMOVED]
random from internal pool - hexdump(len=16): [REMOVED]
mixed random - hexdump(len=16): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
wpa_driver_nl80211_set_key: ifindex=7 alg=2 addr=0xb6f5d77c key_idx=1 
set_tx=1 seq_len=0 key_len=32
    broadcast key
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
netlink: Operstate: linkmode=-1, operstate=6
Failed to set TX queue parameters for queue 0.
Failed to set TX queue parameters for queue 1.
Failed to set TX queue parameters for queue 2.
Failed to set TX queue parameters for queue 3.
uap0: Setup of interface done.
random: Got 5/5 bytes from /dev/random
RTM_NEWLINK: operstate=1 ifi_flags=0x1002 ()
nl80211: Ignore interface down event since interface uap0 is up
RTM_NEWLINK: operstate=1 ifi_flags=0x1002 ()
nl80211: Ignore interface down event since interface uap0 is up
RTM_NEWLINK: operstate=1 ifi_flags=0x1002 ()
nl80211: Ignore interface down event since interface uap0 is up
RTM_NEWLINK: operstate=1 ifi_flags=0x1002 ()
nl80211: Ignore interface down event since interface uap0 is up
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'br0' added
Unknown event 5
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'br0' added
Unknown event 5
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'br0' added
Unknown event 5
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'uap0' added
nl80211: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'uap0' added
nl80211: if_removed already cleared - ignore event
nl80211: Add ifindex 6 for bridge br0
nl80211: Add own interface ifindex 6
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'uap0' added
nl80211: if_removed already cleared - ignore event
nl80211: Add ifindex 6 for bridge br0
nl80211: Add own interface ifindex 6
VLAN: vlan_newlink(uap0)
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'uap0' added
nl80211: if_removed already cleared - ignore event
nl80211: Add ifindex 6 for bridge br0
nl80211: Add own interface ifindex 6
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'uap0' added
nl80211: if_removed already cleared - ignore event
nl80211: Add ifindex 6 for bridge br0
nl80211: Add own interface ifindex 6
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'uap0' added
nl80211: if_removed already cleared - ignore event
VLAN: vlan_newlink(uap0)
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'uap0' added
nl80211: if_removed already cleared - ignore event
nl80211: Add ifindex 6 for bridge br0
nl80211: Add own interface ifindex 6
VLAN: vlan_newlink(uap0)
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'uap0' added
nl80211: if_removed already cleared - ignore event
nl80211: Add ifindex 6 for bridge br0
nl80211: Add own interface ifindex 6
VLAN: vlan_newlink(uap0)

==> kern.log <== (on execution of hostapd)
May 21 10:37:01 mirabox kernel: mwifiex_sdio mmc0:0001:1: CMD_RESP: cmd 
0x112 error, result=0x2


As mentioned, the AP does not exist though hostapd appears to run.

The exact same configuration works with the AR9287 card.

Hope this helps.

Regards,
Mike.

-- 


