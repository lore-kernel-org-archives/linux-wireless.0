Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21717 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2BPPB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 10:01:58 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [RFC] cfg80211: Add an attribute in NL80211_CMD_SET_INTERFACE for bgscan interval
Date: Thu, 16 Feb 2012 20:31:58 +0530
Message-ID: <1329404518-14063-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120216_160212_412094_E7281C0A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new nl80211 netlink attribute %NL80211_ATTR_BGSCAN_INTERVAL in
NL80211_CMD_SET_INTERFACE is an u16 and has the time interval in
seconds at which the driver has to do the background scanning.
This can be used by drivers which handles the scanning and
roaming functionalities. Setting an interval of 0 may disable
the bgscan.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 include/linux/nl80211.h |   10 +++++++++-
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |   12 ++++++++++++
 3 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index ad56e21..32aaa5d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -134,7 +134,8 @@
  *	either a dump request on a %NL80211_ATTR_WIPHY or a specific get
  *	on an %NL80211_ATTR_IFINDEX is supported.
  * @NL80211_CMD_SET_INTERFACE: Set type of a virtual interface, requires
- *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_IFTYPE.
+ *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_IFTYPE; can be used to
+ *	set %NL80211_ATTR_BGSCAN_INTERVAL.
  * @NL80211_CMD_NEW_INTERFACE: Newly created virtual interface or response
  *	to %NL80211_CMD_GET_INTERFACE. Has %NL80211_ATTR_IFINDEX,
  *	%NL80211_ATTR_WIPHY and %NL80211_ATTR_IFTYPE attributes. Can also
@@ -1193,6 +1194,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
  *      up to 16 TIDs.
  *
+ * @NL80211_ATTR_BGSCAN_INTERVAL: The interval in seconds which can
+ * be used to do background scanning. The drivers which makexs the
+ * roaming decisions can use this interval. A value of 0 is used to
+ * disable the backgound scan.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1438,6 +1444,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NOACK_MAP,
 
+	NL80211_ATTR_BGSCAN_INTERVAL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2964205..e3ea709 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -256,9 +256,11 @@ struct ieee80211_supported_band {
 /**
  * struct vif_params - describes virtual interface parameters
  * @use_4addr: use 4-address frames
+ * @bgscan_intvl: background scan interval in secs., 0 to disable it
  */
 struct vif_params {
        int use_4addr;
+	int bgscan_intvl;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c910b07..d5e835b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -204,6 +204,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 		.len = NL80211_HT_CAPABILITY_LEN
 	},
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
+	[NL80211_ATTR_BGSCAN_INTERVAL] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -1680,6 +1681,17 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		change = true;
 	}
 
+	if (info->attrs[NL80211_ATTR_BGSCAN_INTERVAL]) {
+		if (ntype != NL80211_IFTYPE_STATION &&
+		    ntype != NL80211_IFTYPE_P2P_CLIENT)
+			return -EINVAL;
+		params.bgscan_intvl =
+			nla_get_u16(info->attrs[NL80211_ATTR_BGSCAN_INTERVAL]);
+		change = true;
+	} else {
+		params.bgscan_intvl = -1;
+	}
+
 	if (change)
 		err = cfg80211_change_iface(rdev, dev, ntype, flags, &params);
 	else
-- 
1.7.0.4

