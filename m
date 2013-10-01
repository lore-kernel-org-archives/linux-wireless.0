Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35486 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3JASOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 14:14:30 -0400
Message-ID: <524B10F8.9080301@candelatech.com> (sfid-20131001_201448_039470_51BA034A)
Date: Tue, 01 Oct 2013 11:14:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Softlockup warnings on 3.9.11+, software crypt, wpa2, UDP.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm doing some performance tests with UDP download, using WPA2 encryption.
I'm using software crypt since I'm using multiple VIFs.

The receiving side sees lots of these warnings.  Do we need
some bail-out logic somewhere so that it doesn't get stuck
receiving packets for so long?

BUG: soft lockup - CPU#0 stuck for 22s! [btserver:32646]
Modules linked in: nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat 8021q garp stp mrp llc macvlan wanlink(O) pktgen lockd sunrpc f71882fg snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep cdc_acm joydev snd_seq snd_seq_device snd_pcm coretemp ath9k hwmon ath9k_common mperf ath9k_hw 
intel_powerclamp ath kvm_intel mac80211 kvm cfg80211 iTCO_wdt microcode iTCO_vendor_support snd_page_alloc e1000e i2c_i801 snd_timer mos7840 pcspkr serio_raw 
snd soundcore ptp pps_core lpc_ich uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_nat]
CPU 0
Pid: 32646, comm: btserver Tainted: G         C O 3.9.11+ #126 To be filled by O.E.M. To be filled by O.E.M./HURONRIVER
RIP: 0010:[<ffffffff81017e1d>]  [<ffffffff81017e1d>] __kernel_fpu_begin+0x48/0x8b
RSP: 0000:ffff88021fa03918  EFLAGS: 00000286
RAX: 00000000ffffffff RBX: ffffffff81549567 RCX: ffff88020bc48000
RDX: 00000000ffffffff RSI: ffff88021fa03a28 RDI: ffff88020f8d5a00
RBP: ffff88021fa03918 R08: ffff8801b54a1978 R09: 0000000000000010
R10: ffff88020c5cb490 R11: 0000000000000200 R12: ffff88021fa03888
R13: ffffffff815d235d R14: ffff88021fa03918 R15: ffff88020c5cb400
FS:  00007f02f9605740(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000023b4c60 CR3: 000000020b754000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btserver (pid: 32646, threadinfo ffff880210666000, task ffff88020bc48000)
Stack:
  ffff88021fa03928 ffffffff8108b1f2 ffff88021fa03958 ffffffff8108c05d
  ffff88021fa03a28 ffff88021fa03a28 ffff88020c5c9c00 ffff88021fa03a08
  ffff88021fa039d8 ffffffffa05be460 ffff880200000010 ffff8801b54a1978
Call Trace:
  <IRQ>
  [<ffffffff8108b1f2>] kernel_fpu_begin+0x42/0x44
  [<ffffffff8108c05d>] aes_encrypt+0x46/0x62
  [<ffffffffa05be460>] ieee80211_aes_ccm_decrypt+0xcf/0x108 [mac80211]
  [<ffffffffa05b1e0f>] ieee80211_crypto_ccmp_decrypt+0x1c7/0x247 [mac80211]
  [<ffffffffa05c530d>] ieee80211_rx_handlers+0x305/0x18c9 [mac80211]
  [<ffffffff815d235d>] ? apic_timer_interrupt+0x6d/0x80
  [<ffffffffa05c71cf>] ieee80211_prepare_and_rx_handle+0x8fe/0x96a [mac80211]
  [<ffffffffa05c79c4>] ieee80211_rx+0x6e9/0x759 [mac80211]
  [<ffffffffa08f5f99>] ath_rx_tasklet+0xff8/0x10d1 [ath9k]
  [<ffffffffa08f43a1>] ath9k_tasklet+0xf9/0x150 [ath9k]
  [<ffffffff8109d5af>] tasklet_action+0x7d/0xcc
  [<ffffffff8109da08>] __do_softirq+0x114/0x254
  [<ffffffff815caf51>] ? _raw_spin_unlock_irqrestore+0x31/0x3c
  [<ffffffff815caf15>] ? _raw_spin_unlock+0x24/0x2f
  [<ffffffff8109dbda>] irq_exit+0x4b/0xa8
  [<ffffffff815d33dd>] do_IRQ+0x9d/0xb4
  [<ffffffff815cb4ad>] common_interrupt+0x6d/0x6d
  <EOI>
Code: 4c 05 00 00 00 00 00 00 65 48 c7 04 25 b0 c6 00 00 00 00 00 00 b0 01 84 c0 48 8b b9 50 05 00 00 74 1b 83 c8 ff 89 c2 48 0f ae 37 <48> 8b 81 50 05 00 00 f6 
80 00 02 00 00 01 75 06 eb 2f 48 0f ae

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

