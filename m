Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:4824 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456AbYGQQFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 12:05:48 -0400
Received: by ti-out-0910.google.com with SMTP id b6so3396268tic.23
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 09:05:46 -0700 (PDT)
Message-ID: <da2e1ddd0807170905j5121737bia15429aee0f7ffd6@mail.gmail.com> (sfid-20080717_180552_377776_374E3F3F)
Date: Fri, 18 Jul 2008 01:05:46 +0900
From: "=?EUC-KR?B?wNO/tbrz?=" <ybim@mmlab.snu.ac.kr>
To: linux-wireless@vger.kernel.org
Subject: question about open11s installation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I installed open11s through wireless-testing and also through compat-wireless.
I used b43 chipset wlan cards(Asus WL-138G V2 PCI card) which are
known to work with open11s.
I could make the mesh interface, and see neighbor nodes by 'iw dev
mesh station dump'.
But its output is slightly different from open11s manual like this.

root@ybim-desktop:~# iw dev mesh station dump
Station 00:1b:fc:3e:52:44 (on mesh)
        inactive time:  -66040 ms
        rx bytes:       0
        tx bytes:       0

And what is serious is that when I execute the command 'iw dev mesh mpath dump'.
I lose my ssh connection, and the system gets strange.
The symptom is the same in both cases, wireless-testing and compat-wireless.
I got below messages through dmesg when I used wireless-testing.

Actually, I used following commands to create the interface.

export MESH_ID=1023
iw dev wlan2 interface add mesh type mp mesh_id $MESH_ID
ifconfig mesh down
iwconfig mesh mode ad-hoc essid open11s channel 3
ifconfig mesh up
ifconfig mesh 192.168.4.2

But, someone said to me that to use the command 'iwconfig mesh mode
ad-hoc essid open11s channel 3' is not
good way because it can make a problem with mesh interface mode.
So I changed the commands like this

export MESH_ID=1023
iw dev wlan2 interface add mesh type mp mesh_id $MESH_ID
iwconfig mesh channel 3
ifconfig mesh 192.168.4.2

Then I couldn't even make any connection
between nodes, that is, I could not find any node when I typed 'iw dev
mesh station dump'

I think I correctly installed following open11s manual, and the hardware is ok.
But I cannot figure out the reason. Any ideas?
Thank you.

[   16.911652] intel_rng: FWH not detected
[   16.984735] input: PC Speaker as /class/input/input4
[   18.045924] b43-phy0: Broadcom 4318 WLAN found
[   18.113110] phy0: Selected rate control algorithm 'pid'
[   18.192642] Broadcom 43xx driver loaded [ Features: PLR, Firmware-ID: FW13 ]
[   18.432062] input: ImPS/2 Generic Wheel Mouse as /class/input/input5
[   18.542015] parport_pc 00:06: reported by Plug and Play ACPI
[   18.542129] parport0: PC-style at 0x378 (0x778), irq 7, dma 3
[PCSPP,TRISTATE,COMPAT,EPP,
ECP,DMA]
[   19.261264] lp0: using parport0 (interrupt-driven).
[   19.326458] Adding 1510068k swap on /dev/sda5.  Priority:-1
extents:1 across:1510068k
[   19.891677] EXT3 FS on sda1, internal journal
[   20.924007] ip_tables: (C) 2000-2006 Netfilter Core Team
[   21.280007] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
[   22.217466] warning: `avahi-daemon' uses 32-bit capabilities
(legacy support in use)
[   22.264009] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   22.264009] apm: overridden by ACPI.
[   22.393700] ppdev: user-space parallel port driver
[   23.241107] Bluetooth: Core ver 2.11
[   23.242939] NET: Registered protocol family 31
[   23.242947] Bluetooth: HCI device and connection manager initialized
[   23.242952] Bluetooth: HCI socket layer initialized
[   23.276796] Bluetooth: L2CAP ver 2.9
[   23.276804] Bluetooth: L2CAP socket layer initialized
[   23.350706] Bluetooth: RFCOMM socket layer initialized
[   23.350726] Bluetooth: RFCOMM TTY layer initialized
[   23.350729] Bluetooth: RFCOMM ver 1.8
[   24.996012] eth0: no IPv6 routers present
[   25.087154] [drm] Initialized drm 1.1.0 20060810
[   25.126909] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   25.126923] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   25.127504] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   26.972003] [drm] Setting GART location based on new memory map
[   26.972003] [drm] Loading R300 Microcode
[   26.972003] [drm] Num pipes: 1
[   26.972003] [drm] writeback test succeeded in 1 usecs
[   83.974246] input: b43-phy0 as /class/input/input6
[   84.064036] firmware: requesting b43/ucode5.fw
[   84.076352] firmware: requesting b43/pcm5.fw
[   84.100992] firmware: requesting b43/b0g0initvals5.fw
[   84.105021] firmware: requesting b43/b0g0bsinitvals5.fw
[   84.224029] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[   84.341817] Registered led device: b43-phy0::tx
[   84.342096] Registered led device: b43-phy0::rx
[   84.342295] Registered led device: b43-phy0::assoc
[   84.342525] Registered led device: b43-phy0::radio
[   91.948023] mesh: Creating new IBSS network, BSSID 7e:ef:fa:4d:f1:1c
[   94.840007] mesh: no IPv6 routers present
[  121.948010] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  152.724018] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  183.500031] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  184.288045] mesh: Selected IBSS BSSID c2:ca:3d:a0:dd:82 based on
configured SSID
[  214.288020] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  276.676290] ------------[ cut here ]------------
[  276.676290] kernel BUG at net/mac80211/ieee80211_i.h:757!
[  276.676290] invalid opcode: 0000 [#1] SMP
[  276.676290] Modules linked in: rfkill_input radeon drm rfcomm l2cap
bluetooth ppdev speedstep_lib cpufreq_stats cpufreq_userspace
cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative
video output container sbs sbshc battery iptable_filter ip_tables
x_tables ac lp arc4 ecb crypto_blkcipher b43 rfkill mac80211
parport_pc parport cfg80211 led_class psmouse input_polldev serio_raw
pcspkr iTCO_wdt iTCO_vendor_support sky2 button intel_agp agpgart
shpchp pci_hotplug ipv6 evdev ext3 jbd mbcache sd_mod sg sr_mod cdrom
pata_acpi ata_generic 8139too ata_piix libata scsi_mod dock 8139cp mii
ssb ehci_hcd uhci_hcd usbcore thermal processor fan thermal_sys fuse
[  276.676290]
[  276.676290] Pid: 5495, comm: iw Not tainted (2.6.26-custom-wl #1)
[  276.676290] EIP: 0060:[<e09d6e0c>] EFLAGS: 00010246 CPU: 0
[  276.676290] EIP is at ieee80211_dump_mpath+0x6c/0x80 [mac80211]
[  276.676290] EAX: df893040 EBX: 00000000 ECX: 00000000 EDX: df9c6800
[  276.676290] ESI: df9c6d00 EDI: d85f0040 EBP: 00000000 ESP: d801bbe4
[  276.676290]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  276.676290] Process iw (pid: 5495, ti=d801a000 task=dfa6d310
task.ti=d801a000)
[  276.676290] Stack: e09f7f60 e099032f d801bc46 d801bc40 d801bc24
e0993a60 d7c4c1a4 df893040
[  276.676290]        d85f9f00 df893020 df893030 00000001 00000003
00000000 00000000 df893000
[  276.676290]        d85f9f00 00000f00 c0412400 000000d0 c0291675
00000000 d5429e00 00000f00
[  276.676290] Call Trace:
[  276.676290]  [<e099032f>] nl80211_dump_mpath+0x17f/0x200 [cfg80211]
[  276.676290]  [<c0291675>] __alloc_skb+0x55/0x120
[  276.676290]  [<c02ada83>] netlink_dump+0x53/0x1b0
[  276.676290]  [<c02afcc8>] netlink_dump_start+0x128/0x150
[  276.676290]  [<c02b1741>] genl_rcv_msg+0xc1/0x1b0
[  276.676290]  [<e09901b0>] nl80211_dump_mpath+0x0/0x200 [cfg80211]
[  276.676290]  [<c020ed71>] vsnprintf+0x2d1/0x5a0
[  276.676290]  [<c02b1680>] genl_rcv_msg+0x0/0x1b0
[  276.676290]  [<c02aeaf7>] netlink_rcv_skb+0x67/0x90
[  276.676290]  [<c02b0cd9>] genl_rcv+0x19/0x30
[  276.676290]  [<c02ae8c8>] netlink_unicast+0x228/0x260
[  276.676290]  [<c020fdae>] copy_from_user+0x2e/0x70
[  276.676290]  [<c02af0d5>] netlink_sendmsg+0x215/0x2c0
[  276.676290]  [<c028ac01>] sock_sendmsg+0x111/0x130
[  276.676290]  [<c01397c0>] autoremove_wake_function+0x0/0x40
[  276.676290]  [<c019eeb8>] mntput_no_expire+0x18/0x100
[  276.676290]  [<c019a25a>] __d_lookup+0x8a/0x100
[  276.676290]  [<c01bf348>] proc_alloc_inode+0x38/0x60
[  276.676290]  [<c019c334>] iget_locked+0x74/0x140
[  276.676290]  [<c020fdae>] copy_from_user+0x2e/0x70
[  276.676290]  [<c020fdae>] copy_from_user+0x2e/0x70
[  276.676290]  [<c028ad79>] sys_sendmsg+0x159/0x270
[  276.676290]  [<c019a7b5>] dput+0x65/0xe0
[  276.676290]  [<c0183e1e>] __slab_alloc+0x29e/0x4c0
[  276.676290]  [<c02956d4>] __dev_get_by_name+0x74/0x90
[  276.676290]  [<c02908fa>] skb_dequeue+0x4a/0x70
[  276.676290]  [<c0290e01>] skb_queue_purge+0x11/0x20
[  276.676290]  [<c02fb5ae>] unix_sock_destructor+0xe/0xf0
[  276.676290]  [<c028d7b0>] sk_free+0x80/0xf0
[  276.676290]  [<c02908fa>] skb_dequeue+0x4a/0x70
[  276.676290]  [<c01ad0ce>] invalidate_inode_buffers+0xe/0xa0
[  276.676290]  [<c028c2a4>] sys_socketcall+0xb4/0x2b0
[  276.676290]  [<c0187b45>] sys_close+0x65/0xc0
[  276.676290]  [<c0103dbf>] sysenter_past_esp+0x78/0xb9
[  276.676290]  =======================
[  276.676290] Code: ff ff 85 c0 89 c3 74 e6 8b 00 8b 54 24 08 89 02
0f b7 43 04 66 89 42 04 8b 4c 24 10 89 d8 8b 54 24 0c e8 a8 fe ff ff
31 c9 eb c3 <0f> 0b eb fe 0f 0b eb fe 8d b6 00 00 00 00 8d bf 00 00 00
00 83
[  276.676290] EIP: [<e09d6e0c>] ieee80211_dump_mpath+0x6c/0x80
[mac80211] SS:ESP 0068:d801bbe4
[  276.676290] ---[ end trace 328bd7808388128c ]---
[  304.288015] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  335.076064] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  365.864022] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  396.652019] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  427.440012] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  458.228013] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  489.016013] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  519.804019] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  550.608015] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  581.396025] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  612.184012] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  642.972032] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  673.760016] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  704.548030] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  735.336012] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  766.124012] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  796.912012] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  827.700013] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  858.488012] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  889.276015] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  920.064012] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  950.852013] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  978.876699] [drm] Num pipes: 1
[  981.640016] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 1012.428014] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 1043.216014] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[ 1074.004015] mesh: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)

--
YoungBin Im
Master Course Student
Multimedia & Mobile Communications Lab.
School of Computer Science and Engineering
Seoul National University, Republic of Korea.
