Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0045.outbound.protection.outlook.com ([104.47.33.45]:52128
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751633AbdG0XHg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 19:07:36 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 05/12] qtnfmac: implement reporting current channel
Date: Fri, 28 Jul 2017 02:06:47 +0300
Message-Id: <20170727230654.30850-6-sergey.matyukevich.os@quantenna.com> (sfid-20170728_010741_323213_9BD50470)
In-Reply-To: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement current channel reporting functionality. Current operating
channel can be obtained either directly using cfg80211 get_channel
callback or from stats reported by cfg80211 survey_dump callback.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 62 ++++++++++++++++++++++-
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  2 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  2 +-
 3 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 23f180b7d43c..ef8089c163bc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -593,6 +593,7 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	     struct cfg80211_connect_params *sme)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	struct cfg80211_chan_def chandef;
 	struct qtnf_bss_config *bss_cfg;
 	int ret;
 
@@ -605,9 +606,20 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	bss_cfg = &vif->bss_cfg;
 	memset(bss_cfg, 0, sizeof(*bss_cfg));
 
+	if (sme->channel) {
+		/* FIXME: need to set proper nl80211_channel_type value */
+		cfg80211_chandef_create(&chandef, sme->channel,
+					NL80211_CHAN_HT20);
+		/* fall-back to minimal safe chandef description */
+		if (!cfg80211_chandef_valid(&chandef))
+			cfg80211_chandef_create(&chandef, sme->channel,
+						NL80211_CHAN_HT20);
+
+		memcpy(&bss_cfg->chandef, &chandef, sizeof(bss_cfg->chandef));
+	}
+
 	bss_cfg->ssid_len = sme->ssid_len;
 	memcpy(&bss_cfg->ssid, sme->ssid, bss_cfg->ssid_len);
-	bss_cfg->chandef.chan = sme->channel;
 	bss_cfg->auth_type = sme->auth_type;
 	bss_cfg->privacy = sme->privacy;
 	bss_cfg->mfp = sme->mfp;
@@ -683,10 +695,15 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct ieee80211_supported_band *sband;
+	struct cfg80211_chan_def *bss_chandef;
 	struct ieee80211_channel *chan;
 	struct qtnf_chan_stats stats;
+	struct qtnf_vif *vif;
 	int ret;
 
+	vif = qtnf_netdev_get_priv(dev);
+	bss_chandef = &vif->bss_cfg.chandef;
+
 	sband = wiphy->bands[NL80211_BAND_2GHZ];
 	if (sband && idx >= sband->n_channels) {
 		idx -= sband->n_channels;
@@ -705,6 +722,10 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 	survey->channel = chan;
 	survey->filled = 0x0;
 
+	if (bss_chandef->chan)
+		if (chan->hw_value == bss_chandef->chan->hw_value)
+			survey->filled |= SURVEY_INFO_IN_USE;
+
 	ret = qtnf_cmd_get_chan_stats(mac, chan->hw_value, &stats);
 	switch (ret) {
 	case 0:
@@ -743,6 +764,42 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static int
+qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_chan_def *chandef)
+{
+	struct net_device *ndev = wdev->netdev;
+	struct qtnf_bss_config *bss_cfg;
+	struct qtnf_vif *vif;
+
+	if (!ndev)
+		return -ENODEV;
+
+	vif = qtnf_netdev_get_priv(wdev->netdev);
+	bss_cfg = &vif->bss_cfg;
+
+	switch (vif->wdev.iftype) {
+	case NL80211_IFTYPE_STATION:
+		if (vif->sta_state == QTNF_STA_DISCONNECTED) {
+			pr_warn("%s: STA disconnected\n", ndev->name);
+			return -ENODATA;
+		}
+		break;
+	case NL80211_IFTYPE_AP:
+		if (!(vif->bss_status & QTNF_STATE_AP_START)) {
+			pr_warn("%s: AP not started\n", ndev->name);
+			return -ENODATA;
+		}
+		break;
+	default:
+		pr_err("unsupported vif type (%d)\n", vif->wdev.iftype);
+		return -ENODATA;
+	}
+
+	memcpy(chandef, &bss_cfg->chandef, sizeof(*chandef));
+	return 0;
+}
+
 static struct cfg80211_ops qtn_cfg80211_ops = {
 	.add_virtual_intf	= qtnf_add_virtual_intf,
 	.change_virtual_intf	= qtnf_change_virtual_intf,
@@ -764,7 +821,8 @@ static struct cfg80211_ops qtn_cfg80211_ops = {
 	.scan			= qtnf_scan,
 	.connect		= qtnf_connect,
 	.disconnect		= qtnf_disconnect,
-	.dump_survey		= qtnf_dump_survey
+	.dump_survey		= qtnf_dump_survey,
+	.get_channel		= qtnf_get_channel
 };
 
 static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index a1ce12082e10..c8c0685f81b3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2036,7 +2036,7 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 	ether_addr_copy(cmd->bssid, bss_cfg->bssid);
 
 	if (bss_cfg->chandef.chan)
-		cmd->freq = cpu_to_le16(bss_cfg->chandef.chan->center_freq);
+		cmd->channel = cpu_to_le16(bss_cfg->chandef.chan->hw_value);
 
 	cmd->bg_scan_period = cpu_to_le16(bss_cfg->bg_scan_period);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index dd01c0b4f632..6c6940b503a4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -384,7 +384,7 @@ enum qlink_sta_connect_flags {
 struct qlink_cmd_connect {
 	struct qlink_cmd chdr;
 	__le32 flags;
-	__le16 freq;
+	__le16 channel;
 	__le16 bg_scan_period;
 	u8 bssid[ETH_ALEN];
 	u8 payload[0];
-- 
2.11.0
