Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:57202 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab1FHLy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 07:54:57 -0400
Subject: [PATCH 4/5] ath6kl: Fix a kernel panic furing suspend/resume
To: gregkh@suse.de
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Wed, 08 Jun 2011 14:54:50 +0300
Message-ID: <20110608115450.32208.58066.stgit@localhost6.localdomain6> (sfid-20110608_135500_035241_28DBB81F)
In-Reply-To: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

The kernel panic happens when we try to complete a pending
scan request while going to suspend state. The cause for this
kernel panic is accessing a freed memory (ar->arWmin). This
is freed before ar6k_cfg80211_scanComplete_event() getting
called where it is dereferenced.

RIP: 0010:[<ffffffffa042e726>]  [<ffffffffa042e726>] wlan_iterate_nodes+0x16/0xc0 [ath6kl]
RSP: 0018:ffff8800719fbce8  EFLAGS: 00010296
RAX: ffff880071bbcc00 RBX: ffff880037b22520 RCX: ffff880077413c80
RDX: ffff880037b221c0 RSI: ffffffffa041ef10 RDI: 0000000000000020
RBP: ffff8800719fbd18 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000400 R11: 0000000000000000 R12: 0000000000000010
R13: ffff8800719fbdd8 R14: 00007fff83a84b60 R15: 0000000000000001
FS:  00007fdccb8a7700(0000) GS:ffff880077400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000148 CR3: 0000000070604000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
	DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 1998, threadinfo ffff8800719fa000, task ffff880066712d80)
	Stack:
	0000000000000000 ffff880037b22520 0000000000000010 ffff8800719fbdd8
	00007fff83a84b60 0000000000000001 ffff8800719fbd28 ffffffffa0429fe2
	ffff8800719fbd58 ffffffffa041ee5f ffff8800719fbd58 ffff880037b22520
	Call Trace:
	[<ffffffffa0429fe2>] wmi_iterate_nodes+0x12/0x20 [ath6kl]
	[<ffffffffa041ee5f>] ar6k_cfg80211_scanComplete_event+0x3f/0xf0 [ath6kl]
	[<ffffffffa04245f1>] ar6000_close+0x61/0x100 [ath6kl]
	[<ffffffff814d6736>] __dev_close_many+0x96/0x100
	[<ffffffff814d688d>] dev_close_many+0x9d/0x120
	[<ffffffff814d6a48>] rollback_registered_many+0xe8/0x290
	[<ffffffff814d6d16>] unregister_netdevice_queue+0x96/0x100
	[<ffffffff814d6ea0>] unregister_netdev+0x20/0x30
	[<ffffffffa0420259>] ar6000_destroy+0x119/0x180 [ath6kl]
	[<ffffffffa043182a>] ar6k_cleanup_module+0x2a/0x33 [ath6kl]
	[<ffffffff81098fde>] sys_delete_module+0x19e/0x270
	[<ffffffff815d7542>] system_call_fastpath+0x16/0x1b
	Code: c3 0f 1f 40 00 48 89 df e8 68 ff ff ff eb df 66 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 00
	8b af 28 01 00 00 4c 8d 7f 08 49 89 fc 48 89 f3 49 89 d6 41
	RIP  [<ffffffffa042e726>] wlan_iterate_nodes+0x16/0xc0 [ath6kl]
	RSP <ffff8800719fbce8>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index a0c0819..07e6f55 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -871,7 +871,8 @@ ar6k_cfg80211_scanComplete_event(struct ar6_softc *ar, int status)
     if(ar->scan_request)
     {
         /* Translate data to cfg80211 mgmt format */
-        wmi_iterate_nodes(ar->arWmi, ar6k_cfg80211_scan_node, ar->wdev->wiphy);
+	if (ar->arWmi)
+		wmi_iterate_nodes(ar->arWmi, ar6k_cfg80211_scan_node, ar->wdev->wiphy);
 
         cfg80211_scan_done(ar->scan_request,
             ((status & A_ECANCELED) || (status & A_EBUSY)) ? true : false);

