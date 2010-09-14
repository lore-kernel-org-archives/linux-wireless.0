Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38816 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab0INVKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 17:10:09 -0400
Message-ID: <4C8FE4AC.3040107@candelatech.com>
Date: Tue, 14 Sep 2010 14:10:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: BUG in ath9k_tx
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am running 2.6.36-rc4-wl+, with Johannes's sta_info_get_bss patch,
my ath9k rxfilter patch, and Felix's bssid-mask patch.

I had created two un-encrypted STA interfaces.  I was messing with another
machine, trying to get a sniffer working when this happened.

I saw this a few days ago as well, but didn't get a chance to get a good
stacktrace.


kernel BUG at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c:190!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/net/sta1/flags
Modules linked in: 8021q garp stp llc fuse michael_mic macvlan pktgen nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac]

Pid: 43, comm: kworker/u:3 Not tainted 2.6.36-rc4-wl+ #1 PDSBM/PDSBM
EIP: 0060:[<f8beb313>] EFLAGS: 00010286 CPU: 1
EIP is at ath_tx_start+0x5e2/0x671 [ath9k]
EAX: 00000000 EBX: f4b282c0 ECX: f4b282c0 EDX: f67e0054
ESI: 00000004 EDI: 00000000 EBP: f6a15c44 ESP: f6a15c04
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kworker/u:3 (pid: 43, ti=f6a14000 task=f7384910 task.ti=f6a14000)
Stack:
  f678d4e0 01880019 f67e007c f67b0004 f4bd582c f678c3e0 00000188 f67d0064
<0> f6a15c6c f678d694 00000000 f67e0054 f67e0054 f678d694 f5a30800 0000001a
<0> f6a15c88 f8be5749 f67b0004 00000080 f8bf290b f5a30800 00000002 f678c3e0
Call Trace:
  [<f8be5749>] ? ath9k_tx+0x223/0x254 [ath9k]
  [<f8b96b1b>] ? __ieee80211_tx+0xff/0x164 [mac80211]
  [<f8b97972>] ? ieee80211_tx+0xc1/0x1ad [mac80211]
  [<f8b97bca>] ? ieee80211_xmit+0x16c/0x179 [mac80211]
  [<c045629d>] ? trace_hardirqs_on+0xb/0xd
  [<f8b98ab4>] ? ieee80211_subif_start_xmit+0x62d/0x641 [mac80211]
  [<c06c540d>] ? rcu_read_unlock+0x17/0x19
  [<c06c5977>] ? sock_def_write_space+0xae/0xb3
  [<c06d0ec8>] ? dev_hard_start_xmit+0x31b/0x3ed
  [<c06e1813>] ? sch_direct_xmit+0x50/0x116
  [<c06e19b2>] ? __qdisc_run+0xd9/0xf3
  [<c06ce37e>] ? net_tx_action+0xb7/0xdf
  [<c04392e7>] ? __do_softirq+0x86/0x111
  [<c04393a8>] ? do_softirq+0x36/0x5a
  [<c04394e1>] ? irq_exit+0x35/0x68
  [<c0418c3a>] ? smp_apic_timer_interrupt+0x6e/0x7c
  [<c07632ff>] ? apic_timer_interrupt+0x2f/0x40
  [<c045007b>] ? do_adjtimex+0x147/0x55e
  [<c0762b64>] ? _raw_spin_unlock_irqrestore+0x40/0x48
  [<f8b9a6c3>] ? ieee80211_wake_queues_by_reason+0x41/0x48 [mac80211]
  [<f8b9aa1d>] ? ieee80211_wake_queues+0xa/0xc [mac80211]
  [<f8be510c>] ? ath_reset+0x147/0x159 [ath9k]
  [<f8be5a11>] ? ath_hw_check+0x3c/0x47 [ath9k]
  [<c0443c53>] ? process_one_work+0x1bd/0x2c3
  [<c0443c09>] ? process_one_work+0x173/0x2c3
  [<f8be59d5>] ? ath_hw_check+0x0/0x47 [ath9k]
  [<c04452fe>] ? worker_thread+0xf7/0x1f7
  [<c0445207>] ? worker_thread+0x0/0x1f7
  [<c0447cd3>] ? kthread+0x62/0x67
  [<c0447c71>] ? kthread+0x0/0x67
  [<c0403506>] ? kernel_thread_helper+0x6/0x1a
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

