Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout08.plus.net ([212.159.14.20]:56961 "EHLO
	avasout08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3DVMhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 08:37:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 22 Apr 2013 13:30:51 +0100
From: Gerry Gavigan <gerry@gavigan.f9.co.uk>
To: <linux-wireless@vger.kernel.org>
Subject: ath9k problems on openSUSE 12.3
Message-ID: <d5546f49ab812cc89887b18b41d44da0@imap.force9.net> (sfid-20130422_143707_263868_9C7BE9EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After some discussion :

https://forums.opensuse.org/english/get-technical-help-here/wireless/484686-advanced-atheros-issue-12-3-ath9k-64bit-frequent-random-de-auths-2.html

I have been advised to seek help here as the phase lock loop is not 
working.

In case it's relevant:

- the wifi was working if possibly slightly unstable until I upgraded 
to 3.8.7
   (to cure suspend and resume on a gma500 in an AAO)

- Downgrading didn't work

lspci -nn returns

02:00.0 Network controller [0280]: Atheros Communications Inc. AR9485 
Wireless Network Adapter [168c:0032] (rev 01)

dmesg reports

[ 24.800514] ------------[ cut here ]------------
[ 24.800563] WARNING: at 
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.10/linux-3.7/drivers/net/wireless/ath/ath9k/hw.c:794 
ar9003_get_pll_sqsum_dvc+0xa8/0xc0 [ath9k_hw]()
[ 24.800567] Hardware name: AOD270
[ 24.800571] Modules linked in: xt_tcpudp xt_pkttype xt_LOG xt_limit 
af_packet bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 
ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle 
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 
nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter 
ip6_tables x_tables cpufreq_conservative cpufreq_userspace 
cpufreq_powersave acpi_cpufreq mperf coretemp iTCO_wdt 
iTCO_vendor_support acer_wmi sparse_keymap snd_hda_codec_realtek 
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq 
microcode serio_raw pcspkr i2c_i801 snd_timer snd_seq_device uvcvideo 
videobuf2_core sg videodev videobuf2_vmalloc videobuf2_memops lpc_ich 
mfd_core arc4 joydev snd ath9k rts_pstor(C) mac80211 ath9k_common 
ath9k_hw ath cfg80211 rfkill r8169 soundcore snd_page_alloc wmi ac 
battery button autofs4 gma500_gfx drm_kms_helper drm i2c_algo_bit video 
thermal processor thermal_sys scsi_dh_rdac scsi_dh_emc scsi_dh_alua 
scsi_dh_hp_sw scsi_dh
[ 24.800687] Pid: 64, comm: kworker/u:3 Tainted: G C 3.7.10-1.1-desktop 
#1
[ 24.800690] Call Trace:
[ 24.800713] [<c0205779>] try_stack_unwind+0x199/0x1b0
[ 24.800729] [<c0204487>] dump_trace+0x47/0xf0
[ 24.800740] [<c02057db>] show_trace_log_lvl+0x4b/0x60
[ 24.800749] [<c0205808>] show_trace+0x18/0x20
[ 24.800760] [<c06fbeeb>] dump_stack+0x6d/0x72
[ 24.800812] [<c0238cb8>] warn_slowpath_common+0x78/0xb0
[ 24.800855] [<c0238d0b>] warn_slowpath_null+0x1b/0x20
[ 24.800897] [<f7c84448>] ar9003_get_pll_sqsum_dvc+0xa8/0xc0 [ath9k_hw]
[ 24.800941] [<f7b2d2b8>] ath_hw_pll_work+0x48/0xc0 [ath9k]
[ 24.801012] [<c02527dc>] process_one_work+0x10c/0x400
[ 24.801038] [<c0253e89>] worker_thread+0x119/0x3b0
[ 24.801055] [<c02584f2>] kthread+0x92/0xa0
[ 24.801076] [<c070dc67>] ret_from_kernel_thread+0x1b/0x28
[ 24.801093] [<c0258460>] kthread_create_on_node+0xd0/0xd0
[ 24.808339] DWARF2 unwinder stuck at kthread+0x0/0xa0
[ 24.808346]
[ 24.808350] Leftover inexact backtrace:
[ 24.808350]
[ 24.808361] ---[ end trace 33960a031f166c71 ]---


