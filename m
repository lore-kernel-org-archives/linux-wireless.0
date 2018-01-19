Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18602 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755285AbeASPhN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 10:37:13 -0500
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codaurora.org>
Subject: [PATCH 2/8] wil6210: recognize Talyn JTAG ID
Date: Fri, 19 Jan 2018 17:36:58 +0200
Message-Id: <1516376224-13976-3-git-send-email-merez@codeaurora.org> (sfid-20180119_163720_327992_BAAF3CD1)
In-Reply-To: <1516376224-13976-1-git-send-email-merez@codeaurora.org>
References: <1516376224-13976-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add Talyn JTAG ID to the list of valid IDs
and identify this device as Talyn.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 4 ++++
 drivers/net/wireless/ath/wil6210/wil6210.h  | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index f8c7a6b..2b3b1f7 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -73,6 +73,10 @@ void wil_set_capabilities(struct wil6210_priv *wil)
 			break;
 		}
 		break;
+	case JTAG_DEV_ID_TALYN:
+		wil->hw_name = "Talyn";
+		wil->hw_version = HW_VER_TALYN;
+		break;
 	default:
 		wil_err(wil, "Unknown board hardware, chip_id 0x%08x, chip_revision 0x%08x\n",
 			jtag_id, chip_revision);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 0a0766b..a59a553 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -286,6 +287,7 @@ struct RGF_ICR {
 
 #define RGF_USER_JTAG_DEV_ID	(0x880b34) /* device ID */
 	#define JTAG_DEV_ID_SPARROW	(0x2632072f)
+	#define JTAG_DEV_ID_TALYN	(0x7e0e1)
 
 #define RGF_USER_REVISION_ID		(0x88afe4)
 #define RGF_USER_REVISION_ID_MASK	(3)
@@ -300,6 +302,7 @@ enum {
 	HW_VER_UNKNOWN,
 	HW_VER_SPARROW_B0, /* REVISION_ID_SPARROW_B0 */
 	HW_VER_SPARROW_D0, /* REVISION_ID_SPARROW_D0 */
+	HW_VER_TALYN,	/* JTAG_DEV_ID_TALYN */
 };
 
 /* popular locations */
-- 
1.9.1
