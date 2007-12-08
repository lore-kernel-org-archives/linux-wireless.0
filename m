Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40377 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752245AbXLHLVy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:21:54 -0500
Subject: [PATCH 2/4] iwlwifi: Update to changed mac80211 rate control
	interface
From: Mattias Nissler <mattias.nissler@gmx.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1197112439.7472.34.camel@localhost>
References: <1197112439.7472.34.camel@localhost>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 12:21:51 +0100
Message-Id: <1197112911.7472.50.camel@localhost> (sfid-20071208_112159_242287_9A8FB022)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This brings iwlwifi rate control code back in sync with mac80211.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   44 ++++----------------------
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   47 ++++++----------------------
 2 files changed, 17 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index adcd106..022cea0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -560,22 +560,6 @@ static void rs_tx_status(void *priv_rate,
 	return;
 }
 
-static struct ieee80211_rate *iwl3945_get_lowest_rate(struct ieee80211_local
-						  *local)
-{
-	struct ieee80211_hw_mode *mode = local->oper_hw_mode;
-	int i;
-
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rate = &mode->rates[i];
-
-		if (rate->flags & IEEE80211_RATE_SUPPORTED)
-			return rate;
-	}
-
-	return &mode->rates[0];
-}
-
 static u16 iwl3945_get_adjacent_rate(struct iwl3945_rate_scale_priv *rs_priv,
 				 u8 index, u16 rate_mask, int phymode)
 {
@@ -654,10 +638,9 @@ static u16 iwl3945_get_adjacent_rate(struct iwl3945_rate_scale_priv *rs_priv,
  * rate table and must reference the driver allocated rate table
  *
  */
-static struct ieee80211_rate *rs_get_rate(void *priv_rate,
-					  struct net_device *dev,
-					  struct sk_buff *skb,
-					  struct rate_control_extra *extra)
+static void rs_get_rate(void *priv_rate, struct net_device *dev,
+			struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			struct rate_selection *sel)
 {
 	u8 low = IWL_RATE_INVALID;
 	u8 high = IWL_RATE_INVALID;
@@ -674,32 +657,19 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct sta_info *sta;
-	u16 fc, rate_mask;
+	u16 rate_mask;
 	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_RATE("enter\n");
 
-	memset(extra, 0, sizeof(*extra));
-
-	fc = le16_to_cpu(hdr->frame_control);
-	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
-	    (is_multicast_ether_addr(hdr->addr1))) {
-		/* Send management frames and broadcast/multicast data using
-		 * lowest rate. */
-		/* TODO: this could probably be improved.. */
-		IWL_DEBUG_RATE("leave: lowest rate (not data or is "
-			       "multicast)\n");
-
-		return iwl3945_get_lowest_rate(local);
-	}
-
 	sta = sta_info_get(local, hdr->addr1);
 	if (!sta || !sta->rate_ctrl_priv) {
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
+		sel->rate = rate_lowest(local, local->oper_hw_mode, sta);
 		if (sta)
 			sta_info_put(sta);
-		return NULL;
+		return;
 	}
 
 	rate_mask = sta->supp_rates;
@@ -844,7 +814,7 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 
 	IWL_DEBUG_RATE("leave: %d\n", index);
 
-	return &priv->ieee_rates[index];
+	sel->rate = &priv->ieee_rates[index];
 }
 
 static struct rate_control_ops rs_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 4b6aa96..4455a5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1667,55 +1667,26 @@ static void rs_initialize_lq(struct iwl4965_priv *priv,
 	return;
 }
 
-static struct ieee80211_rate *rs_get_lowest_rate(struct ieee80211_local
-						 *local)
+static void rs_get_rate(void *priv_rate, struct net_device *dev,
+			struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			struct rate_selection *sel)
 {
-	struct ieee80211_hw_mode *mode = local->oper_hw_mode;
-	int i;
-
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rate = &mode->rates[i];
-
-		if (rate->flags & IEEE80211_RATE_SUPPORTED)
-			return rate;
-	}
-
-	return &mode->rates[0];
-}
-
-static struct ieee80211_rate *rs_get_rate(void *priv_rate,
-					       struct net_device *dev,
-					       struct sk_buff *skb,
-					       struct rate_control_extra
-					       *extra)
-{
-
 	int i;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct sta_info *sta;
-	u16 fc;
 	struct iwl4965_priv *priv = (struct iwl4965_priv *)priv_rate;
 	struct iwl4965_rate_scale_priv *lq;
 
 	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
 
-	memset(extra, 0, sizeof(*extra));
-
-	fc = le16_to_cpu(hdr->frame_control);
-	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1)) {
-		/* Send management frames and broadcast/multicast data using
-		 * lowest rate. */
-		/* TODO: this could probably be improved.. */
-		return rs_get_lowest_rate(local);
-	}
-
 	sta = sta_info_get(local, hdr->addr1);
 
 	if (!sta || !sta->rate_ctrl_priv) {
+		sel->rate = rate_lowest(local, local->oper_hw_mode, sta);
 		if (sta)
 			sta_info_put(sta);
-		return rs_get_lowest_rate(local);
+		return;
 	}
 
 	lq = (struct iwl4965_rate_scale_priv *)sta->rate_ctrl_priv;
@@ -1742,11 +1713,13 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 	}
 
  done:
+	if ((i < 0) || (i > IWL_RATE_COUNT)) {
+		sel->rate = rate_lowest(local, local->oper_hw_mode, sta);
+		return;
+	}
 	sta_info_put(sta);
-	if ((i < 0) || (i > IWL_RATE_COUNT))
-		return rs_get_lowest_rate(local);
 
-	return &priv->ieee_rates[i];
+	sel->rate = &priv->ieee_rates[i];
 }
 
 static void *rs_alloc_sta(void *priv, gfp_t gfp)
-- 
1.5.3.4

