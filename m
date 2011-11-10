Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab1KJBdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:35 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/28] iwlagn: convert remain-on-channel duration to TU
Date: Wed,  9 Nov 2011 16:39:24 -0800
Message-Id: <1320885571-19122-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023400_877467_A55CE5D7)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The device expects TU but we get ms, so convert.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 073e827..05b1f0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -957,7 +957,8 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 
 	priv->hw_roc_channel = channel;
 	priv->hw_roc_chantype = channel_type;
-	priv->hw_roc_duration = duration;
+	/* convert from ms to TU */
+	priv->hw_roc_duration = DIV_ROUND_UP(1000 * duration, 1024);
 	priv->hw_roc_start_notified = false;
 	cancel_delayed_work(&priv->hw_roc_disable_work);
 
-- 
1.7.0.4

