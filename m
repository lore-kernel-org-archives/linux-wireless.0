Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33091 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1J1WVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 18:21:22 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [wireless-next PATCH v2 1/4] mac80211: Support forcing station to disable 11n.
Date: Fri, 28 Oct 2011 15:21:11 -0700
Message-Id: <1319840474-2618-1-git-send-email-greearb@candelatech.com> (sfid-20111029_002128_214854_3ACBE979)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows a user to configure a wifi station interface
to disable 802.11n, even if the AP and NIC supports it.

Other interface types may be supported in the future.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

* Renamed NL80211_ATTR_DISABLE_11N to NL80211_ATTR_DISABLE_HT
* Fix patched description w/regard to 'netlink bits'.
* Didn't add checks for capability bits or nor moved the disable_11n
  flag to u.mgd, pending answers to earlier questions.

:100644 100644 8049bf7... 8a317c9... M	include/linux/nl80211.h
:100644 100644 92cf1c2... 1331a5b... M	include/net/cfg80211.h
:100644 100644 e253afa... 8221a3a... M	net/mac80211/cfg.c
:100644 100644 4c3d1f5... 72c6726... M	net/mac80211/ieee80211_i.h
:100644 100644 0e5d8da... 393b480... M	net/mac80211/mlme.c
:100644 100644 48260c2... db24d25... M	net/wireless/nl80211.c
 include/linux/nl80211.h    |    4 ++++
 include/net/cfg80211.h     |    4 +++-
 net/mac80211/cfg.c         |    3 +++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mlme.c        |    3 +++
 net/wireless/nl80211.c     |    7 +++++++
 6 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 8049bf7..8a317c9 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1109,6 +1109,9 @@ enum nl80211_commands {
  *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver to perform a TDLS operation.
  *
+ * @NL80211_ATTR_DISABLE_HT:  Force /n capable interfaces to instead
+ *      function as /a/b/g interfaces.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1337,6 +1340,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_SUPPORT,
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
 
+	NL80211_ATTR_DISABLE_HT,
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 92cf1c2..1331a5b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -254,9 +254,11 @@ struct ieee80211_supported_band {
 /**
  * struct vif_params - describes virtual interface parameters
  * @use_4addr: use 4-address frames
+ * @disable_11n:  Don't use 11n features (HT, etc)
  */
 struct vif_params {
-       int use_4addr;
+	int use_4addr;
+	int disable_11n;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e253afa..8221a3a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -57,6 +57,9 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int ret;
 
+	if (params->disable_11n != -1)
+		sdata->cfg_disable_11n = params->disable_11n;
+
 	ret = ieee80211_if_change_type(sdata, type);
 	if (ret)
 		return ret;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4c3d1f5..72c6726 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -595,6 +595,8 @@ struct ieee80211_sub_if_data {
 	/* to detect idle changes */
 	bool old_idle;
 
+	bool cfg_disable_11n; /* configured to disable 11n? */
+
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0e5d8da..393b480 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2597,6 +2597,9 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
 
+	if (sdata->cfg_disable_11n)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+
 	if (req->ie && req->ie_len) {
 		memcpy(wk->ie, req->ie, req->ie_len);
 		wk->ie_len = req->ie_len;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 48260c2..db24d25 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1641,6 +1641,13 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		change = true;
 	}
 
+	if (info->attrs[NL80211_ATTR_DISABLE_HT]) {
+		params.disable_11n = !!nla_get_u8(info->attrs[NL80211_ATTR_DISABLE_HT]);
+		change = true;
+	} else {
+		params.disable_11n = -1;
+	}
+
 	if (change)
 		err = cfg80211_change_iface(rdev, dev, ntype, flags, &params);
 	else
-- 
1.7.3.4

