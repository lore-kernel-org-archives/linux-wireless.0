Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:40119 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751938Ab0LFDpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Dec 2010 22:45:34 -0500
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0511797131
	for <linux-wireless@vger.kernel.org>; Mon,  6 Dec 2010 12:45:32 +0900 (JST)
Subject: [PATCH 1/3] cfg80211: Add antenna availability information
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Dec 2010 12:45:29 +0900
Message-ID: <20101206034529.11462.48097.stgit@localhost6.localdomain6>
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

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 include/net/cfg80211.h |    5 +++++
 net/wireless/nl80211.c |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 589c4b1..d0d4af8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1442,6 +1442,9 @@ struct ieee80211_txrx_stypes {
  * @mgmt_stypes: bitmasks of frame subtypes that can be subscribed to or
  *	transmitted through nl80211, points to an array indexed by interface
  *	type
+ *
+ * @available_antennas: bitmap of antennas which are available to configure.
+ *	antenna configuration commands will be rejected unless this is set.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1481,6 +1484,8 @@ struct wiphy {
 
 	u8 max_num_pmkids;
 
+	u32 available_antennas;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 45fe06d..4854df9 100644
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
@@ -1044,7 +1044,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
 	    info->attrs[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
 		u32 tx_ant, rx_ant;
-		if (!rdev->ops->set_antenna) {
+		if (!rdev->wiphy.available_antennas || !rdev->ops->set_antenna) {
 			result = -EOPNOTSUPP;
 			goto bad_res;
 		}

