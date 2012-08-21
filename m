Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004Ab2HURCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 13:02:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Amit Beka <amit.beka@intel.com>
Subject: [PATCH 8/8] iwlwifi: fix FW restart on init FW
Date: Tue, 21 Aug 2012 19:01:56 +0200
Message-Id: <1345568516-20822-8-git-send-email-johannes@sipsolutions.net> (sfid-20120821_190221_554823_7966BB86)
In-Reply-To: <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
References: <1345568455.10280.11.camel@jlt3.sipsolutions.net>
 <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Beka <amit.beka@intel.com>

When unregistered with mac80211, we can't call its functionality
for FW restart, so avoid it and prevent automatic FW restart for
the init firmware.

Signed-off-by: Amit Beka <amit.beka@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index ab7b9ed..7ff3f14 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -862,7 +862,8 @@ void iwl_down(struct iwl_priv *priv)
 	 * No race since we hold the mutex here and a new one
 	 * can't come in at this time.
 	 */
-	ieee80211_remain_on_channel_expired(priv->hw);
+	if (priv->ucode_loaded && priv->cur_ucode != IWL_UCODE_INIT)
+		ieee80211_remain_on_channel_expired(priv->hw);
 
 	exit_pending =
 		test_and_set_bit(STATUS_EXIT_PENDING, &priv->status);
@@ -994,7 +995,11 @@ static void iwl_bg_restart(struct work_struct *data)
 		iwlagn_prepare_restart(priv);
 		mutex_unlock(&priv->mutex);
 		iwl_cancel_deferred_work(priv);
-		ieee80211_restart_hw(priv->hw);
+		if (priv->mac80211_registered)
+			ieee80211_restart_hw(priv->hw);
+		else
+			IWL_ERR(priv,
+				"Cannot request restart before registrating with mac80211");
 	} else {
 		WARN_ON(1);
 	}
-- 
1.7.10.4

