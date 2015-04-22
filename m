Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbbDVUme (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 16:42:34 -0400
Date: Wed, 22 Apr 2015 22:42:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: iwlwifi getting stuck with current Linus' tree (646da63172)
Message-ID: <alpine.LNX.2.00.1504222235340.3695@pobox.suse.cz> (sfid-20150422_224256_796876_53540EE2)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been running current Linus' tree and have been getting system lockups 
frequently. After a few "silent" lockups, I was able to obtain a dmesg 
before the machine turned dead again (wifi stopped working shortly before 
that).

Before starting to debug / bisect (last known good on this machine is 
4.0-rc6), I am attaching the dmesg in case someone already knows what the 
issue is.

 iwlwifi 0000:03:00.0: Error sending REPLY_ADD_STA: time out after 2000ms.
 iwlwifi 0000:03:00.0: Current CMD queue read_ptr 235 write_ptr 237
 iwlwifi 0000:03:00.0: Loaded firmware version: 8.83.5.1 build 33692
 iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
 iwlwifi 0000:03:00.0: Status: 0x0000004C, count: -1
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | ADVANCED_SYSASSERT          
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | uPc
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | branchlink1
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | branchlink2
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | interruptlink1
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | interruptlink2
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | data1
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | data2
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | line
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | beacon time
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | tsf low
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | tsf hi
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | time gp1
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | time gp2
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | time gp3
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | uCode version
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | hw version
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | board version
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | hcmd
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | isr0
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | isr1
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | isr2
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | isr3
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | isr4
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | isr_pref
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | wait_event
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | l2p_control
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | l2p_duration
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | l2p_mhvalid
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | l2p_addr_match
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | lmpm_pmg_sel
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | timestamp
 iwlwifi 0000:03:00.0: 0xFFFFFFFF | flow_handler
 iwlwifi 0000:03:00.0: Log capacity -1 is bogus, limit to 256 entries
 iwlwifi 0000:03:00.0: Log write index -1 is bogus, limit to 256
 iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 20 entries
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 iwlwifi 0000:03:00.0: EVT_LOGT:4294967295:0xffffffff:4294967295
 wlan0: HW problem - can not stop rx aggregation for 00:b0:0c:4e:a5:28 tid 0
 ieee80211 phy0: Hardware restart was requested
 iwlwifi 0000:03:00.0: iwl_trans_wait_tx_queue_empty bad state = 0
 iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
 iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
 iwlwifi 0000:03:00.0: Failed to load firmware chunk!
 iwlwifi 0000:03:00.0: Could not load the [0] uCode section
 iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
 iwlwifi 0000:03:00.0: Unable to initialize device.
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 30 at net/mac80211/util.c:1800 ieee80211_reconfig+0x66a/0x2a00 [mac80211]()
 Hardware became unavailable during restart.
 Modules linked in: ctr ccm fuse tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defra
e_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack af_packet iptable_filter ip_tables x_tables iTCO_wdt iTCO_vendor_support iwldvm mac80211 kvm_intel kvm snd_hda_codec_conexant snd_hda_codec_generic iwlwifi microcode snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm cfg80211 thinkpad_acpi snd_seq pcspkr i2c_i801 lpc_ich mfd_core snd_seq_device snd_hda_core snd_timer e1000e snd ptp pps_core thermal wmi ac soundcore rfkill battery tpm_tis tpm acpi_cpufreq processor dm_mod ehci_pci uhci_hcd ehci_hcd i915 i2c_algo_bit drm_kms_helper ata_generic usbcore usb_common drm video thermal_sys button sg autofs4
 CPU: 0 PID: 30 Comm: kworker/0:1 Not tainted 4.0.0-09000-g646da63 #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
 Workqueue: events ieee80211_restart_work [mac80211]
  ffffffffc0721b26 ffff880079443c28 ffffffff81686cc3 0000000000000000
  ffff880079443c78 ffff880079443c68 ffffffff8105e8fa ffffffff81c44500
  ffff880076091e18 00000000ffffff92 ffff88007c215b80 ffff88007c21e500
 Call Trace:
  [<ffffffff81686cc3>] dump_stack+0x4c/0x65
  [<ffffffff8105e8fa>] warn_slowpath_common+0x8a/0xc0
  [<ffffffff8105e976>] warn_slowpath_fmt+0x46/0x50
  [<ffffffffc06c2e1c>] ? trace_drv_return_int+0x18c/0x1c0 [mac80211]
  [<ffffffffc06c7aba>] ieee80211_reconfig+0x66a/0x2a00 [mac80211]
  [<ffffffff8168cbee>] ? mutex_unlock+0xe/0x10
  [<ffffffffc0677122>] ieee80211_restart_work+0x42/0x70 [mac80211]
  [<ffffffff8107ce58>] process_one_work+0x1d8/0x800
  [<ffffffff8107cdcb>] ? process_one_work+0x14b/0x800
  [<ffffffff8107d59b>] worker_thread+0x11b/0x470
  [<ffffffff8107d480>] ? process_one_work+0x800/0x800
  [<ffffffff81083b9f>] kthread+0xef/0x110
  [<ffffffff81083ab0>] ? kthread_create_on_node+0x210/0x210
  [<ffffffff8168fce2>] ret_from_fork+0x42/0x70
  [<ffffffff81083ab0>] ? kthread_create_on_node+0x210/0x210
 ---[ end trace 5cececd09b834ad1 ]---
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 30 at net/mac80211/driver-ops.h:12 ieee80211_do_stop+0xad4/0xb80 [mac80211]()
 wlan0:  Failed check-sdata-in-driver check, flags: 0x4
 Modules linked in: ctr ccm fuse tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack af_packet iptable_filter ip_tables x_tables iTCO_wdt iTCO_vendor_support iwldvm mac80211 kvm_intel kvm snd_hda_codec_conexant snd_hda_codec_generic iwlwifi microcode snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm cfg80211 thinkpad_acpi snd_seq pcspkr i2c_i801 lpc_ich mfd_core snd_seq_device snd_hda_core snd_timer e1000e snd ptp pps_core thermal wmi ac soundcore rfkill battery tpm_tis tpm acpi_cpufreq processor dm_mod ehci_pci uhci_hcd ehci_hcd i915 i2c_algo_bit drm_kms_helper ata_generic usbcore usb_common drm video thermal_sys button sg autofs4
 CPU: 0 PID: 30 Comm: kworker/0:1 Tainted: G        W       4.0.0-09000-g646da63 #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
 Workqueue: events ieee80211_restart_work [mac80211]
  ffffffffc07215fa ffff880079443a78 ffffffff81686cc3 0000000000000000
  ffff880079443ac8 ffff880079443ab8 ffffffff8105e8fa 0000000000000246
  ffff88006a6009c0 ffff8800760909e0 0000000000000000 ffff880076091780
 Call Trace:
  [<ffffffff81686cc3>] dump_stack+0x4c/0x65
  [<ffffffff8105e8fa>] warn_slowpath_common+0x8a/0xc0
  [<ffffffff8105e976>] warn_slowpath_fmt+0x46/0x50
  [<ffffffff8108ae2d>] ? __might_sleep+0x4d/0x90
  [<ffffffffc069d8e4>] ieee80211_do_stop+0xad4/0xb80 [mac80211]
  [<ffffffff815a54a7>] ? dev_deactivate_many+0x257/0x310
  [<ffffffffc069d9aa>] ieee80211_stop+0x1a/0x20 [mac80211]
  [<ffffffff81577645>] __dev_close_many+0x95/0xe0
  [<ffffffff81577718>] dev_close_many+0x88/0x120
  [<ffffffff81579d46>] dev_close.part.77+0x36/0x50
  [<ffffffff81579d81>] dev_close+0x21/0x30
  [<ffffffffc03896ad>] cfg80211_shutdown_all_interfaces+0x4d/0xc0 [cfg80211]
  [<ffffffffc06c2675>] ieee80211_handle_reconfig_failure+0x95/0xa0 [mac80211]
  [<ffffffffc06c753a>] ieee80211_reconfig+0xea/0x2a00 [mac80211]
  [<ffffffff8168cbee>] ? mutex_unlock+0xe/0x10
  [<ffffffffc0677122>] ieee80211_restart_work+0x42/0x70 [mac80211]
  [<ffffffff8107ce58>] process_one_work+0x1d8/0x800
  [<ffffffff8107cdcb>] ? process_one_work+0x14b/0x800
  [<ffffffff8107d59b>] worker_thread+0x11b/0x470
  [<ffffffff8107d480>] ? process_one_work+0x800/0x800
  [<ffffffff81083b9f>] kthread+0xef/0x110
  [<ffffffff81083ab0>] ? kthread_create_on_node+0x210/0x210
  [<ffffffff8168fce2>] ret_from_fork+0x42/0x70
  [<ffffffff81083ab0>] ? kthread_create_on_node+0x210/0x210
 ---[ end trace 5cececd09b834ad2 ]---
 cfg80211: Calling CRDA to update world regulatory domain
 cfg80211: World regulatory domain updated:
 cfg80211:  DFS Master region: unset
 cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
 cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
 cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
 cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
 cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
 cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
 cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
 cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
 cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
 iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
 iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
 iwlwifi 0000:03:00.0: Failed to load firmware chunk!
 iwlwifi 0000:03:00.0: Could not load the [0] uCode section
 iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
 iwlwifi 0000:03:00.0: Unable to initialize device.
 iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
 iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
 iwlwifi 0000:03:00.0: Failed to load firmware chunk!
 iwlwifi 0000:03:00.0: Could not load the [0] uCode section
 iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
 iwlwifi 0000:03:00.0: Unable to initialize device.
 e1000e: eth0 NIC Link is Down
 IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
 iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
 iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0

-- 
Jiri Kosina
SUSE Labs
