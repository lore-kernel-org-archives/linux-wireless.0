Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYEWSQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 14:16:19 -0400
Subject: Re: [PATCH, take 2] libertas: fix compact flash interrupt handling
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200805231605.04168.hs4233@mail.mn-solutions.de>
References: <200805231605.04168.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 23 May 2008 14:16:06 -0400
Message-Id: <1211566566.12312.4.camel@localhost.localdomain> (sfid-20080523_201624_906194_C8F45782)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-23 at 16:05 +0200, Holger Schurig wrote:
> [PATCH] libertas: fix compact flash interrupt handling
> 
> The old code misbehaved because it polled card status and always
> called the "tx over" code-path.

Interesting problem here with all 3 of these patches applied, and the
check for the event fifo moved before the priv->cur_cmd check.  Just
scp-ing a 697MB ISO

May 23 13:52:29 localhost dhclient: bound to 192.168.1.12 -- renewal in 51 seconds.
May 23 13:55:04 localhost kernel: NETDEV WATCHDOG: eth2: transmit timed out
May 23 13:55:04 localhost kernel: libertas: tx watch dog timeout
May 23 13:55:07 localhost kernel: libertas: command 0x000b timed out
May 23 13:55:07 localhost kernel: libertas: requeueing command 0x000b due to timeout (#1)
May 23 13:55:10 localhost kernel: libertas: command 0x000b timed out
May 23 13:55:10 localhost kernel: libertas: requeueing command 0x000b due to timeout (#2)
May 23 13:55:13 localhost kernel: libertas: command 0x000b timed out
May 23 13:55:13 localhost kernel: libertas: requeueing command 0x000b due to timeout (#3)
May 23 13:55:14 localhost kernel: NETDEV WATCHDOG: eth2: transmit timed out
May 23 13:55:14 localhost kernel: libertas: tx watch dog timeout
May 23 13:55:16 localhost kernel: libertas: command 0x000b timed out
May 23 13:55:16 localhost kernel: libertas: Excessive timeouts submitting command 0x000b
May 23 13:55:16 localhost kernel: libertas: PREP_CMD: command 0x000b failed: -110
May 23 13:55:24 localhost kernel: NETDEV WATCHDOG: eth2: transmit timed out
May 23 13:55:24 localhost kernel: libertas: tx watch dog timeout
May 23 13:55:27 localhost kernel: libertas: command 0x001f timed out
May 23 13:55:27 localhost kernel: libertas: requeueing command 0x001f due to timeout (#1)
May 23 13:55:30 localhost kernel: libertas: command 0x001f timed out
May 23 13:55:30 localhost kernel: libertas: requeueing command 0x001f due to timeout (#2)
May 23 13:55:33 localhost kernel: libertas: command 0x001f timed out
May 23 13:55:33 localhost kernel: libertas: requeueing command 0x001f due to timeout (#3)
May 23 13:55:34 localhost kernel: NETDEV WATCHDOG: eth2: transmit timed out
May 23 13:55:34 localhost kernel: libertas: tx watch dog timeout
May 23 13:55:36 localhost kernel: libertas: command 0x001f timed out
May 23 13:55:36 localhost kernel: libertas: Excessive timeouts submitting command 0x001f
May 23 13:55:38 localhost kernel: list_add corruption. prev->next should be next (cfa6117c), but was cfa61174. (prev=d35dda74).
May 23 13:55:38 localhost kernel: ------------[ cut here ]------------
May 23 13:55:38 localhost kernel: kernel BUG at lib/list_debug.c:33!
May 23 13:55:38 localhost kernel: invalid opcode: 0000 [#1] SMP 
May 23 13:55:38 localhost kernel: Modules linked in: libertas_cs libertas ieee80211 ieee80211_crypt vfat fat usb_storage bridge bnep rfcomm l2cap bluetooth fuse nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables cpufreq_ondemand acpi_cpufreq i915 drm ipv6 snd_intel8x0m snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy input_polldev snd_seq_oss snd_seq_midi_event snd_seq arc4 snd_seq_device snd_pcm_oss ecb crypto_blkcipher fujitsu_laptop snd_mixer_oss pcspkr sg joydev sdhci 8139cp serio_raw snd_pcm mmc_core 8139too mac80211 mii cfg80211 i2c_i801 iTCO_wdt iTCO_vendor_support snd_timer i2c_core snd soundcore snd_page_alloc video output battery ac button dm_snapshot dm_zero dm_mirror dm_log dm_mod ata_piix pata_acpi ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: ath5k]
May 23 13:55:38 localhost kernel: 
May 23 13:55:38 localhost kernel: Pid: 4424, comm: iwconfig Tainted: G        W (2.6.26-0.25.rc3.git4.fc10.i686 #1)
May 23 13:55:38 localhost kernel: EIP: 0060:[drm:__list_add+52/74] EFLAGS: 00010046 CPU: 0
May 23 13:55:38 localhost kernel: EIP is at __list_add+0x34/0x4a
May 23 13:55:38 localhost kernel: EAX: 00000061 EBX: d35ddab8 ECX: c0420efb EDX: 00000000
May 23 13:55:38 localhost kernel: ESI: d35ddab8 EDI: cfa60580 EBP: d35fad58 ESP: d35fad44
May 23 13:55:38 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
May 23 13:55:38 localhost kernel: Process iwconfig (pid: 4424, ti=d35fa000 task=dd5317e0 task.ti=d35fa000)
May 23 13:55:38 localhost kernel: Stack: c06ffe8c cfa6117c cfa61174 d35dda74 00000001 d35fad74 e07b7c10 cfa623dc 
May 23 13:55:38 localhost kernel:        00000283 cf8b9890 0000001f 00000000 d35fadac e07ba391 00000000 cfa60580 
May 23 13:55:38 localhost kernel:        d35ddab8 00000282 00000000 dd5317e0 c043bc1b d35fad98 d35fad98 cfa60580 
May 23 13:55:38 localhost kernel: Call Trace:
May 23 13:55:38 localhost kernel:  [<e07b7c10>] ? lbs_queue_cmd+0x113/0x1a9 [libertas]
May 23 13:55:38 localhost kernel:  [<e07ba391>] ? lbs_prepare_and_send_command+0xea9/0x1041 [libertas]
May 23 13:55:38 localhost kernel:  [<c043bc1b>] ? autoremove_wake_function+0x0/0x33
May 23 13:55:38 localhost kernel:  [<e07b65db>] ? lbs_get_wireless_stats+0x255/0x2d6 [libertas]
May 23 13:55:38 localhost kernel:  [check_object+308/395] ? check_object+0x134/0x18b
May 23 13:55:38 localhost kernel:  [iw_handler_get_iwstats+27/78] ? iw_handler_get_iwstats+0x1b/0x4e
May 23 13:55:38 localhost kernel:  [ioctl_standard_call+474/667] ? ioctl_standard_call+0x1da/0x29b
May 23 13:55:38 localhost kernel:  [wext_handle_ioctl+267/862] ? wext_handle_ioctl+0x10b/0x35e
May 23 13:55:38 localhost kernel:  [iw_handler_get_iwstats+0/78] ? iw_handler_get_iwstats+0x0/0x4e
May 23 13:55:38 localhost kernel:  [dev_ioctl+1468/1500] ? dev_ioctl+0x5bc/0x5dc
May 23 13:55:38 localhost kernel:  [inotify_d_instantiate+21/60] ? inotify_d_instantiate+0x15/0x3c
May 23 13:55:38 localhost kernel:  [sock_ioctl+0/471] ? sock_ioctl+0x0/0x1d7
May 23 13:55:38 localhost kernel:  [sock_ioctl+459/471] ? sock_ioctl+0x1cb/0x1d7
May 23 13:55:38 localhost kernel:  [sock_ioctl+0/471] ? sock_ioctl+0x0/0x1d7
May 23 13:55:38 localhost kernel:  [vfs_ioctl+34/105] ? vfs_ioctl+0x22/0x69
May 23 13:55:38 localhost kernel:  [do_vfs_ioctl+569/588] ? do_vfs_ioctl+0x239/0x24c
May 23 13:55:38 localhost kernel:  [selinux_file_ioctl+53/56] ? selinux_file_ioctl+0x35/0x38
May 23 13:55:38 localhost kernel:  [sys_ioctl+64/91] ? sys_ioctl+0x40/0x5b
May 23 13:55:38 localhost kernel:  [syscall_call+7/11] ? syscall_call+0x7/0xb
May 23 13:55:38 localhost kernel:  =======================
May 23 13:55:38 localhost kernel: Code: 39 d0 74 14 51 50 52 68 3c fe 6f c0 e8 83 fd 13 00 0f 0b 83 c4 10 eb fe 8b 10 39 ca 74 14 50 52 51 68 8c fe 6f c0 e8 69 fd 13 00 <0f> 0b 83 c4 10 eb fe 89 5a 04 89 13 89 43 04 89 18 8b 5d fc c9 
May 23 13:55:38 localhost kernel: EIP: [drm:__list_add+52/74] __list_add+0x34/0x4a SS:ESP 0068:d35fad44
May 23 13:55:38 localhost kernel: ---[ end trace 23e6231bf1387b55 ]---
May 23 13:55:38 localhost kernel: BUG: sleeping function called from invalid context at kernel/rwsem.c:21
May 23 13:55:38 localhost kernel: in_atomic():0, irqs_disabled():1
May 23 13:55:38 localhost kernel: INFO: lockdep is turned off.
May 23 13:55:38 localhost kernel: irq event stamp: 0
May 23 13:55:38 localhost kernel: hardirqs last  enabled at (0): [<00000000>] 0x0
May 23 13:55:38 localhost kernel: hardirqs last disabled at (0): [copy_process+760/4400] copy_process+0x2f8/0x1130
May 23 13:55:38 localhost kernel: softirqs last  enabled at (0): [copy_process+760/4400] copy_process+0x2f8/0x1130
May 23 13:55:38 localhost kernel: softirqs last disabled at (0): [<00000000>] 0x0
May 23 13:55:38 localhost kernel: Pid: 4424, comm: iwconfig Tainted: G      D W 2.6.26-0.25.rc3.git4.fc10.i686 #1
May 23 13:55:38 localhost kernel:  [mmc_core:__might_sleep+209/9881] __might_sleep+0xd1/0xd6
May 23 13:55:38 localhost kernel:  [snd_pcm:down_read+22/3248] down_read+0x16/0x6a
May 23 13:55:38 localhost kernel:  [acct_collect+55/342] acct_collect+0x37/0x156
May 23 13:55:38 localhost kernel:  [do_exit+442/1589] do_exit+0x1ba/0x635
May 23 13:55:38 localhost kernel:  [oops_exit+35/40] ? oops_exit+0x23/0x28
May 23 13:55:38 localhost kernel:  [die+348/356] die+0x15c/0x164
May 23 13:55:38 localhost kernel:  [do_trap+138/163] do_trap+0x8a/0xa3
May 23 13:55:38 localhost kernel:  [do_invalid_op+0/118] ? do_invalid_op+0x0/0x76
May 23 13:55:38 localhost kernel:  [do_invalid_op+108/118] do_invalid_op+0x6c/0x76
May 23 13:55:38 localhost kernel:  [drm:__list_add+52/74] ? __list_add+0x34/0x4a
May 23 13:55:38 localhost kernel:  [wake_up_klogd+46/49] ? wake_up_klogd+0x2e/0x31
May 23 13:55:38 localhost kernel:  [release_console_sem+425/433] ? release_console_sem+0x1a9/0x1b1
May 23 13:55:38 localhost kernel:  [error_code+114/120] error_code+0x72/0x78
May 23 13:55:38 localhost kernel:  [i915:__wake_up+49/6310] ? __wake_up+0x31/0x3b
May 23 13:55:38 localhost kernel:  [native_cpu_up+1264/1752] ? native_cpu_up+0x4f0/0x6d8
May 23 13:55:38 localhost kernel:  [drm:__list_add+52/74] ? __list_add+0x34/0x4a
May 23 13:55:38 localhost kernel:  [<e07b7c10>] lbs_queue_cmd+0x113/0x1a9 [libertas]
May 23 13:55:38 localhost kernel:  [<e07ba391>] lbs_prepare_and_send_command+0xea9/0x1041 [libertas]
May 23 13:55:38 localhost kernel:  [<c043bc1b>] ? autoremove_wake_function+0x0/0x33
May 23 13:55:38 localhost kernel:  [<e07b65db>] lbs_get_wireless_stats+0x255/0x2d6 [libertas]
May 23 13:55:38 localhost kernel:  [check_object+308/395] ? check_object+0x134/0x18b
May 23 13:55:38 localhost kernel:  [iw_handler_get_iwstats+27/78] iw_handler_get_iwstats+0x1b/0x4e
May 23 13:55:38 localhost kernel:  [ioctl_standard_call+474/667] ioctl_standard_call+0x1da/0x29b
May 23 13:55:38 localhost kernel:  [wext_handle_ioctl+267/862] wext_handle_ioctl+0x10b/0x35e
May 23 13:55:38 localhost kernel:  [iw_handler_get_iwstats+0/78] ? iw_handler_get_iwstats+0x0/0x4e
May 23 13:55:38 localhost kernel:  [dev_ioctl+1468/1500] dev_ioctl+0x5bc/0x5dc
May 23 13:55:38 localhost kernel:  [inotify_d_instantiate+21/60] ? inotify_d_instantiate+0x15/0x3c
May 23 13:55:38 localhost kernel:  [sock_ioctl+0/471] ? sock_ioctl+0x0/0x1d7
May 23 13:55:38 localhost kernel:  [sock_ioctl+459/471] sock_ioctl+0x1cb/0x1d7
May 23 13:55:38 localhost kernel:  [sock_ioctl+0/471] ? sock_ioctl+0x0/0x1d7
May 23 13:55:38 localhost kernel:  [vfs_ioctl+34/105] vfs_ioctl+0x22/0x69
May 23 13:55:38 localhost kernel:  [do_vfs_ioctl+569/588] do_vfs_ioctl+0x239/0x24c
May 23 13:55:38 localhost kernel:  [selinux_file_ioctl+53/56] ? selinux_file_ioctl+0x35/0x38
May 23 13:55:38 localhost kernel:  [sys_ioctl+64/91] sys_ioctl+0x40/0x5b
May 23 13:55:38 localhost kernel:  [syscall_call+7/11] syscall_call+0x7/0xb
May 23 13:55:38 localhost kernel:  =======================

and then the machine hung and I had to hard power off.

Dan

