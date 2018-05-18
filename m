Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:39374 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbeERJrq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:47:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] cfg80211: release station info tidstats where needed
Date: Fri, 18 May 2018 11:47:42 +0200
Message-Id: <20180518094742.10669-2-johannes@sipsolutions.net> (sfid-20180518_114804_035410_760F1375)
In-Reply-To: <20180518094742.10669-1-johannes@sipsolutions.net>
References: <20180518094742.10669-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This fixes memory leaks in cases where we got the station
info but failed sending it out properly.

Fixes: 8689c051a201 ("cfg80211: dynamically allocate per-tid stats for station info")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 13 +++++++++++++
 net/wireless/nl80211.c | 11 ++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8984d24d68b7..1c6364591856 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5710,6 +5710,19 @@ void cfg80211_remain_on_channel_expired(struct wireless_dev *wdev, u64 cookie,
  */
 int cfg80211_sinfo_alloc_tid_stats(struct station_info *sinfo, gfp_t gfp);
 
+/**
+ * cfg80211_sinfo_release_sinfo - release contents of station info
+ * @sinfo: the station information
+ *
+ * Releases any potentially allocated sub-information of the station
+ * information, but not the struct itself (since it's typically on
+ * the stack.)
+ */
+static inline void cfg80211_sinfo_release_sinfo(struct station_info *sinfo)
+{
+	kfree(sinfo->pertid);
+}
+
 /**
  * cfg80211_new_sta - notify userspace about station
  *
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7daceb1f253d..0996fdc002e0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4702,7 +4702,6 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 		}
 
 		nla_nest_end(msg, tidsattr);
-		kfree(sinfo->pertid);
 	}
 
 	nla_nest_end(msg, sinfoattr);
@@ -4712,10 +4711,12 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 		    sinfo->assoc_req_ies))
 		goto nla_put_failure;
 
+	cfg80211_sinfo_release_sinfo(sinfo);
 	genlmsg_end(msg, hdr);
 	return 0;
 
  nla_put_failure:
+	cfg80211_sinfo_release_sinfo(sinfo);
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
 }
@@ -4797,8 +4798,10 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 		return err;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
+	if (!msg) {
+		cfg80211_sinfo_release_sinfo(sinfo);
 		return -ENOMEM;
+	}
 
 	if (nl80211_send_station(msg, NL80211_CMD_NEW_STATION,
 				 info->snd_portid, info->snd_seq, 0,
@@ -14624,8 +14627,10 @@ void cfg80211_del_sta_sinfo(struct net_device *dev, const u8 *mac_addr,
 	trace_cfg80211_del_sta(dev, mac_addr);
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
-	if (!msg)
+	if (!msg) {
+		cfg80211_sinfo_release_sinfo(sinfo);
 		return;
+	}
 
 	if (nl80211_send_station(msg, NL80211_CMD_DEL_STATION, 0, 0, 0,
 				 rdev, dev, mac_addr, sinfo) < 0) {
-- 
2.14.3
