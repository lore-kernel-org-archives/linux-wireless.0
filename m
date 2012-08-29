Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([125.18.18.171]:65099 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2H2QP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 12:15:29 -0400
From: Girish Bn <Girish.BN@lnties.com>
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Crash with Wl12xx driver while Concurrent operation(P2P and
 Wi-Fi legacy)
Date: Wed, 29 Aug 2012 16:15:18 +0000
Message-ID: <45566970CF58C74CB52107862E0541CD1D1AF8B2@POCITMSEXMB03.LntUniverse.com> (sfid-20120829_181536_777075_E3B7EE05)
References: <45566970CF58C74CB52107862E0541CD1D1AC80D@POCITMSEXMB03.LntUniverse.com>
 <CA+XVXfcD4jMYQUy25pqWTBq18ZN7pMg++j-mZqW14GqC2OmfOA@mail.gmail.com>
In-Reply-To: <CA+XVXfcD4jMYQUy25pqWTBq18ZN7pMg++j-mZqW14GqC2OmfOA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have changed the way to test the concurrent operation.
I am following the steps listed Section 2.9(Scenario 2) in the link http://processors.wiki.ti.com/index.php/OMAP_Wireless_Connectivity_NLCP_Multi_Role_Configuration#configuring_the_station

I have taken the Compat Wireless 3.5 from the http://linuxwireless.org/en/users/Download/stable/
Also the firmware binaries from the link https://github.com/TI-OpenLink/ti-utils/commit/5b0914a1b65d98bb9ee3f85c478508ddef47e0cb
I have tried from Single role firmware versions from X.3.7.0.105 till X.3.7.0.120 and also corresponding release of multi-role firmware
I am unable to bring-up both the interfaces at a time.
I always get the "wl12xx: ERROR beacon info change failed: -22" error
Please find the log below
insmod comp
           cd /w
/ # cd /wlan/[J
/wlan # ls
[0;0mcfg80211.ko[0m               [0;0mrfkill_backport.ko[0m        [1;32mwpa_passphrase[0m
[0;0mcompat.ko[0m                 [0;0mwl12xx.ko[0m                 [1;32mwpa_supplicant[0m
[0;0mcompat_firmware_class.ko[0m  [0;0mwlcore.ko[0m                 [0;0mwpa_supplicant.TXT[0m
[0;0mmac80211.ko[0m               [0;0mwlcore_sdio.ko[0m            [0;0mwpa_supplicant.conf[0m
[0;0mp2p.conf[0m                  [1;32mwpa_cli[0m
/wlan # insmod comp

/wlan # insmod compat[J.ko
/wlan # insmod rf
/wlan # insmod rfkill_backport.ko [J
/wlan # insmod cfg
/wlan # insmod cfg80211.ko [J
/wlan # insmod mac
/wlan # insmod mac80211.ko [J
/wlan # insmod comp

/wlan # insmod compat[J_
/wlan # insmod compat_firmware_class.ko [J 
/wlan # insmod wlco

/wlan # insmod wlcore[J.ko
/wlan # insmod wl

/wlan # insmod wl[J12
/wlan # insmod wl12xx.ko [J
/wlan # insmod wl

/wlan # insmod wl[Jco

/wlan # insmod wlcore[J_s
/wlan # insmod wlcore_sdio.ko [J
/wlan # d ifconfig wlan0 hw ether 08:00:28:34:56:22
/wlan # ifconfig wlan0 10.2.30.34 netmask 255.255.255.0 up
/wlan # iw wlan0 set power_save off
/wlan # iw phy0 interface add wlan1 type managed  
/wlan # ifconfig wlan1 hw ether 08:00:28:44:56:83
/wlan # ./wpa_supplicant -d -Dnl80211 -c/wlan/wpa_supplicant.conf -iwlan0 -B
/wlan # ifconfig wlan1 hw ether 08:00:28:44:56:83[J
/wlan # ./wpa_supplicant -d -Dnl80211 -c/wlan/wpa_supplicant.conf -iwlan0 -B[J
/wlan # ifconfig wlan1 hw ether 08:00:28:44:56:83[J                                         cat wp

/wlan # cat wpa_[Js

/wlan # cat wpa_supplicant[J.c
/wlan # cat wpa_supplicant.conf [J
ctrl_interface=/var/run/wpa_supplicant
update_config=1
ap_scan=1

network={
        ssid="Leviton"
        psk="Sapphire@123"
        proto=WPA
        key_mgmt=WPA-PSK
        pairwise=CCMP TKIP
        group=CCMP TKIP
        auth_alg=OPEN
}

/wlan # ./wpa_supplicant -d -Dnl80211 -c/wlan/wpa_supplicant.conf -iwlan0 -B
wpa_supplicant v1.0
random: Trying to read entropy from /dev/random
Initializing interface 'wlan0' conf '/wlan/wpa_supplicant.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/wlan/wpa_supplicant.conf' -> '/wlan/wpa_supplicant.conf'
Reading configuration file '/wlan/wpa_supplicant.conf'
ctrl_interface='/var/run/wpa_supplicant'
update_config=1
ap_scan=1
Priority group 0
   id=0 ssid='Leviton'
nl80211: interface wlan0 in phy phy0
rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
nl80211: Set mode ifindex 2 iftype 2 (STATION)
netlink: Operstate: linkmode=1, operstate=5
nl80211: Using driver-based off-channel TX
nl80211: driver param='(null)'
nl80211: Regulatory information - country=00
nl80211: 2402-2472 @ 40 MHz
nl80211: 2457-2482 @ 20 MHz
nl80211: 2474-2494 @ 20 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5735-5835 @ 40 MHz
wlan0: Own MAC address: 08:00:28:34:56:22
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
wlan0: RSN: flushing PMKID list in the driver
nl80211: Flush PMKIDs
wlan0: Setting scan request: 0 sec 100000 usec
WPS: Set UUID for interface wlan0
WPS: UUID based on MAC address - hexdump(len=16): 30 1b 61 9a 30 b1 5b 77 ad be 47 27 17 d8 71 f8
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
P2P: Own listen channel: 6
P2P: Random operating channel: 81:11
P2P: Add operating class 81
P2P: Channels - hexdump(len=11): 01 02 03 04 05 06 07 08 09 0a 0b
wlan0: Added interface wlan0
Daemonize..
/wlan # ./wp

/wlan # ./wpa_[Jcl
/wlan # ./wpa_cli [Jstatus
Selected interface 'wlan0'
bssid=68:7f:74:e5:67:52
ssid=Leviton
id=0
mode=station
pairwise_cipher=TKIP
group_cipher=TKIP
key_mgmt=WPA-PSK
wpa_state=COMPLETED
ip_address=10.2.30.34
p2p_device_address=08:00:28:34:56:22
address=08:00:28:34:56:22
/wlan # cat p
/wlan # cat p2p.conf [J
ctrl_interface=/var/run/wpa_supplicant

device_name=TI-WILINK-P2P
device_type=1-0050F204-1
sec_device_type=1-0050F204-1

# If you need to modify the group owner intent, 0-15, the higher
# number indicates preference to become the GO
p2p_go_intent=15

# optional, can be useful for monitoring, forces
# wpa_supplicant to use only channel 1 rather than
# 1, 6 and 11:
#p2p_listen_reg_class=81
#p2p_listen_channel=1
p2p_oper_reg_class=81
p2p_oper_channel=8
/wlan # dmesg
[    0.000000] Linux version 2.6.28.2 (root@BPSBuildEnvironment) (gcc version 4.4.2 (GCC) ) #1 Fri Aug 24 17:40:11 IST 2012
[    0.000000] CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: Brady BPS313XV1
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 8192
[    0.000000] free_area_init_node: node 0, pgdat c02aa6dc, node_mem_map c032f000
[    0.000000]   Normal zone: 64 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 8128 pages, LIFO batch:0
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
[    0.000000] Kernel command line: console=0 rootfstype=jffs2 quiet root=/dev/mtdblock7 safefs=0 kernel=1 sku=772 initcall_debug printk.time=1
[    0.000000] irq=30 Event=0x3e bank:1 bit:30 type:0

[    0.000000] irq=31 Event=0x54 bank:2 bit:20 type:0

[    0.000000] irq=32 Event=0x4b bank:2 bit:11 type:0

[    0.000000] PID hash table entries: 128 (order: 7, 512 bytes)
[42949372.960000] Console: colour dummy device 80x30
[42949372.960000] console [ttyS0] enabled
[42949372.960000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
[42949372.960000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
[42949372.960000] Memory: 32MB = 32MB total
[42949372.960000] Memory: 29192KB available (2488K code, 639K data, 92K init)
[42949372.970000] Calibrating delay loop... 89.70 BogoMIPS (lpj=448512)
[42949373.160000] Mount-cache hash table entries: 512
[42949373.160000] CPU: Testing write buffer coherency: ok
[42949373.160000] calling  spawn_ksoftirqd+0x0/0x5c @ 1
[42949373.160000] initcall spawn_ksoftirqd+0x0/0x5c returned 0 after 477 usecs
[42949373.160000] calling  tracer_alloc_buffers+0x0/0x180 @ 1
[42949373.170000] initcall tracer_alloc_buffers+0x0/0x180 returned 0 after 6994 usecs
[42949373.170000] calling  net_ns_init+0x0/0x144 @ 1
[42949373.170000] net_namespace: 312 bytes
[42949373.170000] initcall net_ns_init+0x0/0x144 returned 0 after 85 usecs
[42949373.170000] calling  ptrace_break_init+0x0/0x2c @ 1
[42949373.170000] initcall ptrace_break_init+0x0/0x2c returned 0 after 11 usecs
[42949373.170000] calling  consistent_init+0x0/0xc8 @ 1
[42949373.170000] initcall consistent_init+0x0/0xc8 returned 0 after 75 usecs
[42949373.170000] calling  sysctl_init+0x0/0x24 @ 1
[42949373.170000] initcall sysctl_init+0x0/0x24 returned 0 after 74 usecs
[42949373.170000] calling  ksysfs_init+0x0/0xcc @ 1
[42949373.180000] initcall ksysfs_init+0x0/0xcc returned 0 after 322 usecs
[42949373.180000] calling  init_jiffies_clocksource+0x0/0x1c @ 1
[42949373.180000] initcall init_jiffies_clocksource+0x0/0x1c returned 0 after 20 usecs
[42949373.180000] calling  pm_init+0x0/0x44 @ 1
[42949373.180000] initcall pm_init+0x0/0x44 returned 0 after 140 usecs
[42949373.180000] calling  filelock_init+0x0/0x4c @ 1
[42949373.180000] initcall filelock_init+0x0/0x4c returned 0 after 147 usecs
[42949373.180000] calling  init_script_binfmt+0x0/0x1c @ 1
[42949373.180000] initcall init_script_binfmt+0x0/0x1c returned 0 after 12 usecs
[42949373.180000] calling  init_elf_binfmt+0x0/0x1c @ 1
[42949373.180000] initcall init_elf_binfmt+0x0/0x1c returned 0 after 8 usecs
[42949373.180000] calling  debugfs_init+0x0/0x60 @ 1
[42949373.180000] initcall debugfs_init+0x0/0x60 returned 0 after 110 usecs
[42949373.180000] calling  random32_init+0x0/0x80 @ 1
[42949373.180000] initcall random32_init+0x0/0x80 returned 0 after 11 usecs
[42949373.180000] calling  cpuidle_init+0x0/0x34 @ 1
[42949373.180000] initcall cpuidle_init+0x0/0x34 returned 0 after 98 usecs
[42949373.180000] calling  sock_init+0x0/0x78 @ 1
[42949373.180000] initcall sock_init+0x0/0x78 returned 0 after 541 usecs
[42949373.180000] calling  netlink_proto_init+0x0/0x174 @ 1
[42949373.180000] NET: Registered protocol family 16
[42949373.180000] initcall netlink_proto_init+0x0/0x174 returned 0 after 399 usecs
[42949373.180000] calling  bdi_class_init+0x0/0x54 @ 1
[42949373.180000] initcall bdi_class_init+0x0/0x54 returned 0 after 1436 usecs
[42949373.180000] calling  kobject_uevent_init+0x0/0x64 @ 1
[42949373.180000] initcall kobject_uevent_init+0x0/0x64 returned 0 after 85 usecs
[42949373.180000] calling  tty_class_init+0x0/0x38 @ 1
[42949373.180000] initcall tty_class_init+0x0/0x38 returned 0 after 1219 usecs
[42949373.180000] calling  vtconsole_class_init+0x0/0xe8 @ 1
[42949373.190000] initcall vtconsole_class_init+0x0/0xe8 returned 0 after 2863 usecs
[42949373.190000] calling  customize_machine+0x0/0x2c @ 1
[42949373.190000] cgu_init pll set at 180000000
[42949373.190000] Registering USB gadget 0x00000f20 0x02800004 (3)
[42949373.200000] initcall customize_machine+0x0/0x2c returned 0 after 12677 usecs
[42949373.200000] calling  wdt_device_init+0x0/0x1c @ 1
[42949373.200000] initcall wdt_device_init+0x0/0x1c returned 0 after 1433 usecs
[42949373.200000] calling  lpc313x_pm_init+0x0/0x2c @ 1
[42949373.200000] LPC31: Power Management init.
[42949373.200000] initcall lpc313x_pm_init+0x0/0x2c returned 0 after 71 usecs
[42949373.200000] calling  topology_init+0x0/0x30 @ 1
[42949373.200000] initcall topology_init+0x0/0x30 returned 0 after 1126 usecs
[42949373.200000] calling  param_sysfs_init+0x0/0x200 @ 1
[42949373.250000] initcall param_sysfs_init+0x0/0x200 returned 0 after 42204 usecs
[42949373.250000] calling  readahead_init+0x0/0x3c @ 1
[42949373.250000] initcall readahead_init+0x0/0x3c returned 0 after 1597 usecs
[42949373.250000] calling  init_bio+0x0/0xd8 @ 1
[42949373.250000] initcall init_bio+0x0/0xd8 returned 0 after 782 usecs
[42949373.250000] calling  cryptomgr_init+0x0/0x38 @ 1
[42949373.250000] initcall cryptomgr_init+0x0/0x38 returned 0 after 134 usecs
[42949373.250000] calling  blk_settings_init+0x0/0x44 @ 1
[42949373.250000] initcall blk_settings_init+0x0/0x44 returned 0 after 12 usecs
[42949373.250000] calling  blk_ioc_init+0x0/0x48 @ 1
[42949373.250000] initcall blk_ioc_init+0x0/0x48 returned 0 after 127 usecs
[42949373.250000] calling  blk_softirq_init+0x0/0x34 @ 1
[42949373.250000] initcall blk_softirq_init+0x0/0x34 returned 0 after 9 usecs
[42949373.250000] calling  genhd_device_init+0x0/0x8c @ 1
[42949373.250000] initcall genhd_device_init+0x0/0x8c returned 0 after 2181 usecs
[42949373.250000] calling  misc_init+0x0/0xac @ 1
[42949373.260000] initcall misc_init+0x0/0xac returned 0 after 1847 usecs
[42949373.260000] calling  input_init+0x0/0x11c @ 1
[42949373.260000] initcall input_init+0x0/0x11c returned 0 after 1314 usecs
[42949373.260000] calling  mmc_init+0x0/0x90 @ 1
[42949373.260000] initcall mmc_init+0x0/0x90 returned 0 after 4389 usecs
[42949373.260000] calling  proto_init+0x0/0x3c @ 1
[42949373.260000] initcall proto_init+0x0/0x3c returned 0 after 71 usecs
[42949373.260000] calling  net_dev_init+0x0/0x124 @ 1
[42949373.270000] initcall net_dev_init+0x0/0x124 returned 0 after 1557 usecs
[42949373.270000] calling  neigh_init+0x0/0x8c @ 1
[42949373.270000] initcall neigh_init+0x0/0x8c returned 0 after 17 usecs
[42949373.270000] calling  genl_init+0x0/0xe8 @ 1
[42949373.320000] initcall genl_init+0x0/0xe8 returned 0 after 47865 usecs
[42949373.320000] calling  wireless_nlevent_init+0x0/0x28 @ 1
[42949373.320000] initcall wireless_nlevent_init+0x0/0x28 returned 0 after 11 usecs
[42949373.320000] calling  rfkill_init+0x0/0x74 @ 1
[42949373.320000] initcall rfkill_init+0x0/0x74 returned 0 after 1211 usecs
[42949373.320000] calling  sysctl_init+0x0/0x54 @ 1
[42949373.320000] initcall sysctl_init+0x0/0x54 returned 0 after 25 usecs
[42949373.320000] calling  alignment_init+0x0/0xe4 @ 1
[42949373.320000] initcall alignment_init+0x0/0xe4 returned 0 after 109 usecs
[42949373.320000] calling  clocksource_done_booting+0x0/0x24 @ 1
[42949373.320000] initcall clocksource_done_booting+0x0/0x24 returned 0 after 7 usecs
[42949373.320000] calling  rb_init_debugfs+0x0/0x5c @ 1
[42949373.320000] initcall rb_init_debugfs+0x0/0x5c returned 0 after 133 usecs
[42949373.320000] calling  tracer_init_debugfs+0x0/0x300 @ 1
[42949373.320000] initcall tracer_init_debugfs+0x0/0x300 returned 0 after 452 usecs
[42949373.320000] calling  init_pipe_fs+0x0/0x58 @ 1
[42949373.320000] initcall init_pipe_fs+0x0/0x58 returned 0 after 160 usecs
[42949373.320000] calling  init_mnt_writers+0x0/0x20 @ 1
[42949373.320000] initcall init_mnt_writers+0x0/0x20 returned 0 after 10 usecs
[42949373.320000] calling  eventpoll_init+0x0/0xa4 @ 1
[42949373.320000] initcall eventpoll_init+0x0/0xa4 returned 0 after 321 usecs
[42949373.320000] calling  anon_inode_init+0x0/0x110 @ 1
[42949373.320000] initcall anon_inode_init+0x0/0x110 returned 0 after 164 usecs
[42949373.320000] calling  chr_dev_init+0x0/0xb8 @ 1
[42949373.330000] initcall chr_dev_init+0x0/0xb8 returned 0 after 11251 usecs
[42949373.330000] calling  firmware_class_init+0x0/0x74 @ 1
[42949373.330000] initcall firmware_class_init+0x0/0x74 returned 0 after 1209 usecs
[42949373.330000] calling  loopback_init+0x0/0x1c @ 1
[42949373.340000] initcall loopback_init+0x0/0x1c returned 0 after 2372 usecs
[42949373.340000] calling  inet_init+0x0/0x1dc @ 1
[42949373.340000] NET: Registered protocol family 2
[42949373.450000] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[42949373.450000] TCP established hash table entries: 1024 (order: 1, 8192 bytes)
[42949373.450000] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
[42949373.450000] TCP: Hash tables configured (established 1024 bind 1024)
[42949373.450000] TCP reno registered
[42949373.480000] initcall inet_init+0x0/0x1dc returned 0 after 134477 usecs
[42949373.480000] calling  af_unix_init+0x0/0x5c @ 1
[42949373.480000] NET: Registered protocol family 1
[42949373.480000] initcall af_unix_init+0x0/0x5c returned 0 after 418 usecs
[42949373.480000] calling  populate_rootfs+0x0/0xb8 @ 1
[42949373.480000] initcall populate_rootfs+0x0/0xb8 returned 0 after 2383 usecs
[42949373.480000] calling  timer_init_sysfs+0x0/0x40 @ 1
[42949373.480000] initcall timer_init_sysfs+0x0/0x40 returned 0 after 2300 usecs
[42949373.480000] calling  lpc313x_dma_init+0x0/0x84 @ 1
[42949373.480000] initcall lpc313x_dma_init+0x0/0x84 returned 0 after 123 usecs
[42949373.480000] calling  fpe_init+0x0/0x80 @ 1
[42949373.480000] NetWinder Floating Point Emulator V0.97 (double precision)
[42949373.480000] initcall fpe_init+0x0/0x80 returned 0 after 92 usecs
[42949373.480000] calling  proc_execdomains_init+0x0/0x40 @ 1
[42949373.480000] initcall proc_execdomains_init+0x0/0x40 returned 0 after 67 usecs
[42949373.480000] calling  ioresources_init+0x0/0x60 @ 1
[42949373.480000] initcall ioresources_init+0x0/0x60 returned 0 after 69 usecs
[42949373.480000] calling  uid_cache_init+0x0/0xb0 @ 1
[42949373.480000] initcall uid_cache_init+0x0/0xb0 returned 0 after 210 usecs
[42949373.480000] calling  init_posix_timers+0x0/0xfc @ 1
[42949373.480000] initcall init_posix_timers+0x0/0xfc returned 0 after 144 usecs
[42949373.480000] calling  init_posix_cpu_timers+0x0/0xe8 @ 1
[42949373.480000] initcall init_posix_cpu_timers+0x0/0xe8 returned 0 after 13 usecs
[42949373.480000] calling  nsproxy_cache_init+0x0/0x48 @ 1
[42949373.490000] initcall nsproxy_cache_init+0x0/0x48 returned 0 after 152 usecs
[42949373.490000] calling  timekeeping_init_device+0x0/0x30 @ 1
[42949373.490000] initcall timekeeping_init_device+0x0/0x30 returned 0 after 2315 usecs
[42949373.490000] calling  init_clocksource_sysfs+0x0/0x58 @ 1
[42949373.490000] initcall init_clocksource_sysfs+0x0/0x58 returned 0 after 2337 usecs
[42949373.490000] calling  init_timer_list_procfs+0x0/0x48 @ 1
[42949373.490000] initcall init_timer_list_procfs+0x0/0x48 returned 0 after 81 usecs
[42949373.490000] calling  init_tstats_procfs+0x0/0x48 @ 1
[42949373.490000] initcall init_tstats_procfs+0x0/0x48 returned 0 after 54 usecs
[42949373.490000] calling  futex_init+0x0/0x80 @ 1
[42949373.490000] initcall futex_init+0x0/0x80 returned 0 after 68 usecs
[42949373.490000] calling  proc_modules_init+0x0/0x40 @ 1
[42949373.490000] initcall proc_modules_init+0x0/0x40 returned 0 after 60 usecs
[42949373.490000] calling  kallsyms_init+0x0/0x40 @ 1
[42949373.490000] initcall kallsyms_init+0x0/0x40 returned 0 after 46 usecs
[42949373.490000] calling  utsname_sysctl_init+0x0/0x20 @ 1
[42949373.490000] initcall utsname_sysctl_init+0x0/0x20 returned 0 after 40 usecs
[42949373.490000] calling  ftrace_nodyn_init+0x0/0x24 @ 1
[42949373.490000] initcall ftrace_nodyn_init+0x0/0x24 returned 0 after 5 usecs
[42949373.490000] calling  init_sched_switch_trace+0x0/0x54 @ 1
[42949373.490000] initcall init_sched_switch_trace+0x0/0x54 returned 0 after 18 usecs
[42949373.490000] calling  init_function_trace+0x0/0x1c @ 1
[42949373.490000] initcall init_function_trace+0x0/0x1c returned 0 after 10 usecs
[42949373.490000] calling  init_wakeup_tracer+0x0/0x1c @ 1
[42949373.490000] initcall init_wakeup_tracer+0x0/0x1c returned 0 after 11 usecs
[42949373.490000] calling  stack_trace_init+0x0/0xa4 @ 1
[42949373.490000] initcall stack_trace_init+0x0/0xa4 returned 0 after 255 usecs
[42949373.500000] calling  init_per_zone_pages_min+0x0/0x58 @ 1
[42949373.500000] initcall init_per_zone_pages_min+0x0/0x58 returned 0 after 486 usecs
[42949373.500000] calling  pdflush_init+0x0/0x1c @ 1
[42949373.500000] initcall pdflush_init+0x0/0x1c returned 0 after 992 usecs
[42949373.500000] calling  kswapd_init+0x0/0x20 @ 1
[42949373.500000] initcall kswapd_init+0x0/0x20 returned 0 after 602 usecs
[42949373.500000] calling  setup_vmstat+0x0/0x98 @ 1
[42949373.500000] initcall setup_vmstat+0x0/0x98 returned 0 after 180 usecs
[42949373.500000] calling  mm_sysfs_init+0x0/0x40 @ 1
[42949373.500000] initcall mm_sysfs_init+0x0/0x40 returned 0 after 124 usecs
[42949373.500000] calling  proc_vmalloc_init+0x0/0x40 @ 1
[42949373.500000] initcall proc_vmalloc_init+0x0/0x40 returned 0 after 78 usecs
[42949373.500000] calling  init_tmpfs+0x0/0xe0 @ 1
[42949373.500000] initcall init_tmpfs+0x0/0xe0 returned 0 after 692 usecs
[42949373.500000] calling  slab_proc_init+0x0/0x40 @ 1
[42949373.500000] initcall slab_proc_init+0x0/0x40 returned 0 after 88 usecs
[42949373.500000] calling  cpucache_init+0x0/0x1c @ 1
[42949373.500000] initcall cpucache_init+0x0/0x1c returned 0 after 46 usecs
[42949373.500000] calling  fasync_init+0x0/0x48 @ 1
[42949373.500000] initcall fasync_init+0x0/0x48 returned 0 after 247 usecs
[42949373.500000] calling  proc_filesystems_init+0x0/0x40 @ 1
[42949373.500000] initcall proc_filesystems_init+0x0/0x40 returned 0 after 84 usecs
[42949373.500000] calling  inotify_setup+0x0/0x20 @ 1
[42949373.500000] initcall inotify_setup+0x0/0x20 returned 0 after 11 usecs
[42949373.500000] calling  inotify_user_setup+0x0/0xc4 @ 1
[42949373.500000] initcall inotify_user_setup+0x0/0xc4 returned 0 after 439 usecs
[42949373.500000] calling  aio_setup+0x0/0x8c @ 1
[42949373.510000] initcall aio_setup+0x0/0x8c returned 0 after 1261 usecs
[42949373.510000] calling  proc_locks_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_locks_init+0x0/0x40 returned 0 after 108 usecs
[42949373.510000] calling  dnotify_init+0x0/0x48 @ 1
[42949373.510000] initcall dnotify_init+0x0/0x48 returned 0 after 208 usecs
[42949373.510000] calling  proc_cmdline_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_cmdline_init+0x0/0x40 returned 0 after 151 usecs
[42949373.510000] calling  proc_cpuinfo_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_cpuinfo_init+0x0/0x40 returned 0 after 66 usecs
[42949373.510000] calling  proc_devices_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_devices_init+0x0/0x40 returned 0 after 57 usecs
[42949373.510000] calling  proc_interrupts_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_interrupts_init+0x0/0x40 returned 0 after 55 usecs
[42949373.510000] calling  proc_loadavg_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_loadavg_init+0x0/0x40 returned 0 after 59 usecs
[42949373.510000] calling  proc_meminfo_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_meminfo_init+0x0/0x40 returned 0 after 54 usecs
[42949373.510000] calling  proc_stat_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_stat_init+0x0/0x40 returned 0 after 57 usecs
[42949373.510000] calling  proc_uptime_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_uptime_init+0x0/0x40 returned 0 after 59 usecs
[42949373.510000] calling  proc_version_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_version_init+0x0/0x40 returned 0 after 58 usecs
[42949373.510000] calling  proc_kmsg_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_kmsg_init+0x0/0x40 returned 0 after 55 usecs
[42949373.510000] calling  proc_page_init+0x0/0x60 @ 1
[42949373.510000] initcall proc_page_init+0x0/0x60 returned 0 after 86 usecs
[42949373.510000] calling  init_devpts_fs+0x0/0x48 @ 1
[42949373.510000] initcall init_devpts_fs+0x0/0x48 returned 0 after 242 usecs
[42949373.510000] calling  init_ramfs_fs+0x0/0x1c @ 1
[42949373.510000] initcall init_ramfs_fs+0x0/0x1c returned 0 after 30 usecs
[42949373.510000] calling  init_nfs_fs+0x0/0x150 @ 1
[42949373.520000] initcall init_nfs_fs+0x0/0x150 returned 0 after 2263 usecs
[42949373.520000] calling  init_nlm+0x0/0x34 @ 1
[42949373.520000] initcall init_nlm+0x0/0x34 returned 0 after 51 usecs
[42949373.520000] calling  init_jffs2_fs+0x0/0xe0 @ 1
[42949373.520000] JFFS2 version 2.2. (NAND) (SUMMARY)  (c) 2001-2006 Red Hat, Inc.
[42949373.520000] initcall init_jffs2_fs+0x0/0xe0 returned 0 after 2921 usecs
[42949373.520000] calling  ipc_init+0x0/0x2c @ 1
[42949373.520000] msgmni has been set to 57
[42949373.520000] initcall ipc_init+0x0/0x2c returned 0 after 334 usecs
[42949373.520000] calling  ipc_sysctl_init+0x0/0x20 @ 1
[42949373.520000] initcall ipc_sysctl_init+0x0/0x20 returned 0 after 58 usecs
[42949373.520000] calling  crypto_algapi_init+0x0/0x18 @ 1
[42949373.520000] initcall crypto_algapi_init+0x0/0x18 returned 0 after 93 usecs
[42949373.520000] calling  chainiv_module_init+0x0/0x1c @ 1
[42949373.520000] initcall chainiv_module_init+0x0/0x1c returned 0 after 37 usecs
[42949373.520000] calling  eseqiv_module_init+0x0/0x1c @ 1
[42949373.520000] initcall eseqiv_module_init+0x0/0x1c returned 0 after 20 usecs
[42949373.520000] calling  md5_mod_init+0x0/0x1c @ 1
[42949373.520000] initcall md5_mod_init+0x0/0x1c returned 0 after 1391 usecs
[42949373.520000] calling  crypto_ecb_module_init+0x0/0x1c @ 1
[42949373.520000] initcall crypto_ecb_module_init+0x0/0x1c returned 0 after 36 usecs
[42949373.520000] calling  crypto_cbc_module_init+0x0/0x1c @ 1
[42949373.520000] initcall crypto_cbc_module_init+0x0/0x1c returned 0 after 25 usecs
[42949373.520000] calling  des_generic_mod_init+0x0/0x44 @ 1
[42949373.530000] initcall des_generic_mod_init+0x0/0x44 returned 0 after 3270 usecs
[42949373.530000] calling  aes_init+0x0/0x370 @ 1
[42949373.530000] initcall aes_init+0x0/0x370 returned 0 after 2464 usecs
[42949373.530000] calling  arc4_init+0x0/0x1c @ 1
[42949373.530000] initcall arc4_init+0x0/0x1c returned 0 after 1786 usecs
[42949373.530000] calling  krng_mod_init+0x0/0x1c @ 1
[42949373.530000] alg: No test for stdrng (krng)
[42949373.530000] initcall krng_mod_init+0x0/0x1c returned 0 after 1067 usecs
[42949373.530000] calling  proc_genhd_init+0x0/0x60 @ 1
[42949373.540000] initcall proc_genhd_init+0x0/0x60 returned 0 after 356 usecs
[42949373.540000] calling  noop_init+0x0/0x20 @ 1
[42949373.540000] io scheduler noop registered (default)
[42949373.540000] initcall noop_init+0x0/0x20 returned 0 after 129 usecs
[42949373.540000] calling  rand_initialize+0x0/0x3c @ 1
[42949373.540000] initcall rand_initialize+0x0/0x3c returned 0 after 504 usecs
[42949373.540000] calling  tty_init+0x0/0x110 @ 1
[42949373.670000] initcall tty_init+0x0/0x110 returned 0 after 131121 usecs
[42949373.670000] calling  pty_init+0x0/0x2b8 @ 1
[42949373.670000] initcall pty_init+0x0/0x2b8 returned 0 after 2408 usecs
[42949373.670000] calling  serial8250_init+0x0/0x114 @ 1
[42949373.670000] Serial: 8250/16550 driver1 ports, IRQ sharing disabled
[42949373.680000] serial8250: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
[42949373.680000] DBG::bus: 'platform': add driver serial8250
[42949373.680000] serial8250.0: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
[42949373.690000] initcall serial8250_init+0x0/0x114 returned 0 after 12088 usecs
[42949373.690000] calling  net_olddevs_init+0x0/0xc8 @ 1
[42949373.690000] initcall net_olddevs_init+0x0/0xc8 returned 0 after 114 usecs
[42949373.690000] calling  init_mtd+0x0/0x44 @ 1
[42949373.690000] initcall init_mtd+0x0/0x44 returned 0 after 137 usecs
[42949373.690000] calling  init_mtdchar+0x0/0x98 @ 1
[42949373.690000] initcall init_mtdchar+0x0/0x98 returned 0 after 1392 usecs
[42949373.690000] calling  init_mtdblock+0x0/0x1c @ 1
[42949373.690000] initcall init_mtdblock+0x0/0x1c returned 0 after 815 usecs
[42949373.690000] calling  nand_base_init+0x0/0x14 @ 1
[42949373.690000] initcall nand_base_init+0x0/0x14 returned 0 after 13 usecs
[42949373.690000] calling  lpc313x_nand_init+0x0/0x1c @ 1
[42949373.690000] DBG::bus: 'platform': add driver lpc313x_nand
[42949373.690000] NAND device: Manufacturer ID: 0x20, Chip ID: 0x73 (ST Micro NAND 16MiB 3,3V 8-bit)
[42949373.690000] Bad block table found at page 32736, version 0x00
[42949373.690000] Bad block table found at page 32704, version 0x00
[42949373.690000] nand_read_bbt: Bad block at 0x00000000
[42949373.690000] nand_read_bbt: Bad block at 0x00000000
[42949373.700000] Creating 10 MTD partitions on "NAND 16MiB 3,3V 8-bit":
[42949373.700000] 0x00004000-0x00018000 : "apex1"
[42949373.700000] 0x00018000-0x0002c000 : "apex2"
[42949373.710000] 0x0002c000-0x00030000 : "apex-env"
[42949373.720000] 0x00030000-0x00050000 : "sysconfig"
[42949373.720000] 0x00050000-0x001cc000 : "kernel1"
[42949373.730000] 0x001cc000-0x00348000 : "kernel2"
[42949373.740000] 0x00348000-0x00368000 : "configfs"
[42949373.750000] 0x00368000-0x00e58000 : "rootfs"
[42949373.760000] 0x00e58000-0x00fe8000 : "safefs"
[42949373.760000] 0x00fe8000-0x00ff0000 : "log"
[42949373.770000] initcall lpc313x_nand_init+0x0/0x1c returned 0 after 78275 usecs
[42949373.770000] calling  mousedev_init+0x0/0x68 @ 1
[42949373.770000] mice: PS/2 mouse device common for all mice
[42949373.770000] initcall mousedev_init+0x0/0x68 returned 0 after 2127 usecs
[42949373.780000] calling  lpc313x_wdt_init+0x0/0x1c @ 1
[42949373.780000] DBG::bus: 'platform': add driver lpc313x-wdt
[42949373.780000] CGU: Get clock id:34 freq:6000000
[42949373.780000] lpc313x-wdt lpc313x-wdt: Watchdog device driver initialized.
[42949373.780000] initcall lpc313x_wdt_init+0x0/0x1c returned 0 after 4356 usecs
[42949373.780000] calling  init_ladder+0x0/0x1c @ 1
[42949373.780000] cpuidle: using governor ladder
[42949373.780000] initcall init_ladder+0x0/0x1c returned 0 after 124 usecs
[42949373.780000] calling  sysctl_core_init+0x0/0x30 @ 1
[42949373.780000] initcall sysctl_core_init+0x0/0x30 returned 0 after 166 usecs
[42949373.780000] calling  sysctl_ipv4_init+0x0/0x4c @ 1
[42949373.780000] initcall sysctl_ipv4_init+0x0/0x4c returned 0 after 230 usecs
[42949373.780000] calling  cubictcp_register+0x0/0x6c @ 1
[42949373.780000] TCP cubic registered
[42949373.780000] initcall cubictcp_register+0x0/0x6c returned 0 after 102 usecs
[42949373.780000] calling  packet_init+0x0/0x50 @ 1
[42949373.780000] NET: Registered protocol family 17
[42949373.780000] initcall packet_init+0x0/0x50 returned 0 after 248 usecs
[42949373.780000] calling  init_sunrpc+0x0/0x60 @ 1
[42949373.780000] RPC: Registered udp transport module.
[42949373.790000] RPC: Registered tcp transport module.
[42949373.790000] initcall init_sunrpc+0x0/0x60 returned 0 after 2596 usecs
[42949373.790000] calling  init_rpcsec_gss+0x0/0x3c @ 1
[42949373.790000] initcall init_rpcsec_gss+0x0/0x3c returned 0 after 212 usecs
[42949373.790000] calling  init_kerberos_module+0x0/0x34 @ 1
[42949373.790000] initcall init_kerberos_module+0x0/0x34 returned 0 after 69 usecs
[42949373.790000] calling  rfkill_handler_init+0x0/0x48 @ 1
[42949373.790000] initcall rfkill_handler_init+0x0/0x48 returned 0 after 24 usecs
[42949373.790000] calling  init_oops_id+0x0/0x40 @ 1
[42949373.790000] initcall init_oops_id+0x0/0x40 returned 0 after 108 usecs
[42949373.790000] calling  disable_boot_consoles+0x0/0x50 @ 1
[42949373.790000] initcall disable_boot_consoles+0x0/0x50 returned 0 after 12 usecs
[42949373.790000] calling  pm_qos_power_init+0x0/0x6c @ 1
[42949373.790000] initcall pm_qos_power_init+0x0/0x6c returned 0 after 5821 usecs
[42949373.790000] calling  random32_reseed+0x0/0x6c @ 1
[42949373.800000] initcall random32_reseed+0x0/0x6c returned 0 after 312 usecs
[42949373.800000] calling  seqgen_init+0x0/0x1c @ 1
[42949373.800000] initcall seqgen_init+0x0/0x1c returned 0 after 281 usecs
[42949373.800000] calling  tcp_congestion_default+0x0/0x1c @ 1
[42949373.800000] initcall tcp_congestion_default+0x0/0x1c returned 0 after 22 usecs
[42949373.800000] calling  ip_auto_config+0x0/0xe6c @ 1
[42949373.800000] initcall ip_auto_config+0x0/0xe6c returned 0 after 113 usecs
[42949374.340000] jffs2_scan_inode_node(): CRC failed on node at 0x008b4dc8: Read 0xffffffff, calculated 0xc9c59f44
[42949374.430000] VFS: Mounted root (jffs2 filesystem) readonly.
[42949374.430000] Freeing init memory: 92K
[42949376.730000] CGU: Get clock id:34 freq:6000000
[42949376.730000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949377.930000] jffs2_scan_inode_node(): CRC failed on node at 0x0001c5f4: Read 0xffffffff, calculated 0x1490a44b
[42949377.940000] CGU: Get clock id:34 freq:6000000
[42949377.940000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.130000] Empty flash at 0x0014e310 ends at 0x0014e400
[42949378.160000] CGU: Get clock id:34 freq:6000000
[42949378.160000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.580000] CGU: Get clock id:34 freq:6000000
[42949378.580000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.610000] CGU: Get clock id:34 freq:6000000
[42949378.610000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.670000] calling  on_load+0x0/0xc4 [bpsled] @ 292
[42949378.670000] initcall on_load+0x0/0xc4 [bpsled] returned -16 after 24 usecs
[42949378.670000] initcall on_load+0x0/0xc4 [bpsled] returned with error code -16
[42949378.730000] CGU: Get clock id:34 freq:6000000
[42949378.730000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.780000] CGU: Get clock id:34 freq:6000000
[42949378.780000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.790000] CGU: Get clock id:34 freq:6000000
[42949378.790000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949379.260000] calling  udc_init+0x0/0x40 [nxp_usb2_udc] @ 302
[42949379.260000] Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
[42949379.260000] DBG::bus: 'platform': add driver fsl-usb2-udc
[42949379.270000] initcall udc_init+0x0/0x40 [nxp_usb2_udc] returned 0 after 8192 usecs
[42949379.780000] calling  init+0x0/0xc4 [g_serial] @ 302
[42949379.790000] g_serial gadget: Gadget Serial v2.4
[42949379.790000] g_serial gadget: g_serial ready
[42949379.790000] fsl-usb2-udc: bind to driver g_serial
[42949379.790000] initcall init+0x0/0xc4 [g_serial] returned 0 after 5769 usecs
[42949379.850000] CGU: Get clock id:34 freq:6000000
[42949379.850000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949380.070000] g_serial gadget: high speed config #2: CDC ACM config
[42949384.520000] CGU: Get clock id:34 freq:6000000
[42949469.800000] calling  lpc313x_mci_init+0x0/0x24 [lpc313x_mmc] @ 329
[42949469.800000] DBG::bus: 'platform': add driver lpc313x_mmc
[42949469.800000] CGU: Get clock id:20 freq:45000000
[42949469.800000] Powering off wl12xx<6>Powering off wl12xx<6>Powering down MMC Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x MMC controller at irq 26
[42949469.830000] initcall lpc313x_mci_init+0x0/0x24 [lpc313x_mmc] returned 0 after 28094 usecs
[42949469.930000] Powering up MMC Slot<4>mmc0: card claims to support voltages below the defined range. These will be ignored.
[42949469.990000] mmc0: queuing CIS tuple 0x91 length 3
[42949469.990000] mmc_attach_sdio the value of funcs=0x2
[42949469.990000] mmc_attach_sdio the value of funcs=0x2
[42949469.990000] mmc0: new SDIO card at address 0001
[42949470.020000] Powering on wl12xxcalling  __init_compat+0x0/0x40 [compat] @ 338
[42949492.670000] Compat-wireless backport release: compat-wireless-3.5-rc5-1
[42949492.670000] Backport based on linux-stable.git v3.5-rc5
[42949492.670000] compat.git: linux-stable.git
[42949492.670000] initcall __init_compat+0x0/0x40 [compat] returned 0 after 2313 usecs
[42949495.630000] calling  __init_compat+0x0/0x94 [rfkill_backport] @ 343
[42949495.650000] initcall __init_compat+0x0/0x94 [rfkill_backport] returned 0 after 22300 usecs
[42949500.410000] calling  __init_compat+0x0/0xd8 [cfg80211] @ 347
[42949500.610000] cfg80211: Calling CRDA to update world regulatory domain
[42949500.620000] initcall __init_compat+0x0/0xd8 [cfg80211] returned 0 after 204688 usecs
[42949505.750000] calling  __init_compat+0x0/0x54 [mac80211] @ 353
[42949505.760000] initcall __init_compat+0x0/0x54 [mac80211] returned 0 after 4565 usecs
[42949510.640000] calling  __init_compat+0x0/0x28 [compat_firmware_class] @ 355
[42949510.650000] initcall __init_compat+0x0/0x28 [compat_firmware_class] returned 0 after 11131 usecs
[42949518.600000] calling  __init_compat+0x0/0x20 [wl12xx] @ 360
[42949518.600000] DBG::bus: 'platform': add driver wl12xx
[42949518.620000] initcall __init_compat+0x0/0x20 [wl12xx] returned 0 after 10430 usecs
[42949523.250000] calling  __init_compat+0x0/0x20 [wlcore_sdio] @ 363
[42949523.250000] DBG::bus: 'sdio': add driver wl1271_sdio
[42949523.300000] Powering on wl12xx<6>Powering up MMC Slot<6>Powering off wl12xx<6>Powering down MMC Slot<6>wl12xx: loaded
[42949523.680000] initcall __init_compat+0x0/0x20 [wlcore_sdio] returned 0 after 425374 usecs
[42949560.670000] Powering on wl12xx<6>Powering up MMC Slot<6>wl12xx: firmware booted (Rev 6.3.7.0.105)
[42949631.870000] wlan0: authenticate with c166962c
[42949631.950000] wlan0: send auth to c166962c (try 1/3)
[42949631.950000] wlan0: authenticated
[42949632.010000] wlan0: associate with c166962c (try 1/3)
[42949632.020000] wlan0: RX AssocResp from c1669a1a (capab=0x431 status=0 aid=1)
[42949632.020000] wlan0: associated
[42949637.640000] wl12xx: Association completed.
/wlan # ./wpa_supplicant -Dnl80211 -iwlan1 -c /wlan/p2p.conf &
/wlan # dmesg
[    0.000000] Linux version 2.6.28.2 (root@BPSBuildEnvironment) (gcc version 4.4.2 (GCC) ) #1 Fri Aug 24 17:40:11 IST 2012
[    0.000000] CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: Brady BPS313XV1
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 8192
[    0.000000] free_area_init_node: node 0, pgdat c02aa6dc, node_mem_map c032f000
[    0.000000]   Normal zone: 64 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 8128 pages, LIFO batch:0
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
[    0.000000] Kernel command line: console=0 rootfstype=jffs2 quiet root=/dev/mtdblock7 safefs=0 kernel=1 sku=772 initcall_debug printk.time=1
[    0.000000] irq=30 Event=0x3e bank:1 bit:30 type:0

[    0.000000] irq=31 Event=0x54 bank:2 bit:20 type:0

[    0.000000] irq=32 Event=0x4b bank:2 bit:11 type:0

[    0.000000] PID hash table entries: 128 (order: 7, 512 bytes)
[42949372.960000] Console: colour dummy device 80x30
[42949372.960000] console [ttyS0] enabled
[42949372.960000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
[42949372.960000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
[42949372.960000] Memory: 32MB = 32MB total
[42949372.960000] Memory: 29192KB available (2488K code, 639K data, 92K init)
[42949372.970000] Calibrating delay loop... 89.70 BogoMIPS (lpj=448512)
[42949373.160000] Mount-cache hash table entries: 512
[42949373.160000] CPU: Testing write buffer coherency: ok
[42949373.160000] calling  spawn_ksoftirqd+0x0/0x5c @ 1
[42949373.160000] initcall spawn_ksoftirqd+0x0/0x5c returned 0 after 477 usecs
[42949373.160000] calling  tracer_alloc_buffers+0x0/0x180 @ 1
[42949373.170000] initcall tracer_alloc_buffers+0x0/0x180 returned 0 after 6994 usecs
[42949373.170000] calling  net_ns_init+0x0/0x144 @ 1
[42949373.170000] net_namespace: 312 bytes
[42949373.170000] initcall net_ns_init+0x0/0x144 returned 0 after 85 usecs
[42949373.170000] calling  ptrace_break_init+0x0/0x2c @ 1
[42949373.170000] initcall ptrace_break_init+0x0/0x2c returned 0 after 11 usecs
[42949373.170000] calling  consistent_init+0x0/0xc8 @ 1
[42949373.170000] initcall consistent_init+0x0/0xc8 returned 0 after 75 usecs
[42949373.170000] calling  sysctl_init+0x0/0x24 @ 1
[42949373.170000] initcall sysctl_init+0x0/0x24 returned 0 after 74 usecs
[42949373.170000] calling  ksysfs_init+0x0/0xcc @ 1
[42949373.180000] initcall ksysfs_init+0x0/0xcc returned 0 after 322 usecs
[42949373.180000] calling  init_jiffies_clocksource+0x0/0x1c @ 1
[42949373.180000] initcall init_jiffies_clocksource+0x0/0x1c returned 0 after 20 usecs
[42949373.180000] calling  pm_init+0x0/0x44 @ 1
[42949373.180000] initcall pm_init+0x0/0x44 returned 0 after 140 usecs
[42949373.180000] calling  filelock_init+0x0/0x4c @ 1
[42949373.180000] initcall filelock_init+0x0/0x4c returned 0 after 147 usecs
[42949373.180000] calling  init_script_binfmt+0x0/0x1c @ 1
[42949373.180000] initcall init_script_binfmt+0x0/0x1c returned 0 after 12 usecs
[42949373.180000] calling  init_elf_binfmt+0x0/0x1c @ 1
[42949373.180000] initcall init_elf_binfmt+0x0/0x1c returned 0 after 8 usecs
[42949373.180000] calling  debugfs_init+0x0/0x60 @ 1
[42949373.180000] initcall debugfs_init+0x0/0x60 returned 0 after 110 usecs
[42949373.180000] calling  random32_init+0x0/0x80 @ 1
[42949373.180000] initcall random32_init+0x0/0x80 returned 0 after 11 usecs
[42949373.180000] calling  cpuidle_init+0x0/0x34 @ 1
[42949373.180000] initcall cpuidle_init+0x0/0x34 returned 0 after 98 usecs
[42949373.180000] calling  sock_init+0x0/0x78 @ 1
[42949373.180000] initcall sock_init+0x0/0x78 returned 0 after 541 usecs
[42949373.180000] calling  netlink_proto_init+0x0/0x174 @ 1
[42949373.180000] NET: Registered protocol family 16
[42949373.180000] initcall netlink_proto_init+0x0/0x174 returned 0 after 399 usecs
[42949373.180000] calling  bdi_class_init+0x0/0x54 @ 1
[42949373.180000] initcall bdi_class_init+0x0/0x54 returned 0 after 1436 usecs
[42949373.180000] calling  kobject_uevent_init+0x0/0x64 @ 1
[42949373.180000] initcall kobject_uevent_init+0x0/0x64 returned 0 after 85 usecs
[42949373.180000] calling  tty_class_init+0x0/0x38 @ 1
[42949373.180000] initcall tty_class_init+0x0/0x38 returned 0 after 1219 usecs
[42949373.180000] calling  vtconsole_class_init+0x0/0xe8 @ 1
[42949373.190000] initcall vtconsole_class_init+0x0/0xe8 returned 0 after 2863 usecs
[42949373.190000] calling  customize_machine+0x0/0x2c @ 1
[42949373.190000] cgu_init pll set at 180000000
[42949373.190000] Registering USB gadget 0x00000f20 0x02800004 (3)
[42949373.200000] initcall customize_machine+0x0/0x2c returned 0 after 12677 usecs
[42949373.200000] calling  wdt_device_init+0x0/0x1c @ 1
[42949373.200000] initcall wdt_device_init+0x0/0x1c returned 0 after 1433 usecs
[42949373.200000] calling  lpc313x_pm_init+0x0/0x2c @ 1
[42949373.200000] LPC31: Power Management init.
[42949373.200000] initcall lpc313x_pm_init+0x0/0x2c returned 0 after 71 usecs
[42949373.200000] calling  topology_init+0x0/0x30 @ 1
[42949373.200000] initcall topology_init+0x0/0x30 returned 0 after 1126 usecs
[42949373.200000] calling  param_sysfs_init+0x0/0x200 @ 1
[42949373.250000] initcall param_sysfs_init+0x0/0x200 returned 0 after 42204 usecs
[42949373.250000] calling  readahead_init+0x0/0x3c @ 1
[42949373.250000] initcall readahead_init+0x0/0x3c returned 0 after 1597 usecs
[42949373.250000] calling  init_bio+0x0/0xd8 @ 1
[42949373.250000] initcall init_bio+0x0/0xd8 returned 0 after 782 usecs
[42949373.250000] calling  cryptomgr_init+0x0/0x38 @ 1
[42949373.250000] initcall cryptomgr_init+0x0/0x38 returned 0 after 134 usecs
[42949373.250000] calling  blk_settings_init+0x0/0x44 @ 1
[42949373.250000] initcall blk_settings_init+0x0/0x44 returned 0 after 12 usecs
[42949373.250000] calling  blk_ioc_init+0x0/0x48 @ 1
[42949373.250000] initcall blk_ioc_init+0x0/0x48 returned 0 after 127 usecs
[42949373.250000] calling  blk_softirq_init+0x0/0x34 @ 1
[42949373.250000] initcall blk_softirq_init+0x0/0x34 returned 0 after 9 usecs
[42949373.250000] calling  genhd_device_init+0x0/0x8c @ 1
[42949373.250000] initcall genhd_device_init+0x0/0x8c returned 0 after 2181 usecs
[42949373.250000] calling  misc_init+0x0/0xac @ 1
[42949373.260000] initcall misc_init+0x0/0xac returned 0 after 1847 usecs
[42949373.260000] calling  input_init+0x0/0x11c @ 1
[42949373.260000] initcall input_init+0x0/0x11c returned 0 after 1314 usecs
[42949373.260000] calling  mmc_init+0x0/0x90 @ 1
[42949373.260000] initcall mmc_init+0x0/0x90 returned 0 after 4389 usecs
[42949373.260000] calling  proto_init+0x0/0x3c @ 1
[42949373.260000] initcall proto_init+0x0/0x3c returned 0 after 71 usecs
[42949373.260000] calling  net_dev_init+0x0/0x124 @ 1
[42949373.270000] initcall net_dev_init+0x0/0x124 returned 0 after 1557 usecs
[42949373.270000] calling  neigh_init+0x0/0x8c @ 1
[42949373.270000] initcall neigh_init+0x0/0x8c returned 0 after 17 usecs
[42949373.270000] calling  genl_init+0x0/0xe8 @ 1
[42949373.320000] initcall genl_init+0x0/0xe8 returned 0 after 47865 usecs
[42949373.320000] calling  wireless_nlevent_init+0x0/0x28 @ 1
[42949373.320000] initcall wireless_nlevent_init+0x0/0x28 returned 0 after 11 usecs
[42949373.320000] calling  rfkill_init+0x0/0x74 @ 1
[42949373.320000] initcall rfkill_init+0x0/0x74 returned 0 after 1211 usecs
[42949373.320000] calling  sysctl_init+0x0/0x54 @ 1
[42949373.320000] initcall sysctl_init+0x0/0x54 returned 0 after 25 usecs
[42949373.320000] calling  alignment_init+0x0/0xe4 @ 1
[42949373.320000] initcall alignment_init+0x0/0xe4 returned 0 after 109 usecs
[42949373.320000] calling  clocksource_done_booting+0x0/0x24 @ 1
[42949373.320000] initcall clocksource_done_booting+0x0/0x24 returned 0 after 7 usecs
[42949373.320000] calling  rb_init_debugfs+0x0/0x5c @ 1
[42949373.320000] initcall rb_init_debugfs+0x0/0x5c returned 0 after 133 usecs
[42949373.320000] calling  tracer_init_debugfs+0x0/0x300 @ 1
[42949373.320000] initcall tracer_init_debugfs+0x0/0x300 returned 0 after 452 usecs
[42949373.320000] calling  init_pipe_fs+0x0/0x58 @ 1
[42949373.320000] initcall init_pipe_fs+0x0/0x58 returned 0 after 160 usecs
[42949373.320000] calling  init_mnt_writers+0x0/0x20 @ 1
[42949373.320000] initcall init_mnt_writers+0x0/0x20 returned 0 after 10 usecs
[42949373.320000] calling  eventpoll_init+0x0/0xa4 @ 1
[42949373.320000] initcall eventpoll_init+0x0/0xa4 returned 0 after 321 usecs
[42949373.320000] calling  anon_inode_init+0x0/0x110 @ 1
[42949373.320000] initcall anon_inode_init+0x0/0x110 returned 0 after 164 usecs
[42949373.320000] calling  chr_dev_init+0x0/0xb8 @ 1
[42949373.330000] initcall chr_dev_init+0x0/0xb8 returned 0 after 11251 usecs
[42949373.330000] calling  firmware_class_init+0x0/0x74 @ 1
[42949373.330000] initcall firmware_class_init+0x0/0x74 returned 0 after 1209 usecs
[42949373.330000] calling  loopback_init+0x0/0x1c @ 1
[42949373.340000] initcall loopback_init+0x0/0x1c returned 0 after 2372 usecs
[42949373.340000] calling  inet_init+0x0/0x1dc @ 1
[42949373.340000] NET: Registered protocol family 2
[42949373.450000] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[42949373.450000] TCP established hash table entries: 1024 (order: 1, 8192 bytes)
[42949373.450000] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
[42949373.450000] TCP: Hash tables configured (established 1024 bind 1024)
[42949373.450000] TCP reno registered
[42949373.480000] initcall inet_init+0x0/0x1dc returned 0 after 134477 usecs
[42949373.480000] calling  af_unix_init+0x0/0x5c @ 1
[42949373.480000] NET: Registered protocol family 1
[42949373.480000] initcall af_unix_init+0x0/0x5c returned 0 after 418 usecs
[42949373.480000] calling  populate_rootfs+0x0/0xb8 @ 1
[42949373.480000] initcall populate_rootfs+0x0/0xb8 returned 0 after 2383 usecs
[42949373.480000] calling  timer_init_sysfs+0x0/0x40 @ 1
[42949373.480000] initcall timer_init_sysfs+0x0/0x40 returned 0 after 2300 usecs
[42949373.480000] calling  lpc313x_dma_init+0x0/0x84 @ 1
[42949373.480000] initcall lpc313x_dma_init+0x0/0x84 returned 0 after 123 usecs
[42949373.480000] calling  fpe_init+0x0/0x80 @ 1
[42949373.480000] NetWinder Floating Point Emulator V0.97 (double precision)
[42949373.480000] initcall fpe_init+0x0/0x80 returned 0 after 92 usecs
[42949373.480000] calling  proc_execdomains_init+0x0/0x40 @ 1
[42949373.480000] initcall proc_execdomains_init+0x0/0x40 returned 0 after 67 usecs
[42949373.480000] calling  ioresources_init+0x0/0x60 @ 1
[42949373.480000] initcall ioresources_init+0x0/0x60 returned 0 after 69 usecs
[42949373.480000] calling  uid_cache_init+0x0/0xb0 @ 1
[42949373.480000] initcall uid_cache_init+0x0/0xb0 returned 0 after 210 usecs
[42949373.480000] calling  init_posix_timers+0x0/0xfc @ 1
[42949373.480000] initcall init_posix_timers+0x0/0xfc returned 0 after 144 usecs
[42949373.480000] calling  init_posix_cpu_timers+0x0/0xe8 @ 1
[42949373.480000] initcall init_posix_cpu_timers+0x0/0xe8 returned 0 after 13 usecs
[42949373.480000] calling  nsproxy_cache_init+0x0/0x48 @ 1
[42949373.490000] initcall nsproxy_cache_init+0x0/0x48 returned 0 after 152 usecs
[42949373.490000] calling  timekeeping_init_device+0x0/0x30 @ 1
[42949373.490000] initcall timekeeping_init_device+0x0/0x30 returned 0 after 2315 usecs
[42949373.490000] calling  init_clocksource_sysfs+0x0/0x58 @ 1
[42949373.490000] initcall init_clocksource_sysfs+0x0/0x58 returned 0 after 2337 usecs
[42949373.490000] calling  init_timer_list_procfs+0x0/0x48 @ 1
[42949373.490000] initcall init_timer_list_procfs+0x0/0x48 returned 0 after 81 usecs
[42949373.490000] calling  init_tstats_procfs+0x0/0x48 @ 1
[42949373.490000] initcall init_tstats_procfs+0x0/0x48 returned 0 after 54 usecs
[42949373.490000] calling  futex_init+0x0/0x80 @ 1
[42949373.490000] initcall futex_init+0x0/0x80 returned 0 after 68 usecs
[42949373.490000] calling  proc_modules_init+0x0/0x40 @ 1
[42949373.490000] initcall proc_modules_init+0x0/0x40 returned 0 after 60 usecs
[42949373.490000] calling  kallsyms_init+0x0/0x40 @ 1
[42949373.490000] initcall kallsyms_init+0x0/0x40 returned 0 after 46 usecs
[42949373.490000] calling  utsname_sysctl_init+0x0/0x20 @ 1
[42949373.490000] initcall utsname_sysctl_init+0x0/0x20 returned 0 after 40 usecs
[42949373.490000] calling  ftrace_nodyn_init+0x0/0x24 @ 1
[42949373.490000] initcall ftrace_nodyn_init+0x0/0x24 returned 0 after 5 usecs
[42949373.490000] calling  init_sched_switch_trace+0x0/0x54 @ 1
[42949373.490000] initcall init_sched_switch_trace+0x0/0x54 returned 0 after 18 usecs
[42949373.490000] calling  init_function_trace+0x0/0x1c @ 1
[42949373.490000] initcall init_function_trace+0x0/0x1c returned 0 after 10 usecs
[42949373.490000] calling  init_wakeup_tracer+0x0/0x1c @ 1
[42949373.490000] initcall init_wakeup_tracer+0x0/0x1c returned 0 after 11 usecs
[42949373.490000] calling  stack_trace_init+0x0/0xa4 @ 1
[42949373.490000] initcall stack_trace_init+0x0/0xa4 returned 0 after 255 usecs
[42949373.500000] calling  init_per_zone_pages_min+0x0/0x58 @ 1
[42949373.500000] initcall init_per_zone_pages_min+0x0/0x58 returned 0 after 486 usecs
[42949373.500000] calling  pdflush_init+0x0/0x1c @ 1
[42949373.500000] initcall pdflush_init+0x0/0x1c returned 0 after 992 usecs
[42949373.500000] calling  kswapd_init+0x0/0x20 @ 1
[42949373.500000] initcall kswapd_init+0x0/0x20 returned 0 after 602 usecs
[42949373.500000] calling  setup_vmstat+0x0/0x98 @ 1
[42949373.500000] initcall setup_vmstat+0x0/0x98 returned 0 after 180 usecs
[42949373.500000] calling  mm_sysfs_init+0x0/0x40 @ 1
[42949373.500000] initcall mm_sysfs_init+0x0/0x40 returned 0 after 124 usecs
[42949373.500000] calling  proc_vmalloc_init+0x0/0x40 @ 1
[42949373.500000] initcall proc_vmalloc_init+0x0/0x40 returned 0 after 78 usecs
[42949373.500000] calling  init_tmpfs+0x0/0xe0 @ 1
[42949373.500000] initcall init_tmpfs+0x0/0xe0 returned 0 after 692 usecs
[42949373.500000] calling  slab_proc_init+0x0/0x40 @ 1
[42949373.500000] initcall slab_proc_init+0x0/0x40 returned 0 after 88 usecs
[42949373.500000] calling  cpucache_init+0x0/0x1c @ 1
[42949373.500000] initcall cpucache_init+0x0/0x1c returned 0 after 46 usecs
[42949373.500000] calling  fasync_init+0x0/0x48 @ 1
[42949373.500000] initcall fasync_init+0x0/0x48 returned 0 after 247 usecs
[42949373.500000] calling  proc_filesystems_init+0x0/0x40 @ 1
[42949373.500000] initcall proc_filesystems_init+0x0/0x40 returned 0 after 84 usecs
[42949373.500000] calling  inotify_setup+0x0/0x20 @ 1
[42949373.500000] initcall inotify_setup+0x0/0x20 returned 0 after 11 usecs
[42949373.500000] calling  inotify_user_setup+0x0/0xc4 @ 1
[42949373.500000] initcall inotify_user_setup+0x0/0xc4 returned 0 after 439 usecs
[42949373.500000] calling  aio_setup+0x0/0x8c @ 1
[42949373.510000] initcall aio_setup+0x0/0x8c returned 0 after 1261 usecs
[42949373.510000] calling  proc_locks_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_locks_init+0x0/0x40 returned 0 after 108 usecs
[42949373.510000] calling  dnotify_init+0x0/0x48 @ 1
[42949373.510000] initcall dnotify_init+0x0/0x48 returned 0 after 208 usecs
[42949373.510000] calling  proc_cmdline_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_cmdline_init+0x0/0x40 returned 0 after 151 usecs
[42949373.510000] calling  proc_cpuinfo_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_cpuinfo_init+0x0/0x40 returned 0 after 66 usecs
[42949373.510000] calling  proc_devices_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_devices_init+0x0/0x40 returned 0 after 57 usecs
[42949373.510000] calling  proc_interrupts_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_interrupts_init+0x0/0x40 returned 0 after 55 usecs
[42949373.510000] calling  proc_loadavg_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_loadavg_init+0x0/0x40 returned 0 after 59 usecs
[42949373.510000] calling  proc_meminfo_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_meminfo_init+0x0/0x40 returned 0 after 54 usecs
[42949373.510000] calling  proc_stat_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_stat_init+0x0/0x40 returned 0 after 57 usecs
[42949373.510000] calling  proc_uptime_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_uptime_init+0x0/0x40 returned 0 after 59 usecs
[42949373.510000] calling  proc_version_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_version_init+0x0/0x40 returned 0 after 58 usecs
[42949373.510000] calling  proc_kmsg_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_kmsg_init+0x0/0x40 returned 0 after 55 usecs
[42949373.510000] calling  proc_page_init+0x0/0x60 @ 1
[42949373.510000] initcall proc_page_init+0x0/0x60 returned 0 after 86 usecs
[42949373.510000] calling  init_devpts_fs+0x0/0x48 @ 1
[42949373.510000] initcall init_devpts_fs+0x0/0x48 returned 0 after 242 usecs
[42949373.510000] calling  init_ramfs_fs+0x0/0x1c @ 1
[42949373.510000] initcall init_ramfs_fs+0x0/0x1c returned 0 after 30 usecs
[42949373.510000] calling  init_nfs_fs+0x0/0x150 @ 1
[42949373.520000] initcall init_nfs_fs+0x0/0x150 returned 0 after 2263 usecs
[42949373.520000] calling  init_nlm+0x0/0x34 @ 1
[42949373.520000] initcall init_nlm+0x0/0x34 returned 0 after 51 usecs
[42949373.520000] calling  init_jffs2_fs+0x0/0xe0 @ 1
[42949373.520000] JFFS2 version 2.2. (NAND) (SUMMARY)  (c) 2001-2006 Red Hat, Inc.
[42949373.520000] initcall init_jffs2_fs+0x0/0xe0 returned 0 after 2921 usecs
[42949373.520000] calling  ipc_init+0x0/0x2c @ 1
[42949373.520000] msgmni has been set to 57
[42949373.520000] initcall ipc_init+0x0/0x2c returned 0 after 334 usecs
[42949373.520000] calling  ipc_sysctl_init+0x0/0x20 @ 1
[42949373.520000] initcall ipc_sysctl_init+0x0/0x20 returned 0 after 58 usecs
[42949373.520000] calling  crypto_algapi_init+0x0/0x18 @ 1
[42949373.520000] initcall crypto_algapi_init+0x0/0x18 returned 0 after 93 usecs
[42949373.520000] calling  chainiv_module_init+0x0/0x1c @ 1
[42949373.520000] initcall chainiv_module_init+0x0/0x1c returned 0 after 37 usecs
[42949373.520000] calling  eseqiv_module_init+0x0/0x1c @ 1
[42949373.520000] initcall eseqiv_module_init+0x0/0x1c returned 0 after 20 usecs
[42949373.520000] calling  md5_mod_init+0x0/0x1c @ 1
[42949373.520000] initcall md5_mod_init+0x0/0x1c returned 0 after 1391 usecs
[42949373.520000] calling  crypto_ecb_module_init+0x0/0x1c @ 1
[42949373.520000] initcall crypto_ecb_module_init+0x0/0x1c returned 0 after 36 usecs
[42949373.520000] calling  crypto_cbc_module_init+0x0/0x1c @ 1
[42949373.520000] initcall crypto_cbc_module_init+0x0/0x1c returned 0 after 25 usecs
[42949373.520000] calling  des_generic_mod_init+0x0/0x44 @ 1
[42949373.530000] initcall des_generic_mod_init+0x0/0x44 returned 0 after 3270 usecs
[42949373.530000] calling  aes_init+0x0/0x370 @ 1
[42949373.530000] initcall aes_init+0x0/0x370 returned 0 after 2464 usecs
[42949373.530000] calling  arc4_init+0x0/0x1c @ 1
[42949373.530000] initcall arc4_init+0x0/0x1c returned 0 after 1786 usecs
[42949373.530000] calling  krng_mod_init+0x0/0x1c @ 1
[42949373.530000] alg: No test for stdrng (krng)
[42949373.530000] initcall krng_mod_init+0x0/0x1c returned 0 after 1067 usecs
[42949373.530000] calling  proc_genhd_init+0x0/0x60 @ 1
[42949373.540000] initcall proc_genhd_init+0x0/0x60 returned 0 after 356 usecs
[42949373.540000] calling  noop_init+0x0/0x20 @ 1
[42949373.540000] io scheduler noop registered (default)
[42949373.540000] initcall noop_init+0x0/0x20 returned 0 after 129 usecs
[42949373.540000] calling  rand_initialize+0x0/0x3c @ 1
[42949373.540000] initcall rand_initialize+0x0/0x3c returned 0 after 504 usecs
[42949373.540000] calling  tty_init+0x0/0x110 @ 1
[42949373.670000] initcall tty_init+0x0/0x110 returned 0 after 131121 usecs
[42949373.670000] calling  pty_init+0x0/0x2b8 @ 1
[42949373.670000] initcall pty_init+0x0/0x2b8 returned 0 after 2408 usecs
[42949373.670000] calling  serial8250_init+0x0/0x114 @ 1
[42949373.670000] Serial: 8250/16550 driver1 ports, IRQ sharing disabled
[42949373.680000] serial8250: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
[42949373.680000] DBG::bus: 'platform': add driver serial8250
[42949373.680000] serial8250.0: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
[42949373.690000] initcall serial8250_init+0x0/0x114 returned 0 after 12088 usecs
[42949373.690000] calling  net_olddevs_init+0x0/0xc8 @ 1
[42949373.690000] initcall net_olddevs_init+0x0/0xc8 returned 0 after 114 usecs
[42949373.690000] calling  init_mtd+0x0/0x44 @ 1
[42949373.690000] initcall init_mtd+0x0/0x44 returned 0 after 137 usecs
[42949373.690000] calling  init_mtdchar+0x0/0x98 @ 1
[42949373.690000] initcall init_mtdchar+0x0/0x98 returned 0 after 1392 usecs
[42949373.690000] calling  init_mtdblock+0x0/0x1c @ 1
[42949373.690000] initcall init_mtdblock+0x0/0x1c returned 0 after 815 usecs
[42949373.690000] calling  nand_base_init+0x0/0x14 @ 1
[42949373.690000] initcall nand_base_init+0x0/0x14 returned 0 after 13 usecs
[42949373.690000] calling  lpc313x_nand_init+0x0/0x1c @ 1
[42949373.690000] DBG::bus: 'platform': add driver lpc313x_nand
[42949373.690000] NAND device: Manufacturer ID: 0x20, Chip ID: 0x73 (ST Micro NAND 16MiB 3,3V 8-bit)
[42949373.690000] Bad block table found at page 32736, version 0x00
[42949373.690000] Bad block table found at page 32704, version 0x00
[42949373.690000] nand_read_bbt: Bad block at 0x00000000
[42949373.690000] nand_read_bbt: Bad block at 0x00000000
[42949373.700000] Creating 10 MTD partitions on "NAND 16MiB 3,3V 8-bit":
[42949373.700000] 0x00004000-0x00018000 : "apex1"
[42949373.700000] 0x00018000-0x0002c000 : "apex2"
[42949373.710000] 0x0002c000-0x00030000 : "apex-env"
[42949373.720000] 0x00030000-0x00050000 : "sysconfig"
[42949373.720000] 0x00050000-0x001cc000 : "kernel1"
[42949373.730000] 0x001cc000-0x00348000 : "kernel2"
[42949373.740000] 0x00348000-0x00368000 : "configfs"
[42949373.750000] 0x00368000-0x00e58000 : "rootfs"
[42949373.760000] 0x00e58000-0x00fe8000 : "safefs"
[42949373.760000] 0x00fe8000-0x00ff0000 : "log"
[42949373.770000] initcall lpc313x_nand_init+0x0/0x1c returned 0 after 78275 usecs
[42949373.770000] calling  mousedev_init+0x0/0x68 @ 1
[42949373.770000] mice: PS/2 mouse device common for all mice
[42949373.770000] initcall mousedev_init+0x0/0x68 returned 0 after 2127 usecs
[42949373.780000] calling  lpc313x_wdt_init+0x0/0x1c @ 1
[42949373.780000] DBG::bus: 'platform': add driver lpc313x-wdt
[42949373.780000] CGU: Get clock id:34 freq:6000000
[42949373.780000] lpc313x-wdt lpc313x-wdt: Watchdog device driver initialized.
[42949373.780000] initcall lpc313x_wdt_init+0x0/0x1c returned 0 after 4356 usecs
[42949373.780000] calling  init_ladder+0x0/0x1c @ 1
[42949373.780000] cpuidle: using governor ladder
[42949373.780000] initcall init_ladder+0x0/0x1c returned 0 after 124 usecs
[42949373.780000] calling  sysctl_core_init+0x0/0x30 @ 1
[42949373.780000] initcall sysctl_core_init+0x0/0x30 returned 0 after 166 usecs
[42949373.780000] calling  sysctl_ipv4_init+0x0/0x4c @ 1
[42949373.780000] initcall sysctl_ipv4_init+0x0/0x4c returned 0 after 230 usecs
[42949373.780000] calling  cubictcp_register+0x0/0x6c @ 1
[42949373.780000] TCP cubic registered
[42949373.780000] initcall cubictcp_register+0x0/0x6c returned 0 after 102 usecs
[42949373.780000] calling  packet_init+0x0/0x50 @ 1
[42949373.780000] NET: Registered protocol family 17
[42949373.780000] initcall packet_init+0x0/0x50 returned 0 after 248 usecs
[42949373.780000] calling  init_sunrpc+0x0/0x60 @ 1
[42949373.780000] RPC: Registered udp transport module.
[42949373.790000] RPC: Registered tcp transport module.
[42949373.790000] initcall init_sunrpc+0x0/0x60 returned 0 after 2596 usecs
[42949373.790000] calling  init_rpcsec_gss+0x0/0x3c @ 1
[42949373.790000] initcall init_rpcsec_gss+0x0/0x3c returned 0 after 212 usecs
[42949373.790000] calling  init_kerberos_module+0x0/0x34 @ 1
[42949373.790000] initcall init_kerberos_module+0x0/0x34 returned 0 after 69 usecs
[42949373.790000] calling  rfkill_handler_init+0x0/0x48 @ 1
[42949373.790000] initcall rfkill_handler_init+0x0/0x48 returned 0 after 24 usecs
[42949373.790000] calling  init_oops_id+0x0/0x40 @ 1
[42949373.790000] initcall init_oops_id+0x0/0x40 returned 0 after 108 usecs
[42949373.790000] calling  disable_boot_consoles+0x0/0x50 @ 1
[42949373.790000] initcall disable_boot_consoles+0x0/0x50 returned 0 after 12 usecs
[42949373.790000] calling  pm_qos_power_init+0x0/0x6c @ 1
[42949373.790000] initcall pm_qos_power_init+0x0/0x6c returned 0 after 5821 usecs
[42949373.790000] calling  random32_reseed+0x0/0x6c @ 1
[42949373.800000] initcall random32_reseed+0x0/0x6c returned 0 after 312 usecs
[42949373.800000] calling  seqgen_init+0x0/0x1c @ 1
[42949373.800000] initcall seqgen_init+0x0/0x1c returned 0 after 281 usecs
[42949373.800000] calling  tcp_congestion_default+0x0/0x1c @ 1
[42949373.800000] initcall tcp_congestion_default+0x0/0x1c returned 0 after 22 usecs
[42949373.800000] calling  ip_auto_config+0x0/0xe6c @ 1
[42949373.800000] initcall ip_auto_config+0x0/0xe6c returned 0 after 113 usecs
[42949374.340000] jffs2_scan_inode_node(): CRC failed on node at 0x008b4dc8: Read 0xffffffff, calculated 0xc9c59f44
[42949374.430000] VFS: Mounted root (jffs2 filesystem) readonly.
[42949374.430000] Freeing init memory: 92K
[42949376.730000] CGU: Get clock id:34 freq:6000000
[42949376.730000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949377.930000] jffs2_scan_inode_node(): CRC failed on node at 0x0001c5f4: Read 0xffffffff, calculated 0x1490a44b
[42949377.940000] CGU: Get clock id:34 freq:6000000
[42949377.940000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.130000] Empty flash at 0x0014e310 ends at 0x0014e400
[42949378.160000] CGU: Get clock id:34 freq:6000000
[42949378.160000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.580000] CGU: Get clock id:34 freq:6000000
[42949378.580000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.610000] CGU: Get clock id:34 freq:6000000
[42949378.610000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.670000] calling  on_load+0x0/0xc4 [bpsled] @ 292
[42949378.670000] initcall on_load+0x0/0xc4 [bpsled] returned -16 after 24 usecs
[42949378.670000] initcall on_load+0x0/0xc4 [bpsled] returned with error code -16
[42949378.730000] CGU: Get clock id:34 freq:6000000
[42949378.730000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.780000] CGU: Get clock id:34 freq:6000000
[42949378.780000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.790000] CGU: Get clock id:34 freq:6000000
[42949378.790000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949379.260000] calling  udc_init+0x0/0x40 [nxp_usb2_udc] @ 302
[42949379.260000] Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
[42949379.260000] DBG::bus: 'platform': add driver fsl-usb2-udc
[42949379.270000] initcall udc_init+0x0/0x40 [nxp_usb2_udc] returned 0 after 8192 usecs
[42949379.780000] calling  init+0x0/0xc4 [g_serial] @ 302
[42949379.790000] g_serial gadget: Gadget Serial v2.4
[42949379.790000] g_serial gadget: g_serial ready
[42949379.790000] fsl-usb2-udc: bind to driver g_serial
[42949379.790000] initcall init+0x0/0xc4 [g_serial] returned 0 after 5769 usecs
[42949379.850000] CGU: Get clock id:34 freq:6000000
[42949379.850000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949380.070000] g_serial gadget: high speed config #2: CDC ACM config
[42949384.520000] CGU: Get clock id:34 freq:6000000
[42949469.800000] calling  lpc313x_mci_init+0x0/0x24 [lpc313x_mmc] @ 329
[42949469.800000] DBG::bus: 'platform': add driver lpc313x_mmc
[42949469.800000] CGU: Get clock id:20 freq:45000000
[42949469.800000] Powering off wl12xx<6>Powering off wl12xx<6>Powering down MMC Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x MMC controller at irq 26
[42949469.830000] initcall lpc313x_mci_init+0x0/0x24 [lpc313x_mmc] returned 0 after 28094 usecs
[42949469.930000] Powering up MMC Slot<4>mmc0: card claims to support voltages below the defined range. These will be ignored.
[42949469.990000] mmc0: queuing CIS tuple 0x91 length 3
[42949469.990000] mmc_attach_sdio the value of funcs=0x2
[42949469.990000] mmc_attach_sdio the value of funcs=0x2
[42949469.990000] mmc0: new SDIO card at address 0001
[42949470.020000] Powering on wl12xxcalling  __init_compat+0x0/0x40 [compat] @ 338
[42949492.670000] Compat-wireless backport release: compat-wireless-3.5-rc5-1
[42949492.670000] Backport based on linux-stable.git v3.5-rc5
[42949492.670000] compat.git: linux-stable.git
[42949492.670000] initcall __init_compat+0x0/0x40 [compat] returned 0 after 2313 usecs
[42949495.630000] calling  __init_compat+0x0/0x94 [rfkill_backport] @ 343
[42949495.650000] initcall __init_compat+0x0/0x94 [rfkill_backport] returned 0 after 22300 usecs
[42949500.410000] calling  __init_compat+0x0/0xd8 [cfg80211] @ 347
[42949500.610000] cfg80211: Calling CRDA to update world regulatory domain
[42949500.620000] initcall __init_compat+0x0/0xd8 [cfg80211] returned 0 after 204688 usecs
[42949505.750000] calling  __init_compat+0x0/0x54 [mac80211] @ 353
[42949505.760000] initcall __init_compat+0x0/0x54 [mac80211] returned 0 after 4565 usecs
[42949510.640000] calling  __init_compat+0x0/0x28 [compat_firmware_class] @ 355
[42949510.650000] initcall __init_compat+0x0/0x28 [compat_firmware_class] returned 0 after 11131 usecs
[42949518.600000] calling  __init_compat+0x0/0x20 [wl12xx] @ 360
[42949518.600000] DBG::bus: 'platform': add driver wl12xx
[42949518.620000] initcall __init_compat+0x0/0x20 [wl12xx] returned 0 after 10430 usecs
[42949523.250000] calling  __init_compat+0x0/0x20 [wlcore_sdio] @ 363
[42949523.250000] DBG::bus: 'sdio': add driver wl1271_sdio
[42949523.300000] Powering on wl12xx<6>Powering up MMC Slot<6>Powering off wl12xx<6>Powering down MMC Slot<6>wl12xx: loaded
[42949523.680000] initcall __init_compat+0x0/0x20 [wlcore_sdio] returned 0 after 425374 usecs
[42949560.670000] Powering on wl12xx<6>Powering up MMC Slot<6>wl12xx: firmware booted (Rev 6.3.7.0.105)
[42949631.870000] wlan0: authenticate with c166962c
[42949631.950000] wlan0: send auth to c166962c (try 1/3)
[42949631.950000] wlan0: authenticated
[42949632.010000] wlan0: associate with c166962c (try 1/3)
[42949632.020000] wlan0: RX AssocResp from c1669a1a (capab=0x431 status=0 aid=1)
[42949632.020000] wlan0: associated
[42949637.640000] wl12xx: Association completed.
[42949668.960000] wl12xx: Reading FW panic log
[42949668.960000] wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.7.0.105 pc: 0x0
[42949668.960000] wl12xx: down
[42949668.960000] Powering off wl12xx<6>Powering down MMC Slot<6>ieee80211 phy0: Hardware restart was requested
[42949669.000000] Powering on wl12xx<6>Powering up MMC Slot<1>Unable to handle kernel paging request at virtual address c2a2f000
[42949669.510000] pgd = c0004000
[42949669.520000] [c2a2f000] *pgd=316bf011, *pte=00000000, *ppte=00000000
[42949669.560000] Internal error: Oops: 7 [#1]
[42949669.560000] Modules linked in: wlcore_sdio wl12xx wlcore compat_firmware_class mac80211 cfg80211 rfkill_backport compat lpc313x_mmc g_serial nxp_usb2_udc
[42949669.560000] CPU: 0    Not tainted  (2.6.28.2 #1)
[42949669.560000] PC is at memcpy+0x48/0x330
[42949669.560000] LR is at 0x6e05524b
[42949669.560000] pc : [<c0139c08>]    lr : [<6e05524b>]    psr: 60000013
[42949669.560000] sp : c14b9e0c  ip : 00200080  fp : c14b9e94
[42949669.560000] r10: c2a2b00c  r9 : 00000006  r8 : 2bd00006
[42949669.560000] r7 : 0714524b  r6 : 00200080  r5 : 4bd00006  r4 : 041e8401
[42949669.560000] r3 : 88880888  r2 : ffffffa0  r1 : c2a2efec  r0 : c1657fe0
[42949669.560000] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[42949669.560000] Control: 0005317f  Table: 316a4000  DAC: 00000017
[42949669.560000] Process events/0 (pid: 340, stack limit = 0xc14b8268)
[42949669.560000] Stack: (0xc14b9e0c to 0xc14ba000)
[42949669.560000] 9e00:                            0002b318 00014000 00000005 c1654000 c1654000
[42949669.560000] 9e20: c1f217a0 bf0c2184 00000000 c00325ec c14b9e54 c14b9e48 000277c0 c2a1700c
[42949669.560000] 9e40: 00000000 0000000a 000177c0 00010000 00008800 00300000 00000000 00000000
[42949669.560000] 9e60: 00000000 00000000 c1f217a0 c1f217a0 c1f21b04 00305618 00000000 ffffff08
[42949669.560000] 9e80: 00000002 c1f219ac c14b9ec4 c14b9e98 bf0dcec8 bf0c202c 00000000 bf0ac2a8
[42949669.560000] 9ea0: c1efb9e8 c1efb8f0 c1f217a0 c1efb860 c1f217d4 c1efb8f4 c14b9f1c c14b9ec8
[42949669.560000] 9ec0: bf0b988c bf0dc928 c001fea0 c1f217e0 00000000 c1f200e0 00000002 c1efb860
[42949669.560000] 9ee0: 00000001 00000002 c1efb860 00000001 bf0b5298 c1f20ae0 c1efb3a0 c1f21384
[42949669.560000] 9f00: 00000000 c1f211dc 00000000 00000000 c14b9f5c c14b9f20 bf086c78 bf0b94d0
[42949669.560000] 9f20: c020661c bf06e590 c14b9f5c c14b9f38 bf06e590 c1f20ae0 c1f211fc c1f21384
[42949669.560000] 9f40: 00000000 00000000 00000000 00000000 c14b9f7c c14b9f60 bf069418 bf086aac
[42949669.560000] 9f60: c1520820 c14b8000 bf06939c 00000000 c14b9f9c c14b9f80 c00487a4 bf0693ac
[42949669.560000] 9f80: c1520820 c14b8000 c14b9fa4 c1520828 c14b9fd4 c14b9fa0 c0048f18 c00486f0
[42949669.560000] 9fa0: 00000000 00000000 c1eed360 c004cdc4 c14b9fb0 c14b9fb0 c14b8000 c0048e0c
[42949669.560000] 9fc0: c1520820 00000000 c14b9ff4 c14b9fd8 c004c888 c0048e1c 00000000 00000000
[42949669.560000] 9fe0: 00000000 00000000 00000000 c14b9ff8 c003ab6c c004c838 00000000 fff10004
[42949669.560000] Backtrace:
[42949669.560000] [<bf0c201c>] (wlcore_boot_upload_firmware+0x0/0x244 [wlcore]) from [<bf0dcec8>] (wl12xx_boot+0x5b0/0x738 [wl12xx])
[42949669.560000] [<bf0dc918>] (wl12xx_boot+0x0/0x738 [wl12xx]) from [<bf0b988c>] (wl1271_op_add_interface+0x3cc/0x5a0 [wlcore])
[42949669.560000]  r8:c1efb8f4 r7:c1f217d4 r6:c1efb860 r5:c1f217a0 r4:c1efb8f0
[42949669.560000] [<bf0b94c0>] (wl1271_op_add_interface+0x0/0x5a0 [wlcore]) from [<bf086c78>] (ieee80211_reconfig+0x1dc/0x758 [mac80211])
[42949669.560000] [<bf086a9c>] (ieee80211_reconfig+0x0/0x758 [mac80211]) from [<bf069418>] (ieee80211_restart_work+0x7c/0x94 [mac80211])
[42949669.560000] [<bf06939c>] (ieee80211_restart_work+0x0/0x94 [mac80211]) from [<c00487a4>] (run_workqueue+0xc4/0x14c)
[42949669.560000]  r7:00000000 r6:bf06939c r5:c14b8000 r4:c1520820
[42949669.560000] [<c00486e0>] (run_workqueue+0x0/0x14c) from [<c0048f18>] (worker_thread+0x10c/0x120)
[42949669.560000]  r7:c1520828 r6:c14b9fa4 r5:c14b8000 r4:c1520820
[42949669.560000] [<c0048e0c>] (worker_thread+0x0/0x120) from [<c004c888>] (kthread+0x60/0x9c)
[42949669.560000]  r7:00000000 r6:c1520820 r5:c0048e0c r4:c14b8000
[42949669.560000] [<c004c828>] (kthread+0x0/0x9c) from [<c003ab6c>] (do_exit+0x0/0x734)
[42949669.560000]  r7:00000000 r6:00000000 r5:00000000 r4:00000000
[42949669.560000] Code: ba000002 f5d1f03c f5d1f05c f5d1f07c (e8b151f8)
[42949669.570000] ---[ end trace 4d153cca98b32114 ]---
/wlan # l ./wpa_cli -i wlan1 p2p_group_add freq=2412
Failed to connect to wpa_supplicant - wpa_ctrl_open: No such file or directory
/wlan #
/wlan # dmesg
[    0.000000] Linux version 2.6.28.2 (root@BPSBuildEnvironment) (gcc version 4.4.2 (GCC) ) #1 Fri Aug 24 17:40:11 IST 2012
[    0.000000] CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: Brady BPS313XV1
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 8192
[    0.000000] free_area_init_node: node 0, pgdat c02aa6dc, node_mem_map c032f000
[    0.000000]   Normal zone: 64 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 8128 pages, LIFO batch:0
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
[    0.000000] Kernel command line: console=0 rootfstype=jffs2 quiet root=/dev/mtdblock7 safefs=0 kernel=1 sku=772 initcall_debug printk.time=1
[    0.000000] irq=30 Event=0x3e bank:1 bit:30 type:0

[    0.000000] irq=31 Event=0x54 bank:2 bit:20 type:0

[    0.000000] irq=32 Event=0x4b bank:2 bit:11 type:0

[    0.000000] PID hash table entries: 128 (order: 7, 512 bytes)
[42949372.960000] Console: colour dummy device 80x30
[42949372.960000] console [ttyS0] enabled
[42949372.960000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
[42949372.960000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
[42949372.960000] Memory: 32MB = 32MB total
[42949372.960000] Memory: 29192KB available (2488K code, 639K data, 92K init)
[42949372.970000] Calibrating delay loop... 89.70 BogoMIPS (lpj=448512)
[42949373.160000] Mount-cache hash table entries: 512
[42949373.160000] CPU: Testing write buffer coherency: ok
[42949373.160000] calling  spawn_ksoftirqd+0x0/0x5c @ 1
[42949373.160000] initcall spawn_ksoftirqd+0x0/0x5c returned 0 after 477 usecs
[42949373.160000] calling  tracer_alloc_buffers+0x0/0x180 @ 1
[42949373.170000] initcall tracer_alloc_buffers+0x0/0x180 returned 0 after 6994 usecs
[42949373.170000] calling  net_ns_init+0x0/0x144 @ 1
[42949373.170000] net_namespace: 312 bytes
[42949373.170000] initcall net_ns_init+0x0/0x144 returned 0 after 85 usecs
[42949373.170000] calling  ptrace_break_init+0x0/0x2c @ 1
[42949373.170000] initcall ptrace_break_init+0x0/0x2c returned 0 after 11 usecs
[42949373.170000] calling  consistent_init+0x0/0xc8 @ 1
[42949373.170000] initcall consistent_init+0x0/0xc8 returned 0 after 75 usecs
[42949373.170000] calling  sysctl_init+0x0/0x24 @ 1
[42949373.170000] initcall sysctl_init+0x0/0x24 returned 0 after 74 usecs
[42949373.170000] calling  ksysfs_init+0x0/0xcc @ 1
[42949373.180000] initcall ksysfs_init+0x0/0xcc returned 0 after 322 usecs
[42949373.180000] calling  init_jiffies_clocksource+0x0/0x1c @ 1
[42949373.180000] initcall init_jiffies_clocksource+0x0/0x1c returned 0 after 20 usecs
[42949373.180000] calling  pm_init+0x0/0x44 @ 1
[42949373.180000] initcall pm_init+0x0/0x44 returned 0 after 140 usecs
[42949373.180000] calling  filelock_init+0x0/0x4c @ 1
[42949373.180000] initcall filelock_init+0x0/0x4c returned 0 after 147 usecs
[42949373.180000] calling  init_script_binfmt+0x0/0x1c @ 1
[42949373.180000] initcall init_script_binfmt+0x0/0x1c returned 0 after 12 usecs
[42949373.180000] calling  init_elf_binfmt+0x0/0x1c @ 1
[42949373.180000] initcall init_elf_binfmt+0x0/0x1c returned 0 after 8 usecs
[42949373.180000] calling  debugfs_init+0x0/0x60 @ 1
[42949373.180000] initcall debugfs_init+0x0/0x60 returned 0 after 110 usecs
[42949373.180000] calling  random32_init+0x0/0x80 @ 1
[42949373.180000] initcall random32_init+0x0/0x80 returned 0 after 11 usecs
[42949373.180000] calling  cpuidle_init+0x0/0x34 @ 1
[42949373.180000] initcall cpuidle_init+0x0/0x34 returned 0 after 98 usecs
[42949373.180000] calling  sock_init+0x0/0x78 @ 1
[42949373.180000] initcall sock_init+0x0/0x78 returned 0 after 541 usecs
[42949373.180000] calling  netlink_proto_init+0x0/0x174 @ 1
[42949373.180000] NET: Registered protocol family 16
[42949373.180000] initcall netlink_proto_init+0x0/0x174 returned 0 after 399 usecs
[42949373.180000] calling  bdi_class_init+0x0/0x54 @ 1
[42949373.180000] initcall bdi_class_init+0x0/0x54 returned 0 after 1436 usecs
[42949373.180000] calling  kobject_uevent_init+0x0/0x64 @ 1
[42949373.180000] initcall kobject_uevent_init+0x0/0x64 returned 0 after 85 usecs
[42949373.180000] calling  tty_class_init+0x0/0x38 @ 1
[42949373.180000] initcall tty_class_init+0x0/0x38 returned 0 after 1219 usecs
[42949373.180000] calling  vtconsole_class_init+0x0/0xe8 @ 1
[42949373.190000] initcall vtconsole_class_init+0x0/0xe8 returned 0 after 2863 usecs
[42949373.190000] calling  customize_machine+0x0/0x2c @ 1
[42949373.190000] cgu_init pll set at 180000000
[42949373.190000] Registering USB gadget 0x00000f20 0x02800004 (3)
[42949373.200000] initcall customize_machine+0x0/0x2c returned 0 after 12677 usecs
[42949373.200000] calling  wdt_device_init+0x0/0x1c @ 1
[42949373.200000] initcall wdt_device_init+0x0/0x1c returned 0 after 1433 usecs
[42949373.200000] calling  lpc313x_pm_init+0x0/0x2c @ 1
[42949373.200000] LPC31: Power Management init.
[42949373.200000] initcall lpc313x_pm_init+0x0/0x2c returned 0 after 71 usecs
[42949373.200000] calling  topology_init+0x0/0x30 @ 1
[42949373.200000] initcall topology_init+0x0/0x30 returned 0 after 1126 usecs
[42949373.200000] calling  param_sysfs_init+0x0/0x200 @ 1
[42949373.250000] initcall param_sysfs_init+0x0/0x200 returned 0 after 42204 usecs
[42949373.250000] calling  readahead_init+0x0/0x3c @ 1
[42949373.250000] initcall readahead_init+0x0/0x3c returned 0 after 1597 usecs
[42949373.250000] calling  init_bio+0x0/0xd8 @ 1
[42949373.250000] initcall init_bio+0x0/0xd8 returned 0 after 782 usecs
[42949373.250000] calling  cryptomgr_init+0x0/0x38 @ 1
[42949373.250000] initcall cryptomgr_init+0x0/0x38 returned 0 after 134 usecs
[42949373.250000] calling  blk_settings_init+0x0/0x44 @ 1
[42949373.250000] initcall blk_settings_init+0x0/0x44 returned 0 after 12 usecs
[42949373.250000] calling  blk_ioc_init+0x0/0x48 @ 1
[42949373.250000] initcall blk_ioc_init+0x0/0x48 returned 0 after 127 usecs
[42949373.250000] calling  blk_softirq_init+0x0/0x34 @ 1
[42949373.250000] initcall blk_softirq_init+0x0/0x34 returned 0 after 9 usecs
[42949373.250000] calling  genhd_device_init+0x0/0x8c @ 1
[42949373.250000] initcall genhd_device_init+0x0/0x8c returned 0 after 2181 usecs
[42949373.250000] calling  misc_init+0x0/0xac @ 1
[42949373.260000] initcall misc_init+0x0/0xac returned 0 after 1847 usecs
[42949373.260000] calling  input_init+0x0/0x11c @ 1
[42949373.260000] initcall input_init+0x0/0x11c returned 0 after 1314 usecs
[42949373.260000] calling  mmc_init+0x0/0x90 @ 1
[42949373.260000] initcall mmc_init+0x0/0x90 returned 0 after 4389 usecs
[42949373.260000] calling  proto_init+0x0/0x3c @ 1
[42949373.260000] initcall proto_init+0x0/0x3c returned 0 after 71 usecs
[42949373.260000] calling  net_dev_init+0x0/0x124 @ 1
[42949373.270000] initcall net_dev_init+0x0/0x124 returned 0 after 1557 usecs
[42949373.270000] calling  neigh_init+0x0/0x8c @ 1
[42949373.270000] initcall neigh_init+0x0/0x8c returned 0 after 17 usecs
[42949373.270000] calling  genl_init+0x0/0xe8 @ 1
[42949373.320000] initcall genl_init+0x0/0xe8 returned 0 after 47865 usecs
[42949373.320000] calling  wireless_nlevent_init+0x0/0x28 @ 1
[42949373.320000] initcall wireless_nlevent_init+0x0/0x28 returned 0 after 11 usecs
[42949373.320000] calling  rfkill_init+0x0/0x74 @ 1
[42949373.320000] initcall rfkill_init+0x0/0x74 returned 0 after 1211 usecs
[42949373.320000] calling  sysctl_init+0x0/0x54 @ 1
[42949373.320000] initcall sysctl_init+0x0/0x54 returned 0 after 25 usecs
[42949373.320000] calling  alignment_init+0x0/0xe4 @ 1
[42949373.320000] initcall alignment_init+0x0/0xe4 returned 0 after 109 usecs
[42949373.320000] calling  clocksource_done_booting+0x0/0x24 @ 1
[42949373.320000] initcall clocksource_done_booting+0x0/0x24 returned 0 after 7 usecs
[42949373.320000] calling  rb_init_debugfs+0x0/0x5c @ 1
[42949373.320000] initcall rb_init_debugfs+0x0/0x5c returned 0 after 133 usecs
[42949373.320000] calling  tracer_init_debugfs+0x0/0x300 @ 1
[42949373.320000] initcall tracer_init_debugfs+0x0/0x300 returned 0 after 452 usecs
[42949373.320000] calling  init_pipe_fs+0x0/0x58 @ 1
[42949373.320000] initcall init_pipe_fs+0x0/0x58 returned 0 after 160 usecs
[42949373.320000] calling  init_mnt_writers+0x0/0x20 @ 1
[42949373.320000] initcall init_mnt_writers+0x0/0x20 returned 0 after 10 usecs
[42949373.320000] calling  eventpoll_init+0x0/0xa4 @ 1
[42949373.320000] initcall eventpoll_init+0x0/0xa4 returned 0 after 321 usecs
[42949373.320000] calling  anon_inode_init+0x0/0x110 @ 1
[42949373.320000] initcall anon_inode_init+0x0/0x110 returned 0 after 164 usecs
[42949373.320000] calling  chr_dev_init+0x0/0xb8 @ 1
[42949373.330000] initcall chr_dev_init+0x0/0xb8 returned 0 after 11251 usecs
[42949373.330000] calling  firmware_class_init+0x0/0x74 @ 1
[42949373.330000] initcall firmware_class_init+0x0/0x74 returned 0 after 1209 usecs
[42949373.330000] calling  loopback_init+0x0/0x1c @ 1
[42949373.340000] initcall loopback_init+0x0/0x1c returned 0 after 2372 usecs
[42949373.340000] calling  inet_init+0x0/0x1dc @ 1
[42949373.340000] NET: Registered protocol family 2
[42949373.450000] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[42949373.450000] TCP established hash table entries: 1024 (order: 1, 8192 bytes)
[42949373.450000] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
[42949373.450000] TCP: Hash tables configured (established 1024 bind 1024)
[42949373.450000] TCP reno registered
[42949373.480000] initcall inet_init+0x0/0x1dc returned 0 after 134477 usecs
[42949373.480000] calling  af_unix_init+0x0/0x5c @ 1
[42949373.480000] NET: Registered protocol family 1
[42949373.480000] initcall af_unix_init+0x0/0x5c returned 0 after 418 usecs
[42949373.480000] calling  populate_rootfs+0x0/0xb8 @ 1
[42949373.480000] initcall populate_rootfs+0x0/0xb8 returned 0 after 2383 usecs
[42949373.480000] calling  timer_init_sysfs+0x0/0x40 @ 1
[42949373.480000] initcall timer_init_sysfs+0x0/0x40 returned 0 after 2300 usecs
[42949373.480000] calling  lpc313x_dma_init+0x0/0x84 @ 1
[42949373.480000] initcall lpc313x_dma_init+0x0/0x84 returned 0 after 123 usecs
[42949373.480000] calling  fpe_init+0x0/0x80 @ 1
[42949373.480000] NetWinder Floating Point Emulator V0.97 (double precision)
[42949373.480000] initcall fpe_init+0x0/0x80 returned 0 after 92 usecs
[42949373.480000] calling  proc_execdomains_init+0x0/0x40 @ 1
[42949373.480000] initcall proc_execdomains_init+0x0/0x40 returned 0 after 67 usecs
[42949373.480000] calling  ioresources_init+0x0/0x60 @ 1
[42949373.480000] initcall ioresources_init+0x0/0x60 returned 0 after 69 usecs
[42949373.480000] calling  uid_cache_init+0x0/0xb0 @ 1
[42949373.480000] initcall uid_cache_init+0x0/0xb0 returned 0 after 210 usecs
[42949373.480000] calling  init_posix_timers+0x0/0xfc @ 1
[42949373.480000] initcall init_posix_timers+0x0/0xfc returned 0 after 144 usecs
[42949373.480000] calling  init_posix_cpu_timers+0x0/0xe8 @ 1
[42949373.480000] initcall init_posix_cpu_timers+0x0/0xe8 returned 0 after 13 usecs
[42949373.480000] calling  nsproxy_cache_init+0x0/0x48 @ 1
[42949373.490000] initcall nsproxy_cache_init+0x0/0x48 returned 0 after 152 usecs
[42949373.490000] calling  timekeeping_init_device+0x0/0x30 @ 1
[42949373.490000] initcall timekeeping_init_device+0x0/0x30 returned 0 after 2315 usecs
[42949373.490000] calling  init_clocksource_sysfs+0x0/0x58 @ 1
[42949373.490000] initcall init_clocksource_sysfs+0x0/0x58 returned 0 after 2337 usecs
[42949373.490000] calling  init_timer_list_procfs+0x0/0x48 @ 1
[42949373.490000] initcall init_timer_list_procfs+0x0/0x48 returned 0 after 81 usecs
[42949373.490000] calling  init_tstats_procfs+0x0/0x48 @ 1
[42949373.490000] initcall init_tstats_procfs+0x0/0x48 returned 0 after 54 usecs
[42949373.490000] calling  futex_init+0x0/0x80 @ 1
[42949373.490000] initcall futex_init+0x0/0x80 returned 0 after 68 usecs
[42949373.490000] calling  proc_modules_init+0x0/0x40 @ 1
[42949373.490000] initcall proc_modules_init+0x0/0x40 returned 0 after 60 usecs
[42949373.490000] calling  kallsyms_init+0x0/0x40 @ 1
[42949373.490000] initcall kallsyms_init+0x0/0x40 returned 0 after 46 usecs
[42949373.490000] calling  utsname_sysctl_init+0x0/0x20 @ 1
[42949373.490000] initcall utsname_sysctl_init+0x0/0x20 returned 0 after 40 usecs
[42949373.490000] calling  ftrace_nodyn_init+0x0/0x24 @ 1
[42949373.490000] initcall ftrace_nodyn_init+0x0/0x24 returned 0 after 5 usecs
[42949373.490000] calling  init_sched_switch_trace+0x0/0x54 @ 1
[42949373.490000] initcall init_sched_switch_trace+0x0/0x54 returned 0 after 18 usecs
[42949373.490000] calling  init_function_trace+0x0/0x1c @ 1
[42949373.490000] initcall init_function_trace+0x0/0x1c returned 0 after 10 usecs
[42949373.490000] calling  init_wakeup_tracer+0x0/0x1c @ 1
[42949373.490000] initcall init_wakeup_tracer+0x0/0x1c returned 0 after 11 usecs
[42949373.490000] calling  stack_trace_init+0x0/0xa4 @ 1
[42949373.490000] initcall stack_trace_init+0x0/0xa4 returned 0 after 255 usecs
[42949373.500000] calling  init_per_zone_pages_min+0x0/0x58 @ 1
[42949373.500000] initcall init_per_zone_pages_min+0x0/0x58 returned 0 after 486 usecs
[42949373.500000] calling  pdflush_init+0x0/0x1c @ 1
[42949373.500000] initcall pdflush_init+0x0/0x1c returned 0 after 992 usecs
[42949373.500000] calling  kswapd_init+0x0/0x20 @ 1
[42949373.500000] initcall kswapd_init+0x0/0x20 returned 0 after 602 usecs
[42949373.500000] calling  setup_vmstat+0x0/0x98 @ 1
[42949373.500000] initcall setup_vmstat+0x0/0x98 returned 0 after 180 usecs
[42949373.500000] calling  mm_sysfs_init+0x0/0x40 @ 1
[42949373.500000] initcall mm_sysfs_init+0x0/0x40 returned 0 after 124 usecs
[42949373.500000] calling  proc_vmalloc_init+0x0/0x40 @ 1
[42949373.500000] initcall proc_vmalloc_init+0x0/0x40 returned 0 after 78 usecs
[42949373.500000] calling  init_tmpfs+0x0/0xe0 @ 1
[42949373.500000] initcall init_tmpfs+0x0/0xe0 returned 0 after 692 usecs
[42949373.500000] calling  slab_proc_init+0x0/0x40 @ 1
[42949373.500000] initcall slab_proc_init+0x0/0x40 returned 0 after 88 usecs
[42949373.500000] calling  cpucache_init+0x0/0x1c @ 1
[42949373.500000] initcall cpucache_init+0x0/0x1c returned 0 after 46 usecs
[42949373.500000] calling  fasync_init+0x0/0x48 @ 1
[42949373.500000] initcall fasync_init+0x0/0x48 returned 0 after 247 usecs
[42949373.500000] calling  proc_filesystems_init+0x0/0x40 @ 1
[42949373.500000] initcall proc_filesystems_init+0x0/0x40 returned 0 after 84 usecs
[42949373.500000] calling  inotify_setup+0x0/0x20 @ 1
[42949373.500000] initcall inotify_setup+0x0/0x20 returned 0 after 11 usecs
[42949373.500000] calling  inotify_user_setup+0x0/0xc4 @ 1
[42949373.500000] initcall inotify_user_setup+0x0/0xc4 returned 0 after 439 usecs
[42949373.500000] calling  aio_setup+0x0/0x8c @ 1
[42949373.510000] initcall aio_setup+0x0/0x8c returned 0 after 1261 usecs
[42949373.510000] calling  proc_locks_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_locks_init+0x0/0x40 returned 0 after 108 usecs
[42949373.510000] calling  dnotify_init+0x0/0x48 @ 1
[42949373.510000] initcall dnotify_init+0x0/0x48 returned 0 after 208 usecs
[42949373.510000] calling  proc_cmdline_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_cmdline_init+0x0/0x40 returned 0 after 151 usecs
[42949373.510000] calling  proc_cpuinfo_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_cpuinfo_init+0x0/0x40 returned 0 after 66 usecs
[42949373.510000] calling  proc_devices_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_devices_init+0x0/0x40 returned 0 after 57 usecs
[42949373.510000] calling  proc_interrupts_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_interrupts_init+0x0/0x40 returned 0 after 55 usecs
[42949373.510000] calling  proc_loadavg_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_loadavg_init+0x0/0x40 returned 0 after 59 usecs
[42949373.510000] calling  proc_meminfo_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_meminfo_init+0x0/0x40 returned 0 after 54 usecs
[42949373.510000] calling  proc_stat_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_stat_init+0x0/0x40 returned 0 after 57 usecs
[42949373.510000] calling  proc_uptime_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_uptime_init+0x0/0x40 returned 0 after 59 usecs
[42949373.510000] calling  proc_version_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_version_init+0x0/0x40 returned 0 after 58 usecs
[42949373.510000] calling  proc_kmsg_init+0x0/0x40 @ 1
[42949373.510000] initcall proc_kmsg_init+0x0/0x40 returned 0 after 55 usecs
[42949373.510000] calling  proc_page_init+0x0/0x60 @ 1
[42949373.510000] initcall proc_page_init+0x0/0x60 returned 0 after 86 usecs
[42949373.510000] calling  init_devpts_fs+0x0/0x48 @ 1
[42949373.510000] initcall init_devpts_fs+0x0/0x48 returned 0 after 242 usecs
[42949373.510000] calling  init_ramfs_fs+0x0/0x1c @ 1
[42949373.510000] initcall init_ramfs_fs+0x0/0x1c returned 0 after 30 usecs
[42949373.510000] calling  init_nfs_fs+0x0/0x150 @ 1
[42949373.520000] initcall init_nfs_fs+0x0/0x150 returned 0 after 2263 usecs
[42949373.520000] calling  init_nlm+0x0/0x34 @ 1
[42949373.520000] initcall init_nlm+0x0/0x34 returned 0 after 51 usecs
[42949373.520000] calling  init_jffs2_fs+0x0/0xe0 @ 1
[42949373.520000] JFFS2 version 2.2. (NAND) (SUMMARY)  (c) 2001-2006 Red Hat, Inc.
[42949373.520000] initcall init_jffs2_fs+0x0/0xe0 returned 0 after 2921 usecs
[42949373.520000] calling  ipc_init+0x0/0x2c @ 1
[42949373.520000] msgmni has been set to 57
[42949373.520000] initcall ipc_init+0x0/0x2c returned 0 after 334 usecs
[42949373.520000] calling  ipc_sysctl_init+0x0/0x20 @ 1
[42949373.520000] initcall ipc_sysctl_init+0x0/0x20 returned 0 after 58 usecs
[42949373.520000] calling  crypto_algapi_init+0x0/0x18 @ 1
[42949373.520000] initcall crypto_algapi_init+0x0/0x18 returned 0 after 93 usecs
[42949373.520000] calling  chainiv_module_init+0x0/0x1c @ 1
[42949373.520000] initcall chainiv_module_init+0x0/0x1c returned 0 after 37 usecs
[42949373.520000] calling  eseqiv_module_init+0x0/0x1c @ 1
[42949373.520000] initcall eseqiv_module_init+0x0/0x1c returned 0 after 20 usecs
[42949373.520000] calling  md5_mod_init+0x0/0x1c @ 1
[42949373.520000] initcall md5_mod_init+0x0/0x1c returned 0 after 1391 usecs
[42949373.520000] calling  crypto_ecb_module_init+0x0/0x1c @ 1
[42949373.520000] initcall crypto_ecb_module_init+0x0/0x1c returned 0 after 36 usecs
[42949373.520000] calling  crypto_cbc_module_init+0x0/0x1c @ 1
[42949373.520000] initcall crypto_cbc_module_init+0x0/0x1c returned 0 after 25 usecs
[42949373.520000] calling  des_generic_mod_init+0x0/0x44 @ 1
[42949373.530000] initcall des_generic_mod_init+0x0/0x44 returned 0 after 3270 usecs
[42949373.530000] calling  aes_init+0x0/0x370 @ 1
[42949373.530000] initcall aes_init+0x0/0x370 returned 0 after 2464 usecs
[42949373.530000] calling  arc4_init+0x0/0x1c @ 1
[42949373.530000] initcall arc4_init+0x0/0x1c returned 0 after 1786 usecs
[42949373.530000] calling  krng_mod_init+0x0/0x1c @ 1
[42949373.530000] alg: No test for stdrng (krng)
[42949373.530000] initcall krng_mod_init+0x0/0x1c returned 0 after 1067 usecs
[42949373.530000] calling  proc_genhd_init+0x0/0x60 @ 1
[42949373.540000] initcall proc_genhd_init+0x0/0x60 returned 0 after 356 usecs
[42949373.540000] calling  noop_init+0x0/0x20 @ 1
[42949373.540000] io scheduler noop registered (default)
[42949373.540000] initcall noop_init+0x0/0x20 returned 0 after 129 usecs
[42949373.540000] calling  rand_initialize+0x0/0x3c @ 1
[42949373.540000] initcall rand_initialize+0x0/0x3c returned 0 after 504 usecs
[42949373.540000] calling  tty_init+0x0/0x110 @ 1
[42949373.670000] initcall tty_init+0x0/0x110 returned 0 after 131121 usecs
[42949373.670000] calling  pty_init+0x0/0x2b8 @ 1
[42949373.670000] initcall pty_init+0x0/0x2b8 returned 0 after 2408 usecs
[42949373.670000] calling  serial8250_init+0x0/0x114 @ 1
[42949373.670000] Serial: 8250/16550 driver1 ports, IRQ sharing disabled
[42949373.680000] serial8250: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
[42949373.680000] DBG::bus: 'platform': add driver serial8250
[42949373.680000] serial8250.0: ttyS0 at MMIO 0x15001000 (irq = 10) is a NXP16750
[42949373.690000] initcall serial8250_init+0x0/0x114 returned 0 after 12088 usecs
[42949373.690000] calling  net_olddevs_init+0x0/0xc8 @ 1
[42949373.690000] initcall net_olddevs_init+0x0/0xc8 returned 0 after 114 usecs
[42949373.690000] calling  init_mtd+0x0/0x44 @ 1
[42949373.690000] initcall init_mtd+0x0/0x44 returned 0 after 137 usecs
[42949373.690000] calling  init_mtdchar+0x0/0x98 @ 1
[42949373.690000] initcall init_mtdchar+0x0/0x98 returned 0 after 1392 usecs
[42949373.690000] calling  init_mtdblock+0x0/0x1c @ 1
[42949373.690000] initcall init_mtdblock+0x0/0x1c returned 0 after 815 usecs
[42949373.690000] calling  nand_base_init+0x0/0x14 @ 1
[42949373.690000] initcall nand_base_init+0x0/0x14 returned 0 after 13 usecs
[42949373.690000] calling  lpc313x_nand_init+0x0/0x1c @ 1
[42949373.690000] DBG::bus: 'platform': add driver lpc313x_nand
[42949373.690000] NAND device: Manufacturer ID: 0x20, Chip ID: 0x73 (ST Micro NAND 16MiB 3,3V 8-bit)
[42949373.690000] Bad block table found at page 32736, version 0x00
[42949373.690000] Bad block table found at page 32704, version 0x00
[42949373.690000] nand_read_bbt: Bad block at 0x00000000
[42949373.690000] nand_read_bbt: Bad block at 0x00000000
[42949373.700000] Creating 10 MTD partitions on "NAND 16MiB 3,3V 8-bit":
[42949373.700000] 0x00004000-0x00018000 : "apex1"
[42949373.700000] 0x00018000-0x0002c000 : "apex2"
[42949373.710000] 0x0002c000-0x00030000 : "apex-env"
[42949373.720000] 0x00030000-0x00050000 : "sysconfig"
[42949373.720000] 0x00050000-0x001cc000 : "kernel1"
[42949373.730000] 0x001cc000-0x00348000 : "kernel2"
[42949373.740000] 0x00348000-0x00368000 : "configfs"
[42949373.750000] 0x00368000-0x00e58000 : "rootfs"
[42949373.760000] 0x00e58000-0x00fe8000 : "safefs"
[42949373.760000] 0x00fe8000-0x00ff0000 : "log"
[42949373.770000] initcall lpc313x_nand_init+0x0/0x1c returned 0 after 78275 usecs
[42949373.770000] calling  mousedev_init+0x0/0x68 @ 1
[42949373.770000] mice: PS/2 mouse device common for all mice
[42949373.770000] initcall mousedev_init+0x0/0x68 returned 0 after 2127 usecs
[42949373.780000] calling  lpc313x_wdt_init+0x0/0x1c @ 1
[42949373.780000] DBG::bus: 'platform': add driver lpc313x-wdt
[42949373.780000] CGU: Get clock id:34 freq:6000000
[42949373.780000] lpc313x-wdt lpc313x-wdt: Watchdog device driver initialized.
[42949373.780000] initcall lpc313x_wdt_init+0x0/0x1c returned 0 after 4356 usecs
[42949373.780000] calling  init_ladder+0x0/0x1c @ 1
[42949373.780000] cpuidle: using governor ladder
[42949373.780000] initcall init_ladder+0x0/0x1c returned 0 after 124 usecs
[42949373.780000] calling  sysctl_core_init+0x0/0x30 @ 1
[42949373.780000] initcall sysctl_core_init+0x0/0x30 returned 0 after 166 usecs
[42949373.780000] calling  sysctl_ipv4_init+0x0/0x4c @ 1
[42949373.780000] initcall sysctl_ipv4_init+0x0/0x4c returned 0 after 230 usecs
[42949373.780000] calling  cubictcp_register+0x0/0x6c @ 1
[42949373.780000] TCP cubic registered
[42949373.780000] initcall cubictcp_register+0x0/0x6c returned 0 after 102 usecs
[42949373.780000] calling  packet_init+0x0/0x50 @ 1
[42949373.780000] NET: Registered protocol family 17
[42949373.780000] initcall packet_init+0x0/0x50 returned 0 after 248 usecs
[42949373.780000] calling  init_sunrpc+0x0/0x60 @ 1
[42949373.780000] RPC: Registered udp transport module.
[42949373.790000] RPC: Registered tcp transport module.
[42949373.790000] initcall init_sunrpc+0x0/0x60 returned 0 after 2596 usecs
[42949373.790000] calling  init_rpcsec_gss+0x0/0x3c @ 1
[42949373.790000] initcall init_rpcsec_gss+0x0/0x3c returned 0 after 212 usecs
[42949373.790000] calling  init_kerberos_module+0x0/0x34 @ 1
[42949373.790000] initcall init_kerberos_module+0x0/0x34 returned 0 after 69 usecs
[42949373.790000] calling  rfkill_handler_init+0x0/0x48 @ 1
[42949373.790000] initcall rfkill_handler_init+0x0/0x48 returned 0 after 24 usecs
[42949373.790000] calling  init_oops_id+0x0/0x40 @ 1
[42949373.790000] initcall init_oops_id+0x0/0x40 returned 0 after 108 usecs
[42949373.790000] calling  disable_boot_consoles+0x0/0x50 @ 1
[42949373.790000] initcall disable_boot_consoles+0x0/0x50 returned 0 after 12 usecs
[42949373.790000] calling  pm_qos_power_init+0x0/0x6c @ 1
[42949373.790000] initcall pm_qos_power_init+0x0/0x6c returned 0 after 5821 usecs
[42949373.790000] calling  random32_reseed+0x0/0x6c @ 1
[42949373.800000] initcall random32_reseed+0x0/0x6c returned 0 after 312 usecs
[42949373.800000] calling  seqgen_init+0x0/0x1c @ 1
[42949373.800000] initcall seqgen_init+0x0/0x1c returned 0 after 281 usecs
[42949373.800000] calling  tcp_congestion_default+0x0/0x1c @ 1
[42949373.800000] initcall tcp_congestion_default+0x0/0x1c returned 0 after 22 usecs
[42949373.800000] calling  ip_auto_config+0x0/0xe6c @ 1
[42949373.800000] initcall ip_auto_config+0x0/0xe6c returned 0 after 113 usecs
[42949374.340000] jffs2_scan_inode_node(): CRC failed on node at 0x008b4dc8: Read 0xffffffff, calculated 0xc9c59f44
[42949374.430000] VFS: Mounted root (jffs2 filesystem) readonly.
[42949374.430000] Freeing init memory: 92K
[42949376.730000] CGU: Get clock id:34 freq:6000000
[42949376.730000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949377.930000] jffs2_scan_inode_node(): CRC failed on node at 0x0001c5f4: Read 0xffffffff, calculated 0x1490a44b
[42949377.940000] CGU: Get clock id:34 freq:6000000
[42949377.940000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.130000] Empty flash at 0x0014e310 ends at 0x0014e400
[42949378.160000] CGU: Get clock id:34 freq:6000000
[42949378.160000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.580000] CGU: Get clock id:34 freq:6000000
[42949378.580000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.610000] CGU: Get clock id:34 freq:6000000
[42949378.610000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.670000] calling  on_load+0x0/0xc4 [bpsled] @ 292
[42949378.670000] initcall on_load+0x0/0xc4 [bpsled] returned -16 after 24 usecs
[42949378.670000] initcall on_load+0x0/0xc4 [bpsled] returned with error code -16
[42949378.730000] CGU: Get clock id:34 freq:6000000
[42949378.730000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.780000] CGU: Get clock id:34 freq:6000000
[42949378.780000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949378.790000] CGU: Get clock id:34 freq:6000000
[42949378.790000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949379.260000] calling  udc_init+0x0/0x40 [nxp_usb2_udc] @ 302
[42949379.260000] Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
[42949379.260000] DBG::bus: 'platform': add driver fsl-usb2-udc
[42949379.270000] initcall udc_init+0x0/0x40 [nxp_usb2_udc] returned 0 after 8192 usecs
[42949379.780000] calling  init+0x0/0xc4 [g_serial] @ 302
[42949379.790000] g_serial gadget: Gadget Serial v2.4
[42949379.790000] g_serial gadget: g_serial ready
[42949379.790000] fsl-usb2-udc: bind to driver g_serial
[42949379.790000] initcall init+0x0/0xc4 [g_serial] returned 0 after 5769 usecs
[42949379.850000] CGU: Get clock id:34 freq:6000000
[42949379.850000] lpc313x-wdt lpc313x-wdt: Watchdog timer closed unexpectedly
[42949380.070000] g_serial gadget: high speed config #2: CDC ACM config
[42949384.520000] CGU: Get clock id:34 freq:6000000
[42949469.800000] calling  lpc313x_mci_init+0x0/0x24 [lpc313x_mmc] @ 329
[42949469.800000] DBG::bus: 'platform': add driver lpc313x_mmc
[42949469.800000] CGU: Get clock id:20 freq:45000000
[42949469.800000] Powering off wl12xx<6>Powering off wl12xx<6>Powering down MMC Slot<6>Powering on wl12xx<6>lpc313x_mmc lpc313x_mmc.0: LPC313x MMC controller at irq 26
[42949469.830000] initcall lpc313x_mci_init+0x0/0x24 [lpc313x_mmc] returned 0 after 28094 usecs
[42949469.930000] Powering up MMC Slot<4>mmc0: card claims to support voltages below the defined range. These will be ignored.
[42949469.990000] mmc0: queuing CIS tuple 0x91 length 3
[42949469.990000] mmc_attach_sdio the value of funcs=0x2
[42949469.990000] mmc_attach_sdio the value of funcs=0x2
[42949469.990000] mmc0: new SDIO card at address 0001
[42949470.020000] Powering on wl12xxcalling  __init_compat+0x0/0x40 [compat] @ 338
[42949492.670000] Compat-wireless backport release: compat-wireless-3.5-rc5-1
[42949492.670000] Backport based on linux-stable.git v3.5-rc5
[42949492.670000] compat.git: linux-stable.git
[42949492.670000] initcall __init_compat+0x0/0x40 [compat] returned 0 after 2313 usecs
[42949495.630000] calling  __init_compat+0x0/0x94 [rfkill_backport] @ 343
[42949495.650000] initcall __init_compat+0x0/0x94 [rfkill_backport] returned 0 after 22300 usecs
[42949500.410000] calling  __init_compat+0x0/0xd8 [cfg80211] @ 347
[42949500.610000] cfg80211: Calling CRDA to update world regulatory domain
[42949500.620000] initcall __init_compat+0x0/0xd8 [cfg80211] returned 0 after 204688 usecs
[42949505.750000] calling  __init_compat+0x0/0x54 [mac80211] @ 353
[42949505.760000] initcall __init_compat+0x0/0x54 [mac80211] returned 0 after 4565 usecs
[42949510.640000] calling  __init_compat+0x0/0x28 [compat_firmware_class] @ 355
[42949510.650000] initcall __init_compat+0x0/0x28 [compat_firmware_class] returned 0 after 11131 usecs
[42949518.600000] calling  __init_compat+0x0/0x20 [wl12xx] @ 360
[42949518.600000] DBG::bus: 'platform': add driver wl12xx
[42949518.620000] initcall __init_compat+0x0/0x20 [wl12xx] returned 0 after 10430 usecs
[42949523.250000] calling  __init_compat+0x0/0x20 [wlcore_sdio] @ 363
[42949523.250000] DBG::bus: 'sdio': add driver wl1271_sdio
[42949523.300000] Powering on wl12xx<6>Powering up MMC Slot<6>Powering off wl12xx<6>Powering down MMC Slot<6>wl12xx: loaded
[42949523.680000] initcall __init_compat+0x0/0x20 [wlcore_sdio] returned 0 after 425374 usecs
[42949560.670000] Powering on wl12xx<6>Powering up MMC Slot<6>wl12xx: firmware booted (Rev 6.3.7.0.105)
[42949631.870000] wlan0: authenticate with c166962c
[42949631.950000] wlan0: send auth to c166962c (try 1/3)
[42949631.950000] wlan0: authenticated
[42949632.010000] wlan0: associate with c166962c (try 1/3)
[42949632.020000] wlan0: RX AssocResp from c1669a1a (capab=0x431 status=0 aid=1)
[42949632.020000] wlan0: associated
[42949637.640000] wl12xx: Association completed.
[42949668.960000] wl12xx: Reading FW panic log
[42949668.960000] wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.7.0.105 pc: 0x0
[42949668.960000] wl12xx: down
[42949668.960000] Powering off wl12xx<6>Powering down MMC Slot<6>ieee80211 phy0: Hardware restart was requested
[42949669.000000] Powering on wl12xx<6>Powering up MMC Slot<1>Unable to handle kernel paging request at virtual address c2a2f000
[42949669.510000] pgd = c0004000
[42949669.520000] [c2a2f000] *pgd=316bf011, *pte=00000000, *ppte=00000000
[42949669.560000] Internal error: Oops: 7 [#1]
[42949669.560000] Modules linked in: wlcore_sdio wl12xx wlcore compat_firmware_class mac80211 cfg80211 rfkill_backport compat lpc313x_mmc g_serial nxp_usb2_udc
[42949669.560000] CPU: 0    Not tainted  (2.6.28.2 #1)
[42949669.560000] PC is at memcpy+0x48/0x330
[42949669.560000] LR is at 0x6e05524b
[42949669.560000] pc : [<c0139c08>]    lr : [<6e05524b>]    psr: 60000013
[42949669.560000] sp : c14b9e0c  ip : 00200080  fp : c14b9e94
[42949669.560000] r10: c2a2b00c  r9 : 00000006  r8 : 2bd00006
[42949669.560000] r7 : 0714524b  r6 : 00200080  r5 : 4bd00006  r4 : 041e8401
[42949669.560000] r3 : 88880888  r2 : ffffffa0  r1 : c2a2efec  r0 : c1657fe0
[42949669.560000] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[42949669.560000] Control: 0005317f  Table: 316a4000  DAC: 00000017
[42949669.560000] Process events/0 (pid: 340, stack limit = 0xc14b8268)
[42949669.560000] Stack: (0xc14b9e0c to 0xc14ba000)
[42949669.560000] 9e00:                            0002b318 00014000 00000005 c1654000 c1654000
[42949669.560000] 9e20: c1f217a0 bf0c2184 00000000 c00325ec c14b9e54 c14b9e48 000277c0 c2a1700c
[42949669.560000] 9e40: 00000000 0000000a 000177c0 00010000 00008800 00300000 00000000 00000000
[42949669.560000] 9e60: 00000000 00000000 c1f217a0 c1f217a0 c1f21b04 00305618 00000000 ffffff08
[42949669.560000] 9e80: 00000002 c1f219ac c14b9ec4 c14b9e98 bf0dcec8 bf0c202c 00000000 bf0ac2a8
[42949669.560000] 9ea0: c1efb9e8 c1efb8f0 c1f217a0 c1efb860 c1f217d4 c1efb8f4 c14b9f1c c14b9ec8
[42949669.560000] 9ec0: bf0b988c bf0dc928 c001fea0 c1f217e0 00000000 c1f200e0 00000002 c1efb860
[42949669.560000] 9ee0: 00000001 00000002 c1efb860 00000001 bf0b5298 c1f20ae0 c1efb3a0 c1f21384
[42949669.560000] 9f00: 00000000 c1f211dc 00000000 00000000 c14b9f5c c14b9f20 bf086c78 bf0b94d0
[42949669.560000] 9f20: c020661c bf06e590 c14b9f5c c14b9f38 bf06e590 c1f20ae0 c1f211fc c1f21384
[42949669.560000] 9f40: 00000000 00000000 00000000 00000000 c14b9f7c c14b9f60 bf069418 bf086aac
[42949669.560000] 9f60: c1520820 c14b8000 bf06939c 00000000 c14b9f9c c14b9f80 c00487a4 bf0693ac
[42949669.560000] 9f80: c1520820 c14b8000 c14b9fa4 c1520828 c14b9fd4 c14b9fa0 c0048f18 c00486f0
[42949669.560000] 9fa0: 00000000 00000000 c1eed360 c004cdc4 c14b9fb0 c14b9fb0 c14b8000 c0048e0c
[42949669.560000] 9fc0: c1520820 00000000 c14b9ff4 c14b9fd8 c004c888 c0048e1c 00000000 00000000
[42949669.560000] 9fe0: 00000000 00000000 00000000 c14b9ff8 c003ab6c c004c838 00000000 fff10004
[42949669.560000] Backtrace:
[42949669.560000] [<bf0c201c>] (wlcore_boot_upload_firmware+0x0/0x244 [wlcore]) from [<bf0dcec8>] (wl12xx_boot+0x5b0/0x738 [wl12xx])
[42949669.560000] [<bf0dc918>] (wl12xx_boot+0x0/0x738 [wl12xx]) from [<bf0b988c>] (wl1271_op_add_interface+0x3cc/0x5a0 [wlcore])
[42949669.560000]  r8:c1efb8f4 r7:c1f217d4 r6:c1efb860 r5:c1f217a0 r4:c1efb8f0
[42949669.560000] [<bf0b94c0>] (wl1271_op_add_interface+0x0/0x5a0 [wlcore]) from [<bf086c78>] (ieee80211_reconfig+0x1dc/0x758 [mac80211])
[42949669.560000] [<bf086a9c>] (ieee80211_reconfig+0x0/0x758 [mac80211]) from [<bf069418>] (ieee80211_restart_work+0x7c/0x94 [mac80211])
[42949669.560000] [<bf06939c>] (ieee80211_restart_work+0x0/0x94 [mac80211]) from [<c00487a4>] (run_workqueue+0xc4/0x14c)
[42949669.560000]  r7:00000000 r6:bf06939c r5:c14b8000 r4:c1520820
[42949669.560000] [<c00486e0>] (run_workqueue+0x0/0x14c) from [<c0048f18>] (worker_thread+0x10c/0x120)
[42949669.560000]  r7:c1520828 r6:c14b9fa4 r5:c14b8000 r4:c1520820
[42949669.560000] [<c0048e0c>] (worker_thread+0x0/0x120) from [<c004c888>] (kthread+0x60/0x9c)
[42949669.560000]  r7:00000000 r6:c1520820 r5:c0048e0c r4:c14b8000
[42949669.560000] [<c004c828>] (kthread+0x0/0x9c) from [<c003ab6c>] (do_exit+0x0/0x734)
[42949669.560000]  r7:00000000 r6:00000000 r5:00000000 r4:00000000
[42949669.560000] Code: ba000002 f5d1f03c f5d1f05c f5d1f07c (e8b151f8)
[42949669.570000] ---[ end trace 4d153cca98b32114 ]---
/wlan #
/wlan # dmesg[J
/wlan # ./wpa_cli -i wlan1 p2p_group_add freq=2412[J
/wlan # dmesg[J
/wlan # ./wpa_supplicant -Dnl80211 -iwlan1 -c /wlan/p2p.conf &[J
/wlan # dmesg[J
/wlan # cat p2p.conf [J
/wlan # ./wpa_cli status[J
/wlan # ./wpa_supplicant -d -Dnl80211 -c/wlan/wpa_supplicant.conf -iwlan0 -B[J
/wlan # cat wpa_supplicant.conf [J
/wlan # ifconfig wlan1 hw ether 08:00:28:44:56:83[J
/wlan # iw phy0 interface add wlan1 type managed[J
/wlan # ifconfig wlan
The system crashes in this case. Only wlan0(Station Mode) was successfully started and Associated.

When tried with Single role firmware version  6.3.9.0.105 and Multirole firmware version X.5.7.0.30, I get the error "wl12xx: ERROR beacon info change failed: -22" while connecting wlan1 interface.
With any single role firmware version greater than 6.3.9.0.105, the wlan0 interface itself(Station Mode) fails. And wlan1(P2P GO) can be started with error " wl12xx: ERROR beacon info change failed: -22".

Kindly suggest any items I am missing. Or suggest any patches needs to be applied to Compat Wireless to match the latest firmware binaries

Thanks
Girish



-----Original Message-----
From: anamtsov@gmail.com [mailto:anamtsov@gmail.com] On Behalf Of Arik Nemtsov
Sent: Wednesday, August 29, 2012 8:32 PM
To: Girish Bn
Cc: linux-wireless@vger.kernel.org
Subject: Re: Crash with Wl12xx driver while Concurrent operation(P2P and Wi-Fi legacy)

On Tue, Aug 28, 2012 at 5:45 PM, Girish Bn <Girish.BN@lnties.com> wrote:
> [  725.900000] [<bf0b8c24>] (wl1271_op_bss_info_changed+0x0/0xc24
> [wlcore]) from [<bf06a56c>]
> (ieee80211_bss_info_change_notify+0x1dc/0x200 [mac80211]) [
> 725.900000] [<bf06a390>] (ieee80211_bss_info_change_notify+0x0/0x200
> [mac80211]) from [<bf089b98>] (ieee80211_reconfig+0x584/0x9a0
> [mac80211]) [  725.900000]  r7:c161a888 r6:c15f07d0 r5:c161a3a0
> r4:c159cb00 [  725.900000] [<bf089614>] (ieee80211_reconfig+0x0/0x9a0
> [mac80211]) from [<bf06b460>] (ieee80211_restart_work+0x7c/0x94
> [mac80211]) [  725.910000] [<bf06b3e4>]
> (ieee80211_restart_work+0x0/0x94 [mac80211]) from [<c00487a4>]
> (run_workqueue+0xc4/0x14c) [  725.910000]  r7:00000000 r6:bf06b3e4
> r5:c14d2000 r4:c1fef280 [  725.910000] [<c00486e0>]
> (run_workqueue+0x0/0x14c) from [<c0048f18>]
> (worker_thread+0x10c/0x120) [  725.910000]  r7:c1fef288 r6:c14d3fa4
> r5:c14d2000 r4:c1fef280 [  725.910000] [<c0048e0c>] (worker_thread+0x0/0x120) from [<c004c888>] (kthread+0x60/0x9c) [  725.910000]  r7:00000000 r6:c1fef280 r5:c0048e0c r4:c14d2000 [  725.910000] [<c004c828>] (kthread+0x0/0x9c) from [<c003ab6c>] (do_exit+0x0/0x734) [  725.910000]  r7:00000000 r6:00000000 r5:00000000 r4:00000000 [  725.910000] ---[ end trace 1cd0b968bc5f5a81 ]--- [  725.910000] wl12xx: ERROR AP rate policy change failed -22 Can you please let me know the reason behind crash? Also confirm the driver and firmware version being used is right or not?

Seems you have problems since you're using p2p_go in multiple interface mode (p2p-wlan0-0). Try removing "driver_param=use_p2p_group_interface=1" from your wpa_s.conf and apply this patch:
https://github.com/TI-OpenLink/hostap/commit/b0f48bcc8a61cf620412202166d0d6947f3ba26e
Larsen & Toubro Limited

www.larsentoubro.com

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
