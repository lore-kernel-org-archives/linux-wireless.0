Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37474 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaFMHdQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 03:33:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: clean up own address matching
Date: Fri, 13 Jun 2014 09:33:13 +0200
Message-Id: <1402644793-6383-1-git-send-email-johannes@sipsolutions.net> (sfid-20140613_093319_770326_9F3D3A45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using perm_addr is always wrong, it may be reassigned by
anyone using standard netdev APIs. Remove that from the
match function and also use the match function where only
the perm_addr was used now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 66 ++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index a312c653d116..06a0722164da 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -781,6 +781,36 @@ static void mac80211_hwsim_monitor_ack(struct ieee80211_channel *chan,
 	netif_rx(skb);
 }
 
+struct mac80211_hwsim_addr_match_data {
+	u8 addr[ETH_ALEN];
+	bool ret;
+};
+
+static void mac80211_hwsim_addr_iter(void *data, u8 *mac,
+				     struct ieee80211_vif *vif)
+{
+	struct mac80211_hwsim_addr_match_data *md = data;
+
+	if (memcmp(mac, md->addr, ETH_ALEN) == 0)
+		md->ret = true;
+}
+
+static bool mac80211_hwsim_addr_match(struct mac80211_hwsim_data *data,
+				      const u8 *addr)
+{
+	struct mac80211_hwsim_addr_match_data md = {
+		.ret = false,
+	};
+
+	memcpy(md.addr, addr, ETH_ALEN);
+
+	ieee80211_iterate_active_interfaces_atomic(data->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   mac80211_hwsim_addr_iter,
+						   &md);
+
+	return md.ret;
+}
 
 static bool hwsim_ps_rx_ok(struct mac80211_hwsim_data *data,
 			   struct sk_buff *skb)
@@ -798,8 +828,7 @@ static bool hwsim_ps_rx_ok(struct mac80211_hwsim_data *data,
 		/* Allow unicast frames to own address if there is a pending
 		 * PS-Poll */
 		if (data->ps_poll_pending &&
-		    memcmp(data->hw->wiphy->perm_addr, skb->data + 4,
-			   ETH_ALEN) == 0) {
+		    mac80211_hwsim_addr_match(data, skb->data + 4)) {
 			data->ps_poll_pending = false;
 			return true;
 		}
@@ -809,39 +838,6 @@ static bool hwsim_ps_rx_ok(struct mac80211_hwsim_data *data,
 	return true;
 }
 
-
-struct mac80211_hwsim_addr_match_data {
-	bool ret;
-	const u8 *addr;
-};
-
-static void mac80211_hwsim_addr_iter(void *data, u8 *mac,
-				     struct ieee80211_vif *vif)
-{
-	struct mac80211_hwsim_addr_match_data *md = data;
-	if (memcmp(mac, md->addr, ETH_ALEN) == 0)
-		md->ret = true;
-}
-
-
-static bool mac80211_hwsim_addr_match(struct mac80211_hwsim_data *data,
-				      const u8 *addr)
-{
-	struct mac80211_hwsim_addr_match_data md;
-
-	if (memcmp(addr, data->hw->wiphy->perm_addr, ETH_ALEN) == 0)
-		return true;
-
-	md.ret = false;
-	md.addr = addr;
-	ieee80211_iterate_active_interfaces_atomic(data->hw,
-						   IEEE80211_IFACE_ITER_NORMAL,
-						   mac80211_hwsim_addr_iter,
-						   &md);
-
-	return md.ret;
-}
-
 static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 				       struct sk_buff *my_skb,
 				       int dst_portid)
-- 
2.0.0

