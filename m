Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbYLBUNN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:13 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <sameo@linux.intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/11] iwl3945: Select correct sta ID from find_station()
Date: Tue,  2 Dec 2008 12:13:59 -0800
Message-Id: <1228248847-10424-4-git-send-email-reinette.chatre@intel.com> (sfid-20081202_211319_834749_2C4F8D93)
In-Reply-To: <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

The find_station routine needs to look at the IWL_AP_ID entry if we're a STA.
Currently, it only looks for STA entries which causes HW crypto to fail.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index fb5d295..96824e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -809,13 +809,20 @@ int iwl3945_hw_txq_free_tfd(struct iwl3945_priv *priv, struct iwl3945_tx_queue *
 
 u8 iwl3945_hw_find_station(struct iwl3945_priv *priv, const u8 *addr)
 {
-	int i;
+	int i, start = IWL_AP_ID;
 	int ret = IWL_INVALID_STATION;
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) ||
+	    (priv->iw_mode == NL80211_IFTYPE_AP))
+		start = IWL_STA_ID;
+
+	if (is_broadcast_ether_addr(addr))
+		return priv->hw_setting.bcast_sta_id;
+
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	for (i = IWL_STA_ID; i < priv->hw_setting.max_stations; i++)
+	for (i = start; i < priv->hw_setting.max_stations; i++)
 		if ((priv->stations[i].used) &&
 		    (!compare_ether_addr
 		     (priv->stations[i].sta.sta.addr, addr))) {
-- 
1.5.4.3

