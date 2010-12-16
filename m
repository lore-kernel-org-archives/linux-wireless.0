Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:7434 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755148Ab0LPC3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 21:29:42 -0500
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0696256579
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:29:40 +0900 (JST)
Subject: [PATCH 1/3] cfg80211: Separate available antennas for RX and TX
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: dhalperi@cs.washington.edu, linux-wireless@vger.kernel.org
Date: Thu, 16 Dec 2010 11:30:22 +0900
Message-ID: <20101216023022.24356.22416.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As has been pointed out by Daniel Halperin some devices (e.g. Intel IWL5100)
can only TX from a subset of RX antennas, so use separate availability masks
for RX and TX.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 include/net/cfg80211.h |   12 +++++++++---
 net/wireless/nl80211.c |   17 ++++++++++-------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f45e15f..4d410f3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1472,8 +1472,13 @@ struct ieee80211_txrx_stypes {
  *	transmitted through nl80211, points to an array indexed by interface
  *	type
  *
- * @available_antennas: bitmap of antennas which are available to configure.
- *	antenna configuration commands will be rejected unless this is set.
+ * @available_antennas_tx: bitmap of antennas which are available to be
+ *	configured as TX antennas. Antenna configuration commands will be
+ *	rejected unless this or @available_antennas_rx is set.
+ *
+ * @available_antennas_rx: bitmap of antennas which are available to be
+ *	configured as RX antennas. Antenna configuration commands will be
+ *	rejected unless this or @available_antennas_tx is set.
  *
  * @max_remain_on_channel_duration: Maximum time a remain-on-channel operation
  *	may request, if implemented.
@@ -1518,7 +1523,8 @@ struct wiphy {
 
 	u8 max_num_pmkids;
 
-	u32 available_antennas;
+	u32 available_antennas_tx;
+	u32 available_antennas_rx;
 
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 594a6ac..087397b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -605,7 +605,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	if (dev->wiphy.flags & WIPHY_FLAG_CONTROL_PORT_PROTOCOL)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_CONTROL_PORT_ETHERTYPE);
 
-	if (dev->wiphy.available_antennas && dev->ops->get_antenna) {
+	if ((dev->wiphy.available_antennas_tx ||
+	     dev->wiphy.available_antennas_rx) && dev->ops->get_antenna) {
 		u32 tx_ant = 0, rx_ant = 0;
 		int res;
 		res = dev->ops->get_antenna(&dev->wiphy, &tx_ant, &rx_ant);
@@ -1107,7 +1108,9 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
 	    info->attrs[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
 		u32 tx_ant, rx_ant;
-		if (!rdev->wiphy.available_antennas || !rdev->ops->set_antenna) {
+		if ((!rdev->wiphy.available_antennas_tx &&
+		     !rdev->wiphy.available_antennas_rx) ||
+		    !rdev->ops->set_antenna) {
 			result = -EOPNOTSUPP;
 			goto bad_res;
 		}
@@ -1116,15 +1119,15 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		rx_ant = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_ANTENNA_RX]);
 
 		/* reject antenna configurations which don't match the
-		 * available antenna mask, except for the "all" mask */
-		if ((~tx_ant && (tx_ant & ~rdev->wiphy.available_antennas)) ||
-		    (~rx_ant && (rx_ant & ~rdev->wiphy.available_antennas))) {
+		 * available antenna masks, except for the "all" mask */
+		if ((~tx_ant && (tx_ant & ~rdev->wiphy.available_antennas_tx)) ||
+		    (~rx_ant && (rx_ant & ~rdev->wiphy.available_antennas_rx))) {
 			result = -EINVAL;
 			goto bad_res;
 		}
 
-		tx_ant = tx_ant & rdev->wiphy.available_antennas;
-		rx_ant = rx_ant & rdev->wiphy.available_antennas;
+		tx_ant = tx_ant & rdev->wiphy.available_antennas_tx;
+		rx_ant = rx_ant & rdev->wiphy.available_antennas_rx;
 
 		result = rdev->ops->set_antenna(&rdev->wiphy, tx_ant, rx_ant);
 		if (result)

