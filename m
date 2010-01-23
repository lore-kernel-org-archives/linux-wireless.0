Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:59539 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab0AWHlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 02:41:31 -0500
Received: by pzk28 with SMTP id 28so618081pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 23:41:30 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 23 Jan 2010 18:41:30 +1100
Message-ID: <297c1a111001222341gad6b26eh8a410a73a2d9a3dc@mail.gmail.com>
Subject: NULL dereference on wireless-testing/head
From: "Paul \"TBBle\" Hampson" <Paul.Hampson@Pobox.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just upgraded my Alix.2+ath5k router box from 2.6.30-rc8 w/some
random wireless-testing tree to wireless-testing/head (96ada3c) and
started getting NULL pointer dereferences.

git-bisect indicated 813d766 as the culprit, and reverting that commit
on top of 96ada3c seems to be working.

The NULL-dereference occurs as far as I can tell as soon as the STA
tries to connect. I could trigger it immediately with my Android
mobile phone using a wireless-scanner program.

If it helps, lspci says:
00:0c.0 Ethernet controller [0200]: Atheros Communications Inc.
AR5212/AR5213 Multiprotocol MAC/baseband processor [168c:0013] (rev
01)

This's what I grabbed from netconsole:
[ 1082.148263] BUG: unable to handle kernel NULL pointer dereference at 00000193
[ 1082.158061] IP: [<d0ac1ec5>] invoke_tx_handlers+0x467/0xc27 [mac80211]
[ 1082.158061] *pde = 00000000
[ 1082.158061] Oops: 0000 [#1]
[ 1082.158061] last sysfs file: /sys/class/net/lo/operstate
[ 1082.158061] Modules linked in: netconsole configfs sit tunnel4
pppoe pppox ppp_generic slhc xt_TCPMSS xt_tcpudp iptable_mangle
ipt_MASQUERADE iptable_nat ip_tables x_tables bridge stp llc
nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp
nf_conntrack ipv6 geodewdt lm90 hwmon scx200_acb i2c_core
ledtrig_heartbeat arc4 ecb aes_i586 aes_generic ath5k cs5535_mfgpt
mac80211 ath geode_aes rtc_cmos leds_alix2 geode_rng cfg80211
led_class rng_core ext3 jbd mbcache sd_mod pata_cs5536 ohci_hcd
ehci_hcd libata usbcore via_rhine mii scsi_mod nls_base [last
unloaded: netconsole]
[ 1082.158061]
[ 1082.158061] Pid: 1951, comm: hostapd Not tainted 2.6.33-rc5-wl #1 /
[ 1082.158061] EIP: 0060:[<d0ac1ec5>] EFLAGS: 00210246 CPU: 0
[ 1082.158061] EIP is at invoke_tx_handlers+0x467/0xc27 [mac80211]
[ 1082.158061] EAX: cf06685e EBX: cf00dcb0 ECX: 00000000 EDX: 00000000
[ 1082.158061] ESI: cf1580c0 EDI: cf1bd2c0 EBP: cf9d8e00 ESP: cf00dc3c
[ 1082.158061]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 1082.158061] Process hostapd (pid: 1951, ti=cf00d000 task=cfb594a0
task.ti=cf00d000)
[ 1082.158061] Stack:
[ 1082.158061]  00000050 cf1580e0 cf1580c0 c1065688 00100100 cf00dcb0
cf1580e0 cf00dcb0
[ 1082.158061] <0> d0ac1571 0000006a cf0941e0 00200286 cf066850
0000000e 0000000f cf06685c
[ 1082.158061] <0> 00000012 cf06685e cf1580c0 00000000 cf1580c0
cf0941e0 cf00dcb0 cf1580e0
[ 1082.158061] Call Trace:
[ 1082.158061]  [<c1065688>] ? pollwake+0x0/0x60
[ 1082.158061]  [<d0ac1571>] ? ieee80211_tx_prepare+0x24e/0x283 [mac80211]
[ 1082.158061]  [<d0ac27fe>] ? ieee80211_tx+0x60/0x163 [mac80211]
[ 1082.158061]  [<d0ac2b37>] ? ieee80211_monitor_start_xmit+0x78/0x87 [mac80211]
[ 1082.158061]  [<c1102c42>] ? dev_hard_start_xmit+0x1be/0x253
[ 1082.158061]  [<c110f78d>] ? sch_direct_xmit+0x34/0xe7
[ 1082.158061]  [<c1102ffe>] ? dev_queue_xmit+0x247/0x368
[ 1082.158061]  [<c10fe321>] ? memcpy_fromiovec+0x23/0x45
[ 1082.158061]  [<c1153bad>] ? packet_sendmsg+0x684/0x6d4
[ 1082.158061]  [<c10fe52f>] ? memcpy_toiovec+0x23/0x45
[ 1082.158061]  [<c1058289>] ? kfree+0x7e/0x85
[ 1082.158061]  [<c10fc85d>] ? __kfree_skb+0xf/0x68
[ 1082.158061]  [<c10f74ed>] ? sock_sendmsg+0x96/0xae
[ 1082.158061]  [<c10fe58d>] ? verify_iovec+0x3c/0x67
[ 1082.158061]  [<c10f78f4>] ? sys_sendmsg+0x15f/0x1c4
[ 1082.158061]  [<c10f7b47>] ? sys_recvfrom+0xb8/0x111
[ 1082.158061]  [<c104078d>] ? find_get_page+0x1d/0x84
[ 1082.158061]  [<c104d049>] ? __do_fault+0x2ba/0x2ea
[ 1082.158061]  [<c104d5a0>] ? unmap_vmas+0x27b/0x40b
[ 1082.158061]  [<c104dd94>] ? handle_mm_fault+0x1f0/0x6c5
[ 1082.158061]  [<c10f7bb9>] ? sys_recv+0x19/0x1d
[ 1082.158061]  [<c10f8a6e>] ? sys_socketcall+0x162/0x1ad
[ 1082.158061]  [<c1012d52>] ? do_page_fault+0x0/0x26e
[ 1082.158061]  [<c115bab4>] ? syscall_call+0x7/0xb
[ 1082.158061]  [<c1150000>] ? unix_stream_recvmsg+0x15e/0x3e5
[ 1082.158061] Code: 25 8a 51 18 80 fa 07 74 05 80 fa 04 75 04 31 d2
eb 09 80 fa 7f 0f 95 c2 0f b6 d2 85 d2 75 07 c7 43 10 00 00 00 00 8b
4b 10 31 d2 <f6> 81 93 01 00 00 10 74 0a 0f b7 00 31 d2 a8 0c 0f 94 c2
85 d2
[ 1082.158061] EIP: [<d0ac1ec5>] invoke_tx_handlers+0x467/0xc27
[mac80211] SS:ESP 0068:cf00dc3c
[ 1082.158061] CR2: 0000000000000193
[ 1083.079910] ---[ end trace cd454599fe136901 ]---
[ 1083.093816] Kernel panic - not syncing: Fatal exception in interrupt
[ 1083.112914] Pid: 1951, comm: hostapd Tainted: G      D    2.6.33-rc5-wl #1
[ 1083.133546] Call Trace:
[ 1083.140948]  [<c115a636>] ? panic+0x38/0xdb
[ 1083.153527]  [<c1004731>] ? oops_end+0x78/0x83
[ 1083.166887]  [<c1012b5a>] ? no_context+0x10c/0x115
[ 1083.181291]  [<c1012d52>] ? do_page_fault+0x0/0x26e
[ 1083.195967]  [<c1012c60>] ? bad_area_nosemaphore+0xa/0xc
[ 1083.211944]  [<c115bde7>] ? error_code+0x6b/0x70
[ 1083.225867]  [<d0ac1ec5>] ? invoke_tx_handlers+0x467/0xc27 [mac80211]
[ 1083.245224]  [<c1065688>] ? pollwake+0x0/0x60
[ 1083.258365]  [<d0ac1571>] ? ieee80211_tx_prepare+0x24e/0x283 [mac80211]
[ 1083.278287]  [<d0ac27fe>] ? ieee80211_tx+0x60/0x163 [mac80211]
[ 1083.295873]  [<d0ac2b37>] ? ieee80211_monitor_start_xmit+0x78/0x87 [mac80211]
[ 1083.317294]  [<c1102c42>] ? dev_hard_start_xmit+0x1be/0x253
[ 1083.334038]  [<c110f78d>] ? sch_direct_xmit+0x34/0xe7
[ 1083.349217]  [<c1102ffe>] ? dev_queue_xmit+0x247/0x368
[ 1083.364660]  [<c10fe321>] ? memcpy_fromiovec+0x23/0x45
[ 1083.380103]  [<c1153bad>] ? packet_sendmsg+0x684/0x6d4
[ 1083.395563]  [<c10fe52f>] ? memcpy_toiovec+0x23/0x45
[ 1083.410498]  [<c1058289>] ? kfree+0x7e/0x85
[ 1083.423078]  [<c10fc85d>] ? __kfree_skb+0xf/0x68
[ 1083.436966]  [<c10f74ed>] ? sock_sendmsg+0x96/0xae
[ 1083.451371]  [<c10fe58d>] ? verify_iovec+0x3c/0x67
[ 1083.465770]  [<c10f78f4>] ? sys_sendmsg+0x15f/0x1c4
[ 1083.480435]  [<c10f7b47>] ? sys_recvfrom+0xb8/0x111
[ 1083.495113]  [<c104078d>] ? find_get_page+0x1d/0x84
[ 1083.509787]  [<c104d049>] ? __do_fault+0x2ba/0x2ea
[ 1083.524189]  [<c104d5a0>] ? unmap_vmas+0x27b/0x40b
[ 1083.538594]  [<c104dd94>] ? handle_mm_fault+0x1f0/0x6c5
[ 1083.554299]  [<c10f7bb9>] ? sys_recv+0x19/0x1d
[ 1083.567660]  [<c10f8a6e>] ? sys_socketcall+0x162/0x1ad
[ 1083.583104]  [<c1012d52>] ? do_page_fault+0x0/0x26e
[ 1083.597779]  [<c115bab4>] ? syscall_call+0x7/0xb
[ 1083.611679]  [<c1150000>] ? unix_stream_recvmsg+0x15e/0x3e5

Even with the reversion, I'm seeing the following in the logs on the
router every so often but haven't noticed any network ill-effects yet.
Jan 23 18:39:01 localhost kernel: [ 1044.487162] ------------[ cut
here ]------------
Jan 23 18:39:01 localhost kernel: [ 1044.501138] WARNING: at
net/mac80211/util.c:352 ieee80211_add_pending_skb+0x23/0x73
[mac80211]()
Jan 23 18:39:01 localhost kernel: [ 1044.527513] Modules linked in:
netconsole configfs sit tunnel4 pppoe pppox ppp_generic slhc xt_TCPMSS
xt_tcpudp iptable_mangle ipt_MASQUERADE iptable_nat ip_tables x_tables
bridge stp llc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_conntrack_ftp nf_conntrack ipv6 geodewdt lm90 hwmon scx200_acb
i2c_core ledtrig_heartbeat arc4 ecb aes_i586 ath5k aes_generic
cs5535_mfgpt mac80211 ath geode_aes cfg80211 rtc_cmos geode_rng
leds_alix2 led_class rng_core ext3 jbd mbcache sd_mod pata_cs5536
ehci_hcd ohci_hcd libata usbcore via_rhine scsi_mod nls_base mii [last
unloaded: scsi_wait_scan]
Jan 23 18:39:01 localhost kernel: [ 1044.686967] Pid: 0, comm: swapper
Tainted: G        W  2.6.33-rc5-wl #1
Jan 23 18:39:01 localhost kernel: [ 1044.706830] Call Trace:
Jan 23 18:39:01 localhost kernel: [ 1044.714234]  [<c1019ed6>] ?
warn_slowpath_common+0x5d/0x70
Jan 23 18:39:01 localhost kernel: [ 1044.730733]  [<c1019ef4>] ?
warn_slowpath_null+0xb/0xd
Jan 23 18:39:01 localhost kernel: [ 1044.746213]  [<d0adb726>] ?
ieee80211_add_pending_skb+0x23/0x73 [mac80211]
Jan 23 18:39:01 localhost kernel: [ 1044.766900]  [<d0ac9375>] ?
ieee80211_sta_ps_deliver_poll_response+0x6c/0x80 [mac80211]
Jan 23 18:39:01 localhost kernel: [ 1044.790996]  [<d0ad6403>] ?
ieee80211_invoke_rx_handlers+0xddb/0x14ba [mac80211]
Jan 23 18:39:01 localhost kernel: [ 1044.813212]  [<d0cecb66>] ?
br_forward_finish+0x0/0x42 [bridge]
Jan 23 18:39:01 localhost kernel: [ 1044.831011]  [<d0cecb66>] ?
br_forward_finish+0x0/0x42 [bridge]
Jan 23 18:39:01 localhost kernel: [ 1044.848822]  [<d0cecc16>] ?
__br_forward+0x6e/0x7e [bridge]
Jan 23 18:39:01 localhost kernel: [ 1044.865614]  [<d0ad71a4>] ?
ieee80211_rx+0x6c2/0x722 [mac80211]
Jan 23 18:39:01 localhost kernel: [ 1044.883434]  [<d0b46061>] ?
ath5k_tasklet_rx+0x41e/0x468 [ath5k]
Jan 23 18:39:01 localhost kernel: [ 1044.901495]  [<c101d2e5>] ?
tasklet_action+0x3d/0x63
Jan 23 18:39:01 localhost kernel: [ 1044.916420]  [<c101d868>] ?
__do_softirq+0x5b/0xcb
Jan 23 18:39:01 localhost kernel: [ 1044.930822]  [<c101d80d>] ?
__do_softirq+0x0/0xcb
Jan 23 18:39:01 localhost kernel: [ 1044.944968]  <IRQ>  [<c101d65f>]
? irq_exit+0x25/0x53
Jan 23 18:39:01 localhost kernel: [ 1044.960252]  [<c1003869>] ?
do_IRQ+0x6b/0x7b
Jan 23 18:39:01 localhost kernel: [ 1044.973093]  [<c1002ad0>] ?
common_interrupt+0x30/0x38
Jan 23 18:39:01 localhost kernel: [ 1044.988554]  [<c10072c1>] ?
default_idle+0x25/0x38
Jan 23 18:39:01 localhost kernel: [ 1045.002960]  [<c10018fc>] ?
cpu_idle+0x71/0x8d
Jan 23 18:39:01 localhost kernel: [ 1045.016326]  [<c12076a1>] ?
start_kernel+0x29f/0x2a4
Jan 23 18:39:01 localhost kernel: [ 1045.031240] ---[ end trace
dc4128cfbeaa4654 ]---

I'm subscribed to the list, so let me know if there's any details I'm
missing or tests I can do. I don't have access to the serial console
at the moment, so I can't interact with the box before the ethernet
and bridge interfaces come up, but I can disable the wireless during
boot, and then start netconsole and trigger more crashes if needs be.

-- 
Paul "TBBle" Hampson, Paul.Hampson@Pobox.com
