Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:30910 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751933AbdLULPE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 06:15:04 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@qti.qualcomm.com>,
        Rakesh Pillai <pillair@qti.qualcomm.com>
Subject: [PATCH 1/3] ath10k: Add SNOC bus type for WCN3990 target
Date: Thu, 21 Dec 2017 16:44:45 +0530
Message-Id: <1513854887-10759-2-git-send-email-pillair@qti.qualcomm.com> (sfid-20171221_121508_367133_A77AE420)
In-Reply-To: <1513854887-10759-1-git-send-email-pillair@qti.qualcomm.com>
References: <1513854887-10759-1-git-send-email-pillair@qti.qualcomm.com>
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
index a5a3eeb569c5..8374b05f72b2 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1555,6 +1555,7 @@ static void ath10k_core_get_fw_name(struct ath10k *ar, char *fw_name,
 		break;
 	case ATH10K_BUS_PCI:
 	case ATH10K_BUS_AHB:
+	case ATH10K_BUS_SNOC:
 		scnprintf(fw_name, fw_name_len, "%s-%d.bin",
 			  ATH10K_FW_FILE_BASE, fw_api);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 30c4c07658d5..aeb446b4ff58 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -93,6 +93,7 @@ enum ath10k_bus {
 	ATH10K_BUS_AHB,
 	ATH10K_BUS_SDIO,
 	ATH10K_BUS_USB,
+	ATH10K_BUS_SNOC,
 };
 
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
@@ -106,6 +107,8 @@ static inline const char *ath10k_bus_str(enum ath10k_bus bus)
 		return "sdio";
 	case ATH10K_BUS_USB:
 		return "usb";
+	case ATH10K_BUS_SNOC:
+		return "snoc";
 	}
 
 	return "unknown";
-- 
2.11.0
