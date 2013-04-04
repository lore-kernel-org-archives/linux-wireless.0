Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:21003 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763729Ab3DDUD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 16:03:59 -0400
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 1/3] cfg80211: add get_max_tp() API
Date: Thu, 4 Apr 2013 21:57:20 +0200
Message-ID: <1365105442-31876-1-git-send-email-antonio@open-mesh.com> (sfid-20130404_220402_348503_AFB8ED01)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This new API is aimed to let other modules in the kernel
fetch the maximum throughput value towards a peer over
a given VIF.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 include/net/cfg80211.h | 20 ++++++++++++++++++++
 net/wireless/core.c    | 11 +++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 57870b6..5019f67 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2002,6 +2002,9 @@ struct cfg80211_update_ft_ies_params {
  * @update_ft_ies: Provide updated Fast BSS Transition information to the
  *	driver. If the SME is in the driver/firmware, this information can be
  *	used in building Authentication and Reassociation Request frames.
+ *
+ * @get_max_tp: Get the maximum throughput estimated by the rate control
+ *	algorithm towards a given peer
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2231,6 +2234,9 @@ struct cfg80211_ops {
 					 struct cfg80211_chan_def *chandef);
 	int	(*update_ft_ies)(struct wiphy *wiphy, struct net_device *dev,
 				 struct cfg80211_update_ft_ies_params *ftie);
+
+	int	(*get_max_tp)(struct wireless_dev *wdev, const u8 *peer,
+			      u32 *tp);
 };
 
 /*
@@ -4126,6 +4132,20 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
 				   struct cfg80211_wowlan_wakeup *wakeup,
 				   gfp_t gfp);
 
+/**
+ * cfg80211_get_max_tp - get the maximum estimated throughput towards a peer
+ * @wdev: the wireless device which the peer is connected to
+ * @peer: MAC address of the peer
+ * @tp: output buffer. Will contain the throughput value
+ *
+ * This functions queries the underlaying driver and gets the maximum
+ * estimated throughput towards the given peer. The result is then stored in the
+ * variable pointed by tp
+ *
+ * Return 0 on success or a negative error code otherwise
+ */
+int cfg80211_get_max_tp(struct wireless_dev *wdev, u8 *peer, u32 *tp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 92e3fd4..ae86515 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -854,6 +854,17 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 	wdev->beacon_interval = 0;
 }
 
+int cfg80211_get_max_tp(struct wireless_dev *wdev, u8 *peer, u32 *tp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+
+	if (!rdev->ops->get_max_tp)
+		return -EOPNOTSUPP;
+
+	return rdev->ops->get_max_tp(wdev, peer, tp);
+}
+EXPORT_SYMBOL(cfg80211_get_max_tp);
+
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state,
 					 void *ndev)
-- 
1.8.1.5

