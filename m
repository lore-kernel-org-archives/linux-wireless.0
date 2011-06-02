Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab1FBOpG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 10:45:06 -0400
Date: Thu, 2 Jun 2011 16:44:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] iwlagn: fix channel switch locking
Message-ID: <20110602144424.GA4580@redhat.com> (sfid-20110602_164511_431676_CF50367C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use priv->mutex to avoid race condtions between iwl_chswitch_done()
and iwlagn_mac_channel_switch(), when marking channel switch in
progress. But iwl_chswitch_dane() can be called in atomic context
from iwl_rx_csa() or with mutex already taken from iwlagn_commit_rxon().

These bugs were introduced by:

commit 79d07325502e73508f917475bc1617b60979dd94
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Thu May 6 08:54:11 2010 -0700

    iwlwifi: support channel switch offload in driver

To fix remove mutex from iwl_chswitch_done() and use atomic bitops for
marking channel switch pending.

Cc: stable@kernel.org # 2.6.36+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c     |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 --
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   19 ++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    6 +-----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   13 +------------
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   24 ++++++++++++------------
 9 files changed, 28 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index a37c41b..33f0ad9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -244,8 +244,6 @@ static int iwl2030_hw_channel_switch(struct iwl_priv *priv,
 			ctx->active.channel, ch);
 		return -EFAULT;
 	}
-	priv->switch_rxon.channel = cmd.channel;
-	priv->switch_rxon.switch_in_progress = true;
 
 	return iwl_send_cmd_sync(priv, &hcmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a8dbbd0..32028b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -331,8 +331,6 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 			ctx->active.channel, ch);
 		return -EFAULT;
 	}
-	priv->switch_rxon.channel = cmd.channel;
-	priv->switch_rxon.switch_in_progress = true;
 
 	return iwl_send_cmd_sync(priv, &hcmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 0e127a7..6e5ce44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -270,8 +270,6 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 			ctx->active.channel, ch);
 		return -EFAULT;
 	}
-	priv->switch_rxon.channel = cmd.channel;
-	priv->switch_rxon.switch_in_progress = true;
 
 	return iwl_send_cmd_sync(priv, &hcmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index afb2f20..c263638 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -370,10 +370,10 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * receive commit_rxon request
 	 * abort any previous channel switch if still in process
 	 */
-	if (priv->switch_rxon.switch_in_progress &&
-	    (priv->switch_rxon.channel != ctx->staging.channel)) {
+	if (test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status) &&
+	    (priv->switch_channel != ctx->staging.channel)) {
 		IWL_DEBUG_11H(priv, "abort channel switch on %d\n",
-		      le16_to_cpu(priv->switch_rxon.channel));
+			      le16_to_cpu(priv->switch_channel));
 		iwl_chswitch_done(priv, false);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 58fd367..1a143b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2843,16 +2843,13 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 		goto out;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
-	    test_bit(STATUS_SCANNING, &priv->status))
+	    test_bit(STATUS_SCANNING, &priv->status) ||
+	    test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
 		goto out;
 
 	if (!iwl_is_associated_ctx(ctx))
 		goto out;
 
-	/* channel switch in progress */
-	if (priv->switch_rxon.switch_in_progress == true)
-		goto out;
-
 	if (priv->cfg->ops->lib->set_channel_switch) {
 
 		ch = channel->hw_value;
@@ -2901,15 +2898,19 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 			 * at this point, staging_rxon has the
 			 * configuration for channel switch
 			 */
+			set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
+			priv->switch_channel = cpu_to_le16(ch);
 			if (priv->cfg->ops->lib->set_channel_switch(priv,
-								    ch_switch))
-				priv->switch_rxon.switch_in_progress = false;
+								    ch_switch)) {
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
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 52e9413..70e6fd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -843,12 +843,8 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
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
 
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a87b54f..36a5097 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -559,6 +559,7 @@ void iwlcore_free_geos(struct iwl_priv *priv);
 #define STATUS_POWER_PMI	16
 #define STATUS_FW_ERROR		17
 #define STATUS_DEVICE_ENABLED	18
+#define STATUS_CHANNEL_SWITCH_PENDING 19
 
 
 static inline int iwl_is_ready(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 22a6e3e..c8de236 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -982,17 +982,6 @@ struct traffic_stats {
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
@@ -1287,7 +1276,7 @@ struct iwl_priv {
 
 	struct iwl_rxon_context contexts[NUM_IWL_RXON_CTX];
 
-	struct iwl_switch_rxon switch_rxon;
+	__le16 switch_channel;
 
 	struct {
 		u32 error_event_table;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 0053e9e..b774517 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -250,19 +250,19 @@ static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl_rxon_cmd *rxon = (void *)&ctx->active;
 
-	if (priv->switch_rxon.switch_in_progress) {
-		if (!le32_to_cpu(csa->status) &&
-		    (csa->channel == priv->switch_rxon.channel)) {
-			rxon->channel = csa->channel;
-			ctx->staging.channel = csa->channel;
-			IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
-			      le16_to_cpu(csa->channel));
-			iwl_chswitch_done(priv, true);
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
-			iwl_chswitch_done(priv, false);
-		}
+		iwl_chswitch_done(priv, true);
+	} else {
+		IWL_ERR(priv, "CSA notif (fail) : channel %d\n",
+			le16_to_cpu(csa->channel));
+		iwl_chswitch_done(priv, false);
 	}
 }
 
-- 
1.7.1

