Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12896 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbZIIKEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 06:04:20 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 03:04:23 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/4] ath9k: Enable btcoex based on the subsystem id of the device
Date: Wed, 9 Sep 2009 15:25:50 +0530
Message-ID: <1252490152-19284-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1252490152-19284-1-git-send-email-vasanth@atheros.com>
References: <1252490152-19284-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   23 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/btcoex.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c     |    3 ++-
 drivers/net/wireless/ath/ath9k/hw.h     |    4 ++++
 4 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index e8bfb01..55f607b 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -19,6 +19,29 @@
 static const struct ath_btcoex_config ath_bt_config = { 0, true, true,
 			ATH_BT_COEX_MODE_SLOTTED, true, true, 2, 5, true };
 
+static const u16 ath_subsysid_tbl[] = {
+	AR9280_COEX2WIRE_SUBSYSID,
+	AT9285_COEX3WIRE_SA_SUBSYSID,
+	AT9285_COEX3WIRE_DA_SUBSYSID
+};
+
+/*
+ * Checks the subsystem id of the device to see if it
+ * supports btcoex
+ */
+bool ath_btcoex_supported(u16 subsysid)
+{
+	int i;
+
+	if (!subsysid)
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(ath_subsysid_tbl); i++)
+		if (subsysid == ath_subsysid_tbl[i])
+			return true;
+
+	return false;
+}
 
 /*
  * Detects if there is any priority bt traffic
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 4556819..f1baf66 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -79,6 +79,7 @@ struct ath_btcoex_info {
 	struct ath_gen_timer *no_stomp_timer; /*Timer for no BT stomping*/
 };
 
+bool ath_btcoex_supported(u16 subsysid);
 int ath9k_hw_btcoex_init(struct ath_hw *ah);
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 97a09db..8d77817 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3690,7 +3690,8 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	pCap->num_antcfg_2ghz =
 		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
 
-	if (AR_SREV_9280_10_OR_LATER(ah) && btcoex_enable) {
+	if (AR_SREV_9280_10_OR_LATER(ah) &&
+	    ath_btcoex_supported(ah->hw_version.subsysid)) {
 		btcoex_info->btactive_gpio = ATH_BTACTIVE_GPIO;
 		btcoex_info->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 64ea547..9106a0b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -45,6 +45,10 @@
 #define AR5416_DEVID_AR9287_PCI  0x002D
 #define AR5416_DEVID_AR9287_PCIE 0x002E
 
+#define AR9280_COEX2WIRE_SUBSYSID	0x309b
+#define AT9285_COEX3WIRE_SA_SUBSYSID	0x30aa
+#define AT9285_COEX3WIRE_DA_SUBSYSID	0x30ab
+
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) ath9k_iowrite32((_ah), (_reg), (_val))
 #define REG_READ(_ah, _reg) ath9k_ioread32((_ah), (_reg))
-- 
1.5.5.1

