Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbZEOXHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 19:07:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwlwifi: drop struct iwl3945_hw_key
Date: Fri, 15 May 2009 16:13:43 -0700
Message-Id: <1242429226-8313-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1242429226-8313-1-git-send-email-reinette.chatre@intel.com>
References: <1242429226-8313-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch replaces struct iwl3945_hw_key by struct iwl_hw_key.
It's not used directly with any host command therefore removal is trivial

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    7 +------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 ++---
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 3049ba2..427489a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -503,18 +503,13 @@ struct iwl3945_tid_data {
 	u16 seq_number;
 };
 
-struct iwl3945_hw_key {
-	enum ieee80211_key_alg alg;
-	int keylen;
-	u8 key[32];
-};
 
 struct iwl3945_station_entry {
 	struct iwl3945_addsta_cmd sta;
 	struct iwl3945_tid_data tid[MAX_TID_COUNT];
 	u8 used;
 	u8 ps_status;
-	struct iwl3945_hw_key keyinfo;
+	struct iwl_hw_key keyinfo;
 };
 
 struct iwl_station_entry {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c32ec80..5d52f22 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -340,7 +340,7 @@ static int iwl3945_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	memset(&priv->stations_39[sta_id].keyinfo, 0, sizeof(struct iwl3945_hw_key));
+	memset(&priv->stations_39[sta_id].keyinfo, 0, sizeof(struct iwl_hw_key));
 	memset(&priv->stations_39[sta_id].sta.key, 0,
 		sizeof(struct iwl4965_keyinfo));
 	priv->stations_39[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
@@ -578,8 +578,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      int sta_id)
 {
 	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
-	struct iwl3945_hw_key *keyinfo =
-	    &priv->stations_39[sta_id].keyinfo;
+	struct iwl_hw_key *keyinfo = &priv->stations_39[sta_id].keyinfo;
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
-- 
1.5.6.3

