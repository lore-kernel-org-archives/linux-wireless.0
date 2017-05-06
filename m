Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35307 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbdEFGjY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 May 2017 02:39:24 -0400
Received: by mail-oi0-f47.google.com with SMTP id l18so8202398oig.2
        for <linux-wireless@vger.kernel.org>; Fri, 05 May 2017 23:39:23 -0700 (PDT)
MIME-Version: 1.0
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Date: Sat, 6 May 2017 08:39:22 +0200
Message-ID: <CAFED-jmhSQ2AVT36EgBpt+brvaT-HA=MKvpJUMmzwPtF44b00w@mail.gmail.com> (sfid-20170506_083936_759069_6E81775C)
Subject: iwlwifi 8260 crash (4.11rc6)
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

4.11.0-rc6-next-20170413+
04:00.0 Network controller: Intel Corporation Wireless 8260 (rev 3a)
iwlwifi 0000:04:00.0: loaded firmware version 21.302800.0 op_mode iwlmvm

Scenario:
- iwlwifi configured in monitor mode - up
- suspend my laptop
- crash


[42278.033232] usb 1-4: USB disconnect, device number 6
[42278.033245] usb 1-4.1: USB disconnect, device number 8
[42278.148731] usb 2-4: USB disconnect, device number 2
[42278.180802] thinkpad_acpi: undocked from hotplug port replicator
[42278.304743] usb 1-4.2: USB disconnect, device number 9
[42278.393040] e1000e: enp0s31f6 NIC Link is Down
[42278.400223] usb 1-4.4: USB disconnect, device number 7
[42278.669256] thinkpad_acpi: EC reports that Thermal Table has changed
[42287.376996] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[42287.377006] iwlwifi 0000:04:00.0: CSR values:
[42287.377012] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING
is CSR_INT_PERIODIC_REG)
[42287.377099] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489008
[42287.377241] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[42287.377341] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
[42287.377396] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[42287.377508] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00010000
[42287.377564] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000019
[42287.377620] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[42287.377674] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040005
[42287.377730] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000201
[42287.377785] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[42287.377841] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0Xd55555d5
[42287.377897] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[42287.377952] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X001f0042
[42287.378008] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
[42287.378063] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[42287.378119] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[42287.378175] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[42287.378290] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000060
[42287.378408] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88429af9
[42287.378462] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X07800200
[42287.378514] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[42287.378567] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xc03803c0
[42287.378620] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[42287.378673] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[42287.378676] iwlwifi 0000:04:00.0: FH register values:
[42287.378789] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X425cfc00
[42287.378848] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0429ad90
[42287.378862] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000020
[42287.378876] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801054
[42287.378890] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[42287.378904] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X07830000
[42287.378918] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[42287.378932] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0000
[42287.378946] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[42287.379104] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[42287.379107] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[42287.379109] iwlwifi 0000:04:00.0: Loaded firmware version: 21.302800.0
[42287.379112] iwlwifi 0000:04:00.0: 0x00002B00 | ADVANCED_SYSASSERT
[42287.379114] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[42287.379116] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[42287.379118] iwlwifi 0000:04:00.0: 0x00000BD8 | branchlink2
[42287.379120] iwlwifi 0000:04:00.0: 0x00026AC4 | interruptlink1
[42287.379122] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
[42287.379124] iwlwifi 0000:04:00.0: 0x00000002 | data1
[42287.379127] iwlwifi 0000:04:00.0: 0xDEADBEEF | data2
[42287.379129] iwlwifi 0000:04:00.0: 0xDEADBEEF | data3
[42287.379131] iwlwifi 0000:04:00.0: 0x003BE8E4 | beacon time
[42287.379133] iwlwifi 0000:04:00.0: 0xE3AF117E | tsf low
[42287.379135] iwlwifi 0000:04:00.0: 0x00000003 | tsf hi
[42287.379137] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[42287.379139] iwlwifi 0000:04:00.0: 0xE3AF1183 | time gp2
[42287.379141] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[42287.379143] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[42287.379145] iwlwifi 0000:04:00.0: 0x00049ED0 | uCode version minor
[42287.379147] iwlwifi 0000:04:00.0: 0x00000201 | hw version
[42287.379149] iwlwifi 0000:04:00.0: 0x00489008 | board version
[42287.379151] iwlwifi 0000:04:00.0: 0x09260119 | hcmd
[42287.379153] iwlwifi 0000:04:00.0: 0x00022080 | isr0
[42287.379155] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[42287.379157] iwlwifi 0000:04:00.0: 0x08301802 | isr2
[42287.379160] iwlwifi 0000:04:00.0: 0x00400080 | isr3
[42287.379161] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[42287.379164] iwlwifi 0000:04:00.0: 0x04000118 | last cmd Id
[42287.379166] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[42287.379168] iwlwifi 0000:04:00.0: 0x000064EE | l2p_control
[42287.379170] iwlwifi 0000:04:00.0: 0x00000020 | l2p_duration
[42287.379172] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[42287.379174] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[42287.379176] iwlwifi 0000:04:00.0: 0x0000008F | lmpm_pmg_sel
[42287.379178] iwlwifi 0000:04:00.0: 0x09031905 | timestamp
[42287.379180] iwlwifi 0000:04:00.0: 0x00002030 | flow_handler
[42287.379364] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[42287.379366] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 7
[42287.379369] iwlwifi 0000:04:00.0: 0x00000070 | ADVANCED_SYSASSERT
[42287.379371] iwlwifi 0000:04:00.0: 0x00000000 | umac branchlink1
[42287.379373] iwlwifi 0000:04:00.0: 0xC008113A | umac branchlink2
[42287.379375] iwlwifi 0000:04:00.0: 0xC0081000 | umac interruptlink1
[42287.379377] iwlwifi 0000:04:00.0: 0xC0081000 | umac interruptlink2
[42287.379379] iwlwifi 0000:04:00.0: 0x00000800 | umac data1
[42287.379381] iwlwifi 0000:04:00.0: 0xC0081000 | umac data2
[42287.379383] iwlwifi 0000:04:00.0: 0xDEADBEEF | umac data3
[42287.379385] iwlwifi 0000:04:00.0: 0x00000015 | umac major
[42287.379387] iwlwifi 0000:04:00.0: 0x00049ED0 | umac minor
[42287.379389] iwlwifi 0000:04:00.0: 0xC0886298 | frame pointer
[42287.379391] iwlwifi 0000:04:00.0: 0xC0886298 | stack pointer
[42287.379393] iwlwifi 0000:04:00.0: 0x09260119 | last host cmd
[42287.379395] iwlwifi 0000:04:00.0: 0x00000000 | isr status reg
[42287.379399] ieee80211 phy0: Hardware restart was requested
[42287.379489] iwlwifi 0000:04:00.0: FW error in SYNC CMD REMOVE_STA
[42287.379495] CPU: 0 PID: 3611 Comm: NetworkManager Not tainted
4.11.0-rc6-next-20170413+ #1
[42287.379497] Hardware name: LENOVO 20FH0033PB/20FH0033PB, BIOS
N1KET21W (1.08 ) 04/20/2016
[42287.379498] Call Trace:
[42287.379506]  dump_stack+0x63/0x82
[42287.379519]  iwl_trans_pcie_send_hcmd+0x43b/0x550 [iwlwifi]
[42287.379523]  ? wake_atomic_t_function+0x60/0x60
[42287.379534]  iwl_trans_send_cmd+0x57/0xa0 [iwlwifi]
[42287.379547]  iwl_mvm_send_cmd+0x32/0x90 [iwlmvm]
[42287.379557]  iwl_mvm_send_cmd_pdu+0x58/0x80 [iwlmvm]
[42287.379568]  iwl_mvm_rm_sta_common+0x56/0xc0 [iwlmvm]
[42287.379577]  ? iwl_mvm_rm_sta_common+0x56/0xc0 [iwlmvm]
[42287.379587]  iwl_mvm_rm_snif_sta+0x1d/0x40 [iwlmvm]
[42287.379595]  __iwl_mvm_unassign_vif_chanctx+0x68/0x100 [iwlmvm]
[42287.379603]  iwl_mvm_unassign_vif_chanctx+0x3a/0x50 [iwlmvm]
[42287.379633]  ieee80211_assign_vif_chanctx+0x8d/0x440 [mac80211]
[42287.379656]  __ieee80211_vif_release_channel+0x54/0x140 [mac80211]
[42287.379676]  ieee80211_vif_release_channel+0x3e/0x60 [mac80211]
[42287.379697]  ieee80211_del_virtual_monitor.part.19+0x64/0xc0 [mac80211]
[42287.379717]  ieee80211_do_stop+0x7f8/0x810 [mac80211]
[42287.379722]  ? _raw_spin_unlock_bh+0x1e/0x20
[42287.379725]  ? dev_deactivate_many+0x20b/0x250
[42287.379743]  ieee80211_stop+0x1a/0x20 [mac80211]
[42287.379758]  __dev_close_many+0x99/0x100
[42287.379761]  __dev_close+0x45/0x70
[42287.379764]  __dev_change_flags+0x9d/0x160
[42287.379766]  dev_change_flags+0x29/0x70
[42287.379768]  do_setlink+0x361/0xd60
[42287.379771]  ? __accumulate_sum+0x31/0x90
[42287.379774]  ? __update_load_avg_se.isra.36+0x85/0x160
[42287.379777]  ? update_load_avg+0x18b/0x590
[42287.379781]  ? ___slab_alloc+0x220/0x4e0
[42287.379784]  ? nla_parse+0x32/0x100
[42287.379787]  rtnl_newlink+0x735/0x8a0
[42287.379793]  ? security_capget+0x40/0x70
[42287.379798]  ? ns_capable_common+0x68/0x80
[42287.379800]  ? ns_capable+0x13/0x20
[42287.379803]  rtnetlink_rcv_msg+0xe6/0x220
[42287.379806]  ? __kmalloc_node_track_caller+0x1ee/0x2b0
[42287.379809]  ? __alloc_skb+0x87/0x1d0
[42287.379812]  ? rtnl_newlink+0x8a0/0x8a0
[42287.379816]  netlink_rcv_skb+0xa4/0xc0
[42287.379817]  rtnetlink_rcv+0x28/0x30
[42287.379821]  netlink_unicast+0x18c/0x240
[42287.379824]  netlink_sendmsg+0x2fb/0x3a0
[42287.379829]  sock_sendmsg+0x38/0x50
[42287.379832]  ___sys_sendmsg+0x2b6/0x2d0
[42287.379834]  ? reuse_swap_page+0x35/0x110
[42287.379838]  ? do_wp_page+0x109/0x5d0
[42287.379841]  __sys_sendmsg+0x54/0x90
[42287.379843]  ? __sys_sendmsg+0x54/0x90
[42287.379845]  SyS_sendmsg+0x12/0x20
[42287.379848]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[42287.379851] RIP: 0033:0x7ff24a3ed420
[42287.379852] RSP: 002b:00007ffe40b11f70 EFLAGS: 00000293 ORIG_RAX:
000000000000002e
[42287.379855] RAX: ffffffffffffffda RBX: 00007ff24a3d6b00 RCX: 00007ff24a3ed420
[42287.379856] RDX: 0000000000000000 RSI: 00007ffe40b12020 RDI: 000000000000000c
[42287.379857] RBP: 00007ff24a3d6b00 R08: 0000000000000000 R09: 0000000000000000
[42287.379859] R10: 000055b4f013fa50 R11: 0000000000000293 R12: 0000000000000020
[42287.379860] R13: 0000000000000010 R14: 000055b4f0056b20 R15: 0000000000000001
[42287.379885] iwlwifi 0000:04:00.0: Failed to remove station. Id=2
[42287.379889] iwlwifi 0000:04:00.0: Failed sending remove station
[42287.379915] BUG: unable to handle kernel paging request at ffffffffc08abfa6
[42287.379971] IP: report_bug+0x94/0x120
[42287.379994] PGD 360e0c067
[42287.379995] P4D 360e0c067
[42287.380013] PUD 360e0e067
[42287.380030] PMD 427ad0067
[42287.380047] PTE 800000042bf7a161

[42287.380096] Oops: 0003 [#1] SMP
[42287.380116] Modules linked in: hid_generic usbhid hid
nfnetlink_queue nfnetlink_log nfnetlink ctr ccm binfmt_misc rfcomm
openvswitch nf_conntrack_ipv6 nf_nat_ipv6 nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_defrag_ipv6 nf_nat nf_conntrack
libcrc32c cmac bnep nls_iso8859_1 arc4 intel_rapl x86_pkg_temp_thermal
snd_hda_codec_hdmi intel_powerclamp coretemp snd_soc_skl iwlmvm
snd_hda_codec_realtek snd_soc_skl_ipc snd_hda_codec_generic
snd_soc_sst_ipc mac80211 snd_soc_sst_dsp snd_hda_ext_core
snd_soc_sst_match kvm snd_soc_core irqbypass snd_compress snd_seq_midi
ac97_bus snd_seq_midi_event snd_pcm_dmaengine uvcvideo snd_rawmidi
snd_hda_intel videobuf2_vmalloc videobuf2_memops videobuf2_v4l2
snd_hda_codec videobuf2_core snd_hda_core iwlwifi snd_hwdep joydev
videodev snd_seq input_leds snd_pcm serio_raw
[42287.380524]  btusb btrtl media thinkpad_acpi cfg80211 nvram
snd_seq_device rtsx_pci_ms snd_timer btbcm memstick btintel bluetooth
mei_me shpchp mei intel_pch_thermal snd soundcore tpm_crb mac_hid
parport_pc ppdev lp parport ip_tables x_tables autofs4 algif_skcipher
af_alg dm_crypt rtsx_pci_sdmmc crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel pcbc i915 aesni_intel aes_x86_64 crypto_simd
glue_helper e1000e cryptd i2c_algo_bit psmouse ptp drm_kms_helper
rtsx_pci ahci syscopyarea pps_core sysfillrect libahci sysimgblt
fb_sys_fops drm wmi video
[42287.380834] CPU: 0 PID: 3611 Comm: NetworkManager Not tainted
4.11.0-rc6-next-20170413+ #1
[42287.380895] Hardware name: LENOVO 20FH0033PB/20FH0033PB, BIOS
N1KET21W (1.08 ) 04/20/2016
[42287.380946] task: ffff8e80bec08f00 task.stack: ffffad79419f8000
[42287.380986] RIP: 0010:report_bug+0x94/0x120
[42287.381013] RSP: 0018:ffffad79419fb390 EFLAGS: 00010202
[42287.381050] RAX: 0000000000000907 RBX: ffffad79419fb4d8 RCX: ffffffffc08abf9c
[42287.381109] RDX: 0000000000000001 RSI: ffffffffc08ae140 RDI: 0000000000000001
[42287.381178] RBP: ffffad79419fb3b0 R08: 0000000000000000 R09: 00000000000002fc
[42287.381246] R10: ffffad79419fb590 R11: 0000000000000926 R12: ffffffffc0877dd0
[42287.381320] R13: ffffffffc08a43d0 R14: 00000000000000c9 R15: 0000000000000004
[42287.381390] FS:  00007ff24c5b5e00(0000) GS:ffff8e8141400000(0000)
knlGS:0000000000000000
[42287.381470] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[42287.381527] CR2: ffffffffc08abfa6 CR3: 00000003f482d000 CR4: 00000000003406f0
[42287.381598] Call Trace:
[42287.381631]  do_trap+0x156/0x170
[42287.381668]  do_error_trap+0x89/0x110
[42287.381723]  ? iwl_mvm_binding_remove_vif+0x70/0x80 [iwlmvm]
[42287.381779]  ? __dev_printk+0x3c/0x80
[42287.381815]  ? dev_err+0x64/0x80
[42287.381849]  ? __dev_printk+0x3c/0x80
[42287.381888]  ? dev_warn+0x64/0x80
[42287.381925]  do_invalid_op+0x20/0x30
[42287.381950]  invalid_op+0x1e/0x30
[42287.381980] RIP: 0010:iwl_mvm_binding_remove_vif+0x70/0x80 [iwlmvm]
[42287.382016] RSP: 0018:ffffad79419fb588 EFLAGS: 00010246
[42287.382047] RAX: ffff8e8085e64c40 RBX: ffff8e8085e64c40 RCX: 0000000000000000
[42287.382087] RDX: 0000000000000000 RSI: ffff8e8085e64af0 RDI: ffff8e8126d4d588
[42287.382127] RBP: ffffad79419fb5b0 R08: 0000000000000001 R09: 0000000000000926
[42287.382168] R10: ffffad79419fb590 R11: 0000000000000926 R12: ffff8e8085e64af0
[42287.382208] R13: ffff8e8126d4d588 R14: 0000000000000000 R15: ffff8e80bed3fc00
[42287.382256]  ? __iwl_mvm_unassign_vif_chanctx+0x7f/0x100 [iwlmvm]
[42287.382297]  iwl_mvm_unassign_vif_chanctx+0x3a/0x50 [iwlmvm]
[42287.382354]  ieee80211_assign_vif_chanctx+0x8d/0x440 [mac80211]
[42287.382407]  __ieee80211_vif_release_channel+0x54/0x140 [mac80211]
[42287.382461]  ieee80211_vif_release_channel+0x3e/0x60 [mac80211]
[42287.382514]  ieee80211_del_virtual_monitor.part.19+0x64/0xc0 [mac80211]
[42287.382571]  ieee80211_do_stop+0x7f8/0x810 [mac80211]
[42287.382604]  ? _raw_spin_unlock_bh+0x1e/0x20
[42287.382631]  ? dev_deactivate_many+0x20b/0x250
[42287.382673]  ieee80211_stop+0x1a/0x20 [mac80211]
[42287.382702]  __dev_close_many+0x99/0x100
[42287.382728]  __dev_close+0x45/0x70
[42287.382751]  __dev_change_flags+0x9d/0x160
[42287.382776]  dev_change_flags+0x29/0x70
[42287.382800]  do_setlink+0x361/0xd60
[42287.382824]  ? __accumulate_sum+0x31/0x90
[42287.382850]  ? __update_load_avg_se.isra.36+0x85/0x160
[42287.382884]  ? update_load_avg+0x18b/0x590
[42287.382911]  ? ___slab_alloc+0x220/0x4e0
[42287.382936]  ? nla_parse+0x32/0x100
[42287.382958]  rtnl_newlink+0x735/0x8a0
[42287.384599]  ? security_capget+0x40/0x70
[42287.386207]  ? ns_capable_common+0x68/0x80
[42287.387754]  ? ns_capable+0x13/0x20
[42287.389179]  rtnetlink_rcv_msg+0xe6/0x220
[42287.390453]  ? __kmalloc_node_track_caller+0x1ee/0x2b0
[42287.391766]  ? __alloc_skb+0x87/0x1d0
[42287.393073]  ? rtnl_newlink+0x8a0/0x8a0
[42287.394275]  netlink_rcv_skb+0xa4/0xc0
[42287.395376]  rtnetlink_rcv+0x28/0x30
[42287.396448]  netlink_unicast+0x18c/0x240
[42287.397477]  netlink_sendmsg+0x2fb/0x3a0
[42287.398442]  sock_sendmsg+0x38/0x50
[42287.399258]  ___sys_sendmsg+0x2b6/0x2d0
[42287.400035]  ? reuse_swap_page+0x35/0x110
[42287.400768]  ? do_wp_page+0x109/0x5d0
[42287.401458]  __sys_sendmsg+0x54/0x90
[42287.402134]  ? __sys_sendmsg+0x54/0x90
[42287.402799]  SyS_sendmsg+0x12/0x20
[42287.403455]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[42287.404113] RIP: 0033:0x7ff24a3ed420
[42287.404811] RSP: 002b:00007ffe40b11f70 EFLAGS: 00000293 ORIG_RAX:
000000000000002e
[42287.405477] RAX: ffffffffffffffda RBX: 00007ff24a3d6b00 RCX: 00007ff24a3ed420
[42287.406140] RDX: 0000000000000000 RSI: 00007ffe40b12020 RDI: 000000000000000c
[42287.406806] RBP: 00007ff24a3d6b00 R08: 0000000000000000 R09: 0000000000000000
[42287.407475] R10: 000055b4f013fa50 R11: 0000000000000293 R12: 0000000000000020
[42287.408139] R13: 0000000000000010 R14: 000055b4f0056b20 R15: 0000000000000001
[42287.408797] Code: 61 0f b7 41 0a 4c 63 69 04 44 0f b7 71 08 89 c7
49 01 cd 83 e7 01 a8 02 74 15 66 85 ff 74 10 a8 04 ba 01 00 00 00 75
2a 83 c8 04 <66> 89 41 0a 66 85 ff 74 58 0f b6 49 0b 4c 89 e2 41 0f b7
f6 45
[42287.409511] RIP: report_bug+0x94/0x120 RSP: ffffad79419fb390
[42287.410207] CR2: ffffffffc08abfa6
[42287.416767] ---[ end trace 4974db56fed7b45f ]---
[42292.469465] PM: Syncing filesystems ... done.
[42292.491194] PM: Preparing system for sleep (mem)
[42292.493742] Freezing user space processes ... (elapsed 0.004 seconds) done.
[42292.498657] OOM killer disabled.
[42292.498662] Freezing remaining freezable tasks ...
[42312.507071] Freezing of tasks failed after 20.008 seconds (0 tasks
refusing to freeze, wq_busy=1):
[42312.507078] Showing busy workqueues and worker pools:
[42312.507087] workqueue events_freezable: flags=0x4
[42312.507092]   pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=1/0
[42312.507112]     in-flight: 27144:ieee80211_restart_work [mac80211]
[42312.507200] workqueue mm_percpu_wq: flags=0xc
[42312.507205]   pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=0/0
[42312.507219]     delayed: vmstat_update
[42312.507237]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=0/0
[42312.507250]     delayed: vmstat_update
[42312.507263]   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=0/0
[42312.507275]     delayed: vmstat_update
[42312.507287]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=0/0
[42312.507300]     delayed: vmstat_update
[42312.507317] workqueue writeback: flags=0x4e
[42312.507321]   pwq 8: cpus=0-3 flags=0x4 nice=0 active=0/0
[42312.507334]     delayed: wb_workfn
[42312.507377] pool 6: cpus=3 node=0 flags=0x0 nice=0 hung=10s
workers=3 idle: 27326 27018
[42312.507799] Restarting kernel threads ... done.
[42312.508562] OOM killer enabled.
[42312.508569] Restarting tasks ... done.



-- 
Janusz Dziedzic
