Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32935 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1CIUbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 15:31:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: bloat-devel@lists.bufferbloat.net, me@bobcopeland.com,
	mickflemm@gmail.com, johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 1/3] wireless: add support for ethtool_ops->{get,set}_ringparam
Date: Wed,  9 Mar 2011 15:23:18 -0500
Message-Id: <1299702198-23860-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1299687684-19638-1-git-send-email-linville@tuxdriver.com>
References: <1299687684-19638-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/net/cfg80211.h |    8 ++++++++
 net/wireless/ethtool.c |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1ac5786..60f7876 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1197,6 +1197,10 @@ struct cfg80211_pmksa {
  *	(also see nl80211.h @NL80211_ATTR_WIPHY_ANTENNA_TX).
  *
  * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
+ *
+ * @set_ringparam: Set tx and rx ring sizes.
+ *
+ * @get_ringparam: Get tx and rx ring current and maximum sizes.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -1364,6 +1368,10 @@ struct cfg80211_ops {
 
 	int	(*set_antenna)(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant);
 	int	(*get_antenna)(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant);
+
+	int	(*set_ringparam)(struct wiphy *wiphy, u32 tx, u32 rx);
+	void	(*get_ringparam)(struct wiphy *wiphy,
+				 u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
 };
 
 /*
diff --git a/net/wireless/ethtool.c b/net/wireless/ethtool.c
index ca4c825..9bde4d1 100644
--- a/net/wireless/ethtool.c
+++ b/net/wireless/ethtool.c
@@ -1,5 +1,6 @@
 #include <linux/utsname.h>
 #include <net/cfg80211.h>
+#include "core.h"
 #include "ethtool.h"
 
 static void cfg80211_get_drvinfo(struct net_device *dev,
@@ -37,9 +38,41 @@ static void cfg80211_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 	regs->len = 0;
 }
 
+static void cfg80211_get_ringparam(struct net_device *dev,
+				   struct ethtool_ringparam *rp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+
+	memset(rp, 0, sizeof(*rp));
+
+	if (rdev->ops->get_ringparam)
+		rdev->ops->get_ringparam(wdev->wiphy,
+					 &rp->tx_pending, &rp->tx_max_pending,
+					 &rp->rx_pending, &rp->rx_max_pending);
+}
+
+static int cfg80211_set_ringparam(struct net_device *dev,
+				  struct ethtool_ringparam *rp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+
+	if (rp->rx_mini_pending != 0 || rp->rx_jumbo_pending != 0)
+		return -EINVAL;
+
+	if (rdev->ops->set_ringparam)
+		return rdev->ops->set_ringparam(wdev->wiphy,
+						rp->tx_pending, rp->rx_pending);
+
+	return -ENOTSUPP;
+}
+
 const struct ethtool_ops cfg80211_ethtool_ops = {
 	.get_drvinfo = cfg80211_get_drvinfo,
 	.get_regs_len = cfg80211_get_regs_len,
 	.get_regs = cfg80211_get_regs,
 	.get_link = ethtool_op_get_link,
+	.get_ringparam = cfg80211_get_ringparam,
+	.set_ringparam = cfg80211_set_ringparam,
 };
-- 
1.7.4

