Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:42534 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbbA3UXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 15:23:37 -0500
Received: by mail-ig0-f176.google.com with SMTP id hl2so6021437igb.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 12:23:36 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 30 Jan 2015 21:23:36 +0100
Message-ID: <CAAd0S9BwPQZhOZSzt2NU1SGjzv8i6685Y7Zb6qRQ1BzJ0P92SA@mail.gmail.com> (sfid-20150130_212341_718339_20307764)
Subject: [IWLMVM] Firmware restart issue with 3.19-rc6-wl with AC 3160, REV=0x164
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

since upgrading to 3.19-rc6-wl (3.19-rc5-wl is working fine). I can no
longer use the IWL 3160 in my laptop. As soon as the link goes up (the
modules load fine, just ip/ifconfig up), I get this:

[    5.960381] iwlwifi 0000:01:00.0: L1 Enabled - LTR Disabled
[    5.960722] iwlwifi 0000:01:00.0: L1 Enabled - LTR Disabled
[    6.256941] iwlwifi 0000:01:00.0: L1 Enabled - LTR Disabled
[    6.257392] iwlwifi 0000:01:00.0: L1 Enabled - LTR Disabled
[    6.272858] iwlwifi 0000:01:00.0: Microcode SW error detected.
Restarting 0x82000000.
[    6.272875] iwlwifi 0000:01:00.0: CSR values:
[    6.272886] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING
is CSR_INT_PERIODIC_REG)
[    6.272937] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89204
[    6.272985] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X8000ff40
[    6.273033] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
[    6.273080] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
[    6.273127] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
[    6.273173] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X00000000
[    6.273220] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
[    6.273266] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403cd
[    6.273313] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X00000164
[    6.273359] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X00000000
[    6.273406] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X80000000
[    6.273452] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X803a0000
[    6.273499] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080042
[    6.273545] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X00000000
[    6.273591] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[    6.273637] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[    6.273684] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[    6.273730] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000018
[    6.273777] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X880beb28
[    6.273823] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[    6.273869] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[    6.273916] iwlwifi 0000:01:00.0:      CSR_MONITOR_STATUS_REG: 0Xdbb7fff7
[    6.273962] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[    6.274009] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[    6.274018] iwlwifi 0000:01:00.0: FH register values:
[    6.274067] iwlwifi 0000:01:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X2921bc00
[    6.274114] iwlwifi 0000:01:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02921bd0
[    6.274161] iwlwifi 0000:01:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000010
[    6.274209] iwlwifi 0000:01:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[    6.274256] iwlwifi 0000:01:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[    6.274304] iwlwifi 0000:01:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[    6.274351] iwlwifi 0000:01:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[    6.274398] iwlwifi 0000:01:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[    6.274446] iwlwifi 0000:01:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[    6.274594] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[    6.274605] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
[    6.274614] iwlwifi 0000:01:00.0: Loaded firmware version: 23.11.10.0
[    6.274625] iwlwifi 0000:01:00.0: 0x00000038 | BAD_COMMAND
[    6.274637] iwlwifi 0000:01:00.0: 0x000002F0 | uPc
[    6.274647] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
[    6.274657] iwlwifi 0000:01:00.0: 0x00000B3C | branchlink2
[    6.274667] iwlwifi 0000:01:00.0: 0x00014960 | interruptlink1
[    6.274676] iwlwifi 0000:01:00.0: 0x00060117 | interruptlink2
[    6.274685] iwlwifi 0000:01:00.0: 0x0915001D | data1
[    6.274695] iwlwifi 0000:01:00.0: 0xDEADBEEF | data2
[    6.274704] iwlwifi 0000:01:00.0: 0xDEADBEEF | data3
[    6.274713] iwlwifi 0000:01:00.0: 0x003FE973 | beacon time
[    6.274722] iwlwifi 0000:01:00.0: 0x0000168C | tsf low
[    6.274731] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
[    6.274740] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[    6.274749] iwlwifi 0000:01:00.0: 0x0000168C | time gp2
[    6.274758] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
[    6.274767] iwlwifi 0000:01:00.0: 0x0004170B | uCode version
[    6.274776] iwlwifi 0000:01:00.0: 0x00000164 | hw version
[    6.274785] iwlwifi 0000:01:00.0: 0x00C89204 | board version
[    6.274794] iwlwifi 0000:01:00.0: 0x0915001D | hcmd
[    6.274803] iwlwifi 0000:01:00.0: 0x00022080 | isr0
[    6.274812] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[    6.274821] iwlwifi 0000:01:00.0: 0x00000002 | isr2
[    6.274829] iwlwifi 0000:01:00.0: 0x004000C0 | isr3
[    6.274838] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[    6.274847] iwlwifi 0000:01:00.0: 0x01000112 | isr_pref
[    6.274856] iwlwifi 0000:01:00.0: 0x00000000 | wait_event
[    6.274865] iwlwifi 0000:01:00.0: 0x000001CC | l2p_control
[    6.274874] iwlwifi 0000:01:00.0: 0x00000000 | l2p_duration
[    6.274883] iwlwifi 0000:01:00.0: 0x00000000 | l2p_mhvalid
[    6.274892] iwlwifi 0000:01:00.0: 0x00000000 | l2p_addr_match
[    6.274901] iwlwifi 0000:01:00.0: 0x00000007 | lmpm_pmg_sel
[    6.274910] iwlwifi 0000:01:00.0: 0x17121705 | timestamp
[    6.274919] iwlwifi 0000:01:00.0: 0x00001020 | flow_handler
[    6.274935] ieee80211 phy0: Hardware restart was requested
[    6.274974] iwlwifi 0000:01:00.0: FW Error notification: type
0x00000000 cmd_id 0x1D
[    6.274986] iwlwifi 0000:01:00.0: FW Error notification: seq 0x0915
service 0x0000001D
[    6.274996] iwlwifi 0000:01:00.0: FW Error notification: timestamp
0x            1687
[    6.275034] iwlwifi 0000:01:00.0: FW error in SYNC CMD SCD_QUEUE_CFG
[    6.275056] CPU: 2 PID: 684 Comm: NetworkManager Tainted: G
  O   3.19.0-rc6-wl-bd+ #4
[    6.275065] Hardware name: Acer Aspire V5-122P/Aspire V5-122P, BIOS
V2.12 01/20/2014
[    6.275074]  0000000000000000 0000000000000015 ffffffff813ea760
ffff88003742c000
[    6.275087]  ffffffffa0263306 ffff88003742c020 ffff880000000028
ffff8802921e34e8
[    6.275098]  ffff880200000000 ffff88028f724f60 ffffffff810611a1
ffff8802921e34a8
[    6.275110] Call Trace:
[    6.275137]  [<ffffffff813ea760>] ? dump_stack+0x40/0x50
[    6.275192]  [<ffffffffa0263306>] ?
iwl_trans_pcie_send_hcmd+0x36c/0x43d [iwlwifi]
[    6.275211]  [<ffffffff810611a1>] ? finish_wait+0x5d/0x5d
[    6.275251]  [<ffffffffa0d658eb>] ? iwl_mvm_send_cmd+0xd/0x22 [iwlmvm]
[    6.275285]  [<ffffffffa0d65933>] ? iwl_mvm_send_cmd_pdu+0x33/0x39 [iwlmvm]
[    6.275322]  [<ffffffffa0d660f9>] ? iwl_mvm_enable_txq+0x8f/0xbc [iwlmvm]
[    6.275359]  [<ffffffffa0d69a48>] ? iwl_mvm_add_aux_sta+0x42/0x9b [iwlmvm]
[    6.275390]  [<ffffffffa0d5db20>] ? iwl_mvm_up+0x223/0x417 [iwlmvm]
[    6.275405]  [<ffffffff811eb3ee>] ? blk_throtl_bio+0xc2/0x26b
[    6.275420]  [<ffffffff811f23e4>] ? cpumask_next_and+0x1c/0x39
[    6.275451]  [<ffffffffa0d617e2>] ? __iwl_mvm_mac_start+0x1df/0x216 [iwlmvm]
[    6.275480]  [<ffffffffa015a0a6>] ? rfkill_blocked+0x1a/0x25 [rfkill]
[    6.275511]  [<ffffffffa0d618d6>] ? iwl_mvm_mac_start+0xbd/0xd8 [iwlmvm]
[    6.275573]  [<ffffffffa0cf2da6>] ? ieee80211_do_open+0x14c/0x6c5 [mac80211]
[    6.275630]  [<ffffffffa0cf12e5>] ?
ieee80211_check_concurrent_iface+0x16c/0x181 [mac80211]
[    6.275649]  [<ffffffff81333fed>] ? __dev_open+0x97/0xe5
[    6.275660]  [<ffffffff81333f4b>] ? dev_set_rx_mode+0x1d/0x28
[    6.275671]  [<ffffffff8133423d>] ? __dev_change_flags+0x9d/0x12c
[    6.275682]  [<ffffffff813342e9>] ? dev_change_flags+0x1d/0x51
[    6.275698]  [<ffffffff810b4ae2>] ? __alloc_pages_nodemask+0x146/0x75b
[    6.275712]  [<ffffffff8133dfb7>] ? do_setlink+0x2b1/0x7a9
[    6.275729]  [<ffffffff81171edf>] ? __es_remove_extent+0x3e/0x2a3
[    6.275742]  [<ffffffff813403f1>] ? rtnl_newlink+0x374/0x5c9
[    6.275756]  [<ffffffff8132dd39>] ? netdev_master_upper_dev_get+0x9/0x4b
[    6.275767]  [<ffffffff81340177>] ? rtnl_newlink+0xfa/0x5c9
[    6.275784]  [<ffffffff8120f41e>] ? __nla_reserve+0x16/0x3e
[    6.275798]  [<ffffffff813209db>] ? sk_wake_async+0x19/0x3c
[    6.275814]  [<ffffffff81325900>] ? __alloc_skb+0x6a/0x199
[    6.275826]  [<ffffffff813407bf>] ? rtnetlink_rcv_msg+0x179/0x188
[    6.275840]  [<ffffffff810e8fb5>] ? __kmalloc_track_caller+0x57/0xd3
[    6.275855]  [<ffffffff81201500>] ? rhashtable_lookup_compare+0x35/0x50
[    6.275866]  [<ffffffff81340646>] ? rtnl_newlink+0x5c9/0x5c9
[    6.275881]  [<ffffffff8135497a>] ? netlink_rcv_skb+0x3f/0x82
[    6.275895]  [<ffffffff8133d1b8>] ? rtnetlink_rcv+0x1f/0x28
[    6.275906]  [<ffffffff813542ce>] ? netlink_unicast+0xcc/0x144
[    6.275918]  [<ffffffff81354802>] ? netlink_sendmsg+0x4bc/0x512
[    6.275934]  [<ffffffff8131f609>] ? do_sock_sendmsg+0x82/0x9b
[    6.275950]  [<ffffffff8131fa81>] ? copy_msghdr_from_user+0x17c/0x196
[    6.275963]  [<ffffffff8131fc12>] ? ___sys_sendmsg+0x177/0x1f1
[    6.275976]  [<ffffffff810b376f>] ? get_pfnblock_flags_mask+0x19/0x4a
[    6.275990]  [<ffffffff8103fb52>] ? __do_proc_dointvec+0x27c/0x2c2
[    6.276006]  [<ffffffff811fcd1a>] ? lockref_put_or_lock+0x44/0x5a
[    6.276020]  [<ffffffff81103286>] ? dput+0x4e/0x14d
[    6.276034]  [<ffffffff81107ba9>] ? __fget+0x1c/0x52
[    6.276047]  [<ffffffff8131fea8>] ? __sys_sendmsg+0x3b/0x5a
[    6.276063]  [<ffffffff813edd16>] ? system_call_fastpath+0x16/0x1b
[    6.276072] ------------[ cut here ]------------
[    6.276107] WARNING: CPU: 2 PID: 684 at
drivers/net/wireless/iwlwifi/mvm/utils.c:554
iwl_mvm_enable_txq+0xb3/0xbc [iwlmvm]()
[    6.276114] Failed to configure queue 15 on FIFO 5
[    6.276119] Modules linked in: ...
[    6.276797] CPU: 2 PID: 684 Comm: NetworkManager Tainted: G
  O   3.19.0-rc6-wl-bd+ #4
[    6.276805] Hardware name: Acer Aspire V5-122P/Aspire V5-122P, BIOS
V2.12 01/20/2014
[    6.276811]  0000000000000000 0000000000000009 ffffffff813ea760
ffff8802921e34f8
[    6.276822]  ffffffff8103af2e 0000000000000246 ffffffffa0d6611d
000000000000000f
[    6.276833]  ffff8802921e3590 000000000000000f ffff880291a39a48
0000000000001000
[    6.276843] Call Trace:
[    6.276857]  [<ffffffff813ea760>] ? dump_stack+0x40/0x50
[    6.276872]  [<ffffffff8103af2e>] ? warn_slowpath_common+0x93/0xab
[    6.276908]  [<ffffffffa0d6611d>] ? iwl_mvm_enable_txq+0xb3/0xbc [iwlmvm]
[    6.276920]  [<ffffffff8103af8b>] ? warn_slowpath_fmt+0x45/0x4a
[    6.276957]  [<ffffffffa0d6611d>] ? iwl_mvm_enable_txq+0xb3/0xbc [iwlmvm]
[    6.276993]  [<ffffffffa0d69a48>] ? iwl_mvm_add_aux_sta+0x42/0x9b [iwlmvm]
[    6.277023]  [<ffffffffa0d5db20>] ? iwl_mvm_up+0x223/0x417 [iwlmvm]
[    6.277035]  [<ffffffff811eb3ee>] ? blk_throtl_bio+0xc2/0x26b
[    6.277048]  [<ffffffff811f23e4>] ? cpumask_next_and+0x1c/0x39
[    6.277079]  [<ffffffffa0d617e2>] ? __iwl_mvm_mac_start+0x1df/0x216 [iwlmvm]
[    6.277102]  [<ffffffffa015a0a6>] ? rfkill_blocked+0x1a/0x25 [rfkill]
[    6.277133]  [<ffffffffa0d618d6>] ? iwl_mvm_mac_start+0xbd/0xd8 [iwlmvm]
[    6.277191]  [<ffffffffa0cf2da6>] ? ieee80211_do_open+0x14c/0x6c5 [mac80211]
[    6.277248]  [<ffffffffa0cf12e5>] ?
ieee80211_check_concurrent_iface+0x16c/0x181 [mac80211]
[    6.277294]  [<ffffffff81333fed>] ? __dev_open+0x97/0xe5
[    6.277338]  [<ffffffff81333f4b>] ? dev_set_rx_mode+0x1d/0x28
[    6.277381]  [<ffffffff8133423d>] ? __dev_change_flags+0x9d/0x12c
[    6.277421]  [<ffffffff813342e9>] ? dev_change_flags+0x1d/0x51
[    6.277467]  [<ffffffff810b4ae2>] ? __alloc_pages_nodemask+0x146/0x75b
[    6.277507]  [<ffffffff8133dfb7>] ? do_setlink+0x2b1/0x7a9
[    6.277531]  [<ffffffff81171edf>] ? __es_remove_extent+0x3e/0x2a3
[    6.277543]  [<ffffffff813403f1>] ? rtnl_newlink+0x374/0x5c9
[    6.277556]  [<ffffffff8132dd39>] ? netdev_master_upper_dev_get+0x9/0x4b
[    6.277566]  [<ffffffff81340177>] ? rtnl_newlink+0xfa/0x5c9
[    6.277580]  [<ffffffff8120f41e>] ? __nla_reserve+0x16/0x3e
[    6.277591]  [<ffffffff813209db>] ? sk_wake_async+0x19/0x3c
[    6.277607]  [<ffffffff81325900>] ? __alloc_skb+0x6a/0x199
[    6.277619]  [<ffffffff813407bf>] ? rtnetlink_rcv_msg+0x179/0x188
[    6.277631]  [<ffffffff810e8fb5>] ? __kmalloc_track_caller+0x57/0xd3
[    6.277644]  [<ffffffff81201500>] ? rhashtable_lookup_compare+0x35/0x50
[    6.277655]  [<ffffffff81340646>] ? rtnl_newlink+0x5c9/0x5c9
[    6.277667]  [<ffffffff8135497a>] ? netlink_rcv_skb+0x3f/0x82
[    6.277680]  [<ffffffff8133d1b8>] ? rtnetlink_rcv+0x1f/0x28
[    6.277692]  [<ffffffff813542ce>] ? netlink_unicast+0xcc/0x144
[    6.277704]  [<ffffffff81354802>] ? netlink_sendmsg+0x4bc/0x512
[    6.277718]  [<ffffffff8131f609>] ? do_sock_sendmsg+0x82/0x9b
[    6.277734]  [<ffffffff8131fa81>] ? copy_msghdr_from_user+0x17c/0x196
[    6.277746]  [<ffffffff8131fc12>] ? ___sys_sendmsg+0x177/0x1f1
[    6.277759]  [<ffffffff810b376f>] ? get_pfnblock_flags_mask+0x19/0x4a
[    6.277771]  [<ffffffff8103fb52>] ? __do_proc_dointvec+0x27c/0x2c2
[    6.277802]  [<ffffffff811fcd1a>] ? lockref_put_or_lock+0x44/0x5a
[    6.277847]  [<ffffffff81103286>] ? dput+0x4e/0x14d
[    6.277887]  [<ffffffff81107ba9>] ? __fget+0x1c/0x52
[    6.277909]  [<ffffffff8131fea8>] ? __sys_sendmsg+0x3b/0x5a
[    6.277924]  [<ffffffff813edd16>] ? system_call_fastpath+0x16/0x1b
[    6.277933] ---[ end trace af5334bb0c09eed9 ]---

Is there a likely "suspect" - which could cause this issue? I've tried
bisecting it
but unfortunately I can't find the culprit since the created
iwlwifi/iwlmvm cause panics in:

[  545.157607] BUG: unable to handle kernel paging request at 000000ffffffffff
[  545.157625] IP: [<ffffffffa0e1e1bf>]
iwl_mvm_mac_ctxt_cmd_common+0x103/0x33d [iwlmvm]
[  545.157655] PGD 0
[  545.157662] Oops: 0000 [#1] SMP
[  545.157669] Modules linked in: iwlmvm(O) iwlwifi(O)
[  545.157828] CPU: 3 PID: 684 Comm: NetworkManager Tainted: G
W  O   3.19.0-rc6-wl-bd+ #4
[  545.157836] Hardware name: Acer Aspire V5-122P/Aspire V5-122P, BIOS
V2.12 01/20/2014
[  545.157844] task: ffff88028f724f60 ti: ffff8802921e0000 task.ti:
ffff8802921e0000
[  545.157850] RIP: 0010:[<ffffffffa0e1e1bf>]  [<ffffffffa0e1e1bf>]
iwl_mvm_mac_ctxt_cmd_common+0x103/0x33d [iwlmvm]
[  545.157874] RSP: 0018:ffff8802921e3548  EFLAGS: 00010206
[  545.157881] RAX: 0000000000000000 RBX: ffff8802921e35b4 RCX: 0000000000000000
[  545.157887] RDX: 000000ffffffffff RSI: ffff8802799a5180 RDI: ffff88025a4dda48
[  545.157892] RBP: ffff8802799a5180 R08: 0000000000000001 R09: 0000000000000003
[  545.157898] R10: 0000000000000000 R11: 0000000000000008 R12: ffff8802799a4f28
[  545.157903] R13: ffff88025a4dda48 R14: 0000000000000001 R15: 0000000000000000
[  545.157910] FS:  00007fb8f1773880(0000) GS:ffff88029ed80000(0000)
knlGS:0000000000000000
[  545.157916] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  545.157922] CR2: 000000ffffffffff CR3: 00000002920aa000 CR4: 00000000000407e0
[  545.157926] Stack:
[  545.157930]  0000000000000000 0000000000000003 ffff88025a4dda48
ffff88009b704000
[  545.157939]  0000000000000003 ffff8802799a5180 ffff8802921e3618
ffff88025a4dda48
[  545.157948]  0000000000000001 0000000000000001 0000000000000000
ffffffffa0e1e456
[  545.157956] Call Trace:
[  545.157981]  [<ffffffffa0e1e456>] ?
iwl_mvm_mac_ctxt_cmd_sta+0x5d/0x144 [iwlmvm]
[  545.158006]  [<ffffffffa0e1ed8d>] ? iwl_mvm_mac_ctxt_add+0x6b/0x97 [iwlmvm]
[  545.158027]  [<ffffffffa0e1a8d0>] ?
iwl_mvm_mac_add_interface+0xa0/0x1f1 [iwlmvm]
[  545.158073]  [<ffffffffa0cf1102>] ? drv_add_interface+0x47/0x70 [mac80211]
[  545.158117]  [<ffffffffa0cf2f55>] ? ieee80211_do_open+0x2fb/0x6c5 [mac80211]
[  545.158159]  [<ffffffffa0cf12e5>] ?
ieee80211_check_concurrent_iface+0x16c/0x181 [mac80211]
[  545.158176]  [<ffffffff81333fed>] ? __dev_open+0x97/0xe5
... [mostly likely due to some API mismatch]

Any leads?

Regards,
  Christian
