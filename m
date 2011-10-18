Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33767 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1JRTWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 15:22:53 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC] mac80211:  Support forcing station to disable 11n.
Date: Tue, 18 Oct 2011 12:22:49 -0700
Message-Id: <1318965769-5588-1-git-send-email-greearb@candelatech.com> (sfid-20111018_212257_275439_1101F2CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows a user to configure a wifi station interface
to disable 802.11n, even if the AP and NIC supports it.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

Is this of any interest?  If so, I can post a patch against the
wireless-testing kernel and the matching hostap patch.

NOTE:  The additional netlink bits is to allow this patch to work on 3.0
with the latest hostap and should not be included in the final patch.


:100644 100644 c7ccaae... ef65049... M	include/linux/nl80211.h
:100644 100644 069b048... df3d71c... M	include/net/cfg80211.h
:100644 100644 a8f25cc... 8a3e6f9... M	net/mac80211/cfg.c
:100644 100644 090b0ec... b42dfb4... M	net/mac80211/ieee80211_i.h
:100644 100644 d5ebae7... a12cf4d... M	net/mac80211/mlme.c
:100644 100644 b3650af... 9fe4a28... M	net/wireless/nl80211.c
 include/linux/nl80211.h    |   34 ++++++++++++++++++++++++++++++++++
 include/net/cfg80211.h     |    4 +++-
 net/mac80211/cfg.c         |    3 +++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mlme.c        |    3 +++
 net/wireless/nl80211.c     |    8 ++++++++
 6 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index c7ccaae..ef65049 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -996,6 +996,9 @@ enum nl80211_commands {
  *	are managed in software: interfaces of these types aren't subject to
  *	any restrictions in their number or combinations.
  *
+ * @NL80211_ATTR_DISABLE_80211N:  Force /n capable stations to instead
+ *      function as /a/b/g stations.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1193,6 +1196,37 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_INTERFACE_COMBINATIONS,
 	NL80211_ATTR_SOFTWARE_IFTYPES,
+	NL80211_ATTR_REKEY_DATA,
+
+	NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,
+	NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN,
+
+	NL80211_ATTR_SCAN_SUPP_RATES,
+
+	NL80211_ATTR_HIDDEN_SSID,
+
+	NL80211_ATTR_IE_PROBE_RESP,
+	NL80211_ATTR_IE_ASSOC_RESP,
+
+	NL80211_ATTR_STA_WME,
+	NL80211_ATTR_SUPPORT_AP_UAPSD,
+
+	NL80211_ATTR_ROAM_SUPPORT,
+
+	NL80211_ATTR_SCHED_SCAN_MATCH,
+	NL80211_ATTR_MAX_MATCH_SETS,
+
+	NL80211_ATTR_PMKSA_CANDIDATE,
+
+	NL80211_ATTR_TX_NO_CCK_RATE,
+
+	NL80211_ATTR_TDLS_ACTION,
+	NL80211_ATTR_TDLS_DIALOG_TOKEN,
+	NL80211_ATTR_TDLS_OPERATION,
+	NL80211_ATTR_TDLS_SUPPORT,
+	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
+
+	NL80211_ATTR_DISABLE_11N,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 069b048..df3d71c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -259,9 +259,11 @@ struct ieee80211_supported_band {
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
index a8f25cc..8a3e6f9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -56,6 +56,9 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int ret;
 
+	if (params->disable_11n != -1)
+		sdata->cfg_disable_11n = params->disable_11n;
+
 	ret = ieee80211_if_change_type(sdata, type);
 	if (ret)
 		return ret;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 090b0ec..b42dfb4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -564,6 +564,8 @@ struct ieee80211_sub_if_data {
 	/* to detect idle changes */
 	bool old_idle;
 
+	bool cfg_disable_11n; /* configured to disable 11n? */
+
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d5ebae7..a12cf4d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2450,6 +2450,9 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
 
+	if (sdata->cfg_disable_11n)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+
 	if (req->ie && req->ie_len) {
 		memcpy(wk->ie, req->ie, req->ie_len);
 		wk->ie_len = req->ie_len;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3650af..9fe4a28 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1569,6 +1569,14 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		change = true;
 	}
 
+	if (info->attrs[NL80211_ATTR_DISABLE_11N]) {
+		params.disable_11n = !!nla_get_u8(info->attrs[NL80211_ATTR_DISABLE_11N]);
+		change = true;
+	}
+	else {
+		params.disable_11n = -1;
+	}
+
 	if (change)
 		err = cfg80211_change_iface(rdev, dev, ntype, flags, &params);
 	else
-- 
1.7.3.4

