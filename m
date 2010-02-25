Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63121 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab0BYGMP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 01:12:15 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/7] iwmc3200wifi: refuse to associate on unallowed channels
Date: Thu, 25 Feb 2010 14:15:25 +0800
Message-Id: <1267078531-9817-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1267078531-9817-1-git-send-email-yi.zhu@intel.com>
References: <1267078531-9817-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to make sure we don't associate with APs on unallowed
channels (according to regulatory setting). This could happen
when the channel is not specified (auto-select) within the
connection request. In this case we get the AP's channel until
the firmware indicates the association succeeded later. We need
to verify the associated channel. If the channel is disabled by
regulatory, we have to disassociate with the AP.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |   12 +++++++++---
 drivers/net/wireless/iwmc3200wifi/commands.h |    1 +
 drivers/net/wireless/iwmc3200wifi/rx.c       |   15 +++++++++++++++
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 1e41ad0..9ef4fd0 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -781,10 +781,9 @@ int iwm_send_mlme_profile(struct iwm_priv *iwm)
 	return 0;
 }
 
-int iwm_invalidate_mlme_profile(struct iwm_priv *iwm)
+int __iwm_invalidate_mlme_profile(struct iwm_priv *iwm)
 {
 	struct iwm_umac_invalidate_profile invalid;
-	int ret;
 
 	invalid.hdr.oid = UMAC_WIFI_IF_CMD_INVALIDATE_PROFILE;
 	invalid.hdr.buf_size =
@@ -793,7 +792,14 @@ int iwm_invalidate_mlme_profile(struct iwm_priv *iwm)
 
 	invalid.reason = WLAN_REASON_UNSPECIFIED;
 
-	ret = iwm_send_wifi_if_cmd(iwm, &invalid, sizeof(invalid), 1);
+	return iwm_send_wifi_if_cmd(iwm, &invalid, sizeof(invalid), 1);
+}
+
+int iwm_invalidate_mlme_profile(struct iwm_priv *iwm)
+{
+	int ret;
+
+	ret = __iwm_invalidate_mlme_profile(iwm);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.h b/drivers/net/wireless/iwmc3200wifi/commands.h
index 3dfd9f0..7e16bcf 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.h
+++ b/drivers/net/wireless/iwmc3200wifi/commands.h
@@ -488,6 +488,7 @@ int iwm_umac_set_config_var(struct iwm_priv *iwm, u16 key,
 			    void *payload, u16 payload_size);
 int iwm_send_umac_config(struct iwm_priv *iwm, __le32 reset_flags);
 int iwm_send_mlme_profile(struct iwm_priv *iwm);
+int __iwm_invalidate_mlme_profile(struct iwm_priv *iwm);
 int iwm_invalidate_mlme_profile(struct iwm_priv *iwm);
 int iwm_send_packet(struct iwm_priv *iwm, struct sk_buff *skb, int pool_id);
 int iwm_set_tx_key(struct iwm_priv *iwm, u8 key_idx);
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index ad8f7ea..36b1580 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -518,6 +518,8 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 				   unsigned long buf_size,
 				   struct iwm_wifi_cmd *cmd)
 {
+	struct wiphy *wiphy = iwm_to_wiphy(iwm);
+	struct ieee80211_channel *chan;
 	struct iwm_umac_notif_assoc_complete *complete =
 		(struct iwm_umac_notif_assoc_complete *)buf;
 
@@ -526,6 +528,18 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 
 	switch (le32_to_cpu(complete->status)) {
 	case UMAC_ASSOC_COMPLETE_SUCCESS:
+		chan = ieee80211_get_channel(wiphy,
+			ieee80211_channel_to_frequency(complete->channel));
+		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED) {
+			/* Associated to a unallowed channel, disassociate. */
+			__iwm_invalidate_mlme_profile(iwm);
+			IWM_WARN(iwm, "Couldn't associate with %pM due to "
+				 "channel %d is disabled. Check your local "
+				 "regulatory setting.\n",
+				 complete->bssid, complete->channel);
+			goto failure;
+		}
+
 		set_bit(IWM_STATUS_ASSOCIATED, &iwm->status);
 		memcpy(iwm->bssid, complete->bssid, ETH_ALEN);
 		iwm->channel = complete->channel;
@@ -562,6 +576,7 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 					GFP_KERNEL);
 		break;
 	case UMAC_ASSOC_COMPLETE_FAILURE:
+ failure:
 		clear_bit(IWM_STATUS_ASSOCIATED, &iwm->status);
 		memset(iwm->bssid, 0, ETH_ALEN);
 		iwm->channel = 0;
-- 
1.6.0.4

