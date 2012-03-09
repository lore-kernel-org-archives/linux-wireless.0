Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53170 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab2CIJs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 04:48:27 -0500
Received: by vbbff1 with SMTP id ff1so1215932vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 01:48:27 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 9 Mar 2012 17:48:26 +0800
Message-ID: <CAHPDcRubbrgA_t_V4D-ass0Mc1oCfyg5QgVz+R-7=ovOaRYKDA@mail.gmail.com> (sfid-20120309_104847_259924_A0EC5CE4)
Subject: [wl1271] kernel panic when wl1271 firmware recovery during ieee80211_hw_config?
From: Yingang Fu <yingang.fu@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi, all

My phone hung due to following logs.

>From the log, i found that the wl1271_cmd_send failed due to
CMD_STATUS_WRONG_NESTING status after send a command to firmware.
After the wl1271 recovery work been processed, the kernel panic:

<6>[ 2316.834622] cfg80211: World regulatory domain updated:
<6>[ 2316.834638] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
<6>[ 2316.834653] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000
KHz), (300 mBi, 2000 mBm)
<6>[ 2316.834666] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000
KHz), (300 mBi, 2000 mBm)
<6>[ 2316.834678] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000
KHz), (300 mBi, 2000 mBm)
<6>[ 2316.834691] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000
KHz), (300 mBi, 2000 mBm)
<6>[ 2316.834703] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000
KHz), (300 mBi, 2000 mBm)
<6>[ 2316.834783] cfg80211: Calling CRDA for country: CN
<6>[ 2316.843503] cfg80211: Regulatory domain changed to country: CN
<6>[ 2316.843522] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
<6>[ 2316.843542] cfg80211:     (2402000 KHz - 2482000 KHz @ 40000
KHz), (N/A, 2000 mBm)
<6>[ 2316.843558] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000
KHz), (N/A, 3000 mBm)
<7>[ 2317.326674] wlan0: authenticate with 00:1e:e5:f6:02:55 (try 1)
<7>[ 2317.329246] wlan0: authenticated
<7>[ 2317.366830] wlan0: associate with 00:1e:e5:f6:02:55 (try 1)
<7>[ 2317.370199] wlan0: RX ReassocResp from 00:1e:e5:f6:02:55
(capab=0x411 status=0 aid=14)
<7>[ 2317.370217] wlan0: associated
<6>[ 2318.379418] wl1271: Association completed.
<6>[ 2318.597532] **** Socket bind to device (ŒÚ/ÁÀÁæÝÞÝÞ) perm enabled./n
<7>[ 2332.018008] wlan0: deauthenticated from 00:1e:e5:f6:02:55 (Reason: 7)
<6>[ 2332.146016] cfg80211: Calling CRDA to update world regulatory domain
<6>[ 2332.160506] cfg80211: World regulatory domain updated:
<6>[ 2332.160528] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
<6>[ 2332.160551] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000
KHz), (300 mBi, 2000 mBm)
<6>[ 2332.160570] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000
KHz), (300 mBi, 2000 mBm)
<6>[ 2332.160588] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000
KHz), (300 mBi, 2000 mBm)
<6>[ 2332.160607] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000
KHz), (300 mBi, 2000 mBm)
<6>[ 2332.160625] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000
KHz), (300 mBi, 2000 mBm)
<6>[ 2332.160732] cfg80211: Calling CRDA for country: CN
<6>[ 2332.172836] cfg80211: Regulatory domain changed to country: CN
<6>[ 2332.172859] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
<6>[ 2332.172881] cfg80211:     (2402000 KHz - 2482000 KHz @ 40000
KHz), (N/A, 2000 mBm)
<6>[ 2332.172898] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000
KHz), (N/A, 3000 mBm)
<3>[ 2332.230758] wl1271: ERROR command execute failure 19
<4>[ 2332.231197] ------------[ cut here ]------------
<4>[ 2332.231250] WARNING: at
/home/svnadmin/git/bbdevr2/hardware/ti/wlan/wl12xx-compat/drivers/net/wireless/wl12xx/cmd.c:107
wl1271_cmd_send+0x2ca/0x320 [wl12xx]()
<4>[ 2332.231269] Modules linked in: atomisp lm3554 mt9m114 mt9e013
videobuf_vmalloc videobuf_dma_contig videobuf_core wl12xx_sdio wl12xx
mac80211 cfg80211 compat btwilink st_drv
<4>[ 2332.231353] Pid: 1527, comm: wpa_supplicant Not tainted 2.6.35.3+ #1
<4>[ 2332.231365] Call Trace:
<4>[ 2332.231576]  [<c18313e9>] ? printk+0x1d/0x1f
<4>[ 2332.231610]  [<c124637b>] warn_slowpath_common+0x6b/0x100
<4>[ 2332.231645]  [<fb8b5cda>] ? wl1271_cmd_send+0x2ca/0x320 [wl12xx]
<4>[ 2332.231673]  [<fb8b5cda>] ? wl1271_cmd_send+0x2ca/0x320 [wl12xx]
<4>[ 2332.231697]  [<c1246432>] warn_slowpath_null+0x22/0x30
<4>[ 2332.231725]  [<fb8b5cda>] wl1271_cmd_send+0x2ca/0x320 [wl12xx]
<4>[ 2332.231759]  [<fb8b9aa0>] wl1271_start_dev+0xd0/0x420 [wl12xx]
<4>[ 2332.231791]  [<fb8b16fc>]
wl1271_queue_recovery_work+0x14ac/0x17e0 [wl12xx]
<4>[ 2332.231829]  [<f8dc2a68>] ?
ieee80211_bss_info_change_notify+0xe8/0x370 [mac80211]
<4>[ 2332.231864]  [<f8dc213e>] ieee80211_hw_config+0xce/0x140 [mac80211]
<4>[ 2332.231903]  [<f8dd28a2>] ieee80211_recalc_idle+0x42/0x60 [mac80211]
<4>[ 2332.231939]  [<f8dc7c8b>] ieee80211_scan_cancel+0x1ab/0x360 [mac80211]
<4>[ 2332.231964]  [<c12f8598>] ? __kmalloc+0xb8/0x1d0
<4>[ 2332.231999]  [<f8dc800f>] ieee80211_request_scan+0x2f/0x50 [mac80211]
<4>[ 2332.232037]  [<f8dd7088>] ieee80211_aes_cmac+0xe38/0x2200 [mac80211]
<4>[ 2332.232072]  [<f8d70e8a>]
nl80211_send_new_peer_candidate+0xa1a/0x1be0 [cfg80211]
<4>[ 2332.232097]  [<c16fb21d>] ? dev_get_by_index+0x5d/0x80
<4>[ 2332.232129]  [<f879c1ab>] vzalloc+0x14b/0x200 [compat]
<4>[ 2332.232160]  [<c17157cc>] genl_rcv_msg+0x1ec/0x220
<4>[ 2332.232189]  [<c17155e0>] ? genl_rcv_msg+0x0/0x220
<4>[ 2332.232210]  [<c1713f36>] netlink_rcv_skb+0x86/0xb0
<4>[ 2332.232232]  [<c17155b0>] ? genl_rcv+0x0/0x30
<4>[ 2332.232252]  [<c17155d1>] genl_rcv+0x21/0x30
<4>[ 2332.232274]  [<c1713b81>] netlink_unicast+0x461/0x4b0
<4>[ 2332.232296]  [<c1714f50>] ? netlink_sendmsg+0x110/0x2c0
<4>[ 2332.232321]  [<c16f3ffb>] ? memcpy_fromiovec+0x4b/0x70
<4>[ 2332.232344]  [<c1714ff4>] netlink_sendmsg+0x1b4/0x2c0
<4>[ 2332.232372]  [<c126eb85>] ? sched_clock_cpu+0x435/0x480
<4>[ 2332.232396]  [<c16e7c97>] sock_sendmsg+0xe7/0x100
<4>[ 2332.232425]  [<c18351c3>] ? _raw_spin_unlock_irqrestore+0x23/0x50
<4>[ 2332.232450]  [<c123ca94>] ? try_to_wake_up+0x1a4/0x300
<4>[ 2332.232475]  [<c123cc00>] ? default_wake_function+0x10/0x20
<4>[ 2332.232500]  [<c16e755d>] ? copy_from_user+0xd/0x10
<4>[ 2332.232522]  [<c16f3cfa>] ? verify_iovec+0x5a/0xa0
<4>[ 2332.232542]  [<c16e9dc3>] sys_sendmsg+0x113/0x220
<4>[ 2332.232572]  [<c12ff6d1>] ? do_sync_readv_writev+0xb1/0x110
<4>[ 2332.232602]  [<c12ff9b2>] ? rw_verify_area+0x62/0xd0
<4>[ 2332.232630]  [<c16ea574>] sys_socketcall+0x1c4/0x4b0
<4>[ 2332.232654]  [<c1273061>] ? getnstimeofday+0x51/0x110
<4>[ 2332.232679]  [<c1300c92>] ? sys_writev+0x82/0xb0
<4>[ 2332.232701]  [<c18359a9>] syscall_call+0x7/0xb
<4>[ 2332.232725]  [<c1830000>] ? remote_softirq_cpu_notify+0x2f/0x8b
<4>[ 2332.232742] ---[ end trace 801365373a990aa0 ]---
<3>[ 2332.232769] wl1271: ERROR failed to initiate cmd role enable
<4>[ 2332.242201] wl1271: WARNING idle mode change failed -5
<6>[ 2332.242321] wl1271: Hardware recovery in progress. FW ver: Rev
7.3.2.I15.79 pc: 0x0
<6>[ 2332.242345] wl1271: down
<1>[ 2332.242396] BUG: unable to handle kernel paging request at fffffd94
<1>[ 2332.248613] IP: [<f8ddd8c4>] ieee80211_probereq_get+0x14/0x160 [mac80211]
<4>[ 2332.255400] *pde = 01b5b067 *pte = 00000000
<0>[ 2332.259661] Oops: 0000 [#1] PREEMPT SMP
<0>[ 2332.263570] last sysfs file:
/sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state
<4>[ 2332.271403] Modules linked in: atomisp lm3554 mt9m114 mt9e013
videobuf_vmalloc videobuf_dma_contig videobuf_core wl12xx_sdio wl12xx
mac80211 cfg80211 compat btwilink st_drv
<4>[ 2332.286783]
<4>[ 2332.288276] Pid: 1527, comm: wpa_supplicant Tainted: G        W
 2.6.35.3+ #1 /
<4>[ 2332.295664] EIP: 0060:[<f8ddd8c4>] EFLAGS: 00010292 CPU: 0
<4>[ 2332.301163] EIP is at ieee80211_probereq_get+0x14/0x160 [mac80211]
<4>[ 2332.307310] EAX: 00000000 EBX: e851efe0 ECX: e851f266 EDX: 00000000
<4>[ 2332.313571] ESI: e851e2e0 EDI: 00000000 EBP: df5bfa9c ESP: df5bfa7c
<4>[ 2332.319841]  DS: 007b ES: 007b FS: 00d8 GS: 003b SS: 0068
<0>[ 2332.325225] Process wpa_supplicant (pid: 1527, ti=df5be000
task=dfbb8f00 task.ti=df5be000)
<0>[ 2332.333472] Stack:
<4>[ 2332.335471]  c124d2f3 df5bfaac e851f266 00000001 00000282
e851efe0 e851e2e0 00000000
<4>[ 2332.343033] <0> df5bfac8 fb8b7d29 00000000 e15cea7c 000000b1
c1235995 fb8c8745 00000202
<4>[ 2332.351031] <0> e851efe0 e851f266 e15cea00 df5bfb10 fb8c888b
e15cea7c 000000b1 00000000
<0>[ 2332.359203] Call Trace:
<4>[ 2332.361664]  [<c124d2f3>] ? irq_exit+0x73/0x90
<4>[ 2332.366116]  [<fb8b7d29>] ? wl1271_cmd_build_probe_req+0x39/0x120 [wl12xx]
<4>[ 2332.372960]  [<c1235995>] ? sub_preempt_count+0x85/0xc0
<4>[ 2332.378191]  [<fb8c8745>] ? wl1271_scan_stop+0x195/0x660 [wl12xx]
<4>[ 2332.384273]  [<fb8c888b>] ? wl1271_scan_stop+0x2db/0x660 [wl12xx]
<4>[ 2332.390369]  [<fb8c8cfa>] ? wl1271_scan_stm+0xea/0x1f0 [wl12xx]
<4>[ 2332.396271]  [<fb8c8e7e>] ? wl1271_scan+0x7e/0xb0 [wl12xx]
<4>[ 2332.401747]  [<fb8b0206>] ? wl1271_is_active_sta+0xa86/0xad0 [wl12xx]
<4>[ 2332.408196]  [<f8dc7d61>] ? ieee80211_scan_cancel+0x281/0x360 [mac80211]
<4>[ 2332.414891]  [<f8dc800f>] ? ieee80211_request_scan+0x2f/0x50 [mac80211]
<4>[ 2332.421498]  [<f8dd7088>] ? ieee80211_aes_cmac+0xe38/0x2200 [mac80211]
<4>[ 2332.428027]  [<f8d70e8a>] ?
nl80211_send_new_peer_candidate+0xa1a/0x1be0 [cfg80211]
<4>[ 2332.435655]  [<c16fb21d>] ? dev_get_by_index+0x5d/0x80
<4>[ 2332.440802]  [<f879c1ab>] ? vzalloc+0x14b/0x200 [compat]
<4>[ 2332.446100]  [<c17157cc>] ? genl_rcv_msg+0x1ec/0x220
<4>[ 2332.451052]  [<c17155e0>] ? genl_rcv_msg+0x0/0x220
<4>[ 2332.455826]  [<c1713f36>] ? netlink_rcv_skb+0x86/0xb0
<4>[ 2332.460865]  [<c17155b0>] ? genl_rcv+0x0/0x30
<4>[ 2332.465211]  [<c17155d1>] ? genl_rcv+0x21/0x30
<4>[ 2332.469650]  [<c1713b81>] ? netlink_unicast+0x461/0x4b0
<4>[ 2332.474864]  [<c1714f50>] ? netlink_sendmsg+0x110/0x2c0
<4>[ 2332.480086]  [<c16f3ffb>] ? memcpy_fromiovec+0x4b/0x70
<4>[ 2332.485211]  [<c1714ff4>] ? netlink_sendmsg+0x1b4/0x2c0
<4>[ 2332.490436]  [<c126eb85>] ? sched_clock_cpu+0x435/0x480
<4>[ 2332.495643]  [<c16e7c97>] ? sock_sendmsg+0xe7/0x100
<4>[ 2332.500527]  [<c18351c3>] ? _raw_spin_unlock_irqrestore+0x23/0x50
<4>[ 2332.506601]  [<c123ca94>] ? try_to_wake_up+0x1a4/0x300
<4>[ 2332.511732]  [<c123cc00>] ? default_wake_function+0x10/0x20
<4>[ 2332.517298]  [<c16e755d>] ? copy_from_user+0xd/0x10
<4>[ 2332.522158]  [<c16f3cfa>] ? verify_iovec+0x5a/0xa0
<4>[ 2332.526942]  [<c16e9dc3>] ? sys_sendmsg+0x113/0x220
<4>[ 2332.531824]  [<c12ff6d1>] ? do_sync_readv_writev+0xb1/0x110
<4>[ 2332.537388]  [<c12ff9b2>] ? rw_verify_area+0x62/0xd0
<4>[ 2332.542337]  [<c16ea574>] ? sys_socketcall+0x1c4/0x4b0
<4>[ 2332.547464]  [<c1273061>] ? getnstimeofday+0x51/0x110
<4>[ 2332.552503]  [<c1300c92>] ? sys_writev+0x82/0xb0
<4>[ 2332.557112]  [<c18359a9>] ? syscall_call+0x7/0xb
<4>[ 2332.561720]  [<c1830000>] ? remote_softirq_cpu_notify+0x2f/0x8b
<0>[ 2332.567615] Code: 8b 7c 24 08 89 ec 5d c3 eb 0d 90 90 90 90 90
90 90 90 90 90 90 90 90 55 89 e5 57 56 53 83 ec 14 0f 1f 44 00 00 8b
45 08 89 4d e8 <8b> ba 94 fd ff ff 89 d6 83 c0 02 89 45 f0 8b 55 f0 8b
47 34 8d
<0>[ 2332.586479] EIP: [<f8ddd8c4>] ieee80211_probereq_get+0x14/0x160
[mac80211] SS:ESP 0068:df5bfa7c
<0>[ 2332.595174] CR2: 00000000fffffd94
<4>[ 2332.598485] ---[ end trace 801365373a990aa1 ]---
<0>[ 2332.603086] Kernel panic - not syncing: Fatal exception
<4>[ 2332.608311] Pid: 1527, comm: wpa_supplicant Tainted: G      D W
 2.6.35.3+ #1
<4>[ 2332.615516] Call Trace:
<4>[ 2332.617968]  [<c18313e9>] ? printk+0x1d/0x1f
<4>[ 2332.622226]  [<c1831360>] panic+0x64/0xd0
<4>[ 2332.626228]  [<c1206823>] oops_end+0x83/0x90
<4>[ 2332.630487]  [<c122c376>] no_context+0xc6/0x1f0
<4>[ 2332.635010]  [<c122c530>] __bad_area_nosemaphore+0x90/0x130
<4>[ 2332.640571]  [<c1262321>] ? insert_work+0x61/0xc0
<4>[ 2332.645270]  [<c18351c3>] ? _raw_spin_unlock_irqrestore+0x23/0x50
<4>[ 2332.651404]  [<c122c870>] ? do_page_fault+0x0/0x2c0
<4>[ 2332.656291]  [<c122c5e7>] bad_area_nosemaphore+0x17/0x20
<4>[ 2332.661580]  [<c122ca95>] do_page_fault+0x225/0x2c0
<4>[ 2332.666455]  [<c18351c3>] ? _raw_spin_unlock_irqrestore+0x23/0x50
<4>[ 2332.672538]  [<c15e9308>] ? sdhci_tasklet_finish+0xc8/0x140
<4>[ 2332.678100]  [<c124caf2>] ? tasklet_action+0xe2/0xf0
<4>[ 2332.683051]  [<c122c870>] ? do_page_fault+0x0/0x2c0
<4>[ 2332.687924]  [<c122c870>] ? do_page_fault+0x0/0x2c0
<4>[ 2332.692787]  [<c183601b>] error_code+0x6b/0x70
<4>[ 2332.697227]  [<c122c870>] ? do_page_fault+0x0/0x2c0
<4>[ 2332.702120]  [<f8ddd8c4>] ? ieee80211_probereq_get+0x14/0x160 [mac80211]
<4>[ 2332.708790]  [<c124d2f3>] ? irq_exit+0x73/0x90
<4>[ 2332.713240]  [<fb8b7d29>] wl1271_cmd_build_probe_req+0x39/0x120 [wl12xx]
<4>[ 2332.719921]  [<c1235995>] ? sub_preempt_count+0x85/0xc0
<4>[ 2332.725144]  [<fb8c8745>] ? wl1271_scan_stop+0x195/0x660 [wl12xx]
<4>[ 2332.731233]  [<fb8c888b>] wl1271_scan_stop+0x2db/0x660 [wl12xx]
<4>[ 2332.737148]  [<fb8c8cfa>] wl1271_scan_stm+0xea/0x1f0 [wl12xx]
<4>[ 2332.742876]  [<fb8c8e7e>] wl1271_scan+0x7e/0xb0 [wl12xx]
<4>[ 2332.748183]  [<fb8b0206>] wl1271_is_active_sta+0xa86/0xad0 [wl12xx]
<4>[ 2332.754452]  [<f8dc7d61>] ieee80211_scan_cancel+0x281/0x360 [mac80211]
<4>[ 2332.760979]  [<f8dc800f>] ieee80211_request_scan+0x2f/0x50 [mac80211]
<4>[ 2332.767410]  [<f8dd7088>] ieee80211_aes_cmac+0xe38/0x2200 [mac80211]
<4>[ 2332.773748]  [<f8d70e8a>]
nl80211_send_new_peer_candidate+0xa1a/0x1be0 [cfg80211]
<4>[ 2332.781212]  [<c16fb21d>] ? dev_get_by_index+0x5d/0x80
<4>[ 2332.786355]  [<f879c1ab>] vzalloc+0x14b/0x200 [compat]
<4>[ 2332.791477]  [<c17157cc>] genl_rcv_msg+0x1ec/0x220
<4>[ 2332.796262]  [<c17155e0>] ? genl_rcv_msg+0x0/0x220
<4>[ 2332.801029]  [<c1713f36>] netlink_rcv_skb+0x86/0xb0
<4>[ 2332.805904]  [<c17155b0>] ? genl_rcv+0x0/0x30
<4>[ 2332.810246]  [<c17155d1>] genl_rcv+0x21/0x30
<4>[ 2332.814506]  [<c1713b81>] netlink_unicast+0x461/0x4b0
<4>[ 2332.819556]  [<c1714f50>] ? netlink_sendmsg+0x110/0x2c0
<4>[ 2332.824770]  [<c16f3ffb>] ? memcpy_fromiovec+0x4b/0x70
<4>[ 2332.829899]  [<c1714ff4>] netlink_sendmsg+0x1b4/0x2c0
<4>[ 2332.834942]  [<c126eb85>] ? sched_clock_cpu+0x435/0x480
<4>[ 2332.840158]  [<c16e7c97>] sock_sendmsg+0xe7/0x100
<4>[ 2332.844858]  [<c18351c3>] ? _raw_spin_unlock_irqrestore+0x23/0x50
<4>[ 2332.850939]  [<c123ca94>] ? try_to_wake_up+0x1a4/0x300
<4>[ 2332.856070]  [<c123cc00>] ? default_wake_function+0x10/0x20
<4>[ 2332.861632]  [<c16e755d>] ? copy_from_user+0xd/0x10
<4>[ 2332.866499]  [<c16f3cfa>] ? verify_iovec+0x5a/0xa0
<4>[ 2332.871278]  [<c16e9dc3>] sys_sendmsg+0x113/0x220
<4>[ 2332.875986]  [<c12ff6d1>] ? do_sync_readv_writev+0xb1/0x110
<4>[ 2332.881544]  [<c12ff9b2>] ? rw_verify_area+0x62/0xd0
<4>[ 2332.886501]  [<c16ea574>] sys_socketcall+0x1c4/0x4b0
<4>[ 2332.891453]  [<c1273061>] ? getnstimeofday+0x51/0x110
<4>[ 2332.896495]  [<c1300c92>] ? sys_writev+0x82/0xb0
<4>[ 2332.901100]  [<c18359a9>] syscall_call+0x7/0xb
<4>[ 2332.905536]  [<c1830000>] ? remote_softirq_cpu_notify+0x2f/0x8b
<6>[ 2332.911464] Acquire ownership - eMMC owner: 1, IA req: 1, SCU req: 0
<6>[ 2332.918040] sdhci_pci_power_up_host: host controller power up is done
