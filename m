Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA4C54704E
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 00:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791245080; cv=none; b=C9TaVtLoemsEEM3iHJuR1mjQjXX4jgHl8soChH0VhnwJ0EcpsP+mTWSJpbdxQzCSUeDO3yvgTFusrlQ3OpxuPqXZmJaBmvm8BEik9Wpvg3uVFwr3ju6bhaXdrlnmX3kBQGBSh1Kt5oLr6fAEVbOnlFstqMBjzah6Gk63SnZqZbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791245080; c=relaxed/simple;
	bh=P2ZLfK5sQH+NFxJaRgE3SKD/e9ahhwg1IfGSDEhQpyE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Wn/HulAtsYz6FyPQiSA8+PRByM7mlNlSsKDkn5YFqgvV1FQQaT2T72uBEKUAITJp0dL/fXBu9IflzmbXC3A7cdcyIgeHlqSTKOkEBlMmwREcyNgMjsWIqB+9il20LDb46K1+teziuvNRcK2n+7YMH84TIfAn6qO49icE8WQsGd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b28dafb8e1so3346490b6e.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 17:04:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791245077; x=1791849877;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YZfHvdcoS6BGVaobjlEJFKWcAFbVdkN8rdALLDkhIdI=;
        b=iL+s1iWOy4hxYcmJAUcMULI1RIAz7js4FoOUFGR1LhaOum2VPq3qczfPBXpZenyLBx
         SxdsX6arJVwxF9U97m7DtDzog054gBQhLNOwhetHIw2w8IUv8W588ycLSDLNSv3HfbKO
         yIlG+OPmknuAEWRhDX6DsZjgMly5DimwXSEdKoHxF8wwKvanybIP+vmFBu48MuNU+hAm
         1rw5AepC0LzSS1Fo4bZNIFLaIA+NLIfMFr/LwEWtFqfHQwDnR7pUeISnb1+u7qcLEl0d
         eef3amiAlW3rHGkE+438SYKrxT18gKL9REHbg2m16tyQBr2lAawcvkZi9JFuGrYXsuaR
         Cvng==
X-Forwarded-Encrypted: i=1; AKwUvBwhm7z824z+sHyWIZB4mpWihMlTCnKlvh8mrAT+HNPoFfMBKDImGQxBfDJ/jr9xjuNhht2IPDPmnKhNh51ZgQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kOBPFuo7x/c0ZtxNexdFTNkrSo9WhrKortpaoWob616oW2pZ+5
	1oqCDY58/TVLhs2EIbh21G153qYUeXvrxWMsDqvVT/PKw6ih2bmwWhKlW4jYEUOTvr2ZgY64Vv3
	zOsbXJPZPqKQBRq5JNDYFAec5VcwArkh9HwMMuW7UJuOJ6KL8K9fMbYVcQug=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:470b:b0:4ec:19e3:4072 with SMTP id
 5614622812f47-4f529d205afmr11124559b6e.18.1791245077677; Mon, 05 Oct 2026
 17:04:37 -0700 (PDT)
Date: Mon, 05 Oct 2026 17:04:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac43b15.34119e79.2f92f3.0039.GAE@google.com>
Subject: [syzbot] [wireless?] WARNING in cfg80211_ibss_joined
From: syzbot <syzbot+d0a52209bddfa0948065@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7b12c538697f Merge branch 'bpf-fix-objects-stuck-in-free_b..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=16192035580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d4242cb1c54cdf7
dashboard link: https://syzkaller.appspot.com/bug?extid=d0a52209bddfa0948065
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4306e2a7031b/disk-7b12c538.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4f631dc420c7/vmlinux-7b12c538.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6633caf1195c/bzImage-7b12c538.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d0a52209bddfa0948065@syzkaller.appspotmail.com

wlan1: Creating new IBSS network, BSSID 8d:8d:8d:ff:00:00
------------[ cut here ]------------
!bss
WARNING: net/wireless/ibss.c:72 at cfg80211_ibss_joined+0x3a7/0x5b0 net/wireless/ibss.c:72, CPU#1: kworker/u8:15/6639
Modules linked in:
CPU: 1 UID: 0 PID: 6639 Comm: kworker/u8:15 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Workqueue: events_unbound cfg80211_wiphy_work
RIP: 0010:cfg80211_ibss_joined+0x3a7/0x5b0 net/wireless/ibss.c:72
Code: 48 89 da 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 fd 81 50 f6 e8 d8 25 8a f6 90 0f 0b 90 e9 0b fd ff ff e8 ca 25 8a f6 90 <0f> 0b 90 eb 5c 44 89 fe 83 e6 01 31 ff e8 b7 2a 8a f6 44 89 f8 83
RSP: 0018:ffffc90010217570 EFLAGS: 00010293
RAX: ffffffff8b3db6f6 RBX: 0000000000000001 RCX: ffff888032853e80
RDX: 0000000000000000 RSI: ffffffff8c6da760 RDI: ffffffff8c6da720
RBP: ffff888069cc3518 R08: ffffffff907a547f R09: 1ffffffff20f4a8f
R10: dffffc0000000000 R11: fffffbfff20f4a90 R12: ffff8880561e4ed0
R13: 0000000000000001 R14: 1ffff1100ac3c9da R15: 0000000000000cc0
FS:  0000000000000000(0000) GS:ffff888124dcb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb644e39246 CR3: 0000000059b92000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 <TASK>
 __ieee80211_sta_join_ibss+0xdd8/0x1660 net/mac80211/ibss.c:375
 ieee80211_sta_create_ibss+0x300/0x480 net/mac80211/ibss.c:1287
 ieee80211_sta_find_ibss net/mac80211/ibss.c:1448 [inline]
 ieee80211_ibss_work+0xb85/0x1060 net/mac80211/ibss.c:1637
 cfg80211_wiphy_work+0x29e/0x420 net/wireless/core.c:564
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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
