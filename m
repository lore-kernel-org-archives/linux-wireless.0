Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822Ab1KJPtf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:49:35 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 01/27] iwlagn: add P2P NoA to probe responses
Date: Thu, 10 Nov 2011 06:55:01 -0800
Message-Id: <1320936927-9078-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_164941_822367_9181F520)
In-Reply-To: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Whether to use NoA or not is entire controlled
by the uCode right now, and it also adds the
attribute to beacons. We do need to add it to
probe responses in the driver though.

Keep track of the NoA notification from the
uCode and add the data to probe responses when
such are transmitted. Use RCU to manage the
lifetime.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c |   46 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   13 ++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    8 +++++
 4 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 5af9e62..f0d6d94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1032,6 +1032,50 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	return 0;
 }
 
+static int iwlagn_rx_noa_notification(struct iwl_priv *priv,
+				      struct iwl_rx_mem_buffer *rxb,
+				      struct iwl_device_cmd *cmd)
+{
+	struct iwl_wipan_noa_data *new_data, *old_data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_wipan_noa_notification *noa_notif = (void *)pkt->u.raw;
+
+	/* no condition -- we're in softirq */
+	old_data = rcu_dereference_protected(priv->noa_data, true);
+
+	if (noa_notif->noa_active) {
+		u32 len = le16_to_cpu(noa_notif->noa_attribute.length);
+		u32 copylen = len;
+
+		/* EID, len, OUI, subtype */
+		len += 1 + 1 + 3 + 1;
+		/* P2P id, P2P length */
+		len += 1 + 2;
+		copylen += 1 + 2;
+
+		new_data = kmalloc(sizeof(*new_data) + len, GFP_ATOMIC);
+		if (new_data) {
+			new_data->length = len;
+			new_data->data[0] = WLAN_EID_VENDOR_SPECIFIC;
+			new_data->data[1] = len - 2; /* not counting EID, len */
+			new_data->data[2] = (WLAN_OUI_WFA >> 16) & 0xff;
+			new_data->data[3] = (WLAN_OUI_WFA >> 8) & 0xff;
+			new_data->data[4] = (WLAN_OUI_WFA >> 0) & 0xff;
+			new_data->data[5] = WLAN_OUI_TYPE_WFA_P2P;
+			memcpy(&new_data->data[6], &noa_notif->noa_attribute,
+			       copylen);
+		}
+	} else
+		new_data = NULL;
+
+	rcu_assign_pointer(priv->noa_data, new_data);
+
+	if (old_data)
+		kfree_rcu(old_data, rcu_head);
+
+	return 0;
+}
+
 /**
  * iwl_setup_rx_handlers - Initialize Rx handler callbacks
  *
@@ -1055,6 +1099,8 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	handlers[BEACON_NOTIFICATION]		= iwlagn_rx_beacon_notif;
 	handlers[REPLY_ADD_STA]			= iwl_add_sta_callback;
 
+	handlers[REPLY_WIPAN_NOA_NOTIFICATION]	= iwlagn_rx_noa_notification;
+
 	/*
 	 * The same handler is used for both the REPLY to a discrete
 	 * statistics request from the host as well as for the periodic
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 35a6b71..014b98a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -283,6 +283,19 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		IWL_DEBUG_TX(priv, "Sending REASSOC frame\n");
 #endif
 
+	if (unlikely(ieee80211_is_probe_resp(fc))) {
+		struct iwl_wipan_noa_data *noa_data =
+			rcu_dereference(priv->noa_data);
+
+		if (noa_data &&
+		    pskb_expand_head(skb, 0, noa_data->length,
+				     GFP_ATOMIC) == 0) {
+			memcpy(skb_put(skb, noa_data->length),
+			       noa_data->data, noa_data->length);
+			hdr = (struct ieee80211_hdr *)skb->data;
+		}
+	}
+
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* For management frames use broadcast id to do not break aggregation */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9d463cf..3c0f4e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3069,6 +3069,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 		kmem_cache_destroy(priv->tx_cmd_pool);
 	kfree(priv->scan_cmd);
 	kfree(priv->beacon_cmd);
+	kfree(rcu_dereference_raw(priv->noa_data));
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	kfree(priv->wowlan_sram);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6c00a44..ef8620b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -824,6 +824,12 @@ struct iwl_testmode_trace {
 };
 #endif
 
+struct iwl_wipan_noa_data {
+	struct rcu_head rcu_head;
+	u32 length;
+	u8 data[];
+};
+
 struct iwl_priv {
 
 	/*data shared among all the driver's layers */
@@ -883,6 +889,8 @@ struct iwl_priv {
 	/* init calibration results */
 	struct iwl_calib_result calib_results[IWL_CALIB_MAX];
 
+	struct iwl_wipan_noa_data __rcu *noa_data;
+
 	/* Scan related variables */
 	unsigned long scan_start;
 	unsigned long scan_start_tsf;
-- 
1.7.0.4

