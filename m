Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.versatel.nl ([62.58.50.90]:53669 "EHLO smtp3.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191AbYA1MoR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 07:44:17 -0500
Subject: Re: mac80211 crash in ieee80211_sta_scan_work
From: Bas Hulsken <bhulsken@hotmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <479D9B5F.5000304@lwfinger.net>
References: <479D9B5F.5000304@lwfinger.net>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 13:35:17 +0100
Message-Id: <1201523717.2829.16.camel@Bas> (sfid-20080128_124422_360840_54BEAC3F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

as I've previously mentioned in a private mail to you, I was getting a
similar oops (see info& trace below) for both rt2500pci and rtl8187,
also on the moment the interface went up. I can confirm that applying
Larry's patch prevents this oops from occurring.

Bas

uname -a:
steady.steadydecline.net 2.6.24-rc7_928_g40dfd0a_wireless #1 SMP Sat Jan
19 18:40:34 CET 2008 x86_64 x86_64 x86_64 GNU/Linux

trace:
general protection fault: 0000 [1] SMP 
CPU 1 
Modules linked in: nfsd lockd nfs_acl auth_rpcgss exportfs rfcomm l2cap
autofs4 
sunrpc ipt_REJECT xt_multiport iptable_filter ipt_MASQUERADE
ipt_REDIRECT iptabl
e_nat nf_nat nf_conntrack_ipv4 ipt_TOS iptable_mangle ip_tables
nf_conntrack_ipv
6 xt_state nf_conntrack xt_tcpudp ip6t_ipv6header ip6t_REJECT
ip6table_filter ip
6_tables x_tables ipv6 cpufreq_ondemand acpi_cpufreq ext2 dm_mirror
dm_multipath
 dm_mod wm8775 cx25840 msp3400 saa7115 tuner tea5767 tda8290
tuner_simple mt20xx
 tea5761 ivtv snd_hda_intel i2c_algo_bit cx2341x arc4 ecb snd_seq_dummy
tveeprom blkcipher videodev i2c_i801 rt2500pci rt2x00pci snd_seq_oss
snd_seq_midi_event i2c_core rt2x00lib v4l2_common rtc_cmos floppy
firewire_ohci v4l1_compat snd_seq rfkill firewire_core r8169 iTCO_wdt
pcspkr input_polldev iTCO_vendor_support crc_itu_t sky2 hci_usb
snd_seq_device bluetooth snd_pcm_oss ati_remote2 snd_mixer_oss snd_pcm
rtl8187 snd_timer mac80211 snd_page_alloc snd_hwdep eeprom_93cx6 snd
soundcore cfg80211 button sr_mod cdrom sg ahci pata_jmicron ata_generic
ata_piix pata_acpi libata sd_mod scsi_mod raid456 async_xor async_memcpy
async_tx xor ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 1420, comm: rt2500pci Not tainted 2.6.24-rc7_928_g40dfd0a_wireless
#1
RIP: 0010:[<ffffffff88157cfd>]
[<ffffffff88157cfd>] :mac80211:ieee80211_sta_scan_work+0x8d/0x19e
RSP: 0018:ffff81012dd4be70  EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff81012d8f51e8 RCX: ffff81012d865900
RDX: ffff81012d8f4140 RSI: 000000000015fac3 RDI: ffff81012d8f51e0
RBP: ffff81012d8f44c0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff810478d0 R11: ffffffff8101cbb8 R12: dead4ead00000001
R13: ffff81012d865000 R14: ffffffff814c1c40 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff81012fc01708(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002aaaab3859c0 CR3: 0000000122c35000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rt2500pci (pid: 1420, threadinfo ffff81012dd4a000, task
ffff81012dd3a000)
Stack:  0000000000000000 ffff81012d8f51e8 ffff81012c8eb668
ffff81012d8f51e0
 ffffffff88157c70 ffffffff8104791a ffffffff88170708 0000000000000000
 ffffffff88163473 0000000000000003 ffff81012cc55a88 ffff81012c8eb668
Call Trace:
 [<ffffffff88157c70>] :mac80211:ieee80211_sta_scan_work+0x0/0x19e
 [<ffffffff8104791a>] run_workqueue+0xdf/0x1df
 [<ffffffff810483e7>] worker_thread+0x0/0xe7
 [<ffffffff810484c4>] worker_thread+0xdd/0xe7
 [<ffffffff8104b95e>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8104b83e>] kthread+0x47/0x75
 [<ffffffff81270ef0>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8100ce28>] child_rip+0xa/0x12
 [<ffffffff8100c53f>] restore_args+0x0/0x30
 [<ffffffff8104b7f7>] kthread+0x0/0x75
 [<ffffffff8100ce1e>] child_rip+0x0/0x12


Code: 41 3b 44 24 14 7c 18 83 bd 10 0d 00 00 01 76 0f 48 89 ef 5d 
RIP  [<ffffffff88157cfd>] :mac80211:ieee80211_sta_scan_work+0x8d/0x19e
 RSP <ffff81012dd4be70>
---[ end trace 3f0208667981ef08 ]---




On Mon, 2008-01-28 at 02:07 -0700, Larry Finger wrote:
> Johannes,
> 
> With the latest wireless-2.6 git tree on my x86_64 system, I am getting a GPF in
> ieee80211_sta_scan_work. I tracked it down to the following astatement:
> 
>                 if (!sband ||
>                     (local->scan_channel_idx >= sband->n_channels &&
>                      local->scan_band >= IEEE80211_NUM_BANDS)) {
> 
> Specifically, it is the "local->scan_channel_idx >= sband->n_channels" part of the if test. When I
> added test prints of local->scan_channel_idx, local->scan_band, and sband, I got the following:
> 
> mac80211: scan_channel_idx = 0, scan_band = 0, sband = ffffffff882c2f10
> mac80211: scan_channel_idx = 1, scan_band = 0, sband = ffffffff882c2f10
> ...
> ...
> mac80211: scan_channel_idx = 13, scan_band = 0, sband = ffffffff882c2f10
> mac80211: scan_channel_idx = 0, scan_band = 2, sband = dead4ead00000001
> general protection fault: 0000 [1] SMP
> 
> As can be seen, "sband" is some kind of magic number and is an invalid pointer when scan_band is
> larger than IEEE80211_NUM_BANDS, which causes the GPF.
> 
> With the following patch, it works:
> 
> Index: wireless-2.6/net/mac80211/ieee80211_sta.c
> ===================================================================
> --- wireless-2.6.orig/net/mac80211/ieee80211_sta.c
> +++ wireless-2.6/net/mac80211/ieee80211_sta.c
> @@ -3237,8 +3237,7 @@ void ieee80211_sta_scan_work(struct work
>  		}
> 
>  		if (!sband ||
> -		    (local->scan_channel_idx >= sband->n_channels &&
> -		     local->scan_band >= IEEE80211_NUM_BANDS)) {
> +		     local->scan_band >= IEEE80211_NUM_BANDS) {
>  			ieee80211_scan_completed(local_to_hw(local));
>  			return;
>  		}
> 
> It seems to me that it should be OK to skip the scan_chan_idx >= sband->n_channels part of the test
> as scan_band won't get to be >= to IEEE80211_NUM_BANDS until all the channels have been tested in
> the legal bands.
> 
> Larry
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

