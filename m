Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:56307 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3KXUHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:12 -0500
Received: by mail-we0-f175.google.com with SMTP id p61so3007604wes.20
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:10 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/29] iwlwifi: mvm: add LQ flags definitions
Date: Sun, 24 Nov 2013 22:06:33 +0200
Message-Id: <1385323606-3603-16-git-send-email-egrumbach@gmail.com> (sfid-20131124_210808_086374_FD1C6959)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Add more bit field definitions used in LQ flags.
Also rename the first bit to a shorter name.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h |   27 ++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/rs.c        |    4 ++--
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
index 538f1c7..532312c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
@@ -281,8 +281,31 @@ enum {
 /* # entries in rate scale table to support Tx retries */
 #define  LQ_MAX_RETRY_NUM 16
 
-/* Link quality command flags, only this one is available */
-#define  LQ_FLAG_SET_STA_TLC_RTS_MSK	BIT(0)
+/* Link quality command flags bit fields */
+
+/* Bit 0: (0) Don't use RTS (1) Use RTS */
+#define LQ_FLAG_USE_RTS_POS             0
+#define LQ_FLAG_USE_RTS_MSK	        (1 << LQ_FLAG_USE_RTS_POS)
+
+/* Bit 1-3: LQ command color. Used to match responses to LQ commands */
+#define LQ_FLAG_COLOR_POS               1
+#define LQ_FLAG_COLOR_MSK               (7 << LQ_FLAG_COLOR_POS)
+
+/* Bit 4-5: Tx RTS BW Signalling
+ * (0) No RTS BW signalling
+ * (1) Static BW signalling
+ * (2) Dynamic BW signalling
+ */
+#define LQ_FLAG_RTS_BW_SIG_POS          4
+#define LQ_FLAG_RTS_BW_SIG_NONE         (0 << LQ_FLAG_RTS_BW_SIG_POS)
+#define LQ_FLAG_RTS_BW_SIG_STATIC       (1 << LQ_FLAG_RTS_BW_SIG_POS)
+#define LQ_FLAG_RTS_BW_SIG_DYNAMIC      (2 << LQ_FLAG_RTS_BW_SIG_POS)
+
+/* Bit 6: (0) No dynamic BW selection (1) Allow dynamic BW selection
+ * Dyanmic BW selection allows Tx with narrower BW then requested in rates
+ */
+#define LQ_FLAG_DYNAMIC_BW_POS          6
+#define LQ_FLAG_DYNAMIC_BW_MSK          (1 << LQ_FLAG_DYNAMIC_BW_POS)
 
 /**
  * struct iwl_lq_cmd - link quality command
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index a85938c..482b91b8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2862,12 +2862,12 @@ int iwl_mvm_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 
 	if (enable) {
 		if (mvmsta->tx_protection == 0)
-			lq->flags |= LQ_FLAG_SET_STA_TLC_RTS_MSK;
+			lq->flags |= LQ_FLAG_USE_RTS_MSK;
 		mvmsta->tx_protection++;
 	} else {
 		mvmsta->tx_protection--;
 		if (mvmsta->tx_protection == 0)
-			lq->flags &= ~LQ_FLAG_SET_STA_TLC_RTS_MSK;
+			lq->flags &= ~LQ_FLAG_USE_RTS_MSK;
 	}
 
 	return iwl_mvm_send_lq_cmd(mvm, lq, false);
-- 
1.7.9.5

