Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:38405 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaJMXpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 19:45:14 -0400
Received: by mail-qc0-f171.google.com with SMTP id i17so5820897qcy.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2014 16:45:13 -0700 (PDT)
From: "S. Gilles" <sgilles@terpmail.umd.edu>
Date: Mon, 13 Oct 2014 19:45:09 -0400
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org
Subject: PROBLEM: Boot failure with bad RIP value
Message-ID: <20141013234509.GD22088@number18> (sfid-20141014_014518_955973_AE30B181)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Sending this to the right people this time, hopefully.)

I have been getting a consistent boot failure with 3.17, which I have
bisected to

38506ecefab911785d5e1aa5889f6eeb462e0954 is the first bad commit
commit 38506ecefab911785d5e1aa5889f6eeb462e0954
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Mon Sep 22 09:39:19 2014 -0500

    rtlwifi: rtl_pci: Start modification for new drivers
    
    Future patches will move the drivers for RTL8192EE and RTL8821AE
    from staging to the regular wireless tree. Here, the necessary features
    are added to the PCI driver. Other files are touched due to changes
    in the various data structs.
    
    Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

The end of the trace (hand-retyped, so there may be errors that
escaped me):

R10: ffffffff825f2d80 R11: 0000000000000000 R12: ffff8800b4f107c0
R13: ffff8800b4f124b8 R14: 0000000000001000 R15: ffff8800b4c7a000
FS:  000007fc66c938700(0000) GS:ffff88013e200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000b5438000 CR4: 00000000000407f0
Stack:
 ffffffffa01e20d6 ffff8800b4f12420 ffff8800b4f107c0 ffff880137d7fcd0
 ffffffffa01c97b5 ffff8800b4f107c0 ffff8800b4c7a8d0 0000000000000000
 ffff880137d7fd30 ffffffff81577304 0000000000000000 ffff8800b4c7a8c0
Call Trace:
 [<ffffffffa01e20d6>] ? rtl_pci_start+0x2b/0x15f [rtl_pci]
 [<ffffffffa01c97b5>] rtl_op_start+0x45/0x64 [rtlwifi]
 [<ffffffff81577304>] ieee80211_do_open+0x152/0xb4b
 [<ffffffff815b52bc>] ? mutex_unlock+0x9/0xb
 [<ffffffff81577d4a>] ieee80211_open+0x4d/0x57
 [<ffffffff8147df7f>] __dev_open+0x8b/0xcb
 [<ffffffff8147e1e1>] __dev_change_flags+0xa4/0x13a
 [<ffffffff8147e297>] dev_change_flags+0x20/0x53
 [<ffffffff814d0204>] devinet_ioctl+0x269/0x568
 [<ffffffff814d19b4>] inet_ioctl+0x81/0x9e
 [<ffffffff814654e6>] sock_do_ioctl+0x20/0x3d
 [<ffffffff81465a56>] sock_ioctl+0x20e/0x21a
 [<ffffffff81136242>] do_vfs_ioctl+0x39e/0x467
 [<ffffffff815b7277>] ? sysret_check+0x1b/0x56
 [<ffffffff810965fe>] ? trace_hardirqs_on_caller+0x16e/0x18a
 [<ffffffff81136343>] SyS_ioctl+0x38/0x5f
 [<ffffffff815b7252>] system_call_fastpath+0x16/0x1b
Code:  Bad RIP value.
RIP  [<          (null)>]           (null)
 RSP <ffff880137d7fc90>
CR2: 0000000000000000
---[ end trace 7307d2524c1e640b ]---

This is extremely easy to test (boot) and seems 100% reproducible.

I have submitted Bug 86211 - Boot failure: Bad RIP value for rtl8192ce
for this issue.

Thanks,
S. Gilles
