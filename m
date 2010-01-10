Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:36269 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0AJNTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 08:19:36 -0500
Received: by qyk32 with SMTP id 32so1391727qyk.4
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2010 05:19:35 -0800 (PST)
Message-ID: <4B49D3E0.1090706@cortland.com>
Date: Sun, 10 Jan 2010 08:19:28 -0500
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: kernel panic with b43 and hostap on mips
References: <4B490DF9.10802@hauke-m.de>
In-Reply-To: <4B490DF9.10802@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2010 06:15 PM, Hauke Mehrtens wrote:
> I am using compat-wireless of 2010-01-07 and mac80211: fix netdev 
> queues, mac80211: fix a few work bugs and mac80211: fix endian error 
> by Johannes.
>
> The system is running OpenWrt with kernel 2.6.30.10 on Asus WL-500GP 
> (brcm47xx system mips) and hostap git of 2010-01-08.
>
> The Systems and hostapd starts normal, but if a client tries to 
> connect to the access point the AP crashes. Without encryption it 
> works without any problems but with PSK and WPA1 the system crashes 
> with the attached panic. I have not tried other encryption modes. With 
> compat-wireless of 2009-12-05 and hostap git of 2009-11-29 the system 
> worked link expected.
>
Much the same behavior w/ OpenWrt & 2.6.31.11 on Alix (x86), AR9160 
radio (ath9k) and above compat-wireless and hostapd using WPA2.

I also got some warnings on the client. It was running the same 
hardware, kernel and compat-wireless w/ wpa_supplicant 0.6.9.

Steve

===== AP =====

Jan 10 05:26:11 222 daemon.info hostapd: wlan0: STA 00:0e:8e:1d:f5:5b 
IEEE 802.11: Station tried to associate before authentication (aid=-1 
flags=0x0)
Jan 10 05:26:12 222 daemon.info hostapd: wlan0: STA 00:0e:8e:1d:f5:5b 
IEEE 802.11: Station tried to associate before authentication (aid=-1 
flags=0x0)
BUG: unable to handle kernel paging request at 00acd30c
IP: [<c11bb8cd>] qdisc_calculate_pkt_len+0xd/0xa0
*pde = 00000000
Oops: 0000 [#1]
last sysfs file: /sys/devices/pci0000:00/0000:00:0c.0/ieee80211/phy0/index
Modules linked in: usbhid option usb_storage usbserial evdev lm90 
scx200_acb i2c_algo_bit i2c_dev i2c_core ohci_hcd ne2k_pci 8390 
leds_alix2 nf_nat_tftp nf_conne

Pid: 2422, comm: hostapd Not tainted (2.6.31.11 #1)
EIP: 0060:[<c11bb8cd>] EFLAGS: 00010282 CPU: 0
EIP is at qdisc_calculate_pkt_len+0xd/0xa0
EAX: c171b180 EBX: 00acd2f0 ECX: 00000014 EDX: 00acd2f0
ESI: c171b180 EDI: cf9c8900 EBP: cebe4000 ESP: c16fccd0
  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process hostapd (pid: 2422, ti=c16fc000 task=c1780d80 task.ti=c16fc000)
Stack:
  c171b180 c0000007 c171b180 00000300 c171b180 c11af464 c16fcef4 00000083
<0> 00000083 c11a75ab 00000300 00000091 cebe4000 c171b180 c1200266 c16fcd58
<0> 00000000 00000286 c16fcf40 c171b19c c16fcf44 c1694c00 00000000 c16fcd58
Call Trace:
  [<c11af464>] ? dev_queue_xmit+0x184/0x2d0
  [<c11a75ab>] ? memcpy_fromiovec+0x2b/0x50
  [<c1200266>] ? packet_sendmsg+0x756/0x7c0
  [<c11c3156>] ? netlink_recvmsg+0x246/0x280
  [<c119f0be>] ? sock_sendmsg+0xbe/0xf0
  [<c10329f0>] ? autoremove_wake_function+0x0/0x50
  [<c10329f0>] ? autoremove_wake_function+0x0/0x50
  [<c11a78c0>] ? verify_iovec+0x50/0x90
  [<c119f2d1>] ? sys_sendmsg+0x1e1/0x270
  [<c119fdc4>] ? sys_recvmsg+0x1e4/0x270
  [<c102f35d>] ? call_usermodehelper_exec+0x6d/0x80
  [<c119e78e>] ? sock_ioctl+0x21e/0x250
  [<c107672f>] ? vfs_ioctl+0x1f/0x70
  [<c1089699>] ? invalidate_inode_buffers+0x9/0x30
  [<c11a0613>] ? sys_socketcall+0x243/0x290
  [<c1069a51>] ? filp_close+0x61/0x80
  [<c1069abe>] ? sys_close+0x4e/0x90
  [<c1003095>] ? syscall_call+0x7/0xb
Code: 02 31 c0 8b 5c 24 14 8b 74 24 18 8b 7c 24 1c 8b 6c 24 20 83 c4 24 
c3 8d b4 26 00 00 00 00 83 ec 14 89 5c 24 04 89 d3 89 74 24 08 <8b> 73 
1c 89 7c 24 0c 89
EIP: [<c11bb8cd>] qdisc_calculate_pkt_len+0xd/0xa0 SS:ESP 0068:c16fccd0
CR2: 0000000000acd30c
---[ end trace 7246f3554ac82cd2 ]---

====== Client =======

Jan 10 08:10:48 220 user.warn kernel: WARNING: at 
/home/brown/wifi/dev/openwrt/trunk-alix-svn/build_dir/linux-x86_generic/compat-wireless-2010-01-07/net/mac80211/work.c:736 
free_work+0x347/0xe80 [mac80211]()
Jan 10 08:10:48 220 user.warn kernel: Modules linked in: usbhid option 
usb_storage usbserial evdev lm90 scx200_acb i2c_algo_bit i2c_dev 
i2c_core ohci_hcd ne2k_pci 8390 leds_alix2 nf_nat_tftp nf_conntrack_tftp 
nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp
Jan 10 08:10:48 220 user.warn kernel: Pid: 707, comm: phy0 Tainted: 
G        W  2.6.31.11 #1
Jan 10 08:10:48 220 user.warn kernel: Call Trace:
Jan 10 08:10:48 220 user.warn kernel:  [<c897e337>] ? 
free_work+0x347/0xe80 [mac80211]
Jan 10 08:10:48 220 user.warn kernel:  [<c10221bf>] ? 
warn_slowpath_common+0x7f/0xb0
Jan 10 08:10:48 220 user.warn kernel:  [<c897e337>] ? 
free_work+0x347/0xe80 [mac80211]
Jan 10 08:10:48 220 user.warn kernel:  [<c1022203>] ? 
warn_slowpath_null+0x13/0x20
Jan 10 08:10:48 220 user.warn kernel:  [<c897e337>] ? 
free_work+0x347/0xe80 [mac80211]
Jan 10 08:10:48 220 user.warn kernel:  [<c11a4ed8>] ? __kfree_skb+0x8/0x80
Jan 10 08:10:48 220 user.warn kernel:  [<c897d2d9>] ? 
ieee80211_sta_restart+0x6f9/0x810 [mac80211]
Jan 10 08:10:48 220 user.warn kernel:  [<c897d3c8>] ? 
ieee80211_sta_restart+0x7e8/0x810 [mac80211]
Jan 10 08:10:48 220 user.warn kernel:  [<c8ab023f>] ? 
ath9k_hw_wait+0x3f/0x70 [ath9k_hw]
Jan 10 08:10:48 220 user.warn kernel:  [<c101cb7d>] ? update_curr+0x7d/0xd0
Jan 10 08:10:48 220 user.warn kernel:  [<c1212569>] ? schedule+0x269/0x290
Jan 10 08:10:48 220 user.warn kernel:  [<c897e000>] ? 
free_work+0x10/0xe80 [mac80211]
Jan 10 08:10:48 220 user.warn kernel:  [<c102feda>] ? 
worker_thread+0xca/0x150
Jan 10 08:10:48 220 user.warn kernel:  [<c10329f0>] ? 
autoremove_wake_function+0x0/0x50
Jan 10 08:10:48 220 user.warn kernel:  [<c102fe10>] ? 
worker_thread+0x0/0x150
Jan 10 08:10:48 220 user.warn kernel:  [<c1032833>] ? kthread+0x73/0x90
Jan 10 08:10:48 220 user.warn kernel:  [<c10327c0>] ? kthread+0x0/0x90
Jan 10 08:10:48 220 user.warn kernel:  [<c1003873>] ? 
kernel_thread_helper+0x7/0x14
Jan 10 08:10:48 220 user.warn kernel: ---[ end trace 3df74ce0e3e9f3f6 ]---
Jan 10 08:10:48 220 user.debug kernel: wlan0: association with 
00:0e:8e:1d:f5:5c timed out
Jan 10 08:10:50 220 user.debug kernel: wlan0: direct probe to 
00:0e:8e:1d:f5:5c (try 1)
Jan 10 08:10:50 220 user.debug kernel: wlan0: direct probe responded
Jan 10 08:10:50 220 user.debug kernel: wlan0: direct probe responded
Jan 10 08:10:50 220 user.debug kernel: wlan0: associate with 
00:0e:8e:1d:f5:5c (try 1)
Jan 10 08:10:51 220 user.warn kernel: ------------[ cut here ]------------
Jan 10 08:10:51 220 user.warn kernel: WARNING: at 
/home/brown/wifi/dev/openwrt/trunk-alix-svn/build_dir/linux-x86_generic/compat-wireless-2010-01-07/net/mac80211/work.c:736 
free_work+0x347/0xe80 [mac80211]()
Jan 10 08:10:51 220 user.warn kernel: Modules linked in: usbhid option 
usb_storage usbserial evdev lm90 scx200_acb i2c_algo_bit i2c_dev 
i2c_core ohci_hcd ne2k_pci 8390 leds_alix2 nf_nat_tftp nf_conntrack_tftp 
nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp
Jan 10 08:10:51 220 user.warn kernel: Pid: 707, comm: phy0 Tainted: 
G        W  2.6.31.11 #1
Jan 10 08:10:51 220 user.warn kernel: Call Trace:
Jan 10 08:10:51 220 user.warn kernel:  [<c897e337>] ? 
free_work+0x347/0xe80 [mac80211]
Jan 10 08:10:51 220 user.warn kernel:  [<c10221bf>] ? 
warn_slowpath_common+0x7f/0xb0
Jan 10 08:10:51 220 user.warn kernel:  [<c897e337>] ? 
free_work+0x347/0xe80 [mac80211]
Jan 10 08:10:51 220 user.warn kernel:  [<c1022203>] ? 
warn_slowpath_null+0x13/0x20
Jan 10 08:10:51 220 user.warn kernel:  [<c897e337>] ? 
free_work+0x347/0xe80 [mac80211]
Jan 10 08:10:51 220 user.warn kernel:  [<c8ab023f>] ? 
ath9k_hw_wait+0x3f/0x70 [ath9k_hw]
Jan 10 08:10:51 220 user.warn kernel: ------------[ cut here ]------------
Jan 10 08:10:51 220 user.warn kernel: WARNING: at 
/home/brown/wifi/dev/openwrt/trunk-alix-svn/build_dir/linux-x86_generic/compat-wireless-2010-01-07/net/mac80211/work.c:736 
free_work+0x347/0xe80 [mac80211]()
Jan 10 08:10:51 220 user.warn kernel: Modules linked in: usbhid option 
usb_storage usbserial evdev lm90 scx200_acb i2c_algo_bit i2c_dev 
i2c_core ohci_hcd ne2k_pci 8390 leds_alix2 nf_nat_tftp nf_conntrack_tftp 
nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp
Jan 10 08:10:51 220 user.warn kernel: Pid: 707, comm: phy0 Tainted: 
G        W  2.6.31.11 #1
Jan 10 08:10:51 220 user.warn kernel: Call Trace:
Jan 10 08:10:51 220 user.warn kernel:  [<c897e337>] ? 
free_work+0x347/0xe80 [mac80211]
Jan 10 08:10:51 220 user.warn kernel:  [<c10221bf>] ? 
warn_slowpath_common+0x7f/0xb0
Jan 10 08:10:51 220 user.warn kernel:  [<c897e337>] ? 
free_work+0x347/0xe80 [mac80211]
Jan 10 08:10:51 220 user.warn kernel:  [<c1022203>] ? 
warn_slowpath_null+0x13/0x20
Jan 10 08:10:51 220 user.warn kernel:  [<c897e337>] ? 
free_work+0x347/0xe80 [mac80211]
Jan 10 08:10:51 220 user.warn kernel:  [<c11a4ed8>] ? __kfree_skb+0x8/0x80
Jan 10 08:10:52 220 user.warn kernel: ------------[ cut here ]------------

