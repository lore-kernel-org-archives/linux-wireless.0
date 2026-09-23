Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2C245DF4F
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790150373; cv=none; b=g83VikyDFva1F+jR5ZJXSu6TLvAcgaxzsVqggRfSoStjgAkGxs6PqvOSuCPhwm3gbERAVODfMDHMapIEXQgzPbRrDWCykwqsiiWoQsqm4hBHYLJ+/r7DhW4WoSVdvctaA2Mj/jj7rcUrGPdChH0HITv1FZc6YECRwvXypiIl2NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790150373; c=relaxed/simple;
	bh=4eh5zOTZC44LleOfaH6juKYJ6+gtEihpaa8gIsJ1ApI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=iTtiA/Zy9K7MR5+/72TlOWcguoPvU6vQqNtyi5djyaVIHttK0AtAOYkD5tuozCCHyzlT2byCXHMTvqAf7sxq3E918ZnbFZ9JKu0OCj0dcMwvEwatzwsPGEykMIBPszrT2bIxcWO1MKYmJaUAeiwrkm9ILZMur7/QtYaaU/ImDK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-6c2d5235ac3so2413560eaf.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 00:59:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790150370; x=1790755170;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7F/Xvf4hTHldLYktQ2+9U+srrjIDEAG1Qfa+m0cEIKw=;
        b=PleE+4xPiF2ORGzKDzgU+pGG0s0JdUBfKyGpnhcbM1LS3zICeB6U9Bh5n349q3o4l0
         /+tksdia4xjnzMYFgR/xB3HZpnSAkldYG6d2Lo15T45FLG04EyZRQ6zICR99ycxUSM/A
         V70OlagIb7AA/gPYm9OZpefi+We8o6LD10UX+c2vC6JrjJC4VWoMNWLmuZZgVn6J5XTi
         C0u9HPQflE3+nLw2Eid+g+9UjaqPNAxJphpF78MhykDKNw1oa0HpifI+/9OZ5FDRAFyI
         Qq+JU2FO9BXCHbwGcTSsoBpfyKFeB06fbIwqVHyYOtQFGytZI6XnYWRacOvgMvIDGiFm
         kUtA==
X-Forwarded-Encrypted: i=1; AKwUvBwEkgvBsQqM1ihCfWHIWxeGRFJLHYjReITyqYaOEZ4qNtKdCLHFOs/4xNqLncgN7agUvgA5Y3ukjUjeFDX74Q==@vger.kernel.org
X-Gm-Message-State: AFuF++lYyli0KnvL7/zpA2siE8WUmqjS+EczDroGYywyRe1tKPEWOX1A
	4zdKMc4VjxScidM3CvBG7OCn02WzhfVrLaHAtvrSdQFdJGLe1D7v7Bt6poQg4zGcGnP7lbOxopH
	xIFqUkcLIstDqz1g+CNCovT8nWYkVO4CfEc1t7KFqymDj05Gk0s4kuGLE1MM=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee06:0:b0:6bf:ebd9:6cb4 with SMTP id
 006d021491bc7-6d157d8a169mr4187355eaf.8.1790150369772; Wed, 23 Sep 2026
 00:59:29 -0700 (PDT)
Date: Wed, 23 Sep 2026 00:59:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab386e1.e8212013.2d060.0006.GAE@google.com>
Subject: [syzbot] [wireless?] BUG: workqueue lockup in reg_todo
From: syzbot <syzbot+b733a65a200ab7aa2cbe@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelc=
i
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.g=
it for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=3D17105405580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D56ed23170c168d4=
c
dashboard link: https://syzkaller.appspot.com/bug?extid=3Db733a65a200ab7aa2=
cbe
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-=
1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c5963fdd6790/disk-=
38872197.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a8c2cab00c45/vmlinux-=
38872197.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bde15d173380/Ima=
ge-38872197.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+b733a65a200ab7aa2cbe@syzkaller.appspotmail.com

sched: DL replenish lagged too much
BUG: workqueue lockup - pool cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 stuck f=
or 35s!
Showing busy workqueues and worker pools:
workqueue events: flags=3D0x100
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D18 refcnt=3D19
    in-flight: 9:reg_todo for 39s
    pending: 2*psi_avgs_work, 6*nsim_dev_hwstats_traffic_work, free_obj_wor=
k, 3*psi_avgs_work, delayed_vfree_work, vmstat_shepherd, 3*ovs_dp_masks_reb=
alance
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D9 refcnt=3D10
    pending: 4*nsim_dev_hwstats_traffic_work, 4*ovs_dp_masks_rebalance, psi=
_avgs_work
workqueue events_unbound: flags=3D0x2
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D9 refcnt=3D10
    in-flight: 237:cfg80211_wiphy_work for 62s cfg80211_wiphy_work ,14:nsim=
_dev_trap_report_work for 14s ,6551:cfg80211_wiphy_work for 65s cfg80211_wi=
phy_work ,6553:cfg80211_wiphy_work for 10s ,6550:nsim_dev_trap_report_work =
for 7s
    pending: 2*nsim_dev_trap_report_work
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D12 refcnt=3D13
    in-flight: 6552:nsim_dev_trap_report_work for 9s ,40:cfg80211_wiphy_wor=
k for 59s cfg80211_wiphy_work ,3416:cfg80211_wiphy_work for 59s cfg80211_wi=
phy_work ,3118:cfg80211_wiphy_work for 2s ,6548:toggle_allocation_gate for =
8s ,524:cfg80211_wiphy_work for 17s ,6554:nsim_dev_trap_report_work for 4s
    pending: 3*nsim_dev_trap_report_work
workqueue events_power_efficient: flags=3D0x82
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D4 refcnt=3D5
    in-flight: 5258:reg_check_chans_work for 9s ,373:neigh_periodic_work fo=
r 30s ,49:wg_ratelimiter_gc_entries for 1s
    pending: neigh_periodic_work
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D2 refcnt=3D3
    in-flight: 6555:gc_worker for 8s ,6549:hash_ipportnet6_gc for 4s
workqueue events_dfl_long: flags=3D0x2
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D7 refcnt=3D8
    pending: 7*defense_work_handler
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D1 refcnt=3D2
    in-flight: 5257:defense_work_handler for 8s
workqueue netns: flags=3D0x6000a
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D1 refcnt=3D5
    in-flight: 5259:cleanup_net for 74s
    inactive: cleanup_net
workqueue mm_percpu_wq: flags=3D0x108
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: vmstat_update
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: vmstat_update
workqueue writeback: flags=3D0x4a
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D1 refcnt=3D2
    in-flight: 289:wb_workfn for 64s
workqueue ipv6_addrconf: flags=3D0x6000a
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D1 refcnt=3D7
    in-flight: 134:addrconf_dad_work for 39s
    inactive: 3*addrconf_dad_work
workqueue bat_events: flags=3D0x6000a
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D1 refcnt=3D51
    in-flight: 6547:batadv_tt_purge for 11s
    inactive: 2*batadv_tt_purge, batadv_bla_periodic_work, batadv_dat_purge=
, batadv_tt_purge, batadv_bla_periodic_work, batadv_dat_purge, batadv_bla_p=
eriodic_work, batadv_dat_purge, batadv_mcast_mla_update, 2*batadv_tt_purge,=
 batadv_dat_purge, batadv_bla_periodic_work, batadv_dat_purge, batadv_bla_p=
eriodic_work, batadv_mcast_mla_update, batadv_bla_periodic_work, batadv_dat=
_purge, 4*batadv_mcast_mla_update, 5*batadv_iv_send_outstanding_bat_ogm_pac=
ket, 3*batadv_purge_orig, batadv_iv_send_outstanding_bat_ogm_packet, 3*bata=
dv_purge_orig, 12*batadv_iv_send_outstanding_bat_ogm_packet
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_encrypt_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_encrypt_worker
workqueue wg-kex-wg0: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D1 refcnt=3D2
    in-flight: 6546:wg_packet_handshake_send_worker for 0s
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_tx_worker, wg_packet_encrypt_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
workqueue wg-kex-wg0: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_tx_worker, wg_packet_encrypt_worker, wg_packet_decry=
pt_worker
workqueue wg-kex-wg2: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_encrypt_worker
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker, wg_packet_decry=
pt_worker
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_encrypt_worker
workqueue wg-kex-wg1: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_decrypt_worker, wg_packet_encrypt_worker, wg_packet_=
tx_worker
workqueue wg-kex-wg2: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker, wg_packet_decry=
pt_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_decrypt_worker, wg_packet_encrypt_worker, wg_packet_=
tx_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_tx_worker, wg_packet_encrypt_worker
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker, wg_packet_decry=
pt_worker
workqueue wg-kex-wg1: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_decrypt_worker, wg_packet_encrypt_worker, wg_packet_=
tx_worker
workqueue wg-kex-wg2: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-kex-wg2: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x4 nice=3D0 active=3D1 refcnt=3D2
    in-flight: 394:wg_packet_handshake_send_worker for 3s
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_decrypt_worker, wg_packet_encrypt_worker, wg_packet_=
tx_worker
pool 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 hung=3D35s workers=3D7 idle:=
 4802 4872 10 4820 870 4902
pool 8: cpus=3D0-1 flags=3D0x4 nice=3D0 hung=3D0s workers=3D25 idle: 12
Showing backtraces of busy workers in stalled worker pools:
pool 2:
task:kworker/0:0     state:R  running task     stack:0     pid:9     tgid:9=
     ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: events reg_todo
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:775 (T)
 context_switch kernel/sched/core.c:5526 [inline]
 __schedule+0x1370/0x2d80 kernel/sched/core.c:7277
 preempt_schedule_common+0xd4/0x190 kernel/sched/core.c:7456
 preempt_schedule+0x60/0x78 kernel/sched/core.c:7480
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:211 [inline]
 _raw_spin_unlock_irqrestore+0x94/0x98 kernel/locking/spinlock.c:221
 spin_unlock_irqrestore include/linux/spinlock.h:425 [inline]
 __slab_free+0x194/0x1d0 mm/slub.c:5821
 ___cache_free+0x80/0x94 mm/slub.c:6580
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0xb4/0x120 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x118/0x124 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x2c/0x88 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 kmem_cache_alloc_noprof+0x268/0x5d4 mm/slub.c:5010
 skb_clone+0x1ac/0x320 net/core/skbuff.c:2119
 do_one_broadcast net/netlink/af_netlink.c:1456 [inline]
 netlink_broadcast_filtered+0x520/0xd58 net/netlink/af_netlink.c:1539
 netlink_broadcast+0x50/0x68 net/netlink/af_netlink.c:1563
 uevent_net_broadcast_untagged lib/kobject_uevent.c:331 [inline]
 kobject_uevent_net_broadcast+0x33c/0x53c lib/kobject_uevent.c:410
 kobject_uevent_env+0x518/0x944 lib/kobject_uevent.c:611
 call_crda net/wireless/reg.c:574 [inline]
 reg_query_database+0x278/0x4e4 net/wireless/reg.c:1116
 reg_process_hint_core net/wireless/reg.c:2681 [inline]
 reg_process_hint+0x1b8/0x990 net/wireless/reg.c:3027
 reg_process_pending_hints net/wireless/reg.c:3115 [inline]
 reg_todo+0x168/0x6a4 net/wireless/reg.c:3206
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3479
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3560
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:838


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
