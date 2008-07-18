Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12191 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYGRF4g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 01:56:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 12/13] mac80211: remove unused variable agg_queue
Date: Fri, 18 Jul 2008 13:53:08 +0800
Message-Id: <1216360389-5352-13-git-send-email-yi.zhu@intel.com> (sfid-20080718_081543_416327_CDA6F72E)
In-Reply-To: <1216360389-5352-12-git-send-email-yi.zhu@intel.com>
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-3-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-4-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-5-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-6-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-7-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-8-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-9-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-10-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-11-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-12-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch removes unused variable agg_queue from ieee80211_stop_tx_ba_cb.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/main.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6fa2336..ff3a514 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -812,7 +812,6 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct sta_info *sta;
 	u8 *state;
-	int agg_queue;
 	DECLARE_MAC_BUF(mac);
 
 	if (tid >= STA_TID_NUM) {
@@ -855,8 +854,6 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 		ieee80211_send_delba(sta->sdata->dev, ra, tid,
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
 
-	agg_queue = sta->tid_to_tx_q[tid];
-
 	/* avoid ordering issues: we are the only one that can modify
 	 * the content of the qdiscs */
 	spin_lock_bh(&local->mdev->queue_lock);
-- 
1.5.3.6

