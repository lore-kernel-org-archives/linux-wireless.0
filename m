Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56753 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab0DOVIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:08:45 -0400
Received: by gwaa18 with SMTP id a18so939338gwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 14:08:44 -0700 (PDT)
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 15 Apr 2010 17:08:15 -0400
Message-ID: <g2rcb0375e11004151408m4a74639cz28e6129054824543@mail.gmail.com>
Subject: 2.6.33 iwl5350 firmware crash
To: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A couple days ago I captured a firmware crash.  This is Linux 2.6.33,
with no relevant patches applied.  I triggered it running vncviewer
over ssh.  Power management was on (i.e. iwconfig power on) and
iwlcore.no_sleep_autoadjust was set to N.

After this crash, IIRC I had to restart to get my wireless back.
(Unloading and reloading iwlagn left wlan0 down and trying to bring it
up (ip link set wlan0 up) failed.)

--Andy

Here's the module load info:
[23726.654830] iwlagn 0000:03:00.0: PCI INT A disabled
[23733.397707] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
Linux, 2.6.33-kds
[23733.397711] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[23733.397825] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[23733.397858] iwlagn 0000:03:00.0: setting latency timer to 64
[23733.398736] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link
5350AGN REV=0x24
[23733.418930] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24
802.11a channels
[23733.419140] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[23733.420395] phy3: Selected rate control algorithm 'iwl-agn-rs'
[23733.433844] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-2.ucode
[23733.449813] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[23733.470633] cfg80211: Calling CRDA for country: US
[23733.484154] cfg80211: Current regulatory domain intersected:
[23733.484157]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[23733.484161]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)

And here's the firmware crash:
[71353.704057] wlan0: detected beacon loss from AP - sending probe request
[71355.332289] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[71413.110480] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[71461.039596] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[71541.335924] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[71598.785696] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[71641.001578] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[71689.852315] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[71772.604871] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[71793.197121] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[71818.587532] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[71921.559346] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[72056.421955] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[72127.440680] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[72206.594310] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[72403.955312] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[72832.744281] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[72900.133789] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[73233.158190] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[73702.799886] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[73955.217142] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[74112.526228] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[74360.604048] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[74505.899763] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[74664.377658] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[74686.378492] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[74751.153842] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[74843.694071] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[74934.818091] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:0c:42:61:39:c4 tid = 0
[74944.425130] iwlagn 0000:03:00.0: Microcode SW error detected.
Restarting 0x2000000.
[74944.425154] iwlagn 0000:03:00.0: Start IWL Error Log Dump:
[74944.425160] iwlagn 0000:03:00.0: Status: 0x000212E4, count: 5
[74944.425291] iwlagn 0000:03:00.0: Desc
Time       data1      data2      line
[74944.425301] iwlagn 0000:03:00.0: NMI_INTERRUPT_WDG            (#04)
1638059893 0x00000002 0x07030000 3664
[74944.425308] iwlagn 0000:03:00.0: blink1  blink2  ilink1  ilink2
[74944.425314] iwlagn 0000:03:00.0: 0x005AA 0x006E8 0x008B2 0x022C8
[74944.425376] iwlagn 0000:03:00.0: Start IWL Event Log Dump: display
last 20 entries
[74944.425400] iwlagn 0000:03:00.0: EVT_LOGT:4186771484:0x0000010f:0106
[74944.425416] iwlagn 0000:03:00.0: EVT_LOGT:4186771486:0x00000000:0302
[74944.425432] iwlagn 0000:03:00.0: EVT_LOGT:4186771512:0x00000436:0323
[74944.425448] iwlagn 0000:03:00.0: EVT_LOGT:4186771534:0x00000000:1350
[74944.425464] iwlagn 0000:03:00.0: EVT_LOGT:4186771534:0x00000000:1351
[74944.425479] iwlagn 0000:03:00.0: EVT_LOGT:4186771535:0x00000000:1352
[74944.425495] iwlagn 0000:03:00.0: EVT_LOGT:4186771535:0x00000002:1353
[74944.425511] iwlagn 0000:03:00.0: EVT_LOGT:4186771551:0x01000000:0221
[74944.425527] iwlagn 0000:03:00.0: EVT_LOGT:4186771634:0x0000010f:0106
[74944.425543] iwlagn 0000:03:00.0: EVT_LOGT:4186771636:0x00000000:0302
[74944.425559] iwlagn 0000:03:00.0: EVT_LOGT:4186771667:0x000000b4:0303
[74944.425575] iwlagn 0000:03:00.0: EVT_LOGT:4186771674:0x000000c4:0322
[74944.425591] iwlagn 0000:03:00.0: EVT_LOGT:4186771724:0x00000000:0302
[74944.425606] iwlagn 0000:03:00.0: EVT_LOGT:4186771751:0x00000436:0323
[74944.425622] iwlagn 0000:03:00.0: EVT_LOGT:4186771774:0x00000000:1350
[74944.425638] iwlagn 0000:03:00.0: EVT_LOGT:4186771774:0x00000000:1351
[74944.425654] iwlagn 0000:03:00.0: EVT_LOGT:4186771774:0x00000000:1352
[74944.425670] iwlagn 0000:03:00.0: EVT_LOGT:4186771775:0x00000002:1353
[74944.425686] iwlagn 0000:03:00.0: EVT_LOGT:4186971627:0x000000d7:0123
[74944.425702] iwlagn 0000:03:00.0: EVT_LOGT:4186971635:0x00000000:0125
[74981.401926] iwlagn 0000:03:00.0: Stopping AGG while state not ON or starting
[74981.401939] iwlagn 0000:03:00.0: queue number out of range: 0, must
be 10 to 19
[74981.401945] ------------[ cut here ]------------
[74981.401980] WARNING: at net/mac80211/agg-tx.c:152
___ieee80211_stop_tx_ba_session+0x87/0x8c [mac80211]()
[74981.401987] Hardware name: 7465CTO
[74981.401991] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat
ip6table_filter ip6_tables bluetooth tun iwlagn fuse tp_smapi
thinkpad_ec cpufreq_ondemand ip6t_REJECT nf_conntrack_ipv6 ipv6
dm_multipath kvm_intel kvm uinput snd_hda_codec_conexant arc4
snd_hda_intel ecb snd_hda_codec snd_hwdep iwlcore snd_seq
snd_seq_device thinkpad_acpi snd_pcm mac80211 tpm_tis tpm snd_timer
hwmon tpm_bios snd cfg80211 i2400m_usb i2400m soundcore iTCO_wdt
snd_page_alloc i2c_i801 iTCO_vendor_support aes_x86_64 aes_generic xts
gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video
output [last unloaded: nf_nat]
[74981.402101] Pid: 0, comm: swapper Not tainted 2.6.33 #22
[74981.402106] Call Trace:
[74981.402111]  <IRQ>  [<ffffffff81040011>] warn_slowpath_common+0x7c/0x94
[74981.402136]  [<ffffffff8104003d>] warn_slowpath_null+0x14/0x16
[74981.402158]  [<ffffffffa016af33>]
___ieee80211_stop_tx_ba_session+0x87/0x8c [mac80211]
[74981.402181]  [<ffffffffa016a7b9>] ieee80211_process_delba+0x65/0x75
[mac80211]
[74981.402207]  [<ffffffffa017638f>]
ieee80211_invoke_rx_handlers+0x1132/0x16d5 [mac80211]
[74981.402219]  [<ffffffff81031467>] ? enqueue_task_fair+0x44/0x87
[74981.402230]  [<ffffffff810b8494>] ? free_one_page+0x5d/0x69
[74981.402255]  [<ffffffffa0176fa2>] ieee80211_rx+0x670/0x6da [mac80211]
[74981.402286]  [<ffffffffa0206124>] iwl_rx_reply_rx+0xbc4/0xbf4 [iwlcore]
[74981.402296]  [<ffffffff81030b85>] ? __enqueue_entity+0x7b/0x7d
[74981.402305]  [<ffffffff81030de3>] ? enqueue_entity+0x25c/0x269
[74981.402314]  [<ffffffff81031467>] ? enqueue_task_fair+0x44/0x87
[74981.402324]  [<ffffffff8102a147>] ? enqueue_task+0x5c/0x67
[74981.402335]  [<ffffffff81201ad5>] ? virt_to_phys+0x9/0xb
[74981.402344]  [<ffffffff81201e2b>] ? unmap_single+0x29/0x53
[74981.402362]  [<ffffffffa0246b35>] iwl_rx_handle+0x2b9/0x4cb [iwlagn]
[74981.402373]  [<ffffffff81060081>] ? sched_clock_cpu+0xc6/0xd4
[74981.402395]  [<ffffffffa01f9f1e>] ? __iwl_write32+0xbc/0xcb [iwlcore]
[74981.402412]  [<ffffffffa0248325>] iwl_irq_tasklet+0x579/0x6fd [iwlagn]
[74981.402436]  [<ffffffffa01ff1ae>] ? iwl_isr_ict+0x223/0x49f [iwlcore]
[74981.402446]  [<ffffffff8104570b>] tasklet_action+0x7e/0xdc
[74981.402455]  [<ffffffff8104647b>] __do_softirq+0xf2/0x1c1
[74981.402465]  [<ffffffff8108c7f2>] ? handle_IRQ_event+0x10d/0x11f
[74981.402475]  [<ffffffff81003b0c>] call_softirq+0x1c/0x3e
[74981.402483]  [<ffffffff81005205>] do_softirq+0x3d/0x85
[74981.402491]  [<ffffffff8104609b>] irq_exit+0x4a/0x8c
[74981.402498]  [<ffffffff81004934>] do_IRQ+0xac/0xc3
[74981.402509]  [<ffffffff8142ea93>] ret_from_intr+0x0/0xf
[74981.402514]  <EOI>  [<ffffffff8125e92d>] ? acpi_idle_enter_bm+0x24b/0x276
[74981.402532]  [<ffffffff8125e923>] ? acpi_idle_enter_bm+0x241/0x276
[74981.402545]  [<ffffffff8135f104>] cpuidle_idle_call+0x98/0xf4
[74981.402554]  [<ffffffff81001b60>] cpu_idle+0xae/0xed
[74981.402564]  [<ffffffff8141a71a>] rest_init+0x7e/0x80
[74981.402574]  [<ffffffff8189eced>] start_kernel+0x401/0x40c
[74981.402584]  [<ffffffff8189e297>] x86_64_start_reservations+0xa7/0xab
[74981.402593]  [<ffffffff8189e37f>] x86_64_start_kernel+0xe4/0xeb
[74981.402599] ---[ end trace 651193ec08518a54 ]---
