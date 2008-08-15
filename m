Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18828 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbYHOCFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 22:05:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 15/15] iwl3945: avoid redundant iwl3945_get_active_dwell_time
Date: Fri, 15 Aug 2008 10:01:20 +0800
Message-Id: <1218765680-8378-16-git-send-email-yi.zhu@intel.com> (sfid-20080815_040509_925230_4BBBC5F6)
In-Reply-To: <1218765680-8378-15-git-send-email-yi.zhu@intel.com>
References: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-2-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-3-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-4-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-5-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-6-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-7-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-8-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-9-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-10-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-11-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-12-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-13-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-14-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-15-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

iwl3945_get_active_dwell_time is called twice within the same context.
The patch removes one instance.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e5ab646..28e141d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4815,7 +4815,6 @@ static inline u16 iwl3945_get_active_dwell_time(struct iwl3945_priv *priv,
 static u16 iwl3945_get_passive_dwell_time(struct iwl3945_priv *priv,
 					  enum ieee80211_band band)
 {
-	u16 active = iwl3945_get_active_dwell_time(priv, band);
 	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
@@ -4830,9 +4829,6 @@ static u16 iwl3945_get_passive_dwell_time(struct iwl3945_priv *priv,
 		passive = (passive * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
 	}
 
-	if (passive <= active)
-		passive = active + 1;
-
 	return passive;
 }
 
@@ -4857,6 +4853,9 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
 	active_dwell = iwl3945_get_active_dwell_time(priv, band);
 	passive_dwell = iwl3945_get_passive_dwell_time(priv, band);
 
+	if (passive_dwell <= active_dwell)
+		passive_dwell = active_dwell + 1;
+
 	for (i = 0, added = 0; i < sband->n_channels; i++) {
 		if (channels[i].flags & IEEE80211_CHAN_DISABLED)
 			continue;
-- 
1.5.3.6

