Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:61092 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbZGYAoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 20:44:19 -0400
Received: by wf-out-1314.google.com with SMTP id 26so535376wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 17:44:19 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 24 Jul 2009 17:43:59 -0700
Message-ID: <43e72e890907241743l7eb68cd9h5796e1dc70823c86@mail.gmail.com>
Subject: lockdep complaint , now upgraded on wireless-testing
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pretty sure this is the same one I saw the other day when I applied
the old netns patches from Johannes. Johannes then fixed them, but not
sure if the new shiny patch was posted.

John, I think its best we just revert your current netns patches and
apply Johannes' new ones. That would mean not needing my ath9k oops
fix nor a secondary patch to fix this separately.

  Luis

[   69.138284] =======================================================
[   69.138468] [ INFO: possible circular locking dependency detected ]
[   69.138564] 2.6.31-rc4-wl #6
[   69.138654] -------------------------------------------------------
[   69.138741] wpa_supplicant/3799 is trying to acquire lock:
[   69.138835]  (cfg80211_mutex){+.+.+.}, at: [<ffffffffa009246a>]
cfg80211_get_dev_from_ifindex+0x1a/0x90 [cfg80211]
[   69.139204]
[   69.139205] but task is already holding lock:
[   69.139380]  (rtnl_mutex){+.+.+.}, at: [<ffffffff81400ff2>]
rtnl_lock+0x12/0x20
[   69.139728]
[   69.139729] which lock already depends on the new lock.
[   69.139730]
 69.140017] the existing dependency chain (in reverse order) is:
[   69.140215]
[   69.140215] -> #1 (rtnl_mutex){+.+.+.}:
[   69.140666]        [<ffffffff810857b6>] __lock_acquire+0xd76/0x12b0
[   69.140857]        [<ffffffff81085dd3>] lock_acquire+0xe3/0x120
[   69.141047]        [<ffffffff814ee7a4>] mutex_lock_nested+0x44/0x350
[   69.141241]        [<ffffffff81400ff2>] rtnl_lock+0x12/0x20
[   69.141432]        [<ffffffffa009f6a5>]
nl80211_send_reg_change_event+0x1f5/0x2a0 [cfg80211]
[   69.141642]        [<ffffffffa009529e>] set_regdom+0x28e/0x4c0 [cfg80211]
[   69.141666]        [<ffffffffa0099d7a>] nl80211_set_reg+0x11a/0x2c0
[cfg80211]
[   69.141666]        [<ffffffff81416ad6>] genl_rcv_msg+0x1b6/0x1f0
[   69.141666]        [<ffffffff81415b69>] netlink_rcv_skb+0x89/0xb0
[   69.141666]        [<ffffffff81416909>] genl_rcv+0x29/0x40
[   69.141666]        [<ffffffff8141584d>] netlink_unicast+0x29d/0x2b0
[   69.141666]        [<ffffffff81416444>] netlink_sendmsg+0x214/0x300
[   69.141666]        [<ffffffff813e4407>] sock_sendmsg+0x107/0x130
[   69.141666]        [<ffffffff813e45b9>] sys_sendmsg+0x189/0x320
[   69.141666]        [<ffffffff81011f82>] system_call_fastpath+0x16/0x1b
[   69.141666]        [<ffffffffffffffff>] 0xffffffffffffffff
[   69.141666]
[   69.141666] -> #0 (cfg80211_mutex){+.+.+.}:
[   69.141666]        [<ffffffff8108587b>] __lock_acquire+0xe3b/0x12b0
[   69.141666]        [<ffffffff81085dd3>] lock_acquire+0xe3/0x120
[   69.141666]        [<ffffffff814ee7a4>] mutex_lock_nested+0x44/0x350
[   69.141666]        [<ffffffffa009246a>]
cfg80211_get_dev_from_ifindex+0x1a/0x90 [cfg80211]
[   69.141666]        [<ffffffffa009813f>]
get_rdev_dev_by_info_ifindex+0x6f/0xa0 [cfg80211]
[   69.141666]        [<ffffffffa009b12b>]
nl80211_set_interface+0x3b/0x260 [cfg80211]
