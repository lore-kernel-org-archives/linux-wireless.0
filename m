Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:33409 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762549Ab2KBBqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 21:46:32 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Tim Shepard <shep@laptop.org>, Daniel Drake <dsd@laptop.org>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: add support for SDIO card reset
Date: Thu,  1 Nov 2012 18:44:14 -0700
Message-Id: <1351820654-24433-1-git-send-email-bzhao@marvell.com> (sfid-20121102_024635_381574_DFE9BA9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When command timeout happens due to a bug in firmware/hardware,
the timeout handler just prints some debug information. User is
unable to reload the driver in this case.

Inspired by 9a821f5 "libertas: add sd8686 reset_card support",
this patch adds card reset support for SDIO interface when
command timeout happens. If the SDIO host contoller supports
MMC_POWER_OFF|UP|ON operations, the chip will be reset and the
firmware will be re-downloaded.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |    3 +++
 drivers/net/wireless/mwifiex/main.h   |    1 +
 drivers/net/wireless/mwifiex/sdio.c   |   33 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/sdio.h   |    1 +
 4 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index da6c491..c9528b3 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -944,6 +944,9 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	}
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);
+
+	if (adapter->if_ops.card_reset)
+		adapter->if_ops.card_reset(adapter);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 81f8772..68f3646 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -600,6 +600,7 @@ struct mwifiex_if_ops {
 	int (*event_complete) (struct mwifiex_adapter *, struct sk_buff *);
 	int (*data_complete) (struct mwifiex_adapter *, struct sk_buff *);
 	int (*dnld_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
+	void (*card_reset) (struct mwifiex_adapter *);
 };
 
 struct mwifiex_adapter {
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 8b81d8a..b3680f7 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1748,6 +1748,37 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 		port, card->mp_data_port_mask);
 }
 
+static struct mmc_host *reset_host;
+static void sdio_card_reset_worker(struct work_struct *work)
+{
+	/* The actual reset operation must be run outside of driver thread.
+	 * This is because mmc_remove_host() will cause the device to be
+	 * instantly destroyed, and the driver then needs to end its thread,
+	 * leading to a deadlock.
+	 *
+	 * We run it in a totally independent workqueue.
+	 */
+
+	pr_err("Resetting card...\n");
+	mmc_remove_host(reset_host);
+	/* 20ms delay is based on experiment with sdhci controller */
+	mdelay(20);
+	mmc_add_host(reset_host);
+}
+static DECLARE_WORK(card_reset_work, sdio_card_reset_worker);
+
+/* This function resets the card */
+static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
+{
+	struct sdio_mmc_card *card = adapter->card;
+
+	if (work_pending(&card_reset_work))
+		return;
+
+	reset_host = card->func->card->host;
+	schedule_work(&card_reset_work);
+}
+
 static struct mwifiex_if_ops sdio_ops = {
 	.init_if = mwifiex_init_sdio,
 	.cleanup_if = mwifiex_cleanup_sdio,
@@ -1766,6 +1797,7 @@ static struct mwifiex_if_ops sdio_ops = {
 	.cleanup_mpa_buf = mwifiex_cleanup_mpa_buf,
 	.cmdrsp_complete = mwifiex_sdio_cmdrsp_complete,
 	.event_complete = mwifiex_sdio_event_complete,
+	.card_reset = mwifiex_sdio_card_reset,
 };
 
 /*
@@ -1803,6 +1835,7 @@ mwifiex_sdio_cleanup_module(void)
 	/* Set the flag as user is removing this module. */
 	user_rmmod = 1;
 
+	cancel_work_sync(&card_reset_work);
 	sdio_unregister_driver(&mwifiex_sdio);
 }
 
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 2103373..8cc5468 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -25,6 +25,7 @@
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
+#include <linux/mmc/host.h>
 
 #include "main.h"
 
-- 
1.7.0.2

