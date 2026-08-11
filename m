Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7CB36604B
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 23:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786489359; cv=none; b=rZCzBLxwCDzBDTR3GGXxNazAiVdYGIbV73kZ8uz5g77MEFDVUV+LuZ3/f+QWci2SUzCSZUAgaiJixkS9X/sF/v8m8z5mqBawSdnCaqYq1J2TpMMRsTsRl62M0fu9xoj+hqB6N1KDbf2Nttb4IKNhFMlGoRJqQv9ocw3YYLq2OIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786489359; c=relaxed/simple;
	bh=JWfz3N9p+DwGtlRDiRt0bWUN5/eApv5erg4PtvzoktM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=K+JjW+Soh7Il9wS2T+omINNW4/iqO+n1rhcFlqvcku/nbGRQdvll5NMTSMlNzbJSNzxT7yDNKEnVjwlbv4t1cwqOX2Q/QoCQJ9awkUxix3SyiB/80g+qYWxof/7KOcwjMVfgCBH/yAlk8+t2nfhcw5fBmFa48ne7DtsK5Mtf6nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b1bc2e44e0so465494b6e.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 16:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786489356; x=1787094156;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j20kJlfkURuQ6BGGoc+GOavXDcLdI7raGOg+xVB+VPU=;
        b=Vi4TbqyWwUWwhSFDUu0c8ZkeH1/no1sCVtppLYLtEcEViNQNiETj6IdBzoMw7DbBcP
         mQdsISPmObzZ/PIeAI+MsHhzucpQMErB1rjiG49hZNGCKuqFfhwNGKfDYIDaGFyfMJF8
         m0GLIOKDBkJkto4/uC28cOns8dSKRXz0R4fzvX8UL//liHFTYXfGnmJzz5SW0GW0CJeR
         YnwpjEVCl2ou4oTBM4qQ13oXn8W1D4SvEItko6mxfU6+5ievCUMMuj9IB7LljprLITUl
         YnWe90/pcQu8oxsARiypZ+lGaVTU/bj0RoOfSEijFKUxneLj5dYqGxYl8GIdEGQUWCqY
         SVsw==
X-Forwarded-Encrypted: i=1; AHgh+Rr5/gdFBN+1xHXJTtAHd5nmfMs7IktuDWhKoH3AlDqrO8VMBDuijozp2kckYSKK6xElBmZCx+wAXSV3wPHTQg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxnmmigcVjlciC4LHhaBeu7jjhcpLIOgvnr33uAIH+fHL7yvVXj
	hfP5Ir2Amu/3l8buXLKs2eLzbhFMxAPGM8cfVxnXTWLiUSovFc7djDsmI2L7DZiflsGZeciIT26
	WgL3w29sXkcoZMHYrh6SjSVmgqzzv9qdWCuVM64pOAFUe9bWGSiJuPcWcP3s=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f0b:b0:495:c607:b13d with SMTP id
 5614622812f47-4b210968491mr816378b6e.2.1786489356698; Tue, 11 Aug 2026
 16:02:36 -0700 (PDT)
Date: Tue, 11 Aug 2026 16:02:36 -0700
In-Reply-To: <6a75205d.01d0871a.3a0d52.0034.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7baa0c.d5f0ebe7.22d851.0002.GAE@google.com>
Subject: Re: [syzbot] [wireless?] WARNING in cfg80211_wext_siwrate
From: syzbot <syzbot+af177aa139efdd13a9da@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    a13307e97d5c Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=1186e149580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aaf0da806f995318
dashboard link: https://syzkaller.appspot.com/bug?extid=af177aa139efdd13a9da
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1077e479580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+af177aa139efdd13a9da@syzkaller.appspotmail.com

warning: `syz-executor384' uses wireless extensions which will stop working for Wi-Fi 7 hardware; use nl80211
------------[ cut here ]------------
wlan3: Failed check-sdata-in-driver check, flags: 0x0
WARNING: net/mac80211/driver-ops.h:884 at drv_set_bitrate_mask net/mac80211/driver-ops.h:884 [inline], CPU#1: syz-executor384/5956
WARNING: net/mac80211/driver-ops.h:884 at ieee80211_set_bitrate_mask+0x1034/0x1320 net/mac80211/cfg.c:4134, CPU#1: syz-executor384/5956
Modules linked in:
CPU: 1 UID: 0 PID: 5956 Comm: syz-executor384 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:drv_set_bitrate_mask net/mac80211/driver-ops.h:884 [inline]
RIP: 0010:ieee80211_set_bitrate_mask+0x1084/0x1320 net/mac80211/cfg.c:4134
Code: 20 01 00 00 48 85 c0 49 0f 44 ee 48 b8 00 00 00 00 00 fc ff df 0f b6 04 03 84 c0 0f 85 3b 01 00 00 41 8b 17 4c 89 ef 48 89 ee <67> 48 0f b9 3a e9 c3 fd ff ff e8 9d 71 82 f6 90 0f 0b 90 e9 41 fe
RSP: 0018:ffffc9000374f778 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff1100ff9eb25 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffff88807fcf4120 RDI: ffffffff90698350
RBP: ffff88807fcf4120 R08: ffff888073d00faf R09: 1ffff1100e7a01f5
R10: dffffc0000000000 R11: ffffed100e7a01f6 R12: ffff888073d00740
R13: ffffffff90698350 R14: ffff88807fcf5938 R15: ffff88807fcf5928
FS:  000055555d18b400(0000) GS:ffff888125055000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0604dea286 CR3: 00000000784fe000 CR4: 00000000003526f0
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
RIP: 0033:0x7f3f2a1ec9eb
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007fff6cea1560 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f3f2a1ec9eb
RDX: 00007fff6cea15c0 RSI: 0000000000008b20 RDI: 0000000000000003
RBP: 00007fff6cea1640 R08: 0000000000000001 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff6cea15e0
R13: 00007f3f2a248aa1 R14: 00007f3f2a270cc0 R15: 0000000000000002
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
  34:	e8 9d 71 82 f6       	call   0xf68271d6
  39:	90                   	nop
  3a:	0f 0b                	ud2
  3c:	90                   	nop
  3d:	e9                   	.byte 0xe9
  3e:	41                   	rex.B
  3f:	fe                   	.byte 0xfe


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
