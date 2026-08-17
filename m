Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3078D3F5BD8
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 12:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968518; cv=none; b=YzNIYFg/ebK7f2tkJEwGtoHP+0t5Yq0oHAMQF+G26cAg8H2l5YYAjSBzLD/hsZSJKqPaqsOrCu+XNX9bIiRPmVfgyMFcqrp+attHJZy9XX8m5QBpSEznwdznNNapuw3JPePNlDfhJ/XsqWxuSzrWQOW1M95//6/bek0yo/xep0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968518; c=relaxed/simple;
	bh=o1UIUVHZobxp6X8wQbI8+nwQz3hZVNqykVNiae6Ad6o=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Ixue8QLcXHlt1KVs2rYbvAHZ63JKD2rOd1y+ALHoalr8q1cC4u0JfiCMY4anYllafvsajPWEz4vhVnvP5u27IwZrzOimC/+tIas2q07mPYkWXScx/cpezZFh5lNXi+IjEMPoC7MqUvMPSOEiKcwiEb5jCTiIu17135vNauzGGUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7f36427abfdso5716216a34.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 05:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786968516; x=1787573316;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=COaXSU7GxSe0beF7WrWjU5uv4IL/tUmeZWHBpXqhfAQ=;
        b=tMmQzXJKetDMR1NvuygIUmyonTmh29eSfL4xhlARtRYlYxb6AkvrF/jpZBOa24mciZ
         o8BG+0pjA0AzxD0eolb//DBRqqQxGlyEHqsyqvPIcBA/b0epKjYWoQpptZbw6pqrErP/
         vnmZ2ozq58g76cganEc6vPSsf4Vtp4H0R6+/acBj8hpEpSHq9VGgr+jd+1kMQdLH/zkW
         BDTDlBbkYr93JXP4hjBO8SHxNQmD4rOwoNGMSgjr/rMbzKzND8efkaclRf2j++3koHem
         NGpi8Bmp64TwInClsR42RHq5yk52R0Eg1szpWWOGcGe3BWh7shxfgVQhvxGQCcUSSUqV
         +EAw==
X-Forwarded-Encrypted: i=1; AHgh+RoUg0b/6bgZS0ZDJJspH69yvJHeTlR5eSMYxrJ6SiLoisTIUMRZf/Vf8XD5u/tXri1gL2iX5LZHsHWMyGj5dA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv2Fj7Lrnzz97T/1EPfY5nc4kPKTvFnsvaqxq+IU6GXCVSIK8x
	jdtXcBnqLG02nu1SmaI9KHhqduxNsYgOjoWkkm3GCxxvTbBYE+pBCYYF8SDi4kHWdLf6OQccK46
	Wh0Y2CFx5CyeZL6FbU/BiXyNaLz6iuTXefDyUiMN+UZsofxKA7O+x1oxIAWk=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8582:10b0:6aa:e573:9ce0 with SMTP id
 006d021491bc7-6b0d61d0f52mr15648436eaf.16.1786968516153; Mon, 17 Aug 2026
 05:08:36 -0700 (PDT)
Date: Mon, 17 Aug 2026 05:08:36 -0700
In-Reply-To: <6a63df97.a2ea2cc8.fbad6.000a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a82f9c4.dbb3a75c.20434b.0056.GAE@google.com>
Subject: Re: [syzbot] [wireless?] WARNING in nl80211_set_tx_bitrate_mask
From: syzbot <syzbot+dcaca020ca8377e7ced0@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8d3ae59288f1 Linux 7.2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10dc0679580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1d67342c314f228d
dashboard link: https://syzkaller.appspot.com/bug?extid=dcaca020ca8377e7ced0
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11fdd949580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dcaca020ca8377e7ced0@syzkaller.appspotmail.com

------------[ cut here ]------------
wlan2: Failed check-sdata-in-driver check, flags: 0x0
WARNING: net/mac80211/driver-ops.h:884 at drv_set_bitrate_mask net/mac80211/driver-ops.h:884 [inline], CPU#2: syz-executor202/6039
WARNING: net/mac80211/driver-ops.h:884 at ieee80211_set_bitrate_mask+0x888/0xe20 net/mac80211/cfg.c:4134, CPU#2: syz-executor202/6039
Modules linked in:
CPU: 2 UID: 0 PID: 6039 Comm: syz-executor202 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:drv_set_bitrate_mask net/mac80211/driver-ops.h:884 [inline]
RIP: 0010:ieee80211_set_bitrate_mask+0x88f/0xe20 net/mac80211/cfg.c:4134
Code: 02 00 00 e8 23 6b d6 f6 48 8b 34 24 48 81 c6 20 01 00 00 48 89 34 24 e8 0f 6b d6 f6 48 8d 3d c8 80 1f 06 48 8b 34 24 44 89 ea <67> 48 0f b9 3a e9 f7 fd ff ff e8 f2 6a d6 f6 48 8d bb 50 08 00 00
RSP: 0018:ffffc90003c973f0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88803e5f0740 RCX: ffffffff8b340832
RDX: 0000000000000000 RSI: ffff88805720c120 RDI: ffffffff91538960
RBP: ffff88805720d928 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88803e5f0740
R13: 0000000000000000 R14: ffff88805720c000 R15: ffffc90003c97488
FS:  000055556bc9e400(0000) GS:ffff8880d5dde000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fee5f7dfe9c CR3: 000000003e24f000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 rdev_set_bitrate_mask net/wireless/rdev-ops.h:683 [inline]
 nl80211_set_tx_bitrate_mask+0x320/0x570 net/wireless/nl80211.c:14541
 genl_family_rcv_msg_doit+0x214/0x300 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x560/0x800 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x159/0x420 net/netlink/af_netlink.c:2556
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x585/0x850 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x8b0/0xda0 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:775 [inline]
 __sock_sendmsg net/socket.c:790 [inline]
 __sys_sendto+0x48b/0x4e0 net/socket.c:2252
 __do_sys_sendto net/socket.c:2259 [inline]
 __se_sys_sendto net/socket.c:2255 [inline]
 __x64_sys_sendto+0xe0/0x1c0 net/socket.c:2255
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4b1b84a677
Code: 48 89 fa 4c 89 df e8 98 1d 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffe1ffacce0 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000055556bc9e400 RCX: 00007f4b1b84a677
RDX: 000000000000001c RSI: 00007ffe1ffacd40 RDI: 0000000000000003
RBP: 00007ffe1ffacd40 R08: 00007ffe1ffacd34 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000028
R13: 0000000000000003 R14: 0000000000000026 R15: 00007f4b1b888ed3
 </TASK>
----------------
Code disassembly (best guess):
   0:	02 00                	add    (%rax),%al
   2:	00 e8                	add    %ch,%al
   4:	23 6b d6             	and    -0x2a(%rbx),%ebp
   7:	f6 48 8b 34          	testb  $0x34,-0x75(%rax)
   b:	24 48                	and    $0x48,%al
   d:	81 c6 20 01 00 00    	add    $0x120,%esi
  13:	48 89 34 24          	mov    %rsi,(%rsp)
  17:	e8 0f 6b d6 f6       	call   0xf6d66b2b
  1c:	48 8d 3d c8 80 1f 06 	lea    0x61f80c8(%rip),%rdi        # 0x61f80eb
  23:	48 8b 34 24          	mov    (%rsp),%rsi
  27:	44 89 ea             	mov    %r13d,%edx
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 f7 fd ff ff       	jmp    0xfffffe2b
  34:	e8 f2 6a d6 f6       	call   0xf6d66b2b
  39:	48 8d bb 50 08 00 00 	lea    0x850(%rbx),%rdi


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
