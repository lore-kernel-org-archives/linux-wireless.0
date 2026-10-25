Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792921362;
	b=kM+QdpjJT+p/aiCljYlddsOgfkuXTHI0K0BZsrlLbdUi3cYvf0uwYECY0jos6M0fLsMA
	 XdjOCs5u7h3X2W7vDWCfShtjh9+1Fp6Nh9bqUevidH15vqgz/xugPHEl14+NiCe3TNM2f
	 cFkdLTbnHGP6p4+nBYdZd26oVuAslNJhbS3qQA7OQRoh4j9PykTv0LvfCC81MMbYcFgwx
	 V30QcPI8BhMZmw/XvCO6SeXAtP4wrMOt1JXziQXkGXhaKBgwhrd5Ohls684Zs3vnDhyyN
	 RS8E/W3p8cA+athj54CsGZdQyvpirr3TcdPAK0oEwe2PZ1d8jMTp2K0HvENdGFVXSTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792921362;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=f5z7gJoDVOOZ5z/Ou45lA/nPBYXpeSYEhWs1uILW6Dg=;
	b=jm3zcIsDIb13zJ1fwzciA9bmPRLoWP/bHYNRTCcUQ59eAtCZFzvH8qWc6dAN4KIwm5by
	 pyt63Jb61BWlW5mY+lfkaxANXR7327SQJMbsv6nrZrQb8ha0NSQpTTEOkQYc/sm+3PC3A
	 yOX7ppz09a7dSbWDrju3DCVnNedJ04Q8AZP6lKdsbS5GpkrossnH+5d7tYCzBTIX3JX7I
	 qqamJT3HxtU4Cf6lMY0YZcsfk14lZMCEv5ESiMGDebU1cvWGu11mgAm5AXgcB0x+rvqZD
	 9QU9QCyYwshieMVhGMfI2ZkA83dGDN5b1gcrTREjUS08ctC+VmdMXEqgJIcfVjOC+RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF009606A31B
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 09:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF009606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-5384e381fbbso2082549b6e.2
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 02:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792921361; x=1793526161;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f5z7gJoDVOOZ5z/Ou45lA/nPBYXpeSYEhWs1uILW6Dg=;
        b=kMCihA8KlJ5PSjCiZL2TD2amsEzIlLwoBI5/pIKzNSlohD7i2RuQCYkQE4Vop0QWhX
         u78XLoKW6xu9iKzoaevE95LwtumuFpAXmxt0fu32htm6Mo68QvFm9VrDLwsNa7p5iTpB
         24o1BsiUBUSYxVldQ0t7LP5AuNyHvEbFV3E9PZZ+bHX7i3/MqPmBbPrHLv0hlUkSmHmv
         FsjcTbEO0YoW6Av60gmLG2qHEajxF6x+rWei+dHuXjAmfJUYx8Bws+M1sf7ylyB6CDem
         TMlVvtGdkHaRpP39dSaJSMbQYoMr7QaGcoJzq//1OvhLE8ePJyY+i07SC5ZTW/YBkI+E
         nDuA==
X-Forwarded-Encrypted: i=1; AKwUvBzr2kxVGKphQGHZ/KpcdwK8zAHAj+nJRL4Li+6IAKG2EDQ/+2Xa5Pedp6kECe9lZAjPTjyp/ePp/H91Ic++ag==@vger.kernel.org
X-Gm-Message-State: AFq9FYJhzcMi/zn/fUscA29cYhmfQA47jDBayOJNNgvjtV8JSkGJWWJS
	8UKXB89ZyashPQjF94BJ5xHGeOfcDfCpr+gTqeb/1rwtAmbyd7HzjJArMeV2u/erItB0YVJGTT2
	ss07r8LcTk8bZeNuXdPP60sTca1FibRFjRbGxov4aTRUk7uZERHsdKEi77h8=
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:191a:b0:4f4:4de8:9376 with SMTP id
 5614622812f47-55c00321b32mr2301247b6e.54.1792921360826; Sun, 25 Oct 2026
 02:42:40 -0700 (PDT)
Date: Sun, 25 Oct 2026 02:42:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6addcf10.4ce6c07b.2dfc0c.0009.GAE@google.com>
Subject: [syzbot] [wireless?] WARNING in ieee80211_queue_skb
From: syzbot <syzbot+c38f93f387ac25eabf68@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    20a33c6b6cbe Add linux-next specific files for 20261023
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
console output: https://syzkaller.appspot.com/x/log.txt?x=15cf1aa5580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82b79abce6d1b17c
dashboard link: https://syzkaller.appspot.com/bug?extid=c38f93f387ac25eabf68
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117f4d8e580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c38f93f387ac25eabf68@syzkaller.appspotmail.com

------------[ cut here ]------------
syzkaller0: Failed check-sdata-in-driver check, flags: 0x0
WARNING: net/mac80211/driver-ops.h:1380 at drv_wake_tx_queue net/mac80211/driver-ops.h:1380 [inline], CPU#1: syz-executor116/6060
WARNING: net/mac80211/driver-ops.h:1380 at schedule_and_wake_txq net/mac80211/driver-ops.h:1391 [inline], CPU#1: syz-executor116/6060
WARNING: net/mac80211/driver-ops.h:1380 at ieee80211_queue_skb+0x1cb4/0x22e0 net/mac80211/tx.c:1729, CPU#1: syz-executor116/6060
Modules linked in:
CPU: 1 UID: 0 PID: 6060 Comm: syz-executor116 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
RIP: 0010:drv_wake_tx_queue net/mac80211/driver-ops.h:1380 [inline]
RIP: 0010:schedule_and_wake_txq net/mac80211/driver-ops.h:1391 [inline]
RIP: 0010:ieee80211_queue_skb+0x1cfc/0x22e0 net/mac80211/tx.c:1729
Code: 00 00 48 85 c0 4c 0f 44 e5 48 b8 00 00 00 00 00 fc ff df 41 0f b6 44 05 00 84 c0 0f 85 6d 04 00 00 41 8b 16 4c 89 ff 4c 89 e6 <67> 48 0f b9 3a 49 bf 00 00 00 00 00 fc ff df e9 b5 fa ff ff e8 bb
RSP: 0018:ffffc90003316f70 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88805ac32d90 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffff88805ac30120 RDI: ffffffff91d2d970
RBP: ffff88805ac319f0 R08: ffffffff91c0abbf R09: 1ffffffff2381577
R10: dffffc0000000000 R11: fffffbfff2381578 R12: ffff88805ac30120
R13: 1ffff1100b58633c R14: ffff88805ac319e0 R15: ffffffff91d2d970
FS:  00007f837dd626c0(0000) GS:ffff88812347c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f837e562ff8 CR3: 0000000013544000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __ieee80211_xmit_fast+0x8ea/0x2160 net/mac80211/tx.c:3862
 ieee80211_xmit_fast net/mac80211/tx.c:3930 [inline]
 __ieee80211_subif_start_xmit+0x1367/0x1840 net/mac80211/tx.c:4489
 ieee80211_subif_start_xmit+0xee/0x560 net/mac80211/tx.c:4726
 __netdev_start_xmit include/linux/netdevice.h:5455 [inline]
 netdev_start_xmit include/linux/netdevice.h:5464 [inline]
 xmit_one net/core/dev.c:4057 [inline]
 dev_hard_start_xmit+0x2cd/0x830 net/core/dev.c:4073
 __dev_queue_xmit+0x14d1/0x3920 net/core/dev.c:5066
 packet_snd net/packet/af_packet.c:3157 [inline]
 packet_sendmsg+0x3f1b/0x51b0 net/packet/af_packet.c:3189
 sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
 __sock_sendmsg net/socket.c:818 [inline]
 __sys_sendto+0x408/0x5a0 net/socket.c:2283
 __do_sys_sendto net/socket.c:2290 [inline]
 __se_sys_sendto net/socket.c:2286 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2286
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f837e5c51de
Code: 08 0f 85 f5 e2 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 90 41 57 41 56 4d 89 c6 41 55 4d 89 cd 41 54 55 53 48 83 ec 08
RSP: 002b:00007f837dd620b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f837dd626c0 RCX: 00007f837e5c51de
RDX: 000000000000003c RSI: 00007f837dd62140 RDI: 0000000000000004
RBP: 00007f837dd62120 R08: 00007f837dd62120 R09: 0000000000000014
R10: 0000000000000040 R11: 0000000000000246 R12: 00007f837dd62180
R13: 0000000000000013 R14: 00007ffe6cb13b50 R15: 00007ffe6cb13c38
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	48 85 c0             	test   %rax,%rax
   5:	4c 0f 44 e5          	cmove  %rbp,%r12
   9:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  10:	fc ff df
  13:	41 0f b6 44 05 00    	movzbl 0x0(%r13,%rax,1),%eax
  19:	84 c0                	test   %al,%al
  1b:	0f 85 6d 04 00 00    	jne    0x48e
  21:	41 8b 16             	mov    (%r14),%edx
  24:	4c 89 ff             	mov    %r15,%rdi
  27:	4c 89 e6             	mov    %r12,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
  36:	fc ff df
  39:	e9 b5 fa ff ff       	jmp    0xfffffaf3
  3e:	e8                   	.byte 0xe8
  3f:	bb                   	.byte 0xbb


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
