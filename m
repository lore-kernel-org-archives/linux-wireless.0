Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45236 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbbFAWwF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 18:52:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6E6F2204A0
	for <linux-wireless@vger.kernel.org>; Mon,  1 Jun 2015 22:52:03 +0000 (UTC)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com [209.85.215.54])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 35CA020499
	for <linux-wireless@vger.kernel.org>; Mon,  1 Jun 2015 22:52:00 +0000 (UTC)
Received: by labko7 with SMTP id ko7so108957288lab.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 15:51:58 -0700 (PDT)
MIME-Version: 1.0
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 1 Jun 2015 15:51:37 -0700
Message-ID: <CALCETrU+Jk+rNwV7ibCy_LJoHkcgSPr7EFRzCxgSkJ5Jwh5q4w@mail.gmail.com> (sfid-20150602_005210_734224_C9652300)
Subject: iwlwifi/iwlmvm dies on resume when rfkill is set
To: Intel Linux Wireless <ilw@linux.intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If I switch my laptop into airplane mode (hardware switch) and then
suspend and resume, my wireless is dead on resume and it spews all
over the kernel log (see below).  I can rescue it by switching
airplane mode off and then suspending and resuming again.

This problem has existed on all kernel versions I've tried, although I
haven't tried a 4.0 kernel yet.

--Andy

[70699.024982] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[70699.036852] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[70699.095638] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[70699.188983] ------------[ cut here ]------------
[70699.189002] WARNING: CPU: 1 PID: 910 at
drivers/net/wireless/iwlwifi/pcie/trans.c:1361
iwl_trans_pcie_grab_nic_access+0x128/0x140 [iwlwifi]()
[70699.189004] Timeout waiting for hardware access (CSR_GP_CNTRL 0x080003dc)
[70699.189005] Modules linked in: nfnetlink_queue nfnetlink_log
nfnetlink rfcomm vfat fat uas usb_storage fuse ccm xt_CHECKSUM
iptable_mangle bridge stp llc tun ip6t_REJECT nf_reject_ipv6
nf_conntrack_ipv6 nf_defrag_ipv6 ipt_MASQUERADE nf_nat_masquerade_ipv4
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_nat_ipv4
ip6table_filter nf_nat bnep nf_conntrack ip6_tables arc4 intel_rapl
iosf_mbi iTCO_wdt x86_pkg_temp_thermal iTCO_vendor_support coretemp
kvm_intel btusb snd_hda_codec_hdmi kvm iwlmvm bluetooth
snd_hda_codec_conexant snd_hda_codec_generic mac80211 snd_hda_intel
snd_hda_controller snd_hda_codec iwlwifi snd_hwdep snd_seq
snd_seq_device snd_pcm joydev cfg80211 serio_raw sdhci_pci i2c_i801
sdhci thinkpad_acpi mmc_core snd_timer tpm_tis wmi mei_me rfkill tpm
mei snd lpc_ich shpchp soundcore
[70699.189040]  mfd_core nfsd auth_rpcgss nfs_acl lockd grace sunrpc
binfmt_misc dm_crypt i915 crct10dif_pclmul crc32_pclmul crc32c_intel
e1000e i2c_algo_bit drm_kms_helper ghash_clmulni_intel drm ptp
pps_core video
[70699.189054] CPU: 1 PID: 910 Comm: NetworkManager Not tainted
3.19.7-200.fc21.x86_64 #1
[70699.189055] Hardware name: LENOVO 4286CTO/4286CTO, BIOS 8DET69WW
(1.39 ) 07/18/2013
[70699.189057]  0000000000000000 00000000e8df4a59 ffff8800d66972e8
ffffffff8176f1f7
[70699.189060]  0000000000000000 ffff8800d6697340 ffff8800d6697328
ffffffff8109bc1a
[70699.189062]  ffff8800d6697380 ffff8800d6698000 0000000000000000
ffff8800d669bc30
[70699.189065] Call Trace:
[70699.189072]  [<ffffffff8176f1f7>] dump_stack+0x45/0x57
[70699.189077]  [<ffffffff8109bc1a>] warn_slowpath_common+0x8a/0xc0
[70699.189080]  [<ffffffff8109bca5>] warn_slowpath_fmt+0x55/0x70
[70699.189085]  [<ffffffff813a3248>] ? delay_tsc+0x48/0x80
[70699.189092]  [<ffffffffa046da78>]
iwl_trans_pcie_grab_nic_access+0x128/0x140 [iwlwifi]
[70699.189098]  [<ffffffffa04604ce>] iwl_set_bits_mask_prph+0x3e/0xa0 [iwlwifi]
[70699.189103]  [<ffffffffa046cce3>] iwl_pcie_set_pwr+0x43/0x70 [iwlwifi]
[70699.189108]  [<ffffffffa046edec>]
iwl_trans_pcie_start_fw+0xec/0x710 [iwlwifi]
[70699.189115]  [<ffffffffa0639266>]
iwl_mvm_load_ucode_wait_alive+0x106/0x300 [iwlmvm]
[70699.189119]  [<ffffffffa0639000>] ? 0xffffffffa0639000
[70699.189125]  [<ffffffffa06399bc>] iwl_mvm_up+0x6c/0x460 [iwlmvm]
[70699.189131]  [<ffffffffa063e5cc>] __iwl_mvm_mac_start+0x2c/0x370 [iwlmvm]
[70699.189135]  [<ffffffff816dca28>] ? ip_mc_up+0x48/0x80
[70699.189140]  [<ffffffffa063e938>] iwl_mvm_mac_start+0x28/0x40 [iwlmvm]
[70699.189155]  [<ffffffffa04ed1c1>] ieee80211_do_open+0x311/0xda0 [mac80211]
[70699.189167]  [<ffffffffa04edcc1>] ieee80211_open+0x71/0x80 [mac80211]
[70699.189171]  [<ffffffff8165e03e>] __dev_open+0xce/0x150
[70699.189175]  [<ffffffff8165e381>] __dev_change_flags+0xa1/0x170
[70699.189178]  [<ffffffff8165e479>] dev_change_flags+0x29/0x70
[70699.189181]  [<ffffffff813b1491>] ? list_del+0x11/0x40
[70699.189185]  [<ffffffff8166e0ef>] do_setlink+0x39f/0xb70
[70699.189189]  [<ffffffff811bc230>] ? zone_statistics+0x80/0xa0
[70699.189192]  [<ffffffff811bc230>] ? zone_statistics+0x80/0xa0
[70699.189195]  [<ffffffff813c1252>] ? nla_parse+0x32/0x120
[70699.189198]  [<ffffffff8166effd>] rtnl_newlink+0x5fd/0x7a0
[70699.189203]  [<ffffffff8131f2c8>] ? security_capable+0x18/0x20
[70699.189206]  [<ffffffff810a413d>] ? ns_capable+0x2d/0x60
[70699.189209]  [<ffffffff8166b011>] rtnetlink_rcv_msg+0xa1/0x260
[70699.189212]  [<ffffffff8168b07d>] ? __netlink_lookup+0x4d/0x70
[70699.189215]  [<ffffffff8166af70>] ? rtnetlink_rcv+0x40/0x40
[70699.189217]  [<ffffffff8168f0e9>] netlink_rcv_skb+0xb9/0xe0
[70699.189220]  [<ffffffff8166af5c>] rtnetlink_rcv+0x2c/0x40
[70699.189222]  [<ffffffff8168e7fd>] netlink_unicast+0x12d/0x1c0
[70699.189225]  [<ffffffff8168ebb0>] netlink_sendmsg+0x320/0x680
[70699.189227]  [<ffffffff81322712>] ? sock_has_perm+0x72/0x90
[70699.189231]  [<ffffffff8163f47c>] do_sock_sendmsg+0x9c/0x110
[70699.189235]  [<ffffffff8163edec>] ? copy_msghdr_from_user+0x15c/0x210
[70699.189238]  [<ffffffff8163fac0>] ___sys_sendmsg+0x330/0x340
[70699.189241]  [<ffffffff811ca250>] ? tlb_flush_mmu_free+0x40/0x60
[70699.189244]  [<ffffffff811caf8c>] ? tlb_finish_mmu+0x1c/0x50
[70699.189247]  [<ffffffff81238bb5>] ? __fget_light+0x25/0x70
[70699.189250]  [<ffffffff8163f740>] ? SYSC_sendto+0x1c0/0x210
[70699.189254]  [<ffffffff816402a1>] __sys_sendmsg+0x51/0x90
[70699.189256]  [<ffffffff816402f2>] SyS_sendmsg+0x12/0x20
[70699.189260]  [<ffffffff81775a09>] system_call_fastpath+0x12/0x17
[70699.189262] ---[ end trace 1969d879628f09fa ]---
[70700.277152] iwlwifi 0000:03:00.0: Hardware error detected.  Restarting.
[70700.277175] iwlwifi 0000:03:00.0: CSR values:
[70700.277179] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING
is CSR_INT_PERIODIC_REG)
[70700.277196] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X40489204
[70700.277212] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X80000040
[70700.277228] iwlwifi 0000:03:00.0:                     CSR_INT: 0X20000000
[70700.277242] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[70700.277258] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
[70700.277271] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[70700.277286] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000003
[70700.277301] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080003dc
[70700.277319] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X00000144
[70700.277338] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0X00000000
[70700.277364] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X80000000
[70700.277379] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X803a0000
[70700.277395] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080042
[70700.277411] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[70700.277439] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[70700.277455] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[70700.277473] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[70700.277501] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[70700.277518] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[70700.277531] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[70700.277544] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[70700.277557] iwlwifi 0000:03:00.0:      CSR_MONITOR_STATUS_REG: 0X1c01019c
[70700.277570] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[70700.277583] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0510
[70700.277587] iwlwifi 0000:03:00.0: FH register values:
[70700.345203] iwlwifi 0000:03:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X5a5a5a5a
[70700.413471] iwlwifi 0000:03:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X5a5a5a5a
[70700.481835] iwlwifi 0000:03:00.0:
FH_RSCSR_CHNL0_WPTR: 0X5a5a5a5a
[70700.550212] iwlwifi 0000:03:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X5a5a5a5a
[70700.618816] iwlwifi 0000:03:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X5a5a5a5a
[70700.687568] iwlwifi 0000:03:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X5a5a5a5a
[70700.721981] iwlwifi 0000:03:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X5a5a5a5a
[70700.756156] iwlwifi 0000:03:00.0:
FH_TSSR_TX_STATUS_REG: 0X5a5a5a5a
[70700.790635] iwlwifi 0000:03:00.0:
FH_TSSR_TX_ERROR_REG: 0X5a5a5a5a
[70700.825156] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[70700.825177] iwlwifi 0000:03:00.0: Status: 0x00000000, count: -1
[70700.825186] iwlwifi 0000:03:00.0: Loaded firmware version: 25.15.12.0
[70700.825190] iwlwifi 0000:03:00.0: 0x5A5A5A5A | ADVANCED_SYSASSERT
[70700.825204] iwlwifi 0000:03:00.0: 0x00000000 | uPc
[70700.825208] iwlwifi 0000:03:00.0: 0xD669FCB8 | branchlink1
[70700.825212] iwlwifi 0000:03:00.0: 0xFFFF8800 | branchlink2
[70700.825215] iwlwifi 0000:03:00.0: 0xA04625F2 | interruptlink1
[70700.825219] iwlwifi 0000:03:00.0: 0xFFFFFFFF | interruptlink2
[70700.825222] iwlwifi 0000:03:00.0: 0xA0476B2A | data1
[70700.825241] iwlwifi 0000:03:00.0: 0xFFFFFFFF | data2
[70700.825245] iwlwifi 0000:03:00.0: 0xD669FC68 | data3
[70700.825249] iwlwifi 0000:03:00.0: 0xFFFF8800 | beacon time
[70700.825253] iwlwifi 0000:03:00.0: 0x00000020 | tsf low
[70700.825257] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[70700.825260] iwlwifi 0000:03:00.0: 0xD669FCC8 | time gp1
[70700.825264] iwlwifi 0000:03:00.0: 0xFFFF8800 | time gp2
[70700.825268] iwlwifi 0000:03:00.0: 0xD669FC88 | time gp3
[70700.825272] iwlwifi 0000:03:00.0: 0xFFFF8800 | uCode version
[70700.825276] iwlwifi 0000:03:00.0: 0x4FD81ECE | hw version
[70700.825280] iwlwifi 0000:03:00.0: 0x00000000 | board version
[70700.825284] iwlwifi 0000:03:00.0: 0xFFFFFFFF | hcmd
[70700.825288] iwlwifi 0000:03:00.0: 0x00000292 | isr0
[70700.825291] iwlwifi 0000:03:00.0: 0x00000000 | isr1
[70700.825295] iwlwifi 0000:03:00.0: 0x4FD81ECE | isr2
[70700.825299] iwlwifi 0000:03:00.0: 0x00000000 | isr3
[70700.825303] iwlwifi 0000:03:00.0: 0xA0476AF8 | isr4
[70700.825306] iwlwifi 0000:03:00.0: 0xFFFFFFFF | isr_pref
[70700.825310] iwlwifi 0000:03:00.0: 0x5A5A5A5A | wait_event
[70700.825314] iwlwifi 0000:03:00.0: 0x00000000 | l2p_control
[70700.825318] iwlwifi 0000:03:00.0: 0xD669FD08 | l2p_duration
[70700.825322] iwlwifi 0000:03:00.0: 0xFFFF8800 | l2p_mhvalid
[70700.825326] iwlwifi 0000:03:00.0: 0xA0460822 | l2p_addr_match
[70700.825330] iwlwifi 0000:03:00.0: 0xFFFFFFFF | lmpm_pmg_sel
[70700.825334] iwlwifi 0000:03:00.0: 0xA04778D0 | timestamp
[70700.825338] iwlwifi 0000:03:00.0: 0xFFFFFFFF | flow_handler
[70700.825346] ieee80211 phy0: Hardware restart was requested
[70705.643712] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
[70705.643725] iwlwifi 0000:03:00.0: Could not load the [0] uCode section
[70705.643742] iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
[70705.702465] ------------[ cut here ]------------
[70705.702490] WARNING: CPU: 1 PID: 910 at
drivers/net/wireless/iwlwifi/pcie/trans.c:355
iwl_pcie_apm_stop+0x2e1/0x330 [iwlwifi]()
[70705.702492] Modules linked in: nfnetlink_queue nfnetlink_log
nfnetlink rfcomm vfat fat uas usb_storage fuse ccm xt_CHECKSUM
iptable_mangle bridge stp llc tun ip6t_REJECT nf_reject_ipv6
nf_conntrack_ipv6 nf_defrag_ipv6 ipt_MASQUERADE nf_nat_masquerade_ipv4
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_nat_ipv4
ip6table_filter nf_nat bnep nf_conntrack ip6_tables arc4 intel_rapl
iosf_mbi iTCO_wdt x86_pkg_temp_thermal iTCO_vendor_support coretemp
kvm_intel btusb snd_hda_codec_hdmi kvm iwlmvm bluetooth
snd_hda_codec_conexant snd_hda_codec_generic mac80211 snd_hda_intel
snd_hda_controller snd_hda_codec iwlwifi snd_hwdep snd_seq
snd_seq_device snd_pcm joydev cfg80211 serio_raw sdhci_pci i2c_i801
sdhci thinkpad_acpi mmc_core snd_timer tpm_tis wmi mei_me rfkill tpm
mei snd lpc_ich shpchp soundcore
[70705.702546]  mfd_core nfsd auth_rpcgss nfs_acl lockd grace sunrpc
binfmt_misc dm_crypt i915 crct10dif_pclmul crc32_pclmul crc32c_intel
e1000e i2c_algo_bit drm_kms_helper ghash_clmulni_intel drm ptp
pps_core video
[70705.702566] CPU: 1 PID: 910 Comm: NetworkManager Tainted: G
W      3.19.7-200.fc21.x86_64 #1
[70705.702569] Hardware name: LENOVO 4286CTO/4286CTO, BIOS 8DET69WW
(1.39 ) 07/18/2013
[70705.702571]  0000000000000000 00000000e8df4a59 ffff8800d6697478
ffffffff8176f1f7
[70705.702576]  0000000000000000 0000000000000000 ffff8800d66974b8
ffffffff8109bc1a
[70705.702579]  ffff8800d6697498 ffff8800d6698000 0000000000000000
ffff8800d669bb74
[70705.702584] Call Trace:
[70705.702593]  [<ffffffff8176f1f7>] dump_stack+0x45/0x57
[70705.702601]  [<ffffffff8109bc1a>] warn_slowpath_common+0x8a/0xc0
[70705.702606]  [<ffffffff8109bd4a>] warn_slowpath_null+0x1a/0x20
[70705.702617]  [<ffffffffa046de41>] iwl_pcie_apm_stop+0x2e1/0x330 [iwlwifi]
[70705.702626]  [<ffffffffa046eb60>]
iwl_trans_pcie_stop_device+0xe0/0x280 [iwlwifi]
[70705.702636]  [<ffffffffa0639cb0>] iwl_mvm_up+0x360/0x460 [iwlmvm]
[70705.702646]  [<ffffffffa063e5cc>] __iwl_mvm_mac_start+0x2c/0x370 [iwlmvm]
[70705.702652]  [<ffffffff816dca28>] ? ip_mc_up+0x48/0x80
[70705.702661]  [<ffffffffa063e938>] iwl_mvm_mac_start+0x28/0x40 [iwlmvm]
[70705.702682]  [<ffffffffa04ed1c1>] ieee80211_do_open+0x311/0xda0 [mac80211]
[70705.702700]  [<ffffffffa04edcc1>] ieee80211_open+0x71/0x80 [mac80211]
[70705.702706]  [<ffffffff8165e03e>] __dev_open+0xce/0x150
[70705.702711]  [<ffffffff8165e381>] __dev_change_flags+0xa1/0x170
[70705.702716]  [<ffffffff8165e479>] dev_change_flags+0x29/0x70
[70705.702720]  [<ffffffff813b1491>] ? list_del+0x11/0x40
[70705.702725]  [<ffffffff8166e0ef>] do_setlink+0x39f/0xb70
[70705.702732]  [<ffffffff811bc230>] ? zone_statistics+0x80/0xa0
[70705.702736]  [<ffffffff811bc230>] ? zone_statistics+0x80/0xa0
[70705.702742]  [<ffffffff813c1252>] ? nla_parse+0x32/0x120
[70705.702746]  [<ffffffff8166effd>] rtnl_newlink+0x5fd/0x7a0
[70705.702754]  [<ffffffff8131f2c8>] ? security_capable+0x18/0x20
[70705.702759]  [<ffffffff810a413d>] ? ns_capable+0x2d/0x60
[70705.702763]  [<ffffffff8166b011>] rtnetlink_rcv_msg+0xa1/0x260
[70705.702768]  [<ffffffff8168b07d>] ? __netlink_lookup+0x4d/0x70
[70705.702772]  [<ffffffff8166af70>] ? rtnetlink_rcv+0x40/0x40
[70705.702776]  [<ffffffff8168f0e9>] netlink_rcv_skb+0xb9/0xe0
[70705.702780]  [<ffffffff8166af5c>] rtnetlink_rcv+0x2c/0x40
[70705.702783]  [<ffffffff8168e7fd>] netlink_unicast+0x12d/0x1c0
[70705.702787]  [<ffffffff8168ebb0>] netlink_sendmsg+0x320/0x680
[70705.702791]  [<ffffffff81322712>] ? sock_has_perm+0x72/0x90
[70705.702797]  [<ffffffff8163f47c>] do_sock_sendmsg+0x9c/0x110
[70705.702802]  [<ffffffff8163edec>] ? copy_msghdr_from_user+0x15c/0x210
[70705.702807]  [<ffffffff8163fac0>] ___sys_sendmsg+0x330/0x340
[70705.702812]  [<ffffffff811ca250>] ? tlb_flush_mmu_free+0x40/0x60
[70705.702817]  [<ffffffff811caf8c>] ? tlb_finish_mmu+0x1c/0x50
[70705.702822]  [<ffffffff81238bb5>] ? __fget_light+0x25/0x70
[70705.702827]  [<ffffffff8163f740>] ? SYSC_sendto+0x1c0/0x210
[70705.702832]  [<ffffffff816402a1>] __sys_sendmsg+0x51/0x90
[70705.702836]  [<ffffffff816402f2>] SyS_sendmsg+0x12/0x20
[70705.702842]  [<ffffffff81775a09>] system_call_fastpath+0x12/0x17
[70705.702845] ---[ end trace 1969d879628f09fb ]---
[70705.702849] iwlwifi 0000:03:00.0: Access time out - failed to enable LP XTAL
[70705.703011] iwlwifi 0000:03:00.0: Failed to send quota: -5
[70705.703018] iwlwifi 0000:03:00.0: Failed to update quotas after restart (-5)
