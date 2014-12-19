Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35564 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaLSBBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 20:01:54 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [PATCH 2/5] ath9k: Add HW IDs for QCA956x
Date: Fri, 19 Dec 2014 06:33:56 +0530
Message-Id: <1418951039-12309-3-git-send-email-sujith@msujith.org> (sfid-20141219_020212_284807_15645127)
In-Reply-To: <1418951039-12309-1-git-send-email-sujith@msujith.org>
References: <1418951039-12309-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c | 4 ++++
 drivers/net/wireless/ath/ath9k/hw.c  | 4 ++++
 drivers/net/wireless/ath/ath9k/hw.h  | 1 +
 drivers/net/wireless/ath/ath9k/reg.h | 4 ++++
 4 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index e000c4c..bd4a1a6 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -43,6 +43,10 @@ static const struct platform_device_id ath9k_platform_id_table[] = {
 		.name = "qca953x_wmac",
 		.driver_data = AR9300_DEVID_AR953X,
 	},
+	{
+		.name = "qca956x_wmac",
+		.driver_data = AR9300_DEVID_QCA956X,
+	},
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6d4b273..49510ff 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -246,6 +246,8 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 	case AR9300_DEVID_AR953X:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9531;
 		return;
+	case AR9300_DEVID_QCA956X:
+		ah->hw_version.macVersion = AR_SREV_VERSION_9561;
 	}
 
 	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
@@ -536,6 +538,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	case AR_SREV_VERSION_9550:
 	case AR_SREV_VERSION_9565:
 	case AR_SREV_VERSION_9531:
+	case AR_SREV_VERSION_9561:
 		break;
 	default:
 		ath_err(common,
@@ -636,6 +639,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR9485_DEVID_AR1111:
 	case AR9300_DEVID_AR9565:
 	case AR9300_DEVID_AR953X:
+	case AR9300_DEVID_QCA956X:
 		break;
 	default:
 		if (common->bus_ops->ath_bus_type == ATH_USB)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1cbd335..64bfcbd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -54,6 +54,7 @@
 #define AR9485_DEVID_AR1111	0x0037
 #define AR9300_DEVID_AR9565     0x0036
 #define AR9300_DEVID_AR953X     0x003d
+#define AR9300_DEVID_QCA956X    0x003f
 
 #define AR5416_AR9100_DEVID	0x000b
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index fb11a91..eb2bb0d 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -814,6 +814,7 @@
 #define AR_SREV_REVISION_9531_10        0
 #define AR_SREV_REVISION_9531_11        1
 #define AR_SREV_REVISION_9531_20        2
+#define AR_SREV_VERSION_9561            0x600
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -974,6 +975,9 @@
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9531) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9531_20))
 
+#define AR_SREV_9561(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9561))
+
 /* NOTE: When adding chips newer than Peacock, add chip check here */
 #define AR_SREV_9580_10_OR_LATER(_ah) \
 	(AR_SREV_9580(_ah))
-- 
2.1.3

