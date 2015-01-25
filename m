Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31610 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbbAYIxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 03:53:36 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 07/10] wil6210: remove unnecessary interrupt moderation module parameters
Date: Sun, 25 Jan 2015 10:52:48 +0200
Message-Id: <1422175971-8075-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150125_095343_698391_A8614DEB)
In-Reply-To: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>

Interrupt moderation parameters will never be passed as module
parameters. For product, they will be hard-coded after lab testing,
and for debugging, they can be altered via debugfs.

Signed-off-by: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 38 +++++----------------------------
 1 file changed, 5 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 00c9b0f..d259416 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -33,34 +33,6 @@ static bool no_fw_load = true;
 module_param(no_fw_load, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(no_fw_load, " do not download FW, use one in on-card flash.");
 
-static unsigned int tx_interframe_timeout =
-		WIL6210_ITR_TX_INTERFRAME_TIMEOUT_DEFAULT;
-
-module_param(tx_interframe_timeout, uint, S_IRUGO);
-MODULE_PARM_DESC(tx_interframe_timeout,
-		 " Interrupt moderation TX interframe timeout, usecs.");
-
-static unsigned int rx_interframe_timeout =
-		WIL6210_ITR_RX_INTERFRAME_TIMEOUT_DEFAULT;
-
-module_param(rx_interframe_timeout, uint, S_IRUGO);
-MODULE_PARM_DESC(rx_interframe_timeout,
-		 " Interrupt moderation RX interframe timeout, usecs.");
-
-static unsigned int tx_max_burst_duration =
-		WIL6210_ITR_TX_MAX_BURST_DURATION_DEFAULT;
-
-module_param(tx_max_burst_duration, uint, S_IRUGO);
-MODULE_PARM_DESC(tx_max_burst_duration,
-		 " Interrupt moderation TX max burst duration, usecs.");
-
-static unsigned int rx_max_burst_duration =
-		WIL6210_ITR_RX_MAX_BURST_DURATION_DEFAULT;
-
-module_param(rx_max_burst_duration, uint, S_IRUGO);
-MODULE_PARM_DESC(rx_max_burst_duration,
-		 " Interrupt moderation RX max burst duration, usecs.");
-
 /* if not set via modparam, will be set to default value of 1/8 of
  * rx ring size during init flow
  */
@@ -463,10 +435,10 @@ int wil_priv_init(struct wil6210_priv *wil)
 		goto out_wmi_wq;
 
 	wil->last_fw_recovery = jiffies;
-	wil->tx_interframe_timeout = tx_interframe_timeout;
-	wil->rx_interframe_timeout = rx_interframe_timeout;
-	wil->tx_max_burst_duration = tx_max_burst_duration;
-	wil->rx_max_burst_duration = rx_max_burst_duration;
+	wil->tx_interframe_timeout = WIL6210_ITR_TX_INTERFRAME_TIMEOUT_DEFAULT;
+	wil->rx_interframe_timeout = WIL6210_ITR_RX_INTERFRAME_TIMEOUT_DEFAULT;
+	wil->tx_max_burst_duration = WIL6210_ITR_TX_MAX_BURST_DURATION_DEFAULT;
+	wil->rx_max_burst_duration = WIL6210_ITR_RX_MAX_BURST_DURATION_DEFAULT;
 
 	if (rx_ring_overflow_thrsh == WIL6210_RX_HIGH_TRSH_INIT)
 		rx_ring_overflow_thrsh = WIL6210_RX_HIGH_TRSH_DEFAULT;
-- 
2.1.0

