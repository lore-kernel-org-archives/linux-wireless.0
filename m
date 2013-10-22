Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43724 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3JVS0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 14:26:01 -0400
Message-ID: <5266C321.7000103@candelatech.com> (sfid-20131022_202610_828811_F5522976)
Date: Tue, 22 Oct 2013 11:25:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath10k hits warning in sta_info.c:839.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel is stock 'ath' tree, with small printk to debug an ath10k
crash.

This is FYI for now...will be looking at other ath10k crash bugs
before digging into this tone.

Setup is 2 stations trying to associate to same AP, which causes
endless failures and firmware crashes.  Good for chasing bugs :)


DMAR:[fault reason 05] PTE Write access is not set
dmar: DRHD: handling fault status reg 3
dmar: DMAR:[DMA Write] Request device [05:00.0] fault addr ffd52000
DMAR:[fault reason 05] PTE Write access is not set
dmar: DRHD: handling fault status reg 3
dmar: DMAR:[DMA Write] Request device [05:00.0] fault addr ffd52000
DMAR:[fault reason 05] PTE Write access is not set

sta300: authentication with 00:03:83:3d:30:aa timed out
[root@ct523-9292 ~]# ath10k: Failed to delete peer: 00:03:83:3d:30:aa for VDEV: 1
ath10k: WMI vdev stop failed: ret -108
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6 at /mnt/sda/home/greearb/git/ath/net/mac80211/sta_info.c:839 __sta_info_destroy+0x12)
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc macvlan pktgen lockd f71882fg coretemp hw]
CPU: 1 PID: 6 Comm: kworker/u8:0 Tainted: G        WC   3.12.0-rc5-wl+ #1
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
Workqueue: phy0 ieee80211_iface_work [mac80211]
 0000000000000009 ffff8802160d3c28 ffffffff81566b46 ffff88021fa8ec78
 0000000000000000 ffff8802160d3c68 ffffffff8109e0a2 ffff8802160d3c78
 ffffffffa03ceff2 ffff880215b63800 ffff8800d81505c0 ffff88020dc647c0
Call Trace:
 [<ffffffff81566b46>] dump_stack+0x55/0x86
 [<ffffffff8109e0a2>] warn_slowpath_common+0x77/0x91
 [<ffffffffa03ceff2>] ? __sta_info_destroy+0x122/0x1d6 [mac80211]
 [<ffffffff8109e0d1>] warn_slowpath_null+0x15/0x17
dmar: DRHD: handling fault status reg 3
dmar: DMAR:[DMA Write] Request device [05:00.0] fault addr ffd51000
DMAR:[fault reason 05] PTE Write access is not set
dmar: DRHD: handling fault status reg 3
dmar: DMAR:[DMA Write] Request device [05:00.0] fault addr ffd51000
DMAR:[fault reason 05] PTE Write access is not set
 [<ffffffffa03ceff2>] __sta_info_destroy+0x122/0x1d6 [mac80211]
 [<ffffffffa03cf27a>] sta_info_destroy_addr+0x37/0x59 [mac80211]
 [<ffffffffa03edbcc>] ieee80211_destroy_auth_data+0x2a/0x8c [mac80211]
 [<ffffffffa03f1543>] ieee80211_sta_work+0x159/0xb2c [mac80211]
 [<ffffffffa03ea936>] ? ieee80211_wake_queues_by_reason+0x78/0x87 [mac80211]
 [<ffffffff8156cc88>] ? _raw_spin_unlock_irqrestore+0x27/0x32
 [<ffffffffa03d86bf>] ieee80211_iface_work+0x29f/0x2c2 [mac80211]
 [<ffffffffa03edc3b>] ? sdata_unlock+0xd/0xf [mac80211]
 [<ffffffff810afdc1>] ? pwq_activate_delayed_work+0x23/0x31
 [<ffffffff810b1846>] process_one_work+0x162/0x217
 [<ffffffff810b1cbb>] worker_thread+0x12e/0x1fb
 [<ffffffff810b1b8d>] ? rescuer_thread+0x268/0x268
 [<ffffffff810b6a8e>] kthread+0x88/0x90
 [<ffffffff810b6a06>] ? __kthread_parkme+0x60/0x60
 [<ffffffff8157160c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810b6a06>] ? __kthread_parkme+0x60/0x60
---[ end trace 402f96cbcf4a3d3e ]---
sta300: deauthenticating from 00:03:83:3d:30:aa by local choice (reason=3)
ath10k: MSI-X interrupt handling (8 intrs)
ath10k: UART prints disabled
ath10k: firmware 999.999.0.636 booted
ath10k: htt target version 2.1
ath10k: device successfully recovered
ath10k: firmware crashed!



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

