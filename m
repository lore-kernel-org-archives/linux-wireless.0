Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:9477 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaJJRzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 13:55:44 -0400
Date: Fri, 10 Oct 2014 20:55:25 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] cfg80211: Specify frame and reason code for
 NL80211_CMD_DEL_STATION
Message-ID: <20141010175525.GA29436@jouni.qca.qualcomm.com> (sfid-20141010_195550_162474_5AD3E441)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The optional NL80211_ATTR_MGMT_SUBTYPE and NL80211_ATTR_REASON_CODE
attributes can now be included in NL80211_CMD_DEL_STATION to indicate to
the driver which frame (Deauthentication/Disassociation) and reason code
in that frame should be used to indicate removal to the specific
station. This is used by drivers that implement AP SME and generate
those frames internally.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       |  6 ++++++
 include/uapi/linux/nl80211.h |  6 +++++-
 net/wireless/nl80211.c       | 15 +++++++++++++++
 net/wireless/trace.h         | 10 ++++++++--
 4 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 777e191..592e2dc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -804,9 +804,15 @@ struct station_parameters {
  * Used to delete a station entry (or all stations).
  *
  * @mac: MAC address of the station to remove or NULL to remove all stations
+ * @subtype: Management frame subtype to use for indicating removal
+ *	(0 = no guidance on whether to indicate the removal to the station is
+ *	provided, 10 = Disassociation, 12 = Deauthentication)
+ * @reason_code: Reason code for the Disassociation/Deauthentication frame
  */
 struct station_del_parameters {
 	const u8 *mac;
+	u8 subtype;
+	u16 reason_code;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 4b28dc0..07ef683 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -227,7 +227,11 @@
  *	the interface identified by %NL80211_ATTR_IFINDEX.
  * @NL80211_CMD_DEL_STATION: Remove a station identified by %NL80211_ATTR_MAC
  *	or, if no MAC address given, all stations, on the interface identified
- *	by %NL80211_ATTR_IFINDEX.
+ *	by %NL80211_ATTR_IFINDEX. %NL80211_ATTR_MGMT_SUBTYPE and
+ *	%NL80211_ATTR_REASON_CODE can optionally be used to specify which type
+ *	of disconnection indication should be sent to the station
+ *	(Deauthentication or Disassociation frame and reason code for that
+ *	frame).
  *
  * @NL80211_CMD_GET_MPATH: Get mesh path attributes for mesh path to
  * 	destination %NL80211_ATTR_MAC on the interface identified by
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9333990..b88b239 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4414,6 +4414,21 @@ static int nl80211_del_station(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->del_station)
 		return -EOPNOTSUPP;
 
+	if (info->attrs[NL80211_ATTR_MGMT_SUBTYPE]) {
+		params.subtype =
+			nla_get_u8(info->attrs[NL80211_ATTR_MGMT_SUBTYPE]);
+		if (params.subtype != IEEE80211_STYPE_DISASSOC >> 4 &&
+		    params.subtype != IEEE80211_STYPE_DEAUTH >> 4)
+			return -EINVAL;
+	}
+
+	if (info->attrs[NL80211_ATTR_REASON_CODE]) {
+		params.reason_code =
+			nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
+		if (params.reason_code == 0)
+			return -EINVAL; /* 0 is reserved */
+	}
+
 	return rdev_del_station(rdev, dev, &params);
 }
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 66bc3c9..fae55cd 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -688,14 +688,20 @@ DECLARE_EVENT_CLASS(station_del,
 		WIPHY_ENTRY
 		NETDEV_ENTRY
 		MAC_ENTRY(sta_mac)
+		__field(u8, subtype)
+		__field(u16, reason_code)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		NETDEV_ASSIGN;
 		MAC_ASSIGN(sta_mac, params->mac);
+		__entry->subtype = params->subtype;
+		__entry->reason_code = params->reason_code;
 	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", station mac: " MAC_PR_FMT,
-		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(sta_mac))
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", station mac: " MAC_PR_FMT
+		  ", subtype: %u, reason_code: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(sta_mac),
+		  __entry->subtype, __entry->reason_code)
 );
 
 DEFINE_EVENT(station_del, rdev_del_station,
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
