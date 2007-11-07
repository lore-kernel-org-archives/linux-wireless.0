Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48213 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbXKGGGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 01:06:43 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/5] remove unused iwl4965_init_hw_rates function
Date: Tue,  6 Nov 2007 22:06:27 -0800
Message-Id: <11944156022982-git-send-email-reinette.chatre@intel.com> (sfid-20071107_060645_362653_8606E83D)
In-Reply-To: <11944155923015-git-send-email-reinette.chatre@intel.com>
References: <11944155883607-git-send-email-reinette.chatre@intel.com>
 <1194415589137-git-send-email-reinette.chatre@intel.com>
 <11944155913421-git-send-email-reinette.chatre@intel.com>
 <11944155923015-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

The patch removes the unused function to fix a recursive bug caused
by namespace change.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    8 --------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 --
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f7c5ac3..9b8560d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4269,14 +4269,6 @@ static int iwl4965_tx_queue_agg_disable(struct iwl4965_priv *priv, u16 txq_id,
 
 #endif/* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
-/*
- * RATE SCALE CODE
- */
-int iwl4965_init_hw_rates(struct iwl4965_priv *priv, struct ieee80211_rate *rates)
-{
-	return 0;
-}
-
 
 /**
  * iwl4965_add_station - Initialize a station's hardware rate table
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7549224..64366c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5626,8 +5626,6 @@ static void iwl4965_init_hw_rates(struct iwl4965_priv *priv,
 		if (IWL_BASIC_RATES_MASK & (1 << i))
 			rates[i].flags |= IEEE80211_RATE_BASIC;
 	}
-
-	iwl4965_init_hw_rates(priv, rates);
 }
 
 /**
-- 
1.5.2.5
