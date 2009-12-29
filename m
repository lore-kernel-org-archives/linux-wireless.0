Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52253 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbZL2UcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2009 15:32:09 -0500
To: linux-wireless@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: wl1251: crash in /sys/module/wl1251_spi/notes
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 29 Dec 2009 22:31:58 +0200
Message-ID: <87y6klwmgx.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I noticed that wl1251_spi was crashing while rmmoding it with 2.6.33
kernels (from wireless-testing) on a nokia n900 (rx51_defconfig plus
some changes). [1] 

I did some investigation and I think kernel/module.c is adding sysfs
file with a null string as the name and that causes the crash during
rmmod while the sysfs file is removed. For example, I can crash the
kernel just by executing this command: [2]

ls -a /sys/module/wl1251_spi/notes

This happens everytime with wl1251_spi, but not with other modules.
For example wl1251 seems to work fine:

Nokia-N900-42-9:~# ls -a /sys/module/wl1251/notes/
.                   ..                  .note.gnu.build-id
Nokia-N900-42-9:~# 

The toolchain I'm using:

gcc version 4.4.1 (Sourcery G++ Lite 2009q3-67) 

Any ideas how to debug this further? Anyone seen, or heard, about
similar problems? I didn't notice this problem on 2.6.32 with the same
setup.

[1] crash log from rmmod wl1251_spi:

[ 3856.875579] wl1251: unloaded
[ 3856.878784] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[ 3856.887084] pgd = cd02c000
[ 3856.889892] [00000000] *pgd=8d78d031, *pte=00000000, *ppte=00000000
[ 3856.896270] Internal error: Oops: 17 [#1]
[ 3856.900329] last sysfs file: /sys/class/net/wlan0/flags
[ 3856.905609] Modules linked in: wl1251 mac80211 cfg80211 [last
unloaded: wl1251_spi]
[ 3856.913421] CPU: 0    Not tainted  (2.6.33-rc2-wl-47089-g7bfbe2a
#449)
[ 3856.920013] PC is at strcmp+0x4/0x34
[ 3856.923645] LR is at sysfs_find_dirent+0x18/0x38
[ 3856.928344] pc : [<c01475d0>]    lr : [<c00f5f08>]    psr: a0000013
[ 3856.928344] sp : cd073f00  ip : 22222222  fp : bea5767c
[ 3856.939941] r10: 00000000  r9 : cd072000  r8 : c002bae4
[ 3856.945220] r7 : bea54de8  r6 : 00000000  r5 : 00000000  r4 :
cd031458
[ 3856.951812] r3 : 00000000  r2 : ffffffd0  r1 : 00000000  r0 :
00000000
[ 3856.958404] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment user
[ 3856.965637] Control: 10c5387d  Table: 8d02c019  DAC: 00000015
[ 3856.971435] Process rmmod (pid: 4930, stack limit = 0xcd0722e8)
[ 3856.977416] Stack: (0xcd073f00 to 0xcd074000)
[ 3856.981842] 3f00: 22222222 cd031488 cd073f10 c00f4c94 cd031488
00000000 cfa4df00 00000000
[ 3856.990112] 3f20: cd073f44 c007c3ac bf08875c 00000000 cd073f44
c007c748 bf08875c c007ca54
[ 3856.998382] 3f40: cf11d108 32316c77 735f3135 cf006970 c009db38
cf374100 00000001 cf374100
[ 3857.006652] 3f60: c025e6c0 4001e000 cf11d0c0 c0072d44 00000001
cf374100 c002ba54 00a54e10
[ 3857.014953] 3f80: bf08875c 00000880 cd073f8c 00000000 bea54e10
00000000 bea54de8 bea54e10
[ 3857.023223] 3fa0: 00000081 c002b940 00000000 bea54de8 bea54de8
00000880 40151028 00000000
[ 3857.031494] 3fc0: 00000000 bea54de8 bea54e10 00000081 00000880
00000000 00000000 bea5767c
[ 3857.039764] 3fe0: 00000003 bea54de0 00008b38 400f0efc 60000010
bea54de8 00004e15 00001f02
[ 3857.048034] [<c01475d0>] (strcmp+0x4/0x34) from [<c00f5f08>]
(sysfs_find_dirent+0x18/0x38)
[ 3857.056427] [<c00f5f08>] (sysfs_find_dirent+0x18/0x38) from
[<c00f4c94>] (sysfs_hash_and_remove+0x2c/0x5c)
[ 3857.066192] [<c00f4c94>] (sysfs_hash_and_remove+0x2c/0x5c) from
[<c007c3ac>] (free_notes_attrs+0x28/0x4c)
[ 3857.075866] [<c007c3ac>] (free_notes_attrs+0x28/0x4c) from
[<c007c748>] (free_module+0x34/0xe4)
[ 3857.084686] [<c007c748>] (free_module+0x34/0xe4) from [<c007ca54>]
(sys_delete_module+0x224/0x260)
[ 3857.093750] [<c007ca54>] (sys_delete_module+0x224/0x260) from
[<c002b940>] (ret_fast_syscall+0x0/0x38)
[ 3857.103179] Code: e28cc001 1afffff3 e8bd8030 e3a03000 (e7d02003) 
[ 3857.109405] ---[ end trace e201521161943231 ]---
[ 3857.114074] Kernel panic - not syncing: Fatal exception

[2] crash log from ls:

Nokia-N900-42-9:~# ls -a /sys/module/wl1251_spi/notes
[ 3823.873168] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[ 3823.881530] pgd = cccfc000
[ 3823.884277] [00000000] *pgd=8f08b031, *pte=00000000, *ppte=00000000
[ 3823.890747] Internal error: Oops: 17 [#1]
[ 3823.894805] last sysfs file: /sys/class/net/wlan0/flags
[ 3823.900085] Modules linked in: wl1251_spi wl1251 mac80211 cfg80211
[ 3823.906402] CPU: 0    Not tainted
(2.6.33-rc2-wl-47089-g7bfbe2a-dirty #1)
[ 3823.913360] PC is at strlen+0xc/0x20
[ 3823.916992] LR is at sysfs_readdir+0x15c/0x1e0
[ 3823.921508] pc : [<c014772c>]    lr : [<c00f5ec4>]    psr: a0000013
[ 3823.921508] sp : cd1a1f28  ip : 22222222  fp : bef3760c
[ 3823.933105] r10: cd1a1f80  r9 : 00000000  r8 : 00000000
[ 3823.938385] r7 : c00b9598  r6 : cd1a1f80  r5 : cd1d8458  r4 :
cf398d80
[ 3823.944976] r3 : 00000000  r2 : 00000002  r1 : 22222222  r0 :
00000000
[ 3823.951599] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment user
[ 3823.958801] Control: 10c5387d  Table: 8ccfc019  DAC: 00000015
[ 3823.964599] Process ls (pid: 1143, stack limit = 0xcd1a02e8)
[ 3823.970336] Stack: (0xcd1a1f28 to 0xcd1a2000)
[ 3823.974731] 1f20:                   00000001 00000000 00000e16
00000000 00000004 22222222
[ 3823.983032] 1f40: cf398d80 cf398d80 cf7a834c c00b9598 00000000
cf7a82b8 cd1a0000 c00b9884
[ 3823.991302] 1f60: 00000001 00000000 00001000 000690d0 cf398d80
c002bae4 00000000 c00b991c
[ 3823.999572] 1f80: 00069100 000690e8 00000fd0 ffffffea 00000000
00000000 00000000 00000000
[ 3824.007843] 1fa0: 000000d9 c002b940 00000000 00000000 00000003
000690d0 00001000 00000000
[ 3824.016113] 1fc0: 00000000 00000000 00000000 000000d9 000690c8
00000001 00000000 bef3760c
[ 3824.024383] 1fe0: 400ef954 bef37604 400efa10 400ef908 60000010
00000003 00001802 0005e91c
[ 3824.032684] [<c014772c>] (strlen+0xc/0x20) from [<c00f5ec4>]
(sysfs_readdir+0x15c/0x1e0)
[ 3824.040893] [<c00f5ec4>] (sysfs_readdir+0x15c/0x1e0) from
[<c00b9884>] (vfs_readdir+0x80/0xb4)
[ 3824.049591] [<c00b9884>] (vfs_readdir+0x80/0xb4) from [<c00b991c>]
(sys_getdents64+0x64/0xb4)
[ 3824.058258] [<c00b991c>] (sys_getdents64+0x64/0xb4) from
[<c002b940>] (ret_fast_syscall+0x0/0x38)
[ 3824.067230] Code: c02770d4 e1a03000 ea000000 e2833001 (e5d32000) 
[ 3824.073455] ---[ end trace 7191ebb2793d480e ]---
[ 3824.078186] Kernel panic - not syncing: Fatal exception

-- 
Kalle Valo
