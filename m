Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18770 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbZGTDq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 23:46:29 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 4/5] iwmc3200wifi: fix cfg80211_connect_result is called in IBSS
Date: Mon, 20 Jul 2009 11:47:46 +0800
Message-Id: <1248061667-8614-5-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1248061667-8614-4-git-send-email-yi.zhu@intel.com>
References: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
 <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
 <1248061667-8614-3-git-send-email-yi.zhu@intel.com>
 <1248061667-8614-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid calling cfg80211_connect_result() in IBSS mode.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 6743391..86079a1 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -517,6 +517,9 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 
 		iwm_link_on(iwm);
 
+		if (iwm->conf.mode == UMAC_MODE_IBSS)
+			goto ibss;
+
 		cfg80211_connect_result(iwm_to_ndev(iwm),
 					complete->bssid,
 					iwm->req_ie, iwm->req_ie_len,
@@ -530,6 +533,9 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 
 		iwm_link_off(iwm);
 
+		if (iwm->conf.mode == UMAC_MODE_IBSS)
+			goto ibss;
+
 		cfg80211_connect_result(iwm_to_ndev(iwm), complete->bssid,
 					NULL, 0, NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE,
@@ -538,11 +544,10 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 		break;
 	}
 
-	if (iwm->conf.mode == UMAC_MODE_IBSS) {
-		cfg80211_ibss_joined(iwm_to_ndev(iwm), iwm->bssid, GFP_KERNEL);
-		return 0;
-	}
+	return 0;
 
+ ibss:
+	cfg80211_ibss_joined(iwm_to_ndev(iwm), iwm->bssid, GFP_KERNEL);
 	return 0;
 }
 
-- 
1.6.0.4

