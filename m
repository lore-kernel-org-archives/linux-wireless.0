Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29095 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYIXGC1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 02:02:27 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] iwl3945: added channel sysfs entry
Date: Wed, 24 Sep 2008 13:57:45 +0800
Message-Id: <1222235866-19805-1-git-send-email-yi.zhu@intel.com> (sfid-20080924_080231_170139_3D180880)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The patch adds channels sysfs entry for iwl3945. Make it consistent
with iwlagn.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   56 ++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 62b26be..cf41edf 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7666,8 +7666,60 @@ static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
 static ssize_t show_channels(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
-	/* all this shit doesn't belong into sysfs anyway */
-	return 0;
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	struct ieee80211_channel *channels = NULL;
+	const struct ieee80211_supported_band *supp_band = NULL;
+	int len = 0, i;
+	int count = 0;
+
+	if (!test_bit(STATUS_GEO_CONFIGURED, &priv->status))
+		return -EAGAIN;
+
+	supp_band = iwl3945_get_band(priv, IEEE80211_BAND_2GHZ);
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
+	supp_band = iwl3945_get_band(priv, IEEE80211_BAND_5GHZ);
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
+	return len;
 }
 
 static DEVICE_ATTR(channels, S_IRUSR, show_channels, NULL);
-- 
1.5.3.6

