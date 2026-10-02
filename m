Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC41344DAA
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 03:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790912428; cv=none; b=muRxOjiISTKWC02ksiLfACfEJLRSaZDbi446Kmd2gck/bMBQvCfyEeJ7kwB+z2WEgesRjogAD90fEYAbQJi9rtj0oIp2Am629tSedv6bO4VcTCR2J5ZwyI2JGQUFSjtmrnLgey3whHkI1W/FGU50+4FaHSYmhqYGRD680G9Xr0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790912428; c=relaxed/simple;
	bh=7DEnIPBCCKwg3iRZ58S7DgxGVdPCoT4ozRQnpe3AmZc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=FPMWTYOLNCg4dNKbzjhMOj0eo7H0/C5sOvUU9hkM6NtCOTH41BwJsxnb4oSxFzKu1ZNqxURUYNzkbDhbXZEPSDgckt6UVC1rrDuE1W1Cyw1kmxea5irr1RHg3qgMlBEdsKYzmL6FdH54OS1wZi1PAP0FONjhDAt46uoQgq+8gTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4c307941971so2404833b6e.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 20:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790912425; x=1791517225;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kMwz3JG6cUfXRqV2RJX7PZeX+DHxAQ564iCLriDAmU0=;
        b=IEVrJmdeySc97Zhg6hja2WufpdHQrOkayTCfYotHzzM5tPglJ5e8T3/k6cY3rSFQTy
         CADlOw4jCwBfsji1xORW4Up5axTvbGAH7nL7nUIs6mlbXVzdpEQbU9ktke6fZcYHuJLl
         /a/OcFig7GSMxPDDZzMy/XxxVL/tQApde/8+RXoChWY69h26xolQrxWlJxjcbB/nJ9/I
         Z+46W2VGSTUZBO+oGruu9AIF51HpyXdoGSPYbHD7TJbOzt7+wdVZYb1iKFFnI1ytuCUI
         GxLxckD4AUJyCKekrCNcxzWxJYwXcH/CfQqOr/pQ03PsY9uFMqEd4EWk11fMOFhF2bjX
         VIJQ==
X-Forwarded-Encrypted: i=1; AKwUvBwr1dGSWO/V4NXR8UxbMFKIlZ5Axycf6R9BQUCgkYLg056y0ZC39e+1cpjsNGfWGriW/kX8dPeE4mVjYeaKXA==@vger.kernel.org
X-Gm-Message-State: AFuF++mL9O4pAdByn9lJ3I/gijPQc5UiGEATdzhK+gBUASzIDHn8D4l9
	Vq20ILSVcaKdtKC8hTR2g09MzCK9jCn1eKVD/VgKndJN5rpzQ4uksJxsG9kt42fXhhnehdaMEqV
	iXlFG/1UVjQF/KwSROKDwn2XHV3oppP1U0t7yk7wTzCOqkwwPteUMVg18IUc=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c161:b0:4c4:a240:9c3a with SMTP id
 5614622812f47-4f526a4f2eamr1151205b6e.4.1790912425656; Thu, 01 Oct 2026
 20:40:25 -0700 (PDT)
Date: Thu, 01 Oct 2026 20:40:25 -0700
In-Reply-To: <6a74a7ae.01d0871a.3a0d52.001f.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abf27a9.b50370da.302ea9.0008.GAE@google.com>
Subject: Re: [syzbot] [nvme?] possible deadlock in __sock_release (2)
From: syzbot <syzbot+2398b0f6924a70b7de12@syzkaller.appspotmail.com>
To: hch@lst.de, johannes@sipsolutions.net, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org, sagi@grimberg.me, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    d24e8ac715de Merge tag 'net-7.3-rc6' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=161b2725580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d012d9c67977ee4
dashboard link: https://syzkaller.appspot.com/bug?extid=2398b0f6924a70b7de12
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1443cbf5580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2398b0f6924a70b7de12@syzkaller.appspotmail.com

nvme nvme0: failed to connect socket: -512
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor294/6008 is trying to acquire lock:
ffff888028dcf540 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
ffff888028dcf540 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release+0x86/0x260 net/socket.c:734

but task is already holding lock:
ffffffff8ff50aa0 (nvmf_dev_mutex){+.+.}-{4:4}, at: nvmf_dev_write+0xa6/0xb60 drivers/nvme/host/fabrics.c:1402

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (nvmf_dev_mutex){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       nvmf_dev_show+0x26/0x210 drivers/nvme/host/fabrics.c:1446
       seq_read_iter+0x32f/0x1270 fs/seq_file.c:231
       seq_read+0x344/0x4d0 fs/seq_file.c:163
       vfs_read+0x1e4/0xb40 fs/read_write.c:572
       ksys_read+0x12a/0x250 fs/read_write.c:716
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&p->lock){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
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
       do_open fs/namei.c:4839 [inline]
       path_openat+0x5cd/0x2440 fs/namei.c:5000
       do_file_open+0x20e/0x430 fs/namei.c:5029
       do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
       do_sys_open fs/open.c:1423 [inline]
       __do_sys_openat fs/open.c:1439 [inline]
       __se_sys_openat fs/open.c:1434 [inline]
       __x64_sys_openat+0x12d/0x210 fs/open.c:1434
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       process_measurement+0x5ab/0x2350 security/integrity/ima/ima_main.c:319
       ima_file_check+0xc3/0x110 security/integrity/ima/ima_main.c:685
       security_file_post_open+0xc4/0x210 security/security.c:2755
       do_open fs/namei.c:4839 [inline]
       path_openat+0x5cd/0x2440 fs/namei.c:5000
       do_file_open+0x20e/0x430 fs/namei.c:5029
       file_open_name+0x1c3/0x3e0 fs/open.c:1375
       filp_open+0x2e/0x50 fs/open.c:1392
       kernel_read_file_from_path_initns+0xec/0x240 fs/kernel_read_file.c:159
       fw_get_filesystem_firmware drivers/base/firmware_loader/main.c:549 [inline]
       _request_firmware+0x733/0x13c0 drivers/base/firmware_loader/main.c:873
       request_firmware+0x35/0x50 drivers/base/firmware_loader/main.c:948
       reg_reload_regdb+0x85/0x460 net/wireless/reg.c:1067
       genl_family_rcv_msg_doit+0x214/0x300 net/netlink/genetlink.c:1114
       genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
       genl_rcv_msg+0x560/0x800 net/netlink/genetlink.c:1209
       netlink_rcv_skb+0x159/0x420 net/netlink/af_netlink.c:2575
       genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
       netlink_unicast_kernel net/netlink/af_netlink.c:1338 [inline]
       netlink_unicast+0x585/0x850 net/netlink/af_netlink.c:1364
       netlink_sendmsg+0x8b0/0xda0 net/netlink/af_netlink.c:1919
       sock_sendmsg_nosec net/socket.c:800 [inline]
       __sock_sendmsg net/socket.c:815 [inline]
       __sys_sendto+0x48b/0x4e0 net/socket.c:2281
       __do_sys_sendto net/socket.c:2288 [inline]
       __se_sys_sendto net/socket.c:2284 [inline]
       __x64_sys_sendto+0xe0/0x1c0 net/socket.c:2284
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (cb_lock){++++}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       down_read+0x99/0x4c0 kernel/locking/rwsem.c:1574
       genl_release+0x7e/0x1d0 net/netlink/genetlink.c:697
       netlink_release+0x105e/0x2000 net/netlink/af_netlink.c:735
       __sock_release+0xb3/0x260 net/socket.c:735
       sock_close+0x1c/0x30 net/socket.c:1526
       __fput+0x3ff/0xb50 fs/file_table.c:512
       fput_close_sync+0x118/0x250 fs/file_table.c:617
       __do_sys_close fs/open.c:1560 [inline]
       __se_sys_close fs/open.c:1545 [inline]
       __x64_sys_close+0x8b/0x120 fs/open.c:1545
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}:
       check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3209
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x1528/0x1f40 kernel/locking/lockdep.c:5288
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1024 [inline]
       __sock_release+0x86/0x260 net/socket.c:734
       sock_close+0x1c/0x30 net/socket.c:1526
       __fput+0x3ff/0xb50 fs/file_table.c:512
       __fput_sync+0xd7/0x100 fs/file_table.c:604
       nvme_tcp_alloc_queue.isra.0+0xd6d/0x1770 drivers/nvme/host/tcp.c:1985
       nvme_tcp_alloc_admin_queue drivers/nvme/host/tcp.c:2171 [inline]
       nvme_tcp_configure_admin_queue+0x26/0x530 drivers/nvme/host/tcp.c:2325
       nvme_tcp_setup_ctrl+0xa4/0xa20 drivers/nvme/host/tcp.c:2455
       nvme_tcp_create_ctrl+0x970/0xd90 drivers/nvme/host/tcp.c:3083
       nvmf_create_ctrl drivers/nvme/host/fabrics.c:1361 [inline]
       nvmf_dev_write+0x4ee/0xb60 drivers/nvme/host/fabrics.c:1408
       vfs_write+0x2aa/0x1050 fs/read_write.c:685
       ksys_write+0x12a/0x250 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
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

locks held by syz-executor294/6008: 1, last CPU#2:
 #0: ffffffff8ff50aa0 (nvmf_dev_mutex){+.+.}-{4:4}, at: nvmf_dev_write+0xa6/0xb60 drivers/nvme/host/fabrics.c:1402

stack backtrace:
CPU: 2 UID: 0 PID: 6008 Comm: syz-executor294 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1be kernel/locking/lockdep.c:2087
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2219
 check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3209
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x1528/0x1f40 kernel/locking/lockdep.c:5288
 lock_acquire kernel/locking/lockdep.c:5942 [inline]
 lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
 down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1631
 inode_lock include/linux/fs.h:1024 [inline]
 __sock_release+0x86/0x260 net/socket.c:734
 sock_close+0x1c/0x30 net/socket.c:1526
 __fput+0x3ff/0xb50 fs/file_table.c:512
 __fput_sync+0xd7/0x100 fs/file_table.c:604
 nvme_tcp_alloc_queue.isra.0+0xd6d/0x1770 drivers/nvme/host/tcp.c:1985
 nvme_tcp_alloc_admin_queue drivers/nvme/host/tcp.c:2171 [inline]
 nvme_tcp_configure_admin_queue+0x26/0x530 drivers/nvme/host/tcp.c:2325
 nvme_tcp_setup_ctrl+0xa4/0xa20 drivers/nvme/host/tcp.c:2455
 nvme_tcp_create_ctrl+0x970/0xd90 drivers/nvme/host/tcp.c:3083
 nvmf_create_ctrl drivers/nvme/host/fabrics.c:1361 [inline]
 nvmf_dev_write+0x4ee/0xb60 drivers/nvme/host/fabrics.c:1408
 vfs_write+0x2aa/0x1050 fs/read_write.c:685
 ksys_write+0x12a/0x250 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb8f5809ede
Code: 08 0f 85 f5 e1 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 90 41 57 41 56 4d 89 c6 41 55 4d 89 cd 41 54 55 53 48 83 ec 08
RSP: 002b:00007fb8f57b21a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fb8f57b26c0 RCX: 00007fb8f5809ede
RDX: 0000000000000037 RSI: 00007fb8f5859618 RDI: 0000000000000003
RBP: 0000000000000021 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffd0
R13: 0000000000000002 R14: 00007ffdf198cb10 R15: 00007ffdf198cbf8
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
