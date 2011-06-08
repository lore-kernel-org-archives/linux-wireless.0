Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab1FHN0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 09:26:52 -0400
Date: Wed, 8 Jun 2011 15:26:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-2.6] iwlegacy: fix channel switch locking
Message-ID: <20110608132613.GA11289@redhat.com> (sfid-20110608_152655_949799_0516A120)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use priv->mutex to avoid race conditions between chswitch_done()
and mac_channel_switch(), when marking channel switch in
progress. But chswitch_done() can be called in atomic context
from rx_csa() or with mutex already taken from commit_rxon().

To fix remove mutex from chswitch_done() and use atomic bitops
for marking channel switch pending.

Cc: stable@kernel.org # 2.6.39+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965.c     |    9 ++-----
 drivers/net/wireless/iwlegacy/iwl-core.c     |   30 +++++++++++--------------
 drivers/net/wireless/iwlegacy/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h      |   13 +----------
 drivers/net/wireless/iwlegacy/iwl4965-base.c |   20 ++++++++--------
 5 files changed, 28 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 3a022bc..9cf96cb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1216,10 +1216,10 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *c
 	 * receive commit_rxon request
 	 * abort any previous channel switch if still in process
 	 */
-	if (priv->switch_rxon.switch_in_progress &&
-	    (priv->switch_rxon.channel != ctx->staging.channel)) {
+	if (test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status) &&
+	    (priv->switch_channel != ctx->staging.channel)) {
 		IWL_DEBUG_11H(priv, "abort channel switch on %d\n",
-		      le16_to_cpu(priv->switch_rxon.channel));
+		      le16_to_cpu(priv->switch_channel));
 		iwl_legacy_chswitch_done(priv, false);
 	}
 
@@ -1402,9 +1402,6 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv,
 		return rc;
 	}
 
-	priv->switch_rxon.channel = cmd.channel;
-	priv->switch_rxon.switch_in_progress = true;
-
 	return iwl_legacy_send_cmd_pdu(priv,
 			 REPLY_CHANNEL_SWITCH, sizeof(cmd), &cmd);
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 42df832..3be76bd 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -859,12 +859,8 @@ void iwl_legacy_chswitch_done(struct iwl_priv *priv, bool is_success)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (priv->switch_rxon.switch_in_progress) {
+	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
 		ieee80211_chswitch_done(ctx->vif, is_success);
-		mutex_lock(&priv->mutex);
-		priv->switch_rxon.switch_in_progress = false;
-		mutex_unlock(&priv->mutex);
-	}
 }
 EXPORT_SYMBOL(iwl_legacy_chswitch_done);
 
@@ -876,19 +872,19 @@ void iwl_legacy_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl_legacy_rxon_cmd *rxon = (void *)&ctx->active;
 
-	if (priv->switch_rxon.switch_in_progress) {
-		if (!le32_to_cpu(csa->status) &&
-		    (csa->channel == priv->switch_rxon.channel)) {
-			rxon->channel = csa->channel;
-			ctx->staging.channel = csa->channel;
-			IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
-			      le16_to_cpu(csa->channel));
-			iwl_legacy_chswitch_done(priv, true);
-		} else {
-			IWL_ERR(priv, "CSA notif (fail) : channel %d\n",
+	if (!test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+		return;
+
+	if (!le32_to_cpu(csa->status) && csa->channel == priv->switch_channel) {
+		rxon->channel = csa->channel;
+		ctx->staging.channel = csa->channel;
+		IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
 			      le16_to_cpu(csa->channel));
-			iwl_legacy_chswitch_done(priv, false);
-		}
+		iwl_legacy_chswitch_done(priv, true);
+	} else {
+		IWL_ERR(priv, "CSA notif (fail) : channel %d\n",
+			le16_to_cpu(csa->channel));
+		iwl_legacy_chswitch_done(priv, false);
 	}
 }
 EXPORT_SYMBOL(iwl_legacy_rx_csa);
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index bc66c60..c5fbda0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -560,7 +560,7 @@ void iwl_legacy_free_geos(struct iwl_priv *priv);
 #define STATUS_SCAN_HW		15
 #define STATUS_POWER_PMI	16
 #define STATUS_FW_ERROR		17
-
+#define STATUS_CHANNEL_SWITCH_PENDING 18
 
 static inline int iwl_legacy_is_ready(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index be0106c..ea30122 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -855,17 +855,6 @@ struct traffic_stats {
 };
 
 /*
- * iwl_switch_rxon: "channel switch" structure
- *
- * @ switch_in_progress: channel switch in progress
- * @ channel: new channel
- */
-struct iwl_switch_rxon {
-	bool switch_in_progress;
-	__le16 channel;
-};
-
-/*
  * schedule the timer to wake up every UCODE_TRACE_PERIOD milliseconds
  * to perform continuous uCode event logging operation if enabled
  */
@@ -1115,7 +1104,7 @@ struct iwl_priv {
 
 	struct iwl_rxon_context contexts[NUM_IWL_RXON_CTX];
 
-	struct iwl_switch_rxon switch_rxon;
+	__le16 switch_channel;
 
 	/* 1st responses from initialize and runtime uCode images.
 	 * _4965's initialize alive response contains some calibration data. */
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index af2ae22..7157ba5 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -2861,16 +2861,13 @@ void iwl4965_mac_channel_switch(struct ieee80211_hw *hw,
 		goto out;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
-	    test_bit(STATUS_SCANNING, &priv->status))
+	    test_bit(STATUS_SCANNING, &priv->status) ||
+	    test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
 		goto out;
 
 	if (!iwl_legacy_is_associated_ctx(ctx))
 		goto out;
 
-	/* channel switch in progress */
-	if (priv->switch_rxon.switch_in_progress == true)
-		goto out;
-
 	if (priv->cfg->ops->lib->set_channel_switch) {
 
 		ch = channel->hw_value;
@@ -2919,15 +2916,18 @@ void iwl4965_mac_channel_switch(struct ieee80211_hw *hw,
 			 * at this point, staging_rxon has the
 			 * configuration for channel switch
 			 */
-			if (priv->cfg->ops->lib->set_channel_switch(priv,
-								    ch_switch))
-				priv->switch_rxon.switch_in_progress = false;
+			set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
+			priv->switch_channel = cpu_to_le16(ch);
+			if (priv->cfg->ops->lib->set_channel_switch(priv, ch_switch)) {
+				clear_bit(STATUS_CHANNEL_SWITCH_PENDING,
+					  &priv->status);
+				priv->switch_channel = 0;
+				ieee80211_chswitch_done(ctx->vif, false);
+			}
 		}
 	}
 out:
 	mutex_unlock(&priv->mutex);
-	if (!priv->switch_rxon.switch_in_progress)
-		ieee80211_chswitch_done(ctx->vif, false);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-- 
1.7.1

