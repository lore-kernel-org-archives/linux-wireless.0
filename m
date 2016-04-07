Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42514 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbcDGX34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 19:29:56 -0400
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Kernel crash when ath10k 10.4.3 firmware crashes in TCP download
 test.
Message-ID: <5706ED73.1040003@candelatech.com> (sfid-20160408_013001_062181_7D79816B)
Date: Thu, 7 Apr 2016 16:29:55 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We see this kernel splat when using 'flent' TCP download test on
a QCA99XX wave-2 NIC.  Seems easy to reproduce at least on our test rig.

Significantly patched ath10k, should be near linux.ath plus a bit.  4.4.6+ kernel.

Probably I can make this go away by fixing the firmware crash (which I have not
looked at yet), but a firmware crash is still not a good reason to crash the kernel...

I'll poke at this some more when I get a chance, but if someone has ideas,
please let me know.


(gdb) l *(ieee80211_tx_dequeue+0x41)
0x223aa is in ieee80211_tx_dequeue (/home/greearb/git/linux-4.4.dev.y/net/mac80211/tx.c:1321).
1316	
1317		if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
1318			goto out;
1319	
1320		skb = __skb_dequeue(&txqi->queue);
1321		if (!skb)
1322			goto out;
1323	
1324		txqi->byte_cnt -= skb->len;
1325	
(gdb)


[root@ct523-3ac-f19 ~]# ath10k_pci 0000:07:00.0: firmware crashed! (uuid ae9f983c-2e65-4eb3-a35e-f80536c8a6c9)
ath10k_pci 0000:07:00.0: firmware register dump:
ath10k_pci 0000:07:00.0: [00]: 0x00000009 0x000015B3 0x009A2A26 0x00955B31
ath10k_pci 0000:07:00.0: [04]: 0x009A2A26 0x00060130 0x00000005 0x00000013
ath10k_pci 0000:07:00.0: [08]: 0x000000FC 0x0000009B 0x000000BA 0x0000009C
ath10k_pci 0000:07:00.0: [12]: 0x00000009 0x00000000 0x00953444 0x0095345A
ath10k_pci 0000:07:00.0: [16]: 0x00953438 0x00953469 0x009406B6 0x00000000
ath10k_pci 0000:07:00.0: [20]: 0x409A2A26 0x0040642C 0x000000FF 0x00000001
ath10k_pci 0000:07:00.0: [24]: 0x809A2BC7 0x0040648C 0x00000000 0xC09A2A26
ath10k_pci 0000:07:00.0: [28]: 0x809A4090 0x0040651C 0x0044F194 0x0044F624
ath10k_pci 0000:07:00.0: [32]: 0x809A4E0B 0x004065AC 0x00000002 0x0044F194
ath10k_pci 0000:07:00.0: [36]: 0x80986935 0x0040666C 0x0044E64C 0x00442F64
ath10k_pci 0000:07:00.0: [40]: 0x80992B9D 0x004066AC 0x00423A04 0x0044A904
ath10k_pci 0000:07:00.0: [44]: 0x8098EE1C 0x004066CC 0x00423A04 0x004066CC
ath10k_pci 0000:07:00.0: [48]: 0x80943885 0x0040685C 0x00423A04 0x0098EE14
ath10k_pci 0000:07:00.0: [52]: 0x80940E40 0x0040687C 0x0000001F 0x00000000
ath10k_pci 0000:07:00.0: [56]: 0x80940E13 0x004068AC 0x00400000 0x00000000
ath10k_pci 0000:07:00.0: ath10k_pci ATH10K_DBG_BUFFER:
ath10k: [0000]: 0001AD5A 17FC4C07 91107000 000000FC 000000C4 9CC30005 00000004 0001AD5A
ath10k: [0008]: 17FC0001 009A2A26 000015B3 000015B3 0040631C 00000009
ath10k_pci 0000:07:00.0: ATH10K_END
DMAR: DRHD: handling fault status reg 2
DMAR: DMAR:[DMA Read] Request device [07:00.0] fault addr 0
DMAR:[fault reason 06] PTE Read access is not set
wlan2: Failed to send nullfunc to AP dc:ef:09:e3:30:99 after 1000ms, disconnecting
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffffa0e4b338>] __skb_dequeue+0x2a/0x37 [mac80211]
PGD 0
Oops: 0002 [#1] PREEMPT SMP
Modules linked in: nf_conntrack_netlink nfnetlink nf_conntrack_ipv4 iptable_raw xt_CT nf_conntrack nf_defrag_ipv4 8021q garp mrp stp llc bnep bluetooth fuse 
macvlan wanlink(O) pktgen ip6table_filter ip6_tables ebtable_nat ebtables ath10k_pci ath10k_core ath mac80211 coretemp hwmon snd_hda_codec_hdmi intel_rapl 
iosf_mbi x86_pkg_temp_thermal intel_powerclamp kvm_intel iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek snd_hda_codec_generic cfg80211 kvm snd_hda_intel 
snd_hda_codec snd_hda_core snd_hwdep cdc_acm snd_seq snd_seq_device snd_pcm e1000e irqbypass serio_raw pcspkr i2c_i801 ptp snd_timer pps_core snd fjes soundcore 
8250_fintek shpchp lpc_ich tpm_tis tpm uinput ipv6 i915 i2c_algo_bit drm_kms_helper drm i2c_core video [last unloaded: nf_conntrack]
CPU: 0 PID: 280 Comm: kworker/u16:5 Tainted: G           O    4.4.6+ #28
Hardware name: To be filled by O.E.M. To be filled by O.E.M./ChiefRiver, BIOS 4.6.5 06/07/2013
Workqueue: phy2 ieee80211_iface_work [mac80211]
task: ffff880214439cc0 ti: ffff8800d4b00000 task.ti: ffff8800d4b00000
RIP: 0010:[<ffffffffa0e4b338>]  [<ffffffffa0e4b338>] __skb_dequeue+0x2a/0x37 [mac80211]
RSP: 0018:ffff88021e203d20  EFLAGS: 00010296
RAX: ffff8800cbb80000 RBX: ffff8800cbb83828 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff8800cbb83828 RDI: ffff8800cbb83800
RBP: ffff88021e203d20 R08: 0000000000000010 R09: ffff8800cbb83828
R10: 0000000000001671 R11: ffff8800c7d1bbfc R12: ffff8800cbb83828
R13: ffff8800d7ad2a02 R14: ffff8800cbb83814 R15: ffff8800d93c7b28
FS:  0000000000000000(0000) GS:ffff88021e200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 0000000001c0b000 CR4: 00000000001406f0
Stack:
  ffff88021e203d60 ffffffffa0e4b386 ffff8800d7ad06e0 ffff8800d7ad34ec
  ffff8800cbb83828 ffff8800d7ad2ac0 ffff8800d7ad33a0 ffff8800d93c7b28
  ffff88021e203db0 ffffffffa1106bfb ffff8800d7ad06e0 ffffffff00000000
Call Trace:
  <IRQ>
  [<ffffffffa0e4b386>] ieee80211_tx_dequeue+0x41/0xfe [mac80211]
  [<ffffffffa1106bfb>] ath10k_mac_tx_push_txq+0x6a/0x148 [ath10k_core]
  [<ffffffffa1106e2d>] ath10k_mac_tx_push_pending+0x154/0x169 [ath10k_core]
  [<ffffffffa11143e7>] ath10k_htt_txrx_compl_task+0x75d/0xa62 [ath10k_core]
  [<ffffffff81114e90>] ? enqueue_task_fair+0xa4/0xab
  [<ffffffff81109809>] ? check_preempt_curr+0x45/0x68
  [<ffffffff81109840>] ? ttwu_do_wakeup+0x14/0xe1
  [<ffffffff810ed376>] ? __local_bh_enable+0xc/0x3e
  [<ffffffff810edf42>] tasklet_action+0xae/0xbf
  [<ffffffff810ed833>] __do_softirq+0x109/0x26d
  [<ffffffff811370c5>] ? rcu_irq_exit+0x3d/0x40
  [<ffffffff816a726c>] do_softirq_own_stack+0x1c/0x30
  <EOI>
  [<ffffffff810ed9fc>] do_softirq+0x30/0x3b
  [<ffffffff810eda70>] __local_bh_enable_ip+0x69/0x83
  [<ffffffff816a51bc>] _raw_spin_unlock_bh+0x15/0x17
  [<ffffffffa06e4a9f>] cfg80211_bss_update+0x393/0x542 [cfg80211]
  [<ffffffff811e01ec>] ? __kmalloc+0xf1/0xfd
  [<ffffffffa06e5086>] cfg80211_inform_bss_frame_data+0x20c/0x26e [cfg80211]
  [<ffffffff811110d8>] ? update_cfs_rq_load_avg+0x221/0x307
  [<ffffffffa0e333f6>] ieee80211_bss_info_update+0xaa/0x305 [mac80211]
  [<ffffffffa0e333f6>] ? ieee80211_bss_info_update+0xaa/0x305 [mac80211]
  [<ffffffffa0e64743>] ieee80211_rx_bss_info+0x50/0x78 [mac80211]
  [<ffffffffa0e668df>] ieee80211_rx_mgmt_probe_resp+0x80/0xc9 [mac80211]
  [<ffffffffa0e68f91>] ieee80211_sta_rx_queued_mgmt+0xc8/0x656 [mac80211]
  [<ffffffff8110feae>] ? __enqueue_entity+0x67/0x69
  [<ffffffff81114d11>] ? enqueue_entity+0x5b0/0x68b
  [<ffffffff811106de>] ? hrtick_update+0x16/0x48
  [<ffffffff81109160>] ? resched_curr+0x56/0x59
  [<ffffffff81111de5>] ? update_load_avg+0x22b/0x25e
  [<ffffffff81111de5>] ? update_load_avg+0x22b/0x25e
  [<ffffffff8111f88f>] ? cpuacct_charge+0x48/0x4f
  [<ffffffff811112f3>] ? account_entity_dequeue+0x73/0xad
  [<ffffffff81110bb5>] ? get_sd_balance_interval.isra.40+0x17/0x33
  [<ffffffff81110beb>] ? update_next_balance.constprop.64+0x1a/0x2d
  [<ffffffff81120083>] ? arch_local_irq_save+0x15/0x1b
  [<ffffffffa0e3b799>] ieee80211_iface_work+0x2be/0x343 [mac80211]
  [<ffffffff810fdddf>] process_one_work+0x186/0x2be
  [<ffffffff810fe39a>] worker_thread+0x1e4/0x28f
  [<ffffffff810fe1b6>] ? rescuer_thread+0x275/0x275
  [<ffffffff81102416>] kthread+0xa0/0xa8
  [<ffffffff81102376>] ? kthread_parkme+0x1f/0x1f
  [<ffffffff816a58cf>] ret_from_fork+0x3f/0x70
  [<ffffffff81102376>] ? kthread_parkme+0x1f/0x1f
Code: c3 48 8b 07 55 48 89 e5 48 39 f8 74 27 48 85 c0 74 24 ff 4f 10 48 8b 08 48 8b 50 08 48 c7 00 00 00 00 00 48 c7 40 08 00 00 00 00 <48> 89 51 08 48 89 0a eb 
02 31 c0 5d c3 55 48 89 e5 41 57 41 56
RIP  [<ffffffffa0e4b338>] __skb_dequeue+0x2a/0x37 [mac80211]
  RSP <ffff88021e203d20>
CR2: 0000000000000008
---[ end trace 2d1d7d27b6eb6b94 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Kernel Offset: disabled
Rebooting in 10 seconds..
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

