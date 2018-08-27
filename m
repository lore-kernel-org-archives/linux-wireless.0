Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39841 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbeH0PRo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 11:17:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id w14-v6so4049947plp.6
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2018 04:31:27 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Sasidhar Mudigonda <sasidhar.mudigonda@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Konduri <sanjay.konduri@redpinesignals.com>
Subject: [PATCH 2/2] rsi: improve kernel thread handling to fix kernel panic
Date: Mon, 27 Aug 2018 17:05:15 +0530
Message-Id: <1535369715-14254-2-git-send-email-siva8118@gmail.com> (sfid-20180827_133130_553491_6BEF5325)
In-Reply-To: <1535369715-14254-1-git-send-email-siva8118@gmail.com>
References: <1535369715-14254-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

While running regressions, observed below kernel panic when sdio disconnect
called. This is because of, kthread_stop() is taking care of
wait_for_completion() by default. When wait_for_completion triggered
in kthread_stop and as it was done already, giving kernel panic.
Hence, removing redundant wait_for_completion() from rsi_kill_thread().

... skipping ...
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff810a63df>] exit_creds+0x1f/0x50
PGD 0
Oops: 0002 [#1] SMP
CPU: 0 PID: 6502 Comm: rmmod Tainted: G  OE   4.15.9-Generic #154-Ubuntu
Hardware name: Dell Inc. Edge Gateway 3003/ , BIOS 01.00.00 04/17/2017
Stack:
ffff88007392e600 ffff880075847dc0 ffffffff8108160a 0000000000000000
ffff88007392e600 ffff880075847de8 ffffffff810a484b ffff880076127000
ffff88003cd3a800 ffff880074f12a00 ffff880075847e28 ffffffffc09bed15
Call Trace:
[<ffffffff8108160a>] __put_task_struct+0x5a/0x140
[<ffffffff810a484b>] kthread_stop+0x10b/0x110
[<ffffffffc09bed15>] rsi_disconnect+0x2f5/0x300 [ven_rsi_sdio]
[<ffffffff81578bcb>] ? __pm_runtime_resume+0x5b/0x80
[<ffffffff816f0918>] sdio_bus_remove+0x38/0x100
[<ffffffff8156cc64>] __device_release_driver+0xa4/0x150
[<ffffffff8156d7a5>] driver_detach+0xb5/0xc0
[<ffffffff8156c6c5>] bus_remove_driver+0x55/0xd0
[<ffffffff8156dfbc>] driver_unregister+0x2c/0x50
[<ffffffff816f0b8a>] sdio_unregister_driver+0x1a/0x20
[<ffffffffc09bf0f5>] rsi_module_exit+0x15/0x30 [ven_rsi_sdio]
[<ffffffff8110cad8>] SyS_delete_module+0x1b8/0x210
[<ffffffff81851dc8>] entry_SYSCALL_64_fastpath+0x1c/0xbb

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_common.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index d9ff3b8..60f1f28 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -75,7 +75,6 @@ static inline int rsi_kill_thread(struct rsi_thread *handle)
 	atomic_inc(&handle->thread_done);
 	rsi_set_event(&handle->event);
 
-	wait_for_completion(&handle->completion);
 	return kthread_stop(handle->task);
 }
 
-- 
2.5.5
