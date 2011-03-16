Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f52.google.com ([209.85.212.52]:54361 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab1CPPaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 11:30:19 -0400
Received: by vws16 with SMTP id 16so2096035vws.11
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 08:30:18 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 16 Mar 2011 16:24:56 +0100
Message-ID: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
Subject: rt2800usb stops working with big file transfers in AP and IBSS
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

We have some Ralink RT3071 devices (Delock 88524) and we need to
configure them either as Ad-Hoc or Access Point. In both cases I get a
connection and seems to work for transferring small files (1MByte).
Whenever I start sending more (500Mbytes) then it starts, holds for
some time (3 seconds maybe) and then it drops. After that, the
connection is useless and things need to be restarted. We have a
laptop with an Intel 3945ABG which has no problems with the connection
and the big file, but all other devices (ralink 8188cu chipsets and
others) stop working when doing the big file transfer. The file
transfer is done via samba server with a windows xp machine as
counterpart. But that is not it as http transfer also stalls
everything.

I am using the compat-wireless driver from the 10th of March, cross
compiled against kernel 2.6.24.

I am using the firmware that can be downloaded from the Ralink website
V22 (any newer?)

For IBSS, I use iwconfig entirely and setup an uprotected connection
with a fixed ip address on both sides.

I do have a small issue on the 2.6.24 system due to cross compilation
(as my system was not pure 2.6.24) when registering the device....
dmesg shows:

#-----------------------------------------------------
sysfs: duplicate filename 'cpu_dma_latency' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 2442, comm: insmod Not tainted 2.6.24_atom-atom-x86_586 #29
 [<c01b19c8>] sysfs_add_one+0x54/0xb8
 [<c01b1e9b>] create_dir+0x3c/0x6c
 [<c01b1ef8>] sysfs_create_dir+0x2d/0x40
 [<c0245c55>] kobject_add+0xe9/0x190
 [<c0245b59>] kobject_set_name+0x81/0x94
 [<c02ae39e>] device_add+0x91/0x540
 [<c0245944>] kobject_init+0x29/0x37
 [<c02aebb7>] device_create+0x7a/0x9a
 [<c029cbca>] misc_register+0xc5/0xfe
 [<e0a6512b>] compat_pm_qos_power_init+0xe/0x70 [compat]
 [<e0869008>] compat_init+0x8/0x24 [compat]
 [<c014642b>] sys_init_module+0x17c4/0x189f
 [<c0178355>] do_sync_read+0xc7/0x10a
 [<c0244c41>] _atomic_dec_and_lock+0x2d/0x4c
 [<c0179549>] __fput+0x11a/0x144
 [<c0104ff2>] syscall_call+0x7/0xb
 =======================
kobject_add failed for cpu_dma_latency with -EEXIST, don't try to
register things with the same name in the same directory.
Pid: 2442, comm: insmod Not tainted 2.6.24_atom-atom-x86_586 #29
 [<c0245cca>] kobject_add+0x15e/0x190
 [<c0245b59>] kobject_set_name+0x81/0x94
 [<c02ae39e>] device_add+0x91/0x540
 [<c0245944>] kobject_init+0x29/0x37
 [<c02aebb7>] device_create+0x7a/0x9a
 [<c029cbca>] misc_register+0xc5/0xfe
 [<e0a6512b>] compat_pm_qos_power_init+0xe/0x70 [compat]
 [<e0869008>] compat_init+0x8/0x24 [compat]
 [<c014642b>] sys_init_module+0x17c4/0x189f
 [<c0178355>] do_sync_read+0xc7/0x10a
 [<c0244c41>] _atomic_dec_and_lock+0x2d/0x4c
 [<c0179549>] __fput+0x11a/0x144
 [<c0104ff2>] syscall_call+0x7/0xb
 =======================
pm_qos_param: cpu_dma_latency setup failed
Compat-wireless backport release: compat-wireless-2011-01-31-25-g9d8e201
Backport based on linux-next.git next-20110311
kfifo: module license 'unspecified' taints kernel.
Calling CRDA to update world regulatory domain
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
usbcore: registered new interface driver rt2800usb
#-----------------------------------------------------

But I don't think this is the issue as i have the same problem in
other systems that do not present these warnings/errors.

For the Access Point, I use HostAPD and DHCP

For HostAPD, i use:

My dhcp.conf looks like
#-----------------------------------------------------
option domain-name "MyDomain";
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.111.255;

default-lease-time 600;
max-lease-time 7200;
authoritative;
log-facility local7;

subnet 192.168.111.0 netmask 255.255.255.0 {
  range 192.168.111.1 192.168.111.254;
  option ip-forwarding off;
  default-lease-time 86400;
  max-lease-time 86400;
  option subnet-mask 255.255.255.0;
  option broadcast-address 192.168.111.255;
  authoritative;
}
#-----------------------------------------------------

My hostapd.conf looks like
#-----------------------------------------------------
interface=wlan5
driver=nl80211
ssid=rt3070ap_g2
channel=2
hw_mode=g
max_num_sta=1
#-----------------------------------------------------

HostAPD is correctly configured and connections are possible. DHCP
works as well as the devices get their IP address. HostAPD does not
show any irregularities, and any other log files do not give any
hints.

iwconfig shows
#-----------------------------------------------------
wlan5     IEEE 802.11bgn  Mode:Master  Frequency:2.417 GHz  Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:on

mon.wlan5  IEEE 802.11bgn  Mode:Monitor  Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:on
#-----------------------------------------------------

hostapd shows:
#-----------------------------------------------------
nl80211: Register Action command failed: ret=-114 (Operation already
in progress)
nl80211: Register Action match - hexdump(len=1): 06
nl80211: Failed to register Action frame processing - ignore for now
nl80211: Add own interface ifindex 4
nl80211: New interface mon.wlan5 created: ifindex=6
nl80211: Add own interface ifindex 6
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
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
Mode: IEEE 802.11g  Channel: 2  Frequency: 2417 MHz
Flushing old station entries
Deauthenticate all stations
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=0
set_tx=1 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=1
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=2
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=3
set_tx=0 seq_len=0 key_len=0
Using interface wlan5 with hwaddr 00:12:0e:b9:2d:31 and ssid 'rt3070ap_g2'
nl80211: Set beacon (beacon_set=0)
wlan5: Setup of interface done.
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan5' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan5' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
Unknown event 5
STA 00:12:0e:b2:ac:79 sent probe request for our SSID
STA 00:12:0e:b2:ac:79 sent probe request for our SSID
mgmt::proberesp cb
mgmt::proberesp cb
STA 00:12:0e:b2:ac:79 sent probe request for our SSID
mgmt::auth
authentication: STA=00:12:0e:b2:ac:79 auth_alg=0 auth_transaction=1
status_code=0 wep=0
  New STA
wlan5: STA 00:12:0e:b2:ac:79 IEEE 802.11: authentication OK (open system)
wlan5: STA 00:12:0e:b2:ac:79 MLME:
MLME-AUTHENTICATE.indication(00:12:0e:b2:ac:79, OPEN_SYSTEM)
wlan5: STA 00:12:0e:b2:ac:79 MLME: MLME-DELETEKEYS.request(00:12:0e:b2:ac:79)
authentication reply: STA=00:12:0e:b2:ac:79 auth_alg=0
auth_transaction=2 resp=0 (IE len=0)
mgmt::proberesp cb
mgmt::assoc_req
association request: STA=00:12:0e:b2:ac:79 capab_info=0x401 listen_interval=3
unknown vendor specific information element ignored (vendor OUI 00:0c:43 len=7)
  new AID 1
nl80211: Set beacon (beacon_set=1)
wlan5: STA 00:12:0e:b2:ac:79 IEEE 802.11: association OK (aid 1)
mgmt::auth cb
wlan5: STA 00:12:0e:b2:ac:79 IEEE 802.11: authenticated
Data/PS-poll frame from not associated STA 00:12:0e:b2:ac:79
mgmt::assoc_resp cb
wlan5: STA 00:12:0e:b2:ac:79 IEEE 802.11: associated (aid 1)
AP-STA-CONNECTED 00:12:0e:b2:ac:79
wlan5: STA 00:12:0e:b2:ac:79 MLME: MLME-ASSOCIATE.indication(00:12:0e:b2:ac:79)
wlan5: STA 00:12:0e:b2:ac:79 MLME: MLME-DELETEKEYS.request(00:12:0e:b2:ac:79)
wlan5: STA 00:12:0e:b2:ac:79 RADIUS: starting accounting session
4D80E204-00000000
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
STA 00:12:0e:b2:ac:79 sent probe request for our SSID
unknown mgmt cb frame subtype 10
STA 00:12:0e:b2:ac:79 sent probe request for our SSID
mgmt::proberesp cb
STA 00:01:e3:b7:cd:8b sent probe request for broadcast SSID
mgmt::proberesp cb
STA 00:01:e3:b7:cd:8b sent probe request for broadcast SSID
STA 00:01:e3:b7:cd:8b sent probe request for broadcast SSID
mgmt::proberesp cb
mgmt::proberesp cb
STA 00:01:e3:b7:cd:8b sent probe request for broadcast SSID
STA 00:01:e3:b7:cd:8b sent probe request for broadcast SSID
STA 00:01:e3:b7:cd:8b sent probe request for broadcast SSID
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
STA 00:12:0e:b2:ac:79 sent probe request for our SSID
mgmt::proberesp cb
mgmt::auth
authentication: STA=00:12:0e:b2:ac:79 auth_alg=0 auth_transaction=1
status_code=0 wep=0
wlan5: STA 00:12:0e:b2:ac:79 IEEE 802.11: authentication OK (open system)
wlan5: STA 00:12:0e:b2:ac:79 MLME:
MLME-AUTHENTICATE.indication(00:12:0e:b2:ac:79, OPEN_SYSTEM)
wlan5: STA 00:12:0e:b2:ac:79 MLME: MLME-DELETEKEYS.request(00:12:0e:b2:ac:79)
authentication reply: STA=00:12:0e:b2:ac:79 auth_alg=0
auth_transaction=2 resp=0 (IE len=0)
mgmt::proberesp cb
mgmt::assoc_req
association request: STA=00:12:0e:b2:ac:79 capab_info=0x401 listen_interval=3
unknown vendor specific information element ignored (vendor OUI 00:0c:43 len=7)
  old AID 1
wlan5: STA 00:12:0e:b2:ac:79 IEEE 802.11: association OK (aid 1)
mgmt::auth cb
wlan5: STA 00:12:0e:b2:ac:79 IEEE 802.11: authenticated
mgmt::assoc_resp cb
wlan5: STA 00:12:0e:b2:ac:79 IEEE 802.11: associated (aid 1)
AP-STA-CONNECTED 00:12:0e:b2:ac:79
wlan5: STA 00:12:0e:b2:ac:79 MLME: MLME-ASSOCIATE.indication(00:12:0e:b2:ac:79)
wlan5: STA 00:12:0e:b2:ac:79 MLME: MLME-DELETEKEYS.request(00:12:0e:b2:ac:79)
wlan5: STA 00:12:0e:b2:ac:79 RADIUS: starting accounting session
4D80E204-00000001
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
STA 00:01:e3:ff:2a:17 sent probe request for broadcast SSID
STA 00:01:e3:ff:2a:17 sent probe request for broadcast SSID
STA 00:01:e3:ff:2a:17 sent probe request for broadcast SSID
mgmt::proberesp cb
mgmt::proberesp cb
mgmt::proberesp cb
STA 00:01:e3:a0:75:ea sent probe request for broadcast SSID
STA 00:01:e3:a0:75:ea sent probe request for broadcast SSID
mgmt::proberesp cb
mgmt::proberesp cb

#-----------------------------------------------------

The last things I get when it stops working...

#-----------------------------------------------------
STA 00:25:cf:d6:c1:b4 sent probe request for broadcast SSID
STA 00:25:cf:d6:c1:b4 sent probe request for broadcast SSID
mgmt::proberesp cb
STA 00:25:cf:d6:c1:b4 sent probe request for broadcast SSID
mgmt::proberesp cb
mgmt::proberesp cb
STA 00:12:0e:b2:ac:79 sent probe request for broadcast SSID
STA 00:12:0e:b2:ac:79 sent probe request for our SSID
mgmt::proberesp cb
mgmt::proberesp cb
STA 00:01:e3:a0:75:ea sent probe request for broadcast SSID
STA 00:01:e3:a0:75:ea sent probe request for broadcast SSID
STA 00:01:e3:a0:75:ea sent probe request for broadcast SSID
STA 00:12:0e:b2:ac:79 sent probe request for broadcast SSID
STA 00:12:0e:b2:ac:79 sent probe request for our SSID
#-----------------------------------------------------

At syslog, i get:
#-----------------------------------------------------
Mar 16 16:15:16 LS817 dhcpd: DHCPREQUEST for 192.168.111.247
(192.168.111.33) from 00:12:0e:b2:ac:79 (DE1-03-003-3400) via wlan5
Mar 16 16:15:16 LS817 dhcpd: DHCPACK on 192.168.111.247 to
00:12:0e:b2:ac:79 (DE1-03-003-3400) via wlan5
Mar 16 16:15:16 LS817 dhcpd: DHCPREQUEST for 192.168.111.247
(192.168.111.33) from 00:12:0e:b2:ac:79 (DE1-03-003-3400) via wlan5
Mar 16 16:15:16 LS817 dhcpd: DHCPACK on 192.168.111.247 to
00:12:0e:b2:ac:79 (DE1-03-003-3400) via wlan5
Mar 16 16:15:33 LS817 dhcpd: DHCPINFORM from 192.168.111.247 via wlan5
Mar 16 16:15:33 LS817 dhcpd: DHCPACK to 192.168.111.247
(00:12:0e:b2:ac:79) via wlan5
Mar 16 16:15:33 LS817 dhcpd: DHCPINFORM from 192.168.111.247 via wlan5
Mar 16 16:15:33 LS817 dhcpd: DHCPACK to 192.168.111.247
(00:12:0e:b2:ac:79) via wlan5
Mar 16 16:19:26 LS817 smbd[2657]: [2011/03/16 16:19:26, 0]
../source/lib/util_sock.c:read_socket_data(384)
Mar 16 16:19:26 LS817 smbd[2657]:   read_socket_data: recv failure for
4. Error = Connection reset by peer
#-----------------------------------------------------

But as said, I don't think hostapd is the problem, I suppose it has to
do with the driver or the firmware.

If someone has the updated firmware, please send it to me, i'd appreciate it.

Some other info:

When this big file transfer fails, my ssh connections break.
When configured as ad-hoc mode, it won't allow to turn off power
savings (iwconfig wlan5 power off <-- fails)

What else can I do? How can I get more debug information about what's happening?

Best regards,
-- 
Juan Carlos Garza
