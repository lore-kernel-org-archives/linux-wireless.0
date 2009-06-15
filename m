Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:37626 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753197AbZFOT57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 15:57:59 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 05/11 v2][w-t] iwmc3200wifi: invalidate keys when changing the BSSID
Date: Mon, 15 Jun 2009 21:59:50 +0200
Message-Id: <4fa0241c41670096a2933b81c7bd32e6a5551faa.1245091931.git.samuel@sortiz.org>
In-Reply-To: <e72e3c0d6b16655fdf4da5dcabc6349be7b5c0a2.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
 <7413d2605b449b8e43bcfe61719ee30fccb592b7.1245091931.git.samuel@sortiz.org>
 <e72e3c0d6b16655fdf4da5dcabc6349be7b5c0a2.1245091931.git.samuel@sortiz.org>
In-Reply-To: <cover.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

While associated, we have to invalidate our key cache if we clear our BSSID
through siwap.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/wext.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/wext.c b/drivers/net/wireless/iwmc3200wifi/wext.c
index 584c94d..8891949 100644
--- a/drivers/net/wireless/iwmc3200wifi/wext.c
+++ b/drivers/net/wireless/iwmc3200wifi/wext.c
@@ -82,6 +82,7 @@ static int iwm_wext_siwap(struct net_device *dev, struct iw_request_info *info,
 			  struct sockaddr *ap_addr, char *extra)
 {
 	struct iwm_priv *iwm = ndev_to_iwm(dev);
+	int ret;
 
 	if (iwm->conf.mode == UMAC_MODE_IBSS)
 		return cfg80211_ibss_wext_siwap(dev, info, ap_addr, extra);
@@ -104,10 +105,26 @@ static int iwm_wext_siwap(struct net_device *dev, struct iw_request_info *info,
 	}
 
 	if (iwm->umac_profile_active) {
+		int i;
+
 		if (!memcmp(&iwm->umac_profile->bssid[0], iwm->bssid, ETH_ALEN))
 			return 0;
 
-		iwm_invalidate_mlme_profile(iwm);
+		/*
+		 * If we're clearing the BSSID, and we're associated,
+		 * we have to clear the keys as they're no longer valid.
+		 */
+		if (is_zero_ether_addr(ap_addr->sa_data)) {
+			for (i = 0; i < IWM_NUM_KEYS; i++)
+				iwm->keys[i].in_use = 0;
+
+		}
+
+		ret = iwm_invalidate_mlme_profile(iwm);
+		if (ret < 0) {
+			IWM_ERR(iwm, "Couldn't invalidate profile\n");
+			return ret;
+		}
 	}
 
 	if (iwm->umac_profile->ssid.ssid_len)
-- 
1.6.3.1

