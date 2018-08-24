Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:57279 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbeHXVTV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 17:19:21 -0400
Message-ID: <1535132777.9856.33.camel@linux.intel.com> (sfid-20180824_194347_105948_9194DB24)
Subject: iwlwifi crash
From: James Prestwood <james.prestwood@linux.intel.com>
To: linux-wireless@vger.kernel.org
Date: Fri, 24 Aug 2018 10:46:17 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Saw this when trying to connect to an 8021x network:

[  118.464038] wlp2s0: authenticate with a4:2b:8c:82:6b:55
[  118.466982] wlp2s0: send auth to a4:2b:8c:82:6b:55 (try 1/3)
[  118.468168] wlp2s0: authenticated
[  118.469041] wlp2s0: associate with a4:2b:8c:82:6b:55 (try 1/3)
[  118.476118] wlp2s0: RX AssocResp from a4:2b:8c:82:6b:55 (capab=0x11
status=0 aid=1)
[  118.478290] wlp2s0: associated
[  118.510061] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes
ready
[  146.753067] wlp2s0: deauthenticating from a4:2b:8c:82:6b:55 by local
choice (Reason: 3=DEAUTH_LEAVING)
[  146.763491] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[  184.191504] wlp2s0: authenticate with ac:a0:16:bb:0f:ee
[  184.193734] wlp2s0: send auth to ac:a0:16:bb:0f:ee (try 1/3)
[  184.193893] wlp2s0: aborting authentication with ac:a0:16:bb:0f:ee
by local choice (Reason: 3=DEAUTH_LEAVING)
[  184.193925] ------------[ cut here ]------------
[  184.193926] TX on unused queue 2
[  184.193964] WARNING: CPU: 0 PID: 767 at
drivers/net/wireless/intel/iwlwifi/pcie/tx.c:2282
iwl_trans_pcie_tx+0x795/0x910 [iwlwifi]
[  184.193964] Modules linked in: des_generic cmac md4 fuse
snd_hda_codec_hdmi iwlmvm snd_hda_codec_realtek mac80211
snd_hda_codec_generic rtsx_pci_sdmmc dell_wmi wmi_bmof uvcvideo psmouse
videobuf2_vmalloc dell_wmi_descriptor videobuf2_memops atkbd
intel_wmi_thunderbolt mxm_wmi videobuf2_v4l2 btusb libps2 videodev
snd_hda_intel videobuf2_common asix iwlwifi btrtl usbnet serio_raw
btbcm libphy snd_hda_codec dell_laptop snd_hwdep btintel dell_smbios
hid_multitouch dcdbas bluetooth snd_hda_core snd_pcm snd ecdh_generic
cfg80211 soundcore rfkill i2c_i801 rtsx_pci thermal i2c_hid nouveau
int3403_thermal processor_thermal_device int3402_thermal
int340x_thermal_zone int3400_thermal wmi intel_hid acpi_thermal_rel
intel_soc_dts_iosf mei_me intel_pch_thermal ac battery mei i8042
sparse_keymap
[  184.193994] CPU: 0 PID: 767 Comm: iwd Not tainted 4.18.3-623.native
#1
[  184.193995] Hardware name: Dell Inc. XPS 15 9550/0N7TVV, BIOS 1.5.1
10/17/2017
[  184.194017] RIP: 0010:iwl_trans_pcie_tx+0x795/0x910 [iwlwifi]
[  184.194018] Code: 3d 29 c4 01 00 00 b8 ea ff ff ff 0f 85 56 fc ff ff
44 89 fe 48 c7 c7 a2 e5 94 c0 89 45 d4 c6 05 0a c4 01 00 01 e8 3b f5 7d
d2 <0f> 0b 8b 45 d4 e9 33 fc ff ff 41 0f b6 85 90 00 00 00 83 e0 60 3c 
[  184.194046] RSP: 0018:ffff8814fdc03d48 EFLAGS: 00010296
[  184.194048] RAX: 0000000000000000 RBX: ffff8814ead2c180 RCX:
0000000000000000
[  184.194048] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[  184.194049] RBP: ffff8814fdc03da0 R08: 0000000000000000 R09:
0000000000000000
[  184.194050] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff8814e254d508
[  184.194051] R13: 0000000000000002 R14: ffff8814ce386900 R15:
0000000000000002
[  184.194052] FS:  00007ff7c8c27740(0000) GS:ffff8814fdc00000(0000)
knlGS:0000000000000000
[  184.194054] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  184.194070] CR2: 00007ff7c8e4f000 CR3: 00000004a4f4a004 CR4:
00000000003606f0
[  184.194071] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  184.194071] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[  184.194072] Call Trace:
[  184.194073]  <IRQ>
[  184.194081]  ? iwl_mvm_set_tx_params+0x16a/0x320 [iwlmvm]
[  184.194087]  iwl_mvm_tx_skb_non_sta+0x14b/0x350 [iwlmvm]
[  184.194093]  iwl_mvm_mac_tx+0xe1/0x1a0 [iwlmvm]
[  184.194107]  ieee80211_tx_frags+0x13c/0x210 [mac80211]
[  184.194140]  __ieee80211_tx+0x77/0x160 [mac80211]
[  184.194165]  ieee80211_tx_pending+0x144/0x1f0 [mac80211]
[  184.194168]  ? native_sched_clock+0x25/0x80
[  184.194170]  tasklet_action_common.isra.3+0x3d/0xa0
[  184.194172]  tasklet_action+0x1d/0x30
[  184.194174]  __do_softirq+0xdd/0x2c2
[  184.194176]  do_softirq_own_stack+0x2a/0x40
[  184.194176]  </IRQ>
[  184.194178]  do_softirq.part.2+0x3d/0x40
[  184.194180]  __local_bh_enable_ip+0x4f/0x60
[  184.194181]  _raw_spin_unlock_bh+0x15/0x20
[  184.194184]  iwl_mvm_mac_sta_state+0x1a1/0x670 [iwlmvm]
[  184.194191]  drv_sta_state+0x8e/0x400 [mac80211]
[  184.194198]  __sta_info_destroy_part2+0x11f/0x130 [mac80211]
[  184.194203]  __sta_info_destroy+0x25/0x40 [mac80211]
[  184.194209]  sta_info_destroy_addr+0x33/0x60 [mac80211]
[  184.194218]  ieee80211_destroy_auth_data+0x32/0xc0 [mac80211]
[  184.194227]  ieee80211_mgd_deauth.cold.31+0x1c0/0x3a7 [mac80211]
[  184.194234]  ieee80211_deauth+0x13/0x20 [mac80211]
[  184.194259]  cfg80211_mlme_deauth+0xa5/0x1d0 [cfg80211]
[  184.194267]  cfg80211_disconnect+0x9e/0x1f0 [cfg80211]
[  184.194274]  nl80211_disconnect+0x6a/0xb0 [cfg80211]
[  184.194276]  genl_family_rcv_msg+0x1a5/0x390
[  184.194278]  genl_rcv_msg+0x47/0x90
[  184.194281]  ? __kmalloc_node_track_caller+0x2c/0x40
[  184.194282]  ? genl_family_rcv_msg+0x390/0x390
[  184.194283]  netlink_rcv_skb+0x4d/0x130
[  184.194285]  genl_rcv+0x23/0x40
[  184.194286]  netlink_unicast+0x1af/0x270
[  184.194287]  netlink_sendmsg+0x1fb/0x3a0
[  184.194289]  ? ep_send_events_proc+0x17d/0x1d0
[  184.194292]  sock_sendmsg+0x34/0x50
[  184.194293]  __sys_sendto+0x10f/0x1a0
[  184.194296]  ? __audit_syscall_entry+0xcb/0x150
[  184.194297]  ? syscall_slow_exit_work+0x197/0x1b0
[  184.194298]  ? syscall_trace_enter+0x1bb/0x2a0
[  184.194299]  __x64_sys_sendto+0x23/0x40
[  184.194300]  do_syscall_64+0x55/0x180
[  184.194302]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  184.194303] RIP: 0033:0x7ff7c8d479e0
[  184.194304] Code: ff eb b9 0f 1f 80 00 00 00 00 48 8d 05 29 dd 0c 00
41 89 ca 8b 00 85 c0 75 20 45 31 c9 45 31 c0 b8 2c 00 00 00 c5 fc 77 0f
05 <48> 3d 00 f0 ff ff 77 68 c3 0f 1f 80 00 00 00 00 41 56 41 89 ce 41 
[  184.194324] RSP: 002b:00007ffe64f9b618 EFLAGS: 00000246 ORIG_RAX:
000000000000002c
[  184.194326] RAX: ffffffffffffffda RBX: 0000000000d32f90 RCX:
00007ff7c8d479e0
[  184.194326] RDX: 0000000000000024 RSI: 0000000000d552b0 RDI:
0000000000000006
[  184.194328] RBP: 00007ffe64f9b630 R08: 0000000000000000 R09:
0000000000000000
[  184.194328] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000d4a960
[  184.194329] R13: 00007ffe64f9b68c R14: 00007ffe64f9b688 R15:
000000000046104a
[  184.194330] ---[ end trace 03ce4ec542a6e252 ]---
