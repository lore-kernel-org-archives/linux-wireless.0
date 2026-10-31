Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793436760;
	b=o/IjiMXzimbTz0ydiKgNFsdEzY0CwY5JpQBQ3M9X4MxHTu6Z5PV1983PGNbZ4dqymfZZ
	 KlAfX8BLTCnvl2io1YATROA6V/io41o9Sec1hSPUWXyBmcFQ4qxFWToJocIYiFl21ezrQ
	 EWm3fcgZfd0UN8yJtRAFwn98TBrc8v+WqbkMJOzhAm2XJaSADzBf5LjcsVlpcOXemk6fL
	 yNgeOMr/lQLBv7CRNnBLEK5cq6kKtmBt2E0+BVdQ2oZZ4ZwCdd/vFZllgOOXExlTM4BE5
	 mk02O29ahljl+Um6F+M4/VoJKUyrCuPmQjrDzCESZJXJTUYnONq0LrQJWmPMpFomQOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793436760;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type:Content-Transfer-Encoding;
	bh=T54JHojtNznOOiHI0falihSPn5TxrG175B8BVl0MzMs=;
	b=tOeqjXJYgX9BWMTTGHvJkuLufekPJFMM4MSXXhq5Q0rEPi+69/iEclvaCvAjQSdiM10C
	 DwGeGtGUT9OdmIW9V0bZYJfomAPnOizwsJfC2zzrVnGCBO4MmRebFPVPa6EtV1JmxgVyQ
	 PLkvaUPjN6JalnoAqd+FDEvwLiiuUjoMMj01DNMODIdQ0YkEMXBlRbdmVZeFRzU6t4Aq2
	 JuxawuoohVilM413lT+2KgQWmmLy0UfJ40+FBhjCA4gSHLjRaWUUJXtKPtrVXS4vbZJKm
	 jpgNxBe9zj/hXytBfPh2m2dSh8s+ErkVIdXIvquOLfWQMJYAbIL5XQr4g3W8J58M/gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAA6606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 08:52:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EAA6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-547ae874949so2266943b6e.2
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 01:52:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793436759; x=1794041559;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T54JHojtNznOOiHI0falihSPn5TxrG175B8BVl0MzMs=;
        b=T0h86FkNWpvq/EOntn8lmRBJL98Qdx2Z8Q/gNBctsvtLEzFnVjVLCNgejzNJj+B561
         bAR5X35Ic+5aigRIp3Dp+Rgv7vQzqIfOTpgPCC8e1CGSt9c49ePgR0/uWPwcsHjvp+xF
         6OteNj2fGf92TCf3e5dtUFC/N/afddmDoFON2iAss76gvZfqDr8dgj/71SL1FvaeWrku
         9Ru5d/14n1Im0m68Ts4Gjxnl11cAMzDj1TiovQ3TzhaNv/mf24Ot5v5RtNg1cDzQo8Ih
         kpTFJ3HG46xPgwzQvYB+sfIJHQoBtlcDR+GJBvGoIFUBMfQFuyqLn/NA8WOhaSpScC68
         FY7g==
X-Forwarded-Encrypted: i=1; AKwUvBwPqyrUea9cKelrzn9nUe55EodVYDEfunhc8uE/efB/Rt8TJUs9jyTYXAk8XUD/VRkboLCsdPfC+Rk+IQu0Ng==@vger.kernel.org
X-Gm-Message-State: AFq9FYIYN6DMplDBKV4fyNEUqjfK8gtj7wNcqkODkFgE9iBhtuiWQIxx
	HSkR9JDo8qNe3+jiNyRQDkFW7107IFC8mRJo0RzO4i426yiHQlRd/hnuK5xUDIzmxGhsonXuHrb
	BiRVYV6Rl1c88LPFoAQ2f8X3BGwDuTdQdKyxCTSVIsi9Aq45JKDSeQeOdd60=
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c2c7:b0:531:7f68:842e with SMTP id
 5614622812f47-5640dbd6258mr3317562b6e.8.1793436759449; Sat, 31 Oct 2026
 01:52:39 -0700 (PDT)
Date: Sat, 31 Oct 2026 01:52:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae5ac57.88e51036.1515fd.0003.GAE@google.com>
Subject: [syzbot] [wireless?] WARNING in rfkill_dev_uevent
From: syzbot <syzbot+56f5119a6b206041a6b7@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    dda51b737216 tcp: check congestion control restriction firs=
t
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D12607259580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dd0f4f48df8e34eb=
3
dashboard link: https://syzkaller.appspot.com/bug?extid=3D56f5119a6b206041a=
6b7
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D10e3188d58000=
0
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D169b9135580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/69fc30a54172/disk-=
dda51b73.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6fd8743be1c2/vmlinux-=
dda51b73.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1aa0f93cd3c4/bzI=
mage-dda51b73.xz

AI-generated root cause summary:
In mac80211_hwsim and cfg80211, the netlink attribute HWSIM_ATTR_RADIO_NAME=
 is
accepted without a length limit, and cfg80211 does not bound requested_name=
 when
setting the device and rfkill names. When a user creates a virtual radio wi=
th an
excessively long name via netlink, rfkill registration triggers a uevent wh=
ere
RFKILL_NAME exceeds the fixed 2048-byte UEVENT_BUFFER_SIZE in add_uevent_va=
r(),
triggering a WARN. In production kernels, add_uevent_var() safely returns
-ENOMEM and drops the uevent without memory corruption or system crashes.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=3D56f5119a6=
b206041a6b7

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+56f5119a6b206041a6b7@syzkaller.appspotmail.com

workqueue
workqueue: name exceeds WQ_NAME_LEN. Truncating to: =14=EF=BF=BD=EF=BF=BD=
=EF=BF=BDe=EF=BF=BD45=EF=BF=BD8) r1 +=3D -8
     15: .
------------[ cut here ]------------
add_uevent_var: buffer size too small
WARNING: lib/kobject_uevent.c:688 at add_uevent_var+0x2db/0x460 lib/kobject=
_uevent.c:688, CPU#0: syz-executor353/5646
Modules linked in:
CPU: 0 UID: 0 PID: 5646 Comm: syz-executor353 Not tainted syzkaller #0 PREE=
MPT(full)=20
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 10/07/2026
RIP: 0010:add_uevent_var+0x2db/0x460 lib/kobject_uevent.c:688
Code: 48 8b 44 24 40 42 0f b6 04 38 84 c0 48 8b 5c 24 18 0f 85 73 01 00 00 =
44 01 33 31 c0 eb 20 e8 0c 1c dd f5 48 8d 3d 35 df a3 05 <67> 48 0f b9 3a b=
8 f4 ff ff ff 49 bf 00 00 00 00 00 fc ff df 66 43
RSP: 0018:ffffc90003996a00 EFLAGS: 00010293
RAX: ffffffff8beb4a14 RBX: 1ffff1100efa0443 RCX: ffff88807f68be80
RDX: 0000000000000000 RSI: 0000000000001770 RDI: ffffffff918f2950
RBP: ffffc90003996b38 R08: ffff88807f68be80 R09: 0000000000000008
R10: 0000000000000007 R11: 0000000000000000 R12: 0000000000001770
R13: 1ffff92000732d50 R14: 000000000000079e R15: 0000000000000062
FS:  000055556e425400(0000) GS:ffff888123a6b000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000069e000 CR3: 00000000713cc000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 rfkill_dev_uevent+0x2f/0x1f0 net/rfkill/core.c:875
 dev_uevent+0x4ab/0x870 drivers/base/core.c:2774
 kobject_uevent_env+0x475/0x9e0 lib/kobject_uevent.c:576
 device_add+0x544/0xb80 drivers/base/core.c:3742
 rfkill_register+0x170/0x9b0 net/rfkill/core.c:1100
 wiphy_register+0x2a5f/0x3290 net/wireless/core.c:1310
 ieee80211_register_hw+0x3d72/0x4b30 net/mac80211/main.c:1634
 mac80211_hwsim_new_radio+0x32f1/0x5990 drivers/net/wireless/virtual/mac802=
11_hwsim_main.c:6186
 hwsim_new_radio_nl+0xd8b/0xf90 drivers/net/wireless/virtual/mac80211_hwsim=
_main.c:7062
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2580
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
 netlink_unicast+0x8ef/0xa80 net/netlink/af_netlink.c:1361
 netlink_sendmsg+0x7f0/0xb20 net/netlink/af_netlink.c:1920
 sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
 __sock_sendmsg net/socket.c:818 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2769
 __sys_sendmsg net/socket.c:2801 [inline]
 __do_sys_sendmsg net/socket.c:2806 [inline]
 __se_sys_sendmsg net/socket.c:2804 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2804
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbc181e2649
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc9f9d5c88 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbc181e2649
RDX: 0000000000000084 RSI: 0000200000000a00 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000006 R09: 0000000000000006
R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fbc18275c40 R15: 0000000000000002
 </TASK>
----------------
Code disassembly (best guess):
   0:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   5:	42 0f b6 04 38       	movzbl (%rax,%r15,1),%eax
   a:	84 c0                	test   %al,%al
   c:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  11:	0f 85 73 01 00 00    	jne    0x18a
  17:	44 01 33             	add    %r14d,(%rbx)
  1a:	31 c0                	xor    %eax,%eax
  1c:	eb 20                	jmp    0x3e
  1e:	e8 0c 1c dd f5       	call   0xf5dd1c2f
  23:	48 8d 3d 35 df a3 05 	lea    0x5a3df35(%rip),%rdi        # 0x5a3df5f
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  34:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
  3b:	fc ff df
  3e:	66                   	data16
  3f:	43                   	rex.XB


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
