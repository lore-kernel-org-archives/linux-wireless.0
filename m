Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40436 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab0LAS6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 13:58:06 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oB1Iw5Zl004833
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 1 Dec 2010 10:58:06 -0800
Message-ID: <4CF69ABD.1060204@candelatech.com>
Date: Wed, 01 Dec 2010 10:58:05 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k:  DMA error without scan optimization.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As a work-around, I disabled the scan optimization by running one
wpa-supplicant per interface.  This makes the system much more stable,
and it ran overnight with 30 STA interfaces at low speed (64kbps
tx + rx for each STA).

This morning, I bumped speed to 384Kbps, and it ran fine for 30
minutes or so.  Then, I noticed this error on the console.

The system seems OK still, but I figure it's a matter of time.

Any suggestions for working around this error?  Maybe try
stopping DMA several times in a loop?

sta7: detected beacon loss from AP - sending probe request
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/recv.c:532 ath_stoprecv+0x90/0x9a [ath9k]()
Hardware name: PDSBM
Could not stop RX, we could be confusing the DMA engine when we start RX up
Modules linked in: michael_mic aes_i586 aes_generic 8021q garp stp llc macvlan pktgen fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb 
ath9k mac80211 ath9k_common ath9k_hw microcode ath e1000e cfg80211 iTCO_wdt iTCO_vendor_support pcspkr i2c_i801 i915 drm_kms_helper drm i2c_algo_bit i2c_core 
video output [last unloaded: ipt_addrtype]
Pid: 24656, comm: kworker/u:2 Tainted: G        W   2.6.37-rc3-wl+ #53
Call Trace:
  [<78436fe9>] warn_slowpath_common+0x77/0x8c
  [<f8f6c19e>] ? ath_stoprecv+0x90/0x9a [ath9k]
  [<f8f6c19e>] ? ath_stoprecv+0x90/0x9a [ath9k]
  [<7843707a>] warn_slowpath_fmt+0x2e/0x30
  [<f8f6c19e>] ath_stoprecv+0x90/0x9a [ath9k]
  [<f8f6a495>] ath_reset+0x55/0x163 [ath9k]
  [<7844090e>] ? process_timeout+0x0/0xa
  [<f8f6b9c9>] ath_hw_check+0x3f/0x4a [ath9k]
  [<78447000>] process_one_work+0x1af/0x2bf
  [<78446f8f>] ? process_one_work+0x13e/0x2bf
  [<f8f6b98a>] ? ath_hw_check+0x0/0x4a [ath9k]
  [<7844874e>] worker_thread+0xf9/0x1bf
  [<78448655>] ? worker_thread+0x0/0x1bf
  [<7844b27e>] kthread+0x62/0x67
  [<7844b21c>] ? kthread+0x0/0x67
  [<784036c6>] kernel_thread_helper+0x6/0x1a
---[ end trace c9b5512870bdacf6 ]---
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

