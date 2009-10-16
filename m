Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZJPFUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:20:38 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 05/16] iwmc3200wifi: Profile flags can be WPA1 or WPA2 not both
Date: Fri, 16 Oct 2009 13:18:49 +0800
Message-Id: <1255670340-22565-6-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

UMAC will ASSERT if the profile security flag is WPA1 | WPA2, so we can only
accept one of those.
Moreover wpa_s wext and nl80211 drivers dont try to send WPA1 | WPA2, but only
one at a time.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index a6d2f20..ea0ed32 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -472,12 +472,12 @@ static int iwm_set_wpa_version(struct iwm_priv *iwm, u32 wpa_version)
 		return 0;
 	}
 
+	if (wpa_version & NL80211_WPA_VERSION_1)
+		iwm->umac_profile->sec.flags = UMAC_SEC_FLG_WPA_ON_MSK;
+
 	if (wpa_version & NL80211_WPA_VERSION_2)
 		iwm->umac_profile->sec.flags = UMAC_SEC_FLG_RSNA_ON_MSK;
 
-	if (wpa_version & NL80211_WPA_VERSION_1)
-		iwm->umac_profile->sec.flags |= UMAC_SEC_FLG_WPA_ON_MSK;
-
 	return 0;
 }
 
-- 
1.6.0.4

