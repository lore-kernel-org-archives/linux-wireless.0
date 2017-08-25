Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754438AbdHYCbB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:31:01 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 16/27] qtnfmac: stop using private driver info about current channel
Date: Thu, 24 Aug 2017 19:30:13 -0700
Message-Id: <20170825023024.10565-17-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043142_663895_749BC74F)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Linux Wireless device structure already has required info.
Since driver's info is not used anymore, remove it.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 7 ++-----
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 1 -
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 2 --
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 8542c16..5ee3345 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -630,15 +630,15 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 		 int idx, struct survey_info *survey)
 {
 	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct ieee80211_supported_band *sband;
-	struct cfg80211_chan_def *chandef;
+	const struct cfg80211_chan_def *chandef = &wdev->chandef;
 	struct ieee80211_channel *chan;
 	struct qtnf_chan_stats stats;
 	struct qtnf_vif *vif;
 	int ret;
 
 	vif = qtnf_netdev_get_priv(dev);
-	chandef = &mac->chandef;
 
 	sband = wiphy->bands[NL80211_BAND_2GHZ];
 	if (sband && idx >= sband->n_channels) {
@@ -705,7 +705,6 @@ static int
 qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 		 struct cfg80211_chan_def *chandef)
 {
-	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct net_device *ndev = wdev->netdev;
 	struct qtnf_vif *vif;
 	int ret;
@@ -727,8 +726,6 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 		ret = -ENODATA;
 	}
 
-	memcpy(&mac->chandef, chandef, sizeof(mac->chandef));
-
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 5234a9e..44a2cbb 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -126,7 +126,6 @@ struct qtnf_wmac {
 	struct qtnf_mac_info macinfo;
 	struct qtnf_vif iflist[QTNF_MAX_INTF];
 	struct cfg80211_scan_request *scan_req;
-	struct cfg80211_chan_def chandef;
 	struct mutex mac_lock;	/* lock during wmac speicific ops */
 	struct timer_list scan_timeout;
 };
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index db7e475..9befc9f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -368,8 +368,6 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 		 mac->macid, chdef.chan->hw_value, chdef.center_freq1,
 		 chdef.center_freq2, chdef.width);
 
-	memcpy(&mac->chandef, &chdef, sizeof(mac->chandef));
-
 	for (i = 0; i < QTNF_MAX_INTF; i++) {
 		vif = &mac->iflist[i];
 		if (vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)
-- 
2.9.5
