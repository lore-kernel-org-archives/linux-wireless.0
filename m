Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbYICDbK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 11/39] iwl3945: avoid redundant iwl3945_get_active_dwell_time
Date: Wed,  3 Sep 2008 11:26:31 +0800
Message-Id: <1220412419-15404-12-git-send-email-yi.zhu@intel.com> (sfid-20080903_053117_138605_B0854392)
In-Reply-To: <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
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
index 70dfe9d..709be78 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4814,7 +4814,6 @@ static inline u16 iwl3945_get_active_dwell_time(struct iwl3945_priv *priv,
 static u16 iwl3945_get_passive_dwell_time(struct iwl3945_priv *priv,
 					  enum ieee80211_band band)
 {
-	u16 active = iwl3945_get_active_dwell_time(priv, band);
 	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
@@ -4829,9 +4828,6 @@ static u16 iwl3945_get_passive_dwell_time(struct iwl3945_priv *priv,
 		passive = (passive * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
 	}
 
-	if (passive <= active)
-		passive = active + 1;
-
 	return passive;
 }
 
@@ -4856,6 +4852,9 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
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

