Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48966 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbZCREq6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/13] iwlwifi: report error when detect failure during stop agg queue
Date: Tue, 17 Mar 2009 21:51:52 -0700
Message-Id: <1237351913-19202-13-git-send-email-reinette.chatre@intel.com> (sfid-20090318_060339_749198_77B90A35)
In-Reply-To: <1237351913-19202-12-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-4-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-5-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-6-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-7-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-8-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-9-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-10-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-11-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-12-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This fix related to bug 1921 at
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1921

when detect error during stopping tx aggregation queue, report the error to
help identify the problem.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c  |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    4 +++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 08c19be..a3d9a95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1077,7 +1077,7 @@ static int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 
 	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES <= txq_id)) {
-		IWL_WARN(priv,
+		IWL_ERR(priv,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL50_FIRST_AMPDU_QUEUE,
 			IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES - 1);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 1684490..5798fe4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1138,8 +1138,10 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid)
 	int sta_id;
 
 	sta_id = iwl_find_station(priv, addr);
-	if (sta_id == IWL_INVALID_STATION)
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
 		return -ENXIO;
+	}
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->stations[sta_id].sta.station_flags_msk = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 9e83ee2..b13862a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1223,8 +1223,10 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 
 	sta_id = iwl_find_station(priv, ra);
 
-	if (sta_id == IWL_INVALID_STATION)
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
 		return -ENXIO;
+	}
 
 	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_ON)
 		IWL_WARN(priv, "Stopping AGG while state not IWL_AGG_ON\n");
-- 
1.5.6.3

