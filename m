Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5026 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1H3TCC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:02:02 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 06/22] ath6kl: Implement remain_on_channel and cancel_remain_on_channel
Date: Tue, 30 Aug 2011 21:57:55 +0300
Message-ID: <1314730691-12089-7-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210206_451157_6E6C449F)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   33 ++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index f7176d2..6745bf2 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1658,6 +1658,35 @@ static int ath6kl_change_station(struct wiphy *wiphy, struct net_device *dev,
 				      0);
 }
 
+static int ath6kl_remain_on_channel(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    struct ieee80211_channel *chan,
+				    enum nl80211_channel_type channel_type,
+				    unsigned int duration,
+				    u64 *cookie)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+
+	/* TODO: if already pending or ongoing remain-on-channel,
+	 * return -EBUSY */
+	*cookie = 1; /* only a single pending request is supported */
+
+	return ath6kl_wmi_remain_on_chnl_cmd(ar->wmi, chan->center_freq,
+					     duration);
+}
+
+static int ath6kl_cancel_remain_on_channel(struct wiphy *wiphy,
+					   struct net_device *dev,
+					   u64 cookie)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+
+	if (cookie != 1)
+		return -ENOENT;
+
+	return ath6kl_wmi_cancel_remain_on_chnl_cmd(ar->wmi);
+}
+
 static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.change_virtual_intf = ath6kl_cfg80211_change_iface,
 	.scan = ath6kl_cfg80211_scan,
@@ -1685,6 +1714,8 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.set_beacon = ath6kl_set_beacon,
 	.del_beacon = ath6kl_del_beacon,
 	.change_station = ath6kl_change_station,
+	.remain_on_channel = ath6kl_remain_on_channel,
+	.cancel_remain_on_channel = ath6kl_cancel_remain_on_channel,
 };
 
 struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
@@ -1706,6 +1737,8 @@ struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
 		return NULL;
 	}
 
+	wdev->wiphy->max_remain_on_channel_duration = 5000;
+
 	/* set device pointer for wiphy */
 	set_wiphy_dev(wdev->wiphy, dev);
 
-- 
1.7.4.1

