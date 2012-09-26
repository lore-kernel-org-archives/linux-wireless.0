Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:47213 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811Ab2IZDbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:31:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 10/15] mwifiex: add P2P interface
Date: Tue, 25 Sep 2012 20:23:40 -0700
Message-Id: <1348629825-12001-11-git-send-email-bzhao@marvell.com> (sfid-20120926_053140_511354_233282F1)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Due to firmware design, driver needs to add a default P2P interface
to implement find phase and action frame handshake.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   39 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/decl.h     |    3 +-
 drivers/net/wireless/mwifiex/main.c     |    7 +++++
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 1f4bd67..ece267a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -22,7 +22,7 @@
 
 static const struct ieee80211_iface_limit mwifiex_ap_sta_limits[] = {
 	{
-		.max = 1, .types = BIT(NL80211_IFTYPE_STATION),
+		.max = 2, .types = BIT(NL80211_IFTYPE_STATION),
 	},
 	{
 		.max = 1, .types = BIT(NL80211_IFTYPE_AP),
@@ -1918,6 +1918,41 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->bss_mode = type;
 
 		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		priv = adapter->priv[MWIFIEX_BSS_TYPE_P2P];
+
+		if (priv->bss_mode) {
+			wiphy_err(wiphy, "Can't create multiple P2P ifaces");
+			return ERR_PTR(-EINVAL);
+		}
+
+		wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+		if (!wdev)
+			return ERR_PTR(-ENOMEM);
+
+		priv->wdev = wdev;
+		wdev->wiphy = wiphy;
+
+		/* At start-up, wpa_supplicant tries to change the interface
+		 * to NL80211_IFTYPE_STATION if it is not managed mode.
+		 * So, we initialize it to STA mode.
+		 */
+		wdev->iftype = NL80211_IFTYPE_STATION;
+		priv->bss_mode = NL80211_IFTYPE_STATION;
+
+		/* Setting bss_type to P2P tells firmware that this interface
+		 * is receiving P2P peers found during find phase and doing
+		 * action frame handshake.
+		 */
+		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
+
+		priv->frame_type = MWIFIEX_DATA_FRAME_TYPE_ETH_II;
+		priv->bss_priority = MWIFIEX_BSS_ROLE_STA;
+		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
+		priv->bss_started = 0;
+		priv->bss_num = 0;
+
+		break;
 	default:
 		wiphy_err(wiphy, "type not supported\n");
 		return ERR_PTR(-EINVAL);
@@ -2069,6 +2104,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->max_remain_on_channel_duration = 5000;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				 BIT(NL80211_IFTYPE_ADHOC) |
+				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				 BIT(NL80211_IFTYPE_P2P_GO) |
 				 BIT(NL80211_IFTYPE_AP);
 
 	wiphy->bands[IEEE80211_BAND_2GHZ] = &mwifiex_band_2ghz;
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index d21bcc1..e9357d8 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -28,7 +28,7 @@
 #include <linux/ieee80211.h>
 
 
-#define MWIFIEX_MAX_BSS_NUM         (2)
+#define MWIFIEX_MAX_BSS_NUM         (3)
 
 #define MWIFIEX_MIN_DATA_HEADER_LEN 36	/* sizeof(mwifiex_txpd)
 					 *   + 4 byte alignment
@@ -70,6 +70,7 @@
 enum mwifiex_bss_type {
 	MWIFIEX_BSS_TYPE_STA = 0,
 	MWIFIEX_BSS_TYPE_UAP = 1,
+	MWIFIEX_BSS_TYPE_P2P = 2,
 	MWIFIEX_BSS_TYPE_ANY = 0xff,
 };
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 3bb3417..eb22dd2 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -369,6 +369,13 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 		dev_err(adapter->dev, "cannot create default AP interface\n");
 		goto err_add_intf;
 	}
+
+	/* Create P2P interface by default */
+	if (!mwifiex_add_virtual_intf(adapter->wiphy, "p2p%d",
+				      NL80211_IFTYPE_P2P_CLIENT, NULL, NULL)) {
+		dev_err(adapter->dev, "cannot create default P2P interface\n");
+		goto err_add_intf;
+	}
 	rtnl_unlock();
 
 	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
-- 
1.7.0.2

