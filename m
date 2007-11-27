Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26618 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879AbXK0TDS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:03:18 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] ubject: [PATCH 1/1] iwlwifi: fix iwl_mac_add_interface handler
Date: Tue, 27 Nov 2007 21:00:52 +0200
Message-Id: <11961900522760-git-send-email-tomas.winkler@intel.com> (sfid-20071127_190322_155914_CB1D95EC)
In-Reply-To: 20071126225416.467939000@sipsolutions.net
References: 20071126225416.467939000@sipsolutions.net
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch for 2.6.24
This patch fixes iwl_mac_add_interface.
1. Currently only one interface is supported, instead of silently retuning
0
 now it returns  -EOPNOTSUPP (By Johannes Berg)
2. It enables changing mac address from user space (By Ian Schram)

Signed-off-by: Tomas Winkler <tomas@localhost.localdomain>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org
Cc: Ian Schram <ischram@telenet.be>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 +++++++----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 +++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 465da4f..92d1215 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6936,13 +6936,10 @@ static int iwl_mac_add_interface(struct ieee80211_hw *hw,
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_MAC80211("enter: id %d, type %d\n", conf->if_id, conf->type);
-	if (conf->mac_addr)
-		IWL_DEBUG_MAC80211("enter: MAC %s\n",
-				   print_mac(mac, conf->mac_addr));
 
 	if (priv->interface_id) {
 		IWL_DEBUG_MAC80211("leave - interface_id != 0\n");
-		return 0;
+		return -EOPNOTSUPP;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -6951,6 +6948,12 @@ static int iwl_mac_add_interface(struct ieee80211_hw *hw,
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	mutex_lock(&priv->mutex);
+
+	if (conf->mac_addr) {
+		IWL_DEBUG_MAC80211("Set: %s\n", print_mac(mac, conf->mac_addr));
+		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
+	}
+
 	iwl_set_mode(priv, conf->type);
 
 	IWL_DEBUG_MAC80211("leave\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9918780..e8631a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7326,9 +7326,6 @@ static int iwl_mac_add_interface(struct ieee80211_hw *hw,
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_MAC80211("enter: id %d, type %d\n", conf->if_id, conf->type);
-	if (conf->mac_addr)
-		IWL_DEBUG_MAC80211("enter: MAC %s\n",
-				   print_mac(mac, conf->mac_addr));
 
 	if (priv->interface_id) {
 		IWL_DEBUG_MAC80211("leave - interface_id != 0\n");
@@ -7341,6 +7338,11 @@ static int iwl_mac_add_interface(struct ieee80211_hw *hw,
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	mutex_lock(&priv->mutex);
+
+	if (conf->mac_addr) {
+		IWL_DEBUG_MAC80211("Set %s\n", print_mac(mac, conf->mac_addr));
+		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
+	}
 	iwl_set_mode(priv, conf->type);
 
 	IWL_DEBUG_MAC80211("leave\n");
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
