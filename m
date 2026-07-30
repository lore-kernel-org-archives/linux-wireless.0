Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47D31F942
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 05:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389967; cv=none; b=TZz4zIPYLgXDYYDoQZ7J+xQs8U80ZkTNPYYBdZenLqDWvVOi0PoIDaIMJZmXAn0+vpYgFRMk1ssRP4zLgCQdWjEdrExQDUNGwshzb7f3m+gAfHQknZuyra+Qk+KF6Uf+Z8XSjjmHCXhR1/6vMyZhcUUo2wVnVDZL6Zj8s4aZiV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389967; c=relaxed/simple;
	bh=arTmvc1AWtArNwmO8Mwc6L3gmtynEx4pXWGIwJtZteU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HHlvKmdy/MZuvs1TAjRWPQWr/u24UuqMzMgBDULTcteA/CZK99IevcRjYo4asin6UcuFyU4l2R2PlYHKVvW5F7SxhX5hTP8c8VM3cA8eFkZnK7aOGdouhG2zIqCiHXiR4Wb22XQlJNz2m1f2j8u8T8+7V42kg83J3uVqS4e3dSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=UzfYPhsj; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="UzfYPhsj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1785389962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VUWU4sqbFaCi839wcnM6muA/lectB4AWOd0dN2TTZqM=;
	b=UzfYPhsjTItCqJu7EGfGzsLPYqT4R5mHFSYT6Z2LGU40GYRogRZnYUBm4m6jiF1AEfrj/H
	4gRT/nb4s/9Y5cfU1yyTn3Rz1L/Ow3KkAeDg+jKP4AMxPFqYhFtdAce4i2IVfSePM7T3Yq
	tN1I31rgfLx9JG3fzI9E0wpHwawyxpE9seJ8qSkXfSqOkFf3oZwn1LJ6t0Y5SxBUDztBAD
	zAcAsOTehaSypxISObgzy/xRND6t0vjtxmc0m+TR3VropzLMBWAfojUR513o77SjVTxtXi
	tR9FHhawb1omzCU3++fN+8BunCkK3OEywcPwix/JuZu8bgZWaaMvLCOjlLtNXQ==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: mt76: circular locking between dev->mutex and local->iflist_mtx
Date: Wed, 29 Jul 2026 22:39:16 -0700
Message-ID: <20260730053916.109426-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Lockdep reports a possible deadlock in mt76 on v7.2-rc5. This is stock
in-tree, no patches, on an MT7922 (mt7921e). Kernel built with
PROVE_LOCKING, DEBUG_MUTEXES and DEBUG_ATOMIC_SLEEP.

With NetworkManager told to leave the device alone:

  ip link set wlp4s0 down
  iw phy phy0 interface add mon0 type monitor
  ip link set mon0 up
  iw dev mon0 set freq 5180
  iw dev mon0 del

Nothing fires until the last line. I have reproduced it twice in-tree on
fresh boots, and three times on a downstream build of the same driver,
always at the delete and never before it.

[   32.187995] ======================================================
[   32.188048] WARNING: possible circular locking dependency detected
[   32.188100] 7.2.0-rc5-72rc5-lockdep #1 Not tainted
[   32.188143] ------------------------------------------------------
[   32.188192] iw/747 is trying to acquire lock:
[   32.188232] ffff8f026d573d78 (&dev->mutex#3){+.+.}-{4:4}, at: mt792x_unassign_vif_chanctx+0x29/0x80 [mt792x_lib]
[   32.188338] 
               but task is already holding lock:
[   32.188388] ffff8f026d572ab0 (&local->iflist_mtx){+.+.}-{4:4}, at: ieee80211_del_virtual_monitor+0x4d/0x180 [mac80211]
[   32.188567] 
               which lock already depends on the new lock.

[   32.188635] 
               the existing dependency chain (in reverse order) is:
[   32.188699] 
               -> #1 (&local->iflist_mtx){+.+.}-{4:4}:
[   32.188763]        __mutex_lock+0xda/0x1070
[   32.188811]        ieee80211_iterate_interfaces+0x34/0x70 [mac80211]
[   32.188953]        mt7921_config+0xb8/0xe0 [mt7921_common]
[   32.189010]        drv_config+0x63/0x1d0 [mac80211]
[   32.189124]        ieee80211_hw_conf_init+0x60/0x80 [mac80211]
[   32.189242]        ieee80211_do_open+0x6d4/0x9f0 [mac80211]
[   32.189370]        ieee80211_open+0x99/0xa0 [mac80211]
[   32.189482]        __dev_open+0x125/0x290
[   32.189523]        __dev_change_flags+0x1b0/0x230
[   32.189568]        netif_change_flags+0x27/0x70
[   32.189611]        do_setlink.isra.0+0x370/0x1410
[   32.189656]        rtnl_newlink+0x9ef/0xdb0
[   32.189686]        rtnetlink_rcv_msg+0x486/0x720
[   32.189716]        netlink_rcv_skb+0xcd/0x150
[   32.189738]        netlink_unicast+0x1e7/0x2d0
[   32.189759]        netlink_sendmsg+0x234/0x4b0
[   32.189780]        ____sys_sendmsg+0x391/0x3d0
[   32.189802]        ___sys_sendmsg+0xe1/0x130
[   32.189823]        __sys_sendmsg+0xa4/0x100
[   32.189843]        do_syscall_64+0xbd/0x750
[   32.189865]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   32.189890] 
               -> #0 (&dev->mutex#3){+.+.}-{4:4}:
[   32.189923]        __lock_acquire+0xe38/0x2460
[   32.189946]        lock_acquire+0xca/0x2e0
[   32.190432]        __mutex_lock+0xda/0x1070
[   32.190857]        mt792x_unassign_vif_chanctx+0x29/0x80 [mt792x_lib]
[   32.191262]        drv_unassign_vif_chanctx+0x11c/0x290 [mac80211]
[   32.191698]        ieee80211_assign_link_chanctx+0x2aa/0x5c0 [mac80211]
[   32.192140]        __ieee80211_link_release_channel+0xa2/0x2b0 [mac80211]
[   32.192571]        ieee80211_del_virtual_monitor+0x7e/0x180 [mac80211]
[   32.193010]        ieee80211_do_stop+0x8b7/0xad0 [mac80211]
[   32.193454]        ieee80211_stop+0x71/0x100 [mac80211]
[   32.193877]        __dev_close_many+0xcd/0x250
[   32.194257]        netif_close_many+0xdc/0x1c0
[   32.194616]        netif_close+0x68/0xa0
[   32.194980]        dev_close+0x2c/0x80
[   32.195321]        nl80211_del_interface+0x4c/0xa0 [cfg80211]
[   32.195697]        genl_family_rcv_msg_doit+0x148/0x1a0
[   32.196032]        genl_rcv_msg+0x1d0/0x320
[   32.196362]        netlink_rcv_skb+0xcd/0x150
[   32.196705]        genl_rcv+0x28/0x40
[   32.197034]        netlink_unicast+0x1e7/0x2d0
[   32.197354]        netlink_sendmsg+0x234/0x4b0
[   32.197672]        ____sys_sendmsg+0x391/0x3d0
[   32.197997]        ___sys_sendmsg+0xe1/0x130
[   32.198252]        __sys_sendmsg+0xa4/0x100
[   32.198494]        do_syscall_64+0xbd/0x750
[   32.198739]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   32.198981] 
               other info that might help us debug this:

[   32.199615]  Possible unsafe locking scenario:

[   32.200013]        CPU0                    CPU1
[   32.200213]        ----                    ----
[   32.200410]   lock(&local->iflist_mtx);
[   32.200608]                                lock(&dev->mutex#3);
[   32.200819]                                lock(&local->iflist_mtx);
[   32.201023]   lock(&dev->mutex#3);
[   32.201227] 
                *** DEADLOCK ***

[   32.201828] 4 locks held by iw/747:
[   32.202031]  #0: ffffffffa852bb48 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40
[   32.202248]  #1: ffffffffa851a800 (rtnl_mutex){+.+.}-{4:4}, at: nl80211_pre_doit+0x32/0x2b0 [cfg80211]
[   32.202490]  #2: ffff8f026d5707a0 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: ieee80211_stop+0x3c/0x100 [mac80211]
[   32.202751]  #3: ffff8f026d572ab0 (&local->iflist_mtx){+.+.}-{4:4}, at: ieee80211_del_virtual_monitor+0x4d/0x180 [mac80211]
[   32.203011] 
               stack backtrace:
[   32.203467] CPU: 12 UID: 0 PID: 747 Comm: iw Not tainted 7.2.0-rc5-72rc5-lockdep #1 PREEMPT(full)  b69d6c24e2bb6600f5be6e546ee17bbda82a7b94
[   32.203470] Hardware name: GMKtec NucBox K8 Plus/NucBox K8 Plus, BIOS NucBox K8 Plus 1.02 08/22/2025
[   32.203471] Call Trace:
[   32.203472]  <TASK>
[   32.203475]  dump_stack_lvl+0x6e/0xa0
[   32.203478]  print_circular_bug.cold+0x189/0x1eb
[   32.203482]  check_noncircular+0x173/0x1a0
[   32.203489]  __lock_acquire+0xe38/0x2460
[   32.203494]  lock_acquire+0xca/0x2e0
[   32.203497]  ? mt792x_unassign_vif_chanctx+0x29/0x80 [mt792x_lib 3a3eb660c69c1a8981818b181920f0c124bf7bfe]
[   32.203501]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203502]  ? lock_is_held_type+0xb0/0x180
[   32.203507]  __mutex_lock+0xda/0x1070
[   32.203509]  ? mt792x_unassign_vif_chanctx+0x29/0x80 [mt792x_lib 3a3eb660c69c1a8981818b181920f0c124bf7bfe]
[   32.203512]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203514]  ? mt792x_unassign_vif_chanctx+0x29/0x80 [mt792x_lib 3a3eb660c69c1a8981818b181920f0c124bf7bfe]
[   32.203520]  ? mt792x_unassign_vif_chanctx+0x29/0x80 [mt792x_lib 3a3eb660c69c1a8981818b181920f0c124bf7bfe]
[   32.203523]  mt792x_unassign_vif_chanctx+0x29/0x80 [mt792x_lib 3a3eb660c69c1a8981818b181920f0c124bf7bfe]
[   32.203526]  drv_unassign_vif_chanctx+0x11c/0x290 [mac80211 ca513ba89efcfc1d08c019d6ad64c132f8ebbf7d]
[   32.203548]  ieee80211_assign_link_chanctx+0x2aa/0x5c0 [mac80211 ca513ba89efcfc1d08c019d6ad64c132f8ebbf7d]
[   32.203571]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203572]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203573]  ? __mutex_lock+0x5c8/0x1070
[   32.203575]  ? skb_dequeue+0x22/0x80
[   32.203577]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203580]  __ieee80211_link_release_channel+0xa2/0x2b0 [mac80211 ca513ba89efcfc1d08c019d6ad64c132f8ebbf7d]
[   32.203601]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203602]  ? lock_is_held_type+0xb0/0x180
[   32.203605]  ? ieee80211_link_release_channel+0x6b/0x80 [mac80211 ca513ba89efcfc1d08c019d6ad64c132f8ebbf7d]
[   32.203626]  ieee80211_del_virtual_monitor+0x7e/0x180 [mac80211 ca513ba89efcfc1d08c019d6ad64c132f8ebbf7d]
[   32.203647]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203648]  ieee80211_do_stop+0x8b7/0xad0 [mac80211 ca513ba89efcfc1d08c019d6ad64c132f8ebbf7d]
[   32.203668]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203676]  ieee80211_stop+0x71/0x100 [mac80211 ca513ba89efcfc1d08c019d6ad64c132f8ebbf7d]
[   32.203696]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203698]  __dev_close_many+0xcd/0x250
[   32.203701]  netif_close_many+0xdc/0x1c0
[   32.203704]  netif_close+0x68/0xa0
[   32.203706]  dev_close+0x2c/0x80
[   32.203709]  nl80211_del_interface+0x4c/0xa0 [cfg80211 2693099cfbb115e4a17b77b12e01c00987872d66]
[   32.203729]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203730]  genl_family_rcv_msg_doit+0x148/0x1a0
[   32.203737]  genl_rcv_msg+0x1d0/0x320
[   32.203739]  ? __pfx_nl80211_pre_doit+0x10/0x10 [cfg80211 2693099cfbb115e4a17b77b12e01c00987872d66]
[   32.203757]  ? __pfx_nl80211_del_interface+0x10/0x10 [cfg80211 2693099cfbb115e4a17b77b12e01c00987872d66]
[   32.203774]  ? __pfx_nl80211_post_doit+0x10/0x10 [cfg80211 2693099cfbb115e4a17b77b12e01c00987872d66]
[   32.203792]  ? __pfx_genl_rcv_msg+0x10/0x10
[   32.203795]  netlink_rcv_skb+0xcd/0x150
[   32.203801]  genl_rcv+0x28/0x40
[   32.203803]  netlink_unicast+0x1e7/0x2d0
[   32.203805]  netlink_sendmsg+0x234/0x4b0
[   32.203810]  ____sys_sendmsg+0x391/0x3d0
[   32.203812]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203816]  ___sys_sendmsg+0xe1/0x130
[   32.203828]  __sys_sendmsg+0xa4/0x100
[   32.203833]  do_syscall_64+0xbd/0x750
[   32.203835]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203836]  ? __sys_socket+0xde/0x130
[   32.203839]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203840]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203841]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203843]  ? do_syscall_64+0x1ee/0x750
[   32.203845]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203846]  ? do_user_addr_fault+0x357/0x730
[   32.203848]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203849]  ? lockdep_hardirqs_on_prepare+0xdd/0x190
[   32.203850]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203852]  ? trace_hardirqs_on+0x18/0xf0
[   32.203854]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203856]  ? do_syscall_64+0x72/0x750
[   32.203857]  ? srso_alias_return_thunk+0x5/0xfbef5
[   32.203858]  ? exc_page_fault+0x155/0x2c0
[   32.203860]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   32.203862] RIP: 0033:0x7fa3eba94ade
[   32.203864] Code: 4d 89 d8 e8 64 bf 00 00 4c 8b 5d f8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 05 <c9> c3 83 e2 39 83 fa 08 75 e7 e8 03 ff ff ff 0f 1f 00 f3 0f 1e fa
[   32.203865] RSP: 002b:00007ffd9a1b32c0 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
[   32.203866] RAX: ffffffffffffffda RBX: 0000562a29b36100 RCX: 00007fa3eba94ade
[   32.203867] RDX: 0000000000000000 RSI: 00007ffd9a1b3360 RDI: 0000000000000003
[   32.203868] RBP: 00007ffd9a1b32d0 R08: 0000000000000000 R09: 0000000000000000
[   32.203869] R10: 0000000000000000 R11: 0000000000000202 R12: 0000562a29b361d0
[   32.203869] R13: 00007ffd9a1b3360 R14: 0000562a29b3b680 R15: 0000000000000000
[   32.203875]  </TASK>

mac80211 holds iflist_mtx and calls driver ops that take dev->mutex, so
that order is fixed and the driver cannot change it. mt7921_config does
the reverse: it holds dev->mutex across
ieee80211_iterate_active_interfaces(), which takes iflist_mtx.

It is not one site. Taking dev->mutex across a non-atomic
ieee80211_iterate_* happens in config, suspend, resume and roc_work in
both mt7921 and mt7925, which is eight. Lockdep caught a ninth that is
not obvious from reading those functions: mt76_sta_add() takes
dev->mutex at mac80211.c:1585 and calls drv->sta_add, which reaches
mt7921_regd_set_6ghz_power_type and iterates with the mutex still held.
I have not checked roc_abort_sync, set_runtime_pm, mlo_pm_work or
mac_reset_work, so nine is a floor rather than a count. The _atomic
variants are fine, they take rcu_read_lock rather than iflist_mtx.

I have not bisected this, yet. The pattern looks longstanding rather
than a recent regression, but I would not state that as fact.

Three ways I can see to fix it:

  1. Use ieee80211_iterate_active_interfaces_mtx() where the wiphy mutex
     is already held. drv_config, drv_suspend and drv_resume all assert
     it, and that variant takes no lock at all. Does not help roc_work
     or the sta_add path.

  2. Drop dev->mutex around the iterate and take it inside the callback,
     so the order is always iflist_mtx then dev->mutex.

  3. Iterate to collect, then act, so the two locks never nest.

If one of those looks like the right direction, I can write it and test
it. I have MT7922, MT7925 and MT7927 on the bench with a lockdep kernel
already set up, so it gets verified on hardware rather than just
compiled.

Devin
