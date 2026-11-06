Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951620;
	b=OKUBWAnWVgFQwl+9LOxISlUltqAQyQKAz1J2Sai816y9OhXYTy8F5JBp5pqaqTmCLxY7
	 8ZGnIisZ1XxB2TuGKCzlP5wuMqoVLxmC+cUHYWzmwm0BFhTo7MA3xHPBw4Xfe39EFs1SP
	 BM5eqLiD3m0M1kMT3ODaGpD2f4zyNNR7bPV9UIA+A/LV3CoIEHjl5RA2LoBcIOY/tElQy
	 tjXiRaV+nUMWr+GTnMRjhdS2WxfsuUBpW5huuwblqqwa3eAOOfQvTUjeu4xeCBDNX1/Nn
	 jAacEMIzTSNLVof7h2GyQLQW6C9hD9L4llv19ln3r3AHNc9+AG7xv73Zc6gSIpwD9Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951620;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type:Content-Transfer-Encoding;
	bh=unJFSXbfBrYi3pTr0qn9F9/p+n8o4mcLmQXMTzwZpt4=;
	b=CEtAa41z2wK844Nko7B4vTK2EcoaxE77LNSkQzBweM9LRl1KcvEB/+sdnXc8ByUc1Pyw
	 oTCuZFH0wUZSDa3yoiVXbU2KnsMS9GZlXpRMSX6GO7VkgD/oVFVYCyufchweiTzS4Iocr
	 NbR93w31hOmdCZuQLeuXdIDqb47CjuD4ebiobgD2nE9CZj1OFrp9wML6Cz0bRW20dujes
	 olKg4FE6fmmehySbdHQ58WxsG+1I1oA9O99efz9VPIFAw579rh/D5X9wzyQ9MUrVpHGfK
	 Ce0CFHr/gVBMg/itNExaO0BcCN+vojvcsyW9dZ4S8whk52Kh8rxfVnU4Jl4J5U337qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432B2606A32F
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:53:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 432B2606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-547ae874949so441818b6e.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:53:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951619; x=1794556419;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :in-reply-to:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=unJFSXbfBrYi3pTr0qn9F9/p+n8o4mcLmQXMTzwZpt4=;
        b=zeXllBDcxwxHE0jbLo/V/MW1n69Q4W0CYzmlYeppy08CjwfxYXlrFYZTC+1bLhC+1X
         GD4b4BKlsb1FfZjAM6B25XTM49WrEV/yw8Dw/Syra7yCqTQ7J8X08H6cbaU2BxAyPNOS
         VOX/DUe+hEp1W0bpZHWx1bk6jHYVCAG8FAtCM09UMf93ANE5UJkjw3RAWHTyMf4yMHCK
         Ah9BGhsdP+3hTwpEoVPrMoZTDpHOV5CRh6tJYujur0ULUyEYPPgGRPXIXuBIdDyQC98D
         RK4N/F5/jPZskKNc2G3ylehOQr8mgQtRn36Td0hf9rdE/cmeH/KJzdKUAmBbbMoWQLEl
         Z1wQ==
X-Forwarded-Encrypted: i=1; AKwUvBzPl8wXy+fKclxGs13TDdIDT3bXhNqNrTWuZtSjGvzQBLcWTBoNBqJe+kZobTwYhri0mTnp90fXwzPiLUuong==@vger.kernel.org
X-Gm-Message-State: APuU4Z9hy+DO+zrNAFmzHftPfLA8/0S4G6IbW1PnhObAKO15kvgC0fqy
	opTjo3moK857GOSk9iXrctvI1KQNj3yj6w4Jux58/Fd+FIRHDT/Ri+i6kY2aa/EmQqSQlsBrYfX
	pLv2Ppq5EdoVxxHM6CrjKVvhd1iylBP5Ir9x951JHie71Y+XPSmzWK9S4a8k=
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f0d:b0:549:572c:fd42 with SMTP id
 5614622812f47-567e13616d2mr1123952b6e.47.1793951619125; Thu, 05 Nov 2026
 23:53:39 -0800 (PST)
Date: Thu, 05 Nov 2026 23:53:39 -0800
In-Reply-To: <6ab386e1.e8212013.2d060.0006.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aed8783.dede2635.b849c.0000.GAE@google.com>
Subject: Re: [syzbot] [wireless?] BUG: workqueue lockup in reg_todo
From: syzbot <syzbot+b733a65a200ab7aa2cbe@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	johannes@sipsolutions.net, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot has found a reproducer for the following issue on:

HEAD commit:    b0958b1397fb arm64: mm: validate /dev/mem mmap ranges with.=
.
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.g=
it for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=3D16e972fd580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da58b6b4d667e7a6=
1
dashboard link: https://syzkaller.appspot.com/bug?extid=3Db733a65a200ab7aa2=
cbe
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D17f70e5558000=
0

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a1caa79f24c0/disk-=
b0958b13.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/99b068dd4197/vmlinux-=
b0958b13.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e135f96e545e/Ima=
ge-b0958b13.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+b733a65a200ab7aa2cbe@syzkaller.appspotmail.com

bridge0: received packet on bridge_slave_1 with own address as source addre=
ss (addr:aa:aa:aa:aa:aa:0c, vlan:0)
BUG: workqueue lockup - pool cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 stuck f=
or 33s!
Showing busy workqueues and worker pools:
workqueue events: flags=3D0x100
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D14 refcnt=3D15
    in-flight: 4993:reg_todo for 33s ,1104:nsim_fib_event_work for 111s nsi=
m_fib_event_work ,9:nsim_fib_event_work for 110s nsim_fib_event_work ,4754:=
nsim_fib_event_work for 111s nsim_fib_event_work
    pending: rht_deferred_worker, 2*nsim_dev_hwstats_traffic_work, vmstat_s=
hepherd, drm_fb_helper_damage_work, free_obj_work, psi_avgs_work
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    in-flight: 879:switchdev_deferred_process_work for 63s
    pending: nsim_dev_hwstats_traffic_work, psi_avgs_work
workqueue events_unbound: flags=3D0x2
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D2 refcnt=3D3
    in-flight: 292:cfg80211_wiphy_work for 98s cfg80211_wiphy_work
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D12 refcnt=3D13
    in-flight: 384:cfg80211_wiphy_work for 97s cfg80211_wiphy_work ,323:lin=
kwatch_event for 42s ,40:cfg80211_wiphy_work for 109s cfg80211_wiphy_work ,=
120:cfg80211_wiphy_work for 110s cfg80211_wiphy_work
    pending: 3*nsim_dev_trap_report_work, toggle_allocation_gate, flush_mem=
cg_stats_dwork
workqueue events_power_efficient: flags=3D0x82
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D2 refcnt=3D3
    in-flight: 5038:gc_worker for 6s
    pending: fb_flashcursor
workqueue events_dfl_long: flags=3D0x2
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D2 refcnt=3D3
    in-flight: 56:defense_work_handler for 0s
    pending: defense_work_handler
workqueue netns: flags=3D0x6000a
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D4
    in-flight: 61:cleanup_net for 112s
workqueue mm_percpu_wq: flags=3D0x108
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: vmstat_update
workqueue writeback: flags=3D0x4a
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    in-flight: 12:wb_workfn for 106s
workqueue mld: flags=3D0x40108
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D70
    pending: mld_ifc_work
    inactive: 2*mld_ifc_work, 3*mld_dad_work, mld_ifc_work, mld_dad_work, 2=
*mld_ifc_work, mld_dad_work, 2*mld_ifc_work, mld_dad_work, 3*mld_ifc_work, =
mld_dad_work, 2*mld_ifc_work, 6*mld_dad_work, 8*mld_ifc_work, mld_dad_work,=
 mld_ifc_work, 2*mld_dad_work, mld_ifc_work, mld_dad_work, 4*mld_ifc_work, =
mld_dad_work, 8*mld_ifc_work, mld_dad_work, mld_ifc_work, mld_dad_work, 7*m=
ld_ifc_work, 6*mld_dad_work
workqueue ipv6_addrconf: flags=3D0x6000a
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D121 MAYDAY
    in-flight: 59(RESCUER):addrconf_dad_work for 63s
    inactive: 115*addrconf_dad_work
workqueue bat_events: flags=3D0x6000a
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D49 MAYDAY
    in-flight: 2871(RESCUER):batadv_tt_purge for 0s
    pending: mayday_cursor_func
    inactive: batadv_tt_purge, 2*batadv_mcast_mla_update, batadv_iv_send_ou=
tstanding_bat_ogm_packet, batadv_dat_purge, batadv_bla_periodic_work, batad=
v_dat_purge, batadv_bla_periodic_work, batadv_mcast_mla_update, batadv_dat_=
purge, batadv_bla_periodic_work, batadv_dat_purge, batadv_bla_periodic_work=
, batadv_iv_send_outstanding_bat_ogm_packet, batadv_purge_orig, batadv_dat_=
purge, batadv_bla_periodic_work, batadv_dat_purge, batadv_bla_periodic_work=
, 2*batadv_iv_send_outstanding_bat_ogm_packet, batadv_purge_orig, batadv_iv=
_send_outstanding_bat_ogm_packet, 3*batadv_mcast_mla_update, 2*batadv_iv_se=
nd_outstanding_bat_ogm_packet, batadv_purge_orig, 5*batadv_iv_send_outstand=
ing_bat_ogm_packet, 3*batadv_purge_orig, 3*batadv_iv_send_outstanding_bat_o=
gm_packet, 3*batadv_tt_purge
workqueue wg-kex-wg0: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-kex-wg0: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    in-flight: 5036:wg_packet_handshake_send_worker for 4s
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D4 refcnt=3D5
    in-flight: 4970:wg_packet_tx_worker for 35s
    pending: wg_packet_decrypt_worker, wg_packet_tx_worker, wg_packet_encry=
pt_worker
workqueue wg-kex-wg1: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_decrypt_worker, wg_packet_encrypt_worker, wg_packet_=
tx_worker
workqueue wg-kex-wg2: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    in-flight: 4870:wg_packet_handshake_receive_worker for 50s
    pending: wg_packet_handshake_receive_worker
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    in-flight: 26:wg_packet_handshake_receive_worker for 55s wg_packet_hand=
shake_receive_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_decrypt_worker, wg_packet_encrypt_worker, wg_packet_=
tx_worker
workqueue wg-kex-wg0: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-kex-wg0: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    in-flight: 13:wg_packet_handshake_send_worker for 2s
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D4 refcnt=3D5
    in-flight: 10:wg_packet_tx_worker for 35s
    pending: wg_packet_encrypt_worker, wg_packet_decrypt_worker, wg_packet_=
tx_worker
workqueue wg-kex-wg1: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_decrypt_worker, wg_packet_tx_worker, wg_packet_encry=
pt_worker
workqueue wg-kex-wg2: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_encrypt_worker, wg_packet_decrypt_worker, wg_packet_=
tx_worker
workqueue wg-kex-wg0: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_receive_worker
workqueue wg-kex-wg0: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    in-flight: 5037:wg_packet_handshake_send_worker for 0s
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_tx_worker, wg_packet_decrypt_worker, wg_packet_encry=
pt_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_tx_worker, wg_packet_decrypt_worker, wg_packet_encry=
pt_worker
workqueue wg-kex-wg2: flags=3D0x124
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    in-flight: 4872:wg_packet_handshake_receive_worker for 35s
    pending: wg_packet_handshake_receive_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_tx_worker, wg_packet_encrypt_worker
pool 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 hung=3D33s workers=3D9 idle:=
 4473
pool 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 hung=3D0s workers=3D6 idle: =
24 5039 4851 4994
pool 8: cpus=3D0-1 flags=3D0x6 nice=3D0 hung=3D0s workers=3D13 manager: 504=
0
Showing backtraces of busy workers in stalled worker pools:
pool 2:
task:kworker/0:8     state:R  running task     stack:0     pid:4993  tgid:4=
993  ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: events reg_todo
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 preempt_schedule_common+0xd4/0x190 kernel/sched/core.c:7561
 preempt_schedule+0x60/0x78 kernel/sched/core.c:7585
 __local_bh_enable_ip+0x16c/0x234 kernel/softirq.c:480
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 __alloc_skb+0x1c8/0x610 net/core/skbuff.c:700
 alloc_skb include/linux/skbuff.h:1390 [inline]
 alloc_uevent_skb+0x78/0x1ec lib/kobject_uevent.c:289
 uevent_net_broadcast_untagged lib/kobject_uevent.c:326 [inline]
 kobject_uevent_net_broadcast+0x2d4/0x53c lib/kobject_uevent.c:410
 kobject_uevent_env+0x518/0x944 lib/kobject_uevent.c:611
 call_crda net/wireless/reg.c:575 [inline]
 reg_query_database+0x2b8/0x514 net/wireless/reg.c:1128
 reg_process_hint_core net/wireless/reg.c:2744 [inline]
 reg_process_hint+0x1b8/0x9d4 net/wireless/reg.c:3091
 reg_process_pending_hints net/wireless/reg.c:3184 [inline]
 reg_todo+0x1cc/0x848 net/wireless/reg.c:3275
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3578
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3659
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
pool 2:
task:kworker/0:2     state:R  running task     stack:0     pid:1104  tgid:1=
104  ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: events nsim_fib_event_work
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 schedule_timeout+0x13c/0x28c kernel/time/sleep_timeout.c:99
 schedule_timeout_uninterruptible+0x78/0xbc kernel/time/sleep_timeout.c:158
 msleep+0x3c/0x68 kernel/time/sleep_timeout.c:318
 nsim_fib4_rt_add drivers/net/netdevsim/fib.c:369 [inline]
 nsim_fib4_rt_insert drivers/net/netdevsim/fib.c:432 [inline]
 nsim_fib4_event drivers/net/netdevsim/fib.c:464 [inline]
 nsim_fib_event+0x5564/0x60c4 drivers/net/netdevsim/fib.c:884
 nsim_fib_event_work+0x1d8/0x320 drivers/net/netdevsim/fib.c:1493
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3578
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3659
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
pool 2:
task:kworker/0:5     state:R  running task     stack:0     pid:4870  tgid:4=
870  ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: wg-kex-wg2 wg_packet_handshake_receive_worker
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 preempt_schedule_common+0xd4/0x190 kernel/sched/core.c:7561
 preempt_schedule+0x60/0x78 kernel/sched/core.c:7585
 __local_bh_enable_ip+0x16c/0x234 kernel/softirq.c:480
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:923 [inline]
 wg_noise_handshake_begin_session+0x698/0x958 drivers/net/wireguard/noise.c=
:855
 wg_packet_send_handshake_response+0x108/0x264 drivers/net/wireguard/send.c=
:96
 wg_receive_handshake_packet drivers/net/wireguard/receive.c:154 [inline]
 wg_packet_handshake_receive_worker+0x570/0xcf8 drivers/net/wireguard/recei=
ve.c:213
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3578
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3659
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
pool 2:
task:kworker/0:1     state:R  running task     stack:0     pid:10    tgid:1=
0    ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: wg-crypt-wg0 wg_packet_tx_worker
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 preempt_schedule_common+0xd4/0x190 kernel/sched/core.c:7561
 preempt_schedule+0x60/0x78 kernel/sched/core.c:7585
 __local_bh_enable_ip+0x16c/0x234 kernel/softirq.c:480
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:923 [inline]
 mod_peer_timer+0x21c/0x25c drivers/net/wireguard/timers.c:38
 wg_timers_any_authenticated_packet_traversal+0x98/0xc0 drivers/net/wiregua=
rd/timers.c:218
 wg_packet_create_data_done drivers/net/wireguard/send.c:247 [inline]
 wg_packet_tx_worker+0x130/0x75c drivers/net/wireguard/send.c:276
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3578
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3659
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
pool 2:
task:kworker/0:7     state:R  running task     stack:0     pid:4970  tgid:4=
970  ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: wg-crypt-wg0 wg_packet_tx_worker
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 preempt_schedule_common+0xd4/0x190 kernel/sched/core.c:7561
 preempt_schedule+0x60/0x78 kernel/sched/core.c:7585
 __local_bh_enable_ip+0x16c/0x234 kernel/softirq.c:480
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:923 [inline]
 mod_peer_timer+0x21c/0x25c drivers/net/wireguard/timers.c:38
 wg_timers_any_authenticated_packet_traversal+0x98/0xc0 drivers/net/wiregua=
rd/timers.c:218
 wg_packet_create_data_done drivers/net/wireguard/send.c:247 [inline]
 wg_packet_tx_worker+0x130/0x75c drivers/net/wireguard/send.c:276
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3578
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3659
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
pool 2:
task:kworker/0:6     state:R  running task     stack:0     pid:4872  tgid:4=
872  ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: wg-kex-wg2 wg_packet_handshake_receive_worker
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 preempt_schedule_common+0xd4/0x190 kernel/sched/core.c:7561
 preempt_schedule+0x60/0x78 kernel/sched/core.c:7585
 __local_bh_enable_ip+0x16c/0x234 kernel/softirq.c:480
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:923 [inline]
 mod_peer_timer+0x21c/0x25c drivers/net/wireguard/timers.c:38
 wg_timers_session_derived+0x5c/0x6c drivers/net/wireguard/timers.c:208
 wg_packet_send_handshake_response+0x118/0x264 drivers/net/wireguard/send.c=
:98
 wg_receive_handshake_packet drivers/net/wireguard/receive.c:154 [inline]
 wg_packet_handshake_receive_worker+0x570/0xcf8 drivers/net/wireguard/recei=
ve.c:213
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3578
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3659
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
pool 2:
task:kworker/0:0     state:R  running task     stack:0     pid:9     tgid:9=
     ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: events nsim_fib_event_work
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 schedule_timeout+0x13c/0x28c kernel/time/sleep_timeout.c:99
 schedule_timeout_uninterruptible+0x78/0xbc kernel/time/sleep_timeout.c:158
 msleep+0x3c/0x68 kernel/time/sleep_timeout.c:318
 nsim_fib6_rt_add drivers/net/netdevsim/fib.c:693 [inline]
 nsim_fib6_rt_insert drivers/net/netdevsim/fib.c:759 [inline]
 nsim_fib6_event drivers/net/netdevsim/fib.c:856 [inline]
 nsim_fib_event+0x57a0/0x60c4 drivers/net/netdevsim/fib.c:889
 nsim_fib_event_work+0x1d8/0x320 drivers/net/netdevsim/fib.c:1493
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3578
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3659
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
pool 2:
task:kworker/0:4     state:R  running task     stack:0     pid:4754  tgid:4=
754  ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: events nsim_fib_event_work
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 schedule_timeout+0x13c/0x28c kernel/time/sleep_timeout.c:99
 schedule_timeout_uninterruptible+0x78/0xbc kernel/time/sleep_timeout.c:158
 msleep+0x3c/0x68 kernel/time/sleep_timeout.c:318
 nsim_fib6_rt_add drivers/net/netdevsim/fib.c:693 [inline]
 nsim_fib6_rt_insert drivers/net/netdevsim/fib.c:759 [inline]
 nsim_fib6_event drivers/net/netdevsim/fib.c:856 [inline]
 nsim_fib_event+0x57a0/0x60c4 drivers/net/netdevsim/fib.c:889
 nsim_fib_event_work+0x1d8/0x320 drivers/net/netdevsim/fib.c:1493
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3578
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3659
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
net_ratelimit: 86641 callbacks suppressed
bridge0: received packet on bridge_slave_1 with own address as source addre=
ss (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth1_to_bridge with own address as source addr=
ess (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth1_to_bridge with own address as source addr=
ess (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth1_to_bridge with own address as source addr=
ess (addr:a6:a1:f8:01:63:4c, vlan:0)
bridge0: received packet on bridge_slave_1 with own address as source addre=
ss (addr:aa:aa:aa:aa:aa:1c, vlan:0)
net_ratelimit: 87585 callbacks suppressed
bridge0: received packet on bridge_slave_1 with own address as source addre=
ss (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth1_to_bridge with own address as source addr=
ess (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth1_to_bridge with own address as source addr=
ess (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth1_to_bridge with own address as source addr=
ess (addr:a6:a1:f8:01:63:4c, vlan:0)
bridge0: received packet on bridge_slave_1 with own address as source addre=
ss (addr:aa:aa:aa:aa:aa:1c, vlan:0)
bridge0: received packet on bridge_slave_1 with own address as source addre=
ss (addr:aa:aa:aa:aa:aa:0c, vlan:0)


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
