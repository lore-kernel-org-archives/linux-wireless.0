Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:48177 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754424AbaGEInM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 04:43:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Sat,  5 Jul 2014 11:43:01 +0300
Message-Id: <1404549781-5893-1-git-send-email-luca@coelho.fi> (sfid-20140705_104317_802615_B2E13EA4)
Subject: [PATCH] mac80211: remove redundant IEEE80211_STA_CSA_RECEIVED flag
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The csa_active flag was added in sdata a while ago and made
IEEE80211_STA_CSA_RECEIVED redundant.  The new flag is also used to
mark when CSA is ongoing on other iftypes and took over the old one as
the preferred method for checking whether we're in the middle of a
channel switch.  Remove the old, redundant flag.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ieee80211_i.h | 1 -
 net/mac80211/mlme.c        | 8 +-------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9e025e1..97f6b57 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -345,7 +345,6 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_CONNECTION_POLL	= BIT(1),
 	IEEE80211_STA_CONTROL_PORT	= BIT(2),
 	IEEE80211_STA_DISABLE_HT	= BIT(4),
-	IEEE80211_STA_CSA_RECEIVED	= BIT(5),
 	IEEE80211_STA_MFP_ENABLED	= BIT(6),
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 931330b..93ea991 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1005,8 +1005,6 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		sdata->csa_block_tx = false;
 	}
 
-	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
-
 	ieee80211_sta_reset_beacon_monitor(sdata);
 	ieee80211_sta_reset_conn_monitor(sdata);
 
@@ -1064,7 +1062,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	/* disregard subsequent announcements if we are already processing */
-	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
+	if (sdata->vif.csa_active)
 		return;
 
 	current_band = cbss->channel->band;
@@ -1091,8 +1089,6 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
-
 	mutex_lock(&local->mtx);
 	mutex_lock(&local->chanctx_mtx);
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
@@ -2108,8 +2104,6 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
 			       true, frame_buf);
-	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
-
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
 	if (sdata->csa_block_tx) {
-- 
2.0.0

