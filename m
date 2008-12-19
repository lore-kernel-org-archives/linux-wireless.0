Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbYLSCpU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:20 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 22/43] iwl3945: replace iwl3945_broadcast_addr with iwl_bcast_addr
Date: Fri, 19 Dec 2008 10:37:22 +0800
Message-Id: <1229654263-21454-23-git-send-email-yi.zhu@intel.com> (sfid-20081219_034608_378728_A71B3A2B)
In-Reply-To: <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

The patch replaces iwl3945_broadcast_addr with iwl_bcast_addr for 3945.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   10 ++++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 4f8e6b8..e794cd5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -358,7 +358,6 @@ extern int iwl3945_send_statistics_request(struct iwl3945_priv *priv);
 extern void iwl3945_set_decrypted_flag(struct iwl3945_priv *priv, struct sk_buff *skb,
 				   u32 decrypt_res,
 				   struct ieee80211_rx_status *stats);
-extern const u8 iwl3945_broadcast_addr[ETH_ALEN];
 
 /*
  * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e37a28f..44777fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -303,8 +303,6 @@ void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *t
 	memset(txq, 0, sizeof(*txq));
 }
 
-const u8 iwl3945_broadcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
-
 /*************** STATION TABLE MANAGEMENT ****
  * mac80211 should be examined to determine if sta_info is duplicating
  * the functionality provided here
@@ -1034,7 +1032,7 @@ static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
 	}
 
 	/* Add the broadcast address so we can send broadcast frames */
-	if (iwl3945_add_station(priv, iwl3945_broadcast_addr, 0, 0) ==
+	if (iwl3945_add_station(priv, iwl_bcast_addr, 0, 0) ==
 	    IWL_INVALID_STATION) {
 		IWL_ERROR("Error adding BROADCAST address for transmit.\n");
 		return -EIO;
@@ -1531,9 +1529,9 @@ static u16 iwl3945_fill_probe_req(struct iwl3945_priv *priv,
 	len += 24;
 
 	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-	memcpy(frame->da, iwl3945_broadcast_addr, ETH_ALEN);
+	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
 	memcpy(frame->sa, priv->mac_addr, ETH_ALEN);
-	memcpy(frame->bssid, iwl3945_broadcast_addr, ETH_ALEN);
+	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
 	frame->seq_ctrl = 0;
 
 	/* fill in our indirect SSID IE */
@@ -6653,7 +6651,7 @@ static void iwl3945_config_ap(struct iwl3945_priv *priv)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
-		iwl3945_add_station(priv, iwl3945_broadcast_addr, 0, 0);
+		iwl3945_add_station(priv, iwl_bcast_addr, 0, 0);
 	}
 	iwl3945_send_beacon_cmd(priv);
 
-- 
1.5.3.6

