Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZJPFU2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:20:28 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 03/16] iwmc3200wifi: WPS support
Date: Fri, 16 Oct 2009 13:18:47 +0800
Message-Id: <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

By setting the WSC profile flag, we now support WPS as an enrollee.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    7 +++++++
 drivers/net/wireless/iwmc3200wifi/commands.h |    3 +++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 0d2e719..a6d2f20 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -628,6 +628,13 @@ static int iwm_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		iwm->default_key = sme->key_idx;
 	}
 
+	/* WPA and open AUTH type from wpa_s means WPS (a.k.a. WSC) */
+	if ((iwm->umac_profile->sec.flags &
+	     (UMAC_SEC_FLG_WPA_ON_MSK | UMAC_SEC_FLG_RSNA_ON_MSK)) &&
+	    iwm->umac_profile->sec.auth_type == UMAC_AUTH_TYPE_OPEN) {
+			iwm->umac_profile->sec.flags = UMAC_SEC_FLG_WSC_ON_MSK;
+	}
+
 	ret = iwm_send_mlme_profile(iwm);
 
 	if (iwm->umac_profile->sec.auth_type != UMAC_AUTH_TYPE_LEGACY_PSK ||
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.h b/drivers/net/wireless/iwmc3200wifi/commands.h
index e24d5b6..4e183be 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.h
+++ b/drivers/net/wireless/iwmc3200wifi/commands.h
@@ -288,6 +288,9 @@ struct iwm_umac_cmd_scan_request {
 /* iwm_umac_security.flag is WSC mode on -- bits [2:2] */
 #define UMAC_SEC_FLG_WSC_ON_POS		2
 #define UMAC_SEC_FLG_WSC_ON_SEED	1
+#define UMAC_SEC_FLG_WSC_ON_MSK         (UMAC_SEC_FLG_WSC_ON_SEED << \
+					 UMAC_SEC_FLG_WSC_ON_POS)
+
 
 /* Legacy profile can use only WEP40 and WEP104 for encryption and
  * OPEN or PSK for authentication */
-- 
1.6.0.4

