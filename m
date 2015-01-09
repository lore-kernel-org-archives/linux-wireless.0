Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44249 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932668AbbAIMGm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 07:06:42 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri,  9 Jan 2015 14:06:37 +0200
Message-Id: <1420805197-5831-1-git-send-email-luca@coelho.fi> (sfid-20150109_130646_449119_8E5C851A)
Subject: [PATCH] nl80211: send netdetect configuration info in NL80211_CMD_GET_WOWLAN
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Send the netdetect configuration information in the response to
NL8021_CMD_GET_WOWLAN commands.  This includes the scan interval,
SSIDs to match and frequencies to scan.

Additionally, add the NL80211_WOWLAN_TRIG_NET_DETECT with
NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/uapi/linux/nl80211.h |  4 +++-
 net/wireless/nl80211.c       | 52 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index a963d48..b6c1a00 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3734,7 +3734,9 @@ struct nl80211_pattern_support {
  *	same attributes used with @NL80211_CMD_START_SCHED_SCAN.  It
  *	specifies how the scan is performed (e.g. the interval and the
  *	channels to scan) as well as the scan results that will
- *	trigger a wake (i.e. the matchsets).
+ *	trigger a wake (i.e. the matchsets).  This attribute is also
+ *	sent in a response to @NL80211_CMD_GET_WIPHY, indicating the
+ *	number of match sets supported by the driver (u32).
  * @NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS: nested attribute
  *	containing an array with information about what triggered the
  *	wake up.  If no elements are present in the array, it means
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7c2ce26..38078437 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1088,6 +1088,11 @@ static int nl80211_send_wowlan(struct sk_buff *msg,
 			return -ENOBUFS;
 	}
 
+	if ((rdev->wiphy.wowlan->flags & WIPHY_WOWLAN_NET_DETECT) &&
+	    nla_put_u32(msg, NL80211_WOWLAN_TRIG_NET_DETECT,
+			rdev->wiphy.wowlan->max_nd_match_sets))
+		return -ENOBUFS;
+
 	if (large && nl80211_send_wowlan_tcp_caps(rdev, msg))
 		return -ENOBUFS;
 
@@ -8747,6 +8752,48 @@ static int nl80211_send_wowlan_tcp(struct sk_buff *msg,
 	return 0;
 }
 
+static int nl80211_send_wowlan_nd(struct sk_buff *msg,
+				  struct cfg80211_sched_scan_request *req)
+{
+	struct nlattr *nd, *freqs, *matches, *match;
+	int i;
+
+	if (!req)
+		return 0;
+
+	nd = nla_nest_start(msg, NL80211_WOWLAN_TRIG_NET_DETECT);
+	if (!nd)
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_INTERVAL, req->interval))
+		return -ENOBUFS;
+
+	freqs = nla_nest_start(msg, NL80211_ATTR_SCAN_FREQUENCIES);
+	if (!freqs)
+		return -ENOBUFS;
+
+	for (i = 0; i < req->n_channels; i++)
+		nla_put_u32(msg, i, req->channels[i]->center_freq);
+
+	nla_nest_end(msg, freqs);
+
+	if (req->n_match_sets) {
+		matches = nla_nest_start(msg, NL80211_ATTR_SCHED_SCAN_MATCH);
+		for (i = 0; i < req->n_match_sets; i++) {
+			match = nla_nest_start(msg, i);
+			nla_put(msg, NL80211_SCHED_SCAN_MATCH_ATTR_SSID,
+				req->match_sets[i].ssid.ssid_len,
+				req->match_sets[i].ssid.ssid);
+			nla_nest_end(msg, match);
+		}
+		nla_nest_end(msg, matches);
+	}
+
+	nla_nest_end(msg, nd);
+
+	return 0;
+}
+
 static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -8804,6 +8851,11 @@ static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
 					    rdev->wiphy.wowlan_config->tcp))
 			goto nla_put_failure;
 
+		if (nl80211_send_wowlan_nd(
+			    msg,
+			    rdev->wiphy.wowlan_config->nd_config))
+			goto nla_put_failure;
+
 		nla_nest_end(msg, nl_wowlan);
 	}
 
-- 
2.1.4

