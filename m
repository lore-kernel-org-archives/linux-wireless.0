Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44560 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbXJYJWx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:53 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 18/30] iwlwifi: move 3945 SCD registers to iwl-prph.h
Date: Thu, 25 Oct 2007 17:15:39 +0800
Message-Id: <11933037784073-git-send-email-yi.zhu@intel.com> (sfid-20071025_104106_075592_BB1A3B18)
In-Reply-To: <11933037762104-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
 <11933037692766-git-send-email-yi.zhu@intel.com>
 <1193303770550-git-send-email-yi.zhu@intel.com>
 <11933037721573-git-send-email-yi.zhu@intel.com>
 <1193303773185-git-send-email-yi.zhu@intel.com>
 <11933037743841-git-send-email-yi.zhu@intel.com>
 <11933037762104-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch moves 3945 SCD registers to iwl-prph.h. These registers
are assigned from the periphery bus

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-prph.h |   12 ++++++++++++
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 8b171de..e26d551 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -794,18 +794,18 @@ static int iwl3945_tx_reset(struct iwl_priv *priv)
 	}
 
 	/* bypass mode */
-	iwl_write_prph(priv, SCD_MODE_REG, 0x2);
+	iwl_write_prph(priv, ALM_SCD_MODE_REG, 0x2);
 
 	/* RA 0 is active */
-	iwl_write_prph(priv, SCD_ARASTAT_REG, 0x01);
+	iwl_write_prph(priv, ALM_SCD_ARASTAT_REG, 0x01);
 
 	/* all 6 fifo are active */
-	iwl_write_prph(priv, SCD_TXFACT_REG, 0x3f);
+	iwl_write_prph(priv, ALM_SCD_TXFACT_REG, 0x3f);
 
-	iwl_write_prph(priv, SCD_SBYP_MODE_1_REG, 0x010000);
-	iwl_write_prph(priv, SCD_SBYP_MODE_2_REG, 0x030002);
-	iwl_write_prph(priv, SCD_TXF4MF_REG, 0x000004);
-	iwl_write_prph(priv, SCD_TXF5MF_REG, 0x000005);
+	iwl_write_prph(priv, ALM_SCD_SBYP_MODE_1_REG, 0x010000);
+	iwl_write_prph(priv, ALM_SCD_SBYP_MODE_2_REG, 0x030002);
+	iwl_write_prph(priv, ALM_SCD_TXF4MF_REG, 0x000004);
+	iwl_write_prph(priv, ALM_SCD_TXF5MF_REG, 0x000005);
 
 	iwl_write_direct32(priv, FH_TSSR_CBB_BASE,
 			     priv->hw_setting.shared_phys);
@@ -1033,7 +1033,7 @@ void iwl_hw_txq_ctx_stop(struct iwl_priv *priv)
 	}
 
 	/* stop SCD */
-	iwl_write_prph(priv, SCD_MODE_REG, 0);
+	iwl_write_prph(priv, ALM_SCD_MODE_REG, 0);
 
 	/* reset TFD queues */
 	for (queue = TFD_QUEUE_MIN; queue < TFD_QUEUE_MAX; queue++) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 9639832..ee4af3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -225,6 +225,18 @@
 #define BSM_SRAM_LOWER_BOUND         (PRPH_BASE + 0x3800)
 #define BSM_SRAM_SIZE			(1024) /* bytes */
 
+/* ALM SCD */
+/* SCD (Scheduler) */
+#define ALM_SCD_BASE                        (PRPH_BASE + 0x2E00)
+#define ALM_SCD_MODE_REG                    (ALM_SCD_BASE + 0x000)
+#define ALM_SCD_ARASTAT_REG                 (ALM_SCD_BASE + 0x004)
+#define ALM_SCD_TXFACT_REG                  (ALM_SCD_BASE + 0x010)
+#define ALM_SCD_TXF4MF_REG                  (ALM_SCD_BASE + 0x014)
+#define ALM_SCD_TXF5MF_REG                  (ALM_SCD_BASE + 0x020)
+#define ALM_SCD_SBYP_MODE_1_REG             (ALM_SCD_BASE + 0x02C)
+#define ALM_SCD_SBYP_MODE_2_REG             (ALM_SCD_BASE + 0x030)
+
+
 /* 4965 SCD memory mapped registers */
 #define KDR_SCD_BASE		(PRPH_BASE + 0xa02c00)
 
-- 
1.5.2
