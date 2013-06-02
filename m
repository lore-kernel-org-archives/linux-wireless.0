Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:57565 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117Ab3FBXcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 19:32:50 -0400
Date: Mon, 3 Jun 2013 01:32:47 +0200
From: Jakub Kicinski <kubakici@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: wireless-testing: lockdep warning in __ieee80211_request_smps
Message-ID: <20130603013247.33849c6c@north> (sfid-20130603_013254_066582_3E81ADE4)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

bringing interface up for the first time (or changing PS
settings) cause following warning in current wireless-testing:

WARNING: at /home/kuba/wireless-testing/net/mac80211/cfg.c:2321 __ieee80211_request_smps+0xc5/0xf0 [mac80211]()
Modules linked in: rt2800usb rt2x00usb ...
CPU: 1 PID: 1945 Comm: ifconfig Not tainted 3.10.0-rc3-wl+ #1
Hardware name: Gigabyte Technology Co., Ltd. GA-MA790XT-UD4P/GA-MA790XT-UD4P, BIOS F9b 08/17/2012
 0000000000000009 ffff88021872bb48 ffffffff815d82ad ffff88021872bb88
 ffffffff8103db10 ffff88021872bb78 ffff88021f8eaac0 0000000000000001
 ffff8802188d09e0 ffff88021f8eab58 0000000000000001 ffff88021872bb98
Call Trace:
 [<ffffffff815d82ad>] dump_stack+0x19/0x1b
 [<ffffffff8103db10>] warn_slowpath_common+0x70/0xa0
 [<ffffffff8103db5a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa07345f5>] __ieee80211_request_smps+0xc5/0xf0 [mac80211]
 [<ffffffffa07346a1>] ieee80211_set_power_mgmt+0x81/0x100 [mac80211]
 [<ffffffffa03abf95>] cfg80211_netdev_notifier_call+0x3e5/0x620 [cfg80211]
 [<ffffffff815c0358>] ? dp_device_event+0x48/0x110
 [<ffffffff815e26bd>] notifier_call_chain+0x4d/0x70
 [<ffffffff8106b80e>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff8106b826>] raw_notifier_call_chain+0x16/0x20
 [<ffffffff814d2396>] call_netdevice_notifiers+0x36/0x60
 [<ffffffff814d9658>] __dev_notify_flags+0x38/0x90
 [<ffffffff814d96f5>] dev_change_flags+0x45/0x70
 [<ffffffff81552e79>] devinet_ioctl+0x639/0x720
 [<ffffffff814ebc20>] ? dev_ioctl+0x260/0x750
 [<ffffffff815536b5>] inet_ioctl+0x75/0x90
 [<ffffffff814bc950>] sock_do_ioctl+0x30/0x70
 [<ffffffff81289c08>] ? avc_has_perm_flags+0x28/0x1e0
 [<ffffffff814be714>] sock_ioctl+0x84/0x2b0
 [<ffffffff81175537>] do_vfs_ioctl+0x97/0x640
 [<ffffffff8128ab0a>] ? inode_has_perm.isra.24.constprop.66+0x2a/0x30
 [<ffffffff8128b807>] ? file_has_perm+0x97/0xb0
 [<ffffffff81175b71>] SyS_ioctl+0x91/0xb0
 [<ffffffff812f1629>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff815e6f42>] system_call_fastpath+0x16/0x1b

It seems that wdev.mtx lock is neither held in
nl80211_set_power_save nor in cfg80211_netdev_notifier_call.

I couldn't find any patch addressing this, is it a known
issue?

  -- kuba
