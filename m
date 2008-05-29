Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbYE2Ihw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:52 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 35/43] mac80211: fix ieee80211_get_buffered_bc
Date: Thu, 29 May 2008 16:35:20 +0800
Message-Id: <1212050128-17132-36-git-send-email-yi.zhu@intel.com> (sfid-20080529_103804_956438_274015B8)
In-Reply-To: <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-29-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-30-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-31-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-32-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

The patch fixes bss not initialized in ieee80211_get_buffered_bc
and unbalanced locking.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/tx.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index baa1be0..f974d02 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1908,7 +1908,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	struct sta_info *sta;
 	ieee80211_tx_handler *handler;
 	struct ieee80211_tx_data tx;
@@ -1921,7 +1921,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 
 	sdata = vif_to_sdata(vif);
 	bdev = sdata->dev;
-
+	bss = &sdata->u.ap;
 
 	if (!bss)
 		return NULL;
@@ -1929,19 +1929,16 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	rcu_read_lock();
 	beacon = rcu_dereference(bss->beacon);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_AP || !beacon ||
-	    !beacon->head) {
-		rcu_read_unlock();
-		return NULL;
-	}
+	if (sdata->vif.type != IEEE80211_IF_TYPE_AP || !beacon || !beacon->head)
+		goto out;
 
 	if (bss->dtim_count != 0)
-		return NULL; /* send buffered bc/mc only after DTIM beacon */
+		goto out; /* send buffered bc/mc only after DTIM beacon */
 
 	while (1) {
 		skb = skb_dequeue(&bss->ps_bc_buf);
 		if (!skb)
-			return NULL;
+			goto out;
 		local->total_ps_buffered--;
 
 		if (!skb_queue_empty(&bss->ps_bc_buf) && skb->len >= 2) {
@@ -1984,6 +1981,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 		skb = NULL;
 	}
 
+out:
 	rcu_read_unlock();
 
 	return skb;
-- 
1.5.3.6

