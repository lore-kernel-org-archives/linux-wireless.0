Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:50239 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756758AbaEPN4A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 09:56:00 -0400
From: Luca Coelho <luca@coelho.fi>
To: ath10k@lists.infradead.org, ath9k-devel@venema.h4ckr.net
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com
Date: Fri, 16 May 2014 16:55:34 +0300
Message-Id: <1400248534-16763-1-git-send-email-luca@coelho.fi> (sfid-20140516_155610_702447_072326E9)
Subject: [PATCH] ath9k/ath10k: remove unnecessary channel_switch_beacon callbacks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The channel_switch_beacon callback is optional, so it doesn't have to
be defined if it's not going to do anything useful with it.  Both
ath9k and ath10k define the callback and just returns.  This commit
removes them.

Cc: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---

I'm plannnig to remove the channel_switch_beacon callback (actually,
replace it with a more generic one that can be used for STA and other
iftypes too) and ath9k/ath10k are the only (non) users of it. ;)

 drivers/net/wireless/ath/ath10k/mac.c | 9 ---------
 drivers/net/wireless/ath/ath9k/main.c | 9 ---------
 2 files changed, 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d1df993..a1c4e5e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4035,14 +4035,6 @@ static int ath10k_set_bitrate_mask(struct ieee80211_hw *hw,
 					   fixed_nss, force_sgi);
 }
 
-static void ath10k_channel_switch_beacon(struct ieee80211_hw *hw,
-					 struct ieee80211_vif *vif,
-					 struct cfg80211_chan_def *chandef)
-{
-	/* there's no need to do anything here. vif->csa_active is enough */
-	return;
-}
-
 static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
@@ -4158,7 +4150,6 @@ static const struct ieee80211_ops ath10k_ops = {
 	.restart_complete		= ath10k_restart_complete,
 	.get_survey			= ath10k_get_survey,
 	.set_bitrate_mask		= ath10k_set_bitrate_mask,
-	.channel_switch_beacon		= ath10k_channel_switch_beacon,
 	.sta_rc_update			= ath10k_sta_rc_update,
 	.get_tsf			= ath10k_get_tsf,
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 49265c6..8dc9c77 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2085,14 +2085,6 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	clear_bit(ATH_OP_SCANNING, &common->op_flags);
 }
 
-static void ath9k_channel_switch_beacon(struct ieee80211_hw *hw,
-					struct ieee80211_vif *vif,
-					struct cfg80211_chan_def *chandef)
-{
-	/* depend on vif->csa_active only */
-	return;
-}
-
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2140,5 +2132,4 @@ struct ieee80211_ops ath9k_ops = {
 #endif
 	.sw_scan_start	    = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
-	.channel_switch_beacon     = ath9k_channel_switch_beacon,
 };
-- 
2.0.0.rc0

