Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25549 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358AbZEVRzW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 13:55:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/10] iwlwifi: check for valid band for channel info
Date: Fri, 22 May 2009 11:01:55 -0700
Message-Id: <1243015315-13848-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1243015315-13848-10-git-send-email-reinette.chatre@intel.com>
References: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-2-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-3-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-4-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-5-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-6-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-7-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-8-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-9-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

when display channel info in debugfs, always check for valid band
before access the pointer and display information

for 1000 NIC, it only support "bgn" mode, so there is no 5.2GHz channels
available to display.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   79 ++++++++++++++-------------
 1 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 03006c6..af70229 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -380,50 +380,53 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 	}
 
 	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_2GHZ);
-	channels = supp_band->channels;
+	if (supp_band) {
+		channels = supp_band->channels;
 
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"Displaying %d channels in 2.4GHz band 802.11bg):\n",
-			 supp_band->n_channels);
-
-	for (i = 0; i < supp_band->n_channels; i++)
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"%d: %ddBm: BSS%s%s, %s.\n",
-				ieee80211_frequency_to_channel(
-				channels[i].center_freq),
-				channels[i].max_power,
-				channels[i].flags & IEEE80211_CHAN_RADAR ?
-				" (IEEE 802.11h required)" : "",
-				((channels[i].flags & IEEE80211_CHAN_NO_IBSS)
-				|| (channels[i].flags &
-				IEEE80211_CHAN_RADAR)) ? "" :
-				", IBSS",
-				channels[i].flags &
-				IEEE80211_CHAN_PASSIVE_SCAN ?
-				"passive only" : "active/passive");
+				"Displaying %d channels in 2.4GHz band 802.11bg):\n",
+				supp_band->n_channels);
 
+		for (i = 0; i < supp_band->n_channels; i++)
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"%d: %ddBm: BSS%s%s, %s.\n",
+					ieee80211_frequency_to_channel(
+					channels[i].center_freq),
+					channels[i].max_power,
+					channels[i].flags & IEEE80211_CHAN_RADAR ?
+					" (IEEE 802.11h required)" : "",
+					((channels[i].flags & IEEE80211_CHAN_NO_IBSS)
+					|| (channels[i].flags &
+					IEEE80211_CHAN_RADAR)) ? "" :
+					", IBSS",
+					channels[i].flags &
+					IEEE80211_CHAN_PASSIVE_SCAN ?
+					"passive only" : "active/passive");
+	}
 	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_5GHZ);
-	channels = supp_band->channels;
+	if (supp_band) {
+		channels = supp_band->channels;
 
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"Displaying %d channels in 5.2GHz band (802.11a)\n",
-			supp_band->n_channels);
-
-	for (i = 0; i < supp_band->n_channels; i++)
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"%d: %ddBm: BSS%s%s, %s.\n",
-				ieee80211_frequency_to_channel(
-				channels[i].center_freq),
-				channels[i].max_power,
-				channels[i].flags & IEEE80211_CHAN_RADAR ?
-				" (IEEE 802.11h required)" : "",
-				((channels[i].flags & IEEE80211_CHAN_NO_IBSS)
-				|| (channels[i].flags &
-				IEEE80211_CHAN_RADAR)) ? "" :
-				", IBSS",
-				channels[i].flags &
-				IEEE80211_CHAN_PASSIVE_SCAN ?
-				"passive only" : "active/passive");
+				"Displaying %d channels in 5.2GHz band (802.11a)\n",
+				supp_band->n_channels);
+
+		for (i = 0; i < supp_band->n_channels; i++)
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"%d: %ddBm: BSS%s%s, %s.\n",
+					ieee80211_frequency_to_channel(
+					channels[i].center_freq),
+					channels[i].max_power,
+					channels[i].flags & IEEE80211_CHAN_RADAR ?
+					" (IEEE 802.11h required)" : "",
+					((channels[i].flags & IEEE80211_CHAN_NO_IBSS)
+					|| (channels[i].flags &
+					IEEE80211_CHAN_RADAR)) ? "" :
+					", IBSS",
+					channels[i].flags &
+					IEEE80211_CHAN_PASSIVE_SCAN ?
+					"passive only" : "active/passive");
+	}
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
-- 
1.5.6.3

