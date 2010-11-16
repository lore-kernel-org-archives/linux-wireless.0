Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54614 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab0KPAb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 19:31:58 -0500
Message-ID: <4CE1D0F8.70108@candelatech.com>
Date: Mon, 15 Nov 2010 16:31:52 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k:  TX DMA, reset errors and 0xdeadbeef on not-so-hacked kernel.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the previously posted wpa_supplicant patch, I am able to reproduce
the ath9k DMA errors previously seen when I hacked the kernel
to share scan results.

The basic test:  Create 30 STA interfaces, run one patched instance of
wpa_supplicant to manage all interfaces.  My proprietary user-space app
is also running (gathering stats, etc).  The system crashed within a few
minutes of starting the test.

The kernel does NOT have any significant changes, though it does have
this one applied:

mac80211:  Fix deadlock in ieee80211_do_stop.

I cannot reproduce the problem with un-modified wpa_supplicant, so the error
is likely related to the speed at which interfaces attempt to associate.


Nov 15 16:13:36 localhost kernel: ieee80211 phy0: device no longer idle - scanning
Nov 15 16:13:37 localhost kernel: ieee80211 phy0: device now idle
Nov 15 16:13:37 localhost kernel: ieee80211 phy0: device no longer idle - working
Nov 15 16:13:37 localhost kernel: sta8: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta28: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta27: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta25: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta23: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta22: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta20: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta19: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta18: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta17: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta16: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta15: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta8: authenticated
Nov 15 16:13:37 localhost kernel: sta28: authenticated
Nov 15 16:13:37 localhost kernel: sta27: authenticated
Nov 15 16:13:37 localhost kernel: sta28: associate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta8: associate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta14: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta13: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta12: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta11: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta9: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta7: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta24: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta6: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta5: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta4: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta25: authenticated
Nov 15 16:13:37 localhost kernel: sta3: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta2: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta1: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta21: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta23: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta10: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta22: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: wlan0: authenticate with 00:14:d1:c6:d2:54 (try 1)
Nov 15 16:13:37 localhost kernel: sta20: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 16:13:37 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
Nov 15 16:13:37 localhost kernel: sta19: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta18: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta17: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta16: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta15: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta28: associate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta8: associate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta14: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta13: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta12: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta11: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta9: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta7: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta24: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta6: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta5: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta4: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta3: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta2: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta1: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta21: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta23: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta10: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta22: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: wlan0: authenticate with 00:14:d1:c6:d2:54 (try 2)
Nov 15 16:13:37 localhost kernel: sta20: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta19: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta18: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta17: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta16: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta15: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta28: associate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta8: associate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta14: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta13: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta12: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta11: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta9: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta7: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta24: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta6: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta5: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta4: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta3: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta2: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:37 localhost kernel: sta1: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:38 localhost kernel: sta21: authenticate with 00:14:d1:c6:d2:54 (try 3)
Nov 15 16:13:38 localhost kernel: sta23: authentication with 00:14:d1:c6:d2:54 timed out
Nov 15 16:13:39 localhost kernel: ath: timeout (100000 us) on reg 0x9860: 0xdeadbeef & 0x00000001 != 0x00000000
Nov 15 16:13:39 localhost kernel: ath: Unable to reset hardware; reset status -5
Nov 15 16:13:39 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0xdeadbeef AR_DIAG_SW=0xdeadbeef
Nov 15 16:13:39 localhost kernel: ------------[ cut here ]------------
Nov 15 16:13:39 localhost kernel: WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/recv.c:532 ath_stoprecv+0x90/0x9a [at)
Nov 15 16:13:39 localhost kernel: Hardware name: PDSBM
Nov 15 16:13:39 localhost kernel: Could not stop RX, we could be confusing the DMA engine when we start RX up
Nov 15 16:13:39 localhost kernel: Modules linked in: michael_mic aes_i586 aes_generic 8021q garp stp llc fuse macvlan pktgen nfs lockd fscache nfs_acl auth]
Nov 15 16:13:39 localhost kernel: Pid: 16755, comm: wpa_supplicant Not tainted 2.6.37-rc1-wl+ #48
Nov 15 16:13:39 localhost kernel: Call Trace:
Nov 15 16:13:39 localhost kernel: [<78436f25>] warn_slowpath_common+0x77/0x8c
Nov 15 16:13:39 localhost kernel: [<f8a4a106>] ? ath_stoprecv+0x90/0x9a [ath9k]
Nov 15 16:13:39 localhost kernel: [<f8a4a106>] ? ath_stoprecv+0x90/0x9a [ath9k]
Nov 15 16:13:39 localhost kernel: [<78436fb6>] warn_slowpath_fmt+0x2e/0x30
Nov 15 16:13:39 localhost kernel: [<f8a4a106>] ath_stoprecv+0x90/0x9a [ath9k]
Nov 15 16:13:39 localhost kernel: [<f8a490b9>] ath_set_channel+0x94/0x1e8 [ath9k]
Nov 15 16:13:39 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 16:13:39 localhost kernel: [<7878e27b>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Nov 15 16:13:39 localhost kernel: [<f8a49551>] ath9k_config+0x344/0x423 [ath9k]
Nov 15 16:13:39 localhost kernel: [<f8ae2aaa>] ieee80211_hw_config+0x11b/0x125 [mac80211]
Nov 15 16:13:39 localhost kernel: [<f8af1e36>] ieee80211_set_channel+0x74/0x9e [mac80211]
Nov 15 16:13:39 localhost kernel: [<f83288b5>] cfg80211_set_freq+0x92/0xb5 [cfg80211]
Nov 15 16:13:39 localhost kernel: [<f8af1dc2>] ? ieee80211_set_channel+0x0/0x9e [mac80211]
Nov 15 16:13:39 localhost kernel: [<f832adb4>] cfg80211_mgd_wext_siwfreq+0x108/0x148 [cfg80211]
Nov 15 16:13:39 localhost kernel: [<f832a132>] cfg80211_wext_siwfreq+0x42/0xbf [cfg80211]
Nov 15 16:13:39 localhost kernel: [<7876deeb>] ioctl_standard_call+0x52/0x28e
Nov 15 16:13:39 localhost kernel: [<786f2b2b>] ? dev_name_hash+0x16/0x48
Nov 15 16:13:39 localhost kernel: [<786f653c>] ? __dev_get_by_name+0x32/0x3d
Nov 15 16:13:39 localhost kernel: [<7876e1b4>] wext_handle_ioctl+0x8d/0x18d
Nov 15 16:13:39 localhost kernel: [<f832a0f0>] ? cfg80211_wext_siwfreq+0x0/0xbf [cfg80211]
Nov 15 16:13:39 localhost kernel: [<786f7669>] dev_ioctl+0x520/0x53f
Nov 15 16:13:39 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 16:13:39 localhost kernel: [<786e6ada>] ? sys_sendto+0xb8/0xc6
Nov 15 16:13:39 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 16:13:39 localhost kernel: [<786e5d1f>] ? sock_ioctl+0x0/0x202
Nov 15 16:13:39 localhost kernel: [<786e5f15>] sock_ioctl+0x1f6/0x202
Nov 15 16:13:39 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 16:13:39 localhost kernel: [<786e5d1f>] ? sock_ioctl+0x0/0x202
Nov 15 16:13:39 localhost kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 15 16:13:39 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 16:13:39 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 16:13:39 localhost kernel: [<784c1369>] ? fget_light+0x2d/0xb0
Nov 15 16:13:39 localhost kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 15 16:13:39 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 16:13:39 localhost kernel: ---[ end trace 7f695003c0bcd2c7 ]---
Nov 15 16:13:39 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0xdeadbeef AR_DIAG_SW=0xdeadbeef
Nov 15 16:13:40 localhost kernel: ath: timeout (100000 us) on reg 0x7000: 0xdeadbeef & 0x00000003 != 0x00000000
Nov 15 16:13:40 localhost kernel: ath: Chip reset failed
Nov 15 16:13:40 localhost kernel: ath: Unable to reset channel (2437 MHz), reset status -22
Nov 15 16:13:40 localhost kernel: ath: Unable to set channel

and after a few more of these..system died hard:

Nov 15 16:13:44 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 16:13:44 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Nov 15 16:13:44 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
Nov 15 16:13:45 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0xdeadbeef AR_DIAG_SW=0xdeadbeef
Nov 15 16:13:45 localhost kernel: ath: timeout (100000 us) on reg 0x7000: 0x00000001 & 0x00000003 != 0x00000000
Nov 15 16:13:45 localhost kernel: ath: Chip reset failed
Nov 15 16:13:45 localhost kernel: ath: Unable to reset hardware; reset status -22
Nov 15 16:13:45 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0xbadc0ffe AR_DIAG_SW=0xbadc0ffe
Nov 15 16:13:45 localhost kernel: ------------[ cut here ]------------
EXT4-fs (dm-2): delayed block allocation failed for inode 394823 at logical offset 0 with max blocks 13 with error -30
EXT4-fs (dm-2): This should not happen!! Data will be lost
EXT4-fs error (device dm-2) in ext4_da_writepages:3068: Journal has aborted

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

