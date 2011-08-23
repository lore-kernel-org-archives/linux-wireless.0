Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48637 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab1HWLgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 07:36:37 -0400
Received: by fxh19 with SMTP id 19so173569fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 04:36:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] nl80211/cfg80211: add STA WME parameters
Date: Tue, 23 Aug 2011 14:37:46 +0300
Message-Id: <1314099467-20464-1-git-send-email-eliad@wizery.com> (sfid-20110823_133639_735226_8F215362)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new NL80211_ATTR_STA_WME nested attribute that contains
wme params needed by the low-level driver (uapsd_queues and
max_sp).

Add these params to the station_parameters struct as well.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/linux/nl80211.h |   23 +++++++++++++++++++++++
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |   27 +++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 89dec16..aa85eab 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1042,6 +1042,9 @@ enum nl80211_commands {
  *	(Re)Association Response frames when the driver (or firmware) replies to
  *	(Re)Association Request frames.
  *
+ * @NL80211_ATTR_STA_WME: Nested attribute containing the wme configuration
+ *	of the station, see &enum nl80211_sta_wme_attr.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1252,6 +1255,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_IE_PROBE_RESP,
 	NL80211_ATTR_IE_ASSOC_RESP,
 
+	NL80211_ATTR_STA_WME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2473,4 +2478,22 @@ enum nl80211_hidden_ssid {
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
index d86a15d..d32c05f 100644
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
index 2aa6a21..5e7c290 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2545,6 +2545,12 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
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
@@ -2590,6 +2596,27 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (parse_station_flags(info, &params))
 		return -EINVAL;
 
+	/* parse WME attributes if sta is WME capable */
+	if ((params.sta_flags_set & NL80211_STA_FLAG_WME) &&
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

