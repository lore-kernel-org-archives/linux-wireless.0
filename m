Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42896 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbZGPJdN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:33:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/10] iwmc3200wifi: remove setting WEP keys before setting essid support
Date: Thu, 16 Jul 2009 17:34:11 +0800
Message-Id: <1247736854-6760-7-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1247736854-6760-6-git-send-email-yi.zhu@intel.com>
References: <1247736854-6760-1-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-2-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-3-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-4-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-5-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recent cfg80211 "rework key operation" patch from Johannes Berg
makes sure keys are set only after the connection has been
established. So we can remove the setting WEP keys before essid
support from the driver.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index ee40317..0372658 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -203,32 +203,6 @@ static int iwm_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		return ret;
 	}
 
-	/*
-	 * The WEP keys can be set before or after setting the essid.
-	 * We need to handle both cases by simply pushing the keys after
-	 * we send the profile.
-	 * If the profile is not set yet (i.e. we're pushing keys before
-	 * the essid), we set the cipher appropriately.
-	 * If the profile is set, we havent associated yet because our
-	 * cipher was incorrectly set. So we invalidate and send the
-	 * profile again.
-	 */
-	if (key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
-	    key->cipher == WLAN_CIPHER_SUITE_WEP104) {
-		u8 *ucast_cipher = &iwm->umac_profile->sec.ucast_cipher;
-		u8 *mcast_cipher = &iwm->umac_profile->sec.mcast_cipher;
-
-		IWM_DBG_WEXT(iwm, DBG, "WEP key\n");
-
-		if (key->cipher == WLAN_CIPHER_SUITE_WEP40)
-			*ucast_cipher = *mcast_cipher = UMAC_CIPHER_TYPE_WEP_40;
-		if (key->cipher == WLAN_CIPHER_SUITE_WEP104)
-			*ucast_cipher = *mcast_cipher =
-				UMAC_CIPHER_TYPE_WEP_104;
-
-		return iwm_reset_profile(iwm);
-	}
-
 	return iwm_set_key(iwm, 0, key);
 }
 
-- 
1.6.0.4

