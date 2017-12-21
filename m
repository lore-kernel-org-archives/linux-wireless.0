Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:43185 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdLUQFc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 11:05:32 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@qti.qualcomm.com>,
        Rakesh Pillai <pillair@qti.qualcomm.com>
Subject: [PATCH v2 1/3] ath10k: Add SNOC bus type for WCN3990 target
Date: Thu, 21 Dec 2017 21:35:20 +0530
Message-Id: <1513872322-26636-2-git-send-email-pillair@qti.qualcomm.com> (sfid-20171221_170546_108804_EE0DF759)
In-Reply-To: <1513872322-26636-1-git-send-email-pillair@qti.qualcomm.com>
References: <1513872322-26636-1-git-send-email-pillair@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Govind Singh <govinds@qti.qualcomm.com>

WCN3990 is integrated chipset which uses system NOC.
Add SNOC bus type and related definitions.

Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 drivers/net/wireless/ath/ath10k/core.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 042175a5653f..b6d5bad6f5ec 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1551,6 +1551,7 @@ static void ath10k_core_get_fw_name(struct ath10k *ar, char *fw_name,
 		break;
 	case ATH10K_BUS_PCI:
 	case ATH10K_BUS_AHB:
+	case ATH10K_BUS_SNOC:
 		scnprintf(fw_name, fw_name_len, "%s-%d.bin",
 			  ATH10K_FW_FILE_BASE, fw_api);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 398cd3c57139..81285ab30a7d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -92,6 +92,7 @@ enum ath10k_bus {
 	ATH10K_BUS_AHB,
 	ATH10K_BUS_SDIO,
 	ATH10K_BUS_USB,
+	ATH10K_BUS_SNOC,
 };
 
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
@@ -105,6 +106,8 @@ static inline const char *ath10k_bus_str(enum ath10k_bus bus)
 		return "sdio";
 	case ATH10K_BUS_USB:
 		return "usb";
+	case ATH10K_BUS_SNOC:
+		return "snoc";
 	}
 
 	return "unknown";
-- 
2.11.0
