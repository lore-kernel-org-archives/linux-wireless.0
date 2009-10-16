Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZJPFUM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:20:12 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/16] iwmc3200wifi: allow joining an existed IBSS network
Date: Fri, 16 Oct 2009 13:18:46 +0800
Message-Id: <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We used to only support creating a new IBSS network. Now joining to
an existed IBSS network is supported as well.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   22 ++--------------------
 1 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index f3c5565..0d2e719 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -405,39 +405,21 @@ static int iwm_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
 	struct ieee80211_channel *chan = params->channel;
-	struct cfg80211_bss *bss;
 
 	if (!test_bit(IWM_STATUS_READY, &iwm->status))
 		return -EIO;
 
-	/* UMAC doesn't support creating IBSS network with specified bssid.
-	 * This should be removed after we have join only mode supported. */
+	/* UMAC doesn't support creating or joining an IBSS network
+	 * with specified bssid. */
 	if (params->bssid)
 		return -EOPNOTSUPP;
 
-	bss = cfg80211_get_ibss(iwm_to_wiphy(iwm), NULL,
-				params->ssid, params->ssid_len);
-	if (!bss) {
-		iwm_scan_one_ssid(iwm, params->ssid, params->ssid_len);
-		schedule_timeout_interruptible(2 * HZ);
-		bss = cfg80211_get_ibss(iwm_to_wiphy(iwm), NULL,
-					params->ssid, params->ssid_len);
-	}
-	/* IBSS join only mode is not supported by UMAC ATM */
-	if (bss) {
-		cfg80211_put_bss(bss);
-		return -EOPNOTSUPP;
-	}
-
 	iwm->channel = ieee80211_frequency_to_channel(chan->center_freq);
 	iwm->umac_profile->ibss.band = chan->band;
 	iwm->umac_profile->ibss.channel = iwm->channel;
 	iwm->umac_profile->ssid.ssid_len = params->ssid_len;
 	memcpy(iwm->umac_profile->ssid.ssid, params->ssid, params->ssid_len);
 
-	if (params->bssid)
-		memcpy(&iwm->umac_profile->bssid[0], params->bssid, ETH_ALEN);
-
 	return iwm_send_mlme_profile(iwm);
 }
 
-- 
1.6.0.4

