Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33093 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1J1WVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 18:21:31 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [wireless-next PATCH v2 2/4] wifi: Support disabling ht40.
Date: Fri, 28 Oct 2011 15:21:12 -0700
Message-Id: <1319840474-2618-2-git-send-email-greearb@candelatech.com> (sfid-20111029_002134_922694_AE4482C2)
In-Reply-To: <1319840474-2618-1-git-send-email-greearb@candelatech.com>
References: <1319840474-2618-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Allows users to forceably disable HT40 support in station
interfaces.

Other interface types may be supported later.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

* Tweaked patch description, no other significant changes.

:100644 100644 8a317c9... 9f50f90... M	include/linux/nl80211.h
:100644 100644 1331a5b... 9d7a5e0... M	include/net/cfg80211.h
:100644 100644 8221a3a... c63d7f0... M	net/mac80211/cfg.c
:100644 100644 72c6726... f4a7618... M	net/mac80211/ieee80211_i.h
:100644 100644 393b480... 164cdb1... M	net/mac80211/mlme.c
:100644 100644 db24d25... 404378d... M	net/wireless/nl80211.c
 include/linux/nl80211.h    |    4 ++++
 include/net/cfg80211.h     |    2 ++
 net/mac80211/cfg.c         |    3 +++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    1 +
 net/wireless/nl80211.c     |    7 +++++++
 6 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 8a317c9..9f50f90 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1111,6 +1111,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_DISABLE_HT:  Force /n capable interfaces to instead
  *      function as /a/b/g interfaces.
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
index 1331a5b..9d7a5e0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -255,10 +255,12 @@ struct ieee80211_supported_band {
  * struct vif_params - describes virtual interface parameters
  * @use_4addr: use 4-address frames
  * @disable_11n:  Don't use 11n features (HT, etc)
+ * @disable_ht40:  Don't use HT40, even if hardware & AP support it.
  */
 struct vif_params {
 	int use_4addr;
 	int disable_11n;
+	int disable_ht40;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8221a3a..c63d7f0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -60,6 +60,9 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 	if (params->disable_11n != -1)
 		sdata->cfg_disable_11n = params->disable_11n;
 
+	if (params->disable_ht40 != -1)
+		sdata->cfg_disable_ht40 = params->disable_ht40;
+
 	ret = ieee80211_if_change_type(sdata, type);
 	if (ret)
 		return ret;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 72c6726..f4a7618 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -596,6 +596,7 @@ struct ieee80211_sub_if_data {
 	bool old_idle;
 
 	bool cfg_disable_11n; /* configured to disable 11n? */
+	bool cfg_disable_ht40; /* configured to not use HT-40 */
 
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 393b480..164cdb1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -207,6 +207,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		channel_type = NL80211_CHAN_HT20;
 
 		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+		    !sdata->cfg_disable_ht40 &&
 		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
 		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
 			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index db24d25..404378d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1648,6 +1648,13 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		params.disable_11n = -1;
 	}
 
+	if (info->attrs[NL80211_ATTR_DISABLE_HT40]) {
+		params.disable_ht40 = !!nla_get_u8(info->attrs[NL80211_ATTR_DISABLE_HT40]);
+		change = true;
+	} else {
+		params.disable_ht40 = -1;
+	}
+
 	if (change)
 		err = cfg80211_change_iface(rdev, dev, ntype, flags, &params);
 	else
-- 
1.7.3.4

