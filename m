Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46597 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1KCFzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 01:55:37 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 2/3] mac80211: Support disabling ht40.
Date: Wed,  2 Nov 2011 22:55:21 -0700
Message-Id: <1320299722-30113-2-git-send-email-greearb@candelatech.com> (sfid-20111103_065541_391567_435879C5)
In-Reply-To: <1320299722-30113-1-git-send-email-greearb@candelatech.com>
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Allows users to forceably disable HT40 support in station
interfaces.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 499a5a4... 61b45aa... M	include/linux/nl80211.h
:100644 100644 d2168c0... eeeef41... M	include/net/cfg80211.h
:100644 100644 ea10a51... e4cfeda... M	net/mac80211/ieee80211_i.h
:100644 100644 d4092e8... 149fb1d... M	net/mac80211/mlme.c
:100644 100644 3c4dab1... 7924e28... M	net/wireless/nl80211.c
 include/linux/nl80211.h    |    4 ++++
 include/net/cfg80211.h     |    1 +
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    5 +++++
 net/wireless/nl80211.c     |    7 +++++++
 5 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 499a5a4..61b45aa 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1111,6 +1111,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_DISABLE_HT:  Force HT capable interfaces to disable
  *      this feature.
+ * @NL80211_ATTR_DISABLE_HT40:  Disable HT-40 even if AP and hardware
+ *      support it.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1341,6 +1343,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
 
 	NL80211_ATTR_DISABLE_HT,
+	NL80211_ATTR_DISABLE_HT40,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d2168c0..eeeef41 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1036,6 +1036,7 @@ struct cfg80211_auth_request {
 };
 
 #define ASSOC_REQ_DISABLE_HT	(1<<0) /* Disable HT (802.11n) */
+#define ASSOC_REQ_DISABLE_HT40	(1<<1) /* Disable HT40 (802.11n) */
 
 /**
  * struct cfg80211_assoc_request - (Re)Association request data
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ea10a51..e4cfeda 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -364,6 +364,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
 	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
+	IEEE80211_STA_DISABLE_HT40	= BIT(10),
 };
 
 struct ieee80211_if_managed {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d4092e8..149fb1d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -207,6 +207,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		channel_type = NL80211_CHAN_HT20;
 
 		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+		    !(sdata->u.mgd.flags & IEEE80211_STA_DISABLE_HT40) &&
 		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
 		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
 			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
@@ -2601,6 +2602,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
 	ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
+	ifmgd->flags &= ~IEEE80211_STA_DISABLE_HT40;
 
 	ifmgd->beacon_crc_valid = false;
 
@@ -2614,6 +2616,9 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	if (req->flags & ASSOC_REQ_DISABLE_HT)
 		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
+	if (req->flags & ASSOC_REQ_DISABLE_HT40)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_HT40;
+
 	if (req->ie && req->ie_len) {
 		memcpy(wk->ie, req->ie, req->ie_len);
 		wk->ie_len = req->ie_len;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3c4dab1..7924e28 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -198,6 +198,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_TDLS_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TDLS_EXTERNAL_SETUP] = { .type = NLA_FLAG },
 	[NL80211_ATTR_DISABLE_HT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_DISABLE_HT40] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -4402,6 +4403,9 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT]))
 		flags |= ASSOC_REQ_DISABLE_HT;
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT40]))
+		flags |= ASSOC_REQ_DISABLE_HT40;
+
 	err = nl80211_crypto_settings(rdev, info, &crypto, 1);
 	if (!err)
 		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
@@ -4899,6 +4903,9 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT]))
 		connect.flags |= ASSOC_REQ_DISABLE_HT;
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT40]))
+		connect.flags |= ASSOC_REQ_DISABLE_HT40;
+
 	err = cfg80211_connect(rdev, dev, &connect, connkeys);
 	if (err)
 		kfree(connkeys);
-- 
1.7.3.4

