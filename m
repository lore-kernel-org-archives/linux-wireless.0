Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33563 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdH3Jnt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 05:43:49 -0400
Received: by mail-pf0-f193.google.com with SMTP id r62so1256672pfj.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 02:43:49 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 6/8] rsi: disallow power save config when AP vap running
Date: Wed, 30 Aug 2017 15:08:26 +0530
Message-Id: <1504085908-2163-7-git-send-email-amitkarwar@gmail.com> (sfid-20170830_114412_931079_9594A740)
In-Reply-To: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
References: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

When AP or P2P GO VAP is running, power save configuration should
be disallowed. To check interface type in power save configuration
'vif' parameters is passed.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 33 ++++++++++++++++++++---------
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  5 +++--
 drivers/net/wireless/rsi/rsi_91x_ps.c       | 15 +++++++------
 drivers/net/wireless/rsi/rsi_mgmt.h         |  2 ++
 drivers/net/wireless/rsi/rsi_ps.h           |  7 +++---
 5 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index b1550bc..09ad909 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -592,7 +592,6 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
-	struct ieee80211_vif *vif = adapter->vifs[0];
 	struct ieee80211_conf *conf = &hw->conf;
 	int status = -EOPNOTSUPP;
 
@@ -608,16 +607,30 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 	}
 
 	/* Power save parameters */
-	if ((changed & IEEE80211_CONF_CHANGE_PS) &&
-	    (vif->type == NL80211_IFTYPE_STATION)) {
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		struct ieee80211_vif *vif;
 		unsigned long flags;
+		int i, set_ps = 1;
 
-		spin_lock_irqsave(&adapter->ps_lock, flags);
-		if (conf->flags & IEEE80211_CONF_PS)
-			rsi_enable_ps(adapter);
-		else
-			rsi_disable_ps(adapter);
-		spin_unlock_irqrestore(&adapter->ps_lock, flags);
+		for (i = 0; i < RSI_MAX_VIFS; i++) {
+			vif = adapter->vifs[i];
+			if (!vif)
+				continue;
+			/* Don't go to power save if AP vap exists */
+			if ((vif->type == NL80211_IFTYPE_AP) ||
+			    (vif->type == NL80211_IFTYPE_P2P_GO)) {
+				set_ps = 0;
+				break;
+			}
+		}
+		if (set_ps) {
+			spin_lock_irqsave(&adapter->ps_lock, flags);
+			if (conf->flags & IEEE80211_CONF_PS)
+				rsi_enable_ps(adapter, vif);
+			else
+				rsi_disable_ps(adapter, vif);
+			spin_unlock_irqrestore(&adapter->ps_lock, flags);
+		}
 	}
 
 	/* RTS threshold */
@@ -726,7 +739,7 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 	if (bss->assoc) {
 		if (common->uapsd_bitmap) {
 			rsi_dbg(INFO_ZONE, "Configuring UAPSD\n");
-			rsi_conf_uapsd(adapter);
+			rsi_conf_uapsd(adapter, vif);
 		}
 	} else {
 		common->uapsd_bitmap = 0;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 4e50cfd..383cd43 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1474,10 +1474,11 @@ int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word)
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
 
-int rsi_send_ps_request(struct rsi_hw *adapter, bool enable)
+int rsi_send_ps_request(struct rsi_hw *adapter, bool enable,
+			struct ieee80211_vif *vif)
 {
 	struct rsi_common *common = adapter->priv;
-	struct ieee80211_bss_conf *bss = &adapter->vifs[0]->bss_conf;
+	struct ieee80211_bss_conf *bss = &vif->bss_conf;
 	struct rsi_request_ps *ps;
 	struct rsi_ps_info *ps_info;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/rsi/rsi_91x_ps.c b/drivers/net/wireless/rsi/rsi_91x_ps.c
index 48c79f0..523f532 100644
--- a/drivers/net/wireless/rsi/rsi_91x_ps.c
+++ b/drivers/net/wireless/rsi/rsi_91x_ps.c
@@ -67,7 +67,7 @@ void rsi_default_ps_params(struct rsi_hw *adapter)
 	ps_info->deep_sleep_wakeup_period = RSI_DEF_DS_WAKEUP_PERIOD;
 }
 
-void rsi_enable_ps(struct rsi_hw *adapter)
+void rsi_enable_ps(struct rsi_hw *adapter, struct ieee80211_vif *vif)
 {
 	if (adapter->ps_state != PS_NONE) {
 		rsi_dbg(ERR_ZONE,
@@ -76,7 +76,7 @@ void rsi_enable_ps(struct rsi_hw *adapter)
 		return;
 	}
 
-	if (rsi_send_ps_request(adapter, true)) {
+	if (rsi_send_ps_request(adapter, true, vif)) {
 		rsi_dbg(ERR_ZONE,
 			"%s: Failed to send PS request to device\n",
 			__func__);
@@ -86,7 +86,8 @@ void rsi_enable_ps(struct rsi_hw *adapter)
 	rsi_modify_ps_state(adapter, PS_ENABLE_REQ_SENT);
 }
 
-void rsi_disable_ps(struct rsi_hw *adapter)
+/* This function is used to disable power save */
+void rsi_disable_ps(struct rsi_hw *adapter, struct ieee80211_vif *vif)
 {
 	if (adapter->ps_state != PS_ENABLED) {
 		rsi_dbg(ERR_ZONE,
@@ -95,7 +96,7 @@ void rsi_disable_ps(struct rsi_hw *adapter)
 		return;
 	}
 
-	if (rsi_send_ps_request(adapter, false)) {
+	if (rsi_send_ps_request(adapter, false, vif)) {
 		rsi_dbg(ERR_ZONE,
 			"%s: Failed to send PS request to device\n",
 			__func__);
@@ -105,16 +106,16 @@ void rsi_disable_ps(struct rsi_hw *adapter)
 	rsi_modify_ps_state(adapter, PS_DISABLE_REQ_SENT);
 }
 
-void rsi_conf_uapsd(struct rsi_hw *adapter)
+void rsi_conf_uapsd(struct rsi_hw *adapter, struct ieee80211_vif *vif)
 {
 	int ret;
 
 	if (adapter->ps_state != PS_ENABLED)
 		return;
 
-	ret = rsi_send_ps_request(adapter, false);
+	ret = rsi_send_ps_request(adapter, false, vif);
 	if (!ret)
-		ret = rsi_send_ps_request(adapter, true);
+		ret = rsi_send_ps_request(adapter, true, vif);
 	if (ret)
 		rsi_dbg(ERR_ZONE,
 			"%s: Failed to send PS request to device\n",
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 331d64b..b9d0802 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -641,4 +641,6 @@ int rsi_band_check(struct rsi_common *common, struct ieee80211_channel *chan);
 int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word);
 int rsi_send_radio_params_update(struct rsi_common *common);
 int rsi_set_antenna(struct rsi_common *common, u8 antenna);
+int rsi_send_ps_request(struct rsi_hw *adapter, bool enable,
+			struct ieee80211_vif *vif);
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_ps.h b/drivers/net/wireless/rsi/rsi_ps.h
index d847587..98ff6a4 100644
--- a/drivers/net/wireless/rsi/rsi_ps.h
+++ b/drivers/net/wireless/rsi/rsi_ps.h
@@ -55,10 +55,9 @@ struct rsi_ps_info {
 } __packed;
 
 char *str_psstate(enum ps_state state);
-void rsi_enable_ps(struct rsi_hw *adapter);
-void rsi_disable_ps(struct rsi_hw *adapter);
+void rsi_enable_ps(struct rsi_hw *adapter, struct ieee80211_vif *vif);
+void rsi_disable_ps(struct rsi_hw *adapter, struct ieee80211_vif *vif);
 int rsi_handle_ps_confirm(struct rsi_hw *adapter, u8 *msg);
 void rsi_default_ps_params(struct rsi_hw *hw);
-int rsi_send_ps_request(struct rsi_hw *adapter, bool enable);
-void rsi_conf_uapsd(struct rsi_hw *adapter);
+void rsi_conf_uapsd(struct rsi_hw *adapter, struct ieee80211_vif *vif);
 #endif
-- 
2.7.4
