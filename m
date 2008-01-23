Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61300 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbYAWSPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 13:15:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: Fix uCode error on association
Date: Wed, 23 Jan 2008 10:15:21 -0800
Message-Id: <1201112121-22340-7-git-send-email-reinette.chatre@intel.com> (sfid-20080123_181532_272501_7C8CBC49)
In-Reply-To: <1201112121-22340-6-git-send-email-reinette.chatre@intel.com>
References: <1201112121-22340-1-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-2-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-3-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-4-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-5-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

The problem is that priv->assoc_id is set when assoc. resp frame is
received. But, when it is set, LQ cmd is still not sent to the uCode, it is
done from bg_post_assoc, which is called through a workqueue.

On the other hand, when a tx arrives at the moment when this flag is set,
but LQ is still not sent, the if condition in tx_skb will not hold and
the frame will not be dropped.  Thus, it will be sent through
which is still not in the sta table in the uCoded.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 ++++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 4b07db9..1da14f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -790,7 +790,6 @@ struct iwl3945_priv {
 	u16 active_rate_basic;
 
 	u8 call_post_assoc_from_beacon;
-	u8 assoc_station_added;
 	/* Rate scaling data */
 	s8 data_retry_limit;
 	u8 retry_rate;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ea24e7b..322ad04 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2806,7 +2806,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 #endif
 
 	/* drop all data frame if we are not associated */
-	if (!iwl3945_is_associated(priv) && !priv->assoc_id &&
+	if ((!iwl3945_is_associated(priv) || !priv->assoc_id) &&
 	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
 		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
 		goto drop_unlock;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2e82af1..8c58ab0 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2933,8 +2933,10 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 #endif
 
 	/* drop all data frame if we are not associated */
-	if (!iwl4965_is_associated(priv) && !priv->assoc_id &&
-	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
+	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
+	   (!iwl4965_is_associated(priv) ||
+	    !priv->assoc_id ||
+	    !priv->assoc_station_added)) {
 		IWL_DEBUG_DROP("Dropping - !iwl4965_is_associated\n");
 		goto drop_unlock;
 	}
-- 
1.5.3.4

