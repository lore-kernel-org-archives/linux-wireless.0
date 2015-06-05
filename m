Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from misuzu.xephris.net ([216.86.145.57]:56113 "EHLO
	misuzu.xephris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbbFEBdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 21:33:11 -0400
Received: from [172.21.2.12] (ip11.216-86-144.static.steadfastdns.net [216.86.144.11])
	(Authenticated sender: severn@xephris.net)
	by misuzu.xephris.net (Postfix) with ESMTPSA id ABECAE335E
	for <linux-wireless@vger.kernel.org>; Thu,  4 Jun 2015 21:27:28 -0400 (EDT)
Message-ID: <5570FB00.3040108@xephris.net> (sfid-20150605_033317_252046_16E1FBC2)
Date: Thu, 04 Jun 2015 21:27:28 -0400
From: Severn <severn@xephris.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rtlwifi NULL pointer dereference
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've been hitting this NULL pointer deref with an rtl8188ee PCIE card. It happens 100% of the time when I bring up a WPA2-PSK AP with hostapd 2.4.

If I revert 33511b157bbcebaef853cc1811992b664a2e5862, everything seems to work properly.

Below is my hostapd.conf and the crash log. This is mainline 4.0.4 with no patches.

hostapd.conf
interface=wlp5s0
driver=nl80211
ssid=XXXX
wpa=2
wpa_passphrase=XXXXXXXXXXXX
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
bridge=br1

ieee80211n=1
wmm_enabled=1

hw_mode=g
channel=1



[  463.293026] ------------[ cut here ]------------
[  463.297440] WARNING: CPU: 1 PID: 2439 at net/mac80211/driver-ops.h:12 ieee80211_bss_info_change_notify+0x179/0x1d0 [mac80211]()
[  463.301487] wlp5s0:  Failed check-sdata-in-driver check, flags: 0x0
[  463.305375] Modules linked in: netconsole(E) pps_ldisc(E) pps_core(E) vhost_net(E) vhost(E) macvtap(E) macvlan(E) nf_conntrack_netlink(E) nfnetlink(E) bridge(E) stp(E) llc(E) xt_tcpudp(E) xt_conntrack(E) iptable_filter(E) ipt_MASQUERADE(E) nf_nat_masquerade_ipv4(E) iptable_nat(E) nf_conntrack_ipv4(E) nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) iptable_mangle(E) ip_tables(E) x_tables(E) ppdev(E) intel_rapl(E) iosf_mbi(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm(E) crct10dif_pclmul(E) crc32_pclmul(E) arc4(E) ghash_clmulni_intel(E) cryptd(E) serio_raw(E) rtl8188ee(E) ath10k_pci(E) rtl_pci(E) lpc_ich(E) ath10k_core(E) rtlwifi(E) ath(E) option(E) usb_wwan(E) usbserial(E) snd_hda_codec_hdmi(E) mac80211(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) cfg80211(E) snd_hda_intel(E) i915(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E) drm_kms_helper(E) snd_pcm(E) snd_timer(E) drm(E) mei_me(E) snd(E) mei(E) soundcore(E) i2c_algo_bit(E)
shpchp(E) 8250_fintek(E) parport_pc(
E) qmi_wwan(E) cdc_wdm(E) video(E) usbnet(E) mac_hid(E) lp(E) parport(E) hid_generic(E) psmouse(E) usbhid(E) hid(E) pata_acpi(E) r8169(E) mii(E) configfs(E) [last unloaded: netconsole]
[  463.329769] CPU: 1 PID: 2439 Comm: iwconfig Tainted: G            E   4.0.4+ #1
[  463.333358] Hardware name: BIOSTAR Group NM70I-1037U/NM70I-1037U, BIOS 4.6.5 06/05/2013
[  463.337004]  ffffffffc06d2d74 ffff8800d23d7b98 ffffffff817b2128 0000000000000001
[  463.340784]  ffff8800d23d7be8 ffff8800d23d7bd8 ffffffff81075cfa 0000000000000000
[  463.344431]  ffff8800d20328c0 0000000000000001 0000000000040000 ffff880119f506a0
[  463.347806] Call Trace:
[  463.351149]  [<ffffffff817b2128>] dump_stack+0x45/0x57
[  463.354493]  [<ffffffff81075cfa>] warn_slowpath_common+0x8a/0xc0
[  463.357609]  [<ffffffff81075d76>] warn_slowpath_fmt+0x46/0x50
[  463.360720]  [<ffffffffc0655c69>] ieee80211_bss_info_change_notify+0x179/0x1d0 [mac80211]
[  463.363858]  [<ffffffffc066ab2d>] ieee80211_recalc_txpower+0x2d/0x40 [mac80211]
[  463.366987]  [<ffffffffc06726df>] ieee80211_set_tx_power+0x4f/0x1c0 [mac80211]
[  463.369924]  [<ffffffffc05d0458>] cfg80211_wext_siwtxpower+0xa8/0x1c0 [cfg80211]
[  463.372832]  [<ffffffff81796ac6>] ioctl_standard_call+0x56/0xe0
[  463.375705]  [<ffffffff817976b0>] ? iw_handler_get_private+0x70/0x70
[  463.378536]  [<ffffffff81796a70>] ? call_commit_handler+0x40/0x40
[  463.381151]  [<ffffffff81796016>] wireless_process_ioctl+0x176/0x1c0
[  463.383751]  [<ffffffff81796c49>] wext_handle_ioctl+0x69/0xb0
[  463.386327]  [<ffffffff816c3d92>] dev_ioctl+0x2f2/0x590
[  463.388909]  [<ffffffff811d3db2>] ? kmem_cache_alloc_trace+0x1e2/0x220
[  463.391505]  [<ffffffff8168e9a2>] sock_ioctl+0x132/0x2c0
[  463.391508]  [<ffffffff812048a8>] do_vfs_ioctl+0x2f8/0x510
[  463.391510]  [<ffffffff81204b41>] SyS_ioctl+0x81/0xa0
[  463.391514]  [<ffffffff817b9c0d>] system_call_fastpath+0x16/0x1b
[  463.391516] ---[ end trace 1cbc6978cc0030de ]---
[  464.849444] IPv6: ADDRCONF(NETDEV_UP): wlp5s0: link is not ready
[  464.852812] device wlp5s0 entered promiscuous mode
[  464.891435] BUG: unable to handle kernel NULL pointer dereference at 0000000000000006
[  464.893883] IP: [<ffffffffc073998e>] rtl_get_tcb_desc+0x5e/0x760 [rtlwifi]
[  464.896313] PGD 368cd067 PUD d49a8067 PMD 0
[  464.898739] Oops: 0002 [#1] SMP
[  464.901146] Modules linked in: netconsole(E) pps_ldisc(E) pps_core(E) vhost_net(E) vhost(E) macvtap(E) macvlan(E) nf_conntrack_netlink(E) nfnetlink(E) bridge(E) stp(E) llc(E) xt_tcpudp(E) xt_conntrack(E) iptable_filter(E) ipt_MASQUERADE(E) nf_nat_masquerade_ipv4(E) iptable_nat(E) nf_conntrack_ipv4(E) nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) iptable_mangle(E) ip_tables(E) x_tables(E) ppdev(E) intel_rapl(E) iosf_mbi(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm(E) crct10dif_pclmul(E) crc32_pclmul(E) arc4(E) ghash_clmulni_intel(E) cryptd(E) serio_raw(E) rtl8188ee(E) ath10k_pci(E) rtl_pci(E) lpc_ich(E) ath10k_core(E) rtlwifi(E) ath(E) option(E) usb_wwan(E) usbserial(E) snd_hda_codec_hdmi(E) mac80211(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) cfg80211(E) snd_hda_intel(E) i915(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E) drm_kms_helper(E) snd_pcm(E) snd_timer(E) drm(E) mei_me(E) snd(E) mei(E) soundcore(E) i2c_algo_bit(E)
shpchp(E) 8250_fintek(E) parport_pc(
E) qmi_wwan(E) cdc_wdm(E) video(E) usbnet(E) mac_hid(E) lp(E) parport(E) hid_generic(E) psmouse(E) usbhid(E) hid(E) pata_acpi(E) r8169(E) mii(E) configfs(E) [last unloaded: netconsole]
[  464.917354] CPU: 0 PID: 2610 Comm: hostapd Tainted: G        W   E   4.0.4+ #1
[  464.920124] Hardware name: BIOSTAR Group NM70I-1037U/NM70I-1037U, BIOS 4.6.5 06/05/2013
[  464.922902] task: ffff88003672db20 ti: ffff8800d2b48000 task.ti: ffff8800d2b48000
[  464.925678] RIP: 0010:[<ffffffffc073998e>]  [<ffffffffc073998e>] rtl_get_tcb_desc+0x5e/0x760 [rtlwifi]
[  464.928487] RSP: 0018:ffff8800d2b4b6d8  EFLAGS: 00010082
[  464.931286] RAX: 0000000000000000 RBX: ffff880119f506a0 RCX: 0000000000000000
[  464.934099] RDX: 0000000000000000 RSI: ffff880119f52848 RDI: ffff880119f506a0
[  464.936909] RBP: ffff8800d2b4b718 R08: 0000000000000000 R09: 0000000000000000
[  464.939689] R10: ffff8800d2033c38 R11: ffff8800d4ec8000 R12: ffff8800d3b8b528
[  464.942433] R13: ffff8800d2ae1420 R14: 0000000000000080 R15: ffff880119f522e0
[  464.945142] FS:  00007fc263cf6740(0000) GS:ffff88011f200000(0000) knlGS:0000000000000000
[  464.947870] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  464.950572] CR2: 0000000000000006 CR3: 00000000369c4000 CR4: 00000000001407f0
[  464.953256] Stack:
[  464.955864]  ffff8800d3b8b530 ffff8800d2ae1420 ffff8800d2b4b708 ffff8800d4ec8000
[  464.958450]  0000000000000000 ffff8800d2ae1420 ffff8800d3b8b500 ffff880119f522e0
[  464.960965]  ffff8800d2b4b798 ffffffffc071763c ffff8800d2b4b7a8 ffff880000000068
[  464.963415] Call Trace:
[  464.965772]  [<ffffffffc071763c>] rtl88ee_tx_fill_desc+0xac/0x8d0 [rtl8188ee]
[  464.968205]  [<ffffffffc066e36a>] ? rate_control_get_rate+0xda/0xf0 [mac80211]
[  464.970514]  [<ffffffffc03be55b>] rtl_pci_tx+0x18b/0x410 [rtl_pci]
[  464.972808]  [<ffffffffc073d78a>] rtl_op_bss_info_changed+0x6da/0x7b0 [rtlwifi]
[  464.975108]  [<ffffffffc067534a>] ? ieee80211_assign_beacon+0x5a/0x230 [mac80211]
[  464.977415]  [<ffffffffc0655bba>] ieee80211_bss_info_change_notify+0xca/0x1d0 [mac80211]
[  464.979733]  [<ffffffffc0675c49>] ieee80211_start_ap+0x409/0x4e0 [mac80211]
[  464.982086]  [<ffffffffc05abf07>] nl80211_start_ap+0x2f7/0x570 [cfg80211]
[  464.984437]  [<ffffffff816de615>] genl_family_rcv_msg+0x1a5/0x3d0
[  464.986757]  [<ffffffff816de840>] ? genl_family_rcv_msg+0x3d0/0x3d0
[  464.989060]  [<ffffffff816de8d1>] genl_rcv_msg+0x91/0xd0
[  464.991351]  [<ffffffff816ddb71>] netlink_rcv_skb+0xc1/0xe0
[  464.993631]  [<ffffffff816de21c>] genl_rcv+0x2c/0x40
[  464.995900]  [<ffffffff816dd216>] netlink_unicast+0xf6/0x200
[  464.998169]  [<ffffffff8101360f>] ? __switch_to+0x15f/0x570
[  465.000430]  [<ffffffff816dd73c>] netlink_sendmsg+0x41c/0x670
[  465.002692]  [<ffffffff8168ff77>] do_sock_sendmsg+0x87/0xb0
[  465.004947]  [<ffffffff81691b23>] ___sys_sendmsg+0x313/0x320
[  465.007197]  [<ffffffff813b92d3>] ? unlock_buckets+0x33/0x40
[  465.009443]  [<ffffffff816da182>] ? netlink_insert+0x92/0xe0
[  465.011690]  [<ffffffff810b7298>] ? __wake_up+0x48/0x60
[  465.013929]  [<ffffffff816dc32f>] ? netlink_table_ungrab+0x2f/0x40
[  465.016168]  [<ffffffff816dcaa9>] ? netlink_bind+0x169/0x240
[  465.018409]  [<ffffffff81692442>] __sys_sendmsg+0x42/0x80
[  465.020648]  [<ffffffff81692492>] SyS_sendmsg+0x12/0x20
[  465.022884]  [<ffffffff817b9c0d>] system_call_fastpath+0x16/0x1b
[  465.025118] Code: 0f 88 df 06 00 00 0f b6 76 04 48 8b 4f 38 48 8b b4 f1 d8 00 00 00 48 8d 0c 40 48 8b 46 08 48 8d 04 88 48 85 c0 74 08 0f b7 40 06 <41> 88 40 06 44 89 f0 83 e0 0c 66 83 f8 08 74 32 41 0f b6 40 03
[  465.027762] RIP  [<ffffffffc073998e>] rtl_get_tcb_desc+0x5e/0x760 [rtlwifi]
[  465.030150]  RSP <ffff8800d2b4b6d8>
[  465.032495] CR2: 0000000000000006
[  465.034836] ---[ end trace 1cbc6978cc0030df ]---
[  490.974925] ------------[ cut here ]------------
[  490.977230] WARNING: CPU: 0 PID: 2610 at kernel/watchdog.c:290 watchdog_overflow_callback+0x9a/0xc0()
[  490.979533] Watchdog detected hard LOCKUP on cpu 0
[  490.979559] Modules linked in: netconsole(E) pps_ldisc(E) pps_core(E) vhost_net(E) vhost(E) macvtap(E) macvlan(E) nf_conntrack_netlink(E) nfnetlink(E) bridge(E) stp(E) llc(E) xt_tcpudp(E) xt_conntrack(E) iptable_filter(E) ipt_MASQUERADE(E) nf_nat_masquerade_ipv4(E) iptable_nat(E) nf_conntrack_ipv4(E) nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) iptable_mangle(E) ip_tables(E) x_tables(E) ppdev(E) intel_rapl(E) iosf_mbi(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm(E) crct10dif_pclmul(E) crc32_pclmul(E) arc4(E) ghash_clmulni_intel(E) cryptd(E) serio_raw(E) rtl8188ee(E) ath10k_pci(E) rtl_pci(E) lpc_ich(E) ath10k_core(E) rtlwifi(E) ath(E) option(E) usb_wwan(E) usbserial(E) snd_hda_codec_hdmi(E) mac80211(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) cfg80211(E) snd_hda_intel(E) i915(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E) drm_kms_helper(E) snd_pcm(E) snd_timer(E) drm(E) mei_me(E) snd(E) mei(E) soundcore(E) i2c_algo_bit(E)
shpchp(E) 8250_fintek(E) parport_pc(
E) qmi_wwan(E) cdc_wdm(E) video(E) usbnet(E) mac_hid(E) lp(E) parport(E) hid_generic(E) psmouse(E) usbhid(E) hid(E) pata_acpi(E) r8169(E) mii(E) configfs(E) [last unloaded: netconsole]
[  490.997688] CPU: 0 PID: 2610 Comm: hostapd Tainted: G      D W   E   4.0.4+ #1
[  491.000355] Hardware name: BIOSTAR Group NM70I-1037U/NM70I-1037U, BIOS 4.6.5 06/05/2013
[  491.003048]  ffffffff81abcf07 ffff88011f205ac0 ffffffff817b2128 0000000000000000
[  491.005695]  ffff88011f205b10 ffff88011f205b00 ffffffff81075cfa 0000000000000000
[  491.008263]  ffff88011a814800 0000000000000000 ffff88011f205c40 0000000000000000
[  491.010762] Call Trace:
[  491.013163]  <NMI>  [<ffffffff817b2128>] dump_stack+0x45/0x57
[  491.015528]  [<ffffffff81075cfa>] warn_slowpath_common+0x8a/0xc0
[  491.017814]  [<ffffffff81075d76>] warn_slowpath_fmt+0x46/0x50
[  491.020081]  [<ffffffff8112c9da>] watchdog_overflow_callback+0x9a/0xc0
[  491.022337]  [<ffffffff8117192c>] __perf_event_overflow+0x8c/0x230
[  491.024578]  [<ffffffff8102cad7>] ? x86_perf_event_set_period+0xe7/0x150
[  491.026804]  [<ffffffff811723c4>] perf_event_overflow+0x14/0x20
[  491.029013]  [<ffffffff81033e9a>] intel_pmu_handle_irq+0x1ba/0x3a0
[  491.031218]  [<ffffffff8102b7bb>] perf_event_nmi_handler+0x2b/0x50
[  491.033423]  [<ffffffff81019338>] nmi_handle+0x88/0x120
[  491.035617]  [<ffffffff810198aa>] default_do_nmi+0x4a/0x140
[  491.037806]  [<ffffffff81019a28>] do_nmi+0x88/0xc0
[  491.039993]  [<ffffffff817bc101>] end_repeat_nmi+0x1e/0x2e
[  491.042160]  [<ffffffff817b9522>] ? _raw_spin_lock_irqsave+0x52/0x80
[  491.044315]  [<ffffffff817b9522>] ? _raw_spin_lock_irqsave+0x52/0x80
[  491.046450]  [<ffffffff817b9522>] ? _raw_spin_lock_irqsave+0x52/0x80
[  491.048557]  <<EOE>>  <IRQ>  [<ffffffffc03bff8f>] _rtl_pci_interrupt+0x5f/0x3d0 [rtl_pci]
[  491.050696]  [<ffffffff81050935>] ? msi_set_affinity+0x75/0x90
[  491.052820]  [<ffffffff810cee1e>] handle_irq_event_percpu+0x3e/0x1a0
[  491.054943]  [<ffffffff810cefc1>] handle_irq_event+0x41/0x70
[  491.057047]  [<ffffffff810d1f6f>] handle_edge_irq+0x7f/0x120
[  491.059139]  [<ffffffff81017732>] handle_irq+0x22/0x40
[  491.061220]  [<ffffffff817bcb61>] do_IRQ+0x51/0xf0
[  491.063291]  [<ffffffff817ba92d>] common_interrupt+0x6d/0x6d
[  491.065362]  [<ffffffff8101e129>] ? read_tsc+0x9/0x10
[  491.067425]  [<ffffffff81079faa>] ? __do_softirq+0x8a/0x2d0
[  491.069473]  [<ffffffff81079f40>] ? __do_softirq+0x20/0x2d0
[  491.071505]  [<ffffffff8107a4cd>] irq_exit+0xfd/0x110
[  491.073524]  [<ffffffff817bcc4a>] smp_apic_timer_interrupt+0x4a/0x60
[  491.075553]  [<ffffffff817bacad>] apic_timer_interrupt+0x6d/0x80
[  491.077586]  <EOI>  [<ffffffff810ff0f1>] ? acct_collect+0x191/0x200
[  491.079641]  [<ffffffff810ff09a>] ? acct_collect+0x13a/0x200
[  491.081692]  [<ffffffff81078798>] do_exit+0x758/0xb30
[  491.083739]  [<ffffffff81018a18>] oops_end+0xa8/0x120
[  491.085785]  [<ffffffff817ad6dc>] no_context+0x2df/0x343
[  491.087833]  [<ffffffff817ad7b3>] __bad_area_nosemaphore+0x73/0x1cc
[  491.089886]  [<ffffffff817adaf1>] bad_area+0x44/0x4c
[  491.091938]  [<ffffffff8106307a>] __do_page_fault+0x2fa/0x440
[  491.093993]  [<ffffffff810631f1>] do_page_fault+0x31/0x70
[  491.096050]  [<ffffffff817bbdc8>] page_fault+0x28/0x30
[  491.098111]  [<ffffffffc073998e>] ? rtl_get_tcb_desc+0x5e/0x760 [rtlwifi]
[  491.100186]  [<ffffffffc071763c>] rtl88ee_tx_fill_desc+0xac/0x8d0 [rtl8188ee]
[  491.102278]  [<ffffffffc066e36a>] ? rate_control_get_rate+0xda/0xf0 [mac80211]
[  491.104371]  [<ffffffffc03be55b>] rtl_pci_tx+0x18b/0x410 [rtl_pci]
[  491.106467]  [<ffffffffc073d78a>] rtl_op_bss_info_changed+0x6da/0x7b0 [rtlwifi]
[  491.108582]  [<ffffffffc067534a>] ? ieee80211_assign_beacon+0x5a/0x230 [mac80211]
[  491.110701]  [<ffffffffc0655bba>] ieee80211_bss_info_change_notify+0xca/0x1d0 [mac80211]
[  491.112742]  [<ffffffffc0675c49>] ieee80211_start_ap+0x409/0x4e0 [mac80211]
[  491.114702]  [<ffffffffc05abf07>] nl80211_start_ap+0x2f7/0x570 [cfg80211]
[  491.116645]  [<ffffffff816de615>] genl_family_rcv_msg+0x1a5/0x3d0
[  491.118590]  [<ffffffff816de840>] ? genl_family_rcv_msg+0x3d0/0x3d0
[  491.120531]  [<ffffffff816de8d1>] genl_rcv_msg+0x91/0xd0
[  491.122469]  [<ffffffff816ddb71>] netlink_rcv_skb+0xc1/0xe0
[  491.124386]  [<ffffffff816de21c>] genl_rcv+0x2c/0x40
[  491.126281]  [<ffffffff816dd216>] netlink_unicast+0xf6/0x200
[  491.128112]  [<ffffffff8101360f>] ? __switch_to+0x15f/0x570
[  491.129863]  [<ffffffff816dd73c>] netlink_sendmsg+0x41c/0x670
[  491.131545]  [<ffffffff8168ff77>] do_sock_sendmsg+0x87/0xb0
[  491.133150]  [<ffffffff81691b23>] ___sys_sendmsg+0x313/0x320
[  491.134685]  [<ffffffff813b92d3>] ? unlock_buckets+0x33/0x40
[  491.136143]  [<ffffffff816da182>] ? netlink_insert+0x92/0xe0
[  491.137585]  [<ffffffff810b7298>] ? __wake_up+0x48/0x60
[  491.139005]  [<ffffffff816dc32f>] ? netlink_table_ungrab+0x2f/0x40
[  491.140413]  [<ffffffff816dcaa9>] ? netlink_bind+0x169/0x240
[  491.141820]  [<ffffffff81692442>] __sys_sendmsg+0x42/0x80
[  491.143220]  [<ffffffff81692492>] SyS_sendmsg+0x12/0x20
[  491.144609]  [<ffffffff817b9c0d>] system_call_fastpath+0x16/0x1b
[  491.145992] ---[ end trace 1cbc6978cc0030e0 ]---

