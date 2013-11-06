Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33024 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3KFS5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 13:57:41 -0500
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id rA6Ive1t024967
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 6 Nov 2013 10:57:40 -0800
Message-ID: <527A9124.5000306@candelatech.com> (sfid-20131106_195744_890692_15B02E5D)
Date: Wed, 06 Nov 2013 10:57:40 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Crash related to scanning in 'ath' tree (3.12.0-rc5 + minor patches)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is from the 'ath' tree, which is 3.12.0-rc5.  There are just a few printk patches
to mac80211, and some moderate amount of patches to ath10k.  I left the ath10k logs in
this crash in case it provides some clue, but I think it may not be an ath10k problem
as I have seen what I think is the same crash a few times before in 3.11+ with ath9k.

I have memory poisoning and pretty much every other debugging option enabled in this
kernel.

(gdb) l *(ieee80211_prep_hw_scan+0x44)
0x5f58 is in ieee80211_prep_hw_scan (/mnt/sda/home/greearb/git/linux.ath/net/mac80211/scan.c:251).
246				return false;
247	
248			band = local->hw_scan_band;
249			n_chans = 0;
250			for (i = 0; i < req->n_channels; i++) {
251				if (req->channels[i]->band == band) {
252					local->hw_scan_req->channels[n_chans] =
253								req->channels[i];
254					n_chans++;
255				}
(gdb)



sta301: send auth to 00:03:83:3d:30:aa (try 1/3)
IPv6: ADDRCONF(NETDEV_UP): sta310: link is not ready
general protection fault: 0000 [#1] PREEMPT SMP
Modules linked in: ath10k_pci ath10k_core ath5k ath9k ath9k_common ath9k_hw nf_nat_ipv4 nf_nat veth 8021q g0
ath10k: msdu 0xd9107800
ath10k: htt data tx using tid 16
ath10k: pci send data vaddr ffff8800cbc009c0 paddr 0xcbc009c0 len 76 as 76 bytes
ath10k: ath10k_pci_ce_recv_data netbuf=ffff88020d7ee640  nbytes=16
ath10k: htc rx completion ep 1 skb ffff88020d7ee640
ath10k: HTT RX, msg_type: 0x7
ath10k: htt tx completion num_msdus 1
ath10k: htt tx completion msdu_id 0 discard 0 no_ack 0
ath10k: htt tx free msdu_id 0
ath10k: ath10k_htc_notify_tx_completion: ep 1 skb ffff88020fa35680
ath10k: ath10k_pci_ce_recv_data netbuf=ffff8800cd340240  nbytes=64
ath10k: htc rx completion ep 1 skb ffff8800cd340240
ath10k: HTT RX, msg_type: 0x1
ath10k: rx skb ffff8800caf64b40 len 360 legacy rate_idx 0 vht_nss 0 freq 5180 band 1
ath10k: ath10k_pci_ce_recv_data netbuf=ffff8800cd343a80  nbytes=64
ath10k: htc rx completion ep 1 skb ffff8800cd343a80
ath10k: HTT RX, msg_type: 0x1
ath10k: rx skb ffff8800caf658c0 len 60 legacy rate_idx 0 vht_nss 0 freq 5180 band 1
ath10k: ath10k_pci_ce_recv_data netbuf=ffff8800cd342880  nbytes=64
ath10k: htc rx completion ep 1 skb ffff8800cd342880
ath10k: HTT RX, msg_type: 0x1
ath10k: ath10k_pci_ce_recv_data netbuf=ffff8800d0bca880  nbytes=184
ath10k: htc rx completion ep 2 skb ffff8800d0bca880
ath10k: event mgmt rx status 00000000
ath10k: event mgmt rx skb ffff8800d0bca880 len 148 ftype 00 stype 80
ath10k: event mgmt rx freq 5180 band 1 snr -25, rate_idx 0
 pcspkr mac80211 e1000e snd_page_alloc ptp cfg80211 lpc_ich i2c_i801 snd_timer pps_core snd soundcore acpi_]
CPU: 2 PID: 6 Comm: kworker/u8:0 Tainted: G        WC   3.12.0-rc5-wl+ #2
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
Workqueue: phy11 ieee80211_scan_work [mac80211]
task: ffff880216252140 ti: ffff88021625a000 task.ti: ffff88021625a000
RIP: 0010:[<ffffffffa035cf58>]  [<ffffffffa035cf58>] ieee80211_prep_hw_scan+0x44/0xed [mac80211]
RSP: 0018:ffff88021625bca8  EFLAGS: 00010297
RAX: 0000000000000000 RBX: ffff8800caea88a0 RCX: 6b6b6b6b6b6b6b6b
ath10k: ath10k_pci_ce_recv_data netbuf=ffff8800cac7a400  nbytes=64
ath10k: htc rx completion ep 1 skb ffff8800cac7a400
ath10k: HTT RX, msg_type: 0x1
ath10k: ath10k_pci_ce_recv_data netbuf=ffff8800d0bc9d40  nbytes=184
ath10k: htc rx completion ep 2 skb ffff8800d0bc9d40
ath10k: event mgmt rx status 00000000
ath10k: event mgmt rx skb ffff8800d0bc9d40 len 148 ftype 00 stype 80
ath10k: event mgmt rx freq 5180 band 1 snr -25, rate_idx 0
RDX: 0000000000000000 RSI: ffff8800caea9c58 RDI: ffff8800caea88a0
RBP: ffff88021625bd08 R08: 0000000000000002 R09: 0000000000000002
R10: ffffffffa035da61 R11: 0000000000000092 R12: ffff880034a33b50
R13: ffff88020da6ab01 R14: ffff8800caea9bf0 R15: ffff8800caea9c78
FS:  0000000000000000(0000) GS:ffff88021fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003a56cba9f0 CR3: 0000000001a0d000 CR4: 00000000000407e0
Stack:
 ffff88021625bcd8 ffffffff810ecd39 ffffffffa035da61 ffff880216252140
 ffff8800caea9d00 0000000000000246 ffff88021625bd08 ffffffff810ecdac
 0000000000000092 ffff8800caea88a0 ffff8800caea9d00 ffff88020da6ab01
Call Trace:
 [<ffffffff810ecd39>] ? __lock_is_held+0x32/0x54
 [<ffffffffa035da61>] ? ieee80211_scan_work+0x3b/0x42e [mac80211]
 [<ffffffff810ecdac>] ? lock_is_held+0x51/0x63
 [<ffffffffa035d081>] __ieee80211_scan_completed+0x80/0x1ab [mac80211]
 [<ffffffffa035de3d>] ieee80211_scan_work+0x417/0x42e [mac80211]
 [<ffffffff810b42d3>] process_one_work+0x1d7/0x303
 [<ffffffff810b4269>] ? process_one_work+0x16d/0x303
 [<ffffffff810b161b>] ? spin_lock_irq+0x9/0xb
ath10k: ath10k_pci_ce_recv_data netbuf=ffff8800cac79440  nbytes=64
ath10k: htc rx completion ep 1 skb ffff8800cac79440
ath10k: HTT RX, msg_type: 0x1
ath10k: ath10k_pci_ce_recv_data netbuf=ffff8800d0bc8480  nbytes=184
ath10k: htc rx completion ep 2 skb ffff8800d0bc8480
ath10k: event mgmt rx status 00000000
ath10k: event mgmt rx skb ffff8800d0bc8480 len 148 ftype 00 stype 80
ath10k: event mgmt rx freq 5180 band 1 snr -25, rate_idx 0
 [<ffffffff810b47d2>] worker_thread+0x12e/0x1fb
 [<ffffffff810b46a4>] ? rescuer_thread+0x27b/0x27b
 [<ffffffff810b9d61>] kthread+0x9d/0xa5
 [<ffffffff815916e3>] ? _raw_spin_unlock_irq+0x29/0x54
 [<ffffffff810b9cc4>] ? __kthread_parkme+0x60/0x60
 [<ffffffff8159674c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810b9cc4>] ? __kthread_parkme+0x60/0x60
Code: a7 10 14 00 00 a8 20 74 07 31 c0 e9 b9 00 00 00 44 8b 8b 38 14 00 00 41 83 f9 03 74 ec 31 c0 31 d2 eb
RIP  [<ffffffffa035cf58>] ieee80211_prep_hw_scan+0x44/0xed [mac80211]
 RSP <ffff88021625bca8>
---[ end trace ba755a478f678e6a ]---
BUG: unable to handle kernel paging request at ffffffffffffffa8
IP: [<ffffffff810ba165>] kthread_data+0xb/0x11
PGD 1a10067 PUD 1a12067 PMD 0
Oops: 0000 [#2] PREEMPT SMP
Modules linked in: ath10k_pci ath10k_core ath5k ath9k ath9k_common ath9k_hw nf_nat_ipv4 nf_nat veth 8021q g]
CPU: 0 PID: 6 Comm: kworker/u8:0 Tainted: G      D WC   3.12.0-rc5-wl+ #2
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
task: ffff880216252140 ti: ffff88021625a000 task.ti: ffff88021625a000
RIP: 0010:[<ffffffff810ba165>]  [<ffffffff810ba165>] kthread_data+0xb/0x11
RSP: 0018:ffff88021625ba28  EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffff88021fa13b80 RCX: ffff88021fa13c28
RDX: 0000000000021d4b RSI: 0000000000000000 RDI: ffff880216252140
RBP: ffff88021625ba28 R08: ffffffff81c57340 R09: 000000000000b570
R10: ffffffff810d3316 R11: 000000000000bd1c R12: 0000000000000000
R13: ffff88021625bb18 R14: 0000000000000000 R15: ffff880216252130
FS:  0000000000000000(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000028 CR3: 0000000214dc0000 CR4: 00000000000407f0
Stack:
 ffff88021625ba48 ffffffff810b4c99 ffff88021fa13b80 ffff880216252550
 ffff88021625bab8 ffffffff8158ff83 ffff880216252140 ffff88021625bfd8
 0000000000013b80 ffff88021625bfd8 ffff88020b875e00 ffff880216252140
Call Trace:
 [<ffffffff810b4c99>] wq_worker_sleeping+0xf/0x87
 [<ffffffff8158ff83>] __schedule+0x159/0x5fa
 [<ffffffff8159052e>] schedule+0x60/0x62
 [<ffffffff810a175f>] do_exit+0x8e9/0x8eb
 [<ffffffff81592d36>] oops_end+0xaf/0xb7
 [<ffffffff8100d2ac>] die+0x55/0x61
 [<ffffffff815928bf>] do_general_protection+0x93/0x13c
 [<ffffffffa035da61>] ? ieee80211_scan_work+0x3b/0x42e [mac80211]
 [<ffffffff81592248>] general_protection+0x28/0x30
 [<ffffffffa035da61>] ? ieee80211_scan_work+0x3b/0x42e [mac80211]
 [<ffffffffa035cf58>] ? ieee80211_prep_hw_scan+0x44/0xed [mac80211]
 [<ffffffff810ecd39>] ? __lock_is_held+0x32/0x54
 [<ffffffffa035da61>] ? ieee80211_scan_work+0x3b/0x42e [mac80211]
 [<ffffffff810ecdac>] ? lock_is_held+0x51/0x63
 [<ffffffffa035d081>] __ieee80211_scan_completed+0x80/0x1ab [mac80211]
 [<ffffffffa035de3d>] ieee80211_scan_work+0x417/0x42e [mac80211]
 [<ffffffff810b42d3>] process_one_work+0x1d7/0x303
 [<ffffffff810b4269>] ? process_one_work+0x16d/0x303
 [<ffffffff810b161b>] ? spin_lock_irq+0x9/0xb
 [<ffffffff810b47d2>] worker_thread+0x12e/0x1fb
 [<ffffffff810b46a4>] ? rescuer_thread+0x27b/0x27b
 [<ffffffff810b9d61>] kthread+0x9d/0xa5
 [<ffffffff815916e3>] ? _raw_spin_unlock_irq+0x29/0x54
 [<ffffffff810b9cc4>] ? __kthread_parkme+0x60/0x60
 [<ffffffff8159674c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810b9cc4>] ? __kthread_parkme+0x60/0x60
Code: 65 48 8b 04 25 c0 c8 00 00 48 8b 80 b8 03 00 00 48 89 e5 5d 48 8b 40 98 48 c1 e8 02 83 e0 01 c3 48 8b
RIP  [<ffffffff810ba165>] kthread_data+0xb/0x11
 RSP <ffff88021625ba28>
CR2: ffffffffffffffa8
---[ end trace ba755a478f678e6b ]---
Fixing recursive fault but reboot is needed!
ath10k: htt tx alloc msdu_id 0
ath10k: msdu 0xd0b8a780
ath10k: htt data tx using tid 16
ath10k: pci send data vaddr ffff880032cce8c0 paddr 0x32cce8c0 len 76 as 76 bytes
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
Shutting down cpus with NMI
drm_kms_helper: panic occurred, switching back to text console



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

