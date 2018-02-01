Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40840 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755850AbeBAAxJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 19:53:09 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 8A12640A7E2
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 16:53:06 -0800 (PST)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: lockdep warning in mac80211/tx.c, 4.13.16+ kernel, ath9k related
Message-ID: <d4632910-7dd9-b066-0c10-b21dd7cbfc61@candelatech.com> (sfid-20180201_015312_997297_FC3C85E1)
Date: Wed, 31 Jan 2018 16:53:06 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

This first splat comes from this code:

static ieee80211_tx_result debug_noinline
ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
{
	struct ieee80211_key *key;
	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;

	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT))
		tx->key = NULL;
	else if (tx->sta &&
### line 605 ###		 (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
		tx->key = key;
	else if (ieee80211_is_group_privacy_action(tx->skb) &&
		(key = rcu_dereference(tx->sdata->default_multicast_key)))
		tx->key = key;
	else if (ieee80211_is_mgmt(hdr->frame_control) &&
		 is_multicast_ether_addr(hdr->addr1) &&
		 ieee80211_is_robust_mgmt_frame(tx->skb) &&
		 (key = rcu_dereference(tx->sdata->default_mgmt_key)))
		tx->key = key;
	else if (is_multicast_ether_addr(hdr->addr1) &&
		 (key = rcu_dereference(tx->sdata->default_multicast_key)))
		tx->key = key;
	else if (!is_multicast_ether_addr(hdr->addr1) &&
### line 619 ###		 (key = rcu_dereference(tx->sdata->default_unicast_key)))
		tx->key = key;
	else
		tx->key = NULL;

This ath9k has some local modifications, including removal of the airtime fairness logic
that was breaking my test case very quickly, so could be my fault of course.

Full tree is here:

https://github.com/greearb/linux-ct-4.13


Any idea why this might be complaining?

Test case is to bring up 200 virtual stations on each of 6 radios and then randomly
restart the stations and/or APs they are connected to.  I'm trying to shake out
stability bugs and such...


  30917 Jan 31 15:21:01 2u-6n kernel: =============================
  30918 Jan 31 15:21:01 2u-6n kernel: WARNING: suspicious RCU usage
  30919 Jan 31 15:21:01 2u-6n kernel: 4.13.16+ #2 Tainted: G        W  O
  30920 Jan 31 15:21:01 2u-6n kernel: -----------------------------
  30921 Jan 31 15:21:01 2u-6n kernel: /home/greearb/git/linux-4.13.dev.y/net/mac80211/tx.c:605 suspicious rcu_dereference_check() usage!
  30922 Jan 31 15:21:01 2u-6n kernel:
  30923                               other info that might help us debug this:
  30924 Jan 31 15:21:01 2u-6n kernel:
  30925                               rcu_scheduler_active = 2, debug_locks = 1
  30926 Jan 31 15:21:01 2u-6n kernel: 5 locks held by ip/19628:
  30927 Jan 31 15:21:01 2u-6n kernel:  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff818a40f6>] rtnetlink_rcv+0x16/0x30
  30928 Jan 31 15:21:01 2u-6n kernel:  #1:  (&wdev->mtx){+.+.+.}, at: [<ffffffffa04b0e4d>] cfg80211_leave+0x1d/0x40 [cfg80211]
  30929 Jan 31 15:21:01 2u-6n kernel:  #2:  (&local->sta_mtx){+.+.+.}, at: [<ffffffffa093999c>] __sta_info_flush+0x7c/0x170 [mac80211]
  30930 Jan 31 15:21:01 2u-6n kernel:  #3:  (&(&txq->axq_lock)->rlock){+.-...}, at: [<ffffffffa0485db6>] ath_tx_node_cleanup+0x66/0x160 [ath9k]
  30931 Jan 31 15:21:01 2u-6n kernel:  #4:  (&(&fq->lock)->rlock){+.-...}, at: [<ffffffffa096f865>] ieee80211_tx_dequeue+0x45/0xca0 [mac80211]
  30932 Jan 31 15:21:01 2u-6n kernel:
  30933                               stack backtrace:
  30934 Jan 31 15:21:01 2u-6n kernel: CPU: 1 PID: 19628 Comm: ip Tainted: G        W  O    4.13.16+ #2
  30935 Jan 31 15:21:01 2u-6n kernel: Hardware name: Iron_Systems,Inc CS-CAD-2U-A02/X10SRL-F, BIOS 2.0b 05/02/2017
  30936 Jan 31 15:21:01 2u-6n kernel: Call Trace:
  30937 Jan 31 15:21:01 2u-6n kernel:  dump_stack+0x85/0xc7
  30938 Jan 31 15:21:01 2u-6n kernel:  lockdep_rcu_suspicious+0xc5/0x100
  30939 Jan 31 15:21:01 2u-6n kernel:  ieee80211_tx_h_select_key+0x1c9/0x4e0 [mac80211]
  30940 Jan 31 15:21:01 2u-6n kernel:  ieee80211_tx_dequeue+0x376/0xca0 [mac80211]
  30941 Jan 31 15:21:01 2u-6n kernel:  ath_tid_dequeue+0x9c/0x110 [ath9k]
  30942 Jan 31 15:21:01 2u-6n kernel:  ath_tx_node_cleanup+0xa4/0x160 [ath9k]
  30943 Jan 31 15:21:01 2u-6n kernel:  ath9k_sta_state+0x6b/0x1e0 [ath9k]
  30944 Jan 31 15:21:01 2u-6n kernel:  drv_sta_state+0xad/0xa80 [mac80211]
  30945 Jan 31 15:21:01 2u-6n kernel:  __sta_info_destroy_part2+0x178/0x1d0 [mac80211]
  30946 Jan 31 15:21:01 2u-6n kernel:  __sta_info_flush+0xef/0x170 [mac80211]
  30947 Jan 31 15:21:01 2u-6n kernel:  ieee80211_set_disassoc+0xc6/0x400 [mac80211]
  30948 Jan 31 15:21:01 2u-6n kernel:  ieee80211_mgd_deauth+0x2f6/0x830 [mac80211]
  30949 Jan 31 15:21:01 2u-6n kernel:  ieee80211_deauth+0x13/0x20 [mac80211]
  30950 Jan 31 15:21:01 2u-6n kernel:  cfg80211_mlme_deauth+0x16b/0x3e0 [cfg80211]
  30951 Jan 31 15:21:01 2u-6n kernel:  cfg80211_mlme_down+0x6d/0xa0 [cfg80211]
  30952 Jan 31 15:21:01 2u-6n kernel:  cfg80211_disconnect+0x2f4/0x3f0 [cfg80211]
  30953 Jan 31 15:21:01 2u-6n kernel:  ? kfree+0x24d/0x2b0
  30954 Jan 31 15:21:01 2u-6n kernel:  __cfg80211_leave+0x134/0x190 [cfg80211]
  30955 Jan 31 15:21:01 2u-6n kernel:  cfg80211_leave+0x28/0x40 [cfg80211]
  30956 Jan 31 15:21:01 2u-6n kernel:  cfg80211_netdev_notifier_call+0x49c/0x820 [cfg80211]
  30957 Jan 31 15:21:01 2u-6n kernel:  ? lockdep_rtnl_is_held+0x15/0x20
  30958 Jan 31 15:21:01 2u-6n kernel:  ? addrconf_notify+0x6b/0xcc0 [ipv6]
  30959 Jan 31 15:21:01 2u-6n kernel:  ? packet_notifier+0xee/0x2a0
  30960 Jan 31 15:21:01 2u-6n kernel:  notifier_call_chain+0x45/0x70
  30961 Jan 31 15:21:01 2u-6n kernel:  raw_notifier_call_chain+0x11/0x20
  30962 Jan 31 15:21:01 2u-6n kernel:  call_netdevice_notifiers_info+0x30/0x60
  30963 Jan 31 15:21:01 2u-6n kernel:  __dev_close_many+0x54/0xe0
  30964 Jan 31 15:21:01 2u-6n kernel:  __dev_close+0x31/0x50
  30965 Jan 31 15:21:01 2u-6n kernel:  __dev_change_flags+0x98/0x160
  30966 Jan 31 15:21:01 2u-6n kernel:  dev_change_flags+0x24/0x60
  30967 Jan 31 15:21:01 2u-6n kernel:  do_setlink+0x367/0xcd0
  30968 Jan 31 15:21:01 2u-6n kernel:  ? mark_held_locks+0x6f/0xa0
  30969 Jan 31 15:21:01 2u-6n kernel:  ? get_page_from_freelist+0x1fd/0xc10
  30970 Jan 31 15:21:01 2u-6n kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
  30971 Jan 31 15:21:01 2u-6n kernel:  ? nla_parse+0x36/0x150
  30972 Jan 31 15:21:01 2u-6n kernel:  rtnl_newlink+0x776/0x8e0
  30973 Jan 31 15:21:01 2u-6n kernel:  ? __wake_up+0x1e/0x50
30974 Jan 31 15:21:01 2u-6n kernel:  ? ns_capable_common+0x75/0x90
  30975 Jan 31 15:21:01 2u-6n kernel:  ? ns_capable+0xe/0x10
  30976 Jan 31 15:21:01 2u-6n kernel:  rtnetlink_rcv_msg+0x85/0x1f0
  30977 Jan 31 15:21:01 2u-6n kernel:  ? lock_acquire+0xac/0x200
  30978 Jan 31 15:21:01 2u-6n kernel:  ? rtnl_newlink+0x8e0/0x8e0
  30979 Jan 31 15:21:01 2u-6n kernel:  netlink_rcv_skb+0xe2/0x110
  30980 Jan 31 15:21:01 2u-6n kernel:  rtnetlink_rcv+0x25/0x30
  30981 Jan 31 15:21:01 2u-6n kernel:  netlink_unicast+0x1cb/0x2e0
  30982 Jan 31 15:21:01 2u-6n kernel:  netlink_sendmsg+0x2c6/0x3a0
  30983 Jan 31 15:21:01 2u-6n kernel:  sock_sendmsg+0x33/0x40
  30984 Jan 31 15:21:01 2u-6n kernel:  ___sys_sendmsg+0x2f3/0x300
  30985 Jan 31 15:21:01 2u-6n kernel:  ? lock_acquire+0xac/0x200
  30986 Jan 31 15:21:01 2u-6n kernel:  ? __handle_mm_fault+0x5e8/0xfb0
  30987 Jan 31 15:21:01 2u-6n kernel:  ? getnstimeofday64+0x9/0x20
  30988 Jan 31 15:21:01 2u-6n kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
  30989 Jan 31 15:21:01 2u-6n kernel:  __sys_sendmsg+0x40/0x70
  30990 Jan 31 15:21:01 2u-6n kernel:  ? __sys_sendmsg+0x40/0x70
  30991 Jan 31 15:21:01 2u-6n kernel:  SyS_sendmsg+0xd/0x20
  30992 Jan 31 15:21:01 2u-6n kernel:  do_syscall_64+0x64/0x140
  30993 Jan 31 15:21:01 2u-6n kernel:  entry_SYSCALL64_slow_path+0x25/0x25
  30994 Jan 31 15:21:01 2u-6n kernel: RIP: 0033:0x7f1e8363a150
  30995 Jan 31 15:21:01 2u-6n kernel: RSP: 002b:00007ffee8bb8bf8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
  30996 Jan 31 15:21:01 2u-6n kernel: RAX: ffffffffffffffda RBX: 000000005a724f5d RCX: 00007f1e8363a150
  30997 Jan 31 15:21:01 2u-6n kernel: RDX: 0000000000000000 RSI: 00007ffee8bb8c70 RDI: 0000000000000004
  30998 Jan 31 15:21:01 2u-6n kernel: RBP: 00007ffee8bb8c70 R08: 0000000000000001 R09: 0000000000000000
  30999 Jan 31 15:21:01 2u-6n kernel: R10: 00000000000005e7 R11: 0000000000000246 R12: 00007ffee8bb8cb0
  31000 Jan 31 15:21:01 2u-6n kernel: R13: 000000000066b460 R14: 00007ffee8bc0d20 R15: 0000000000000000
  31001 Jan 31 15:21:01 2u-6n kernel:
  31002 Jan 31 15:21:01 2u-6n kernel: =============================
  31003 Jan 31 15:21:01 2u-6n kernel: WARNING: suspicious RCU usage
  31004 Jan 31 15:21:01 2u-6n kernel: 4.13.16+ #2 Tainted: G        W  O
  31005 Jan 31 15:21:01 2u-6n kernel: -----------------------------
  31006 Jan 31 15:21:01 2u-6n kernel: /home/greearb/git/linux-4.13.dev.y/net/mac80211/tx.c:619 suspicious rcu_dereference_check() usage!
  31007 Jan 31 15:21:01 2u-6n kernel:
  31008                               other info that might help us debug this:
  31009 Jan 31 15:21:01 2u-6n kernel:
  31010                               rcu_scheduler_active = 2, debug_locks = 1
  31011 Jan 31 15:21:01 2u-6n kernel: 5 locks held by ip/19628:
  31012 Jan 31 15:21:01 2u-6n kernel:  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff818a40f6>] rtnetlink_rcv+0x16/0x30
  31013 Jan 31 15:21:01 2u-6n kernel:  #1:  (&wdev->mtx){+.+.+.}, at: [<ffffffffa04b0e4d>] cfg80211_leave+0x1d/0x40 [cfg80211]
  31014 Jan 31 15:21:01 2u-6n kernel:  #2:  (&local->sta_mtx){+.+.+.}, at: [<ffffffffa093999c>] __sta_info_flush+0x7c/0x170 [mac80211]
  31015 Jan 31 15:21:01 2u-6n kernel:  #3:  (&(&txq->axq_lock)->rlock){+.-...}, at: [<ffffffffa0485db6>] ath_tx_node_cleanup+0x66/0x160 [ath9k]
  31016 Jan 31 15:21:01 2u-6n kernel:  #4:  (&(&fq->lock)->rlock){+.-...}, at: [<ffffffffa096f865>] ieee80211_tx_dequeue+0x45/0xca0 [mac80211]
  31017 Jan 31 15:21:01 2u-6n kernel:
  31018                               stack backtrace:
  31019 Jan 31 15:21:01 2u-6n kernel: CPU: 1 PID: 19628 Comm: ip Tainted: G        W  O    4.13.16+ #2
  31020 Jan 31 15:21:01 2u-6n kernel: Hardware name: Iron_Systems,Inc CS-CAD-2U-A02/X10SRL-F, BIOS 2.0b 05/02/2017
  31021 Jan 31 15:21:01 2u-6n kernel: Call Trace:
  31022 Jan 31 15:21:01 2u-6n kernel:  dump_stack+0x85/0xc7
  31023 Jan 31 15:21:01 2u-6n kernel:  lockdep_rcu_suspicious+0xc5/0x100
  31024 Jan 31 15:21:01 2u-6n kernel:  ieee80211_tx_h_select_key+0x431/0x4e0 [mac80211]
  31025 Jan 31 15:21:01 2u-6n kernel:  ieee80211_tx_dequeue+0x376/0xca0 [mac80211]
  31026 Jan 31 15:21:01 2u-6n kernel:  ath_tid_dequeue+0x9c/0x110 [ath9k]
  31027 Jan 31 15:21:01 2u-6n kernel:  ath_tx_node_cleanup+0xa4/0x160 [ath9k]
  31028 Jan 31 15:21:01 2u-6n kernel:  ath9k_sta_state+0x6b/0x1e0 [ath9k]
  31029 Jan 31 15:21:01 2u-6n kernel:  drv_sta_state+0xad/0xa80 [mac80211]
  31030 Jan 31 15:21:01 2u-6n kernel:  __sta_info_destroy_part2+0x178/0x1d0 [mac80211]
31031 Jan 31 15:21:01 2u-6n kernel:  __sta_info_flush+0xef/0x170 [mac80211]
  31032 Jan 31 15:21:01 2u-6n kernel:  ieee80211_set_disassoc+0xc6/0x400 [mac80211]
  31033 Jan 31 15:21:01 2u-6n kernel:  ieee80211_mgd_deauth+0x2f6/0x830 [mac80211]
  31034 Jan 31 15:21:01 2u-6n kernel:  ieee80211_deauth+0x13/0x20 [mac80211]
  31035 Jan 31 15:21:01 2u-6n kernel:  cfg80211_mlme_deauth+0x16b/0x3e0 [cfg80211]
  31036 Jan 31 15:21:01 2u-6n kernel:  cfg80211_mlme_down+0x6d/0xa0 [cfg80211]
  31037 Jan 31 15:21:01 2u-6n kernel:  cfg80211_disconnect+0x2f4/0x3f0 [cfg80211]
  31038 Jan 31 15:21:01 2u-6n kernel:  ? kfree+0x24d/0x2b0
  31039 Jan 31 15:21:01 2u-6n kernel:  __cfg80211_leave+0x134/0x190 [cfg80211]
  31040 Jan 31 15:21:01 2u-6n kernel:  cfg80211_leave+0x28/0x40 [cfg80211]
  31041 Jan 31 15:21:01 2u-6n kernel:  cfg80211_netdev_notifier_call+0x49c/0x820 [cfg80211]
  31042 Jan 31 15:21:01 2u-6n kernel:  ? lockdep_rtnl_is_held+0x15/0x20
  31043 Jan 31 15:21:01 2u-6n kernel:  ? addrconf_notify+0x6b/0xcc0 [ipv6]
  31044 Jan 31 15:21:01 2u-6n kernel:  ? packet_notifier+0xee/0x2a0
  31045 Jan 31 15:21:01 2u-6n kernel:  notifier_call_chain+0x45/0x70
  31046 Jan 31 15:21:01 2u-6n kernel:  raw_notifier_call_chain+0x11/0x20
  31047 Jan 31 15:21:01 2u-6n kernel:  call_netdevice_notifiers_info+0x30/0x60
  31048 Jan 31 15:21:01 2u-6n kernel:  __dev_close_many+0x54/0xe0
  31049 Jan 31 15:21:01 2u-6n kernel:  __dev_close+0x31/0x50
  31050 Jan 31 15:21:01 2u-6n kernel:  __dev_change_flags+0x98/0x160
  31051 Jan 31 15:21:01 2u-6n kernel:  dev_change_flags+0x24/0x60
  31052 Jan 31 15:21:01 2u-6n kernel:  do_setlink+0x367/0xcd0
  31053 Jan 31 15:21:01 2u-6n kernel:  ? mark_held_locks+0x6f/0xa0
  31054 Jan 31 15:21:01 2u-6n kernel:  ? get_page_from_freelist+0x1fd/0xc10
  31055 Jan 31 15:21:01 2u-6n kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
  31056 Jan 31 15:21:01 2u-6n kernel:  ? nla_parse+0x36/0x150
  31057 Jan 31 15:21:01 2u-6n kernel:  rtnl_newlink+0x776/0x8e0
  31058 Jan 31 15:21:01 2u-6n kernel:  ? __wake_up+0x1e/0x50
  31059 Jan 31 15:21:01 2u-6n kernel:  ? ns_capable_common+0x75/0x90
  31060 Jan 31 15:21:01 2u-6n kernel:  ? ns_capable+0xe/0x10
  31061 Jan 31 15:21:01 2u-6n kernel:  rtnetlink_rcv_msg+0x85/0x1f0
  31062 Jan 31 15:21:01 2u-6n kernel:  ? lock_acquire+0xac/0x200
  31063 Jan 31 15:21:01 2u-6n kernel:  ? rtnl_newlink+0x8e0/0x8e0
  31064 Jan 31 15:21:01 2u-6n kernel:  netlink_rcv_skb+0xe2/0x110
  31065 Jan 31 15:21:01 2u-6n kernel:  rtnetlink_rcv+0x25/0x30
  31066 Jan 31 15:21:01 2u-6n kernel:  netlink_unicast+0x1cb/0x2e0
  31067 Jan 31 15:21:01 2u-6n kernel:  netlink_sendmsg+0x2c6/0x3a0
  31068 Jan 31 15:21:01 2u-6n kernel:  sock_sendmsg+0x33/0x40
  31069 Jan 31 15:21:01 2u-6n kernel:  ___sys_sendmsg+0x2f3/0x300
  31070 Jan 31 15:21:01 2u-6n kernel:  ? lock_acquire+0xac/0x200
  31071 Jan 31 15:21:01 2u-6n kernel:  ? __handle_mm_fault+0x5e8/0xfb0
  31072 Jan 31 15:21:01 2u-6n kernel:  ? getnstimeofday64+0x9/0x20
  31073 Jan 31 15:21:01 2u-6n kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
  31074 Jan 31 15:21:01 2u-6n kernel:  __sys_sendmsg+0x40/0x70
  31075 Jan 31 15:21:01 2u-6n kernel:  ? __sys_sendmsg+0x40/0x70
  31076 Jan 31 15:21:01 2u-6n kernel:  SyS_sendmsg+0xd/0x20
  31077 Jan 31 15:21:01 2u-6n kernel:  do_syscall_64+0x64/0x140
  31078 Jan 31 15:21:01 2u-6n kernel:  entry_SYSCALL64_slow_path+0x25/0x25
  31079 Jan 31 15:21:01 2u-6n kernel: RIP: 0033:0x7f1e8363a150
  31080 Jan 31 15:21:01 2u-6n kernel: RSP: 002b:00007ffee8bb8bf8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
  31081 Jan 31 15:21:01 2u-6n kernel: RAX: ffffffffffffffda RBX: 000000005a724f5d RCX: 00007f1e8363a150
  31082 Jan 31 15:21:01 2u-6n kernel: RDX: 0000000000000000 RSI: 00007ffee8bb8c70 RDI: 0000000000000004
  31083 Jan 31 15:21:01 2u-6n kernel: RBP: 00007ffee8bb8c70 R08: 0000000000000001 R09: 0000000000000000
  31084 Jan 31 15:21:01 2u-6n kernel: R10: 00000000000005e7 R11: 0000000000000246 R12: 00007ffee8bb8cb0
  31085 Jan 31 15:21:01 2u-6n kernel: R13: 000000000066b460 R14: 00007ffee8bc0d20 R15: 0000000000000000


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
