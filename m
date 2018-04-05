Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:38733 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbeDEOzL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 10:55:11 -0400
To: johannes.berg@intel.com
Cc: emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linux-wireless@vger.kernel.org
From: Daniel Borkmann <daniel@iogearbox.net>
Subject: iwlwifi: FW error in SYNC CMD TIME_QUOTA_CMD
Message-ID: <799ecceb-8b2a-bf8c-b408-374a02280306@iogearbox.net> (sfid-20180405_165515_591063_12773CF6)
Date: Thu, 5 Apr 2018 16:55:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey guys,

after upgrading to 4608f064532c ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next")
my kernel log gets constantly flooded with the below message and wireless stops
working ... just in case you haven't had a report on this yet. Downgrading back
to older v4.16-rcX kernel gets everything back to normal working state; haven't
had time for bisection yet, but hopefully the below would provide some clue.

[...]
[  513.429683] ieee80211 phy0: Hardware restart was requested
[  513.429688] iwlwifi 0000:04:00.0: FW Error notification: type 0x00000000 cmd_id 0x32
[  513.429689] iwlwifi 0000:04:00.0: FW Error notification: seq 0x0070 service 0x00000032
[  513.429690] iwlwifi 0000:04:00.0: FW Error notification: timestamp 0x            9AB3
[  513.429694] iwlwifi 0000:04:00.0: FW error in SYNC CMD TIME_QUOTA_CMD
[  513.429696] CPU: 2 PID: 330 Comm: kworker/2:2 Tainted: G        W        4.16.0+ #83
[  513.429697] Hardware name: LENOVO 20FBCTO1WW/20FBCTO1WW, BIOS N1FET47W (1.21 ) 11/28/2016
[  513.429705] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  513.429706] Call Trace:
[  513.429710]  dump_stack+0x5c/0x85
[  513.429714]  iwl_trans_pcie_send_hcmd+0x41f/0x510 [iwlwifi]
[  513.429717]  ? wait_woken+0x80/0x80
[  513.429719]  iwl_trans_send_cmd+0x4a/0xc0 [iwlwifi]
[  513.429721]  ? __update_load_avg_se.isra.39+0x1eb/0x1f0
[  513.429724]  iwl_mvm_send_cmd+0x2c/0x90 [iwlmvm]
[  513.429727]  iwl_mvm_send_cmd_pdu+0x58/0x80 [iwlmvm]
[  513.429731]  ? iwl_mvm_update_quotas+0x372/0x5d0 [iwlmvm]
[  513.429733]  iwl_mvm_update_quotas+0x372/0x5d0 [iwlmvm]
[  513.429735]  ? check_preempt_wakeup+0x178/0x240
[  513.429738]  ? iwl_mvm_mac_reconfig_complete+0x150/0x1d0 [iwlmvm]
[  513.429740]  iwl_mvm_mac_reconfig_complete+0x150/0x1d0 [iwlmvm]
[  513.429747]  ? ieee80211_wake_queues_by_reason+0x83/0xa0 [mac80211]
[  513.429753]  ieee80211_reconfig+0x1e3/0x1210 [mac80211]
[  513.429756]  ? try_to_del_timer_sync+0x4d/0x80
[  513.429760]  ieee80211_restart_work+0x9e/0xd0 [mac80211]
[  513.429762]  process_one_work+0x1cb/0x3a0
[  513.429763]  worker_thread+0x47/0x3f0
[  513.429765]  kthread+0xf5/0x130
[  513.429766]  ? rescuer_thread+0x350/0x350
[  513.429767]  ? kthread_create_worker_on_cpu+0x70/0x70
[  513.429768]  ? do_syscall_64+0x6e/0x190
[  513.429770]  ? SyS_exit_group+0x10/0x10
[  513.429771]  ret_from_fork+0x35/0x40
[  513.429773] iwlwifi 0000:04:00.0: Failed to send quota: -5
[  513.429775] iwlwifi 0000:04:00.0: Failed to update quotas after restart (-5)
[  514.163758] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
[  514.163987] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  514.163988] iwlwifi 0000:04:00.0: Status: 0x00000100, count: 6
[  514.163989] iwlwifi 0000:04:00.0: Loaded firmware version: 27.455470.0
[  514.163991] iwlwifi 0000:04:00.0: 0x00000038 | BAD_COMMAND
[  514.163991] iwlwifi 0000:04:00.0: 0x00A002F1 | trm_hw_status0
[  514.163992] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  514.163993] iwlwifi 0000:04:00.0: 0x0000FECC | branchlink2
[  514.163994] iwlwifi 0000:04:00.0: 0x00029602 | interruptlink1
[  514.163995] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
[  514.163996] iwlwifi 0000:04:00.0: 0x00700032 | data1
[  514.163997] iwlwifi 0000:04:00.0: 0x00000032 | data2
[  514.163997] iwlwifi 0000:04:00.0: 0x00000033 | data3
[  514.163998] iwlwifi 0000:04:00.0: 0x003F648A | beacon time
[  514.163999] iwlwifi 0000:04:00.0: 0x00009B74 | tsf low
[  514.164000] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  514.164001] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  514.164002] iwlwifi 0000:04:00.0: 0x00009B75 | time gp2
[  514.164002] iwlwifi 0000:04:00.0: 0x00000001 | uCode revision type
[  514.164003] iwlwifi 0000:04:00.0: 0x0000001B | uCode version major
[  514.164004] iwlwifi 0000:04:00.0: 0x0006F32E | uCode version minor
[  514.164005] iwlwifi 0000:04:00.0: 0x00000201 | hw version
[  514.164006] iwlwifi 0000:04:00.0: 0x00489008 | board version
[  514.164007] iwlwifi 0000:04:00.0: 0x00700032 | hcmd
[  514.164008] iwlwifi 0000:04:00.0: 0x00122080 | isr0
[  514.164008] iwlwifi 0000:04:00.0: 0x10800000 | isr1
[  514.164009] iwlwifi 0000:04:00.0: 0x28201802 | isr2
[  514.164010] iwlwifi 0000:04:00.0: 0x004000C0 | isr3
[  514.164011] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[  514.164012] iwlwifi 0000:04:00.0: 0x002F0128 | last cmd Id
[  514.164012] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  514.164013] iwlwifi 0000:04:00.0: 0x000077DD | l2p_control
[  514.164014] iwlwifi 0000:04:00.0: 0x00000820 | l2p_duration
[  514.164015] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  514.164016] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  514.164017] iwlwifi 0000:04:00.0: 0x0000000D | lmpm_pmg_sel
[  514.164018] iwlwifi 0000:04:00.0: 0x04012314 | timestamp
[  514.164018] iwlwifi 0000:04:00.0: 0x00002838 | flow_handler
[  514.164190] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  514.164192] iwlwifi 0000:04:00.0: Status: 0x00000100, count: 7
[  514.164193] iwlwifi 0000:04:00.0: 0x00000070 | ADVANCED_SYSASSERT
[  514.164194] iwlwifi 0000:04:00.0: 0x00000000 | umac branchlink1
[  514.164195] iwlwifi 0000:04:00.0: 0xC0085E88 | umac branchlink2
[  514.164196] iwlwifi 0000:04:00.0: 0xC0083660 | umac interruptlink1
[  514.164197] iwlwifi 0000:04:00.0: 0xC008AC82 | umac interruptlink2
[  514.164198] iwlwifi 0000:04:00.0: 0x00000800 | umac data1
[  514.164199] iwlwifi 0000:04:00.0: 0xC008AC82 | umac data2
[  514.164200] iwlwifi 0000:04:00.0: 0xDEADBEEF | umac data3
[  514.164201] iwlwifi 0000:04:00.0: 0x0000001B | umac major
[  514.164202] iwlwifi 0000:04:00.0: 0x0006F32E | umac minor
[  514.164203] iwlwifi 0000:04:00.0: 0xC088627C | frame pointer
[  514.164204] iwlwifi 0000:04:00.0: 0xC088627C | stack pointer
[  514.164206] iwlwifi 0000:04:00.0: 0x00000000 | last host cmd
[  514.164207] iwlwifi 0000:04:00.0: 0x00000000 | isr status reg
[  514.164210] ieee80211 phy0: Hardware restart was requested
[  514.164217] iwlwifi 0000:04:00.0: FW Error notification: type 0x00000000 cmd_id 0x32
[  514.164218] iwlwifi 0000:04:00.0: FW Error notification: seq 0x0070 service 0x00000032
[  514.164220] iwlwifi 0000:04:00.0: FW Error notification: timestamp 0x            9B71
[  514.164226] iwlwifi 0000:04:00.0: FW error in SYNC CMD TIME_QUOTA_CMD
[  514.164229] CPU: 2 PID: 330 Comm: kworker/2:2 Tainted: G        W        4.16.0+ #83
[  514.164229] Hardware name: LENOVO 20FBCTO1WW/20FBCTO1WW, BIOS N1FET47W (1.21 ) 11/28/2016
[  514.164239] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[...]

(Sequence repeats over and over.)

Thanks,
Daniel
