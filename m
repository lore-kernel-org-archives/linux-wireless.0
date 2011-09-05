Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4714 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab1IEOja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 10:39:30 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 3/4] ath6kl: Allow AP mode to be configured
Date: Mon, 5 Sep 2011 17:38:46 +0300
Message-ID: <1315233527-6234-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20110905_163932_392856_10422334)
In-Reply-To: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com>
References: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 1fe55f6..6405696 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1221,6 +1221,9 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 	case NL80211_IFTYPE_ADHOC:
 		ar->next_mode = ADHOC_NETWORK;
 		break;
+	case NL80211_IFTYPE_AP:
+		ar->next_mode = AP_NETWORK;
+		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 		ar->next_mode = INFRA_NETWORK;
 		break;
@@ -1956,7 +1959,7 @@ struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
 	set_wiphy_dev(wdev->wiphy, dev);
 
 	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-	    BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
 	/* max num of ssids that can be probed during scanning */
 	wdev->wiphy->max_scan_ssids = MAX_PROBED_SSID_INDEX;
 	wdev->wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
-- 
1.7.4.1

