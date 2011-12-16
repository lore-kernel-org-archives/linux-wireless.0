Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759786Ab1LPQhs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:48 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/24] iwlwifi: reset the tid_data when a station is removed
Date: Fri, 16 Dec 2011 07:37:20 -0800
Message-Id: <1324049849-831-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173810_080124_5A3C7BF8)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the station is removed, we need to reset the information that
was accounted for this station.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 63d948d..6bf3311 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -463,6 +463,7 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 		       const u8 *addr)
 {
 	unsigned long flags;
+	u8 tid;
 
 	if (!iwl_is_ready(priv->shrd)) {
 		IWL_DEBUG_INFO(priv,
@@ -501,6 +502,10 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 		priv->stations[sta_id].lq = NULL;
 	}
 
+	for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++)
+		memset(&priv->tid_data[sta_id][tid], 0,
+			sizeof(priv->tid_data[sta_id][tid]));
+
 	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
 
 	priv->num_stations--;
-- 
1.7.0.4

