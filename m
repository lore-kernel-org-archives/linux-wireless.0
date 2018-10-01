Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCA0C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 21:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E37EE2089A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 21:38:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E37EE2089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=atomide.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbeJBESB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 00:18:01 -0400
Received: from muru.com ([72.249.23.125]:58038 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbeJBESB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 00:18:01 -0400
Received: from hillo.muru.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTP id BF7C080F0;
        Mon,  1 Oct 2018 21:42:37 +0000 (UTC)
From:   Tony Lindgren <tony@atomide.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH] wlcore: Fix BUG with clear completion on timeout
Date:   Mon,  1 Oct 2018 14:38:05 -0700
Message-Id: <20181001213805.86511-1-tony@atomide.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We do not currently clear wl->elp_compl on ELP timeout and we have bogus
lingering pointer that wlcore_irq then will try to access after recovery
is done:

BUG: spinlock bad magic on CPU#1, irq/255-wl12xx/580
...
(spin_dump) from [<c01b9344>] (do_raw_spin_lock+0xc8/0x124)
(do_raw_spin_lock) from [<c09b3970>] (_raw_spin_lock_irqsave+0x68/0x74)
(_raw_spin_lock_irqsave) from [<c01a02f0>] (complete+0x24/0x58)
(complete) from [<bf572610>] (wlcore_irq+0x48/0x17c [wlcore])
(wlcore_irq [wlcore]) from [<c01c5efc>] (irq_thread_fn+0x2c/0x64)
(irq_thread_fn) from [<c01c623c>] (irq_thread+0x148/0x290)
(irq_thread) from [<c016b4b0>] (kthread+0x160/0x17c)
(kthread) from [<c01010b4>] (ret_from_fork+0x14/0x20)
...

After that the system will hang. Let's fix this by adding a flag for
recovery and moving the recovery work call to to the error handling
section.

And we want to set WL1271_FLAG_INTENDED_FW_RECOVERY and actually clear
it too in wl1271_recovery_work() and just downgrade the error to a
warning to prevent overly verbose output.

Cc: Eyal Reizer <eyalr@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -957,6 +957,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 	BUG_ON(wl->conf.recovery.bug_on_recovery &&
 	       !test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
 
+	clear_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags);
+
 	if (wl->conf.recovery.no_recovery) {
 		wl1271_info("No recovery (chosen on module load). Fw will remain stuck.");
 		goto out_unlock;
@@ -6710,6 +6712,7 @@ static int __maybe_unused wlcore_runtime_resume(struct device *dev)
 	int ret;
 	unsigned long start_time = jiffies;
 	bool pending = false;
+	bool recovery = false;
 
 	/* Nothing to do if no ELP mode requested */
 	if (!test_bit(WL1271_FLAG_IN_ELP, &wl->flags))
@@ -6726,7 +6729,7 @@ static int __maybe_unused wlcore_runtime_resume(struct device *dev)
 
 	ret = wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
 	if (ret < 0) {
-		wl12xx_queue_recovery_work(wl);
+		recovery = true;
 		goto err;
 	}
 
@@ -6734,11 +6737,12 @@ static int __maybe_unused wlcore_runtime_resume(struct device *dev)
 		ret = wait_for_completion_timeout(&compl,
 			msecs_to_jiffies(WL1271_WAKEUP_TIMEOUT));
 		if (ret == 0) {
-			wl1271_error("ELP wakeup timeout!");
-			wl12xx_queue_recovery_work(wl);
+			wl1271_warning("ELP wakeup timeout!");
 
 			/* Return no error for runtime PM for recovery */
-			return 0;
+			ret = 0;
+			recovery = true;
+			goto err;
 		}
 	}
 
@@ -6753,6 +6757,12 @@ static int __maybe_unused wlcore_runtime_resume(struct device *dev)
 	spin_lock_irqsave(&wl->wl_lock, flags);
 	wl->elp_compl = NULL;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	if (recovery) {
+		set_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags);
+		wl12xx_queue_recovery_work(wl);
+	}
+
 	return ret;
 }
 
-- 
2.19.0
