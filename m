Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2HURCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 13:02:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/8] iwlwifi: reduce max remain-on-channel duration
Date: Tue, 21 Aug 2012 19:01:54 +0200
Message-Id: <1345568516-20822-6-git-send-email-johannes@sipsolutions.net> (sfid-20120821_190223_889573_D65EA208)
In-Reply-To: <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
References: <1345568455.10280.11.camel@jlt3.sipsolutions.net>
 <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to the way the PAN parameters are set up, the
maximum duration isn't 1000 but much lower, set it
to 500 which is safe (somewhere around 550 might
be possible.)

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index a5f7bce..908ff253 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -195,7 +195,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			ARRAY_SIZE(iwlagn_iface_combinations_dualmode);
 	}
 
-	hw->wiphy->max_remain_on_channel_duration = 1000;
+	hw->wiphy->max_remain_on_channel_duration = 500;
 
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
-- 
1.7.10.4

