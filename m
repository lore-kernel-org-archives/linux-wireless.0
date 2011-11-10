Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56565 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab1KJBdd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:33 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/28] iwlagn: remove knowledge of ucode image location from upper layers
Date: Wed,  9 Nov 2011 16:39:12 -0800
Message-Id: <1320885571-19122-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023341_258912_61577C7A)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The upper layers of the driver do not need to know where the ucode is
stored.  It already passes in an enum of which ucode to load.  Let the
lower layer routines select the ucode to load.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   26 +++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    7 ++-----
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    1 -
 drivers/net/wireless/iwlwifi/iwl-sv-open.c   |    7 ++-----
 4 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 502659a..1ad4af4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -125,6 +125,22 @@ static int iwlagn_load_section(struct iwl_trans *trans, const char *name,
 	return 0;
 }
 
+static inline struct fw_img *iwl_get_ucode_image(struct iwl_priv *priv,
+					enum iwlagn_ucode_type ucode_type)
+{
+	switch (ucode_type) {
+	case IWL_UCODE_INIT:
+		return &priv->ucode_init;
+	case IWL_UCODE_WOWLAN:
+		return &priv->ucode_wowlan;
+	case IWL_UCODE_REGULAR:
+		return &priv->ucode_rt;
+	case IWL_UCODE_NONE:
+		break;
+	}
+	return NULL;
+}
+
 static int iwlagn_load_given_ucode(struct iwl_priv *priv,
 				   struct fw_img *image)
 {
@@ -520,13 +536,18 @@ static void iwlagn_alive_fn(struct iwl_priv *priv,
 #define UCODE_CALIB_TIMEOUT	(2*HZ)
 
 int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
-				 struct fw_img *image,
 				 enum iwlagn_ucode_type ucode_type)
 {
 	struct iwl_notification_wait alive_wait;
 	struct iwlagn_alive_data alive_data;
 	int ret;
 	enum iwlagn_ucode_type old_type;
+	struct fw_img *image = iwl_get_ucode_image(priv, ucode_type);
+
+	if (!image) {
+		IWL_ERR(priv, "Invalid ucode requested (%d)\n", ucode_type);
+		return -EINVAL;
+	}
 
 	ret = iwl_trans_start_device(trans(priv));
 	if (ret)
@@ -609,8 +630,7 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 				      NULL, NULL);
 
 	/* Will also start the device */
-	ret = iwlagn_load_ucode_wait_alive(priv, &priv->ucode_init,
-					   IWL_UCODE_INIT);
+	ret = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_INIT);
 	if (ret)
 		goto error;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b03eb99..d5d3309 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1452,9 +1452,7 @@ static int __iwl_up(struct iwl_priv *priv)
 		goto error;
 	}
 
-	ret = iwlagn_load_ucode_wait_alive(priv,
-					   &priv->ucode_rt,
-					   IWL_UCODE_REGULAR);
+	ret = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_REGULAR);
 	if (ret) {
 		IWL_ERR(priv, "Failed to start RT ucode: %d\n", ret);
 		goto error;
@@ -2102,8 +2100,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 
 	priv->shrd->wowlan = true;
 
-	ret = iwlagn_load_ucode_wait_alive(priv, &priv->ucode_wowlan,
-					   IWL_UCODE_WOWLAN);
+	ret = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_WOWLAN);
 	if (ret)
 		goto error;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5b936ec..adefab5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -95,7 +95,6 @@ int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwlagn_send_prio_tbl(struct iwl_priv *priv);
 int iwlagn_run_init_ucode(struct iwl_priv *priv);
 int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
-				 struct fw_img *image,
 				 enum iwlagn_ucode_type ucode_type);
 
 /* lib */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 5e50d88..e3882d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -396,8 +396,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_LOAD_INIT_FW:
-		status = iwlagn_load_ucode_wait_alive(priv, &priv->ucode_init,
-						      IWL_UCODE_INIT);
+		status = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_INIT);
 		if (status)
 			IWL_DEBUG_INFO(priv,
 				"Error loading init ucode: %d\n", status);
@@ -409,9 +408,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
-		status = iwlagn_load_ucode_wait_alive(priv,
-					   &priv->ucode_rt,
-					   IWL_UCODE_REGULAR);
+		status = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_REGULAR);
 		if (status) {
 			IWL_DEBUG_INFO(priv,
 				"Error loading runtime ucode: %d\n", status);
-- 
1.7.0.4

