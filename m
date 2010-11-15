Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34197 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab0KOR4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 12:56:37 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oAFHua3u002482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 09:56:37 -0800
Message-ID: <4CE17454.3030301@candelatech.com>
Date: Mon, 15 Nov 2010 09:56:36 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k:  Failed to stp TX DMA (with hacked wifi stack)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This again is with my patch that allows scan results to be shared,
and I have not seen this on an official kernel.

Here is the first warning that I see in the logs.  It happens soon
after startup, when the interfaces start associating.

Nov 15 09:31:45 localhost kernel: ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
Nov 15 09:31:45 localhost kernel: ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
Nov 15 09:31:45 localhost kernel: ADDRCONF(NETDEV_CHANGE): sta28: link becomes ready
Nov 15 09:31:49 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 09:31:49 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 09:31:49 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
Nov 15 09:31:49 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 09:31:49 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 09:31:49 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
Nov 15 09:31:49 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Nov 15 09:31:49 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020
Nov 15 09:31:49 localhost kernel: ------------[ cut here ]------------
Nov 15 09:31:49 localhost kernel: WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/recv.c:532 ath_stoprecv+0x90/0x9a [at)
Nov 15 09:31:49 localhost kernel: Hardware name: PDSBM
Nov 15 09:31:49 localhost kernel: Could not stop RX, we could be confusing the DMA engine when we start RX up
Nov 15 09:31:49 localhost kernel: Modules linked in: aes_i586 aes_generic 8021q garp stp llc michael_mic macvlan pktgen fuse nfs lockd fscache nfs_acl auth]
Nov 15 09:31:49 localhost kernel: Pid: 4932, comm: wpa_supplicant Tainted: G        W   2.6.37-rc1-wl+ #47
Nov 15 09:31:49 localhost kernel: Call Trace:
Nov 15 09:31:49 localhost kernel: [<78436f25>] warn_slowpath_common+0x77/0x8c
Nov 15 09:31:49 localhost kernel: [<f8a4a106>] ? ath_stoprecv+0x90/0x9a [ath9k]
Nov 15 09:31:49 localhost kernel: [<f8a4a106>] ? ath_stoprecv+0x90/0x9a [ath9k]
Nov 15 09:31:49 localhost kernel: [<78436fb6>] warn_slowpath_fmt+0x2e/0x30
Nov 15 09:31:49 localhost kernel: [<f8a4a106>] ath_stoprecv+0x90/0x9a [ath9k]
Nov 15 09:31:49 localhost kernel: [<f8a490b9>] ath_set_channel+0x94/0x1e8 [ath9k]
Nov 15 09:31:49 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 09:31:49 localhost kernel: [<7878e27b>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Nov 15 09:31:49 localhost kernel: [<f8a49551>] ath9k_config+0x344/0x423 [ath9k]
Nov 15 09:31:49 localhost kernel: [<f8682aaa>] ieee80211_hw_config+0x11b/0x125 [mac80211]
Nov 15 09:31:49 localhost kernel: [<f8691e36>] ieee80211_set_channel+0x74/0x9e [mac80211]
Nov 15 09:31:49 localhost kernel: [<f824aa29>] cfg80211_set_freq+0x92/0xb5 [cfg80211]
Nov 15 09:31:49 localhost kernel: [<f8691dc2>] ? ieee80211_set_channel+0x0/0x9e [mac80211]
Nov 15 09:31:49 localhost kernel: [<f824cf28>] cfg80211_mgd_wext_siwfreq+0x108/0x148 [cfg80211]
Nov 15 09:31:49 localhost kernel: [<f824c2a6>] cfg80211_wext_siwfreq+0x42/0xbf [cfg80211]
Nov 15 09:31:49 localhost kernel: [<7876deeb>] ioctl_standard_call+0x52/0x28e
Nov 15 09:31:49 localhost kernel: [<786f2b2b>] ? dev_name_hash+0x16/0x48
Nov 15 09:31:49 localhost kernel: [<786f653c>] ? __dev_get_by_name+0x32/0x3d
Nov 15 09:31:49 localhost kernel: [<7876e1b4>] wext_handle_ioctl+0x8d/0x18d
Nov 15 09:31:49 localhost kernel: [<f824c264>] ? cfg80211_wext_siwfreq+0x0/0xbf [cfg80211]
Nov 15 09:31:49 localhost kernel: [<786f7669>] dev_ioctl+0x520/0x53f
Nov 15 09:31:49 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 09:31:49 localhost kernel: [<786e6ada>] ? sys_sendto+0xb8/0xc6
Nov 15 09:31:49 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 09:31:49 localhost kernel: [<786e5d1f>] ? sock_ioctl+0x0/0x202
Nov 15 09:31:49 localhost kernel: [<786e5f15>] sock_ioctl+0x1f6/0x202
Nov 15 09:31:49 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 09:31:49 localhost kernel: [<786e5d1f>] ? sock_ioctl+0x0/0x202
Nov 15 09:31:49 localhost kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 15 09:31:49 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 09:31:49 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 09:31:49 localhost kernel: [<784c1369>] ? fget_light+0x2d/0xb0
Nov 15 09:31:49 localhost kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 15 09:31:49 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 09:31:49 localhost kernel: ---[ end trace 5082762405b9644b ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

