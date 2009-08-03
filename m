Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55498 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZHCGf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 02:35:28 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/3] iwmc3200wifi: fix set_wpa_version and set_auth_type order
Date: Mon,  3 Aug 2009 14:37:01 +0800
Message-Id: <1249281423-26435-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1249281423-26435-1-git-send-email-yi.zhu@intel.com>
References: <1249281423-26435-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwm->umac_profile->sec.flags is set by iwm_set_wpa_version and
checked by iwm_set_auth_type. The patch changes the order to
make the flag used correctly.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 3f5a08f..a6e852f 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -484,6 +484,8 @@ static int iwm_set_auth_type(struct iwm_priv *iwm,
 
 static int iwm_set_wpa_version(struct iwm_priv *iwm, u32 wpa_version)
 {
+	IWM_DBG_WEXT(iwm, DBG, "wpa_version: %d\n", wpa_version);
+
 	if (!wpa_version) {
 		iwm->umac_profile->sec.flags = UMAC_SEC_FLG_LEGACY_PROFILE;
 		return 0;
@@ -508,6 +510,9 @@ static int iwm_set_cipher(struct iwm_priv *iwm, u32 cipher, bool ucast)
 		return 0;
 	}
 
+	IWM_DBG_WEXT(iwm, DBG, "%ccast cipher is 0x%x\n", ucast ? 'u' : 'm',
+		     cipher);
+
 	switch (cipher) {
 	case IW_AUTH_CIPHER_NONE:
 		*profile_cipher = UMAC_CIPHER_TYPE_NONE;
@@ -584,11 +589,11 @@ static int iwm_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		iwm->umac_profile->bss_num = 0;
 	}
 
-	ret = iwm_set_auth_type(iwm, sme->auth_type);
+	ret = iwm_set_wpa_version(iwm, sme->crypto.wpa_versions);
 	if (ret < 0)
 		return ret;
 
-	ret = iwm_set_wpa_version(iwm, sme->crypto.wpa_versions);
+	ret = iwm_set_auth_type(iwm, sme->auth_type);
 	if (ret < 0)
 		return ret;
 
-- 
1.6.0.4

