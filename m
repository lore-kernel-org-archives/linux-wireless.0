Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49825 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3L3EVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Dec 2013 23:21:44 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] ath9k: Assign macVersion for QCA9531
Date: Mon, 30 Dec 2013 09:46:34 +0530
Message-Id: <1388376996-614-3-git-send-email-sujith@msujith.org> (sfid-20131230_052150_667881_15CD3969)
In-Reply-To: <1388376996-614-1-git-send-email-sujith@msujith.org>
References: <1388376996-614-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 5 +++++
 drivers/net/wireless/ath/ath9k/hw.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 579b669..2525cb1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -245,6 +245,9 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 	case AR9300_DEVID_QCA955X:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9550;
 		return;
+	case AR9300_DEVID_AR953X:
+		ah->hw_version.macVersion = AR_SREV_VERSION_9531;
+		return;
 	}
 
 	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
@@ -518,6 +521,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	case AR_SREV_VERSION_9462:
 	case AR_SREV_VERSION_9550:
 	case AR_SREV_VERSION_9565:
+	case AR_SREV_VERSION_9531:
 		break;
 	default:
 		ath_err(common,
@@ -617,6 +621,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR9300_DEVID_AR9462:
 	case AR9485_DEVID_AR1111:
 	case AR9300_DEVID_AR9565:
+	case AR9300_DEVID_AR953X:
 		break;
 	default:
 		if (common->bus_ops->ath_bus_type == ATH_USB)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5e10ad9..e766399 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -52,6 +52,7 @@
 #define AR9300_DEVID_QCA955X	0x0038
 #define AR9485_DEVID_AR1111	0x0037
 #define AR9300_DEVID_AR9565     0x0036
+#define AR9300_DEVID_AR953X     0x003d
 
 #define AR5416_AR9100_DEVID	0x000b
 
-- 
1.8.5.2

