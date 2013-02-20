Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab3BTKgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 05:36:32 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] nl80211: conditionally add back TCP WoWLAN information
Date: Wed, 20 Feb 2013 11:36:26 +0100
Message-Id: <1361356586-11496-4-git-send-email-johannes@sipsolutions.net> (sfid-20130220_113639_709963_BEB82C25)
In-Reply-To: <1361356586-11496-1-git-send-email-johannes@sipsolutions.net>
References: <1361356586-11496-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add back the previously removed TCP WoWLAN information,
but only if userspace is prepared to deal with large
wiphy capability data dumps.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fa35b07..4701893a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -925,8 +925,49 @@ nla_put_failure:
 }
 
 #ifdef CONFIG_PM
+static int nl80211_send_wowlan_tcp_caps(struct cfg80211_registered_device *rdev,
+					struct sk_buff *msg)
+{
+	const struct wiphy_wowlan_tcp_support *tcp = rdev->wiphy.wowlan.tcp;
+	struct nlattr *nl_tcp;
+
+	if (!tcp)
+		return 0;
+
+	nl_tcp = nla_nest_start(msg, NL80211_WOWLAN_TRIG_TCP_CONNECTION);
+	if (!nl_tcp)
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD,
+			tcp->data_payload_max))
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD,
+			tcp->data_payload_max))
+		return -ENOBUFS;
+
+	if (tcp->seq && nla_put_flag(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD_SEQ))
+		return -ENOBUFS;
+
+	if (tcp->tok && nla_put(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD_TOKEN,
+				sizeof(*tcp->tok), tcp->tok))
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL80211_WOWLAN_TCP_DATA_INTERVAL,
+			tcp->data_interval_max))
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL80211_WOWLAN_TCP_WAKE_PAYLOAD,
+			tcp->wake_payload_max))
+		return -ENOBUFS;
+
+	nla_nest_end(msg, nl_tcp);
+	return 0;
+}
+
 static int nl80211_send_wowlan(struct sk_buff *msg,
-			       struct cfg80211_registered_device *dev)
+			       struct cfg80211_registered_device *dev,
+			       bool large)
 {
 	struct nlattr *nl_wowlan;
 
@@ -968,6 +1009,9 @@ static int nl80211_send_wowlan(struct sk_buff *msg,
 			return -ENOBUFS;
 	}
 
+	if (large && nl80211_send_wowlan_tcp_caps(dev, msg))
+		return -ENOBUFS;
+
 	nla_nest_end(msg, nl_wowlan);
 
 	return 0;
@@ -1404,7 +1448,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			break;
 	case 6:
 #ifdef CONFIG_PM
-		if (nl80211_send_wowlan(msg, dev))
+		if (nl80211_send_wowlan(msg, dev, split))
 			goto nla_put_failure;
 		(*split_start)++;
 		if (split)
-- 
1.8.0

