Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECD31624D5
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 00:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786579778; cv=none; b=DJjtN+q3XxQYwCi2YaeMcitdlOT+ICENehiTco7cuVUigBGLXkHSjeTpD/xw2qH2xsDzch6MNH3H8PW58983FFpcmJzCksv4gnuNqUM8b4i5aDs5ynGFLIkUkVt0eJt3E5v/7HFRaqUpdB4Qc0JYC+OkcTCkNGYAizxjsyWFTdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786579778; c=relaxed/simple;
	bh=EuHtZ87x1ljNimARrMpzfU2RV5ISBPmGk2TQb0Qyu3w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=b6cpewksO2VcdO3PqeIEWD0ihb6joyOZyFrAkNVnPmbuZOx2dS/e/KWtNdzy//xP4hlZiKTWqr9KtKzSvFbey1QuOGcLJFIsUA4s36HL0YIMlVsBY5sun1GOLi34hRmznsYWsv8NwyTLw0jRMTZ6tlrZEK6rWvES9TdEb9VrK/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7e9dc0f5900so728863a34.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 17:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786579776; x=1787184576;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oNiJ8GOfUsqRQMoOAzytXiE/zC+9uK9EpwgD5iKmSnw=;
        b=laSBYWADRKjbVVUttSOikUKMiT/gwhGF7KKhfyj8i7B7iE4OPZfZwhzET4Qt/a22qd
         WVDJLHYTSeVXS8LFslNkk1UQG+kmxqRdF4a6sdaUqApyQMihhX5M03QFtMte3w/9t27F
         zviT3u8zExnjqfMy6FgElDTLpky9rP4v05joRbv2k2ClD3g3zaZyre3gyc2DF4CCp83x
         rSB4fwAUb3jm46qeFUn7GZPr13+0seJvViXKQrvubL848mrs5/s/cIDKRCK/DC07KymM
         juUSVMvRMAH7Rv5tU6oCeNrS0HwUkKPhMx1IBy7+ffNp4BX9buRccMnExxWoq1Hc0MrH
         ouBA==
X-Forwarded-Encrypted: i=1; AHgh+Rr7/VIRiW9QW5upyE8xkACIGToShh0/mTAa0uqNCRvkCWvqf8j3wPdTP2h2IOAlG3d7dxf1QDBmeMeC0MVJoA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3sW/69j6/FKQB+e/ti4W2GMSqDEt01sWdVsZErq+RNcsTH5HD
	fZjasbeW0gw2naqQs6di9nBVCBb6I8hpt3qll4AmPQKh1lEHb425KvbED4aiOOEvh3EBclpNqPs
	kQ8n1j+I+8wd4o6ZTREjNBCorEwuHpZneSZYj7Q/E4BGNxvh5I60PV0VNj0Q=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:201c:b0:69d:7fdb:3416 with SMTP id
 006d021491bc7-6b0c5cc7ea7mr1521275eaf.21.1786579775732; Wed, 12 Aug 2026
 17:09:35 -0700 (PDT)
Date: Wed, 12 Aug 2026 17:09:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7d0b3f.ac361c09.22ff0a.004d.GAE@google.com>
Subject: [syzbot] [wireless?] WARNING in drv_unassign_vif_chanctx (4)
From: syzbot <syzbot+63a84ea9c0f57d6133fa@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9a143525f62b Merge tag 'ata-7.2-rc7' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14adefb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aaf0da806f995318
dashboard link: https://syzkaller.appspot.com/bug?extid=63a84ea9c0f57d6133fa
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/36e9efe36a27/disk-9a143525.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cf7e7297c673/vmlinux-9a143525.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3ddbff8e1c81/bzImage-9a143525.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+63a84ea9c0f57d6133fa@syzkaller.appspotmail.com

------------[ cut here ]------------
wlan0: Failed check-sdata-in-driver check, flags: 0x0
WARNING: net/mac80211/driver-ops.c:366 at drv_unassign_vif_chanctx+0x498/0x7d0 net/mac80211/driver-ops.c:366, CPU#1: kworker/u8:33/10061
Modules linked in:
CPU: 1 UID: 0 PID: 10061 Comm: kworker/u8:33 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Workqueue: netns cleanup_net
RIP: 0010:drv_unassign_vif_chanctx+0x4e5/0x7d0 net/mac80211/driver-ops.c:366
Code: 8d 78 0a 00 00 48 8b 02 48 8d b0 20 01 00 00 48 85 c0 48 0f 44 f1 42 0f b6 44 3d 00 84 c0 0f 85 95 01 00 00 41 8b 16 48 89 df <67> 48 0f b9 3a e9 04 fd ff ff e8 6c 20 8d f6 90 0f 0b 90 e9 3d fe
RSP: 0018:ffffc9000d7ff090 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff90695800 RCX: ffff888037171938
RDX: 0000000000000000 RSI: ffff888037170120 RDI: ffffffff90695800
RBP: 1ffff11006e2e325 R08: ffffffff90574637 R09: 1ffffffff20ae8c6
R10: dffffc0000000000 R11: fffffbfff20ae8c7 R12: ffff888037172c70
R13: ffff888037170ec0 R14: ffff888037171928 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff888125055000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557e0c475950 CR3: 0000000051358000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 ieee80211_assign_link_chanctx+0x234/0xcd0 net/mac80211/chan.c:1199
 __ieee80211_link_release_channel+0x3c6/0x610 net/mac80211/chan.c:2176
 ieee80211_teardown_sdata+0xc1/0x240 net/mac80211/iface.c:916
 unregister_netdevice_many_notify+0x1acd/0x2140 net/core/dev.c:12467
 unregister_netdevice_many net/core/dev.c:12509 [inline]
 unregister_netdevice_queue+0x2f5/0x340 net/core/dev.c:12320
 unregister_netdevice include/linux/netdevice.h:3474 [inline]
 _cfg80211_unregister_wdev+0x156/0x5a0 net/wireless/core.c:1422
 ieee80211_remove_interfaces+0x49c/0x6a0 net/mac80211/iface.c:2492
 ieee80211_unregister_hw+0x5d/0x2c0 net/mac80211/main.c:1718
 mac80211_hwsim_del_radio+0x28a/0x4a0 drivers/net/wireless/virtual/mac80211_hwsim_main.c:6226
 hwsim_exit_net+0xe8e/0xf50 drivers/net/wireless/virtual/mac80211_hwsim_main.c:7207
 ops_exit_list net/core/net_namespace.c:199 [inline]
 ops_undo_list+0x43d/0x8d0 net/core/net_namespace.c:252
 cleanup_net+0x572/0x810 net/core/net_namespace.c:702
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess):
   0:	8d 78 0a             	lea    0xa(%rax),%edi
   3:	00 00                	add    %al,(%rax)
   5:	48 8b 02             	mov    (%rdx),%rax
   8:	48 8d b0 20 01 00 00 	lea    0x120(%rax),%rsi
   f:	48 85 c0             	test   %rax,%rax
  12:	48 0f 44 f1          	cmove  %rcx,%rsi
  16:	42 0f b6 44 3d 00    	movzbl 0x0(%rbp,%r15,1),%eax
  1c:	84 c0                	test   %al,%al
  1e:	0f 85 95 01 00 00    	jne    0x1b9
  24:	41 8b 16             	mov    (%r14),%edx
  27:	48 89 df             	mov    %rbx,%rdi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 04 fd ff ff       	jmp    0xfffffd38
  34:	e8 6c 20 8d f6       	call   0xf68d20a5
  39:	90                   	nop
  3a:	0f 0b                	ud2
  3c:	90                   	nop
  3d:	e9                   	.byte 0xe9
  3e:	3d                   	.byte 0x3d
  3f:	fe                   	.byte 0xfe


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
