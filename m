Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:52980
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751314AbdJEBi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 21:38:26 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 8/8] qtnfmac: do not cache current channel info in driver's state
Date: Wed,  4 Oct 2017 18:38:13 -0700
Message-Id: <20171005013813.13332-9-igor.mitsyanko.os@quantenna.com> (sfid-20171005_033831_246768_D7DC1222)
In-Reply-To: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
References: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Linux Wireless device structure already has current channel
information that can be used when needed. Start using it.
Since driver's channel info is not used anymore, remove it.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 7 ++-----
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 1 -
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 2 --
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index cf0f19ef..028bed1 100644
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
@@ -728,8 +727,6 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
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
index d7fb076..f639ea3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -372,8 +372,6 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 		 mac->macid, chandef.chan->hw_value, chandef.center_freq1,
 		 chandef.center_freq2, chandef.width);
 
-	memcpy(&mac->chandef, &chandef, sizeof(mac->chandef));
-
 	for (i = 0; i < QTNF_MAX_INTF; i++) {
 		vif = &mac->iflist[i];
 		if (vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)
-- 
2.9.5
