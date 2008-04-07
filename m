Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:34063 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYDGT6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 15:58:21 -0400
Received: by nf-out-0910.google.com with SMTP id g13so739966nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2008 12:58:19 -0700 (PDT)
Message-ID: <47FA7CBB.4060504@gmail.com> (sfid-20080407_205837_899174_DBCD04E4)
Date: Mon, 07 Apr 2008 21:57:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: RTNL: assertion failed at key.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I got this:

RTNL: assertion failed at /home/l/latest/xxx/net/mac80211/sta_info.c (140)
Pid: 19097, comm: ath5k_pci Tainted: G        W 2.6.25-rc8-mm1_64lock #6

Call Trace:
  [<ffffffffa009073c>] :mac80211:sta_info_destroy+0x14c/0x170
  [<ffffffffa009085b>] :mac80211:sta_info_flush+0xfb/0x120
  [<ffffffffa0093926>] :mac80211:ieee80211_sta_join_ibss+0x66/0x560
  [<ffffffffa0093f2d>] ? :mac80211:ieee80211_rx_bss_add+0x10d/0x160
  [<ffffffff804e020f>] ? _spin_unlock_bh+0x2f/0x40
  [<ffffffffa0093f2d>] ? :mac80211:ieee80211_rx_bss_add+0x10d/0x160
  [<ffffffffa0095526>] :mac80211:ieee80211_sta_find_ibss+0x376/0x4a0
  [<ffffffffa0095885>] ? :mac80211:ieee80211_scan_completed+0x125/0x2c0
  [<ffffffffa00959e5>] :mac80211:ieee80211_scan_completed+0x285/0x2c0
  [<ffffffffa0098a72>] :mac80211:ieee80211_sta_scan_work+0xa2/0x1e0
  [<ffffffffa00989d0>] ? :mac80211:ieee80211_sta_scan_work+0x0/0x1e0
  [<ffffffff80241fc6>] run_workqueue+0x176/0x220
  [<ffffffff80242c96>] worker_thread+0xa6/0x110
  [<ffffffff802462e0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff80242bf0>] ? worker_thread+0x0/0x110
  [<ffffffff80245ebd>] kthread+0x4d/0x80
  [<ffffffff8020c558>] child_rip+0xa/0x12
  [<ffffffff8020bc6f>] ? restore_args+0x0/0x30
  [<ffffffff80245e70>] ? kthread+0x0/0x80
  [<ffffffff8020c54e>] ? child_rip+0x0/0x12

RTNL: assertion failed at /home/l/latest/xxx/net/mac80211/key.c (275)
Pid: 19097, comm: ath5k_pci Tainted: G        W 2.6.25-rc8-mm1_64lock #6

Call Trace:
  [<ffffffffa00a218a>] :mac80211:ieee80211_key_free+0xaa/0xb0
  [<ffffffffa0090634>] :mac80211:sta_info_destroy+0x44/0x170
  [<ffffffffa009085b>] :mac80211:sta_info_flush+0xfb/0x120
  [<ffffffffa0093926>] :mac80211:ieee80211_sta_join_ibss+0x66/0x560
  [<ffffffffa0093f2d>] ? :mac80211:ieee80211_rx_bss_add+0x10d/0x160
  [<ffffffff804e020f>] ? _spin_unlock_bh+0x2f/0x40
  [<ffffffffa0093f2d>] ? :mac80211:ieee80211_rx_bss_add+0x10d/0x160
  [<ffffffffa0095526>] :mac80211:ieee80211_sta_find_ibss+0x376/0x4a0
  [<ffffffffa0095885>] ? :mac80211:ieee80211_scan_completed+0x125/0x2c0
  [<ffffffffa00959e5>] :mac80211:ieee80211_scan_completed+0x285/0x2c0
  [<ffffffffa0098a72>] :mac80211:ieee80211_sta_scan_work+0xa2/0x1e0
  [<ffffffffa00989d0>] ? :mac80211:ieee80211_sta_scan_work+0x0/0x1e0
  [<ffffffff80241fc6>] run_workqueue+0x176/0x220
  [<ffffffff80242c96>] worker_thread+0xa6/0x110
  [<ffffffff802462e0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff80242bf0>] ? worker_thread+0x0/0x110
  [<ffffffff80245ebd>] kthread+0x4d/0x80
  [<ffffffff8020c558>] child_rip+0xa/0x12
  [<ffffffff8020bc6f>] ? restore_args+0x0/0x30
  [<ffffffff80245e70>] ? kthread+0x0/0x80
  [<ffffffff8020c54e>] ? child_rip+0x0/0x12


I don't know what's the proper place for rtnl_un/lock here. sta_info_flush? Or 
even ieee80211_sta_join_ibss and others who call sta_info_flush?

Thanks.
