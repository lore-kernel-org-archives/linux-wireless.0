Received: from mail-oa2-f1.google.com (mail-oa2-f1.google.com [74.125.231.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21CB22A7F6
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 04:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788754707; cv=none; b=DnEBTTTApyL6qC1MPxiKVhtGUhrwU8mkD25lY8BiCyMDrD42yP4qwHrVZwGhZT75LxZg/ddV0LcmxOP46vis9HYdKvQECoPQHtncx58uOdM8bGr3PgYJVuqJgj89csuR7tkIrrqk1n2HtYqS5uTvAKt8TE/pKV6LDtblqLOsJ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788754707; c=relaxed/simple;
	bh=NeTZ3WAU46MbvPO6kEBfkBdJfB1cNVN70SCHhy/XKpo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tVD4oxxpca86312zlMJ8Av9Wem+MNlzWNuuw9mfIOQpB2/R45NGh7QqABaSZ6fra1zb9XPKbNx0AuFfzW76kHQ5JgKBxWr/B4BUILLLP1vAxc5F1YUPZlTXUVvyv2wUHcpGgrClyQkVanu1RbXUH5xc906RWIclp5f32KlQQrr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa2-f1.google.com with SMTP id 586e51a60fabf-4489b7aa0e7so898102fac.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 21:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788754704; x=1789359504;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3MD5bZESO5Sio0y2t1dVGhfCjI2ywfD0LtblhOvs7NI=;
        b=pr9CNIKGPYmtdwKVZgvQyjlkDA3J6p8q4M2xjnNBpEa4Lu7QkIxXHzayk7bEhmX9MQ
         bjYXS7tK7CAKp/17hUbRd3Kh0EZi0x+AHjjkOr1yii93oGAct0jMmxiKbc0kEny4j9qM
         6Alu29baD/KO4akuBNeM1ExzyJb9VAhoF5tXdFIbBYo01RNrg5sAinJp+SrtKlv5A/QI
         l9jvF1DTA78VLxFHp+A3+5ZbJM6hBfeD7wMQRPxI7XUxoUheK64huDCU3DKLM/fg/+YS
         AnEwk8iaEdun7F9qPBOuuC+GrXf+5gTiT9yZ7ZxPRJaSLCZ+WnTCKnYXDBn2QjqLRjD4
         RQwg==
X-Forwarded-Encrypted: i=1; AKwUvBzJTkAl/xuSYGgcthd6HLa1qDtPCvkP00qtN6gqXYCKNcd4rM83wJ9ovSucqXSbZ6uegObxCxHEsf7OOExxDw==@vger.kernel.org
X-Gm-Message-State: AFuF++lVwYUQR3Y/DP4Z5FLtzj7NBh2B8eOWt6YSEoVheHl/eN6169ka
	EGCtN64Z9aruYsVZuCPbs4qlNoiXjMN36eryi+/lClLFHdgIT9jXUt7wdQrSa9YGVffe6yVujLo
	40RjWyJPswZhaylQtrG3f/+reMfv/znL1XrIKZL/KB7mrA+jc0jH6/Mzo4Fs=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4dee:b0:6b3:4a99:bd85 with SMTP id
 006d021491bc7-6b6fcac6a61mr11985039eaf.22.1788754704714; Sun, 06 Sep 2026
 21:18:24 -0700 (PDT)
Date: Sun, 06 Sep 2026 21:18:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9e3b10.4a487d73.3c8564.0027.GAE@google.com>
Subject: [syzbot] [wireless?] WARNING in mac80211_hwsim_write_tsf
From: syzbot <syzbot+c5d94e4d897c2c21cb27@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    940de590b839 Merge tag 'hardening-v7.3-rc2' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=124bbc15580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=c5d94e4d897c2c21cb27
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b8d77584fb64/disk-940de590.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/86f920f789e3/vmlinux-940de590.xz
kernel image: https://storage.googleapis.com/syzbot-assets/60d455a26058/bzImage-940de590.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c5d94e4d897c2c21cb27@syzkaller.appspotmail.com

netlink: 80 bytes leftover after parsing attributes in process `syz.4.6946'.
------------[ cut here ]------------
c->control.rates[0].idx < 0
WARNING: ./include/net/mac80211.h:3413 at ieee80211_get_tx_rate include/net/mac80211.h:3413 [inline], CPU#1: syz.4.6946/31565
WARNING: ./include/net/mac80211.h:3413 at mac80211_hwsim_get_tx_rate drivers/net/wireless/virtual/mac80211_hwsim_main.c:1335 [inline], CPU#1: syz.4.6946/31565
WARNING: ./include/net/mac80211.h:3413 at mac80211_hwsim_write_tsf+0x4ca/0x6b0 drivers/net/wireless/virtual/mac80211_hwsim_main.c:1617, CPU#1: syz.4.6946/31565
Modules linked in:
CPU: 1 UID: 0 PID: 31565 Comm: syz.4.6946 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:ieee80211_get_tx_rate include/net/mac80211.h:3413 [inline]
RIP: 0010:mac80211_hwsim_get_tx_rate drivers/net/wireless/virtual/mac80211_hwsim_main.c:1335 [inline]
RIP: 0010:mac80211_hwsim_write_tsf+0x4ca/0x6b0 drivers/net/wireless/virtual/mac80211_hwsim_main.c:1617
Code: 41 5c 41 5d 41 5e 41 5f 5d e9 32 cd ab 04 e8 8d e8 8c fa 66 bd 64 00 4d 8d bc 24 a8 49 00 00 e9 18 fc ff ff e8 77 e8 8c fa 90 <0f> 0b 90 e9 86 fc ff ff 89 d9 80 e1 07 38 c1 0f 8c be fb ff ff be
RSP: 0018:ffffc90003eb6d78 EFLAGS: 00010283
RAX: ffffffff873ad2a9 RBX: ffff888058132a30 RCX: 0000000000080000
RDX: ffffc90005c19000 RSI: 000000000000023a RDI: 000000000000023b
RBP: ffff88805ae00f40 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520007d6da0 R12: ffff88805ae03220
R13: ffff888058132a00 R14: dffffc0000000000 R15: ffffffffffffffff
FS:  00007f213d4426c0(0000) GS:ffff888124dda000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2d723ffc CR3: 0000000039eac000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 mac80211_hwsim_tx_frame_no_nl+0x16b/0x1760 drivers/net/wireless/virtual/mac80211_hwsim_main.c:1913
 mac80211_hwsim_tx+0x18cb/0x2580 drivers/net/wireless/virtual/mac80211_hwsim_main.c:2276
 drv_tx net/mac80211/driver-ops.h:38 [inline]
 ieee80211_tx_frags+0x3df/0x890 net/mac80211/tx.c:1753
 __ieee80211_tx+0x267/0x580 net/mac80211/tx.c:1808
 ieee80211_tx+0x312/0x4b0 net/mac80211/tx.c:1991
 ieee80211_monitor_start_xmit+0xb33/0x1280 net/mac80211/tx.c:2486
 __netdev_start_xmit include/linux/netdevice.h:5429 [inline]
 netdev_start_xmit include/linux/netdevice.h:5438 [inline]
 xmit_one net/core/dev.c:3937 [inline]
 dev_hard_start_xmit+0x2cd/0x830 net/core/dev.c:3953
 __dev_queue_xmit+0x14c0/0x3820 net/core/dev.c:4926
 packet_snd net/packet/af_packet.c:3110 [inline]
 packet_sendmsg+0x3d0d/0x4f80 net/packet/af_packet.c:3142
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 __sys_sendto+0x408/0x5a0 net/socket.c:2281
 __do_sys_sendto net/socket.c:2288 [inline]
 __se_sys_sendto net/socket.c:2284 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2284
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f213c59e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f213d442028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f213c825fa0 RCX: 00007f213c59e159
RDX: 000000000000002b RSI: 0000200000000540 RDI: 000000000000000b
RBP: 00007f213c635024 R08: 0000200000000380 R09: 0000000000000014
R10: 0000000004000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f213c826038 R14: 00007f213c825fa0 R15: 00007f213c94fa48
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
