Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:37264 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754596AbZIANMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 09:12:36 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 4/9] iwmc3200wifi: use cfg80211_roamed to send roam event
Date: Tue,  1 Sep 2009 15:14:01 +0200
Message-Id: <8736a234164502177f2073aa9d2f042eed39f67b.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <3a950a601bd437ab1c971dc495fc0a2c3c886631.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
 <51aebb943245be1aef404d6274fe60feabd47c94.1251809163.git.sameo@linux.intel.com>
 <b08ebbaa73e4796a6be51889860bc1bd67867a90.1251809163.git.sameo@linux.intel.com>
 <3a950a601bd437ab1c971dc495fc0a2c3c886631.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <cover.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

The device sends connection terminated and [re]association success
(or failure) events when roaming occours. The patch uses
cfg80211_roamed instead of cfg80211_connect_result to notify SME
for roaming.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    2 +-
 drivers/net/wireless/iwmc3200wifi/commands.c |    1 +
 drivers/net/wireless/iwmc3200wifi/iwm.h      |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c       |   26 ++++++++++++++++++++------
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 2784b08..a56a2b0 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -673,7 +673,7 @@ static int iwm_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	IWM_DBG_WEXT(iwm, DBG, "Active: %d\n", iwm->umac_profile_active);
 
 	if (iwm->umac_profile_active)
-		return iwm_invalidate_mlme_profile(iwm);
+		iwm_invalidate_mlme_profile(iwm);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index a68a2af..23b52fa 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -756,6 +756,7 @@ int iwm_send_mlme_profile(struct iwm_priv *iwm)
 		return ret;
 	}
 
+	set_bit(IWM_STATUS_SME_CONNECTING, &iwm->status);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 7a51bc3..f054cc8 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -175,7 +175,7 @@ struct iwm_key {
 #define IWM_STATUS_READY		0
 #define IWM_STATUS_SCANNING		1
 #define IWM_STATUS_SCAN_ABORTING	2
-#define IWM_STATUS_ASSOCIATING		3
+#define IWM_STATUS_SME_CONNECTING	3
 #define IWM_STATUS_ASSOCIATED		4
 
 struct iwm_tx_queue {
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 86079a1..9e6f2cd 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -487,8 +487,6 @@ static int iwm_mlme_assoc_start(struct iwm_priv *iwm, u8 *buf,
 
 	start = (struct iwm_umac_notif_assoc_start *)buf;
 
-	set_bit(IWM_STATUS_ASSOCIATING, &iwm->status);
-
 	IWM_DBG_MLME(iwm, INFO, "Association with %pM Started, reason: %d\n",
 		     start->bssid, le32_to_cpu(start->roam_reason));
 
@@ -507,14 +505,23 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 	IWM_DBG_MLME(iwm, INFO, "Association with %pM completed, status: %d\n",
 		     complete->bssid, complete->status);
 
-	clear_bit(IWM_STATUS_ASSOCIATING, &iwm->status);
-
 	switch (le32_to_cpu(complete->status)) {
 	case UMAC_ASSOC_COMPLETE_SUCCESS:
 		set_bit(IWM_STATUS_ASSOCIATED, &iwm->status);
 		memcpy(iwm->bssid, complete->bssid, ETH_ALEN);
 		iwm->channel = complete->channel;
 
+		/* Internal roaming state, avoid notifying SME. */
+		if (!test_and_clear_bit(IWM_STATUS_SME_CONNECTING, &iwm->status)
+		    && iwm->conf.mode == UMAC_MODE_BSS) {
+			cfg80211_roamed(iwm_to_ndev(iwm),
+					complete->bssid,
+					iwm->req_ie, iwm->req_ie_len,
+					iwm->resp_ie, iwm->resp_ie_len,
+					GFP_KERNEL);
+			break;
+		}
+
 		iwm_link_on(iwm);
 
 		if (iwm->conf.mode == UMAC_MODE_IBSS)
@@ -531,6 +538,11 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 		memset(iwm->bssid, 0, ETH_ALEN);
 		iwm->channel = 0;
 
+		/* Internal roaming state, avoid notifying SME. */
+		if (!test_and_clear_bit(IWM_STATUS_SME_CONNECTING, &iwm->status)
+		    && iwm->conf.mode == UMAC_MODE_BSS)
+			break;
+
 		iwm_link_off(iwm);
 
 		if (iwm->conf.mode == UMAC_MODE_IBSS)
@@ -540,6 +552,7 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 					NULL, 0, NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE,
 					GFP_KERNEL);
+		break;
 	default:
 		break;
 	}
@@ -562,7 +575,7 @@ static int iwm_mlme_profile_invalidate(struct iwm_priv *iwm, u8 *buf,
 	IWM_DBG_MLME(iwm, INFO, "Profile Invalidated. Reason: %d\n",
 		     le32_to_cpu(invalid->reason));
 
-	clear_bit(IWM_STATUS_ASSOCIATING, &iwm->status);
+	clear_bit(IWM_STATUS_SME_CONNECTING, &iwm->status);
 	clear_bit(IWM_STATUS_ASSOCIATED, &iwm->status);
 
 	iwm->umac_profile_active = 0;
@@ -813,7 +826,8 @@ static int iwm_mlme_mgt_frame(struct iwm_priv *iwm, u8 *buf,
 		iwm->resp_ie = kmemdup(mgt->u.reassoc_resp.variable,
 				       iwm->resp_ie_len, GFP_KERNEL);
 	} else {
-		IWM_ERR(iwm, "Unsupported management frame");
+		IWM_ERR(iwm, "Unsupported management frame: 0x%x",
+			cpu_to_le16(mgt->frame_control));
 		return 0;
 	}
 
-- 
1.6.3.3

