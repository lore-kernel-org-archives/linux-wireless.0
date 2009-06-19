Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3623 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZFSLbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 07:31:10 -0400
Date: Fri, 19 Jun 2009 07:30:49 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org
Subject: lockdep spew
Message-ID: <20090619113049.GB18956@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I get the following in latest wireless-testing, by starting hostapd, then
turning on network manager which then tries to act like a station.  Quite
possibly a driver bug but I haven't had a chance to look at it in depth
yet.

[  959.515213] phy0: device now idle
[  960.122130] phy0: device no longer idle - in use
[  960.161448] phy0: device now idle
[  960.163728] PM: Adding info for No Bus:mon.wlan0
[  960.199042] phy0: device no longer idle - in use
[  960.551906] phy0: Allocated STA 00:18:41:c8:58:43
[  960.552865] phy0: Inserted STA 00:18:41:c8:58:43
[  966.937833] 
[  966.937836] ======================================================
[  966.937855] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
[  966.937863] 2.6.30-wl #136
[  966.937869] ------------------------------------------------------
[  966.937877] wpa_supplicant/2889 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[  966.937884]  (&local->key_lock){......}, at: [<f87ae0ed>] ieee80211_key_free+0x41/0x60 [mac80211]
[  966.937935] 
[  966.937936] and this task is already holding:
[  966.937954]  (&local->sta_lock){..-...}, at: [<f879d49d>] sta_info_flush+0x39/0xbc [mac80211]
[  966.938016] which would create a new lock dependency:
[  966.938032]  (&local->sta_lock){..-...} -> (&local->key_lock){......}
[  966.938108] 
[  966.938109] but this new dependency connects a SOFTIRQ-irq-safe lock:
[  966.938129]  (&local->sta_lock){..-...}
[  966.938151] ... which became SOFTIRQ-irq-safe at:
[  966.938171]   [<c01449c6>] __lock_acquire+0x548/0x12ab
[  966.938199]   [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938221]   [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938256]   [<f87ad33c>] ieee80211_beacon_get+0xfe/0x1f4 [mac80211]
[  966.938259]   [<f86d1648>] ath5k_beacon_update+0x32/0x307 [ath5k]
[  966.938259]   [<f86d1b49>] ath5k_beacon_send+0x22c/0x2b8 [ath5k]
[  966.938259]   [<f86d3448>] ath5k_tasklet_beacon+0x94/0xa3 [ath5k]
[  966.938259]   [<c01282ee>] tasklet_hi_action+0x93/0xe6
[  966.938259]   [<c012885e>] __do_softirq+0xb4/0x184
[  966.938259]   [<c012895e>] do_softirq+0x30/0x48
[  966.938259]   [<c0128ada>] irq_exit+0x3d/0x74
[  966.938259]   [<c03724fd>] do_IRQ+0x75/0x89
[  966.938259]   [<c010306e>] common_interrupt+0x2e/0x34
[  966.938259]   [<c02ed1a2>] cpuidle_idle_call+0x6a/0xa0
[  966.938259]   [<c0101c36>] cpu_idle+0x53/0x85
[  966.938259]   [<c035eefc>] rest_init+0x6c/0x6e
[  966.938259]   [<c0506735>] start_kernel+0x281/0x286
[  966.938259]   [<c0506038>] __init_begin+0x38/0x40
[  966.938259]   [<ffffffff>] 0xffffffff
[  966.938259] 
[  966.938259] to a SOFTIRQ-irq-unsafe lock:
[  966.938259]  (todo_lock){+.+...}
[  966.938259] ... which became SOFTIRQ-irq-unsafe at:
[  966.938259] ...  [<c0144a3b>] __lock_acquire+0x5bd/0x12ab
[  966.938259]   [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]   [<c036e955>] _spin_lock+0x2d/0x5d
[  966.938259]   [<f87ae088>] __ieee80211_key_todo+0x1c5/0x1e9 [mac80211]
[  966.938259]   [<f87ae1ab>] ieee80211_key_todo+0x19/0x25 [mac80211]
[  966.938259]   [<f87ae238>] ieee80211_todo_for_each_key+0x72/0x79 [mac80211]
[  966.938259]   [<f87ae2d6>] ieee80211_enable_keys+0x56/0x5b [mac80211]
[  966.938259]   [<f87a631b>] ieee80211_open+0x44e/0x5a3 [mac80211]
[  966.938259]   [<c030bced>] dev_open+0x8b/0xc0
[  966.938259]   [<c030b73a>] dev_change_flags+0x9b/0x14c
[  966.938259]   [<c0312951>] do_setlink+0x2a2/0x348
[  966.938259]   [<c0312adc>] rtnl_setlink+0xe5/0xe9
[  966.938259]   [<c0313894>] rtnetlink_rcv_msg+0x18a/0x1a0
[  966.938259]   [<c031b78e>] netlink_rcv_skb+0x35/0x7b
[  966.938259]   [<c0313703>] rtnetlink_rcv+0x20/0x27
[  966.938259]   [<c031b30b>] netlink_unicast+0x1a9/0x20a
[  966.938259]   [<c031b58f>] netlink_sendmsg+0x223/0x230
[  966.938259]   [<c02fea7f>] sock_sendmsg+0xcc/0xe2
[  966.938259]   [<c02febe3>] sys_sendmsg+0x14e/0x19b
[  966.938259]   [<c02ffb2d>] sys_socketcall+0x13f/0x168
[  966.938259]   [<c01029c8>] sysenter_do_call+0x12/0x36
[  966.938259]   [<ffffffff>] 0xffffffff
[  966.938259] 
[  966.938259] other info that might help us debug this:
[  966.938259] 
[  966.938259] 2 locks held by wpa_supplicant/2889:
[  966.938259]  #0:  (rtnl_mutex){+.+.+.}, at: [<c03136e1>] rtnl_lock+0x14/0x16
[  966.938259]  #1:  (&local->sta_lock){..-...}, at: [<f879d49d>] sta_info_flush+0x39/0xbc [mac80211]
[  966.938259] 
[  966.938259] the SOFTIRQ-irq-safe lock's dependencies:
[  966.938259] -> (&local->sta_lock){..-...} ops: 0 {
[  966.938259]    IN-SOFTIRQ-W at:
[  966.938259]                                        [<c01449c6>] __lock_acquire+0x548/0x12ab
[  966.938259]                                        [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                        [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]                                        [<f87ad33c>] ieee80211_beacon_get+0xfe/0x1f4 [mac80211]
[  966.938259]                                        [<f86d1648>] ath5k_beacon_update+0x32/0x307 [ath5k]
[  966.938259]                                        [<f86d1b49>] ath5k_beacon_send+0x22c/0x2b8 [ath5k]
[  966.938259]                                        [<f86d3448>] ath5k_tasklet_beacon+0x94/0xa3 [ath5k]
[  966.938259]                                        [<c01282ee>] tasklet_hi_action+0x93/0xe6
[  966.938259]                                        [<c012885e>] __do_softirq+0xb4/0x184
[  966.938259]                                        [<c012895e>] do_softirq+0x30/0x48
[  966.938259]                                        [<c0128ada>] irq_exit+0x3d/0x74
[  966.938259]                                        [<c03724fd>] do_IRQ+0x75/0x89
[  966.938259]                                        [<c010306e>] common_interrupt+0x2e/0x34
[  966.938259]                                        [<c02ed1a2>] cpuidle_idle_call+0x6a/0xa0
[  966.938259]                                        [<c0101c36>] cpu_idle+0x53/0x85
[  966.938259]                                        [<c035eefc>] rest_init+0x6c/0x6e
[  966.938259]                                        [<c0506735>] start_kernel+0x281/0x286
[  966.938259]                                        [<c0506038>] __init_begin+0x38/0x40
[  966.938259]                                        [<ffffffff>] 0xffffffff
[  966.938259]    INITIAL USE at:
[  966.938259]                                       [<c0144a8c>] __lock_acquire+0x60e/0x12ab
[  966.938259]                                       [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                       [<f879d49d>] sta_info_flush+0x39/0xbc [mac80211]
[  966.938259]                                       [<f87a5b50>] ieee80211_stop+0xe3/0x460 [mac80211]
[  966.938259]                                       [<c030ba2f>] dev_close+0x72/0x8e
[  966.938259]                                       [<c030b73a>] dev_change_flags+0x9b/0x14c
[  966.938259]                                       [<c0349492>] devinet_ioctl+0x214/0x4f3
[  966.938259]                                       [<c034a737>] inet_ioctl+0x93/0xac
[  966.938259]                                       [<c02fe2c7>] sock_ioctl+0x1ce/0x1f2
[  966.938259]                                       [<c019a132>] vfs_ioctl+0x1d/0x76
[  966.938259]                                       [<c019a604>] do_vfs_ioctl+0x479/0x4b3
[  966.938259]                                       [<c019a671>] sys_ioctl+0x33/0x4d
[  966.938259]                                       [<c01029c8>] sysenter_do_call+0x12/0x36
[  966.938259]                                       [<ffffffff>] 0xffffffff
[  966.938259]  }
[<f87c3188>] __key.37782+0x0/0xffff1039 [mac80211]
[  966.938259]  -> (&sta->flaglock){..-...} ops: 0 {
[  966.938259]     IN-SOFTIRQ-W at:
[  966.938259]                                          [<c01449c6>] __lock_acquire+0x548/0x12ab
[  966.938259]                                          [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[<f87a9855>] ieee80211_invoke_rx_handlers+0x111/0x11cb [mac80211]
[  966.938259]                                          [<f87aae58>] __ieee80211_rx_handle_packet+0x549/0x576 [mac80211]
[  966.938259]                                          [<f87ab6c3>] __ieee80211_rx+0x4d5/0x556 [mac80211]
[  966.938259]                                          [<f86d3bdd>] ath5k_tasklet_rx+0x50a/0x55d [ath5k]
[  966.938259]                                          [<c01283d4>] tasklet_action+0x93/0xe6
[  966.938259]                                          [<c012885e>] __do_softirq+0xb4/0x184
[  966.938259]                                          [<c012895e>] do_softirq+0x30/0x48
[  966.938259]                                          [<c0128ada>] irq_exit+0x3d/0x74
[  966.938259]                                          [<c03724fd>] do_IRQ+0x75/0x89
[  966.938259]                                          [<c010306e>] common_interrupt+0x2e/0x34
[  966.938259]                                          [<c02ed1a2>] cpuidle_idle_call+0x6a/0xa0
[  966.938259]                                          [<c0101c36>] cpu_idle+0x53/0x85
[  966.938259]                                          [<c035eefc>] rest_init+0x6c/0x6e
[  966.938259]                                          [<c0506735>] start_kernel+0x281/0x286
[  966.938259]                                          [<c0506038>] __init_begin+0x38/0x40
[  966.938259]                                          [<ffffffff>] 0xffffffff
[  966.938259]                                         [<c0144a8c>] __lock_acquire+0x60e/0x12ab
[  966.938259]                                         [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                         [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]                                         [<f87abb40>] ieee80211_tx_prepare+0x238/0x29d [mac80211]
[  966.938259]                                         [<f87aca49>] ieee80211_tx+0x60/0x248 [mac80211]
[  966.938259]                                         [<f87aceb2>] ieee80211_xmit+0x281/0x293 [mac80211]
[  966.938259]                                         [<f87acf83>] ieee80211_monitor_start_xmit+0x82/0x91 [mac80211]
[  966.938259]                                         [<c030af09>] dev_hard_start_xmit+0x256/0x2b5
[  966.938259]                                         [<c0318ff9>] __qdisc_run+0xc5/0x1b0
[  966.938259]                                         [<c030b298>] dev_queue_xmit+0x245/0x367
[  966.938259]                                         [<fa1d4e4e>] packet_sendmsg+0x1c2/0x207 [af_packet]
[  966.938259]                                         [<c02fea7f>] sock_sendmsg+0xcc/0xe2
[  966.938259]                                         [<c02febe3>] sys_sendmsg+0x14e/0x19b
[  966.938259]                                         [<c02ffb2d>] sys_socketcall+0x13f/0x168
[  966.938259]                                         [<c01029c8>] sysenter_do_call+0x12/0x36
[  966.938259]                                         [<ffffffff>] 0xffffffff
[  966.938259]   }
[  966.938259]   ... key      at: [<f87c3190>] __key.37322+0x0/0xffff1031 [mac80211]
[  966.938259]  ... acquired at:
[  966.938259]    [<c0145446>] __lock_acquire+0xfc8/0x12ab
[  966.938259]    [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]    [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]    [<f879cd9a>] __sta_info_unlink+0x97/0x162 [mac80211]
[  966.938259]    [<f879ce8d>] sta_info_unlink+0x28/0x36 [mac80211]
[  966.938259]    [<f87a8712>] ieee80211_del_station+0xa0/0xf0 [mac80211]
[  966.938259]    [<f83ca2a5>] nl80211_del_station+0x71/0x93 [cfg80211]
[  966.938259]    [<c031bf51>] genl_rcv_msg+0x18c/0x1a6
[  966.938259]    [<c031b78e>] netlink_rcv_skb+0x35/0x7b
[  966.938259]    [<c031bdb8>] genl_rcv+0x23/0x30
[  966.938259]    [<c031b30b>] netlink_unicast+0x1a9/0x20a
[  966.938259]    [<c031b58f>] netlink_sendmsg+0x223/0x230
[  966.938259]    [<c02fea7f>] sock_sendmsg+0xcc/0xe2
[  966.938259]    [<c02febe3>] sys_sendmsg+0x14e/0x19b
[  966.938259]    [<c02ffb2d>] sys_socketcall+0x13f/0x168
[  966.938259]    [<c01029c8>] sysenter_do_call+0x12/0x36
[  966.938259]    [<ffffffff>] 0xffffffff
[  966.938259] 
[  966.938259] 
[  966.938259] the SOFTIRQ-irq-unsafe lock's dependencies:
[  966.938259] -> (todo_lock){+.+...} ops: 0 {
[  966.938259]    HARDIRQ-ON-W at:
[  966.938259]                                        [<c0144a1c>] __lock_acquire+0x59e/0x12ab
[  966.938259]                                        [  966.938259]                                        [<c036e955>] _spin_lock+0x2d/0x5d
[<f87ae088>] __ieee80211_key_todo+0x1c5/0x1e9 [mac80211]
[  966.938259]                                        [<f87ae1ab>] ieee80211_key_todo+0x19/0x25 [mac80211]
[  966.938259]                                        [<f87ae238>] ieee80211_todo_for_each_key+0x72/0x79 [mac80211]
[  966.938259]                                        [<f87ae2d6>] ieee80211_enable_keys+0x56/0x5b [mac80211]
[  966.938259]                                        [<f87a631b>] ieee80211_open+0x44e/0x5a3 [mac80211]
[  966.938259]                                        [<c030bced>] dev_open+0x8b/0xc0
[  966.938259]                                        [<c030b73a>] dev_change_flags+0x9b/0x14c
[  966.938259]                                        [<c0312951>] do_setlink+0x2a2/0x348
[  966.938259]                                        [<c0312adc>] rtnl_setlink+0xe5/0xe9
[  966.938259]                                        [<c0313894>] rtnetlink_rcv_msg+0x18a/0x1a0
[  966.938259]                                        [<c031b78e>] netlink_rcv_skb+0x35/0x7b
[  966.938259]                                        [<c0313703>] rtnetlink_rcv+0x20/0x27
[  966.938259]                                        [<c031b30b>] netlink_unicast+0x1a9/0x20a
[  966.938259]                                        [<c031b58f>] netlink_sendmsg+0x223/0x230
[  966.938259]                                        [<c02fea7f>] sock_sendmsg+0xcc/0xe2
[  966.938259]                                        [<c02febe3>] sys_sendmsg+0x14e/0x19b
[  966.938259]                                        [<c02ffb2d>] sys_socketcall+0x13f/0x168
[  966.938259]                                        [<c01029c8>] sysenter_do_call+0x12/0x36
[  966.938259]                                        [<ffffffff>] 0xffffffff
[  966.938259]    SOFTIRQ-ON-W at:
[  966.938259]                                        [<c0144a3b>] __lock_acquire+0x5bd/0x12ab
[  966.938259]                                        [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                        [<f87ae088>] __ieee80211_key_todo+0x1c5/0x1e9 [mac80211]
[  966.938259]                                        [<f87ae1ab>] ieee80211_key_todo+0x19/0x25 [mac80211]
[  966.938259]                                        [<f87ae238>] ieee80211_todo_for_each_key+0x72/0x79 [mac80211]
[  966.938259]                                        [<f87ae2d6>] ieee80211_enable_keys+0x56/0x5b [mac80211]
[  966.938259]                                        [<f87a631b>] ieee80211_open+0x44e/0x5a3 [mac80211]
[  966.938259]                                        [<c030bced>] dev_open+0x8b/0xc0
[  966.938259]                                        [<c030b73a>] dev_change_flags+0x9b/0x14c
[  966.938259]                                        [<c0312951>] do_setlink+0x2a2/0x348
[  966.938259]                                        [<c0312adc>] rtnl_setlink+0xe5/0xe9
[  966.938259]                                        [<c0313894>] rtnetlink_rcv_msg+0x18a/0x1a0
[  966.938259]                                        [<c031b78e>] netlink_rcv_skb+0x35/0x7b
[  966.938259]                                        [<c0313703>] rtnetlink_rcv+0x20/0x27
[  966.938259]                                        [<c031b30b>] netlink_unicast+0x1a9/0x20a
[  966.938259]                                        [<c031b58f>] netlink_sendmsg+0x223/0x230
[  966.938259]                                        [<c02fea7f>] sock_sendmsg+0xcc/0xe2
[  966.938259]                                        [<c02febe3>] sys_sendmsg+0x14e/0x19b
[  966.938259]                                        [<c02ffb2d>] sys_socketcall+0x13f/0x168
[  966.938259]                                        [<c01029c8>] sysenter_do_call+0x12/0x36
[  966.938259]                                        [<ffffffff>] 0xffffffff
[  966.938259]    INITIAL USE at:
[  966.938259]                                       [<c0144a8c>] __lock_acquire+0x60e/0x12ab
[  966.938259]                                       [  966.938259]                                       [<c036e955>] _spin_lock+0x2d/0x5d
[<f87ae088>] __ieee80211_key_todo+0x1c5/0x1e9 [mac80211]
[  966.938259]                                       [<f87ae1ab>] ieee80211_key_todo+0x19/0x25 [mac80211]
[  966.938259]                                       [<f87ae238>] ieee80211_todo_for_each_key+0x72/0x79 [mac80211]
[  966.938259]                                       [<f87ae2d6>] ieee80211_enable_keys+0x56/0x5b [mac80211]
[  966.938259]                                       [<f87a631b>] ieee80211_open+0x44e/0x5a3 [mac80211]
[  966.938259]                                       [<c030bced>] dev_open+0x8b/0xc0
[  966.938259]                                       [<c030b73a>] dev_change_flags+0x9b/0x14c
[  966.938259]                                       [<c0312951>] do_setlink+0x2a2/0x348
[  966.938259]                                       [<c0312adc>] rtnl_setlink+0xe5/0xe9
[  966.938259]                                       [<c0313894>] rtnetlink_rcv_msg+0x18a/0x1a0
[  966.938259]                                       [<c031b78e>] netlink_rcv_skb+0x35/0x7b
[  966.938259]                                       [<c0313703>] rtnetlink_rcv+0x20/0x27
[  966.938259]                                       [<c031b30b>] netlink_unicast+0x1a9/0x20a
[  966.938259]                                       [<c031b58f>] netlink_sendmsg+0x223/0x230
[  966.938259]                                       [<c02fea7f>] sock_sendmsg+0xcc/0xe2
[  966.938259]                                       [<c02febe3>] sys_sendmsg+0x14e/0x19b
[  966.938259]                                       [<c02ffb2d>] sys_socketcall+0x13f/0x168
[  966.938259]                                       [<c01029c8>] sysenter_do_call+0x12/0x36
[<ffffffff>] 0xffffffff
[  966.938259]  }
[  966.938259]  ... key      at: [<f87c2ed4>] todo_lock+0x10/0xffff12fd [mac80211]
[  966.938259]  -> (&cwq->lock){-.-...} ops: 0 {
[  966.938259]     IN-HARDIRQ-W at:
[  966.938259]                                          [<c01449a7>] __lock_acquire+0x529/0x12ab
[  966.938259]                                          [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                          [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]                                          [<c0132ca0>] __queue_work+0x17/0x34
[  966.938259]                                          [<c0132d37>] queue_work_on+0x40/0x49
[  966.938259]                                          [<c0132e5d>] queue_work+0x26/0x4a
[  966.938259]                                          [<c024aede>] __acpi_os_execute+0xe0/0x137
[  966.938259]                                          [<c024af5b>] acpi_os_execute+0xf/0x11
[  966.938259]                                          [<c024e9f7>] acpi_ec_gpe_handler+0x6f/0xa3
[  966.938259]                                          [<c0259bdc>] acpi_ev_gpe_dispatch+0x51/0x10f
[  966.938259]                                          [<c0259d26>] acpi_ev_gpe_detect+0x8c/0xce
[  966.938259]                                          [<c0258085>] acpi_ev_sci_xrupt_handler+0x1a/0x20
[  966.938259]                                          [<c024a73b>] acpi_irq+0x13/0x2e
[  966.938259]                                          [<c0156d7b>] handle_IRQ_event+0x6a/0x12f
[  966.938259]                                          [<c015845a>] handle_fasteoi_irq+0x7e/0xb5
[  966.938259]                                          [<c0104551>] handle_irq+0x40/0x4b
[  966.938259]                                          [<c03724d1>] do_IRQ+0x49/0x89
[  966.938259]                                          [<c010306e>] common_interrupt+0x2e/0x34
[  966.938259]                                          [<c0101c36>] cpu_idle+0x53/0x85
[  966.938259]                                          [<c035eefc>] rest_init+0x6c/0x6e
[  966.938259]                                          [<c0506735>] start_kernel+0x281/0x286
[  966.938259]                                          [<c0506038>] __init_begin+0x38/0x40
[  966.938259]                                          [<ffffffff>] 0xffffffff
[  966.938259]     IN-SOFTIRQ-W at:
[  966.938259]                                          [<c01449c6>] __lock_acquire+0x548/0x12ab
[  966.938259]                                          [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                          [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]                                          [<c0132ca0>] __queue_work+0x17/0x34
[  966.938259]                                          [<c0132d37>] queue_work_on+0x40/0x49
[  966.938259]                                          [<c0132e5d>] queue_work+0x26/0x4a
[  966.938259]                                          [<c0220c35>] kblockd_schedule_work+0x12/0x14
[  966.938259]                                          [<c0229abd>] as_antic_timeout+0x58/0xa4
[  966.938259]                                          [<c012c0b2>] run_timer_softirq+0x177/0x1ec
[  966.938259]                                          [<c0128ada>] irq_exit+0x3d/0x74
[<c0103347>] apic_timer_interrupt+0x2f/0x34
[  966.938259]                                          [  966.938259]                                          [<c0144a8c>] __lock_acquire+0x60e/0x12ab
[  966.938259]                                         [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]                                         [<c0132e5d>] queue_work+0x26/0x4a
[  966.938259]                                         [  966.938259]                                         [  966.938259]                                         [<c0290088>] bus_register+0xe4/0x230
[<c052086e>] driver_init+0x1c/0x28
[  966.938259]                                         [  966.938259]                                         [<ffffffff>] 0xffffffff
 ops: 0[  966.938259]                                            [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                            [  966.938259]                                            [  966.938259]                                            [  966.938259]                                            [<c0259d26>] acpi_ev_gpe_detect+0x8c/0xce
[  966.938259]                                            [<c024a73b>] acpi_irq+0x13/0x2e
[<c0156d7b>] handle_IRQ_event+0x6a/0x12f
[<c015845a>] handle_fasteoi_irq+0x7e/0xb5
[  966.938259]                                            [  966.938259]                                            [<c024f19b>] acpi_ec_space_handler+0x82/0x195
[  966.938259]                                            [<c025bf6f>] acpi_ex_access_region+0x19f/0x1a9
[  966.938259]                                            [<c025fa1e>] acpi_ex_resolve_node_to_value+0x166/0x1dc
[  966.938259]                                            [<c0256465>] acpi_ds_evaluate_name_path+0x71/0xdc
[  966.938259]                                            [<c0264357>] acpi_ps_parse_aml+0x8e/0x288
[  966.938259]                                            [<c0261e4c>] acpi_ns_evaluate+0xcc/0x180
[  966.938259]                                            [  966.938259]                                            [<c0263173>] acpi_ns_walk_namespace+0x9a/0x10b
[  966.938259]                                            [<c025986a>] acpi_install_address_space_handler+0x65/0x7b
[  966.938259]                                            [<c051dc2a>] acpi_ec_ecdt_probe+0x1d9/0x215
[  966.938259]                                            [  966.938259]                                            [<c0103467>] kernel_thread_helper+0x7/0x10
[<ffffffff>] 0xffffffff
[<c01449c6>] __lock_acquire+0x548/0x12ab
[  966.938259]                                            [  966.938259]                                            [<c0159546>] __rcu_process_callbacks+0x17e/0x1ea
[  966.938259]                                            [  966.938259]                                            [<c012895e>] do_softirq+0x30/0x48
[  966.938259]                                            [<c0372584>] smp_apic_timer_interrupt+0x73/0x81
[  966.938259]                                            [  966.938259]                                            [<c0506735>] start_kernel+0x281/0x286
[<c0506038>] __init_begin+0x38/0x40
[  966.938259]                                            [  966.938259]                                               [<c0144a76>] __lock_acquire+0x5f8/0x12ab
[  966.938259]                                               [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[<c0135c9a>] prepare_to_wait+0x1c/0x4c
[  966.938259]                                               [<c01357a7>] kthread+0x4b/0x6f
[  966.938259]                                               [  966.938259]                                           [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                           [<c036bbf9>] wait_for_common+0x2f/0xf7
[<c036bd4c>] wait_for_completion+0x17/0x19
[  966.938259]                                           [<c0514a1e>] migration_init+0x1d/0x4b
[  966.938259]                                           [<c05061e7>] kernel_init+0x4d/0x156
[<ffffffff>] 0xffffffff
 (&rq->lock[  966.938259]       IN-HARDIRQ-W[  966.938259]                                              [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                              [<c0121451>] scheduler_tick+0x36/0x1a5
[  966.938259]                                              [  966.938259]                                              [  966.938259]                                              [<c0156d7b>] handle_IRQ_event+0x6a/0x12f
[  966.938259]                                              [  966.938259]                                              [<c010306e>] common_interrupt+0x2e/0x34
[  966.938259]                                              [  966.938259]                                              [<c0191064>] sget+0x39/0x3b2
[<c01cb6d5>] sysfs_get_sb+0x18/0x1a
[  966.938259]                                              [<c01909d6>] kern_mount_data+0x15/0x17
[  966.938259]                                              [<c0519e60>] vfs_caches_init+0xd9/0xeb
[  966.938259]                                              [  966.938259]                                              [  966.938259]                                              [  966.938259]       IN-SOFTIRQ-W[  966.938259]                                              [<c01449c6>] __lock_acquire+0x548/0x12ab
[  966.938259]                                              [  966.938259]                                              [<c036e955>] _spin_lock+0x2d/0x5d
[  966.938259]                                              [  966.938259]                                              [  966.938259]                                              [<c012c543>] process_timeout+0xd/0xf
[<c012c0b2>] run_timer_softirq+0x177/0x1ec
[  966.938259]                                              [  966.938259]                                              [  966.938259]                                              [  966.938259]                                              [  966.938259]                                              [  966.938259]                                              [<c0101c36>] cpu_idle+0x53/0x85
[  966.938259]                                              [<c0506735>] start_kernel+0x281/0x286
[  966.938259]                                              [  966.938259]                                              [  966.938259]       IN-RECLAIM_FS-W[  966.938259]                                                 [<c0144a76>] __lock_acquire+0x5f8/0x12ab
[  966.938259]                                                 [  966.938259]                                                 [<c036e955>] _spin_lock+0x2d/0x5d
[  966.938259]                                                 [<c01198b7>] task_rq_lock+0x3b/0x65
[<c011fcef>] set_cpus_allowed_ptr+0x1a/0xdc
[<c0176249>] kswapd+0x5e/0x58a
[  966.938259]                                                 [<c01357a7>] kthread+0x4b/0x6f
[  966.938259]                                                 [<ffffffff>] 0xffffffff
[  966.938259]                                             [<c0144a8c>] __lock_acquire+0x60e/0x12ab
[  966.938259]                                             [  966.938259]                                             [  966.938259]                                             [  966.938259]                                             [<c05065a2>] start_kernel+0xee/0x286
[  966.938259]                                             [<ffffffff>] 0xffffffff
[  966.938259]     }
[  966.938259]     ... key      at:  (&vec->lock){..-...} {
 at:
[  966.938259]                                                [  966.938259]                                                [  966.938259]                                                [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]                                                [  966.938259]                                                [<c0121da4>] enqueue_task_rt+0xe5/0x23c
[  966.938259]                                                [<c011f703>] try_to_wake_up+0xcb/0x208
[  966.938259]                                                [  966.938259]                                                [<c011fb4f>] rebalance_domains+0x2d6/0x3b5
[<c011fc62>] run_rebalance_domains+0x34/0xa7
[<c012885e>] __do_softirq+0xb4/0x184
[  966.938259]                                                [  966.938259]                                                [<c03724fd>] do_IRQ+0x75/0x89
[  966.938259]                                                [<c02ed1a2>] cpuidle_idle_call+0x6a/0xa0
[  966.938259]                                                [<c0101c36>] cpu_idle+0x53/0x85
[  966.938259]                                                [  966.938259]                                                [  966.938259]                                                [<c0506038>] __init_begin+0x38/0x40
[<ffffffff>] 0xffffffff
[  966.938259]        INITIAL USE[  966.938259]                                               [  966.938259]                                               [  966.938259]                                               [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[<c016b0cf>] cpupri_set+0xa9/0xf0
[  966.938259]                                               [  966.938259]                                               [<c011d472>] rq_attach_root+0x86/0xa9
[  966.938259]                                               [<c05148ff>] sched_init+0x262/0x364
[  966.938259]                                               [<c05065a2>] start_kernel+0xee/0x286
[  966.938259]                                               [<c0506038>] __init_begin+0x38/0x40
[  966.938259]                                               [<ffffffff>] 0xffffffff
[  966.938259]      }
[  966.938259]      ... key      at: [<c0bfb190>] __key.14459+0x0/0x30
[  966.938259]     ... acquired at:
[  966.938259]    [<c0145446>] __lock_acquire+0xfc8/0x12ab
[  966.938259]    [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]    [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]    [<c016b0cf>] cpupri_set+0xa9/0xf0
[  966.938259]    [<c011bb48>] rq_online_rt+0x5e/0x61
[  966.938259]    [<c0118ffc>] set_rq_online+0x40/0x4a
[  966.938259]    [<c011d472>] rq_attach_root+0x86/0xa9
[  966.938259]    [<c05148ff>] sched_init+0x262/0x364
[  966.938259]    [<c05065a2>] start_kernel+0xee/0x286
[  966.938259]    [<c0506038>] __init_begin+0x38/0x40
[  966.938259]    [<ffffffff>] 0xffffffff
[  966.938259] 
[  966.938259]     -> (&rt_b->rt_runtime_lock){..-...} ops: 0 {
[  966.938259]        IN-SOFTIRQ-W at:
[  966.938259]                                                [<c01449c6>] __lock_acquire+0x548/0x12ab
[  966.938259]                                                [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                                [<c036e955>] _spin_lock+0x2d/0x5d
[  966.938259]                                                [<c0121e26>] enqueue_task_rt+0x167/0x23c
[  966.938259]                                                [<c01183f5>] enqueue_task+0x2c/0x38
[  966.938259]                                                [<c01184cb>] activate_task+0x24/0x2a
[  966.938259]                                                [<c011f703>] try_to_wake_up+0xcb/0x208
[  966.938259]                                                [<c011f877>] wake_up_process+0x14/0x16
[  966.938259]                                                [<c011fb4f>] rebalance_domains+0x2d6/0x3b5
[  966.938259]                                                [<c011fc62>] run_rebalance_domains+0x34/0xa7
[  966.938259]                                                [<c012885e>] __do_softirq+0xb4/0x184
[  966.938259]                                                [<c012895e>] do_softirq+0x30/0x48
[  966.938259]                                                [<c0128ada>] irq_exit+0x3d/0x74
[  966.938259]                                                [<c03724fd>] do_IRQ+0x75/0x89
[  966.938259]                                                [<c010306e>] common_interrupt+0x2e/0x34
[  966.938259]                                                [<c02ed1a2>] cpuidle_idle_call+0x6a/0xa0
[  966.938259]                                                [<c0101c36>] cpu_idle+0x53/0x85
[  966.938259]                                                [  966.938259]                                                [<c0506038>] __init_begin+0x38/0x40
[  966.938259]                                                [  966.938259]                                               [<c036e955>] _spin_lock+0x2d/0x5d
[  966.938259]                                               [  966.938259]                                               [<c01183f5>] enqueue_task+0x2c/0x38
[<c011f703>] try_to_wake_up+0xcb/0x208
[<c011f877>] wake_up_process+0x14/0x16
[<c0369f9a>] migration_call+0xad/0x410
[<c0103467>] kernel_thread_helper+0x7/0x10
[  966.938259]      -> at:
[  966.938259]                                                  [  966.938259]                                                  [  966.938259]                                                  [  966.938259]                                                  [<c012c6b4>] run_local_timers+0xd/0x1e
[  966.938259]                                                  [  966.938259]                                                  [<c037257f>] smp_apic_timer_interrupt+0x6e/0x81
[  966.938259]                                                  [  966.938259]                                                  [  966.938259]                                                  [<c0370dc7>] notifier_call_chain+0x51/0x7e
[  966.938259]                                                  [<c036a3d5>] _cpu_up+0x62/0x105
[  966.938259]                                                  [<c0506233>] kernel_init+0x99/0x156
[  966.938259]                                                  [  966.938259]         IN-SOFTIRQ-W[  966.938259]                                                  [  966.938259]                                                  [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]                                                  [<c01409ae>] tick_setup_sched_timer+0x10b/0x133
[  966.938259]                                                  [<c012bf62>] run_timer_softirq+0x27/0x1ec
[  966.938259]                                                  [  966.938259]                                                  [<c0128ada>] irq_exit+0x3d/0x74
[  966.938259]                                                  [  966.938259]                                                  [<c036953d>] start_secondary+0x1ad/0x1b4
[  966.938259]                                                 [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                                 [  966.938259]                                                 [<c013879f>] __hrtimer_start_range_ns+0x34/0x288
[  966.938259]                                                 [  966.938259]                                                 [<c01184cb>] activate_task+0x24/0x2a
[  966.938259]                                                 [  966.938259]                                                 [<c0369f9a>] migration_call+0xad/0x410
[  966.938259]                                                 [  966.938259]                                                 [  966.938259]                                                 [  966.938259]      ... acquired at:
[  966.938259]    [<c01457d5>] lock_acquire+0xac/0xc9
[<c0121e77>] enqueue_task_rt+0x1b8/0x23c
[  966.938259]    [<c011f877>] wake_up_process+0x14/0x16
[<c0514a3c>] migration_init+0x3b/0x4b
[  966.938259]    [<c0103467>] kernel_thread_helper+0x7/0x10
){-.....}[  966.938259]                                                  [<c01449a7>] __lock_acquire+0x529/0x12ab
[  966.938259]                                                  [  966.938259]                                                  [  966.938259]                                                  [  966.938259]                                                  [<c012c70c>] update_process_times+0x47/0x53
[<c014080b>] tick_sched_timer+0x71/0x9f
[  966.938259]                                                  [<c0138d96>] hrtimer_interrupt+0x106/0x165
[<c0103347>] apic_timer_interrupt+0x2f/0x34
[  966.938259]                                                  [  966.938259]                                                  [  966.938259]         INITIAL USE[  966.938259]                                                 [<c0144a8c>] __lock_acquire+0x60e/0x12ab
[  966.938259]                                                 [  966.938259]                                                 [  966.938259]                                                 [  966.938259]                                                 [  966.938259]                                                 [  966.938259]                                                 [  966.938259]                                                 [  966.938259]                                                 [<c0103467>] kernel_thread_helper+0x7/0x10
[  966.938259]       }
[<c0145446>] __lock_acquire+0xfc8/0x12ab
[  966.938259]    [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]    [<c0119e37>] __enable_runtime+0x34/0x7f
[  966.938259]    [<c011bb2e>] rq_online_rt+0x44/0x61
[<c0118ffc>] set_rq_online+0x40/0x4a
[  966.938259]    [  966.938259]    [  966.938259]    [<c01397c1>] raw_notifier_call_chain+0x11/0x13
[<c036a439>] _cpu_up+0xc6/0x105
[  966.938259]    [<c0103467>] kernel_thread_helper+0x7/0x10
[  966.938259]    [<ffffffff>] 0xffffffff
[  966.938259]     ... acquired at:
[<c0145446>] __lock_acquire+0xfc8/0x12ab
[<c036e955>] _spin_lock+0x2d/0x5d
[<c0121e26>] enqueue_task_rt+0x167/0x23c
[<c01183f5>] enqueue_task+0x2c/0x38
[<c01184cb>] activate_task+0x24/0x2a
[  966.938259]    [<c011f877>] wake_up_process+0x14/0x16
[  966.938259]    [<c0369f9a>] migration_call+0xad/0x410
[  966.938259]    [<c0514a3c>] migration_init+0x3b/0x4b
[<c0101141>] do_one_initcall+0x4f/0x116
[  966.938259]    [<c05061e7>] kernel_init+0x4d/0x156
[  966.938259]    [<c0103467>] kernel_thread_helper+0x7/0x10
[<ffffffff>] 0xffffffff
[  966.938259] 
[<c0145446>] __lock_acquire+0xfc8/0x12ab
[  966.938259]    [<c01457d5>] lock_acquire+0xac/0xc9
[<c036e955>] _spin_lock+0x2d/0x5d
[<c011b5ab>] update_curr_rt+0x123/0x1b0
[  966.938259]    [<c011bd03>] dequeue_task_rt+0x22/0x62
[<c0118499>] dequeue_task+0x98/0xa6
[<c036bec5>] __schedule+0x133/0x7fa
[  966.938259]    [<c036c5a3>] schedule+0x17/0x30
[  966.938259]    [  966.938259]    [<c0103467>] kernel_thread_helper+0x7/0x10
[<ffffffff>] 0xffffffff
[  966.938259] 
 (&rq->lock/1 ops: 0[  966.938259]        IN-SOFTIRQ-W at:
[<c01449c6>] __lock_acquire+0x548/0x12ab
[  966.938259]                                                [<c036e8f8>] _spin_lock_nested+0x34/0x64
[  966.938259]                                                [  966.938259]                                                [<c011fc62>] run_rebalance_domains+0x34/0xa7
[  966.938259]                                                [  966.938259]                                                [<c012895e>] do_softirq+0x30/0x48
[  966.938259]                                                [  966.938259]                                                [  966.938259]                                                [  966.938259]                                                [  966.938259]                                                [<c0506735>] start_kernel+0x281/0x286
[  966.938259]                                                [<c0506038>] __init_begin+0x38/0x40
[  966.938259]                                                [<ffffffff>] 0xffffffff
[  966.938259]                                               [<c0144a8c>] __lock_acquire+0x60e/0x12ab
[  966.938259]                                               [  966.938259]                                               [<c011cb6d>] double_rq_lock+0x4c/0x7f
[  966.938259]                                               [  966.938259]                                               [<c011fc62>] run_rebalance_domains+0x34/0xa7
[  966.938259]                                               [<c012895e>] do_softirq+0x30/0x48
[  966.938259]                                               [  966.938259]                                               [<c0372584>] smp_apic_timer_interrupt+0x73/0x81
[  966.938259]                                               [<c0103347>] apic_timer_interrupt+0x2f/0x34
[  966.938259]                                               [<c0101c36>] cpu_idle+0x53/0x85
[  966.938259]                                               [<c035eefc>] rest_init+0x6c/0x6e
[  966.938259]                                               [<c0506735>] start_kernel+0x281/0x286
[  966.938259]                                               [<c0506038>] __init_begin+0x38/0x40
[  966.938259]                                               [<ffffffff>] 0xffffffff
[  966.938259]      }
[  966.938259]      ... key      at: [<c069d351>] __key.48522+0x1/0x8
[  966.938259]      -> (&sig->cputimer.lock){-.-...} ops: 0 {
[  966.938259]         IN-HARDIRQ-W at:
[  966.938259]                                                  [<c01449a7>] __lock_acquire+0x529/0x12ab
[  966.938259]                                                  [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                                  [<c036e955>] _spin_lock+0x2d/0x5d
[  966.938259]                                                  [<c011a0b4>] account_system_time+0x105/0x157
[  966.938259]                                                  [<c011a16f>] account_process_tick+0x69/0x7e
[  966.938259]                                                  [<c012c6e9>] update_process_times+0x24/0x53
[  966.938259]                                                  [<c014080b>] tick_sched_timer+0x71/0x9f
[  966.938259]                                                  [<c0138274>] __run_hrtimer+0x63/0x98
[  966.938259]                                                  [<c0138d96>] hrtimer_interrupt+0x106/0x165
[  966.938259]                                                  [<c037257f>] smp_apic_timer_interrupt+0x6e/0x81
[  966.938259]                                                  [<c0103347>] apic_timer_interrupt+0x2f/0x34
[  966.938259]                                                  [<c018f447>] do_sync_read+0xb0/0xeb
[  966.938259]                                                  [<c018fe63>] vfs_read+0x8d/0x106
[  966.938259]                                                  [<c018ff98>] sys_read+0x48/0x75
[  966.938259]                                                  [<c01029c8>] sysenter_do_call+0x12/0x36
[  966.938259]                                                  [<ffffffff>] 0xffffffff
[  966.938259]         IN-SOFTIRQ-W at:
[  966.938259]                                                  [<c01449c6>] __lock_acquire+0x548/0x12ab
[  966.938259]                                                  [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                                  [<c036e955>] _spin_lock+0x2d/0x5d
[  966.938259]                                                  [<c0119a09>] update_curr+0x128/0x149
[  966.938259]                                                  [<c011af54>] enqueue_task_fair+0x40/0xd6
[  966.938259]                                                  [<c01183f5>] enqueue_task+0x2c/0x38
[  966.938259]                                                  [<c01184cb>] activate_task+0x24/0x2a
[  966.938259]                                                  [<c011f703>] try_to_wake_up+0xcb/0x208
[  966.938259]                                                  [<c011f850>] default_wake_function+0x10/0x12
[  966.938259]                                                  [<c0135ae0>] autoremove_wake_function+0x14/0x34
[  966.938259]                                                  [<c0135b2f>] wake_bit_function+0x2f/0x3c
[  966.938259]                                                  [<c01185c1>] __wake_up_common+0x39/0x61
[  966.938259]                                                  [<c01197e2>] __wake_up+0x2e/0x40
[  966.938259]                                                  [<c0135a69>] __wake_up_bit+0x2c/0x2f
[<c016c166>] unlock_page+0x4c/0x4f
[  966.938259]                                                  [  966.938259]                                                  [<c022128a>] req_bio_endio+0x89/0xa6
[<c022157c>] end_that_request_data+0x19/0x48
[  966.938259]                                                  [  966.938259]                                                  [<c02a3aaf>] scsi_io_completion+0x1c9/0x434
[  966.938259]                                                  [  966.938259]                                                  [<c0225e5f>] blk_done_softirq+0x63/0x70
[  966.938259]                                                  [  966.938259]                                                  [<c0128ada>] irq_exit+0x3d/0x74
[<c010306e>] common_interrupt+0x2e/0x34
[  966.938259]                                                  [  966.938259]                                                  [<c01983a3>] do_path_lookup+0xe9/0x103
[  966.938259]                                                  [  966.938259]                                                  [  966.938259]                                                  [<ffffffff>] 0xffffffff
[  966.938259]                                                 [  966.938259]                                                 [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]                                                 [<c0137abe>] posix_cpu_timers_exit_group+0x16/0x39
[  966.938259]                                                 [  966.938259]                                                 [  966.938259]                                                 [<c0103467>] kernel_thread_helper+0x7/0x10
[  966.938259]       ... key      at: [  966.938259]    [<c036e955>] _spin_lock+0x2d/0x5d
[<c011a9a9>] dequeue_task_fair+0x40/0x185
[<c011ecce>] pull_task+0x16/0x42
[<c011fa39>] rebalance_domains+0x1c0/0x3b5
[<c011fc62>] run_rebalance_domains+0x34/0xa7
[<c012895e>] do_softirq+0x30/0x48
[<c010306e>] common_interrupt+0x2e/0x34
[<c0145446>] __lock_acquire+0xfc8/0x12ab
[  966.938259]    [  966.938259]    [<c011fc62>] run_rebalance_domains+0x34/0xa7
[<c012895e>] do_softirq+0x30/0x48
[  966.938259]    [<c0101c36>] cpu_idle+0x53/0x85
[  966.938259]    [  966.938259]     ... acquired at:
[  966.938259]    [  966.938259]    [  966.938259]    [  966.938259]    [  966.938259]    [<c016bfa6>] __lock_page_killable+0x74/0x7b
[<c016dcb5>] generic_file_aio_read+0x390/0x54f
[<c018f447>] do_sync_read+0xb0/0xeb
[<c018ff98>] sys_read+0x48/0x75
[  966.938259] 
[<c0145446>] __lock_acquire+0xfc8/0x12ab
[<c01198b7>] task_rq_lock+0x3b/0x65
[  966.938259]    [<c01185c1>] __wake_up_common+0x39/0x61
[<c0119745>] complete+0x30/0x43
[<c0135735>] kthreadd+0xc1/0xe8
[<c0103467>] kernel_thread_helper+0x7/0x10
[<ffffffff>] 0xffffffff
[  966.938259]    -> {
 at:
[<c0144a8c>] __lock_acquire+0x60e/0x12ab
[  966.938259]                                             [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[<c01b4fe7>] sys_epoll_ctl+0x241/0x41e
[  966.938259]                                             [<ffffffff>] 0xffffffff
[  966.938259]     ... key      at: [<c0c03720>] __key.22648+0x0/0x8
[  966.938259]     ... acquired at:
[  966.938259]    [<c0145446>] __lock_acquire+0xfc8/0x12ab
[<c01457d5>] lock_acquire+0xac/0xc9
[<c036e955>] _spin_lock+0x2d/0x5d
[<c01198b7>] task_rq_lock+0x3b/0x65
[<c011f669>] try_to_wake_up+0x31/0x208
[<c011f850>] default_wake_function+0x10/0x12
[<c01185c1>] __wake_up_common+0x39/0x61
[  966.938259]    [<c01185ff>] __wake_up_locked+0x16/0x1a
[<c01b4d6f>] ep_poll_callback+0x81/0xb8
[  966.938259]    [<c01185c1>] __wake_up_common+0x39/0x61
[<c0119790>] __wake_up_sync_key+0x38/0x4a
[  966.938259]    [<f8045944>] unix_stream_connect+0x317/0x387 [unix]
[  966.938259]    [<c02fe546>] sys_connect+0x59/0x76
[  966.938259]    [<c02ffa64>] sys_socketcall+0x76/0x168
[  966.938259]    [<ffffffff>] 0xffffffff
[  966.938259] 
[<c0145446>] __lock_acquire+0xfc8/0x12ab
[  966.938259]    [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]    [<c01b4d06>] ep_poll_callback+0x18/0xb8
[  966.938259]    [<c0119790>] __wake_up_sync_key+0x38/0x4a
[<c0300c03>] sock_def_readable+0x3f/0x6d
[<f8045944>] unix_stream_connect+0x317/0x387 [unix]
[  966.938259]    [<c02fe546>] sys_connect+0x59/0x76
[  966.938259]    [<c02ffa64>] sys_socketcall+0x76/0x168
[  966.938259]    [<c01029c8>] sysenter_do_call+0x12/0x36
[<ffffffff>] 0xffffffff
[  966.938259] 
[  966.938259]   ... acquired at:
[<c0145446>] __lock_acquire+0xfc8/0x12ab
[<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]    [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]    [<c01197ce>] __wake_up+0x1a/0x40
[<c013249b>] insert_work+0x9a/0xa3
[<c0132caf>] __queue_work+0x26/0x34
[  966.938259]    [<c0132d37>] queue_work_on+0x40/0x49
[  966.938259]    [<c0131dd2>] call_usermodehelper_exec+0x8a/0xdc
[<c022f627>] kobject_uevent_env+0x333/0x368
[<c022f666>] kobject_uevent+0xa/0xc
[<c022ede0>] kset_register+0x2e/0x34
[<c0290088>] bus_register+0xe4/0x230
[<c052086e>] driver_init+0x1c/0x28
[<c050628c>] kernel_init+0xf2/0x156
[<c0103467>] kernel_thread_helper+0x7/0x10
[<ffffffff>] 0xffffffff
[  966.938259]  ... acquired at:
[  966.938259]    [<c0145446>] __lock_acquire+0xfc8/0x12ab
[<c01457d5>] lock_acquire+0xac/0xc9
[<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]    [  966.938259]    [<c0132d37>] queue_work_on+0x40/0x49
[<c0132e95>] schedule_work+0x14/0x16
[<f87adb87>] add_todo+0x4a/0x58 [mac80211]
[  966.938259]    [<f87ae3f5>] ieee80211_key_link+0x11a/0x138 [mac80211]
[  966.938259]    [<f87a8df1>] ieee80211_add_key+0xca/0x104 [mac80211]
[  966.938259]    [<f83cd705>] nl80211_new_key+0xfe/0x12a [cfg80211]
[  966.938259]    [<c031bf51>] genl_rcv_msg+0x18c/0x1a6
[  966.938259]    [<c031b78e>] netlink_rcv_skb+0x35/0x7b
[  966.938259]    [<c031bdb8>] genl_rcv+0x23/0x30
[  966.938259]    [<c031b30b>] netlink_unicast+0x1a9/0x20a
[  966.938259]    [<c031b58f>] netlink_sendmsg+0x223/0x230
[  966.938259]    [<c02fea7f>] sock_sendmsg+0xcc/0xe2
[  966.938259]    [<c02febe3>] sys_sendmsg+0x14e/0x19b
[  966.938259]    [<c02ffb2d>] sys_socketcall+0x13f/0x168
[  966.938259]    [<c01029c8>] sysenter_do_call+0x12/0x36
[  966.938259]    [<ffffffff>] 0xffffffff
[  966.938259] 
[  966.938259] 
[  966.938259] stack backtrace:
[  966.938259] Pid: 2889, comm: wpa_supplicant Not tainted 2.6.30-wl #136
[  966.938259] Call Trace:
[  966.938259]  [<c036bac6>] ? printk+0x14/0x16
[  966.938259]  [<c01443c1>] check_usage+0x2fe/0x30f
[  966.938259]  [<c0144422>] check_irq_usage+0x50/0xac
[  966.938259]  [<c01451cf>] __lock_acquire+0xd51/0x12ab
[  966.938259]  [<f87ae0ed>] ? ieee80211_key_free+0x41/0x60 [mac80211]
[  966.938259]  [<f87ae0ed>] ? ieee80211_key_free+0x41/0x60 [mac80211]
[  966.938259]  [<c01457d5>] lock_acquire+0xac/0xc9
[  966.938259]  [<f87ae0ed>] ? ieee80211_key_free+0x41/0x60 [mac80211]
[  966.938259]  [<c036ea80>] _spin_lock_irqsave+0x36/0x69
[  966.938259]  [<f87ae0ed>] ? ieee80211_key_free+0x41/0x60 [mac80211]
[  966.938259]  [<f87ae0ed>] ieee80211_key_free+0x41/0x60 [mac80211]
[  966.938259]  [<f879cd6c>] __sta_info_unlink+0x69/0x162 [mac80211]
[  966.938259]  [<c036eaa9>] ? _spin_lock_irqsave+0x5f/0x69
[  966.938259]  [<f879d4ce>] sta_info_flush+0x6a/0xbc [mac80211]
[  966.938259]  [<f87a5b50>] ieee80211_stop+0xe3/0x460 [mac80211]
[  966.938259]  [<c036e70c>] ? _spin_unlock_bh+0x34/0x37
[  966.938259]  [<c030ba2f>] dev_close+0x72/0x8e
[  966.938259]  [<c030b73a>] dev_change_flags+0x9b/0x14c
[  966.938259]  [<c0349492>] devinet_ioctl+0x214/0x4f3
[  966.938259]  [<c034a737>] inet_ioctl+0x93/0xac
[  966.938259]  [<c02fe2c7>] sock_ioctl+0x1ce/0x1f2
[  966.938259]  [<c02fe0f9>] ? sock_ioctl+0x0/0x1f2
[  966.938259]  [<c019a132>] vfs_ioctl+0x1d/0x76
[  966.938259]  [<c0142336>] ? lock_release_holdtime+0xf5/0xfa
[  966.938259]  [<c019a604>] do_vfs_ioctl+0x479/0x4b3
[  966.938259]  [<c017be80>] ? might_fault+0x50/0x8d
[  966.938259]  [<c017be80>] ? might_fault+0x50/0x8d
[  966.938259]  [<c02339d4>] ? trace_hardirqs_on_thunk+0xc/0x10
[  966.938259]  [<c019a671>] sys_ioctl+0x33/0x4d
[  966.938259]  [<c01029c8>] sysenter_do_call+0x12/0x36
[  966.938259] phy0: Removed STA 00:18:41:c8:58:43
[  967.027386] phy0: Destroyed STA 00:18:41:c8:58:43
[  979.976463] wlan0: authenticate with AP 00:1a:70:da:a9:cd
[  979.978033] wlan0: authenticated
[  979.978049] wlan0: associate with AP 00:1a:70:da:a9:cd
[  979.980300] wlan0: RX AssocResp from 00:1a:70:da:a9:cd (capab=0x411 status=0 aid=3)
[  979.980316] wlan0: associated
[  979.980343] phy0: Allocated STA 00:1a:70:da:a9:cd
[  979.981246] phy0: Inserted STA 00:1a:70:da:a9:cd
[  979.981792] wlan0: switched to short slot time (BSSID=00:1a:70:da:a9:cd)

-- 
Bob Copeland %% www.bobcopeland.com

