Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:35877 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933214AbdELQmq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 12:42:46 -0400
Received: by mail-pg0-f48.google.com with SMTP id x64so13283505pgd.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 09:42:41 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 07/11] mwifiex: remove useless 'mwifiex_lock'
Date: Fri, 12 May 2017 09:42:04 -0700
Message-Id: <20170512164208.38725-7-briannorris@chromium.org> (sfid-20170512_184322_657913_E40A2753)
In-Reply-To: <20170512164208.38725-1-briannorris@chromium.org>
References: <20170512164208.38725-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If mwifiex_shutdown_drv() is racing with another mwifiex_shutdown_drv(),
we *really* have problems. Kill the lock.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/init.c | 4 ----
 drivers/net/wireless/marvell/mwifiex/main.h | 2 --
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 2ada202c72ec..2bff87bd76a6 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -439,7 +439,6 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 	struct mwifiex_private *priv;
 	s32 i, j;
 
-	spin_lock_init(&adapter->mwifiex_lock);
 	spin_lock_init(&adapter->int_lock);
 	spin_lock_init(&adapter->main_proc_lock);
 	spin_lock_init(&adapter->mwifiex_cmd_lock);
@@ -693,11 +692,8 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 
 	spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
 
-	spin_lock(&adapter->mwifiex_lock);
-
 	mwifiex_adapter_cleanup(adapter);
 
-	spin_unlock(&adapter->mwifiex_lock);
 	adapter->hw_status = MWIFIEX_HW_STATUS_NOT_READY;
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index bb2a467d8b13..66c184936c95 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -870,8 +870,6 @@ struct mwifiex_adapter {
 	bool rx_locked;
 	bool main_locked;
 	struct mwifiex_bss_prio_tbl bss_prio_tbl[MWIFIEX_MAX_BSS_NUM];
-	/* spin lock for init/shutdown */
-	spinlock_t mwifiex_lock;
 	/* spin lock for main process */
 	spinlock_t main_proc_lock;
 	u32 mwifiex_processing;
-- 
2.13.0.rc2.291.g57267f2277-goog
