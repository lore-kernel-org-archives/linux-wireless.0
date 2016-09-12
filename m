Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33434 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757479AbcILJnj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:43:39 -0400
Received: by mail-pa0-f67.google.com with SMTP id h5so7563187pao.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 02:43:39 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        johannes.berg@intel.com, hofrat@osadl.org
Cc: prameela.j04cs@gmail.com, prameela.garnepudi@redpinesignals.com
Subject: [PATCH 6/9] rsi: code cleanup (spelling mistakes and new line after declaration) in file rsi_91x_sdio.c      Added developer name
Date: Mon, 12 Sep 2016 15:08:21 +0530
Message-Id: <b624fae62a96a117c4aed52a0626d575628d736c.1473669618.git.prameela.j04cs@gmail.com> (sfid-20160912_114342_848181_9C18D611)
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 8428858..d958f90 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1,6 +1,8 @@
 /**
  * Copyright (c) 2014 Redpine Signals Inc.
  *
+ * Developers:
+ *		Fariya Fathima	2014 <fariya.f@redpinesignals.com>
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
  * copyright notice and this permission notice appear in all copies.
@@ -128,7 +130,7 @@ static int rsi_issue_sdiocommand(struct sdio_func *func,
 }
 
 /**
- * rsi_handle_interrupt() - This function is called upon the occurence
+ * rsi_handle_interrupt() - This function is called upon the occurrence
  *			    of an interrupt.
  * @function: Pointer to the sdio_func structure.
  *
@@ -183,8 +185,7 @@ static void rsi_reset_card(struct sdio_func *pfunction)
 	host->ios.timing = MMC_TIMING_LEGACY;
 	host->ops->set_ios(host, &host->ios);
 
-	/*
-	 * This delay should be sufficient to allow the power supply
+	/* This delay should be sufficient to allow the power supply
 	 * to reach the minimum voltage.
 	 */
 	msleep(20);
@@ -193,8 +194,7 @@ static void rsi_reset_card(struct sdio_func *pfunction)
 	host->ios.power_mode = MMC_POWER_ON;
 	host->ops->set_ios(host, &host->ios);
 
-	/*
-	 * This delay must be at least 74 clock sizes, or 1 ms, or the
+	/* This delay must be at least 74 clock sizes, or 1 ms, or the
 	 * time required to reach a stable voltage.
 	 */
 	msleep(20);
@@ -361,6 +361,7 @@ static int rsi_setblocklength(struct rsi_hw *adapter, u32 length)
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	int status;
+
 	rsi_dbg(INIT_ZONE, "%s: Setting the block length\n", __func__);
 
 	status = sdio_set_block_size(dev->pfunction, length);
@@ -464,6 +465,7 @@ int rsi_sdio_write_register(struct rsi_hw *adapter,
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit)
 {
 	int status;
+
 	status = rsi_sdio_write_register(adapter,
 					 1,
 					 (SDIO_FUN1_INTR_CLR_REG |
@@ -473,8 +475,6 @@ void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit)
 		rsi_dbg(ERR_ZONE, "%s: unable to send ack\n", __func__);
 }
 
-
-
 /**
  * rsi_sdio_read_register_multiple() - This function read multiple bytes of
  *				       information from the SD card.
@@ -667,7 +667,7 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 		goto fail;
 	}
 
-	rsi_dbg(INIT_ZONE, "%s: Setup card succesfully\n", __func__);
+	rsi_dbg(INIT_ZONE, "%s: Setup card successfully\n", __func__);
 
 	status = rsi_init_sdio_slave_regs(adapter);
 	if (status) {
-- 
2.4.11
