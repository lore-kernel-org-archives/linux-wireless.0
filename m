Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49134 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbZHUSoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 14:44:12 -0400
Received: by bwz19 with SMTP id 19so600699bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 11:44:12 -0700 (PDT)
Message-ID: <4A8EEAF9.6020308@gmail.com>
Date: Fri, 21 Aug 2009 20:44:09 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
CC: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] iwlwifi: Make injection of non-broadcast frames work again
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 1ccb84d87d04df3c76cd4352fe69786d8c7cf016 by Wey-Yi Guy
("iwlwifi: clean up unused NL80211_IFTYPE_MONITOR for Monitor mode")
broke injection of non-broadcast frames to unassociated stations
(causing a SYSASSERT for all such injected frames), due to injected
frames no longer automatically getting a broadcast station ID assigned.
This patch restores the old behavior, fixing the aforementioned
regression.

Also, consistently check for IEEE80211_TX_CTL_INJECTED instead of
iwl_is_monitor_mode in the TX path, as TX_CTL_INJECTED specifically
means that a given packet is coming from a monitor interface, while
iwl_is_monitor_mode only shows whether a monitor interface exists
on the device.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
V2: Use a totally new approach to fixing this bug.
Also fix a few more cases where iwl_is_monitor_mode was incorrectly
used to check whether a given packet comes from a monitor interface.
(For that, IEEE80211_TX_CTL_INJECTED should be used.)

 drivers/net/wireless/iwlwifi/iwl-tx.c       |   10 ++++++----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 ++++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 9b76bd4..8eba9e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -718,10 +718,9 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		IWL_DEBUG_TX(priv, "Sending REASSOC frame\n");
 #endif
 
-	/* drop all data frame if we are not associated */
+	/* drop all non-injected data frame if we are not associated */
 	if (ieee80211_is_data(fc) &&
-	    (!iwl_is_monitor_mode(priv) ||
-	    !(info->flags & IEEE80211_TX_CTL_INJECTED)) && /* packet injection */
+	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
 	    (!iwl_is_associated(priv) ||
 	     ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id) ||
 	     !priv->assoc_station_added)) {
@@ -732,7 +731,10 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find (or create) index into station table for destination station */
-	sta_id = iwl_get_sta_id(priv, hdr);
+	if (info->flags & IEEE80211_TX_CTL_INJECTED)
+		sta_id = priv->hw_params.bcast_sta_id;
+	else
+		sta_id = iwl_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e617411..d0debdf 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -518,9 +518,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		IWL_DEBUG_TX(priv, "Sending REASSOC frame\n");
 #endif
 
-	/* drop all data frame if we are not associated */
+	/* drop all non-injected data frame if we are not associated */
 	if (ieee80211_is_data(fc) &&
-	    (!iwl_is_monitor_mode(priv)) && /* packet injection */
+	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
 	    (!iwl_is_associated(priv) ||
 	     ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id))) {
 		IWL_DEBUG_DROP(priv, "Dropping - !iwl_is_associated\n");
@@ -532,7 +532,10 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find (or create) index into station table for destination station */
-	sta_id = iwl_get_sta_id(priv, hdr);
+	if (info->flags & IEEE80211_TX_CTL_INJECTED)
+		sta_id = priv->hw_params.bcast_sta_id;
+	else
+		sta_id = iwl_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
-- 
1.6.2.4



