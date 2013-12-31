Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40864 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab3LaPa4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 10:30:56 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 1/2] cfg80211: Add a function to get the number of enabled channels
Date: Tue, 31 Dec 2013 17:32:25 +0200
Message-Id: <1388503946-25862-2-git-send-email-ilan.peer@intel.com> (sfid-20131231_163059_169890_8384FBE3)
In-Reply-To: <1388503946-25862-1-git-send-email-ilan.peer@intel.com>
References: <1388503946-25862-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a utility function to get the number of channels enabled by
the device.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 include/net/cfg80211.h |    9 +++++++++
 net/wireless/util.c    |   21 +++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 80a1021..405ef5b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4532,6 +4532,15 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
  */
 void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp);
 
+/**
+ * ieee80211_get_num_enabled_channels - get the number of channels supported
+ * and enabled by the device.
+ * @wiphy: the wiphy
+ *
+ * Return: the number of channels supported and enabled by the device.
+ */
+unsigned int ieee80211_get_num_enabled_channels(struct wiphy *wiphy);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 935dea9..fb5f685 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1462,6 +1462,27 @@ int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 	return 0;
 }
 
+unsigned int ieee80211_get_num_enabled_channels(struct wiphy *wiphy)
+{
+	struct ieee80211_supported_band *sband;
+	unsigned int n_channels, i, j;
+
+	for (i = 0, n_channels = 0; i < IEEE80211_NUM_BANDS; i++) {
+		sband = wiphy->bands[i];
+		if (!sband)
+			continue;
+
+		for (j = 0; j < sband->n_channels; j++) {
+			if (!(sband->channels[j].flags &
+			      IEEE80211_CHAN_DISABLED))
+				n_channels++;
+		}
+	}
+
+	return n_channels;
+}
+EXPORT_SYMBOL(ieee80211_get_num_enabled_channels);
+
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
 const unsigned char rfc1042_header[] __aligned(2) =
-- 
1.7.10.4

