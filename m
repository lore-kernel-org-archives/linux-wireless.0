Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:33811 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751815Ab0LHE7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 23:59:55 -0500
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0785284392
	for <linux-wireless@vger.kernel.org>; Wed,  8 Dec 2010 13:59:54 +0900 (JST)
Subject: [PATCH v3] cfg80211: Add antenna availability information
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 08 Dec 2010 13:59:24 +0900
Message-ID: <20101208045924.26586.95364.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a field to wiphy for the hardware to report the availble antennas for
configuration. Only if this is set to something bigger than zero, will the
anntenna configuration ops be executed.

Allthough this could be a simple number of antennas, I defined it as a bitmap
of antennas which are available for configuration, since it's more consistent
with the rest of the antenna API and there could be cases where the
hardware allows only configuration of certain antennas. As it does not make
much of a difference in size or normal usage, I think it's better to be able to
support this, in case the need arises.

The antenna configuration is now also checked against the availabe antennas and
rejected if it does not match.

Signed-off-by: Bruno Randolf <br1@einfach.org>

--
v3:	always apply available antenna mask (for "all" antennas case).

v2:	reject antenna configurations which don't match the available antennas
---
 include/net/cfg80211.h |    5 +++++
 net/wireless/nl80211.c |   15 +++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8764c9a..ef6f15d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1465,6 +1465,9 @@ struct ieee80211_txrx_stypes {
  * @mgmt_stypes: bitmasks of frame subtypes that can be subscribed to or
  *	transmitted through nl80211, points to an array indexed by interface
  *	type
+ *
+ * @available_antennas: bitmap of antennas which are available to configure.
+ *	antenna configuration commands will be rejected unless this is set.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1504,6 +1507,8 @@ struct wiphy {
 
 	u8 max_num_pmkids;
 
+	u32 available_antennas;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2cf0333..5da02bd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -547,7 +547,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	if (dev->wiphy.flags & WIPHY_FLAG_CONTROL_PORT_PROTOCOL)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_CONTROL_PORT_ETHERTYPE);
 
-	if (dev->ops->get_antenna) {
+	if (dev->wiphy.available_antennas && dev->ops->get_antenna) {
 		u32 tx_ant = 0, rx_ant = 0;
 		int res;
 		res = dev->ops->get_antenna(&dev->wiphy, &tx_ant, &rx_ant);
@@ -1045,7 +1045,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
 	    info->attrs[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
 		u32 tx_ant, rx_ant;
-		if (!rdev->ops->set_antenna) {
+		if (!rdev->wiphy.available_antennas || !rdev->ops->set_antenna) {
 			result = -EOPNOTSUPP;
 			goto bad_res;
 		}
@@ -1053,6 +1053,17 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		tx_ant = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_ANTENNA_TX]);
 		rx_ant = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_ANTENNA_RX]);
 
+		/* reject antenna configurations which don't match the
+		 * available antenna mask, except for the "all" mask */
+		if ((~tx_ant && (tx_ant & ~rdev->wiphy.available_antennas)) ||
+		    (~rx_ant && (rx_ant & ~rdev->wiphy.available_antennas))) {
+			result = -EINVAL;
+			goto bad_res;
+		}
+
+		tx_ant = tx_ant & rdev->wiphy.available_antennas;
+		rx_ant = rx_ant & rdev->wiphy.available_antennas;
+
 		result = rdev->ops->set_antenna(&rdev->wiphy, tx_ant, rx_ant);
 		if (result)
 			goto bad_res;

