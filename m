Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4079 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbYFMHrH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 03:47:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/3] iwlwifi: adding channels to sysfs
Date: Fri, 13 Jun 2008 15:44:53 +0800
Message-Id: <1213343095-8133-2-git-send-email-yi.zhu@intel.com> (sfid-20080613_094711_143440_9808BC8B)
In-Reply-To: <1213343095-8133-1-git-send-email-yi.zhu@intel.com>
References: <1213343095-8133-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ester Kummer <ester.kummer@intel.com>

This patch returns channel list to sysfs.

Signed-off-by: Ester Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   58 ++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 81a1c22..c179b21 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4122,8 +4122,62 @@ static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
 static ssize_t show_channels(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
-	/* all this shit doesn't belong into sysfs anyway */
-	return 0;
+
+	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct ieee80211_channel *channels = NULL;
+	const struct ieee80211_supported_band *supp_band = NULL;
+	int len = 0, i;
+	int count = 0;
+
+	if (!test_bit(STATUS_GEO_CONFIGURED, &priv->status))
+		return -EAGAIN;
+
+	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_2GHZ);
+	channels = supp_band->channels;
+	count = supp_band->n_channels;
+
+	len += sprintf(&buf[len],
+			"Displaying %d channels in 2.4GHz band "
+			"(802.11bg):\n", count);
+
+	for (i = 0; i < count; i++)
+		len += sprintf(&buf[len], "%d: %ddBm: BSS%s%s, %s.\n",
+				ieee80211_frequency_to_channel(
+				channels[i].center_freq),
+				channels[i].max_power,
+				channels[i].flags & IEEE80211_CHAN_RADAR ?
+				" (IEEE 802.11h required)" : "",
+				(!(channels[i].flags & IEEE80211_CHAN_NO_IBSS)
+				|| (channels[i].flags &
+				IEEE80211_CHAN_RADAR)) ? "" :
+				", IBSS",
+				channels[i].flags &
+				IEEE80211_CHAN_PASSIVE_SCAN ?
+				"passive only" : "active/passive");
+
+	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_5GHZ);
+	channels = supp_band->channels;
+	count = supp_band->n_channels;
+
+	len += sprintf(&buf[len], "Displaying %d channels in 5.2GHz band "
+			"(802.11a):\n", count);
+
+	for (i = 0; i < count; i++)
+		len += sprintf(&buf[len], "%d: %ddBm: BSS%s%s, %s.\n",
+				ieee80211_frequency_to_channel(
+				channels[i].center_freq),
+				channels[i].max_power,
+				channels[i].flags & IEEE80211_CHAN_RADAR ?
+				" (IEEE 802.11h required)" : "",
+				((channels[i].flags & IEEE80211_CHAN_NO_IBSS)
+				|| (channels[i].flags &
+				IEEE80211_CHAN_RADAR)) ? "" :
+				", IBSS",
+				channels[i].flags &
+				IEEE80211_CHAN_PASSIVE_SCAN ?
+				"passive only" : "active/passive");
+
+	return len;
 }
 
 static DEVICE_ATTR(channels, S_IRUSR, show_channels, NULL);
-- 
1.5.3.6

