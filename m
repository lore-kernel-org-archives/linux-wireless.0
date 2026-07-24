Received: from mail-oa1-f80.google.com (mail-oa1-f80.google.com [209.85.160.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06739361950
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930208; cv=none; b=uws/wr1YY86SLL4Pqm4v0h49lSoE3L9TTglDGrfH5gGPG22/fdLab1MKgrzPimbhEfyrSjevCa0FmzYNbSG22Zkp4VGtN/8lQsrnMgk9X6QVDgx93NWs7o7bcSW5Uq27j+8usY1vKVlTKZ7RAf0B4qbVdor1OU7Vct1SgPtKYGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930208; c=relaxed/simple;
	bh=4c1v2gKPJxoxMfqQsm1l2KpljohrD/R5BLwT+y9B9P0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=t+Yx35IzPNc2kHs1IwKF00xooLvd/yY4lbOgSI+ZF3CLXLOBIgKvD5fwiUSkX8aMvFS4AycSifnHnh+fAOSVoQDxdyOrBuLy5pRiD4vxkJrk3owSuQpNkm6+TJxTi+3iMgpV/shi8UyyScHreE4xGc0+52A6RmsbePmWxfmr9js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f80.google.com with SMTP id 586e51a60fabf-44d0960fb5bso347096fac.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 14:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930199; x=1785534999;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QjVWOREysRIlXu+WlAK/dydMJtIiJmW7TsOBc9IpceY=;
        b=iti5uKHOEwUWX1Sq2B1jDwSTX27kIlMCPp8zVFmtHYb1jDCWtesd50Zdv8NtBgPrWY
         RSEGYhe8KgyEbH3dNPhK8iyrzRCVGCkuOKmQziC+vEebq3cqD+Og5B9dP7RB0/UlbwaG
         I/ZRgkSFT4mlaKvsYejzneCBy+suGFElgPbUPMawaOyrRvA97qRXUA7VKin4B00gKjGq
         Q2cqp+B2fe9EDKnH4R4TeAfqin0syGjlPUbzfWKqHrAzx1nVAxsHasqmvwtSvKcOBdxg
         sWasArQRDoj1T2XVP+BiBf8KLNN4s2fFSllh8riXAWfGdQ0eotZ4n6ce2lBskgcq0j+I
         YSUw==
X-Forwarded-Encrypted: i=1; AHgh+RoIW30mAiJ/SkFTC8Q8kVW1fuA5e66n0anDts105tIFxUk/7mV6uCyR0ocoD4jpKxZ4PLPF6O2jx69PLFS36g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzles0W7xRTQIfkgLo02wNUiRuY1s3dSrPy/zO48/JQlYv6DHxZ
	ZdRISwe7CvyDRRuCyYtCTXnAjUBPrcJAE/abo9m6C4gzX6FU6SP52R4n77FdYab3v08yukxyMrG
	ogbwk0HiSNs9WsQVbYrqCLaH+zmPQusZpOP9WTfLrAkeE8VQo57APE5prqQw=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6b47:b0:492:9376:433a with SMTP id
 5614622812f47-4ab6a1866c8mr239316b6e.37.1784930199449; Fri, 24 Jul 2026
 14:56:39 -0700 (PDT)
Date: Fri, 24 Jul 2026 14:56:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a63df97.a2ea2cc8.fbad6.000a.GAE@google.com>
Subject: [syzbot] [wireless?] WARNING in nl80211_set_tx_bitrate_mask
From: syzbot <syzbot+dcaca020ca8377e7ced0@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e13caf1c2658 Merge tag 'net-7.2-rc4' of git://git.kernel.o..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12e732b9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c4196ba0e33631d
dashboard link: https://syzkaller.appspot.com/bug?extid=dcaca020ca8377e7ced0
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b71ec6e89047/disk-e13caf1c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e865a2cae4e9/vmlinux-e13caf1c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1cd52838b32f/bzImage-e13caf1c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dcaca020ca8377e7ced0@syzkaller.appspotmail.com

------------[ cut here ]------------
wlan0: Failed check-sdata-in-driver check, flags: 0x0
WARNING: net/mac80211/driver-ops.h:884 at drv_set_bitrate_mask net/mac80211/driver-ops.h:884 [inline], CPU#0: syz.3.1244/10657
WARNING: net/mac80211/driver-ops.h:884 at ieee80211_set_bitrate_mask+0x1034/0x1320 net/mac80211/cfg.c:4131, CPU#0: syz.3.1244/10657
Modules linked in:
CPU: 0 UID: 0 PID: 10657 Comm: syz.3.1244 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/25/2026
RIP: 0010:drv_set_bitrate_mask net/mac80211/driver-ops.h:884 [inline]
RIP: 0010:ieee80211_set_bitrate_mask+0x1084/0x1320 net/mac80211/cfg.c:4131
Code: 20 01 00 00 48 85 c0 49 0f 44 ee 48 b8 00 00 00 00 00 fc ff df 0f b6 04 03 84 c0 0f 85 3b 01 00 00 41 8b 17 4c 89 ef 48 89 ee <67> 48 0f b9 3a e9 c3 fd ff ff e8 fd a2 82 f6 90 0f 0b 90 e9 41 fe
RSP: 0018:ffffc90005adeff8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff1100ac7fb25 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffff8880563fc120 RDI: ffffffff9069bb20
RBP: ffff8880563fc120 R08: ffff8880527d0faf R09: 1ffff1100a4fa1f5
R10: dffffc0000000000 R11: ffffed100a4fa1f6 R12: ffff8880527d0740
R13: ffffffff9069bb20 R14: ffff8880563fd938 R15: ffff8880563fd928
FS:  00007f230a4956c0(0000) GS:ffff888124f54000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f340e3fe9b0 CR3: 00000000590f6000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 rdev_set_bitrate_mask net/wireless/rdev-ops.h:683 [inline]
 nl80211_set_tx_bitrate_mask+0x30b/0x4f0 net/wireless/nl80211.c:14541
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
 __sock_sendmsg net/socket.c:790 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
 __sys_sendmsg net/socket.c:2770 [inline]
 __do_sys_sendmsg net/socket.c:2775 [inline]
 __se_sys_sendmsg net/socket.c:2773 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f230959de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f230a495028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f2309825fa0 RCX: 00007f230959de99
RDX: 0000000000000000 RSI: 0000200000000280 RDI: 0000000000000005
RBP: 00007f2309633eaf R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2309826038 R14: 00007f2309825fa0 R15: 00007ffc28746ce8
 </TASK>
----------------
Code disassembly (best guess):
   0:	20 01                	and    %al,(%rcx)
   2:	00 00                	add    %al,(%rax)
   4:	48 85 c0             	test   %rax,%rax
   7:	49 0f 44 ee          	cmove  %r14,%rbp
   b:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  12:	fc ff df
  15:	0f b6 04 03          	movzbl (%rbx,%rax,1),%eax
  19:	84 c0                	test   %al,%al
  1b:	0f 85 3b 01 00 00    	jne    0x15c
  21:	41 8b 17             	mov    (%r15),%edx
  24:	4c 89 ef             	mov    %r13,%rdi
  27:	48 89 ee             	mov    %rbp,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 c3 fd ff ff       	jmp    0xfffffdf7
  34:	e8 fd a2 82 f6       	call   0xf682a336
  39:	90                   	nop
  3a:	0f 0b                	ud2
  3c:	90                   	nop
  3d:	e9                   	.byte 0xe9
  3e:	41                   	rex.B
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
