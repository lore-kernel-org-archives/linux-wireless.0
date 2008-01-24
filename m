Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:46255 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbYAXHQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 02:16:16 -0500
Message-ID: <47983B31.4020304@lwfinger.net> (sfid-20080124_071621_438768_C8566B05)
Date: Thu, 24 Jan 2008 00:16:01 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Kernel Panic in mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been having "random" kernel panics where the "Caps Lock" LED is flashing at ~1 Hz. These 
crashes only occur for the wireless-2.6 tree and have been happening for roughly 3 weeks. After 
running a memory test to ensure that these panics were not caused by a hardware problem, I enabled 
netconsole logging and caught the following crash report for my x86_64 system:

Unable to handle kernel paging request at ffffffff88246288 RIP:
  [<ffffffff88202940>] :mac80211:rate_control_pid_tx_status+0x426/0x45a
PGD 203067 PUD 207063 PMD 580d3067 PTE 0
Oops: 0000 [1] SMP
CPU 1
Modules linked in: netconsole af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device sunrpc 
rfkill_input cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 
freq_table usbserial ipt_MASQUERADE xt_state nf_nat_ftp iptable_nat nf_nat nf_conntrack_ftp 
nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables x_tables fuse loop dm_mod snd_hda_intel 
snd_pcm b43 rfkill mac80211 led_class snd_timer snd soundcore rtc_cmos rtc_core k8temp 
snd_page_alloc rtc_lib forcedeth hwmon ohci1394 sdhci mmc_core sr_mod ieee1394 cdrom ssb serio_raw 
i2c_nforce2 output button sg ehci_hcd ohci_hcd sd_mod usbcore edd ext3 mbcache jbd fan sata_nv 
pata_amd libata scsi_mod thermal processor
Pid: 0, comm: swapper Not tainted 2.6.24-rc7-L2.6-gbc77eb36-dirty #11
RIP: 0010:[<ffffffff88202940>]  [<ffffffff88202940>] :mac80211:rate_control_pid_tx_status+0x426/0x45a
RSP: 0018:ffff810059b77dd0  EFLAGS: 00010202
RAX: 0000000000003600 RBX: ffff8100581e6000 RCX: 0000000000000240
RDX: ffffffff88242c80 RSI: 0000000000000001 RDI: ffff810056066800
RBP: ffff810059b77e00 R08: 0000000000000007 R09: 000000000000000b
R10: 000000000000000c R11: ffff8100581e6010 R12: 0000000000000001
R13: 00000000ffffffff R14: 0000000000000000 R15: ffff810037a75028
FS:  00002b0125b744f0(0000) GS:ffff810059801780(0000) knlGS:00000000f70de6c0
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffffff88246288 CR3: 0000000056044000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff810059b72000, task ffff810059b70000)
Stack:  ffff810058b2e5c8 ffff810058071400 ffff810058b2e460 ffff810058b2e460
  ffff810058165ba0 ffff810053e9d823 ffff810059b77e50 ffffffff881ee684
  ffff810058b2e5b0 ffff810058071400 ffff810059b77e50 ffff810058071400
Call Trace:
  <IRQ>  [<ffffffff881ee684>] :mac80211:ieee80211_tx_status+0x19d/0x424
  [<ffffffff881eee0a>] :mac80211:ieee80211_tasklet_handler+0x7e/0xe2
  [<ffffffff8023ef23>] tasklet_action+0x6e/0xc8
  [<ffffffff8023edf6>] __do_softirq+0x70/0xf1
  [<ffffffff8020b03c>] default_idle+0x0/0x51
  [<ffffffff8020d38c>] call_softirq+0x1c/0x28
  [<ffffffff8020f2fb>] do_softirq+0x39/0x9f
  [<ffffffff8023ed44>] irq_exit+0x4e/0x90
  [<ffffffff8020f41b>] do_IRQ+0xba/0xdb
  [<ffffffff8020b03c>] default_idle+0x0/0x51
  [<ffffffff8020c686>] ret_from_intr+0x0/0xf
  <EOI>  [<ffffffff8020b073>] default_idle+0x37/0x51
  [<ffffffff8020b071>] default_idle+0x35/0x51
  [<ffffffff8020b133>] cpu_idle+0xa6/0xce
  [<ffffffff8021df9f>] start_secondary+0x3de/0x3ef


Code: f6 44 02 08 10 74 12 45 85 ed 78 05 44 39 e9 7f 08 89 8f 24
RIP  [<ffffffff88202940>] :mac80211:rate_control_pid_tx_status+0x426/0x45a
  RSP <ffff810059b77dd0>
CR2: ffffffff88246288
---[ end trace 638a30c2fdaf8180 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!

I have not yet figured out which instruction is found at mac80211:rate_control_pid_tx_status+0x426, 
but I will continue to work on it. I wanted to get this report filed so that the problem can be 
found before 2.6.25-rcX comes out.

Larry
