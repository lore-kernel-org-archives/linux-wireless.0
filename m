Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53521 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbbL0L2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Dec 2015 06:28:44 -0500
Received: from [192.168.178.24] ([80.171.222.65]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0LhOO8-1aZ47F0hrk-00mZBr for
 <linux-wireless@vger.kernel.org>; Sun, 27 Dec 2015 12:28:41 +0100
To: linux-wireless <linux-wireless@vger.kernel.org>
From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: warning at net/mac80211/driver-ops.h:647 ieee80211_sta_wmm_params
Message-ID: <567FCB67.1000101@gmx.de> (sfid-20151227_122919_319415_803E9245)
Date: Sun, 27 Dec 2015 12:28:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yesterday I got this warning for the first time while using WLAN in a train, I'm unsure if this warning is worth to be reported or not :


Dec 26 20:26:48 t44 kernel: [45827.647635] cfg80211:   (5490000 KHz - 5710000 KHz @ 160000 KHz), (N/A, 2700 mBm), (0 s)
Dec 26 20:26:48 t44 kernel: [45827.647637] cfg80211:   (57000000 KHz - 66000000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
Dec 26 20:26:48 t44 kernel: [45827.700734] ------------[ cut here ]------------
Dec 26 20:26:48 t44 kernel: [45827.700762] WARNING: CPU: 0 PID: 1498 at net/mac80211/driver-ops.h:647 ieee80211_sta_wmm_params+0x3f7/0x410 [mac80211]()
Dec 26 20:26:48 t44 kernel: [45827.700764] wlp3s0: invalid CW_min/CW_max: 127/3
Dec 26 20:26:48 t44 kernel: [45827.700766] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat mmc_block nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_log_ipv4 nf_log_common xt_LOG xt_limit ipt_REJECT nf_reject_ipv4 xt_recent xt_tcpudp xt_conntrack iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables nfsd auth_rpcgss oid_registry lockd grace ctr ccm sunrpc af_packet bridge stp llc tun uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev arc4 coretemp x86_pkg_temp_thermal kvm_intel kvm rtsx_pci_sdmmc mmc_core evdev jitterentropy_rng hmac drbg aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd psmouse pcspkr atkbd i915 fbcon bitblit i2c_algo_bit softcursor font i2c_i801 iwlmvm snd_hda_codec_generic drm_kms_helper mac80211 cfbfillrect syscopyarea tpm_tis cfbimgblt tpm sysfillrect sysimgblt iwlwifi fb_sys_fops cfbcopyarea drm cfg80211 
i2c_core xhci_pci snd_hda_intel thinkpad_acpi snd_hda_codec nvram ehci_pci hwmon battery intel_gtt snd_hda_core ehci_hcd xhci_hcd rtsx_pci ac agpgart rfkill e1000e video snd_pcm fb fbdev snd_timer lpc_ich usbcore snd mfd_core usb_common soundcore thermal wmi button processor
Dec 26 20:26:48 t44 kernel: [45827.700893] CPU: 0 PID: 1498 Comm: kworker/u8:67 Tainted: G        W       4.3.3-hardened-r2 #1
Dec 26 20:26:48 t44 kernel: [45827.700894] Hardware name: LENOVO 20AQCTO1WW/20AQCTO1WW, BIOS GJET83WW (2.33 ) 03/09/2015
Dec 26 20:26:48 t44 kernel: [45827.700898] Workqueue: phy0 ffffffffc03fdc10
Dec 26 20:26:48 t44 kernel: [45827.700901]  ffffffff81a0584b 0000000000000000 ffffffffc04556dc ffffc9000768b898
Dec 26 20:26:48 t44 kernel: [45827.700904]  ffffffff8138014d ffffc9000768b8e0 ffffc9000768b8d0 ffffffff81061b16
Dec 26 20:26:48 t44 kernel: [45827.700908]  ffffffffc04556dc 0000000000000287 ffffffffc0451ab0 ffff88032c5b0c18
Dec 26 20:26:48 t44 kernel: [45827.700911] Call Trace:
Dec 26 20:26:48 t44 kernel: [45827.700929]  [<ffffffffc04556dc>] ? minstrel_mcs_groups+0xc15c/0xc7b6 [mac80211]
Dec 26 20:26:48 t44 kernel: [45827.700934]  [<ffffffff8138014d>] dump_stack+0x44/0x67
Dec 26 20:26:48 t44 kernel: [45827.700938]  [<ffffffff81061b16>] warn_slowpath_common+0x86/0xc0
Dec 26 20:26:48 t44 kernel: [45827.700950]  [<ffffffffc04556dc>] ? minstrel_mcs_groups+0xc15c/0xc7b6 [mac80211]
Dec 26 20:26:48 t44 kernel: [45827.700961]  [<ffffffffc0451ab0>] ? minstrel_mcs_groups+0x8530/0xc7b6 [mac80211]
Dec 26 20:26:48 t44 kernel: [45827.700965]  [<ffffffff81061bb0>] warn_slowpath_fmt+0x60/0x80
Dec 26 20:26:48 t44 kernel: [45827.700976]  [<ffffffffc0451ab0>] ? minstrel_mcs_groups+0x8530/0xc7b6 [mac80211]
Dec 26 20:26:48 t44 kernel: [45827.700992]  [<ffffffffc0435be4>] ? ieee80211_sta_process_chanswitch+0xa4/0x5d0 [mac80211]
Dec 26 20:26:48 t44 kernel: [45827.701006]  [<ffffffffc0436ce7>] ieee80211_sta_wmm_params+0x3f7/0x410 [mac80211]
Dec 26 20:26:48 t44 kernel: [45827.701020]  [<ffffffffc03f32f5>] ? ieee80211_rx_bss_put+0x25/0x30 [mac80211]
Dec 26 20:26:48 t44 kernel: [45827.701034]  [<ffffffffc043881f>] ieee80211_rx_mgmt_beacon+0xa3f/0x1190 [mac80211]
Dec 26 20:26:48 t44 kernel: [45827.701038]  [<ffffffff81452d62>] ? __domain_mapping+0x202/0x3d0
Dec 26 20:26:48 t44 kernel: [45827.701042]  [<ffffffff8160cd8a>] ? _raw_spin_lock_irqsave+0x1a/0x30
Dec 26 20:26:48 t44 kernel: [45827.701056]  [<ffffffffc043a18f>] ieee80211_sta_rx_queued_mgmt+0x35f/0x760 [mac80211]
Dec 26 20:26:48 t44 kernel: [45827.701065]  [<ffffffffc04b0cb5>] ? iwl_mvm_send_cmd_pdu+0x55/0x70 [iwlmvm]
Dec 26 20:26:48 t44 kernel: [45827.701072]  [<ffffffffc04a666f>] ? iwl_mvm_mc_iface_iterator+0x8f/0xe0 [iwlmvm]
Dec 26 20:26:48 t44 kernel: [45827.701077]  [<ffffffffc04a65e0>] ? iwl_mvm_set_tx_power+0x100/0x100 [iwlmvm]
Dec 26 20:26:48 t44 kernel: [45827.701080]  [<ffffffff81386b6c>] ? rb_erase+0x5ac/0x610
Dec 26 20:26:48 t44 kernel: [45827.701094]  [<ffffffffc041ab09>] ? __iterate_interfaces+0xd9/0x150 [mac80211]
Dec 26 20:26:48 t44 kernel: [45827.701098]  [<ffffffff8109b0aa>] ? set_next_entity+0xaa/0x800
Dec 26 20:26:48 t44 kernel: [45827.701100]  [<ffffffff8109bdb5>] ? dequeue_task_fair+0x575/0x1100
Dec 26 20:26:48 t44 kernel: [45827.701114]  [<ffffffffc03fdeff>] ieee80211_iface_work+0x2ef/0x3b0 [mac80211]
Dec 26 20:26:48 t44 kernel: [45827.701117]  [<ffffffff8107f95b>] process_one_work+0x14b/0x400
Dec 26 20:26:48 t44 kernel: [45827.701121]  [<ffffffff8107ff41>] worker_thread+0x51/0x470
Dec 26 20:26:48 t44 kernel: [45827.701123]  [<ffffffff8107fef0>] ? rescuer_thread+0x2e0/0x2e0
Dec 26 20:26:48 t44 kernel: [45827.701126]  [<ffffffff810858b1>] kthread+0xf1/0x110
Dec 26 20:26:48 t44 kernel: [45827.701129]  [<ffffffff810857c0>] ? kthread_create_on_node+0x190/0x190
Dec 26 20:26:48 t44 kernel: [45827.701132]  [<ffffffff8160d96e>] ret_from_fork+0x3e/0x70
Dec 26 20:26:48 t44 kernel: [45827.701134]  [<ffffffff810857c0>] ? kthread_create_on_node+0x190/0x190
Dec 26 20:26:48 t44 kernel: [45827.701137] ---[ end trace fe948fc0d5825694 ]---
Dec 26 20:26:48 t44 kernel: [45827.701138] wlp3s0: failed to set TX queue parameters for queue 3
Dec 26 20:26:48 t44 kernel: [45827.701142] wlp3s0: Limiting TX power to 20 (20 - 0) dBm as advertised by 46:90:e8:45:8a:51
Dec 26 20:27:56 t44 kernel: [45895.138554] grsec: time set by /usr/sbin/ntpd[ntpd:1582] uid/euid:0/0 gid/egid:0/0, parent /sbin/init[init:1] uid/euid:0/0 gid/egid:0/0
Dec 26 20:54:21 t44 kernel: [47481.883125] grsec: denied resource overstep by requesting 69632 for RLIMIT_MEMLOCK against limit 65536 for /usr/lib64/thunderbird/thunderbird[thunderbird:22842] uid/euid:1000/1000 gid/egid:1000/1000, parent /usr/bin/kdeinit4[kdeinit4:2845] uid/euid:1000/1000 gid/egid:1000/1000
Dec 26 20:54:53 t44 kernel: [47514.126615] wlp3s0: deauthenticating from 46:90:e8:45:8a:51 by local choice (Reason: 3=DEAUTH_LEAVING)
Dec 26 20:54:53 t44 kernel: [47514.137712] cfg80211: World regulatory domain updated:
Dec 26 20:54:53 t44 kernel: [47514.137715] cfg80211:  DFS Master region: unset
Dec 26 20:54:53 t44 kernel: [47514.137716] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Dec 26 20:54:53 t44 kernel: [47514.137718] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)

-- 
Toralf, pgp: C4EACDDE 0076E94E
