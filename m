Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:38524 "HELO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752441Ab2ALEG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 23:06:28 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: derive priv from net_device instead of wiphy
Date: Wed, 11 Jan 2012 20:06:12 -0800
Message-Id: <1326341172-8034-2-git-send-email-bzhao@marvell.com> (sfid-20120112_050636_652680_690D5D60)
In-Reply-To: <1326341172-8034-1-git-send-email-bzhao@marvell.com>
References: <1326341172-8034-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Currently mwifiex_private pointers are derived from wiphy
structures. This will always work as long as there is only
one net_device associated with one wiphy. In scenarios where
there are multiple net_devices associated with single
wiphy, one should use net_device to derive the priv.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 36f67da..00f1005 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -79,7 +79,7 @@ static int
 mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 			 u8 key_index, bool pairwise, const u8 *mac_addr)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
 
 	if (mwifiex_set_encode(priv, NULL, 0, key_index, 1)) {
 		wiphy_err(wiphy, "deleting the crypto keys\n");
@@ -122,7 +122,7 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 				struct net_device *dev,
 				bool enabled, int timeout)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	u32 ps_mode;
 
 	if (timeout)
@@ -143,7 +143,7 @@ mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 				 u8 key_index, bool unicast,
 				 bool multicast)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
 
 	/* Return if WEP key not configured */
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED)
@@ -165,7 +165,7 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 			 u8 key_index, bool pairwise, const u8 *mac_addr,
 			 struct key_params *params)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
 
 	if (mwifiex_set_encode(priv, params->key, params->key_len,
 							key_index, 0)) {
@@ -376,7 +376,7 @@ mwifiex_cfg80211_set_channel(struct wiphy *wiphy, struct net_device *dev,
 			     struct ieee80211_channel *chan,
 			     enum nl80211_channel_type channel_type)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	if (priv->media_connected) {
 		wiphy_err(wiphy, "This setting is valid only when station "
@@ -1004,7 +1004,7 @@ static int
 mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_ibss_params *params)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	int ret = 0;
 
 	if (priv->bss_mode != NL80211_IFTYPE_ADHOC) {
@@ -1042,7 +1042,7 @@ done:
 static int
 mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	wiphy_dbg(wiphy, "info: disconnecting from essid %pM\n",
 			priv->cfg_bssid);
@@ -1280,10 +1280,7 @@ EXPORT_SYMBOL_GPL(mwifiex_add_virtual_intf);
  */
 int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
-
-	if (!priv || !dev)
-		return 0;
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_remove(priv);
-- 
1.7.0.2

