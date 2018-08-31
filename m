Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45342 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727702AbeHaMiE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:38:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:10 +0300
Message-Id: <20180831083130.15525-9-luca@coelho.fi> (sfid-20180831_103154_992783_667BB667)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 08/28] mac80211: Fix station bandwidth setting after channel switch
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

When performing a channel switch flow for a managed interface, the
flow did not update the bandwidth of the AP station and the rate
scale algorithm. In case of a channel width downgrade, this would
result with the rate scale algorithm using a bandwidth that does not
match the interface channel configuration.

Fix this by updating the AP station bandwidth and rate scaling algorithm
before the actual channel change in case of a bandwidth downgrade, or
after the actual channel change in case of a bandwidth upgrade.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 53 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7fb9957359a3..4b53bbd10a3a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1073,6 +1073,10 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	 */
 
 	if (sdata->reserved_chanctx) {
+		struct ieee80211_supported_band *sband = NULL;
+		struct sta_info *mgd_sta = NULL;
+		enum ieee80211_sta_rx_bandwidth bw = IEEE80211_STA_RX_BW_20;
+
 		/*
 		 * with multi-vif csa driver may call ieee80211_csa_finish()
 		 * many times while waiting for other interfaces to use their
@@ -1081,6 +1085,48 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		if (sdata->reserved_ready)
 			goto out;
 
+		if (sdata->vif.bss_conf.chandef.width !=
+		    sdata->csa_chandef.width) {
+			/*
+			 * For managed interface, we need to also update the AP
+			 * station bandwidth and align the rate scale algorithm
+			 * on the bandwidth change. Here we only consider the
+			 * bandwidth of the new channel definition (as channel
+			 * switch flow does not have the full HT/VHT/HE
+			 * information), assuming that if additional changes are
+			 * required they would be done as part of the processing
+			 * of the next beacon from the AP.
+			 */
+			switch (sdata->csa_chandef.width) {
+			case NL80211_CHAN_WIDTH_20_NOHT:
+			case NL80211_CHAN_WIDTH_20:
+			default:
+				bw = IEEE80211_STA_RX_BW_20;
+				break;
+			case NL80211_CHAN_WIDTH_40:
+				bw = IEEE80211_STA_RX_BW_40;
+				break;
+			case NL80211_CHAN_WIDTH_80:
+				bw = IEEE80211_STA_RX_BW_80;
+				break;
+			case NL80211_CHAN_WIDTH_80P80:
+			case NL80211_CHAN_WIDTH_160:
+				bw = IEEE80211_STA_RX_BW_160;
+				break;
+			}
+
+			mgd_sta = sta_info_get(sdata, ifmgd->bssid);
+			sband =
+				local->hw.wiphy->bands[sdata->csa_chandef.chan->band];
+		}
+
+		if (sdata->vif.bss_conf.chandef.width >
+		    sdata->csa_chandef.width) {
+			mgd_sta->sta.bandwidth = bw;
+			rate_control_rate_update(local, sband, mgd_sta,
+						 IEEE80211_RC_BW_CHANGED);
+		}
+
 		ret = ieee80211_vif_use_reserved_context(sdata);
 		if (ret) {
 			sdata_info(sdata,
@@ -1091,6 +1137,13 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 			goto out;
 		}
 
+		if (sdata->vif.bss_conf.chandef.width <
+		    sdata->csa_chandef.width) {
+			mgd_sta->sta.bandwidth = bw;
+			rate_control_rate_update(local, sband, mgd_sta,
+						 IEEE80211_RC_BW_CHANGED);
+		}
+
 		goto out;
 	}
 
-- 
2.18.0
