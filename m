Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45703 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086Ab0KOSPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 13:15:33 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oAFIFWi8004427
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 10:15:32 -0800
Message-ID: <4CE178C4.5010006@candelatech.com>
Date: Mon, 15 Nov 2010 10:15:32 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k:  Warning on rmmod  (hacked wifi stack)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Same hacked stack..saw this when I unloaded ath9k.  It had just been loaded
and hadn't otherwise complained.

Nov 15 10:11:36 localhost kernel: ieee80211 phy0: Destroyed STA 00:14:d1:c6:d2:54
rmNov 15 10:11:38 localhost kernel: sta7: deauthenticated from 00:14:d1:c6:d2:54 (Reason: 0)
Nov 15 10:11:38 localhost kernel: ieee80211 phy0: Removed STA 00:14:d1:c6:d2:54
Nov 15 10:11:38 localhost kernel: ieee80211 phy0: Destroyed STA 00:14:d1:c6:d2:54
Nov 15 10:11:38 localhost kernel: sta8: deauthenticated from 00:14:d1:c6:d2:54 (Reason: 0)
mNov 15 10:11:38 localhost kernel: ieee80211 phy0: Removed STA 00:14:d1:c6:d2:54
Nov 15 10:11:38 localhost kernel: ieee80211 phy0: Destroyed STA 00:14:d1:c6:d2:54
od ath9k
Nov 15 10:11:39 localhost kernel: ieee80211 phy0: device now idle
Nov 15 10:11:39 localhost kernel: sta10: deauthenticating from 00:14:d1:c6:d2:54 by local choice (reason=3)
Nov 15 10:11:39 localhost kernel: ieee80211 phy0: Removed STA 00:14:d1:c6:d2:54
Nov 15 10:11:39 localhost kernel: ieee80211 phy0: Destroyed STA 00:14:d1:c6:d2:54
Nov 15 10:11:39 localhost kernel: sta1: deauthenticating from 00:14:d1:c6:d2:54 by local choice (reason=3)
Nov 15 10:11:39 localhost kernel: ieee80211 phy0: Removed STA 00:14:d1:c6:d2:54
Nov 15 10:11:39 localhost kernel: ieee80211 phy0: Destroyed STA 00:14:d1:c6:d2:54
Nov 15 10:11:39 localhost kernel: sta5: deauthenticating from 00:14:d1:c6:d2:54 by local choice (reason=3)
Nov 15 10:11:39 localhost kernel: ieee80211 phy0: Removed STA 00:14:d1:c6:d2:54
Nov 15 10:11:39 localhost kernel: ieee80211 phy0: Destroyed STA 00:14:d1:c6:d2:54
Nov 15 10:11:39 localhost kernel: cfg80211: Calling CRDA to update world regulatory domain
Nov 15 10:11:39 localhost kernel: cfg80211: World regulatory domain updated:
Nov 15 10:11:39 localhost kernel:    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Nov 15 10:11:39 localhost kernel:    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 15 10:11:39 localhost kernel:    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Nov 15 10:11:39 localhost kernel:    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Nov 15 10:11:39 localhost kernel:    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 15 10:11:39 localhost kernel:    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 15 10:11:39 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 10:11:39 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 10:11:39 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 10:11:39 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 10:11:39 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 10:11:39 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 10:11:39 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
Nov 15 10:11:39 localhost kernel: ------------[ cut here ]------------
Nov 15 10:11:39 localhost kernel: WARNING: at /home/greearb/git/linux.wireless-testing/kernel/pm_qos_params.c:267 pm_qos_update_request+0x2e/0x57()
Nov 15 10:11:39 localhost kernel: Hardware name: PDSBM
Nov 15 10:11:39 localhost kernel: pm_qos_update_request() called for unknown object
Nov 15 10:11:39 localhost kernel: Modules linked in: aes_i586 aes_generic 8021q garp stp llc michael_mic macvlan pktgen fuse nfs lockd fscache nfs_acl auth]
Nov 15 10:11:39 localhost kernel: Pid: 2863, comm: rmmod Not tainted 2.6.37-rc1-wl+ #47
Nov 15 10:11:39 localhost kernel: Call Trace:
Nov 15 10:11:39 localhost kernel: [<78436f25>] warn_slowpath_common+0x77/0x8c
Nov 15 10:11:39 localhost kernel: [<7844fd46>] ? pm_qos_update_request+0x2e/0x57
Nov 15 10:11:39 localhost kernel: [<7844fd46>] ? pm_qos_update_request+0x2e/0x57
Nov 15 10:11:39 localhost kernel: [<78436fb6>] warn_slowpath_fmt+0x2e/0x30
Nov 15 10:11:39 localhost kernel: [<7844fd46>] pm_qos_update_request+0x2e/0x57
Nov 15 10:11:39 localhost kernel: [<f8ff0b22>] ath9k_stop+0x17e/0x1a9 [ath9k]
Nov 15 10:11:39 localhost kernel: [<f8f35e58>] ieee80211_stop_device+0x41/0x6d [mac80211]
Nov 15 10:11:39 localhost kernel: [<f8f2b29c>] ieee80211_do_stop+0x31d/0x3b7 [mac80211]
Nov 15 10:11:39 localhost kernel: [<7878e211>] ? _raw_spin_unlock_bh+0x25/0x28
Nov 15 10:11:39 localhost kernel: [<f8f2b348>] ieee80211_stop+0x12/0x16 [mac80211]
Nov 15 10:11:39 localhost kernel: [<786f5e55>] __dev_close+0x73/0x88
Nov 15 10:11:39 localhost kernel: [<7878dd8c>] ? _raw_write_unlock_bh+0x25/0x28
Nov 15 10:11:39 localhost kernel: [<786f5e7e>] dev_close+0x14/0x36
Nov 15 10:11:39 localhost kernel: [<786f5f24>] rollback_registered_many+0x84/0x17a
Nov 15 10:11:39 localhost kernel: [<786f602a>] unregister_netdevice_many+0x10/0x42
Nov 15 10:11:39 localhost kernel: [<f8f2ab9e>] ieee80211_remove_interfaces+0x90/0x98 [mac80211]
Nov 15 10:11:39 localhost kernel: [<f8f1e0b3>] ieee80211_unregister_hw+0x46/0xed [mac80211]
Nov 15 10:11:39 localhost kernel: [<f8fee4d0>] ? ath_deinit_leds+0x93/0x96 [ath9k]
Nov 15 10:11:39 localhost kernel: [<f8fee8f2>] ath9k_deinit_device+0x6a/0x8d [ath9k]
Nov 15 10:11:39 localhost kernel: [<f8ff8ebe>] ath_pci_remove+0x22/0x54 [ath9k]
Nov 15 10:11:39 localhost kernel: [<785af79e>] pci_device_remove+0x27/0xa3
Nov 15 10:11:39 localhost kernel: [<7863616c>] __device_release_driver+0x5c/0xa3
Nov 15 10:11:39 localhost kernel: [<78636221>] driver_detach+0x6e/0x8f
Nov 15 10:11:39 localhost kernel: [<786356e3>] bus_remove_driver+0x69/0x85
Nov 15 10:11:39 localhost kernel: [<7863669e>] driver_unregister+0x53/0x5a
Nov 15 10:11:39 localhost kernel: [<7850728d>] ? sysfs_remove_file+0xf/0x11
Nov 15 10:11:39 localhost kernel: [<785af9d5>] pci_unregister_driver+0x2d/0x6c
Nov 15 10:11:39 localhost kernel: [<f8ff8df5>] ath_pci_exit+0xd/0xf [ath9k]
Nov 15 10:11:39 localhost kernel: [<f8ffb91f>] ath9k_exit+0xb/0x35 [ath9k]
Nov 15 10:11:39 localhost kernel: [<7878ce20>] ? mutex_unlock+0x8/0xa
Nov 15 10:11:39 localhost kernel: [<78461f5b>] sys_delete_module+0x173/0x1c4
Nov 15 10:11:39 localhost kernel: [<784a4d4b>] ? remove_vma+0x57/0x5d
Nov 15 10:11:39 localhost kernel: [<784a59eb>] ? do_munmap+0x239/0x252
Nov 15 10:11:39 localhost kernel: [<7878e53e>] ? restore_all_notrace+0x0/0x18
Nov 15 10:11:39 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 10:11:39 localhost kernel: ---[ end trace e38d5c78a9f7d834 ]---
Nov 15 10:11:40 localhost kernel: ath9k 0000:08:01.0: PCI INT A disabled
Nov 15 10:11:40 localhost kernel: ath9k: Driver unloaded

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

