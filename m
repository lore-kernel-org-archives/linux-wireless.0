Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54638 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbZIANMl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 09:12:41 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 1/9] iwmc3200wifi: invalidate profile when necessary before connect
Date: Tue,  1 Sep 2009 15:13:58 +0200
Message-Id: <51aebb943245be1aef404d6274fe60feabd47c94.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <cover.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <cover.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

If cfg80211 requests to connect when we have already had an active
profile, invalidate the current profile first before sending a new
profile to UMAC.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index a6e852f..789ef5c 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -326,11 +326,8 @@ static int iwm_cfg80211_change_iface(struct wiphy *wiphy,
 
 	iwm->umac_profile->mode = cpu_to_le32(iwm->conf.mode);
 
-	if (iwm->umac_profile_active) {
-		int ret = iwm_invalidate_mlme_profile(iwm);
-		if (ret < 0)
-			IWM_ERR(iwm, "Couldn't invalidate profile\n");
-	}
+	if (iwm->umac_profile_active)
+		iwm_invalidate_mlme_profile(iwm);
 
 	return 0;
 }
@@ -573,6 +570,14 @@ static int iwm_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	if (!sme->ssid)
 		return -EINVAL;
 
+	if (iwm->umac_profile_active) {
+		ret = iwm_invalidate_mlme_profile(iwm);
+		if (ret) {
+			IWM_ERR(iwm, "Couldn't invalidate profile\n");
+			return ret;
+		}
+	}
+
 	if (chan)
 		iwm->channel =
 			ieee80211_frequency_to_channel(chan->center_freq);
-- 
1.6.3.3

