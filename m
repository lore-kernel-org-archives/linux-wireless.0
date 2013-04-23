Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout07.plus.net ([84.93.230.235]:38708 "EHLO
	avasout07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab3DWJeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 05:34:36 -0400
From: Gerry Gavigan <gerry@gavigan.f9.co.uk>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k problems on openSUSE 12.3
Date: Tue, 23 Apr 2013 10:28:26 +0100
Message-ID: <2687000.szPz826eEU@linux-zd5t.site> (sfid-20130423_113441_605456_E294EDD5)
In-Reply-To: <20854.18866.135251.330099@gargle.gargle.HOWL>
References: <d5546f49ab812cc89887b18b41d44da0@imap.force9.net> <20854.18866.135251.330099@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 Apr 2013 14:13:30 Sujith Manoharan wrote:
> Gerry Gavigan wrote:
> > 02:00.0 Network controller [0280]: Atheros Communications Inc. AR9485
> > Wireless Network Adapter [168c:0032] (rev 01)
> 
> As a first step, can you disable Power Save and see if the issue persists ?
> ("iw dev wlan# set power_save off" and verify that "iw wlan0 get power_save"
> shows "off").

Thank you 

- turned power save off
- confirmed
- shut down
- restarted
- power save is on

problem persists 

dmesg trace

[   15.610198] wlan0: direct probe to 00:1f:33:7a:cf:b4 (try 3/3)
[   15.811020] wlan0: authentication with 00:1f:33:7a:cf:b4 timed out
[   15.931895] ------------[ cut here ]------------
[   15.931944] WARNING: at 
/home/abuild/rpmbuild/BUILD/kernel-
desktop-3.7.10/linux-3.7/drivers/net/wireless/ath/ath9k/hw.c:794 
ar9003_get_pll_sqsum_dvc+0xa8/0xc0 [ath9k_hw]()
[   15.931948] Hardware name: AOD270
[   15.931952] Modules linked in: xt_tcpudp xt_pkttype xt_LOG xt_limit 
af_packet bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 
ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle 
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 
nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter 
ip6_tables x_tables cpufreq_conservative cpufreq_userspace 
cpufreq_powersave acpi_cpufreq mperf coretemp iTCO_wdt 
iTCO_vendor_support acer_wmi sparse_keymap snd_hda_codec_realtek 
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_pcm 
microcode snd_seq pcspkr uvcvideo serio_raw videobuf2_core videodev 
videobuf2_vmalloc videobuf2_memops joydev i2c_i801 snd_timer sg 
snd_seq_device lpc_ich mfd_core arc4 snd ath9k mac80211 ath9k_common 
ath9k_hw rts_pstor(C) ath cfg80211 rfkill r8169 soundcore snd_page_alloc 
ac wmi battery button autofs4 gma500_gfx drm_kms_helper drm i2c_algo_bit 
thermal video processor thermal_sys scsi_dh_rdac scsi_dh_emc 
scsi_dh_alua scsi_dh_hp_sw scsi_dh
[   15.932067] Pid: 63, comm: kworker/u:2 Tainted: G         C   
3.7.10-1.1-desktop #1
[   15.932071] Call Trace:
[   15.932093]  [<c0205779>] try_stack_unwind+0x199/0x1b0
[   15.932110]  [<c0204487>] dump_trace+0x47/0xf0
[   15.932121]  [<c02057db>] show_trace_log_lvl+0x4b/0x60
[   15.932130]  [<c0205808>] show_trace+0x18/0x20
[   15.932141]  [<c06fbeeb>] dump_stack+0x6d/0x72
[   15.932151]  [<c0238cb8>] warn_slowpath_common+0x78/0xb0
[   15.932162]  [<c0238d0b>] warn_slowpath_null+0x1b/0x20
[   15.932185]  [<f7c78448>] ar9003_get_pll_sqsum_dvc+0xa8/0xc0 
[ath9k_hw]
[   15.932215]  [<f7b712b8>] ath_hw_pll_work+0x48/0xc0 [ath9k]
[   15.932261]  [<c02527dc>] process_one_work+0x10c/0x400
[   15.932272]  [<c0253e89>] worker_thread+0x119/0x3b0
[   15.932282]  [<c02584f2>] kthread+0x92/0xa0
[   15.932294]  [<c070dc67>] ret_from_kernel_thread+0x1b/0x28
[   15.932304]  [<c0258460>] kthread_create_on_node+0xd0/0xd0
[   15.939555] DWARF2 unwinder stuck at kthread+0x0/0xa0
[   15.939561]
[   15.939565] Leftover inexact backtrace:
[   15.939565]
[   15.939577] ---[ end trace bf86f678b93882b1 ]---

should I

- turn power save off
- reinstall 3.7.10 (start again with openSUSE 12.3)?

Grateful people are helping, sorry if I'm being stupid

Gerry
