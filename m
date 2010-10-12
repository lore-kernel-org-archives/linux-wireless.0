Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46144 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0JLVgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 17:36:23 -0400
Message-ID: <4CB4D4D0.9000601@candelatech.com>
Date: Tue, 12 Oct 2010 14:36:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: lockdep buglet in ath9k.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see this with lockdep enabled in today's wireless-testing.

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 1755, comm: ifconfig Not tainted 2.6.36-rc7-wl+ #30
Call Trace:
  [<c075e490>] ? printk+0xf/0x17
  [<c045507e>] register_lock_class+0x5a/0x29e
  [<c0455be6>] ? mark_lock+0x1e/0x1de
  [<c0456af9>] __lock_acquire+0xa2/0xb8c
  [<c0455be6>] ? mark_lock+0x1e/0x1de
  [<c045763d>] lock_acquire+0x5a/0x78
  [<f8c06133>] ? ath9k_config+0x274/0x3d8 [ath9k]
  [<c0760152>] _raw_spin_lock_irqsave+0x2f/0x3f
  [<f8c06133>] ? ath9k_config+0x274/0x3d8 [ath9k]
  [<f8c06133>] ath9k_config+0x274/0x3d8 [ath9k]
  [<f8882a2b>] ieee80211_hw_config+0x11b/0x125 [mac80211]
  [<f888ee9d>] ieee80211_do_open+0x3b4/0x455 [mac80211]
  [<f888e1b2>] ? ieee80211_check_concurrent_iface+0x21/0x13a [mac80211]
  [<f888ef99>] ieee80211_open+0x5b/0x5e [mac80211]
  [<c06cf333>] __dev_open+0x80/0xae
  [<c06cd563>] __dev_change_flags+0xa0/0x115
  [<c06cf287>] dev_change_flags+0x13/0x3f
  [<c0718c2c>] devinet_ioctl+0x21e/0x49d
  [<c071a30c>] inet_ioctl+0x82/0x9b
  [<c06c0418>] sock_ioctl+0x1ce/0x1f0
  [<c06c024a>] ? sock_ioctl+0x0/0x1f0
  [<c04c27df>] do_vfs_ioctl+0x4a7/0x4ec
  [<c0499a16>] ? handle_mm_fault+0x41d/0x9da
  [<c04b823e>] ? fcheck_files+0x81/0xb6
  [<c04c2865>] sys_ioctl+0x41/0x61
  [<c0402f1c>] sysenter_do_call+0x12/0x38
ADDRCONF(NETDEV_UP): wlan0: link is not ready

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

