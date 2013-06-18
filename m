Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43603 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab3FRWEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 18:04:02 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/6] mac80211:  Fix bss ref leak.
Date: Tue, 18 Jun 2013 15:03:33 -0700
Message-Id: <1371593017-10985-2-git-send-email-greearb@candelatech.com> (sfid-20130619_000406_468738_5052F99A)
In-Reply-To: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Some of the calls to ieee80211_destroy_assoc_data should
be putting the bss reference and were not.  Add boolean
argument to tell that method whether or not it should put
the reference and fix calling code appropriately.

Grab the bss reference where the pointer is assigned
to make it easier to properly do reference counting.

Also add some comments to help clarify the bss ref-counting
logic.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/mlme.c |   33 ++++++++++++++++++++++++---------
 net/mac80211/scan.c |    6 ++++++
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6510790..622cdd8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2400,7 +2400,7 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 }
 
 static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
-					 bool assoc)
+					 bool assoc, bool put_bss)
 {
 	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
 
@@ -2415,6 +2415,9 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 		ieee80211_vif_release_channel(sdata);
 	}
 
+	if (put_bss)
+		cfg80211_put_bss(sdata->local->hw.wiphy, assoc_data->bss);
+
 	kfree(assoc_data);
 	sdata->u.mgd.assoc_data = NULL;
 }
@@ -2587,6 +2590,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	return true;
 }
 
+/** Calling code must dispose of bss reference if it is not NULL. */
 static enum rx_mgmt_action __must_check
 ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_mgmt *mgmt, size_t len,
@@ -2643,17 +2647,20 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		return RX_MGMT_NONE;
 	}
 
+	/* bss will be passed back to calling code, and that code must
+	 * deal with properly putting the reference.
+	 */
 	*bss = assoc_data->bss;
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		sdata_info(sdata, "%pM denied association (code=%d)\n",
 			   mgmt->sa, status_code);
-		ieee80211_destroy_assoc_data(sdata, false);
+		ieee80211_destroy_assoc_data(sdata, false, false);
 	} else {
 		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
 			/* oops -- internal error -- send timeout for now */
-			ieee80211_destroy_assoc_data(sdata, false);
-			cfg80211_put_bss(sdata->local->hw.wiphy, *bss);
+			ieee80211_destroy_assoc_data(sdata, false, true);
+			*bss = NULL; /* Ensure no stale references */
 			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
 		}
 		sdata_info(sdata, "associated\n");
@@ -2663,7 +2670,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		 * recalc after assoc_data is NULL but before associated
 		 * is set can cause the interface to go idle
 		 */
-		ieee80211_destroy_assoc_data(sdata, true);
+		ieee80211_destroy_assoc_data(sdata, true, false);
 	}
 
 	return RX_MGMT_CFG80211_RX_ASSOC;
@@ -3105,6 +3112,9 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		break;
 	case IEEE80211_STYPE_ASSOC_RESP:
 	case IEEE80211_STYPE_REASSOC_RESP:
+		/* One way or another, must eventually put bss reference
+		 * if it is not NULL.
+		 */
 		rma = ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len, &bss);
 		break;
 	case IEEE80211_STYPE_ACTION:
@@ -3136,6 +3146,9 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		cfg80211_send_rx_assoc(sdata->dev, bss, (u8 *)mgmt, skb->len);
 		break;
 	case RX_MGMT_CFG80211_ASSOC_TIMEOUT:
+		/* bss reference is already put at this point, see
+		 * 'internal-error' comment in ieee80211_rx_mgmt_assoc_resp
+		 */
 		cfg80211_send_assoc_timeout(sdata->dev, mgmt->bssid);
 		break;
 	case RX_MGMT_CFG80211_TX_DEAUTH:
@@ -3385,7 +3398,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 			memcpy(bssid, ifmgd->assoc_data->bss->bssid, ETH_ALEN);
 
-			ieee80211_destroy_assoc_data(sdata, false);
+			ieee80211_destroy_assoc_data(sdata, false, true);
 
 			mutex_unlock(&ifmgd->mtx);
 			cfg80211_send_assoc_timeout(sdata->dev, bssid);
@@ -3935,6 +3948,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 		return -ENOMEM;
 
 	auth_data->bss = req->bss;
+	cfg80211_ref_bss(local->hw.wiphy, auth_data->bss);
 
 	if (req->sae_data_len >= 4) {
 		__le16 *pos = (__le16 *) req->sae_data;
@@ -3998,8 +4012,6 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 		goto err_clear;
 	}
 
-	/* hold our own reference */
-	cfg80211_ref_bss(local->hw.wiphy, auth_data->bss);
 	err = 0;
 	goto out_unlock;
 
@@ -4008,6 +4020,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 	ifmgd->auth_data = NULL;
  err_free:
+	cfg80211_put_bss(sdata->local->hw.wiphy, auth_data->bss);
 	kfree(auth_data);
  out_unlock:
 	mutex_unlock(&ifmgd->mtx);
@@ -4129,6 +4142,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	assoc_data->bss = req->bss;
+	cfg80211_ref_bss(sdata->local->hw.wiphy, assoc_data->bss);
 
 	if (ifmgd->req_smps == IEEE80211_SMPS_AUTOMATIC) {
 		if (ifmgd->powersave)
@@ -4259,6 +4273,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
  err_clear:
 	memset(ifmgd->bssid, 0, ETH_ALEN);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+	cfg80211_put_bss(sdata->local->hw.wiphy, assoc_data->bss);
 	ifmgd->assoc_data = NULL;
  err_free:
 	kfree(assoc_data);
@@ -4364,7 +4379,7 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&ifmgd->mtx);
 	if (ifmgd->assoc_data)
-		ieee80211_destroy_assoc_data(sdata, false);
+		ieee80211_destroy_assoc_data(sdata, false, true);
 	if (ifmgd->auth_data)
 		ieee80211_destroy_auth_data(sdata, false);
 	del_timer_sync(&ifmgd->timer);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 0b6434b..e0fcb4a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -55,6 +55,9 @@ static bool is_uapsd_supported(struct ieee802_11_elems *elems)
 	return qos_info & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD;
 }
 
+/** Must (eventually) put the returned value to keep from leaking
+ * a reference to the bss.
+ */
 struct ieee80211_bss *
 ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
@@ -73,6 +76,9 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
 		signal = (rx_status->signal * 100) / local->hw.max_signal;
 
+	/* We now own a reference to cbss, have to make sure we
+	 * put it later.
+	 */
 	cbss = cfg80211_inform_bss_frame(local->hw.wiphy, channel,
 					 mgmt, len, signal, GFP_ATOMIC);
 	if (!cbss)
-- 
1.7.3.4

