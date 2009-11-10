Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48637 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZKJBeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 20:34:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, reinette.chatre@intel.com,
	"John W. Linville" <linville@linville-t41.local>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] iwlagn: reenable AP mode
Date: Mon,  9 Nov 2009 20:30:10 -0500
Message-Id: <1257816610-26290-1-git-send-email-linville@linville-t41.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Really just poking around here...am I on the right track?  Or is the
iwlagn firmware supposed to handle buffering broadcast frames?

Looking at Johannes's docs, I don't see anything that seems
to relate to "implement sequence numbering for frames with the
IEEE80211_TX_CTL_ASSIGN_SEQ flag (or ask the hardware to do it for
those frames)".  Anyone know how to ask the hardware to do that?

I also don't see anything for "When sending probe response frames,
the timestamp must be adjusted by the hardware or firmware."  But,
I didn't look too hard -- maybe I missed it?

 drivers/net/wireless/iwlwifi/iwl-agn.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2bbd04d..d02874e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -558,9 +558,17 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 {
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, beacon_update);
-	struct sk_buff *beacon;
+	struct sk_buff *beacon, *skb;
 
-	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
+	/* Tx buffered bcast/mcast traffic. */
+	skb = ieee80211_get_buffered_bc(priv->hw, priv->vif);
+	while (skb) {
+		if (iwl_tx_skb(priv, skb))
+			dev_kfree_skb_any(skb);
+		skb = ieee80211_get_buffered_bc(priv->hw, priv->vif);
+	}
+
+	/* Pull updated AP beacon from mac80211. */
 	beacon = ieee80211_beacon_get(priv->hw, priv->vif);
 
 	if (!beacon) {
@@ -2316,7 +2324,8 @@ static int iwl_setup_mac(struct iwl_priv *priv)
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_SPECTRUM_MGMT;
+		    IEEE80211_HW_SPECTRUM_MGMT |
+		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 
 	if (!priv->cfg->broken_powersave)
 		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
@@ -2324,6 +2333,7 @@ static int iwl_setup_mac(struct iwl_priv *priv)
 
 	hw->sta_data_size = sizeof(struct iwl_station_priv);
 	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
-- 
1.6.2.5

