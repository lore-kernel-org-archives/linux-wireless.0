Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858Ab0EJW2b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:31 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 40/47] iwlwifi: add iwl_sta_id()
Date: Mon, 10 May 2010 15:28:11 -0700
Message-Id: <1273530498-11876-41-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In places where the station struct is
guaranteed to exist (presumably), use
this helper to get the station ID out
of it (and warn if there's no station
struct after all).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 8efb83d..7229e2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -84,4 +84,12 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv,
 int iwl_sta_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid);
 void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id);
 void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt);
+
+static inline int iwl_sta_id(struct ieee80211_sta *sta)
+{
+	if (WARN_ON(!sta))
+		return IWL_INVALID_STATION;
+
+	return ((struct iwl_station_priv_common *)sta->drv_priv)->sta_id;
+}
 #endif /* __iwl_sta_h__ */
-- 
1.6.3.3

