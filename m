Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:58664 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1CKCyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:54:04 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: remove unnecessary type casting
Date: Thu, 10 Mar 2011 18:57:09 -0800
Message-Id: <1299812229-27370-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299812229-27370-1-git-send-email-bzhao@marvell.com>
References: <1299812229-27370-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Type casting in these places is not needed.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   39 ++++++++++--------------------
 drivers/net/wireless/mwifiex/main.c     |   15 ++++--------
 2 files changed, 18 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index f19a7cf..3c77f8e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -161,8 +161,7 @@ static int
 mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 			 u8 key_index, bool pairwise, const u8 *mac_addr)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	int ret = 0;
 
 	ret = mwifiex_set_encode(priv, 0, NULL, 0, key_index, 1);
@@ -184,8 +183,7 @@ mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 			      int dbm)
 {
 	int ret = 0;
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 
 	ret = mwifiex_set_tx_power(priv, type, dbm);
 
@@ -203,8 +201,7 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 				bool enabled, int timeout)
 {
 	int ret = 0;
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 
 	if (timeout)
 		wiphy_dbg(wiphy,
@@ -235,8 +232,7 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 			 u8 key_index, bool pairwise, const u8 *mac_addr,
 			 struct key_params *params)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	int ret = 0;
 
 	ret = mwifiex_set_encode(priv, params->cipher, params->key,
@@ -267,8 +263,7 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 	enum ieee80211_band band;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
-	struct mwifiex_private *priv = (struct mwifiex_private *)
-					mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_802_11d_domain_reg *domain_info = &adapter->domain_reg;
 	int ret = 0;
@@ -348,8 +343,7 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 static int mwifiex_reg_notifier(struct wiphy *wiphy,
 		struct regulatory_request *request)
 {
-	struct mwifiex_private *priv = (struct mwifiex_private *)
-				mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 
 	wiphy_dbg(wiphy, "info: cfg80211 regulatory domain callback for domain"
 			" %c%c\n", request->alpha2[0], request->alpha2[1]);
@@ -448,8 +442,7 @@ mwifiex_cfg80211_set_channel(struct wiphy *wiphy, struct net_device *dev,
 			     struct ieee80211_channel *chan,
 			     enum nl80211_channel_type channel_type)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 
 	if (priv->media_connected) {
 		wiphy_err(wiphy, "This setting is valid only when station "
@@ -535,8 +528,7 @@ mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
 static int
 mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 
 	int ret = 0;
 
@@ -785,8 +777,7 @@ static int
 mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 			    u16 reason_code)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	if (priv->disconnect)
 		return -EBUSY;
@@ -1164,8 +1155,7 @@ static int
 mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_connect_params *sme)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	int ret = 0;
 	int mode = 0;
 
@@ -1204,8 +1194,7 @@ static int
 mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_ibss_params *params)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	int ret = 0;
 	int mode = 0;
 
@@ -1242,8 +1231,7 @@ done:
 static int
 mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 
 	if (priv->disconnect)
 		return -EBUSY;
@@ -1271,8 +1259,7 @@ static int
 mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_scan_request *request)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	wiphy_dbg(wiphy, "info: received scan request on %s\n", dev->name);
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index b5d06c1..f3d0f69 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -535,8 +535,7 @@ mwifiex_close(struct net_device *dev)
 static int
 mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct sk_buff *new_skb = NULL;
 	struct mwifiex_txinfo *tx_info;
 
@@ -596,8 +595,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 static int
 mwifiex_set_mac_address(struct net_device *dev, void *addr)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct sockaddr *hw_addr = (struct sockaddr *) addr;
 
 	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
@@ -616,8 +614,7 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
  */
 static void mwifiex_set_multicast_list(struct net_device *dev)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	mwifiex_request_set_multicast_list(priv, dev);
 }
 
@@ -627,8 +624,7 @@ static void mwifiex_set_multicast_list(struct net_device *dev)
 static void
 mwifiex_tx_timeout(struct net_device *dev)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	dev_err(priv->adapter->dev, "%lu : Tx timeout, bss_index=%d\n",
 				jiffies, priv->bss_index);
@@ -641,8 +637,7 @@ mwifiex_tx_timeout(struct net_device *dev)
  */
 static struct net_device_stats *mwifiex_get_stats(struct net_device *dev)
 {
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	return &priv->stats;
 }
-- 
1.7.0.2

