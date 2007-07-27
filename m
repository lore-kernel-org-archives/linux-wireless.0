Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50879 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762462AbXG0J3B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:01 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 03/17] iwlwifi: modify station fix
Date: Fri, 27 Jul 2007 17:26:27 +0800
Message-Id: <11855284072074-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284053896-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes bit mask for modify station parameters.
Using assignment (=) instead of adding (|). The later caused
bringing parameters from previous command to the current and
eventaully caused uCode error.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c |   10 +++++-----
 drivers/net/wireless/iwl-base.c |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 9991956..3f1a339 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -3759,7 +3759,7 @@ static void iwl4965_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
 	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
 	priv->stations[sta_id].sta.sta.modify_mask = 0;
-	priv->stations[sta_id].sta.mode |= STA_CONTROL_MODIFY_MSK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, lock_flags);
 	/* assuming we are in rx flow and the lock is already locked */
 	iwl_send_add_station(priv, &priv->stations[sta_id].sta,
@@ -4097,9 +4097,9 @@ static void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv, int sta_id,
 	unsigned long lock_flags;
 
 	spin_lock_irqsave(&priv->sta_lock, lock_flags);
-	priv->stations[sta_id].sta.sta.modify_mask |= STA_MODIFY_TID_DISABLE_TX;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_TID_DISABLE_TX;
 	priv->stations[sta_id].sta.tid_disable_tx &= cpu_to_le32(~(1 << tid));
-	priv->stations[sta_id].sta.mode |= STA_CONTROL_MODIFY_MSK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, lock_flags);
 	iwl_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
@@ -4556,7 +4556,7 @@ static void iwl4965_sta_modify_add_ba_tid(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_ADDBA_TID_MSK;
 	priv->stations[sta_id].sta.add_immediate_ba_tid = (u8)tid;
 	priv->stations[sta_id].sta.add_immediate_ba_ssn = cpu_to_le16(ssn);
-	priv->stations[sta_id].sta.mode |= STA_CONTROL_MODIFY_MSK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, lock_flags);
 	iwl_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
@@ -4570,7 +4570,7 @@ static void iwl4965_sta_modify_del_ba_tid(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.station_flags_msk = 0;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_DELBA_TID_MSK;
 	priv->stations[sta_id].sta.remove_immediate_ba_tid = (u8)tid;
-	priv->stations[sta_id].sta.mode |= STA_CONTROL_MODIFY_MSK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, lock_flags);
 	iwl_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 7f8f2ac..1437f66 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -1405,8 +1405,8 @@ static int iwl_update_sta_key_info(struct iwl_priv *priv,
 	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
 	       keyconf->keylen);
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
-	priv->stations[sta_id].sta.sta.modify_mask |= STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode |= STA_CONTROL_MODIFY_MSK;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-- 
1.5.2
