Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:34971 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaB0Ol1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:41:27 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [RFC v2 4/4] mac80211: add usage of CS channel reservation for STA
Date: Thu, 27 Feb 2014 16:41:21 +0200
Message-Id: <1393512081-31453-5-git-send-email-luca@coelho.fi> (sfid-20140227_154134_942277_0704F793)
In-Reply-To: <1393512081-31453-1-git-send-email-luca@coelho.fi>
References: <1393512081-31453-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

For simplicity, and as a proof of concept, only the STA case is
covered for now.  But the P2P GO and AP cases should also work with
this new concept.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
In RFC v2:

   * fixed some locking issues;
---
 net/mac80211/mlme.c | 70 ++++++++++++++++++++++-------------------------------
 1 file changed, 29 insertions(+), 41 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 46b62bb..44902bc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -927,18 +927,20 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
+	/* TODO: maybe this if block can be moved to use_reserved()? */
 	mutex_lock(&local->mtx);
-	ret = ieee80211_vif_change_channel(sdata, &changed);
-	mutex_unlock(&local->mtx);
-	if (ret) {
-		sdata_info(sdata,
-			   "vif channel switch failed, disconnecting\n");
-		ieee80211_queue_work(&sdata->local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		goto out;
-	}
 
 	if (!local->use_chanctx) {
+		ret = ieee80211_vif_change_channel(sdata, &changed);
+		if (ret) {
+			sdata_info(sdata,
+				   "vif channel switch failed, disconnecting\n");
+			ieee80211_queue_work(&sdata->local->hw,
+					     &ifmgd->csa_connection_drop_work);
+			mutex_unlock(&local->mtx);
+			goto out;
+		}
+
 		local->_oper_chandef = sdata->csa_chandef;
 		/* Call "hw_config" only if doing sw channel switch.
 		 * Otherwise update the channel directly
@@ -947,7 +949,18 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 			ieee80211_hw_config(local, 0);
 		else
 			local->hw.conf.chandef = local->_oper_chandef;
+	} else {
+		ret = ieee80211_vif_use_reserved_context(sdata, &changed);
+		if (ret) {
+			sdata_info(sdata,
+				   "using reserved context during channel switch failed, disconnecting\n");
+			ieee80211_queue_work(&sdata->local->hw,
+					     &ifmgd->csa_connection_drop_work);
+			mutex_unlock(&local->mtx);
+			goto out;
+		}
 	}
+	mutex_unlock(&local->mtx);
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
 	ifmgd->associated->channel = sdata->csa_chandef.chan;
@@ -998,7 +1011,6 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct cfg80211_bss *cbss = ifmgd->associated;
-	struct ieee80211_chanctx *chanctx;
 	enum ieee80211_band current_band;
 	struct ieee80211_csa_ie csa_ie;
 	int res;
@@ -1039,44 +1051,20 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
-
-	mutex_lock(&local->chanctx_mtx);
-	if (local->use_chanctx) {
-		u32 num_chanctx = 0;
-		list_for_each_entry(chanctx, &local->chanctx_list, list)
-		       num_chanctx++;
-
-		if (num_chanctx > 1 ||
-		    !(local->hw.flags & IEEE80211_HW_CHANCTX_STA_CSA)) {
-			sdata_info(sdata,
-				   "not handling chan-switch with channel contexts\n");
-			ieee80211_queue_work(&local->hw,
-					     &ifmgd->csa_connection_drop_work);
-			mutex_unlock(&local->chanctx_mtx);
-			return;
-		}
-	}
+	/* TODO: handle !local->chanctx) here */
 
-	if (WARN_ON(!rcu_access_pointer(sdata->vif.chanctx_conf))) {
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		mutex_unlock(&local->chanctx_mtx);
-		return;
-	}
-	chanctx = container_of(rcu_access_pointer(sdata->vif.chanctx_conf),
-			       struct ieee80211_chanctx, conf);
-	if (chanctx->refcount > 1) {
+	mutex_lock(&local->mtx);
+	res = ieee80211_vif_reserve_chanctx(sdata, &csa_ie.chandef);
+	mutex_unlock(&local->mtx);
+	if (res) {
 		sdata_info(sdata,
-			   "channel switch with multiple interfaces on the same channel, disconnecting\n");
+			   "reserving context for channel switch failed, disconnecting\n");
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
-		mutex_unlock(&local->chanctx_mtx);
 		return;
 	}
-	mutex_unlock(&local->chanctx_mtx);
 
-	sdata->csa_chandef = csa_ie.chandef;
+	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
 	sdata->vif.csa_active = true;
 
 	if (csa_ie.mode)
-- 
1.8.5.3

