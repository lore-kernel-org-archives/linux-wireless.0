Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49393 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1HYLXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 07:23:40 -0400
Received: by wwf5 with SMTP id 5so2258797wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 04:23:39 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/3] nl80211/cfg80211: add STA WME parameters
Date: Thu, 25 Aug 2011 14:24:53 +0300
Message-Id: <1314271494-8756-2-git-send-email-eliad@wizery.com> (sfid-20110825_132349_576682_0FD51052)
In-Reply-To: <1314271494-8756-1-git-send-email-eliad@wizery.com>
References: <1314271494-8756-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new NL80211_ATTR_STA_WME nested attribute that contains
wme params needed by the low-level driver (uapsd_queues and
max_sp).

Add these params to the station_parameters struct as well.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: consider WIPHY_FLAG_AP_UAPSD before parsing wme params.

 include/linux/nl80211.h |   21 +++++++++++++++++++++
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |   28 ++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 075497e..6e2ff33 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1044,6 +1044,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_SUPPORT_AP_UAPSD: the device supports uapsd when working
  *	as AP.
+ * @NL80211_ATTR_STA_WME: Nested attribute containing the wme configuration
+ *	of the station, see &enum nl80211_sta_wme_attr.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1256,6 +1258,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_IE_ASSOC_RESP,
 
 	NL80211_ATTR_SUPPORT_AP_UAPSD,
+	NL80211_ATTR_STA_WME,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -2487,4 +2490,22 @@ enum nl80211_hidden_ssid {
 	NL80211_HIDDEN_SSID_ZERO_CONTENTS
 };
 
+/**
+ * enum nl80211_sta_wme_attr - station WME attributes
+ * @__NL80211_STA_WME_INVALID: invalid number for nested attribute
+ * @NL80211_STA_WME_QUEUES: bitmap of uapsd queues.
+ * @NL80211_STA_WME_MAX_SP: max service period.
+ * @__NL80211_STA_WME_AFTER_LAST: internal
+ * @NL80211_STA_WME_MAX: highest station WME attribute
+ */
+enum nl80211_sta_wme_attr {
+	__NL80211_STA_WME_INVALID,
+	NL80211_STA_WME_UAPSD_QUEUES,
+	NL80211_STA_WME_MAX_SP,
+
+	/* keep last */
+	__NL80211_STA_WME_AFTER_LAST,
+	NL80211_STA_WME_MAX = __NL80211_STA_WME_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 707f95d..9818a84 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -452,6 +452,8 @@ struct station_parameters {
 	u8 plink_action;
 	u8 plink_state;
 	struct ieee80211_ht_cap *ht_capa;
+	u8 uapsd_queues;
+	u8 max_sp;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a1854ec..6ea9ffe 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2547,6 +2547,12 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static struct nla_policy
+nl80211_sta_wme_policy[NL80211_STA_WME_MAX + 1] __read_mostly = {
+	[NL80211_STA_WME_UAPSD_QUEUES] = { .type = NLA_U8 },
+	[NL80211_STA_WME_MAX_SP] = { .type = NLA_U8 },
+};
+
 static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -2592,6 +2598,28 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (parse_station_flags(info, &params))
 		return -EINVAL;
 
+	/* parse WME attributes if sta is WME capable */
+	if ((rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) &&
+	    (params.sta_flags_set & NL80211_STA_FLAG_WME) &&
+	    info->attrs[NL80211_ATTR_STA_WME]) {
+		struct nlattr *tb[NL80211_STA_WME_MAX + 1];
+		struct nlattr *nla;
+
+		nla = info->attrs[NL80211_ATTR_STA_WME];
+		err = nla_parse_nested(tb, NL80211_STA_WME_MAX, nla,
+				       nl80211_sta_wme_policy);
+		if (err)
+			return err;
+
+		if (tb[NL80211_STA_WME_UAPSD_QUEUES])
+			params.uapsd_queues =
+			     nla_get_u8(tb[NL80211_STA_WME_UAPSD_QUEUES]);
+
+		if (tb[NL80211_STA_WME_MAX_SP])
+			params.max_sp =
+			     nla_get_u8(tb[NL80211_STA_WME_MAX_SP]);
+	}
+
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
-- 
1.7.6.401.g6a319

