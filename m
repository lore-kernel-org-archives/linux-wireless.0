Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62204 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJJLoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 07:44:06 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi2so1783205wib.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2014 04:44:03 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: use bss_info as txpower source
Date: Fri, 10 Oct 2014 13:33:00 +0200
Message-Id: <1412940780-25360-1-git-send-email-michal.kazior@tieto.com> (sfid-20141010_134410_295583_41DF5D7E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This simply changes the source for txpower setup.
It does not make ath10k use different txpower
values for different vifs.

This will make it easier to implement chanctx in
ath10k in the future.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 94 ++++++++++++++++++++++++++--------
 2 files changed, 75 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1ac2f14..fc9f558 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -273,6 +273,7 @@ struct ath10k_vif {
 	u8 force_sgi;
 	bool use_cts_prot;
 	int num_legacy_stations;
+	int txpower;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 75e0aeb..8529b54 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2688,12 +2688,68 @@ static void ath10k_config_chan(struct ath10k *ar)
 	ath10k_monitor_recalc(ar);
 }
 
+static int ath10k_mac_txpower_setup(struct ath10k *ar, int txpower)
+{
+	int ret;
+	u32 param;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac txpower %d\n", txpower);
+
+	param = ar->wmi.pdev_param->txpower_limit2g;
+	ret = ath10k_wmi_pdev_set_param(ar, param, txpower * 2);
+	if (ret) {
+		ath10k_warn(ar, "failed to set 2g txpower %d: %d\n",
+			    txpower, ret);
+		return ret;
+	}
+
+	param = ar->wmi.pdev_param->txpower_limit5g;
+	ret = ath10k_wmi_pdev_set_param(ar, param, txpower * 2);
+	if (ret) {
+		ath10k_warn(ar, "failed to set 5g txpower %d: %d\n",
+			    txpower, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ath10k_mac_txpower_recalc(struct ath10k *ar)
+{
+	struct ath10k_vif *arvif;
+	int ret, txpower = -1;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		WARN_ON(arvif->txpower < 0);
+
+		if (txpower == -1)
+			txpower = arvif->txpower;
+		else
+			txpower = min(txpower, arvif->txpower);
+	}
+
+	if (WARN_ON(txpower == -1))
+		return -EINVAL;
+
+	ret = ath10k_mac_txpower_setup(ar, txpower);
+	if (ret) {
+		ath10k_warn(ar, "failed to setup tx power %d: %d\n",
+			    txpower, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath10k *ar = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 	int ret = 0;
-	u32 param;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -2717,25 +2773,6 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac config power %d\n",
-			   hw->conf.power_level);
-
-		param = ar->wmi.pdev_param->txpower_limit2g;
-		ret = ath10k_wmi_pdev_set_param(ar, param,
-						hw->conf.power_level * 2);
-		if (ret)
-			ath10k_warn(ar, "failed to set 2g txpower %d: %d\n",
-				    hw->conf.power_level, ret);
-
-		param = ar->wmi.pdev_param->txpower_limit5g;
-		ret = ath10k_wmi_pdev_set_param(ar, param,
-						hw->conf.power_level * 2);
-		if (ret)
-			ath10k_warn(ar, "failed to set 5g txpower %d: %d\n",
-				    hw->conf.power_level, ret);
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_PS)
 		ath10k_config_ps(ar);
 
@@ -2944,6 +2981,13 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		goto err_peer_delete;
 	}
 
+	arvif->txpower = vif->bss_conf.txpower;
+	ret = ath10k_mac_txpower_recalc(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to recalc tx power: %d\n", ret);
+		goto err_peer_delete;
+	}
+
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
 
@@ -3224,6 +3268,16 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (changed & BSS_CHANGED_TXPOWER) {
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev_id %i txpower %d\n",
+			   arvif->vdev_id, info->txpower);
+
+		arvif->txpower = info->txpower;
+		ret = ath10k_mac_txpower_recalc(ar);
+		if (ret)
+			ath10k_warn(ar, "failed to recalc tx power: %d\n", ret);
+	}
+
 exit:
 	mutex_unlock(&ar->conf_mutex);
 }
-- 
1.8.5.3

