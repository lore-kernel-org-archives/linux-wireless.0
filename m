Received: from mail-oo2-f11.google.com (mail-oo2-f11.google.com [74.125.231.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D489E4825C4
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 22:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788993902; cv=none; b=edrNkHEy5NyfYXPKr07i0LeqQQgPruJgum9LSQzD/GQxoQRReh7OWVOULIlRWI3BI3quxdFxDv0tJy5eNxhd/gUA/O+Mja9FhHo7stxM/U6T9H6Q35dQCMw5hT1QPIA+7gKXQzoUyDh+Oj4EZ8hRNvErRPk5+4Q3KwSuJ3hucsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788993902; c=relaxed/simple;
	bh=ayXAYpIOQBuW6ezTZuvH5c7lqVtStW6Pgo04q9tR3FY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kzeen7LRzacLgoZNgL0+7ZcLXbDMovET5SIjGNQ2p96f55rYGom0pdTG/Kaf95Wby8+wt0misH2+o7FIqCX7ZmVkGYrF0Wv8Ihqo0vvHA66dpyz+X6tUBf5xdE26nk0rr8J38YSRZRNj8gpmv/AAel41I6A2mVAulhPPpAVg/Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f11.google.com with SMTP id 006d021491bc7-6b148096e48so1301375eaf.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 15:44:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788993886; x=1789598686;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H/zyDd5ZHfD1gowSKtlv4Qe8jLMIPiJvUQA8mt4u+qI=;
        b=f4M+7E0YZE/W97YnX8uokFD/q4unpP/hH97n86s+2ua2qDtS8rOoNAZd8oALVaKODb
         zurRw8s70HwMpkgTUENmWY+CutFM45xXwi+otZFfbv63R3xBYmxGWGGJGoVPe62AZ0bm
         JNTf6cQ8maGeRwWbtP8RPIsyVPZWHyRaI1ZQYd8T4NHm8Tp0d7pTu8APEeXr9S6A4AAe
         BXfi0Hr1jFWekA2npE4VmrOmvPWV1hzkjFC9V2MBwfx8XQILk/BlbnGteJe2YwLhpFzu
         q/ulZyThE4xhx/EaXX30kV4+HfOCpZ0YNlHiwBdM6+YtAqz8rxHHrYG+zol8kqzLkynA
         10TQ==
X-Forwarded-Encrypted: i=1; AKwUvBxHKF058zzA5fKwguScUOfnJ12rxykxsHjp9b2ExE1NcZnplMotvS5EEV2Xv2JahOh6V10CsXfDlH1Cp66uFw==@vger.kernel.org
X-Gm-Message-State: AFuF++mHMSGE4hzPsSs7ccRhGFE4u+xVbPwv++1kCgLr3aONGao2YZEc
	8CXxx9+lwDEWvdlUrv7Hj49+5A5/8SxQqAWiBd/Ml2d8TFl1f07DN8teOeNgg06ATgHZHUS6BAD
	Dlwn7+i6EnDkb1xAQTllLyf5gUKWJ5qPe6wTU0Mb8ccBpXXQLmCnso7Mcj38=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:810a:b0:6b1:bdd9:453 with SMTP id
 006d021491bc7-6b6faee1fa2mr23686398eaf.12.1788993886341; Wed, 09 Sep 2026
 15:44:46 -0700 (PDT)
Date: Wed, 09 Sep 2026 15:44:46 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa1e15e.f81106d8.2ab401.0003.GAE@google.com>
Subject: [syzbot] [wireless?] BUG: using smp_processor_id() in preemptible
 code in ieee80211_tx_control_port
From: syzbot <syzbot+d979bd35c8a76fd1b6f5@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a9d7ced84989 Add linux-next specific files for 20260908
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=149cfaf9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=17eeb09695a2b3c9
dashboard link: https://syzkaller.appspot.com/bug?extid=d979bd35c8a76fd1b6f5
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129cfaf9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139866f9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4f470407358e/disk-a9d7ced8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/858b9d7ba687/vmlinux-a9d7ced8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ef971d22d75f/bzImage-a9d7ced8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d979bd35c8a76fd1b6f5@syzkaller.appspotmail.com

BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor240/5639
caller is dev_sw_netstats_tx_add include/linux/netdevice.h:3086 [inline]
caller is ieee80211_tx_control_port+0xac7/0x1100 net/mac80211/tx.c:6656
CPU: 0 UID: 0 PID: 5639 Comm: syz-executor240 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 check_preemption_disabled+0xcd/0xd0 lib/smp_processor_id.c:47
 dev_sw_netstats_tx_add include/linux/netdevice.h:3086 [inline]
 ieee80211_tx_control_port+0xac7/0x1100 net/mac80211/tx.c:6656
 rdev_tx_control_port net/wireless/rdev-ops.h:783 [inline]
 nl80211_tx_control_port+0x624/0x960 net/wireless/nl80211.c:18603
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x7c3/0xae0 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
 __sys_sendmsg net/socket.c:2799 [inline]
 __do_sys_sendmsg net/socket.c:2804 [inline]
 __se_sys_sendmsg net/socket.c:2802 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2fe280ba69
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc9ac26a08 EFLAGS: 00000246 ORIG_RAX: 000000000000002e



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
