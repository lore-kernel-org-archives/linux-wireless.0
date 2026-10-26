Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792978365;
	b=hCGguoOy1JfrZ2eW57pPZSwdj4TzueRh8Tcfi53K40GNRFBV1aatgcv25MaDj/znOoZt
	 Tf/DcV8IFqxJJ58P6zpVxFEJ5/Wz6TuwJ3cyKpCEgRmjE/2WUospqolzVeCcOFpTe5ICe
	 +lIDYrQUt4RPF6uRE1XFkJjZ5QkSLof/BhiN/SInBC0fLmdRsm2158ZPITCct2hcRzV6N
	 kmgMKtLqgKkH1riguTyiQpnTJLipKwmkga13Y5Tg9PuNilicU3jfU5KHadi31NzYjpALX
	 ShuUMPcI7AUwpsLgwiFf2I0WfhUBs1fSjL7HWD8sIlmyiM9z+81v/tI/7/1wWJBuYMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792978365;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=1WrAPJVqztXGeicWZ8YmBuP6dCF2HqU/IaTH6pLRzhE=;
	b=mgUBsYiTk83U9IDyQK3I0MGNxjpN3vTDJcFcmEx6HtzTMBqfTfego1hVdluu0pQefNk1
	 nv8z9vcwCeBJQkpJqcO3/vFqwOl5aLID1T4pg6FBbMZmhhQiJ82qh1orji5k8CnpmR1mR
	 kPBbp3rljBwrjO8QSavifh+tkVozCcPGOVFWSLKKaiwfQLuhIxntFLduN8xzzXtrTq54I
	 HaGlJTYR+sr2H/BQQx0pd4FB5uX/YoLK5RRRlQ75zPmcPsOMIoVECmp8BNqCVtkmY6pny
	 FNBB9f1EMV1u9xb+qc8sS0X1/0RtJB2c0+wjnVfIC+6qU4cwImimj60bGrIgdTK1EsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1617C606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 01:32:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1617C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4c55ba309c2so4276651b6e.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 18:32:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792978364; x=1793583164;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1WrAPJVqztXGeicWZ8YmBuP6dCF2HqU/IaTH6pLRzhE=;
        b=z+8YvrBPWuwrCdp4K+8eAqv9+0l0ecX5eWq5lw0UdeTsxFqsmN3mFcGegwVGJcEMca
         mGrrXy31Sns360bcStQdi/5K8BHie9xvgvL8NKE254Ev5xIVM7fQP+yHyjCywmzk4hkV
         ElcQfDnVsUFZrflBI1AzHP7OyzTMWxrQBXbApVqi6iQQkvYU3YVyRIX45K3yWHuhPAaP
         EiAY38/itaUjz3SGewUg0l2bnK//cqhuNa498atYvRkOoXBNmmfzMhqRYuQZc/bu7E6Q
         iVab6kCPacNtGalXZ7ChYOvBNnjQvS0QWBAp4o8uq8Um1feA6EtKA1Ii9ToavSdD+Ebq
         Cqww==
X-Forwarded-Encrypted: i=1; AKwUvBy0N00j4I2xHzQssPfbEokwz0p5hD2m95Ye3C+Xlsn3FSykdr+lE7IkuoduVurLi9fOhUjsmUMIyNiGmoBXuw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJScyFTtArWvvSppsMi8m6GL1ZXCpzi0E+GKFjUaujWWTpiREkZ
	1DVxEKbk8aMMvTic62hsFGDEz5vrf+D2ZX/rfYkicKv/eIHhrymkTEIKD0GGtmFPDF0CYko+EK3
	rtzxXjrtA32KyEmOOD22K/Az5W7JrxuHMMKoKgx2aGK9BdKa+7QAZDJF0RXM=
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:220a:b0:4ed:7045:d3bc with SMTP id
 5614622812f47-55c002d9ed3mr3460748b6e.32.1792978364068; Sun, 25 Oct 2026
 18:32:44 -0700 (PDT)
Date: Sun, 25 Oct 2026 18:32:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adeadbc.a6443767.132891.0050.GAE@google.com>
Subject: [syzbot] [wireless?] WARNING in cfg80211_cac_event
From: syzbot <syzbot+3df76a08d929e91e5327@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    734bef548a96 Merge tag 'net-next-7.4' of git://git.kernel...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12a55469580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d0f4f48df8e34eb3
dashboard link: https://syzkaller.appspot.com/bug?extid=3df76a08d929e91e5327
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/585a51a9cc57/disk-734bef54.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b2888e6093ab/vmlinux-734bef54.xz
kernel image: https://storage.googleapis.com/syzbot-assets/74d0b6ec60eb/bzImage-734bef54.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3df76a08d929e91e5327@syzkaller.appspotmail.com

------------[ cut here ]------------
!time_after_eq(jiffies, timeout)
WARNING: net/wireless/mlme.c:1309 at cfg80211_cac_event+0x45b/0x6e0 net/wireless/mlme.c:1309, CPU#1: kworker/u8:3/2120
Modules linked in:
CPU: 1 UID: 0 PID: 2120 Comm: kworker/u8:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
Workqueue: events_unbound cfg80211_wiphy_work
RIP: 0010:cfg80211_cac_event+0x45b/0x6e0 net/wireless/mlme.c:1309
Code: fc ff ff e8 67 a8 7d f6 90 0f 0b 90 eb c8 e8 5c a8 7d f6 48 8d 3d 85 18 43 06 67 48 0f b9 3a e9 35 fd ff ff e8 46 a8 7d f6 90 <0f> 0b 90 e9 82 fe ff ff 89 d9 80 e1 07 fe c1 38 c1 0f 8c 24 fc ff
RSP: 0000:ffffc9000328f918 EFLAGS: 00010293
RAX: ffffffff8b4abdda RBX: 0000000100010317 RCX: ffff888031c13e80
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000000
RBP: 0000000100011a86 R08: ffff888031c13e80 R09: 0000000000000003
R10: 0000000000000005 R11: 0000000000000000 R12: ffff8880569213e8
R13: dffffc0000000000 R14: 0000000100011a87 R15: 1ffff1100ad2427d
FS:  0000000000000000(0000) GS:ffff888123b6b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd8c6a5cdc CR3: 000000007562a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 ieee80211_dfs_cac_timer_work+0x264/0x380 net/mac80211/mlme.c:3995
 cfg80211_wiphy_work+0x29e/0x420 net/wireless/core.c:610
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
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
