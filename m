Received: from mail-oa1-f79.google.com (mail-oa1-f79.google.com [209.85.160.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5C1184540
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 00:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786060897; cv=none; b=spyRj/khR281gKER9VUvs4+XedJkt9pskiD6GzvGCtJ0bmRT0WGIO0y2CVCiSj8tOU/M/CssCH/B/ruBL8YINVwlta7Gnyufrh/UKk74RCjBBsxNFSAEnyIxLqoBBrf4eNNqMoj//s3NySAEp13SGkHEvBFFiQOwB5jqNOHxgS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786060897; c=relaxed/simple;
	bh=1bJWVyeZnRuOuHntp7+lTeu0y4ITdPXkHSJVDH6DNUk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TWhYe9CkFFo39zSoh0MnrV9gpwaJMOTLyashPzQZxqn3MevSswoKD5adDM8UOhHekRAFzgT9KEnRoxxtPbNMmqIMQA0+27ffk/eq+hj0kV/xuOFJJKIVDeEXeKAx77n4A4IIva3DCJ6h+7UdK4eYMnJ3WLXVJTH3yM6qu40Y7+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f79.google.com with SMTP id 586e51a60fabf-4488f192768so2293997fac.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 17:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786060893; x=1786665693;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JhlxfeYKuuhGGTKptt6/0FUkLSlB4juTWmeosV4wFr8=;
        b=Gy5SVJq/IYVy6u+Ag05AlGSkhINeoQ158Mx67idQStKD/mjqnqYDS0huJEjAHJaW+8
         o3DBktEcpNJuc3yaSuCIOfUk85UWk8YgDhEVa7AGxsdFKqHGqvgui+ZNSU/baq+xdVt1
         xXj79k1bbsaoEQPm3a+Xit2C3N200MEcHhNDi3/BPTZGEhSLYOZxApA2sgHM6uW1/Z2M
         m0F64UHCMPyFTZ31hSmBuiruqGIpgsqZL8b/L9MzGerRna4XqlJsvJGy655MHYtmJur+
         brAhvnvmu649KhgCoIVAAmhifXGOyEB0NakOM5pJguY6ku7gNFGGpFeZGoTq2K++a8WZ
         zfnA==
X-Forwarded-Encrypted: i=1; AHgh+RpG3SKhpT0xCUteSGq2JL3bvoa/sshZ/7T94Ft2jVeGXlayGSFKmfmFzOXTl+1P18/oBAsEpmXi032qrYHsUA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/gCAs+7s6uxWH6MCyXje9yNVaXTjsLWUVqqxBUFgrUCgEnVKx
	HfJqnWfFsmmWSdQViLzSX66ba6ZZ7nRSmGeCCHtym/1uVE3a3KGSjdY1NnAx2SO9m/1FPlvowB9
	fgoRzCY76cr6Tu2mKOwAMBu0I4xvifrd8CeIeEVIMJeN5bvbJuPNwqXadBj8=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee0a:0:b0:6ae:6f38:dac with SMTP id
 006d021491bc7-6ae96c8490emr9917601eaf.10.1786060893028; Thu, 06 Aug 2026
 17:01:33 -0700 (PDT)
Date: Thu, 06 Aug 2026 17:01:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a75205d.01d0871a.3a0d52.0034.GAE@google.com>
Subject: [syzbot] [wireless?] WARNING in cfg80211_wext_siwrate
From: syzbot <syzbot+af177aa139efdd13a9da@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    31a420a822ff bpf: Check sk_state before sk_protocol in bpf..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=14370132580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e38b15c29e6a1d9
dashboard link: https://syzkaller.appspot.com/bug?extid=af177aa139efdd13a9da
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/180a2e05da8a/disk-31a420a8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7e4b97c130ad/vmlinux-31a420a8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/589c3b9f04af/bzImage-31a420a8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+af177aa139efdd13a9da@syzkaller.appspotmail.com

------------[ cut here ]------------
wlan1: Failed check-sdata-in-driver check, flags: 0x0
WARNING: net/mac80211/driver-ops.h:884 at drv_set_bitrate_mask net/mac80211/driver-ops.h:884 [inline], CPU#1: syz.1.7134/31079
WARNING: net/mac80211/driver-ops.h:884 at ieee80211_set_bitrate_mask+0x1034/0x1320 net/mac80211/cfg.c:4134, CPU#1: syz.1.7134/31079
Modules linked in:
CPU: 1 UID: 0 PID: 31079 Comm: syz.1.7134 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:drv_set_bitrate_mask net/mac80211/driver-ops.h:884 [inline]
RIP: 0010:ieee80211_set_bitrate_mask+0x1084/0x1320 net/mac80211/cfg.c:4134
Code: 20 01 00 00 48 85 c0 49 0f 44 ee 48 b8 00 00 00 00 00 fc ff df 0f b6 04 03 84 c0 0f 85 3b 01 00 00 41 8b 17 4c 89 ef 48 89 ee <67> 48 0f b9 3a e9 c3 fd ff ff e8 ad 3b 82 f6 90 0f 0b 90 e9 41 fe
RSP: 0018:ffffc90004457778 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff11006ac0325 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffff888035600120 RDI: ffffffff9069c4f0
RBP: ffff888035600120 R08: ffff888069d60faf R09: 1ffff1100d3ac1f5
R10: dffffc0000000000 R11: ffffed100d3ac1f6 R12: ffff888069d60740
R13: ffffffff9069c4f0 R14: ffff888035601938 R15: ffff888035601928
FS:  00007f1ff74ce6c0(0000) GS:ffff888125050000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2f81aff8 CR3: 000000007c55c000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 <TASK>
 rdev_set_bitrate_mask net/wireless/rdev-ops.h:683 [inline]
 cfg80211_wext_siwrate+0x78d/0x9d0 net/wireless/wext-compat.c:1238
 ioctl_standard_call+0xc5/0x160 net/wireless/wext-core.c:1042
 wireless_process_ioctl net/wireless/wext-core.c:-1 [inline]
 wext_ioctl_dispatch+0xee/0x410 net/wireless/wext-core.c:1013
 wext_handle_ioctl+0x110/0x1d0 net/wireless/wext-core.c:1074
 sock_ioctl+0x159/0x7e0 net/socket.c:1353
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1ff659e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1ff74ce028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f1ff6825fa0 RCX: 00007f1ff659e0d9
RDX: 0000200000000040 RSI: 0000000000008b20 RDI: 0000000000000008
RBP: 00007f1ff6635024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1ff6826038 R14: 00007f1ff6825fa0 R15: 00007ffebb92fee8
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
  34:	e8 ad 3b 82 f6       	call   0xf6823be6
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
