Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46131 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbcAMJE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 04:04:59 -0500
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Dedy Lansky <dlansky@codeaurora.org>,
	Maya Erez <merez@codeaurora.org>,
	Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
From: Lior David <liord@codeaurora.org>
Subject: [PATCH] cfg80211: basic support for PBSS network type
Message-ID: <56961335.4040801@codeaurora.org> (sfid-20160113_100512_267824_080F3811)
Date: Wed, 13 Jan 2016 11:04:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PBSS (Personal Basic Service Set) is a new BSS type for DMG
networks. It is similar to infrastructure BSS, having an AP-like
entity called PCP (PBSS Control Point), but it has few differences.
PBSS support is mandatory for 11ad devices.

Add support for PBSS by introducing a new PBSS flag attribute.
The PBSS flag is used in the START_AP command to request starting
a PCP instead of an AP, and in the CONNECT command to request
connecting to a PCP instead of an AP.

Signed-off-by: Lior David <liord@codeaurora.org>
---
 include/net/cfg80211.h       | 8 ++++++++
 include/uapi/linux/nl80211.h | 6 ++++++
 net/wireless/nl80211.c       | 5 +++++
 net/wireless/sme.c           | 9 ++++++---
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9bcaaf7..9e1b24c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -712,6 +712,8 @@ struct cfg80211_acl_data {
  * @p2p_opp_ps: P2P opportunistic PS
  * @acl: ACL configuration used by the drivers which has support for
  *	MAC address based access control
+ * @pbss: If set, start as a PCP instead of AP. Relevant for DMG
+ *	networks.
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -730,6 +732,7 @@ struct cfg80211_ap_settings {
 	u8 p2p_ctwindow;
 	bool p2p_opp_ps;
 	const struct cfg80211_acl_data *acl;
+	bool pbss;
 };
 
 /**
@@ -1888,6 +1891,8 @@ struct cfg80211_ibss_params {
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
  * @vht_capa:  VHT Capability overrides
  * @vht_capa_mask: The bits of vht_capa which are to be used.
+ * @pbss: if set, connect to a PCP instead of AP. Valid for DMG
+ *	networks.
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -1910,6 +1915,7 @@ struct cfg80211_connect_params {
 	struct ieee80211_ht_cap ht_capa_mask;
 	struct ieee80211_vht_cap vht_capa;
 	struct ieee80211_vht_cap vht_capa_mask;
+	bool pbss;
 };
 
 /**
@@ -3489,6 +3495,7 @@ struct cfg80211_cached_keys;
  *	registered for unexpected class 3 frames (AP mode)
  * @conn: (private) cfg80211 software SME connection state machine data
  * @connect_keys: (private) keys to set after connection is established
+ * @conn_bss_type: connecting/connected BSS type
  * @ibss_fixed: (private) IBSS is using fixed BSSID
  * @ibss_dfs_possible: (private) IBSS may change to a DFS channel
  * @event_list: (private) list for internal event processing
@@ -3519,6 +3526,7 @@ struct wireless_dev {
 	u8 ssid_len, mesh_id_len, mesh_id_up_len;
 	struct cfg80211_conn *conn;
 	struct cfg80211_cached_keys *connect_keys;
+	enum ieee80211_bss_type conn_bss_type;
 
 	struct list_head event_list;
 	spinlock_t event_lock;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5b7b5eb..7758969 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1789,6 +1789,10 @@ enum nl80211_commands {
  *	thus it must not specify the number of iterations, only the interval
  *	between scans. The scan plans are executed sequentially.
  *	Each scan plan is a nested attribute of &enum nl80211_sched_scan_plan.
+ * @NL80211_ATTR_PBSS: flag attribute. If set it means operate
+ *	in a PBSS. Specified in %NL80211_CMD_CONNECT to request
+ *	connecting to a PCP, and in %NL80211_CMD_START_AP to start
+ *	a PCP instead of AP. Relevant for DMG networks only.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2164,6 +2168,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_MAX_SCAN_PLAN_ITERATIONS,
 	NL80211_ATTR_SCHED_SCAN_PLANS,
 
+	NL80211_ATTR_PBSS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d4786f2..75a14b3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -401,6 +401,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
 	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
+	[NL80211_ATTR_PBSS] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -3461,6 +3462,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(params.acl);
 	}
 
+	params.pbss = nla_get_flag(info->attrs[NL80211_ATTR_PBSS]);
+
 	wdev_lock(wdev);
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
@@ -7980,6 +7983,8 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		connect.flags |= ASSOC_REQ_USE_RRM;
 	}
 
+	connect.pbss = nla_get_flag(info->attrs[NL80211_ATTR_PBSS]);
+
 	wdev_lock(dev->ieee80211_ptr);
 	err = cfg80211_connect(rdev, dev, &connect, connkeys, NULL);
 	wdev_unlock(dev->ieee80211_ptr);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 8020b5b..79bd3a1 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -264,7 +264,7 @@ static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 			       wdev->conn->params.bssid,
 			       wdev->conn->params.ssid,
 			       wdev->conn->params.ssid_len,
-			       IEEE80211_BSS_TYPE_ESS,
+			       wdev->conn_bss_type,
 			       IEEE80211_PRIVACY(wdev->conn->params.privacy));
 	if (!bss)
 		return NULL;
@@ -687,7 +687,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		WARN_ON_ONCE(!wiphy_to_rdev(wdev->wiphy)->ops->connect);
 		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
 				       wdev->ssid, wdev->ssid_len,
-				       IEEE80211_BSS_TYPE_ESS,
+				       wdev->conn_bss_type,
 				       IEEE80211_PRIVACY_ANY);
 		if (bss)
 			cfg80211_hold_bss(bss_from_pub(bss));
@@ -846,7 +846,7 @@ void cfg80211_roamed(struct net_device *dev,
 
 	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, wdev->ssid,
 			       wdev->ssid_len,
-			       IEEE80211_BSS_TYPE_ESS, IEEE80211_PRIVACY_ANY);
+			       wdev->conn_bss_type, IEEE80211_PRIVACY_ANY);
 	if (WARN_ON(!bss))
 		return;
 
@@ -1017,6 +1017,9 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 	memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
 	wdev->ssid_len = connect->ssid_len;
 
+	wdev->conn_bss_type = connect->pbss ? IEEE80211_BSS_TYPE_PBSS :
+					      IEEE80211_BSS_TYPE_ESS;
+
 	if (!rdev->ops->connect)
 		err = cfg80211_sme_connect(wdev, connect, prev_bssid);
 	else
-- 
1.8.2.1
