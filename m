Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:37417 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760167AbYEWCME (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:12:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: move iwl_rx_missed_beacon_notif to iwl-rx.c
Date: Fri, 23 May 2008 10:09:23 +0800
Message-Id: <1211508569-3163-46-git-send-email-yi.zhu@intel.com> (sfid-20080523_042836_549876_209C4F94)
In-Reply-To: <1211508569-3163-45-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-28-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-30-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-31-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-32-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-33-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-34-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-35-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-36-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-37-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-38-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-39-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-40-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-41-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-42-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-43-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-44-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-45-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves iwl_rx_missed_beacon_notif rx handler to iwl-rx.c.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   22 ----------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 +++
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   22 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 +++
 4 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index da08622..8c83384 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2902,26 +2902,7 @@ static void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
 	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
 	       sizeof(struct iwl4965_rx_phy_res));
 }
-static void iwl4965_rx_missed_beacon_notif(struct iwl_priv *priv,
-					   struct iwl_rx_mem_buffer *rxb)
 
-{
-#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_missed_beacon_notif *missed_beacon;
-
-	missed_beacon = &pkt->u.missed_beacon;
-	if (le32_to_cpu(missed_beacon->consequtive_missed_beacons) > 5) {
-		IWL_DEBUG_CALIB("missed bcn cnsq %d totl %d rcd %d expctd %d\n",
-		    le32_to_cpu(missed_beacon->consequtive_missed_beacons),
-		    le32_to_cpu(missed_beacon->total_missed_becons),
-		    le32_to_cpu(missed_beacon->num_recvd_beacons),
-		    le32_to_cpu(missed_beacon->num_expected_beacons));
-		if (!test_bit(STATUS_SCANNING, &priv->status))
-			iwl_init_sensitivity(priv);
-	}
-#endif /*CONFIG_IWL4965_RUN_TIME_CALIB*/
-}
 #ifdef CONFIG_IWL4965_HT
 
 /**
@@ -3512,9 +3493,6 @@ static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_RX_PHY_CMD] = iwl4965_rx_reply_rx_phy;
 	priv->rx_handlers[REPLY_RX_MPDU_CMD] = iwl4965_rx_reply_rx;
 
-	priv->rx_handlers[MISSED_BEACONS_NOTIFICATION] =
-	    iwl4965_rx_missed_beacon_notif;
-
 #ifdef CONFIG_IWL4965_HT
 	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwl4965_rx_reply_compressed_ba;
 #endif /* CONFIG_IWL4965_HT */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index aa22a59..eeea4e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -204,6 +204,9 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwl_rx_queue_restock(struct iwl_priv *priv);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
 void iwl_rx_allocate(struct iwl_priv *priv);
+/* Handlers */
+void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
+			       struct iwl_rx_mem_buffer *rxb);
 
 /*****************************************************
 * TX
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index ed63e5c..cc61c93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -33,6 +33,7 @@
 #include "iwl-core.h"
 #include "iwl-sta.h"
 #include "iwl-io.h"
+#include "iwl-calib.h"
 #include "iwl-helpers.h"
 /************************** RX-FUNCTIONS ****************************/
 /*
@@ -446,3 +447,24 @@ int iwl_rxq_stop(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_rxq_stop);
 
+void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb)
+
+{
+#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl4965_missed_beacon_notif *missed_beacon;
+
+	missed_beacon = &pkt->u.missed_beacon;
+	if (le32_to_cpu(missed_beacon->consequtive_missed_beacons) > 5) {
+		IWL_DEBUG_CALIB("missed bcn cnsq %d totl %d rcd %d expctd %d\n",
+		    le32_to_cpu(missed_beacon->consequtive_missed_beacons),
+		    le32_to_cpu(missed_beacon->total_missed_becons),
+		    le32_to_cpu(missed_beacon->num_recvd_beacons),
+		    le32_to_cpu(missed_beacon->num_expected_beacons));
+		if (!test_bit(STATUS_SCANNING, &priv->status))
+			iwl_init_sensitivity(priv);
+	}
+#endif /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
+}
+EXPORT_SYMBOL(iwl_rx_missed_beacon_notif);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7fe1bb9..1a94574 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2263,6 +2263,9 @@ static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl4965_rx_card_state_notif;
 	priv->rx_handlers[REPLY_TX] = iwl4965_rx_reply_tx;
 
+	priv->rx_handlers[MISSED_BEACONS_NOTIFICATION] =
+	    iwl_rx_missed_beacon_notif;
+
 	/* Set up hardware specific Rx handlers */
 	priv->cfg->ops->lib->rx_handler_setup(priv);
 }
-- 
1.5.3.6

