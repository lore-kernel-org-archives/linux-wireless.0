Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbZEZDSi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 23:18:38 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/3] iwmc3200wifi: fix fragmentation threshold setting
Date: Tue, 26 May 2009 11:10:46 +0800
Message-Id: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

We were sending the fragmentation threshold value to the wrong table,
causing an LMAC assert when setting it from wext.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 3256ad2..96f714e 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -268,7 +268,7 @@ static int iwm_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 
 		iwm->conf.frag_threshold = wiphy->frag_threshold;
 
-		ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+		ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_FA_CFG_FIX,
 					     CFG_FRAG_THRESHOLD,
 					     iwm->conf.frag_threshold);
 		if (ret < 0)
-- 
1.6.0.4

