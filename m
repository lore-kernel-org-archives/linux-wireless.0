Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:38104 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760840AbZDHSVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/18] iwl3945: use iwl_get_sta_id from iwlwifi
Date: Wed,  8 Apr 2009 11:26:43 -0700
Message-Id: <1239215212-1657-10-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202130_049132_7E2ED13E)
In-Reply-To: <1239215212-1657-9-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-4-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-5-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-6-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-7-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-8-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

iwl3945 can now use iwl_get_sta_id.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   61 +--------------------------
 1 files changed, 1 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c1f3324..c3d6caf 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -712,65 +712,6 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 	tx->next_frame_len = 0;
 }
 
-/**
- * iwl3945_get_sta_id - Find station's index within station table
- */
-static int iwl3945_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
-{
-	int sta_id;
-	u16 fc = le16_to_cpu(hdr->frame_control);
-
-	/* If this frame is broadcast or management, use broadcast station id */
-	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
-	    is_multicast_ether_addr(hdr->addr1))
-		return priv->hw_params.bcast_sta_id;
-
-	switch (priv->iw_mode) {
-
-	/* If we are a client station in a BSS network, use the special
-	 * AP station entry (that's the only station we communicate with) */
-	case NL80211_IFTYPE_STATION:
-		return IWL_AP_ID;
-
-	/* If we are an AP, then find the station, or use BCAST */
-	case NL80211_IFTYPE_AP:
-		sta_id = priv->cfg->ops->smgmt->find_station(priv, hdr->addr1);
-		if (sta_id != IWL_INVALID_STATION)
-			return sta_id;
-		return priv->hw_params.bcast_sta_id;
-
-	/* If this frame is going out to an IBSS network, find the station,
-	 * or create a new station table entry */
-	case NL80211_IFTYPE_ADHOC: {
-		/* Create new station table entry */
-		sta_id = priv->cfg->ops->smgmt->find_station(priv, hdr->addr1);
-		if (sta_id != IWL_INVALID_STATION)
-			return sta_id;
-
-		sta_id = priv->cfg->ops->smgmt->add_station(priv,
-				hdr->addr1, 0, CMD_ASYNC, NULL);
-
-		if (sta_id != IWL_INVALID_STATION)
-			return sta_id;
-
-		IWL_DEBUG_DROP(priv, "Station %pM not in station map. "
-			       "Defaulting to broadcast...\n",
-			       hdr->addr1);
-		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
-		return priv->hw_params.bcast_sta_id;
-	}
-	/* If we are in monitor mode, use BCAST. This is required for
-	 * packet injection. */
-	case NL80211_IFTYPE_MONITOR:
-		return priv->hw_params.bcast_sta_id;
-
-	default:
-		IWL_WARN(priv, "Unknown mode of operation: %d\n",
-			priv->iw_mode);
-		return priv->hw_params.bcast_sta_id;
-	}
-}
-
 /*
  * start REPLY_TX command process
  */
@@ -836,7 +777,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find (or create) index into station table for destination station */
-	sta_id = iwl3945_get_sta_id(priv, hdr);
+	sta_id = iwl_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
-- 
1.5.6.3

