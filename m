Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E23D2E54D3
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 00:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785543146; cv=none; b=XoyR/RiktULAlkooOnNDSoLYsj57cjD/nDDwp06rMhtNti+dAKm9s1Tqv8jAQdwMhyq9ywXeDnwc+gRdijOmU/riZlMyjZhISVeRhl/xC050DLgwUOf1uIL37YIocsl/tUFSil3aD/WkFrrNbUi7D5Cw5kTSDZuThjk/2FESI8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785543146; c=relaxed/simple;
	bh=w4Gf0Oi8oLHLr8WMFMmtEBIFvNGvAtEbopMHFcRkT3Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KJ/CzYFEzlYUTGY/Dm9N1zcLmkibErvEAZWn+XZlcW5fkCnOHfwzm8H0VcfeMRDMQKkEtm01gfsQoSmQKU04kHZ0ucvAQWBXiR2Aduai33XgA6kGC2nIT8PScQ1bJ9k01VD1tGUiS7kZO9uHC5kM6pPuVBUGADL4/0mQUYYdcMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-4959c49e054so1002541b6e.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 17:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785543143; x=1786147943;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MXgOcXPNnQ3xzqWo+dwxHto1GQpPYlWGt2X6T3gWApQ=;
        b=dXVBd8AE4/pH8loHNDift68LPAwIJcrRAwNDsgfYcxpeUuiWtIf2wWWfBam5W6uYkl
         rEOOyOkBxJfnjNsEjg4ygG4ryOl8vumGPcRfCU7IEXRbztc4+Z+vBrGn2ontlddnShqS
         B/lXj1WztD5IGsu6Xb1Tn16G4S4L23cootMyG6dAHelFqRABZq8fUYz8odZjVBOYnAUO
         qelUQCsLQbzOUJuAwNrhYDb5G/FeUoXsMeXySBq6Nn1W+ZZGeB3/RXiHoP+AHXEjwM5U
         hmSKbuL6fzPRW5JpwZlvLResZkPJ/tIfsEv1+13v9CmLvvGy2dgfPfguXMjcBr0ISqgl
         18tg==
X-Forwarded-Encrypted: i=1; AHgh+RrK5D2sCC65g2mHtUZ5aYg7OuFzTI6MDa2/oYXmv9R9tBxGBnO7Ui3eNXgK/QOPREeGLPb6rLM35W8Lm/1rxg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxceN2V2jWbRccFOt6n8a/Zh1ItD77CjtdQ1E2SA2ncflY7QuQd
	xYHcOiUnBCrDFqTaQKrmMKYf3SDvA99/5AO9y2y/OBXYWnJgAKn37u+ZoU+AKzeHigScZwv1hsq
	UVB5DsclCCEwl2Y21VM+RZY+NXTrNyaRyhn2OcQBC1+NHhVdw0qX8Z/i5nrw=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c3ee:b0:496:11f1:f2b5 with SMTP id
 5614622812f47-4af5e1b817bmr4405907b6e.10.1785543142970; Fri, 31 Jul 2026
 17:12:22 -0700 (PDT)
Date: Fri, 31 Jul 2026 17:12:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6d39e6.f794c993.27aeb.0008.GAE@google.com>
Subject: [syzbot] [wireless?] BUG: unable to handle kernel paging request in trace_event_raw_event_drv_net_setup_tc
From: syzbot <syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8ba098e6b6ff Merge tag 'v7.2-rc5-smb3-client-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f84c9e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
dashboard link: https://syzkaller.appspot.com/bug?extid=f1ba58d6b55abd13239e
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/db1d2f27959e/disk-8ba098e6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2eacbf7835c3/vmlinux-8ba098e6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/de833d39bd28/bzImage-8ba098e6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: fffffffffffffc10
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD e997067 P4D e997067 PUD e999067 PMD 0 
Oops: Oops: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 15892 Comm: syz.5.2483 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:strnlen+0x4b/0x80 lib/string.c:414
Code: 49 89 fc 48 89 f8 eb 09 48 83 c0 01 48 39 e8 74 1e 48 89 c2 48 89 c1 48 c1 ea 03 83 e1 07 0f b6 14 1a 38 ca 7f 04 84 d2 75 15 <80> 38 00 75 d9 4c 29 e0 48 83 c4 08 5b 5d 41 5c e9 40 87 07 00 48
RSP: 0018:ffffc900071ef120 EFLAGS: 00010246
RAX: fffffffffffffc10 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000010 RDI: fffffffffffffc10
RBP: fffffffffffffc20 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: fffffffffffffc10
R13: ffff88801bcc3e00 R14: 0000000000000006 R15: 0000000000000010
FS:  00007faa1ab866c0(0000) GS:ffff888123dda000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffc10 CR3: 0000000025e0b000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 strnlen include/linux/fortify-string.h:183 [inline]
 __fortify_strlen include/linux/fortify-string.h:219 [inline]
 trace_event_get_offsets_drv_net_setup_tc net/mac80211/trace.h:2539 [inline]
 do_trace_event_raw_event_drv_net_setup_tc net/mac80211/trace.h:2539 [inline]
 trace_event_raw_event_drv_net_setup_tc+0x100/0x5d0 net/mac80211/trace.h:2539
 __do_trace_drv_net_setup_tc net/mac80211/trace.h:2539 [inline]
 trace_drv_net_setup_tc net/mac80211/trace.h:2539 [inline]
 drv_net_setup_tc net/mac80211/driver-ops.h:1706 [inline]
 ieee80211_netdev_setup_tc+0x2c6/0x3e0 net/mac80211/iface.c:938
 tcf_block_offload_cmd.isra.0+0x1c4/0x310 net/sched/cls_api.c:838
 tcf_block_offload_bind net/sched/cls_api.c:875 [inline]
 tcf_block_get_ext+0x7ed/0x1950 net/sched/cls_api.c:1498
 tcf_block_get+0xa8/0x100 net/sched/cls_api.c:1543
 hfsc_init_qdisc+0x154/0x420 net/sched/sch_hfsc.c:1413
 qdisc_create+0x47b/0x1060 net/sched/sch_api.c:1337
 __tc_modify_qdisc net/sched/sch_api.c:1771 [inline]
 tc_modify_qdisc+0xdcf/0x2120 net/sched/sch_api.c:1835
 rtnetlink_rcv_msg+0x3c9/0xe90 net/core/rtnetlink.c:7085
 netlink_rcv_skb+0x159/0x420 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x585/0x850 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x8b0/0xda0 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:775 [inline]
 __sock_sendmsg net/socket.c:790 [inline]
 ____sys_sendmsg+0xa4d/0xbe0 net/socket.c:2684
 ___sys_sendmsg+0x190/0x1e0 net/socket.c:2738
 __sys_sendmsg+0x160/0x210 net/socket.c:2770
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faa19d9e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faa1ab86028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007faa1a025fa0 RCX: 00007faa19d9e019
RDX: 0000000000000000 RSI: 00002000000008c0 RDI: 0000000000000004
RBP: 00007faa19e3500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007faa1a026038 R14: 00007faa1a025fa0 R15: 00007ffd20378ea8
 </TASK>
Modules linked in:
CR2: fffffffffffffc10
---[ end trace 0000000000000000 ]---
RIP: 0010:strnlen+0x4b/0x80 lib/string.c:414
Code: 49 89 fc 48 89 f8 eb 09 48 83 c0 01 48 39 e8 74 1e 48 89 c2 48 89 c1 48 c1 ea 03 83 e1 07 0f b6 14 1a 38 ca 7f 04 84 d2 75 15 <80> 38 00 75 d9 4c 29 e0 48 83 c4 08 5b 5d 41 5c e9 40 87 07 00 48
RSP: 0018:ffffc900071ef120 EFLAGS: 00010246
RAX: fffffffffffffc10 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000010 RDI: fffffffffffffc10
RBP: fffffffffffffc20 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: fffffffffffffc10
R13: ffff88801bcc3e00 R14: 0000000000000006 R15: 0000000000000010
FS:  00007faa1ab866c0(0000) GS:ffff888123dda000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffc10 CR3: 0000000025e0b000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	49 89 fc             	mov    %rdi,%r12
   3:	48 89 f8             	mov    %rdi,%rax
   6:	eb 09                	jmp    0x11
   8:	48 83 c0 01          	add    $0x1,%rax
   c:	48 39 e8             	cmp    %rbp,%rax
   f:	74 1e                	je     0x2f
  11:	48 89 c2             	mov    %rax,%rdx
  14:	48 89 c1             	mov    %rax,%rcx
  17:	48 c1 ea 03          	shr    $0x3,%rdx
  1b:	83 e1 07             	and    $0x7,%ecx
  1e:	0f b6 14 1a          	movzbl (%rdx,%rbx,1),%edx
  22:	38 ca                	cmp    %cl,%dl
  24:	7f 04                	jg     0x2a
  26:	84 d2                	test   %dl,%dl
  28:	75 15                	jne    0x3f
* 2a:	80 38 00             	cmpb   $0x0,(%rax) <-- trapping instruction
  2d:	75 d9                	jne    0x8
  2f:	4c 29 e0             	sub    %r12,%rax
  32:	48 83 c4 08          	add    $0x8,%rsp
  36:	5b                   	pop    %rbx
  37:	5d                   	pop    %rbp
  38:	41 5c                	pop    %r12
  3a:	e9 40 87 07 00       	jmp    0x7877f
  3f:	48                   	rex.W


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
