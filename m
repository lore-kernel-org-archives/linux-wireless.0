Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51659 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab1ELJz0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 05:55:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: wey-yi.w.guy@intel.com
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com,
	Reinette Chatre <reinette.chatre@intel.com>,
	Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] iwlwifi: fix TX power configuration on 3945 and 4965 devices
Date: Thu, 12 May 2011 11:55:24 +0200
Message-Id: <1305194124-46828-1-git-send-email-jslaby@suse.cz> (sfid-20110512_115530_052802_E1B73537)
References: bnc#619440 bnc#610421
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

When receiving a TX power change request from mac80211 the functions
servicing these requests for 3945 and 4965 uses information in the
active RXON. In iwl_mac_config the staging RXON is prepared based on
various directions from mac80211 and only at the end is the staging
RXON committed to the device and the active RXON updated.

By servicing the TX power change request while servicing the other
requests that modify the staging RXON we loose the new information
provided by mac80211.

Fix this by servicing the TX power change request after the RXON has
been committed to the device and active RXON thus contains accurate
information.

References: https://bugzilla.novell.com/show_bug.cgi?id=610421
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/iwlegacy/iwl-core.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -2220,13 +2220,6 @@ int iwl_legacy_mac_config(struct ieee802
 			IWL_DEBUG_MAC80211(priv, "Error setting sleep level\n");
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
-			priv->tx_power_user_lmt, conf->power_level);
-
-		iwl_legacy_set_tx_power(priv, conf->power_level, false);
-	}
-
 	if (!iwl_legacy_is_ready(priv)) {
 		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		goto out;
@@ -2245,6 +2238,14 @@ int iwl_legacy_mac_config(struct ieee802
 			iwl_legacy_update_qos(priv, ctx);
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
+			priv->tx_power_user_lmt, conf->power_level);
+
+		iwl_legacy_set_tx_power(priv, conf->power_level, false);
+	}
+
+
 out:
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	mutex_unlock(&priv->mutex);
