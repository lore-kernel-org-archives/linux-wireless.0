Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:35943 "HELO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756336Ab2EIBdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 21:33:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 05/18] mwifiex: save adapter pointer in wiphy_priv
Date: Tue,  8 May 2012 18:30:17 -0700
Message-Id: <1336527030-2045-6-git-send-email-bzhao@marvell.com> (sfid-20120509_033320_617451_916CC8DB)
In-Reply-To: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
References: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Since wiphy structure is per adapter we would save adapter,
instead of mwifiex private pointer, in wiphy_priv.
Also move country_info from mwifiex_private to mwifiex_adapter
as making it part of mwifiex_adapter looks logical.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   48 +++++++++++++++--------------
 drivers/net/wireless/mwifiex/main.h      |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c |    2 +-
 3 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4532393..ff627e1 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -84,7 +84,7 @@ mwifiex_is_alg_wep(u32 cipher)
 /*
  * This function retrieves the private structure from kernel wiphy structure.
  */
-static void *mwifiex_cfg80211_get_priv(struct wiphy *wiphy)
+static void *mwifiex_cfg80211_get_adapter(struct wiphy *wiphy)
 {
 	return (void *) (*(unsigned long *) wiphy_priv(wiphy));
 }
@@ -115,7 +115,8 @@ mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 			      enum nl80211_tx_power_setting type,
 			      int mbm)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
+	struct mwifiex_private *priv;
 	struct mwifiex_power_cfg power_cfg;
 	int dbm = MBM_TO_DBM(mbm);
 
@@ -126,6 +127,8 @@ mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 		power_cfg.is_power_auto = 1;
 	}
 
+	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+
 	return mwifiex_set_tx_power(priv, &power_cfg);
 }
 
@@ -209,13 +212,13 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 	enum ieee80211_band band;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
-	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
+	struct mwifiex_private *priv;
 	struct mwifiex_802_11d_domain_reg *domain_info = &adapter->domain_reg;
 
 	/* Set country code */
-	domain_info->country_code[0] = priv->country_code[0];
-	domain_info->country_code[1] = priv->country_code[1];
+	domain_info->country_code[0] = adapter->country_code[0];
+	domain_info->country_code[1] = adapter->country_code[1];
 	domain_info->country_code[2] = ' ';
 
 	band = mwifiex_band_to_radio_type(adapter->config_bands);
@@ -267,6 +270,8 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 
 	domain_info->no_of_triplet = no_of_triplet;
 
+	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+
 	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
 				   HostCmd_ACT_GEN_SET, 0, NULL)) {
 		wiphy_err(wiphy, "11D: setting domain info in FW\n");
@@ -289,12 +294,12 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 static int mwifiex_reg_notifier(struct wiphy *wiphy,
 				struct regulatory_request *request)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
 
-	wiphy_dbg(wiphy, "info: cfg80211 regulatory domain callback for domain"
-			" %c%c\n", request->alpha2[0], request->alpha2[1]);
+	wiphy_dbg(wiphy, "info: cfg80211 regulatory domain callback for %c%c\n",
+		  request->alpha2[0], request->alpha2[1]);
 
-	memcpy(priv->country_code, request->alpha2, sizeof(request->alpha2));
+	memcpy(adapter->country_code, request->alpha2, sizeof(request->alpha2));
 
 	switch (request->initiator) {
 	case NL80211_REGDOM_SET_BY_DRIVER:
@@ -392,15 +397,15 @@ mwifiex_cfg80211_set_channel(struct wiphy *wiphy, struct net_device *dev,
 			     enum nl80211_channel_type channel_type)
 {
 	struct mwifiex_private *priv;
+	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
 
 	if (dev)
 		priv = mwifiex_netdev_get_priv(dev);
 	else
-		priv = mwifiex_cfg80211_get_priv(wiphy);
+		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
 
 	if (priv->media_connected) {
-		wiphy_err(wiphy, "This setting is valid only when station "
-				"is not connected\n");
+		wiphy_err(wiphy, "This is invalid in connected state\n");
 		return -EINVAL;
 	}
 
@@ -456,7 +461,9 @@ mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
 static int
 mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
+	struct mwifiex_private *priv = mwifiex_get_priv(adapter,
+							MWIFIEX_BSS_ROLE_STA);
 	int ret = 0;
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
@@ -1300,16 +1307,12 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 					    u32 *flags,
 					    struct vif_params *params)
 {
-	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
-	struct mwifiex_adapter *adapter;
+	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
+	struct mwifiex_private *priv;
 	struct net_device *dev;
 	void *mdev_priv;
 	struct wireless_dev *wdev;
 
-	if (!priv)
-		return NULL;
-
-	adapter = priv->adapter;
 	if (!adapter)
 		return NULL;
 
@@ -1538,10 +1541,9 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 
 	wiphy->reg_notifier = mwifiex_reg_notifier;
 
-	/* Set struct mwifiex_private pointer in wiphy_priv */
+	/* Set struct mwifiex_adapter pointer in wiphy_priv */
 	wdev_priv = wiphy_priv(wiphy);
-
-	*(unsigned long *) wdev_priv = (unsigned long) priv;
+	*(unsigned long *)wdev_priv = (unsigned long)adapter;
 
 	set_wiphy_dev(wiphy, (struct device *)priv->adapter->dev);
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 9fc2242..e324e29 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -471,7 +471,6 @@ struct mwifiex_private {
 	struct cfg80211_scan_request *scan_request;
 	struct mwifiex_user_scan_cfg *user_scan_cfg;
 	u8 cfg_bssid[6];
-	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	struct wps wps;
 	u8 scan_block;
 	s32 cqm_rssi_thold;
@@ -679,6 +678,7 @@ struct mwifiex_adapter {
 	struct cmd_ctrl_node *cmd_queued;
 	spinlock_t queue_lock;		/* lock for tx queues */
 	struct completion fw_load;
+	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 58970e0..9265e42 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -462,7 +462,7 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 
 	info->bss_chan = bss_desc->channel;
 
-	memcpy(info->country_code, priv->country_code,
+	memcpy(info->country_code, adapter->country_code,
 	       IEEE80211_COUNTRY_STRING_LEN);
 
 	info->media_connected = priv->media_connected;
-- 
1.7.0.2

