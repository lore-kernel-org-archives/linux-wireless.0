Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50DE4534BB
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 15:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786030002; cv=none; b=dO9P4bPkYHloKKnwWS0ur2uqvekhIz+ziG9GDGqjV+UnFMw2kArruvPa/oYnHUmRHCABRJhmqu1PnxZs1FIMDWt0WTldq68Pmgzm9WCZ+wtGwK949IuIRfU8roGLRE/mo4pJF+9ilKSzpcCqFBXALoaFMGIhgDwH+rjNQ2/b73Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786030002; c=relaxed/simple;
	bh=PKv1bAGhKp/YccIsCvP8+3KTPozLFS1X8kARfAdrYxs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=NmNdZIIEuC4b/Rga8YvaYlOSLcpwKyE+F6eBPnfwa4GuKapUeSGWaDpZiWWw36CHqW6elkj7Vk2eSD3CbdYpy9wIEPFXiy5TbhIHhQZKV0mkPZww6EAUmpyXdnFNWZE2Wip1SH2kYdH1Tlg7d3+/1bc0KRR+0PEjVcz7GnkHNPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-4ab4f78b9f4so2853551b6e.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 08:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786029999; x=1786634799;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+dIcc5sG7ojdR+UrhEf8vYJLwqLwbyX/SlkMNr7YEJM=;
        b=jKnAysWy+hOhZWCb8wgQ+4B4nHnPnld1w2LY0cKkuLnoL7REsQMSVnDEFLO82GGIUj
         L4bVgxzP0BTRHIk8oyd5ri4VDuA+RTN4ABuYwBxv+cftD1UjyJ/jhgiuGguhdmkoExLv
         duUF5QPCr9QhwLkme6LoSTCOVS9jBGAU7A7eAfGTZBCpcYWEKw512tPlzwreTPx+kBwS
         avuzhDcwX8Ywsy4em6so6ttrwhGCNPhETQIkSuP04+z601LAm/nuABZ3BN1DU2PW5HyA
         wkruanKmXgbj5NKvViIvecnHxC4pGomme3hwwJxCV9oqzMt0HJWpxojO+68nMZvQVqcK
         sGUQ==
X-Forwarded-Encrypted: i=1; AHgh+RoAQLLswl2MLFnM7o3lfRyqTxefMhG+bk+UIiibVni2duSa6fubJALZVLN7FkgmabSGALFw/7olbiR2pLY/aw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxGSR/go8MZBkhgLAw6fT3hsCXzYDnn8/P8fsfcBvW08d1vWeD5
	wGYN5Ieys5jgczaQX1++Rl6kgNjFTUF+vxdBAF9IEcOWZ+id8JCb56eyuRd8tJFwJP5jW8DeMbr
	0ct9MCH3oOnt0lkoXZPNnm8eKzgTpYnitj+/KK7gFl8ZI6Xv+b2/N0FzBTOk=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:198c:b0:6ae:9cf4:f863 with SMTP id
 006d021491bc7-6b0216b7e40mr1194713eaf.36.1786029998828; Thu, 06 Aug 2026
 08:26:38 -0700 (PDT)
Date: Thu, 06 Aug 2026 08:26:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a74a7ae.01d0871a.3a0d52.001f.GAE@google.com>
Subject: [syzbot] [wireless?] possible deadlock in __sock_release (2)
From: syzbot <syzbot+2398b0f6924a70b7de12@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0d8395707651 Merge tag 'soc-fixes-7.2-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b277b9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
dashboard link: https://syzkaller.appspot.com/bug?extid=2398b0f6924a70b7de12
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-0d839570.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0b7275b6c889/vmlinux-0d839570.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b752a676c1dd/bzImage-0d839570.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2398b0f6924a70b7de12@syzkaller.appspotmail.com

nvme nvme0: failed to connect socket: -512
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.3.2609/19125 is trying to acquire lock:
ffff8880574acd00 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
ffff8880574acd00 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release+0x86/0x260 net/socket.c:709

but task is already holding lock:
ffffffff8fd25f60 (nvmf_dev_mutex){+.+.}-{4:4}, at: nvmf_dev_write+0xa6/0xb60 drivers/nvme/host/fabrics.c:1400

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (nvmf_dev_mutex){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       nvmf_dev_show+0x26/0x210 drivers/nvme/host/fabrics.c:1444
       seq_read_iter+0x32f/0x1270 fs/seq_file.c:231
       seq_read+0x344/0x4d0 fs/seq_file.c:163
       vfs_read+0x1e4/0xb40 fs/read_write.c:572
       ksys_read+0x12a/0x250 fs/read_write.c:716
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&p->lock){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       seq_read_iter+0xe1/0x1270 fs/seq_file.c:183
       kernfs_fop_read_iter+0x46c/0x610 fs/kernfs/file.c:290
       __kernel_read+0x397/0xad0 fs/read_write.c:532
       integrity_kernel_read+0x7e/0xb0 security/integrity/iint.c:28
       ima_calc_file_hash_tfm+0x25e/0x350 security/integrity/ima/ima_crypto.c:222
       ima_calc_file_hash+0x1e3/0x380 security/integrity/ima/ima_crypto.c:280
       ima_collect_measurement+0x94f/0xb30 security/integrity/ima/ima_api.c:300
       process_measurement+0xdfe/0x2350 security/integrity/ima/ima_main.c:425
       ima_file_check+0xc3/0x110 security/integrity/ima/ima_main.c:685
       security_file_post_open+0xc4/0x210 security/security.c:2755
       do_open fs/namei.c:4702 [inline]
       path_openat+0x985/0x4280 fs/namei.c:4863
       do_file_open+0x20e/0x430 fs/namei.c:4892
       do_sys_openat2+0x10f/0x1e0 fs/open.c:1368
       do_sys_open fs/open.c:1374 [inline]
       __do_sys_openat fs/open.c:1390 [inline]
       __se_sys_openat fs/open.c:1385 [inline]
       __x64_sys_openat+0x12d/0x210 fs/open.c:1385
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       process_measurement+0x5ab/0x2350 security/integrity/ima/ima_main.c:319
       ima_file_check+0xc3/0x110 security/integrity/ima/ima_main.c:685
       security_file_post_open+0xc4/0x210 security/security.c:2755
       do_open fs/namei.c:4702 [inline]
       path_openat+0x985/0x4280 fs/namei.c:4863
       do_file_open_root+0x2f6/0x5a0 fs/namei.c:4916
       file_open_root+0x1c6/0x3f0 fs/open.c:1355
       kernel_read_file_from_path_initns+0x189/0x260 fs/kernel_read_file.c:163
       fw_get_filesystem_firmware drivers/base/firmware_loader/main.c:549 [inline]
       _request_firmware+0x733/0x13c0 drivers/base/firmware_loader/main.c:873
       request_firmware+0x35/0x50 drivers/base/firmware_loader/main.c:948
       reg_reload_regdb+0x85/0x460 net/wireless/reg.c:1067
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
       ____sys_sendmsg+0xa4d/0xbe0 net/socket.c:2684
       ___sys_sendmsg+0x190/0x1e0 net/socket.c:2738
       __sys_sendmsg+0x160/0x210 net/socket.c:2770
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (cb_lock){++++}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       down_read+0x99/0x4c0 kernel/locking/rwsem.c:1574
       genl_release+0x7e/0x1d0 net/netlink/genetlink.c:697
       netlink_release+0x1058/0x1ff0 net/netlink/af_netlink.c:735
       __sock_release+0xb3/0x260 net/socket.c:710
       sock_close+0x1c/0x30 net/socket.c:1501
       __fput+0x3ff/0xb50 fs/file_table.c:512
       fput_close_sync+0x118/0x250 fs/file_table.c:617
       __do_sys_close fs/open.c:1511 [inline]
       __se_sys_close fs/open.c:1496 [inline]
       __x64_sys_close+0x8b/0x120 fs/open.c:1496
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}:
       check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3165
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x136c/0x1a40 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1024 [inline]
       __sock_release+0x86/0x260 net/socket.c:709
       sock_close+0x1c/0x30 net/socket.c:1501
       __fput+0x3ff/0xb50 fs/file_table.c:512
       __fput_sync+0xd4/0x100 fs/file_table.c:604
       nvme_tcp_alloc_queue.isra.0+0xd53/0x1750 drivers/nvme/host/tcp.c:1922
       nvme_tcp_alloc_admin_queue drivers/nvme/host/tcp.c:2107 [inline]
       nvme_tcp_configure_admin_queue+0x26/0x4d0 drivers/nvme/host/tcp.c:2261
       nvme_tcp_setup_ctrl+0xa4/0xa20 drivers/nvme/host/tcp.c:2391
       nvme_tcp_create_ctrl+0x975/0xd20 drivers/nvme/host/tcp.c:3014
       nvmf_create_ctrl drivers/nvme/host/fabrics.c:1359 [inline]
       nvmf_dev_write+0x4ee/0xb60 drivers/nvme/host/fabrics.c:1406
       vfs_write+0x2aa/0x1050 fs/read_write.c:685
       ksys_write+0x12a/0x250 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &sb->s_type->i_mutex_key#13 --> &p->lock --> nvmf_dev_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(nvmf_dev_mutex);
                               lock(&p->lock);
                               lock(nvmf_dev_mutex);
  lock(&sb->s_type->i_mutex_key#13);

 *** DEADLOCK ***

1 lock held by syz.3.2609/19125:
 #0: ffffffff8fd25f60 (nvmf_dev_mutex){+.+.}-{4:4}, at: nvmf_dev_write+0xa6/0xb60 drivers/nvme/host/fabrics.c:1400

stack backtrace:
CPU: 0 UID: 0 PID: 19125 Comm: syz.3.2609 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1c7 kernel/locking/lockdep.c:2043
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
 check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3165
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x136c/0x1a40 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
 down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1631
 inode_lock include/linux/fs.h:1024 [inline]
 __sock_release+0x86/0x260 net/socket.c:709
 sock_close+0x1c/0x30 net/socket.c:1501
 __fput+0x3ff/0xb50 fs/file_table.c:512
 __fput_sync+0xd4/0x100 fs/file_table.c:604
 nvme_tcp_alloc_queue.isra.0+0xd53/0x1750 drivers/nvme/host/tcp.c:1922
 nvme_tcp_alloc_admin_queue drivers/nvme/host/tcp.c:2107 [inline]
 nvme_tcp_configure_admin_queue+0x26/0x4d0 drivers/nvme/host/tcp.c:2261
 nvme_tcp_setup_ctrl+0xa4/0xa20 drivers/nvme/host/tcp.c:2391
 nvme_tcp_create_ctrl+0x975/0xd20 drivers/nvme/host/tcp.c:3014
 nvmf_create_ctrl drivers/nvme/host/fabrics.c:1359 [inline]
 nvmf_dev_write+0x4ee/0xb60 drivers/nvme/host/fabrics.c:1406
 vfs_write+0x2aa/0x1050 fs/read_write.c:685
 ksys_write+0x12a/0x250 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7da039e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7da1208028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f7da0625fa0 RCX: 00007f7da039e0d9
RDX: 0000000000000031 RSI: 0000200000000180 RDI: 0000000000000004
RBP: 00007f7da0435024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7da0626038 R14: 00007f7da0625fa0 R15: 00007fff358bed38
 </TASK>
bridge0: port 3(syz_tun) entered disabled state
syz_tun (unregistering): left allmulticast mode
syz_tun (unregistering): left promiscuous mode
bridge0: port 3(syz_tun) entered disabled state


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
