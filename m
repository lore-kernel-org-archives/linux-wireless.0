Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53495 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbYDOEQR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 04/12] iwlwifi: default WEP HW encryption
Date: Mon, 14 Apr 2008 21:16:06 -0700
Message-Id: <1208232974-3828-5-git-send-email-reinette.chatre@intel.com> (sfid-20080415_051624_553411_DA64B2C4)
In-Reply-To: <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds HW encryption support in default WEP mode.
When no key mapping key/pairwise key is used. The key is broadcast key
is used as default/global/static key.
This code assumes that group cast key is added after pairwise key.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    3 +
 drivers/net/wireless/iwlwifi/iwl-sta.c      |  119 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.h      |   46 ++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   90 ++++++++++++---------
 5 files changed, 220 insertions(+), 40 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-sta.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-sta.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 2751e8a..741ea34 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -22,5 +22,5 @@ endif
 
 
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
-iwl4965-objs		= iwl4965-base.o iwl-4965.o iwl-4965-rs.o
+iwl4965-objs		= iwl4965-base.o iwl-4965.o iwl-4965-rs.o iwl-sta.o
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 65e5367..93df29e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1112,6 +1112,9 @@ struct iwl_priv {
 	spinlock_t sta_lock;
 	int num_stations;
 	struct iwl4965_station_entry stations[IWL_STATION_COUNT];
+	struct iwl_wep_key wep_keys[WEP_KEYS_MAX];
+	u8 default_wep_key;
+	u8 key_mapping_key;
 
 	/* Indication if ieee80211_ops->open has been called */
 	u8 is_open;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
new file mode 100644
index 0000000..a48e228
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -0,0 +1,119 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <net/mac80211.h>
+
+#include "iwl-eeprom.h"
+#include "iwl-4965.h"
+#include "iwl-core.h"
+#include "iwl-sta.h"
+#include "iwl-io.h"
+#include "iwl-helpers.h"
+
+int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
+{
+	int i, not_empty = 0;
+	u8 buff[sizeof(struct iwl_wep_cmd) +
+		sizeof(struct iwl_wep_key) * WEP_KEYS_MAX];
+	struct iwl_wep_cmd *wep_cmd = (struct iwl_wep_cmd *)buff;
+	size_t cmd_size  = sizeof(struct iwl_wep_cmd);
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_WEPKEY,
+		.data = wep_cmd,
+		.meta.flags = CMD_ASYNC,
+	};
+
+	memset(wep_cmd, 0, cmd_size +
+			(sizeof(struct iwl_wep_key) * WEP_KEYS_MAX));
+
+	for (i = 0; i < WEP_KEYS_MAX ; i++) {
+		wep_cmd->key[i].key_index = i;
+		if (priv->wep_keys[i].key_size) {
+			wep_cmd->key[i].key_offset = i;
+			not_empty = 1;
+		} else {
+			wep_cmd->key[i].key_offset = WEP_INVALID_OFFSET;
+		}
+
+		wep_cmd->key[i].key_size = priv->wep_keys[i].key_size;
+		memcpy(&wep_cmd->key[i].key[3], priv->wep_keys[i].key,
+				priv->wep_keys[i].key_size);
+	}
+
+	wep_cmd->global_key_type = WEP_KEY_WEP_TYPE;
+	wep_cmd->num_keys = WEP_KEYS_MAX;
+
+	cmd_size += sizeof(struct iwl_wep_key) * WEP_KEYS_MAX;
+
+	cmd.len = cmd_size;
+
+	if (not_empty || send_if_empty)
+		return iwl_send_cmd(priv, &cmd);
+	else
+		return 0;
+}
+
+int iwl_remove_default_wep_key(struct iwl_priv *priv,
+			       struct ieee80211_key_conf *key)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->default_wep_key--;
+	memset(&priv->wep_keys[key->keyidx], 0, sizeof(priv->wep_keys[0]));
+	ret = iwl_send_static_wepkey_cmd(priv, 1);
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return ret;
+}
+
+int iwl_set_default_wep_key(struct iwl_priv *priv,
+			    struct ieee80211_key_conf *keyconf)
+{
+	int ret;
+	unsigned long flags;
+
+	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
+	keyconf->hw_key_idx = keyconf->keyidx;
+	priv->stations[IWL_AP_ID].keyinfo.alg = ALG_WEP;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->default_wep_key++;
+
+	priv->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
+	memcpy(&priv->wep_keys[keyconf->keyidx].key, &keyconf->key,
+							keyconf->keylen);
+
+	ret = iwl_send_static_wepkey_cmd(priv, 0);
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return ret;
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
new file mode 100644
index 0000000..50e9f14
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -0,0 +1,46 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+#ifndef __iwl_sta_h__
+#define __iwl_sta_h__
+
+#include <net/mac80211.h>
+
+#include "iwl-eeprom.h"
+#include "iwl-core.h"
+#include "iwl-4965.h"
+#include "iwl-io.h"
+#include "iwl-helpers.h"
+
+int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty);
+int iwl_remove_default_wep_key(struct iwl_priv *priv,
+				struct ieee80211_key_conf *key);
+int iwl_set_default_wep_key(struct iwl_priv *priv,
+				struct ieee80211_key_conf *key);
+
+#endif /* __iwl_sta_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index ecc9cba..dfd2b75 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -50,6 +50,7 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-helpers.h"
+#include "iwl-sta.h"
 
 static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl4965_tx_queue *txq);
@@ -941,6 +942,9 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 			return -EIO;
 		}
 		priv->assoc_station_added = 1;
+		if (priv->default_wep_key &&
+		    iwl_send_static_wepkey_cmd(priv, 0))
+			IWL_ERROR("Could not send WEP static key.\n");
 	}
 
 	return 0;
@@ -1180,6 +1184,8 @@ static int iwl4965_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 {
 	unsigned long flags;
 
+	priv->key_mapping_key = 0;
+
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	memset(&priv->stations[sta_id].keyinfo, 0, sizeof(struct iwl4965_hw_key));
 	memset(&priv->stations[sta_id].sta.key, 0, sizeof(struct iwl4965_keyinfo));
@@ -1198,6 +1204,8 @@ static int iwl4965_set_dynamic_key(struct iwl_priv *priv,
 {
 	int ret;
 
+	priv->key_mapping_key = 1;
+
 	switch (key->alg) {
 	case ALG_CCMP:
 		ret = iwl4965_set_ccmp_dynamic_key_info(priv, key, sta_id);
@@ -1216,23 +1224,6 @@ static int iwl4965_set_dynamic_key(struct iwl_priv *priv,
 	return ret;
 }
 
-static int iwl4965_remove_static_key(struct iwl_priv *priv)
-{
-	int ret = -EOPNOTSUPP;
-
-	return ret;
-}
-
-static int iwl4965_set_static_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *key)
-{
-	if (key->alg == ALG_WEP)
-		return -EOPNOTSUPP;
-
-	IWL_ERROR("Static key invalid: alg %d\n", key->alg);
-	return -EINVAL;
-}
-
 static void iwl4965_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
@@ -2115,6 +2106,10 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      int sta_id)
 {
 	struct iwl4965_hw_key *keyinfo = &priv->stations[sta_id].keyinfo;
+	struct iwl_wep_key *wepkey;
+	int keyidx = 0;
+
+	BUG_ON(ctl->key_idx > 3);
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
@@ -2133,16 +2128,24 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 		break;
 
 	case ALG_WEP:
-		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_WEP |
-			(ctl->key_idx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT;
-
-		if (keyinfo->keylen == 13)
-			cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
+		wepkey = &priv->wep_keys[ctl->key_idx];
+		cmd->cmd.tx.sec_ctl = 0;
+		if (priv->default_wep_key) {
+			/* the WEP key was sent as static */
+			keyidx = ctl->key_idx;
+			memcpy(&cmd->cmd.tx.key[3], wepkey->key,
+							wepkey->key_size);
+			if (wepkey->key_size == WEP_KEY_LEN_128)
+				cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
+		} else {
+			IWL_ERROR("No support for WEP key mappings key\n");
+		}
 
-		memcpy(&cmd->cmd.tx.key[3], keyinfo->key, keyinfo->keylen);
+		cmd->cmd.tx.sec_ctl |= (TX_CMD_SEC_WEP |
+			(keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
 
 		IWL_DEBUG_TX("Configuring packet for WEP encryption "
-			     "with key %d\n", ctl->key_idx);
+			     "with key %d\n", keyidx);
 		break;
 
 	default:
@@ -6989,7 +6992,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	DECLARE_MAC_BUF(mac);
 	int ret = 0;
 	u8 sta_id = IWL_INVALID_STATION;
-	u8 static_key;
+	u8 is_default_wep_key = 0;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7002,33 +7005,42 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		/* only support pairwise keys */
 		return -EOPNOTSUPP;
 
-	/* FIXME: need to differenciate between static and dynamic key
-	 * in the level of mac80211 */
-	static_key = !iwl_is_associated(priv);
+	sta_id = iwl4965_hw_find_station(priv, addr);
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_DEBUG_MAC80211("leave - %s not in station map.\n",
+				   print_mac(mac, addr));
+		return -EINVAL;
 
-	if (!static_key) {
-		sta_id = iwl4965_hw_find_station(priv, addr);
-		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_MAC80211("leave - %s not in station map.\n",
-					   print_mac(mac, addr));
-			return -EINVAL;
-		}
 	}
 
+	mutex_lock(&priv->mutex);
 	iwl4965_scan_cancel_timeout(priv, 100);
+	mutex_unlock(&priv->mutex);
+
+	/* If we are getting WEP group key and we didn't receive any key mapping
+	 * so far, we are in legacy wep mode (group key only), otherwise we are
+	 * in 1X mode.
+	 * In legacy wep mode, we use another host command to the uCode */
+	if (key->alg == ALG_WEP && sta_id == priv->hw_setting.bcast_sta_id &&
+		priv->iw_mode != IEEE80211_IF_TYPE_AP) {
+		if (cmd == SET_KEY)
+			is_default_wep_key = !priv->key_mapping_key;
+		else
+			is_default_wep_key = priv->default_wep_key;
+	}
 
 	switch (cmd) {
 	case SET_KEY:
-		if (static_key)
-			ret = iwl4965_set_static_key(priv, key);
+		if (is_default_wep_key)
+			ret = iwl_set_default_wep_key(priv, key);
 		else
 			ret = iwl4965_set_dynamic_key(priv, key, sta_id);
 
 		IWL_DEBUG_MAC80211("enable hwcrypto key\n");
 		break;
 	case DISABLE_KEY:
-		if (static_key)
-			ret = iwl4965_remove_static_key(priv);
+		if (is_default_wep_key)
+			ret = iwl_remove_default_wep_key(priv, key);
 		else
 			ret = iwl4965_clear_sta_key_info(priv, sta_id);
 
-- 
1.5.3.4

