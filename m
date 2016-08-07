Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40154 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbcHGIz0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Aug 2016 04:55:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4B1E8202A1
	for <linux-wireless@vger.kernel.org>; Sun,  7 Aug 2016 08:55:24 +0000 (UTC)
Received: from mail-vk0-f49.google.com (mail-vk0-f49.google.com [209.85.213.49])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id E73BB20274
	for <linux-wireless@vger.kernel.org>; Sun,  7 Aug 2016 08:55:20 +0000 (UTC)
Received: by mail-vk0-f49.google.com with SMTP id x130so220404697vkc.0
        for <linux-wireless@vger.kernel.org>; Sun, 07 Aug 2016 01:55:20 -0700 (PDT)
MIME-Version: 1.0
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 7 Aug 2016 01:54:59 -0700
Message-ID: <CALCETrX3QgRpRjCp__i3iBMY3o1fw5sG7oTF-4uR3skvTwawMg@mail.gmail.com> (sfid-20160807_105531_459578_E28A288C)
Subject: iwlwifi errors (regression?) on 4.7.0
To: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <linuxwifi@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My Intel 7265 used to work flawlessly, but for the past week or two it
has seemed to be very unreliable.  It's also throwing errors.  I see
problems on firmware versions 16 and 21, although I haven't gotten the
warning and backtrace on firmware 16 yet.

I have:

iwlwifi 0000:3a:00.0: enabling device (0000 -> 0002)
iwlwifi 0000:3a:00.0: Unsupported splx structure
iwlwifi 0000:3a:00.0: loaded firmware version 21.302800.0 op_mode iwlmvm
iwlwifi 0000:3a:00.0: Detected Intel(R) Dual Band Wireless AC 7265, REV=0x210
iwlwifi 0000:3a:00.0: L1 Enabled - LTR Disabled
iwlwifi 0000:3a:00.0: L1 Enabled - LTR Disabled


I just got this error on 4.7.0:

[324188.495734] wlp58s0: associated
[324281.259579] iwlwifi 0000:3a:00.0: Queue 16 stuck for 10000 ms.
[324281.259600] iwlwifi 0000:3a:00.0: Current SW read_ptr 255 write_ptr 13
[324281.259648] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00  ................
[324281.259676] iwlwifi 0000:3a:00.0: FH TRBs(0) = 0x00000000
[324281.259703] iwlwifi 0000:3a:00.0: FH TRBs(1) = 0xc011000c
[324281.259728] iwlwifi 0000:3a:00.0: FH TRBs(2) = 0x00000000
[324281.259753] iwlwifi 0000:3a:00.0: FH TRBs(3) = 0x80300024
[324281.259779] iwlwifi 0000:3a:00.0: FH TRBs(4) = 0x00000000
[324281.259804] iwlwifi 0000:3a:00.0: FH TRBs(5) = 0x00000000
[324281.259830] iwlwifi 0000:3a:00.0: FH TRBs(6) = 0x00000000
[324281.259855] iwlwifi 0000:3a:00.0: FH TRBs(7) = 0x007090e6
[324281.259925] iwlwifi 0000:3a:00.0: Q 0 is active and mapped to fifo
3 ra_tid 0x0000 [37,37]
[324281.259999] iwlwifi 0000:3a:00.0: Q 1 is active and mapped to fifo
2 ra_tid 0x0000 [0,0]
[324281.260065] iwlwifi 0000:3a:00.0: Q 2 is active and mapped to fifo
1 ra_tid 0x0000 [7,7]
[324281.260131] iwlwifi 0000:3a:00.0: Q 3 is active and mapped to fifo
0 ra_tid 0x0000 [0,0]
[324281.260197] iwlwifi 0000:3a:00.0: Q 4 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.260264] iwlwifi 0000:3a:00.0: Q 5 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.260330] iwlwifi 0000:3a:00.0: Q 6 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.260396] iwlwifi 0000:3a:00.0: Q 7 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.260462] iwlwifi 0000:3a:00.0: Q 8 is active and mapped to fifo
3 ra_tid 0x0000 [0,0]
[324281.260528] iwlwifi 0000:3a:00.0: Q 9 is active and mapped to fifo
7 ra_tid 0x0000 [231,231]
[324281.260595] iwlwifi 0000:3a:00.0: Q 10 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.260662] iwlwifi 0000:3a:00.0: Q 11 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.260731] iwlwifi 0000:3a:00.0: Q 12 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.260806] iwlwifi 0000:3a:00.0: Q 13 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.260873] iwlwifi 0000:3a:00.0: Q 14 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.260939] iwlwifi 0000:3a:00.0: Q 15 is active and mapped to
fifo 5 ra_tid 0x0000 [0,0]
[324281.261006] iwlwifi 0000:3a:00.0: Q 16 is active and mapped to
fifo 1 ra_tid 0x1fff [255,13]
[324281.261085] iwlwifi 0000:3a:00.0: Q 17 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.261214] iwlwifi 0000:3a:00.0: Q 18 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.261356] iwlwifi 0000:3a:00.0: Q 19 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.261499] iwlwifi 0000:3a:00.0: Q 20 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.261636] iwlwifi 0000:3a:00.0: Q 21 is inactive and mapped to
fifo 0 ra_tid 0x8000 [0,0]
[324281.261775] iwlwifi 0000:3a:00.0: Q 22 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.261903] iwlwifi 0000:3a:00.0: Q 23 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.262032] iwlwifi 0000:3a:00.0: Q 24 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.262173] iwlwifi 0000:3a:00.0: Q 25 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.262285] iwlwifi 0000:3a:00.0: Q 26 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.262426] iwlwifi 0000:3a:00.0: Q 27 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.262555] iwlwifi 0000:3a:00.0: Q 28 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.262684] iwlwifi 0000:3a:00.0: Q 29 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.262812] iwlwifi 0000:3a:00.0: Q 30 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[324281.262909] iwlwifi 0000:3a:00.0: Microcode SW error detected.
Restarting 0x2000000.
[324281.262918] iwlwifi 0000:3a:00.0: CSR values:
[324281.262925] iwlwifi 0000:3a:00.0: (2nd byte of CSR_INT_COALESCING
is CSR_INT_PERIODIC_REG)
[324281.262945] iwlwifi 0000:3a:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489200
[324281.262960] iwlwifi 0000:3a:00.0:          CSR_INT_COALESCING: 0X00000040
[324281.262976] iwlwifi 0000:3a:00.0:                     CSR_INT: 0X00000000
[324281.262992] iwlwifi 0000:3a:00.0:                CSR_INT_MASK: 0X00000000
[324281.263007] iwlwifi 0000:3a:00.0:           CSR_FH_INT_STATUS: 0X00000000
[324281.263022] iwlwifi 0000:3a:00.0:                 CSR_GPIO_IN: 0X00000000
[324281.263037] iwlwifi 0000:3a:00.0:                   CSR_RESET: 0X00000000
[324281.263053] iwlwifi 0000:3a:00.0:                CSR_GP_CNTRL: 0X080403c5
[324281.263069] iwlwifi 0000:3a:00.0:                  CSR_HW_REV: 0X00000210
[324281.263084] iwlwifi 0000:3a:00.0:              CSR_EEPROM_REG: 0Xd55555d5
[324281.263099] iwlwifi 0000:3a:00.0:               CSR_EEPROM_GP: 0X00000000
[324281.263115] iwlwifi 0000:3a:00.0:              CSR_OTP_GP_REG: 0Xd55555d5
[324281.263131] iwlwifi 0000:3a:00.0:                 CSR_GIO_REG: 0X001f0042
[324281.263146] iwlwifi 0000:3a:00.0:            CSR_GP_UCODE_REG: 0X00000000
[324281.263162] iwlwifi 0000:3a:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[324281.263177] iwlwifi 0000:3a:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[324281.263192] iwlwifi 0000:3a:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[324281.263208] iwlwifi 0000:3a:00.0:                 CSR_LED_REG: 0X00000060
[324281.263223] iwlwifi 0000:3a:00.0:        CSR_DRAM_INT_TBL_REG: 0X88272f5f
[324281.263238] iwlwifi 0000:3a:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[324281.263253] iwlwifi 0000:3a:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[324281.263272] iwlwifi 0000:3a:00.0:      CSR_MONITOR_STATUS_REG: 0Xc3b7ff57
[324281.263293] iwlwifi 0000:3a:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[324281.263311] iwlwifi 0000:3a:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[324281.263317] iwlwifi 0000:3a:00.0: FH register values:
[324281.263347] iwlwifi 0000:3a:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X274eac00
[324281.263374] iwlwifi 0000:3a:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0274eaf0
[324281.263401] iwlwifi 0000:3a:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[324281.263427] iwlwifi 0000:3a:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[324281.263454] iwlwifi 0000:3a:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[324281.263482] iwlwifi 0000:3a:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[324281.263509] iwlwifi 0000:3a:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[324281.263535] iwlwifi 0000:3a:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[324281.263598] iwlwifi 0000:3a:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[324281.263732] iwlwifi 0000:3a:00.0: Start IWL Error Log Dump:
[324281.263739] iwlwifi 0000:3a:00.0: Status: 0x00000000, count: 6
[324281.263745] iwlwifi 0000:3a:00.0: Loaded firmware version: 21.302800.0
[324281.263751] iwlwifi 0000:3a:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN
[324281.263756] iwlwifi 0000:3a:00.0: 0x000002F3 | trm_hw_status0
[324281.263762] iwlwifi 0000:3a:00.0: 0x00000000 | trm_hw_status1
[324281.263767] iwlwifi 0000:3a:00.0: 0x000401D4 | branchlink2
[324281.263772] iwlwifi 0000:3a:00.0: 0x00049A60 | interruptlink1
[324281.263777] iwlwifi 0000:3a:00.0: 0x000069F6 | interruptlink2
[324281.263782] iwlwifi 0000:3a:00.0: 0x00000000 | data1
[324281.263787] iwlwifi 0000:3a:00.0: 0x00000080 | data2
[324281.263793] iwlwifi 0000:3a:00.0: 0x03030000 | data3
[324281.263798] iwlwifi 0000:3a:00.0: 0xE280296F | beacon time
[324281.263804] iwlwifi 0000:3a:00.0: 0x0188C690 | tsf low
[324281.263809] iwlwifi 0000:3a:00.0: 0x00000233 | tsf hi
[324281.263814] iwlwifi 0000:3a:00.0: 0x00000000 | time gp1
[324281.263819] iwlwifi 0000:3a:00.0: 0x2E22C83F | time gp2
[324281.263825] iwlwifi 0000:3a:00.0: 0x00000000 | uCode revision type
[324281.263832] iwlwifi 0000:3a:00.0: 0x00000015 | uCode version major
[324281.263838] iwlwifi 0000:3a:00.0: 0x00049ED0 | uCode version minor
[324281.263844] iwlwifi 0000:3a:00.0: 0x00000210 | hw version
[324281.263850] iwlwifi 0000:3a:00.0: 0x00489200 | board version
[324281.263857] iwlwifi 0000:3a:00.0: 0x10FF001C | hcmd
[324281.263862] iwlwifi 0000:3a:00.0: 0x26E22002 | isr0
[324281.263868] iwlwifi 0000:3a:00.0: 0x01804000 | isr1
[324281.263873] iwlwifi 0000:3a:00.0: 0x00000002 | isr2
[324281.263879] iwlwifi 0000:3a:00.0: 0x40400080 | isr3
[324281.263883] iwlwifi 0000:3a:00.0: 0x00000000 | isr4
[324281.263888] iwlwifi 0000:3a:00.0: 0x10800112 | last cmd Id
[324281.263894] iwlwifi 0000:3a:00.0: 0x00000000 | wait_event
[324281.263899] iwlwifi 0000:3a:00.0: 0x00000288 | l2p_control
[324281.263904] iwlwifi 0000:3a:00.0: 0x00001C22 | l2p_duration
[324281.263909] iwlwifi 0000:3a:00.0: 0x000000BF | l2p_mhvalid
[324281.263914] iwlwifi 0000:3a:00.0: 0x00000020 | l2p_addr_match
[324281.263919] iwlwifi 0000:3a:00.0: 0x00000007 | lmpm_pmg_sel
[324281.263925] iwlwifi 0000:3a:00.0: 0x09031909 | timestamp
[324281.263931] iwlwifi 0000:3a:00.0: 0x00340010 | flow_handler
[324281.263940] ieee80211 phy0: Hardware restart was requested
[324281.668963] iwlwifi 0000:3a:00.0: L1 Enabled - LTR Disabled
[324281.669167] iwlwifi 0000:3a:00.0: L1 Enabled - LTR Disabled
[324281.734332] iwlwifi 0000:3a:00.0: L1 Enabled - LTR Disabled
[324281.734597] iwlwifi 0000:3a:00.0: L1 Enabled - LTR Disabled


Earlier on the same boot I got:

[266562.042662] ------------[ cut here ]------------
[266562.042693] WARNING: CPU: 2 PID: 994 at
drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1377
iwl_mvm_rx_tx_cmd+0x665/0x870 [iwlmvm]
[266562.042697] Modules linked in: rfcomm fuse ccm xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun nf_conntrack_netbios_ns
nf_conntrack_broadcast ip6t_REJECT nf_reject_ipv6 xt_conntrack
ip6t_rpfilter ebtable_broute bridge stp llc ebtable_nat
ip6table_mangle ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_raw ip6table_security iptable_mangle iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
iptable_raw iptable_security ebtable_filter ebtables ip6table_filter
ip6_tables cmac bnep arc4 iwlmvm vfat fat mac80211 snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel
snd_hda_codec iwlwifi intel_rapl snd_hwdep x86_pkg_temp_thermal
hid_multitouch coretemp snd_hda_core kvm_intel kvm snd_seq btusb btrtl
cfg80211 btbcm snd_seq_device btintel
[266562.042780]  snd_pcm bluetooth uvcvideo i2c_designware_platform
iTCO_wdt iTCO_vendor_support i2c_designware_core snd_timer
videobuf2_vmalloc dell_wmi videobuf2_memops snd videobuf2_v4l2
videobuf2_core videodev mei_me dell_laptop dell_smbios mei dcdbas
irqbypass efi_pstore joydev rtsx_pci_ms memstick efivars media pcspkr
soundcore i2c_i801 shpchp rfkill idma64 processor_thermal_device
intel_soc_dts_iosf intel_lpss_pci wmi nfsd acpi_als kfifo_buf tpm_tis
industrialio auth_rpcgss pinctrl_sunrisepoint int3400_thermal
intel_lpss_acpi pinctrl_intel tpm intel_lpss nfs_acl intel_hid
acpi_thermal_rel lockd int3403_thermal int340x_thermal_zone
sparse_keymap acpi_pad grace sunrpc binfmt_misc dm_crypt i915
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops rtsx_pci_sdmmc mmc_core drm crct10dif_pclmul
[266562.042923]  crc32_pclmul crc32c_intel ghash_clmulni_intel
serio_raw rtsx_pci i2c_hid video i2c_dev
[266562.042944] CPU: 2 PID: 994 Comm: irq/283-iwlwifi Tainted: G
 W       4.7.0-xps13+ #113
[266562.042950] Hardware name: Dell Inc. XPS 13 9350/07TYC2, BIOS
1.4.4 06/14/2016
[266562.042956]  0000000000000286 000000009bd58e95 ffff880273217bb0
ffffffff81462534
[266562.042967]  0000000000000000 0000000000000000 ffff880273217bf0
ffffffff81097a4b
[266562.042976]  0000056175c08720 0000000000000000 0000000000000d14
0000000000000d14
[266562.042986] Call Trace:
[266562.043000]  [<ffffffff81462534>] dump_stack+0x65/0x91
[266562.043008]  [<ffffffff81097a4b>] __warn+0xcb/0xf0
[266562.043016]  [<ffffffff81097b7d>] warn_slowpath_null+0x1d/0x20
[266562.043043]  [<ffffffffa085e2e5>] iwl_mvm_rx_tx_cmd+0x665/0x870 [iwlmvm]
[266562.043065]  [<ffffffffa0854605>] iwl_mvm_rx_common+0x165/0x260 [iwlmvm]
[266562.043082]  [<ffffffffa085475b>] iwl_mvm_rx+0x5b/0x70 [iwlmvm]
[266562.043102]  [<ffffffffa0734979>] iwl_pcie_rx_handle+0x319/0x950 [iwlwifi]
[266562.043127]  [<ffffffffa07363cb>] iwl_pcie_irq_handler+0x4db/0xb10 [iwlwifi]
[266562.043137]  [<ffffffff810f51c0>] ? irq_forced_thread_fn+0x70/0x70
[266562.043144]  [<ffffffff810f51e0>] irq_thread_fn+0x20/0x50
[266562.043152]  [<ffffffff810f54ad>] irq_thread+0x12d/0x1c0
[266562.043162]  [<ffffffff81887773>] ? __schedule+0x2f3/0x7b0
[266562.043169]  [<ffffffff810f52d0>] ? wake_threads_waitq+0x30/0x30
[266562.043177]  [<ffffffff810f5380>] ? irq_thread_dtor+0xb0/0xb0
[266562.043186]  [<ffffffff810b7808>] kthread+0xd8/0xf0
[266562.043197]  [<ffffffff8188c7bf>] ret_from_fork+0x1f/0x40
[266562.043207]  [<ffffffff810b7730>] ? kthread_worker_fn+0x160/0x160
[266562.043215] ---[ end trace fc942b7f981b5787 ]---
[266563.131187] ------------[ cut here ]------------
