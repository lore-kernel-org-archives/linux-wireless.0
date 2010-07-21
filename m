Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632Ab0GURfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:35:19 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 16/20] mmc: introduce API to control the card's power
Date: Wed, 21 Jul 2010 20:33:50 +0300
Message-Id: <1279733634-21974-17-git-send-email-ohad@wizery.com>
In-Reply-To: <1279733634-21974-1-git-send-email-ohad@wizery.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce the sdio_claim_power/sdio_release_power API
(with correspoding mmc_claim_power/mmc_release_power)
that controls the power of the card. A reference count
scheme is employed, to allow SDIO function voting.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/bus.c        |    3 ++
 drivers/mmc/core/core.c       |   50 +++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/sdio.c       |    5 ++++
 drivers/mmc/core/sdio_io.c    |   50 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/card.h      |    2 +
 include/linux/mmc/host.h      |    2 +
 include/linux/mmc/sdio_func.h |    3 ++
 7 files changed, 115 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 49d9dca..33151d5 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -17,6 +17,7 @@
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
+#include <asm/atomic.h>
 
 #include "core.h"
 #include "sdio_cis.h"
@@ -207,6 +208,8 @@ struct mmc_card *mmc_alloc_card(struct mmc_host *host, struct device_type *type)
 
 	card->host = host;
 
+	atomic_set(&card->power_claims, 0);
+
 	device_initialize(&card->dev);
 
 	card->dev.parent = mmc_classdev(host);
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 569e94d..ca5e3bf 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1334,6 +1334,56 @@ EXPORT_SYMBOL(mmc_resume_host);
 
 #endif
 
+/**
+ *	mmc_release_power - remove power from the card
+ *	@host: mmc host
+ */
+int mmc_release_power(struct mmc_host *host)
+{
+	int err = 0;
+
+	mmc_bus_get(host);
+	if (host->bus_ops && !host->bus_dead) {
+		if (host->bus_ops->suspend)
+			err = host->bus_ops->suspend(host);
+			/* it's ok not to have a suspend handler */
+			err = err == -ENOSYS ? 0 : err;
+	}
+	mmc_bus_put(host);
+
+	if (!err)
+		mmc_power_off(host);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mmc_release_power);
+
+/*
+ *	mmc_claim_power - power up card
+ *	@host: mmc host
+ */
+int mmc_claim_power(struct mmc_host *host)
+{
+	int err = 0;
+
+	mmc_bus_get(host);
+
+	mmc_power_up(host);
+	mmc_select_voltage(host, host->ocr);
+
+	BUG_ON(!host->bus_ops->resume);
+	err = host->bus_ops->resume(host);
+	if (err) {
+		printk(KERN_WARNING "%s: error %d during resume "
+					    "(card was removed?)\n",
+					    mmc_hostname(host), err);
+	}
+	mmc_bus_put(host);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mmc_claim_power);
+
 static int __init mmc_init(void)
 {
 	int ret;
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 37739f5..79e6fa1 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -15,6 +15,7 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_func.h>
+#include <asm/atomic.h>
 
 #include "core.h"
 #include "bus.h"
@@ -72,6 +73,10 @@ static int sdio_init_func(struct mmc_card *card, unsigned int fn)
 
 	card->sdio_func[fn - 1] = func;
 
+	/* For each SDIO function initialized, increase the power claim
+	 * reference count of the card */
+	atomic_inc(&card->power_claims);
+
 	return 0;
 
 fail:
diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 0f687cd..28ebc16 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -17,6 +17,56 @@
 #include "sdio_ops.h"
 
 /**
+ *	sdio_release_power - allow to release power of a certain SDIO function
+ *	@func: SDIO function that is accessed
+ *
+ *	Indicate to the core SDIO layer that we're not requiring that the
+ *	function remain powered.  If all functions for the card are in the
+ *	same "no power" state, then the host controller can remove power from
+ *	the card.  Note: the function driver must preserve hardware states if
+ *	necessary.
+ */
+int sdio_release_power(struct sdio_func *func)
+{
+	int ret = 0;
+	BUG_ON(!func);
+	BUG_ON(!func->card);
+
+	if (atomic_dec_and_test(&func->card->power_claims))
+		ret = mmc_release_power(func->card->host);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sdio_release_power);
+
+/*
+ *	sdio_claim_power - request power for a certain SDIO function
+ *	@func: SDIO function that is accessed
+ *
+ *	Indicate to the core SDIO layer that we want power back for this
+ *	SDIO function.  The power may or may not actually have been removed
+ *	since last call to sdio_release_power(), so the function driver must
+ *	not assume any preserved state at the hardware level and re-perform
+ *	all the necessary hardware config.  This function returns 0 when
+ *	power is actually restored, or some error code if this cannot be
+ *	achieved.  One error reason might be that the card is no longer
+ *	available on the bus (was removed while powered down and card
+ *	detection didn't trigger yet).
+ */
+int sdio_claim_power(struct sdio_func *func)
+{
+	int ret = 0;
+	BUG_ON(!func);
+	BUG_ON(!func->card);
+
+	if (atomic_inc_return(&func->card->power_claims) == 1)
+		ret = mmc_claim_power(func->card->host);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sdio_claim_power);
+
+/**
  *	sdio_claim_host - exclusively claim a bus for a certain SDIO function
  *	@func: SDIO function that will be accessed
  *
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index d02d2c6..4073b43 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -11,6 +11,7 @@
 #define LINUX_MMC_CARD_H
 
 #include <linux/mmc/core.h>
+#include <asm/atomic.h>
 
 struct mmc_cid {
 	unsigned int		manfid;
@@ -120,6 +121,7 @@ struct mmc_card {
 	struct sdio_func_tuple	*tuples;	/* unknown common tuples */
 
 	struct dentry		*debugfs_root;
+	atomic_t		power_claims;	/* ref count of power requests */
 };
 
 #define mmc_card_mmc(c)		((c)->type == MMC_TYPE_MMC)
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 80db597..3675d58 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -234,6 +234,8 @@ static inline void *mmc_priv(struct mmc_host *host)
 
 extern int mmc_suspend_host(struct mmc_host *);
 extern int mmc_resume_host(struct mmc_host *);
+extern int mmc_release_power(struct mmc_host *);
+extern int mmc_claim_power(struct mmc_host *);
 
 extern void mmc_power_save_host(struct mmc_host *host);
 extern void mmc_power_restore_host(struct mmc_host *host);
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index 31baaf8..e77b676 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -116,6 +116,9 @@ extern void sdio_unregister_driver(struct sdio_driver *);
 /*
  * SDIO I/O operations
  */
+int sdio_claim_power(struct sdio_func *func);
+int sdio_release_power(struct sdio_func *func);
+
 extern void sdio_claim_host(struct sdio_func *func);
 extern void sdio_release_host(struct sdio_func *func);
 
-- 
1.7.0.4

