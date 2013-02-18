Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54699 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab3BRWOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 17:14:32 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r1IMEVX7026078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 14:14:32 -0800
Message-ID: <5122A7C7.3070508@candelatech.com> (sfid-20130218_231436_933191_3F8FE600)
Date: Mon, 18 Feb 2013 14:14:31 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Crash on removal of 400 interfaces (3.7.6+)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We often see crashes in work-queue processing when deleting
lots of wifi station interfaces.  I'm guessing that there is probably
a work item that was not properly un-registered before deleting
memory.  I have backported some wifi fixes from upstream, so
maybe they are to blame, but in case anyone has any suggestions
for places to look, please let me know.

For reference, my tree is here:
http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.7.dev.y/.git;a=summary

I'll go poke at the code in the meantime.



wiphy1: start_sw_scan: running-other-vifs: 0  running-station-vifs: 159, associated-stations: 156 scanning current channel: 5745 MHz
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81099d58>] cwq_dec_nr_in_flight+0x46/0xd5
sta110: deauthenticating from 30:46:9a:10:0b:9c by local choice (reason=3)
PGD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: nfsv3 nfs_acl nfnetlink_log nfnetlink bluetooth nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat fuse 8021q garp stp llc macvlan lockd 
wanlink(O) sunrpc pktgen f71882fg coretemp hwmon mperf iTCO_wdt iTCO_vendor_support kvm cdc_acm ppdev gpio_ich snd_hda_codec_realtek i2c_i801 microcode 
serio_raw lpc_ich pcspkr ath9k ath9k_common ath9k_hw ath mac80211 snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc 
snd_timer snd soundcore cfg80211 parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_nat]
CPU 1
Pid: 15954, comm: kworker/u:2 Tainted: G        WC O 3.7.6+ #65 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff81099d58>]  [<ffffffff81099d58>] cwq_dec_nr_in_flight+0x46/0xd5
RSP: 0018:ffff8800c6ed9dc8  EFLAGS: 00010046
RAX: ffff8802187acec0 RBX: ffff880087755000 RCX: 0000000000000000
RDX: ffff8802187acec8 RSI: 000000000000000a RDI: ffff8802149ad400
RBP: ffff8800c6ed9dd8 R08: 0000000000000000 R09: ffff88021b9aed10
R10: ffff88021b9aed18 R11: ffffffff81c0cbf0 R12: ffffffff81c0c9c0
R13: ffff8802149ad400 R14: ffff88021b9aed10 R15: ffffffff81c0cbe0
FS:  0000000000000000(0000) GS:ffff88022bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001a0b000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/u:2 (pid: 15954, threadinfo ffff8800c6ed8000, task ffff880092111730)
Stack:
  ffff880087755000 ffffffff81c0c9c0 ffff8800c6ed9e38 ffffffff8109a3b9
  ffff8802220f0000 00ffffff81a13410 ffffffffa026030b ffff8802149ad4a5
  ffffffff81c0cbe0 ffff880087755000 ffffffff81c0cbe0 ffff880087755020
Call Trace:
  [<ffffffff8109a3b9>] process_one_work+0x26c/0x27b
  [<ffffffffa026030b>] ? ieee80211_netdev_select_queue+0x12/0x12 [mac80211]
  [<ffffffff8109c6a8>] worker_thread+0x158/0x255
  [<ffffffff8109c550>] ? manage_workers+0x26e/0x26e
  [<ffffffff810a0084>] kthread+0xbf/0xc7
  [<ffffffff81523dfe>] ? schedule+0x5f/0x61
  [<ffffffff8109ffc5>] ? __init_kthread_worker+0x37/0x37
  [<ffffffff81529b7c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8109ffc5>] ? __init_kthread_worker+0x37/0x37
Code: 8b 47 54 48 8b 57 60 ff c8 48 39 ca 89 47 54 74 6e 3b 47 58 7d 69 4c 8b 42 f8 31 c9 48 8d 42 f8 41 f6 c0 04 74 05 4c 89 c1 30 c9 <4c> 8b 09 4c 8b 40 08 4d 
8d 61 10 49 83 e8 08 eb 32 4c 8b 58 10
RIP  [<ffffffff81099d58>] cwq_dec_nr_in_flight+0x46/0xd5
  RSP <ffff8800c6ed9dc8>
CR2: 0000000000000000
---[ end trace 5f3eec36f8009bcd ]---
note: kworker/u:2[15954] exited with preempt_count 1
BUG: unable to handle kernel paging request at ffffffffffffffc8
IP: [<ffffffff8109fadc>] kthread_data+0xb/0x11
PGD 1a0d067 PUD 1a0e067 PMD 0
Oops: 0000 [#2] PREEMPT SMP
Modules linked in: nfsv3 nfs_acl nfnetlink_log nfnetlink bluetooth nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat fuse 8021q garp stp llc macvlan lockd 
wanlink(O) sunrpc pktgen f71882fg coretemp hwmon mperf iTCO_wdt iTCO_vendor_support kvm cdc_acm ppdev gpio_ich snd_hda_codec_realtek i2c_i801 microcode 
serio_raw lpc_ich pcspkr ath9k ath9k_common ath9k_hw ath mac80211 snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc 
snd_timer snd soundcore cfg80211 parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_nat]
CPU 1
Pid: 15954, comm: kworker/u:2 Tainted: G      D WC O 3.7.6+ #65 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109fadc>]  [<ffffffff8109fadc>] kthread_data+0xb/0x11
RSP: 0018:ffff8800c6ed9998  EFLAGS: 00010092
RAX: 0000000000000000 RBX: ffff88022bc92b80 RCX: ffff880092111778
RDX: ffffffff81c0d460 RSI: 0000000000000001 RDI: ffff880092111730
RBP: ffff8800c6ed9998 R08: 00000000bb51f0b4 R09: 000224203fbfdcda
R10: ffff880092111730 R11: ffff8800c6ed99f8 R12: ffff880092111af8
R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88022bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffffffffc8 CR3: 0000000001a0b000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/u:2 (pid: 15954, threadinfo ffff8800c6ed8000, task ffff880092111730)
Stack:
  ffff8800c6ed99c8 ffffffff8109c04d ffff8800c6ed99c8 ffff88022bc92b80
  ffff880092111af8 ffff8800c6ed9aa8 ffff8800c6ed9a68 ffffffff8152396d
  ffff8800c6ed99f8 ffff880092111730 ffff8800c6ed8010 ffff880092111730
Call Trace:
  [<ffffffff8109c04d>] wq_worker_sleeping+0x15/0x73
  [<ffffffff8152396d>] __schedule+0x17f/0x561
  [<ffffffff81523dfe>] schedule+0x5f/0x61
  [<ffffffff8108bcfd>] do_exit+0x7d4/0x7d8
  [<ffffffff81525e44>] oops_end+0xba/0xc2
  [<ffffffff8103218d>] no_context+0x25a/0x269
  [<ffffffff81032363>] __bad_area_nosemaphore+0x1c7/0x1e7
  [<ffffffff81009866>] ? __switch_to+0x1f7/0x421
  [<ffffffff81032391>] bad_area_nosemaphore+0xe/0x10
  [<ffffffff81527cc2>] __do_page_fault+0x313/0x385
  [<ffffffff81523d0d>] ? __schedule+0x51f/0x561
  [<ffffffff81523dfe>] ? schedule+0x5f/0x61
  [<ffffffff81527d3d>] do_page_fault+0x9/0xb
  [<ffffffff81525388>] page_fault+0x28/0x30
  [<ffffffff81099d58>] ? cwq_dec_nr_in_flight+0x46/0xd5
  [<ffffffff81524a55>] ? _raw_spin_lock_irq+0x25/0x2a
  [<ffffffff8109a3b9>] process_one_work+0x26c/0x27b
  [<ffffffffa026030b>] ? ieee80211_netdev_select_queue+0x12/0x12 [mac80211]
  [<ffffffff8109c6a8>] worker_thread+0x158/0x255
  [<ffffffff8109c550>] ? manage_workers+0x26e/0x26e
  [<ffffffff810a0084>] kthread+0xbf/0xc7
  [<ffffffff81523dfe>] ? schedule+0x5f/0x61
  [<ffffffff8109ffc5>] ? __init_kthread_worker+0x37/0x37
  [<ffffffff81529b7c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8109ffc5>] ? __init_kthread_worker+0x37/0x37
Code: 65 48 8b 04 25 c0 c6 00 00 48 8b 80 70 03 00 00 48 89 e5 48 8b 40 b8 c9 48 c1 e8 02 83 e0 01 c3 48 8b 87 70 03 00 00 55 48 89 e5 <48> 8b 40 c8 c9 c3 48 3b 
3d c7 d8 b6 00 55 48 89 e5 75 09 0f bf
RIP  [<ffffffff8109fadc>] kthread_data+0xb/0x11
  RSP <ffff8800c6ed9998>
CR2: ffffffffffffffc8
---[ end trace 5f3eec36f8009bce ]---
Fixing recursive fault but reboot is needed!
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
Shutting down cpus with NMI
panic occurred, switching back to text console
Rebooting in 10 seconds..


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

