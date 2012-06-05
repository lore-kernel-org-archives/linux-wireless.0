Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab2FEHih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 03:38:37 -0400
Message-ID: <1338881915.4514.14.camel@jlt3.sipsolutions.net> (sfid-20120605_093840_264529_9142C1C5)
Subject: [PATCH 3.5] iwlwifi: unregister LEDs if mac80211 registration fails
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jun 2012 09:38:35 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Otherwise the LEDs stick around and cause issues the
next time around since they're still there but not
really hooked up.

Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 5d158ca..3ee23134 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -251,6 +251,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	ret = ieee80211_register_hw(priv->hw);
 	if (ret) {
 		IWL_ERR(priv, "Failed to register hw (error %d)\n", ret);
+		iwl_leds_exit(priv);
 		return ret;
 	}
 	priv->mac80211_registered = 1;
-- 
1.7.10



