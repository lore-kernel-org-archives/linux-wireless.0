Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45981 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbYE0Ou6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 10:50:58 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/3] mac80211: fix ieee80211_get_buffered_bc
Date: Tue, 27 May 2008 17:50:51 +0300
Message-Id: <1211899852-22712-3-git-send-email-tomas.winkler@intel.com> (sfid-20080527_165103_945235_768D634C)
In-Reply-To: <1211899852-22712-2-git-send-email-tomas.winkler@intel.com>
References: <1211899852-22712-1-git-send-email-tomas.winkler@intel.com>
 <1211899852-22712-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix bss not initialized in ieee80211_get_buffered_bc
and unbalanced locking

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/tx.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1a3b50b..04df78e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1954,7 +1954,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 			  struct ieee80211_tx_control *control)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	struct sta_info *sta;
 	ieee80211_tx_handler *handler;
 	struct ieee80211_tx_data tx;
@@ -1966,7 +1966,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 
 	sdata = vif_to_sdata(vif);
 	bdev = sdata->dev;
-
+	bss = &sdata->u.ap;
 
 	if (!bss)
 		return NULL;
@@ -1974,19 +1974,16 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
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
 	memset(control, 0, sizeof(*control));
 	while (1) {
 		skb = skb_dequeue(&bss->ps_bc_buf);
 		if (!skb)
-			return NULL;
+			goto out;
 		local->total_ps_buffered--;
 
 		if (!skb_queue_empty(&bss->ps_bc_buf) && skb->len >= 2) {
@@ -2023,6 +2020,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 		skb = NULL;
 	}
 
+out:
 	rcu_read_unlock();
 
 	return skb;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

