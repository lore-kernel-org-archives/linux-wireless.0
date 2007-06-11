Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27069 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbXFKJA5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 05:00:57 -0400
Date: Mon, 11 Jun 2007 16:59:58 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/6] mac80211: Add IEEE80211_ prefix to SET_TSINFO_{} macros
Message-ID: <20070611085957.GA5549@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add IEEE80211_ prefix to SET_TSINFO_{} macros

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 include/linux/ieee80211.h     |   18 +++++++++---------
 net/mac80211/debugfs_netdev.c |    2 +-
 net/mac80211/ieee80211_sta.c  |   20 ++++++++++----------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 00e9f99..31368bc 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -134,15 +134,15 @@ struct ieee80211_ht_additional_info {
 #define IEEE80211_TSINFO_ACK(a)		((a.short1 & 0xC000) >> 14)
 #define IEEE80211_TSINFO_SCHEDULE(a)	((a.byte3 & 0x01) >> 0)
 
-#define SET_TSINFO_TYPE(i, d)		(i.short1 |= (d << 0) & 0x0001)
-#define SET_TSINFO_TSID(i, d)		(i.short1 |= (d << 1) & 0x001E)
-#define SET_TSINFO_DIR(i, d)		(i.short1 |= (d << 5) & 0x0060)
-#define SET_TSINFO_POLICY(i, d)		(i.short1 |= (d << 7) & 0x0180)
-#define SET_TSINFO_AGG(i, d)		(i.short1 |= (d << 9) & 0x0200)
-#define SET_TSINFO_APSD(i, d)		(i.short1 |= (d << 10) & 0x0400)
-#define SET_TSINFO_UP(i, d)		(i.short1 |= (d << 11) & 0x3800)
-#define SET_TSINFO_ACK(i, d)		(i.short1 |= (d << 14) & 0xC000)
-#define SET_TSINFO_SCHEDULE(i, d)	(i.byte3 |= (d << 0) & 0x01)
+#define IEEE80211_SET_TSINFO_TYPE(i, d)		(i.short1 |= (d << 0) & 0x0001)
+#define IEEE80211_SET_TSINFO_TSID(i, d)		(i.short1 |= (d << 1) & 0x001E)
+#define IEEE80211_SET_TSINFO_DIR(i, d)		(i.short1 |= (d << 5) & 0x0060)
+#define IEEE80211_SET_TSINFO_POLICY(i, d)	(i.short1 |= (d << 7) & 0x0180)
+#define IEEE80211_SET_TSINFO_AGG(i, d)		(i.short1 |= (d << 9) & 0x0200)
+#define IEEE80211_SET_TSINFO_APSD(i, d)		(i.short1 |= (d << 10) & 0x0400)
+#define IEEE80211_SET_TSINFO_UP(i, d)		(i.short1 |= (d << 11) & 0x3800)
+#define IEEE80211_SET_TSINFO_ACK(i, d)		(i.short1 |= (d << 14) & 0xC000)
+#define IEEE80211_SET_TSINFO_SCHEDULE(i, d)	(i.byte3 |= (d << 0) & 0x01)
 
 struct ieee80211_ts_info {
 	__le16 short1;
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index b9409ee..7be0d90 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -257,7 +257,7 @@ static ssize_t tsinfo_ ##_name## _write(struct file *file,		\
 		       "[%u, %u]\n",sdata->dev->name,val,min_val,max_val);\
 		return -EINVAL;						\
 	}								\
-	SET_TSINFO_ ##_name (_tspec.ts_info, val);			\
+	IEEE80211_SET_TSINFO_ ##_name (sdata->u.sta.tspec.ts_info, val);\
 	return count;							\
 }									\
 									\
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 9fdd265..fc77345 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -859,11 +859,11 @@ void ieee80211_send_delts(struct net_device *dev,
 	memset(&mgmt->u.action.u.delts.ts_info, 0,
 			sizeof(struct ieee80211_ts_info));
 
-	SET_TSINFO_TSID(tp->ts_info, tsid);
-	SET_TSINFO_DIR(tp->ts_info, direction);
-	SET_TSINFO_POLICY(tp->ts_info, WLAN_TSINFO_EDCA);
-	SET_TSINFO_APSD(tp->ts_info, WLAN_TSINFO_PSB_LEGACY);
-	SET_TSINFO_UP(tp->ts_info, ifsta->ts_data[tsid][index].up);
+	IEEE80211_SET_TSINFO_TSID(tp->ts_info, tsid);
+	IEEE80211_SET_TSINFO_DIR(tp->ts_info, direction);
+	IEEE80211_SET_TSINFO_POLICY(tp->ts_info, WLAN_TSINFO_EDCA);
+	IEEE80211_SET_TSINFO_APSD(tp->ts_info, WLAN_TSINFO_PSB_LEGACY);
+	IEEE80211_SET_TSINFO_UP(tp->ts_info, ifsta->ts_data[tsid][index].up);
 
 	ieee80211_sta_tx(dev, skb, 0);
 }
@@ -930,11 +930,11 @@ void wmm_send_delts(struct net_device *dev,
 	tspec = (struct ieee80211_elem_tspec *)pos;
 	memset(tspec, 0, sizeof(*tspec));
 
-	SET_TSINFO_TSID(tspec->ts_info, tsid);
-	SET_TSINFO_DIR(tspec->ts_info, direction);
-	SET_TSINFO_POLICY(tspec->ts_info, WLAN_TSINFO_EDCA);
-	SET_TSINFO_APSD(tspec->ts_info, WLAN_TSINFO_PSB_LEGACY);
-	SET_TSINFO_UP(tspec->ts_info, ifsta->ts_data[tsid][index].up);
+	IEEE80211_SET_TSINFO_TSID(tspec->ts_info, tsid);
+	IEEE80211_SET_TSINFO_DIR(tspec->ts_info, direction);
+	IEEE80211_SET_TSINFO_POLICY(tspec->ts_info, WLAN_TSINFO_EDCA);
+	IEEE80211_SET_TSINFO_APSD(tspec->ts_info, WLAN_TSINFO_PSB_LEGACY);
+	IEEE80211_SET_TSINFO_UP(tspec->ts_info, ifsta->ts_data[tsid][index].up);
 
 	ieee80211_sta_tx(dev, skb, 0);
 }
-- 
1.5.0.rc2.g73a2
