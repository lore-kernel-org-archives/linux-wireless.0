Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:42522 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010Ab1L2BD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 20:03:29 -0500
Received: from macbook.redfish-solutions.com (macbook.redfish-solutions.com [192.168.1.17])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.5/8.14.5) with ESMTP id pBT0uEJ2025549
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2011 17:56:15 -0700
Message-ID: <4EFBBAAE.8040507@redfish-solutions.com> (sfid-20111229_020349_552566_85DD948E)
Date: Wed, 28 Dec 2011 17:56:14 -0700
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Panic in tpt support on ath5k
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using compat-wireless-2011-12-01 on OpenWRT trunk on an alix5k, with a Winston Neweb CM/9 card and seeing:

[   29.822951] BUG: unable to handle kernel NULL pointer dereference at   (null)
[   29.832121] IP: [<d0af1747>] __ieee80211_get_rx_led_name+0xb9/0xcd [mac80211]
[   29.832121] *pde = 00000000
[   29.832121] Oops: 0000 [#1]
[   29.832121] last sysfs file: /sys/kernel/uevent_seqnum
[   29.832121] Modules linked in: gpio_keys_polled leds_gpio lm90 scx200_acb i2c_gpio i2c_algo_pcf i2c_algo_pca i2c_algo
_bit i2c_dev i2c_core geodewdt via_rhine ohci_hcd xt_LED ledtrig_heartbeat ledtrig_gpio cs5535_gpio cs5535_clockevt nf_n
at_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp xt_TRACE cs5535_mfgpt cs5535_mfd mfd_core ipt_MASQUERADE iptable_nat
 nf_nat xt_CT xt_conntrack xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ehci_hcd pppoe
pppox ipt_REJECT xt_TCPMSS ipt_LOG xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tc
pudp x_tables nsc_gpio gpio_dev dummy ppp_mppe ppp_async ppp_generic slhc button_hotplug ath9k ath9k_common ath9k_hw ath
5k ath mac80211 usbcore nls_base crc_ccitt input_polldev msr cfg80211 compat input_core chainiv eseqiv crypto_wq sha1_ge
neric krng rng cryptosoft cryptodev(P) ocf(P) md5 geode_aes hmac ecb des_generic deflate cbc authenc arc4 aes_i586 aes_g
eneric zlib_deflate crypto_blkcipher cryptomgr aead crypto_hash crypto_algapi
[   29.832121]
[   29.832121] Pid: 1071, comm: hostapd Tainted: P            2.6.39.4 #1
[   29.832121] EIP: 0060:[<d0af1747>] EFLAGS: 00010286 CPU: 0
[   29.832121] EIP is at __ieee80211_get_rx_led_name+0xb9/0xcd [mac80211]
[   29.832121] EAX: fffffff8 EBX: ffffff9c ECX: 00000000 EDX: ffffffff
[   29.832121] ESI: cf84900c EDI: 00000001 EBP: 00000001 ESP: ce47fe58
[   29.832121]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   29.832121] Process hostapd (pid: 1071, ti=ce47e000 task=cee88c80 task.ti=ce47e000)
[   29.832121] Stack:
[   29.832121]  00000000 00000000 00000001 cee40a40 cf849000 d0af1c40 ce458000 ce458340
[   29.832121]  cee40a40 00000000 d0ae3f08 01458000 ce458048 ce458000 ce458048 d0afb400
[   29.832121]  00000000 c116cefd ce458000 00000000 00001003 c116d0db 00000001 ce458000
[   29.832121] Call Trace:
[   29.832121]  [<d0af1c40>] ? ieee80211_mod_tpt_led_trig+0xa4/0xc4 [mac80211]
[   29.832121]  [<d0ae3f08>] ? __ieee80211_recalc_idle+0x700/0xa17 [mac80211]
[   29.832121]  [<c116cefd>] ? __dev_open+0x76/0xa1
[   29.832121]  [<c116d0db>] ? __dev_change_flags+0x97/0x110
[   29.832121]  [<c116d1c1>] ? dev_change_flags+0x10/0x3b
[   29.832121]  [<c11a6f9d>] ? devinet_ioctl+0x22a/0x588
[   29.832121]  [<c115f3a0>] ? sock_ioctl+0x1b9/0x1e0
[   29.832121]  [<c115f1e7>] ? sock_fasync+0x6a/0x6a
[   29.832121]  [<c10743ba>] ? do_vfs_ioctl+0x446/0x49e
[   29.832121]  [<c1160c5f>] ? sys_socketcall+0x19a/0x1dc
[   29.832121]  [<c1074439>] ? sys_ioctl+0x27/0x4a
[   29.832121]  [<c11ca485>] ? syscall_call+0x7/0xb
[   29.832121] Code: 89 54 24 08 eb 05 4a 85 d2 79 d0 8b 5e 0c 83 eb 64 83 c6 0c eb 15 89 d8 8d 4c 24 04 8d 54 24 08 e8
ed f0 65 f0 8b 5b 64 83 eb 64 <8b> 43 64 8d 74 26 00 8d 43 64 39 f0 75 dd 83 c4 0c 5b 5e c3 55
[   29.832121] EIP: [<d0af1747>] __ieee80211_get_rx_led_name+0xb9/0xcd [mac80211] SS:ESP 0068:ce47fe58
[   29.832121] CR2: 0000000000000000
[   30.680974] ---[ end trace 371e7af7a93daf8b ]---
[   32.384319] BUG: unable to handle kernel NULL pointer dereference at   (null)
[   32.394261] IP: [<d0af1747>] __ieee80211_get_rx_led_name+0xb9/0xcd [mac80211]
[   32.394261] *pde = 00000000
[   32.394261] Oops: 0000 [#2]
[   32.394261] last sysfs file: /sys/kernel/uevent_seqnum
[   32.394261] Modules linked in: gpio_keys_polled leds_gpio lm90 scx200_acb i2c_gpio i2c_algo_pcf i2c_algo_pca i2c_algo
_bit i2c_dev i2c_core geodewdt via_rhine ohci_hcd xt_LED ledtrig_heartbeat ledtrig_gpio cs5535_gpio cs5535_clockevt nf_n
at_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp xt_TRACE cs5535_mfgpt cs5535_mfd mfd_core ipt_MASQUERADE iptable_nat
 nf_nat xt_CT xt_conntrack xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ehci_hcd pppoe
pppox ipt_REJECT xt_TCPMSS ipt_LOG xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tc
pudp x_tables nsc_gpio gpio_dev dummy ppp_mppe ppp_async ppp_generic slhc button_hotplug ath9k ath9k_common ath9k_hw ath
5k ath mac80211 usbcore nls_base crc_ccitt input_polldev msr cfg80211 compat input_core chainiv eseqiv crypto_wq sha1_ge
neric krng rng cryptosoft cryptodev(P) ocf(P) md5 geode_aes hmac ecb des_generic deflate cbc authenc arc4 aes_i586 aes_g
eneric zlib_deflate crypto_blkcipher cryptomgr aead crypto_hash crypto_algapi
[   32.394261]
[   32.394261] Pid: 1081, comm: S45firewall Tainted: P      D     2.6.39.4 #1
[   32.394261] EIP: 0060:[<d0af1747>] EFLAGS: 00010286 CPU: 0
[   32.394261] EIP is at __ieee80211_get_rx_led_name+0xb9/0xcd [mac80211]
[   32.394261] EAX: fffffff8 EBX: ffffff9c ECX: 00000000 EDX: ffffffff
[   32.394261] ESI: cf84900c EDI: cf80ffcc EBP: cf80ffe0 ESP: cf80ffa8
[   32.394261]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   32.394261] Process S45firewall (pid: 1081, ti=cf80e000 task=cee89c20 task.ti=ce452000)
[   32.394261] Stack:
[   32.394261]  00000000 00000000 00000001 c12c3260 00000100 c1023daa d0af1694 c12c3a6c
[   32.394261]  c12c3c6c cefc9454 cf839f6c 00000001 c12c30c4 00000100 00000001 c1020a34
[   32.394261]  0000000a ce453f8c ce452000 c10209da 00000007 c10034b5
[   32.394261] Call Trace:
[   32.394261]  [<c1023daa>] ? run_timer_softirq+0xf8/0x164
[   32.394261]  [<d0af1694>] ? __ieee80211_get_rx_led_name+0x6/0xcd [mac80211]
[   32.394261]  [<c1020a34>] ? __do_softirq+0x5a/0xc9
[   32.394261]  [<c10209da>] ? local_bh_enable+0x6f/0x6f
[   32.394261]  <IRQ>
[   32.394261]  [<c1003417>] ? do_IRQ+0x6b/0x7b
[   32.394261]  [<c11caf69>] ? common_interrupt+0x29/0x30
[   32.394261] Code: 89 54 24 08 eb 05 4a 85 d2 79 d0 8b 5e 0c 83 eb 64 83 c6 0c eb 15 89 d8 8d 4c 24 04 8d 54 24 08 e8
ed f0 65 f0 8b 5b 64 83 eb 64 <8b> 43 64 8d 74 26 00 8d 43 64 39 f0 75 dd 83 c4 0c 5b 5e c3 55
[   32.394261] EIP: [<d0af1747>] __ieee80211_get_rx_led_name+0xb9/0xcd [mac80211] SS:ESP 0068:cf80ffa8
[   32.394261] CR2: 0000000000000000
[   33.152138] ---[ end trace 371e7af7a93daf8c ]---
[   33.166070] Kernel panic - not syncing: Fatal exception in interrupt
[   33.185204] Pid: 1081, comm: S45firewall Tainted: P      D     2.6.39.4 #1
[   33.205883] Call Trace:
[   33.213221]  [<c11c904f>] ? panic+0x4d/0x12a
[   33.226126]  [<c10041e6>] ? oops_end+0x68/0x86
[   33.239559]  [<c101561a>] ? no_context+0x10c/0x116
[   33.254017]  [<c1015900>] ? vmalloc_sync_all+0xa9/0xa9
[   33.269517]  [<c101572b>] ? bad_area_nosemaphore+0xa/0xc
[   33.285536]  [<c1015a5d>] ? do_page_fault+0x15d/0x350
[   33.300767]  [<c1015900>] ? vmalloc_sync_all+0xa9/0xa9
[   33.316262]  [<c11ca814>] ? error_code+0x58/0x60
[   33.330177]  [<c1015900>] ? vmalloc_sync_all+0xa9/0xa9
[   33.345737]  [<d0af1747>] ? __ieee80211_get_rx_led_name+0xb9/0xcd [mac80211]
[   33.366946]  [<c1023daa>] ? run_timer_softirq+0xf8/0x164
[   33.382993]  [<d0af1694>] ? __ieee80211_get_rx_led_name+0x6/0xcd [mac80211]
[   33.403925]  [<c1020a34>] ? __do_softirq+0x5a/0xc9
[   33.418388]  [<c10209da>] ? local_bh_enable+0x6f/0x6f
[   33.433604]  <IRQ>  [<c1003417>] ? do_IRQ+0x6b/0x7b
[   33.448353]  [<c11caf69>] ? common_interrupt+0x29/0x30


for quite a while, led trigger 'tpt' support has been lacking for ath5k.

It's recent state causing panics is new, however.

Can support for tpt on ath5k get a little lovin' so it's on par with ath9k, or at least not causing panics?

Thanks,

-Philip
