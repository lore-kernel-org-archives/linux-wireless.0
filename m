Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33432 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750896AbdGFOld (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:41:33 -0400
Received: by mail-pg0-f65.google.com with SMTP id u62so500519pgb.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:41:32 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v3 01/21] rsi: use BUILD_BUG_ON check for fsm_state
Date: Thu,  6 Jul 2017 20:07:04 +0530
Message-Id: <1499351844-2046-2-git-send-email-amitkarwar@gmail.com> (sfid-20170706_164135_924099_8728C9FC)
In-Reply-To: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Whenever new fsm_state enum element is added, fsm_state array
also needs to be updated. If this change is missed, we may end
up doing invalid access in array. BUILD_BUG_ON check will help
to avoid this problem.

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c | 2 ++
 drivers/net/wireless/rsi/rsi_main.h        | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index 4c0a493..f3b91b6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -138,6 +138,8 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
 	seq_puts(seq, "==> RSI STA DRIVER STATUS <==\n");
 	seq_puts(seq, "DRIVER_FSM_STATE: ");
 
+	BUILD_BUG_ON(ARRAY_SIZE(fsm_state) != NUM_FSM_STATES);
+
 	if (common->fsm_state <= FSM_MAC_INIT_DONE)
 		seq_printf(seq, "%s", fsm_state[common->fsm_state]);
 
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index f398525..72675eb 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -40,7 +40,9 @@ enum RSI_FSM_STATES {
 	FSM_RESET_MAC_SENT,
 	FSM_RADIO_CAPS_SENT,
 	FSM_BB_RF_PROG_SENT,
-	FSM_MAC_INIT_DONE
+	FSM_MAC_INIT_DONE,
+
+	NUM_FSM_STATES
 };
 
 extern u32 rsi_zone_enabled;
-- 
2.7.4
