Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45448 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727410AbeHaMp2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:45:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:12 +0300
Message-Id: <20180831083130.15525-11-luca@coelho.fi> (sfid-20180831_103937_402313_8544B8FF)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 10/28] mac80211: don't Tx a deauth frame if the AP forbade Tx
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If the driver fails to properly prepare for the channel
switch, mac80211 will disconnect. If the CSA IE had mode
set to 1, it means that the clients are not allowed to send
any Tx on the current channel, and that includes the
deauthentication frame.

Make sure that we don't send the deauthentication frame in
this case.

In iwlwifi, this caused a failure to flush queues since the
firmware already closed the queues after having parsed the
CSA IE. Then mac80211 would wait until the deauthentication
frame would go out (drv_flush(drop=false)) and that would
never happen.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4b53bbd10a3a..3dbecae4be73 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1365,6 +1365,16 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 					 cbss->beacon_interval));
 	return;
  drop_connection:
+	/*
+	 * This is just so that the disconnect flow will know that
+	 * we were trying to switch channel and failed. In case the
+	 * mode is 1 (we are not allowed to Tx), we will know not to
+	 * send a deauthentication frame. Those two fields will be
+	 * reset when the disconnection worker runs.
+	 */
+	sdata->vif.csa_active = true;
+	sdata->csa_block_tx = csa_ie.mode;
+
 	ieee80211_queue_work(&local->hw, &ifmgd->csa_connection_drop_work);
 	mutex_unlock(&local->chanctx_mtx);
 	mutex_unlock(&local->mtx);
@@ -2575,6 +2585,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
+	bool tx;
 
 	sdata_lock(sdata);
 	if (!ifmgd->associated) {
@@ -2582,6 +2593,8 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 
+	tx = !sdata->csa_block_tx;
+
 	/* AP is probably out of range (or not reachable for another reason) so
 	 * remove the bss struct for that AP.
 	 */
@@ -2589,7 +2602,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
-			       true, frame_buf);
+			       tx, frame_buf);
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
 	ifmgd->csa_waiting_bcn = false;
@@ -2600,7 +2613,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 	}
 	mutex_unlock(&local->mtx);
 
-	ieee80211_report_disconnect(sdata, frame_buf, sizeof(frame_buf), true,
+	ieee80211_report_disconnect(sdata, frame_buf, sizeof(frame_buf), tx,
 				    WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
 
 	sdata_unlock(sdata);
-- 
2.18.0
