Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0083.outbound.protection.outlook.com ([104.47.41.83]:62175
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752117AbdFTT4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 15:56:09 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 6/8] qtnfmac: move current channel info from vif to mac
Date: Tue, 20 Jun 2017 22:55:15 +0300
Message-Id: <20170620195517.18373-7-sergey.matyukevich.os@quantenna.com> (sfid-20170620_215614_335779_CA01C4DC)
In-Reply-To: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
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

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 39 +++++++++++++++--------
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  6 ++--
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  2 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c    |  7 ++--
 4 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 77afc0fc8c03..3f90f57ed595 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -408,11 +408,19 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
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
@@ -423,8 +431,6 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	bss_cfg->ssid_len = settings->ssid_len;
 	memcpy(&bss_cfg->ssid, settings->ssid, bss_cfg->ssid_len);
 
-	memcpy(&bss_cfg->chandef, &settings->chandef,
-	       sizeof(struct cfg80211_chan_def));
 	memcpy(&bss_cfg->crypto, &settings->crypto,
 	       sizeof(struct cfg80211_crypto_settings));
 
@@ -755,6 +761,7 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	     struct cfg80211_connect_params *sme)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct cfg80211_chan_def chandef;
 	struct qtnf_bss_config *bss_cfg;
 	int ret;
@@ -777,7 +784,7 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 			cfg80211_chandef_create(&chandef, sme->channel,
 						NL80211_CHAN_HT20);
 
-		memcpy(&bss_cfg->chandef, &chandef, sizeof(bss_cfg->chandef));
+		memcpy(&mac->chandef, &chandef, sizeof(mac->chandef));
 	}
 
 	bss_cfg->ssid_len = sme->ssid_len;
@@ -857,14 +864,14 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
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
@@ -884,9 +891,10 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
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
@@ -898,7 +906,7 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 			break;
 		}
 
-		survey->filled = SURVEY_INFO_TIME |
+		survey->filled |= SURVEY_INFO_TIME |
 				 SURVEY_INFO_TIME_SCAN |
 				 SURVEY_INFO_TIME_BUSY |
 				 SURVEY_INFO_TIME_RX |
@@ -930,15 +938,14 @@ static int
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
@@ -950,7 +957,6 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 	case NL80211_IFTYPE_AP_VLAN:
 		/* AP_VLAN: get primary vif and pass through to AP */
 		vif = vif->u.vlan.parent;
-		bss_cfg = &vif->bss_cfg;
 	case NL80211_IFTYPE_AP:
 		if (!(vif->bss_status & QTNF_STATE_AP_START)) {
 			pr_warn("%s: AP not started\n", ndev->name);
@@ -962,7 +968,12 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
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
index 2e7034a560aa..f44ae71047c3 100644
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
@@ -2086,8 +2086,8 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 
 	ether_addr_copy(cmd->bssid, bss_cfg->bssid);
 
-	if (bss_cfg->chandef.chan)
-		cmd->channel = cpu_to_le16(bss_cfg->chandef.chan->hw_value);
+	if (vif->mac->chandef.chan)
+		cmd->channel = cpu_to_le16(vif->mac->chandef.chan->hw_value);
 
 	cmd->bg_scan_period = cpu_to_le16(bss_cfg->bg_scan_period);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 8824e3d0b5bc..3c62f5bd28e4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -68,7 +68,6 @@ struct qtnf_bss_config {
 	u16 auth_type;
 	bool privacy;
 	enum nl80211_mfp mfp;
-	struct cfg80211_chan_def chandef;
 	struct cfg80211_crypto_settings crypto;
 	u16 bg_scan_period;
 	u32 connect_flags;
@@ -155,6 +154,7 @@ struct qtnf_wmac {
 	struct qtnf_mac_info macinfo;
 	struct qtnf_vif iflist[QTNF_MAX_INTF];
 	struct cfg80211_scan_request *scan_req;
+	struct cfg80211_chan_def chandef;
 };
 
 struct qtnf_hw_info {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 6e1e93ccc40e..d1edeb3892df 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -358,7 +358,6 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 	struct wiphy *wiphy = priv_to_wiphy(mac);
 	struct cfg80211_chan_def chandef;
 	struct ieee80211_channel *chan;
-	struct qtnf_bss_config *bss_cfg;
 	struct qtnf_vif *vif;
 	int freq;
 	int i;
@@ -383,16 +382,14 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 	if (!cfg80211_chandef_valid(&chandef))
 		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
 
+	memcpy(&mac->chandef, &chandef, sizeof(mac->chandef));
+
 	for (i = 0; i < QTNF_MAX_INTF; i++) {
 		vif = &mac->iflist[i];
 		if (vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)
 			continue;
 
 		if (vif->netdev) {
-			bss_cfg = &vif->bss_cfg;
-			memcpy(&bss_cfg->chandef, &chandef,
-			       sizeof(bss_cfg->chandef));
-
 			mutex_lock(&vif->wdev.mtx);
 			cfg80211_ch_switch_notify(vif->netdev, &chandef);
 			mutex_unlock(&vif->wdev.mtx);
-- 
2.11.0
