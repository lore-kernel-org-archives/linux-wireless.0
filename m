Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0071.outbound.protection.outlook.com ([104.47.41.71]:30304
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751635AbdG0XHl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 19:07:41 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 07/12] qtnfmac: move current channel info from vif to mac
Date: Fri, 28 Jul 2017 02:06:49 +0300
Message-Id: <20170727230654.30850-8-sergey.matyukevich.os@quantenna.com> (sfid-20170728_010746_503017_486D686F)
In-Reply-To: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless cfg80211 core supplies channel settings in cfg80211_ap_settings
structure for each BSS in multiple BSS configuration. On the other hand
all the virtual interfaces on one radio are using the same PHY settings
including channel.

Move chandef structure from vif to mac structure in order to mantain
the only instance of cfg80211_chan_def structure in qtnf_wmac
rather than its multiple copies in qtnf_vif.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 38 +++++++++++++++--------
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  6 ++--
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  2 +-
 3 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index ef8089c163bc..d47050934f00 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -266,11 +266,19 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_ap_settings *settings)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct qtnf_bss_config *bss_cfg;
 	int ret;
 
-	bss_cfg = &vif->bss_cfg;
+	if (!cfg80211_chandef_identical(&mac->chandef, &settings->chandef)) {
+		memcpy(&mac->chandef, &settings->chandef, sizeof(mac->chandef));
+		if (vif->vifid != 0)
+			pr_warn("%s: unexpected chan %u (%u MHz)\n", dev->name,
+				settings->chandef.chan->hw_value,
+				settings->chandef.chan->center_freq);
+	}
 
+	bss_cfg = &vif->bss_cfg;
 	memset(bss_cfg, 0, sizeof(*bss_cfg));
 
 	bss_cfg->bcn_period = settings->beacon_interval;
@@ -281,8 +289,6 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	bss_cfg->ssid_len = settings->ssid_len;
 	memcpy(&bss_cfg->ssid, settings->ssid, bss_cfg->ssid_len);
 
-	memcpy(&bss_cfg->chandef, &settings->chandef,
-	       sizeof(struct cfg80211_chan_def));
 	memcpy(&bss_cfg->crypto, &settings->crypto,
 	       sizeof(struct cfg80211_crypto_settings));
 
@@ -593,6 +599,7 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	     struct cfg80211_connect_params *sme)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct cfg80211_chan_def chandef;
 	struct qtnf_bss_config *bss_cfg;
 	int ret;
@@ -615,7 +622,7 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 			cfg80211_chandef_create(&chandef, sme->channel,
 						NL80211_CHAN_HT20);
 
-		memcpy(&bss_cfg->chandef, &chandef, sizeof(bss_cfg->chandef));
+		memcpy(&mac->chandef, &chandef, sizeof(mac->chandef));
 	}
 
 	bss_cfg->ssid_len = sme->ssid_len;
@@ -695,14 +702,14 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct ieee80211_supported_band *sband;
-	struct cfg80211_chan_def *bss_chandef;
+	struct cfg80211_chan_def *chandef;
 	struct ieee80211_channel *chan;
 	struct qtnf_chan_stats stats;
 	struct qtnf_vif *vif;
 	int ret;
 
 	vif = qtnf_netdev_get_priv(dev);
-	bss_chandef = &vif->bss_cfg.chandef;
+	chandef = &mac->chandef;
 
 	sband = wiphy->bands[NL80211_BAND_2GHZ];
 	if (sband && idx >= sband->n_channels) {
@@ -722,9 +729,10 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 	survey->channel = chan;
 	survey->filled = 0x0;
 
-	if (bss_chandef->chan)
-		if (chan->hw_value == bss_chandef->chan->hw_value)
-			survey->filled |= SURVEY_INFO_IN_USE;
+	if (chandef->chan) {
+		if (chan->hw_value == chandef->chan->hw_value)
+			survey->filled = SURVEY_INFO_IN_USE;
+	}
 
 	ret = qtnf_cmd_get_chan_stats(mac, chan->hw_value, &stats);
 	switch (ret) {
@@ -736,7 +744,7 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 			break;
 		}
 
-		survey->filled = SURVEY_INFO_TIME |
+		survey->filled |= SURVEY_INFO_TIME |
 				 SURVEY_INFO_TIME_SCAN |
 				 SURVEY_INFO_TIME_BUSY |
 				 SURVEY_INFO_TIME_RX |
@@ -768,15 +776,14 @@ static int
 qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 		 struct cfg80211_chan_def *chandef)
 {
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct net_device *ndev = wdev->netdev;
-	struct qtnf_bss_config *bss_cfg;
 	struct qtnf_vif *vif;
 
 	if (!ndev)
 		return -ENODEV;
 
 	vif = qtnf_netdev_get_priv(wdev->netdev);
-	bss_cfg = &vif->bss_cfg;
 
 	switch (vif->wdev.iftype) {
 	case NL80211_IFTYPE_STATION:
@@ -796,7 +803,12 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return -ENODATA;
 	}
 
-	memcpy(chandef, &bss_cfg->chandef, sizeof(*chandef));
+	if (!cfg80211_chandef_valid(&mac->chandef)) {
+		pr_err("invalid channel settings on %s\n", ndev->name);
+		return -ENODATA;
+	}
+
+	memcpy(chandef, &mac->chandef, sizeof(*chandef));
 	return 0;
 }
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index c8c0685f81b3..a3c3dddb194c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -185,7 +185,7 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif)
 {
 	struct sk_buff *cmd_skb;
 	struct qtnf_bss_config *bss_cfg = &vif->bss_cfg;
-	struct cfg80211_chan_def *chandef = &bss_cfg->chandef;
+	struct cfg80211_chan_def *chandef = &vif->mac->chandef;
 	struct qlink_tlv_channel *qchan;
 	struct qlink_auth_encr aen;
 	u16 res_code = QLINK_CMD_RESULT_OK;
@@ -2035,8 +2035,8 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 
 	ether_addr_copy(cmd->bssid, bss_cfg->bssid);
 
-	if (bss_cfg->chandef.chan)
-		cmd->channel = cpu_to_le16(bss_cfg->chandef.chan->hw_value);
+	if (vif->mac->chandef.chan)
+		cmd->channel = cpu_to_le16(vif->mac->chandef.chan->hw_value);
 
 	cmd->bg_scan_period = cpu_to_le16(bss_cfg->bg_scan_period);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index b2d050c4f1e2..6830ff45976d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -67,7 +67,6 @@ struct qtnf_bss_config {
 	u16 auth_type;
 	bool privacy;
 	enum nl80211_mfp mfp;
-	struct cfg80211_chan_def chandef;
 	struct cfg80211_crypto_settings crypto;
 	u16 bg_scan_period;
 	u32 connect_flags;
@@ -141,6 +140,7 @@ struct qtnf_wmac {
 	struct qtnf_mac_info macinfo;
 	struct qtnf_vif iflist[QTNF_MAX_INTF];
 	struct cfg80211_scan_request *scan_req;
+	struct cfg80211_chan_def chandef;
 };
 
 struct qtnf_hw_info {
-- 
2.11.0
