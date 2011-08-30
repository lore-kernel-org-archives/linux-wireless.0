Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5483 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab1H3TDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:03:37 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 15/22] ath6kl: Advertise supported mgmt_stypes
Date: Tue, 30 Aug 2011 21:58:04 +0300
Message-ID: <1314730691-12089-16-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210340_477958_2B746499)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6033959..2d44397 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1758,6 +1758,28 @@ static void ath6kl_mgmt_frame_register(struct wiphy *wiphy,
 	}
 }
 
+static const struct ieee80211_txrx_stypes
+ath6kl_mgmt_stypes[NUM_NL80211_IFTYPES] = {
+	[NL80211_IFTYPE_STATION] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_P2P_CLIENT] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_P2P_GO] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+};
+
 static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.change_virtual_intf = ath6kl_cfg80211_change_iface,
 	.scan = ath6kl_cfg80211_scan,
@@ -1810,6 +1832,8 @@ struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
 		return NULL;
 	}
 
+	wdev->wiphy->mgmt_stypes = ath6kl_mgmt_stypes;
+
 	wdev->wiphy->max_remain_on_channel_duration = 5000;
 
 	/* set device pointer for wiphy */
-- 
1.7.4.1

