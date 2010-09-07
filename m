Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49491 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab0IGL3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 07:29:39 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v1 2/8] mmc: propagate power save/restore ops return value
Date: Tue,  7 Sep 2010 14:29:03 +0300
Message-Id: <1283858949-11073-3-git-send-email-ohad@wizery.com>
In-Reply-To: <1283858949-11073-1-git-send-email-ohad@wizery.com>
References: <1283858949-11073-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow power save/restore and their relevant mmc_bus_ops handlers exit with a return value.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/core.c  |   20 ++++++++++++++------
 drivers/mmc/core/core.h  |    4 ++--
 drivers/mmc/core/mmc.c   |    8 ++++++--
 drivers/mmc/core/sd.c    |    8 ++++++--
 include/linux/mmc/host.h |    4 ++--
 5 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 5db49b1..73575c4 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1538,37 +1538,45 @@ void mmc_stop_host(struct mmc_host *host)
 	mmc_power_off(host);
 }
 
-void mmc_power_save_host(struct mmc_host *host)
+int mmc_power_save_host(struct mmc_host *host)
 {
+	int ret = 0;
+
 	mmc_bus_get(host);
 
 	if (!host->bus_ops || host->bus_dead || !host->bus_ops->power_restore) {
 		mmc_bus_put(host);
-		return;
+		return -EINVAL;
 	}
 
 	if (host->bus_ops->power_save)
-		host->bus_ops->power_save(host);
+		ret = host->bus_ops->power_save(host);
 
 	mmc_bus_put(host);
 
 	mmc_power_off(host);
+
+	return ret;
 }
 EXPORT_SYMBOL(mmc_power_save_host);
 
-void mmc_power_restore_host(struct mmc_host *host)
+int mmc_power_restore_host(struct mmc_host *host)
 {
+	int ret;
+
 	mmc_bus_get(host);
 
 	if (!host->bus_ops || host->bus_dead || !host->bus_ops->power_restore) {
 		mmc_bus_put(host);
-		return;
+		return -EINVAL;
 	}
 
 	mmc_power_up(host);
-	host->bus_ops->power_restore(host);
+	ret = host->bus_ops->power_restore(host);
 
 	mmc_bus_put(host);
+
+	return ret;
 }
 EXPORT_SYMBOL(mmc_power_restore_host);
 
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 9d9eef5..fff58fa 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -22,8 +22,8 @@ struct mmc_bus_ops {
 	void (*detect)(struct mmc_host *);
 	int (*suspend)(struct mmc_host *);
 	int (*resume)(struct mmc_host *);
-	void (*power_save)(struct mmc_host *);
-	void (*power_restore)(struct mmc_host *);
+	int (*power_save)(struct mmc_host *);
+	int (*power_restore)(struct mmc_host *);
 };
 
 void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops);
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 6909a54..1f69f5a 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -623,12 +623,16 @@ static int mmc_resume(struct mmc_host *host)
 	return err;
 }
 
-static void mmc_power_restore(struct mmc_host *host)
+static int mmc_power_restore(struct mmc_host *host)
 {
+	int ret;
+
 	host->card->state &= ~MMC_STATE_HIGHSPEED;
 	mmc_claim_host(host);
-	mmc_init_card(host, host->ocr, host->card);
+	ret = mmc_init_card(host, host->ocr, host->card);
 	mmc_release_host(host);
+
+	return ret;
 }
 
 static int mmc_sleep(struct mmc_host *host)
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 0f52410..32c58b4 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -722,12 +722,16 @@ static int mmc_sd_resume(struct mmc_host *host)
 	return err;
 }
 
-static void mmc_sd_power_restore(struct mmc_host *host)
+static int mmc_sd_power_restore(struct mmc_host *host)
 {
+	int ret;
+
 	host->card->state &= ~MMC_STATE_HIGHSPEED;
 	mmc_claim_host(host);
-	mmc_sd_init_card(host, host->ocr, host->card);
+	ret = mmc_sd_init_card(host, host->ocr, host->card);
 	mmc_release_host(host);
+
+	return ret;
 }
 
 static const struct mmc_bus_ops mmc_sd_ops = {
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 1575b52..0935841 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -236,8 +236,8 @@ static inline void *mmc_priv(struct mmc_host *host)
 extern int mmc_suspend_host(struct mmc_host *);
 extern int mmc_resume_host(struct mmc_host *);
 
-extern void mmc_power_save_host(struct mmc_host *host);
-extern void mmc_power_restore_host(struct mmc_host *host);
+extern int mmc_power_save_host(struct mmc_host *host);
+extern int mmc_power_restore_host(struct mmc_host *host);
 
 extern void mmc_detect_change(struct mmc_host *, unsigned long delay);
 extern void mmc_request_done(struct mmc_host *, struct mmc_request *);
-- 
1.7.0.4

