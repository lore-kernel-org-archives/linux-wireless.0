Received: from mail-oa2-f1.google.com (mail-oa2-f1.google.com [74.125.231.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3A6242D7B
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787503949; cv=none; b=BEbE+g8ol9xdLILeQD0d5DHVkpYB1DWSb3QTdAyCWqLpNvolMxtIsl8/vyhLCDAeLX6Mps/DIH5LoNTNfP98hSDBZM+YFWSI/g6xNQfjF+O/LMOkjhZmFNJhF9TpxjavntKzyjzvXXZ9ISsj8DHGDKfT297WgttSsKiil8H90K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787503949; c=relaxed/simple;
	bh=copDUyRMszbRIqNAsugt2MWx3EsI7GjK4ddKoONo6iM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mE1xkWNIAI8A8Bt0Pfunr9xrH0S8M3eiP51C/a8BHxN3SzZlx18waHyLEFpA9dUWmpc7YrOznqycox6St/eK1DMtDube6Dq3Jiv8nmt9H4FLKt/1mMxQC/sQKfZFWy9CL+7w+Bn/ha+C6sIYVebGlKpM4XC36dkYtNgvLAOhtTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa2-f1.google.com with SMTP id 586e51a60fabf-44cf1835ec3so1204957fac.0
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 09:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787503947; x=1788108747;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RezAGxIanJHuW5LH+wjmzvg9wFoKszoaBFkcFQbSQDQ=;
        b=bTSaMdveDc5hI0dD4MgFU9K7LKUbhS7E+mwwtSUXieeuX9RHacxtyQNmv43eJIaQIp
         5A89AZ7Foq4WK/i6+rX9i0Sr0ZonWAmmdpdjeuvdjKJ/VbitLM9cIVr2jUlYjDG1jtz/
         XYJYRNsU5hLLPHCI3bFTRLaU+5CgdcRLpBqUxTCeq9p8lX8H9+r27Egp1lORNbdC84Ve
         ZHLDxrm90Q4rOAhvRK1u6Jl+oNTsQO2O90EqmHzzjtqaDN6+0r+R7lOw4kr+FtDvnepm
         0lQbx+erxY6nW89LvymD9vk4AiuhvPV1dIvMbn7of9oG70YAqZarYH1EHu+5suaOQJJY
         0JXQ==
X-Forwarded-Encrypted: i=1; AHgh+RpgY9x3mB6k2wzQlef2uA7tk05tImV9MNrc0nLjSUgGVQwUL2IckC6Y9vzB9ILhgy5htu5oX1/1Q/h017X+Jw==@vger.kernel.org
X-Gm-Message-State: AFuF++mnHzwzCyl2hG7KXPN7qvu7w86yXat7D7L0YfcUHDcUWKjVuii2
	e1fjgH3c0uoNQsTKtGhougHb7FtTV3+XjhHxYsG65pSNzMXZyiCvkVnq2WqgTAlRoDNCI87dLH1
	bet3bSh6LucUAvVl4t8FowBL63z4gGfD3ppSe/xMlP5FurKV4MYA2g26hXjM=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2016:b0:6ae:4d57:a5fe with SMTP id
 006d021491bc7-6b16b4cc8e2mr11588208eaf.20.1787503947074; Sun, 23 Aug 2026
 09:52:27 -0700 (PDT)
Date: Sun, 23 Aug 2026 09:52:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8b254b.91706f20.16b6e3.02c9.GAE@google.com>
Subject: [syzbot] [wireless?] memory leak in ieee80211_mesh_csa_beacon
From: syzbot <syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    bd5f485f3f02 Merge tag 'soc-arm-7.3' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16795679580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82c3db8c83e3e016
dashboard link: https://syzkaller.appspot.com/bug?extid=f5752cd6b94fe38be666
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17913a25580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5cb73cc49d3d/disk-bd5f485f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dec5db798cfd/vmlinux-bd5f485f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a7a15e3d5e4d/bzImage-bd5f485f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com

2026/08/19 20:15:25 executed programs: 5
BUG: memory leak
unreferenced object 0xffff88810a69b000 (size 1024):
  comm "syz.0.19", pid 5915, jiffies 4294944112
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    d8 23 c0 25 81 88 ff ff 00 00 00 00 00 00 00 00  .#.%............
  backtrace (crc 46b98ecb):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4597 [inline]
    slab_alloc_node mm/slub.c:4917 [inline]
    __kmalloc_cache_noprof+0x359/0x440 mm/slub.c:5485
    _kmalloc_noprof include/linux/slab.h:988 [inline]
    ieee80211_mesh_csa_beacon+0x2e/0x100 net/mac80211/mesh.c:1547
    ieee80211_set_csa_beacon net/mac80211/cfg.c:4674 [inline]
    __ieee80211_channel_switch+0xb22/0xed0 net/mac80211/cfg.c:4795
    rdev_channel_switch net/wireless/rdev-ops.h:1168 [inline]
    nl80211_channel_switch+0x39b/0x780 net/wireless/nl80211.c:12234
    genl_family_rcv_msg_doit+0x12e/0x1a0 net/netlink/genetlink.c:1114
    genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
    genl_rcv_msg+0x302/0x440 net/netlink/genetlink.c:1209
    netlink_rcv_skb+0x89/0x1c0 net/netlink/af_netlink.c:2556
    genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
    netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
    netlink_unicast+0x38f/0x4e0 net/netlink/af_netlink.c:1345
    netlink_sendmsg+0x335/0x690 net/netlink/af_netlink.c:1900
    sock_sendmsg_nosec net/socket.c:800 [inline]
    __sock_sendmsg net/socket.c:815 [inline]
    ____sys_sendmsg+0x54a/0x580 net/socket.c:2709
    ___sys_sendmsg+0x101/0x140 net/socket.c:2763
    __sys_sendmsg+0xcd/0x140 net/socket.c:2795
    do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
    do_syscall_64+0xe9/0x530 arch/x86/entry/syscall_64.c:84
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


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
