Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:59596 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752763AbdDMMHF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 08:07:05 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 02/10] nl80211: allow multiple active scheduled scan requests
Date: Thu, 13 Apr 2017 13:06:28 +0100
Message-Id: <1492085196-4574-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170413_140723_668593_29CDE116)
In-Reply-To: <1492085196-4574-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1492085196-4574-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements the idea to have multiple scheduled scan requests
running concurrently. It mainly illustrates how to deal with the incoming
request from user-space in terms of backward compatibility. In order to
use multiple scheduled scans user-space needs to provide a flag attribute
NL80211_ATTR_SCHED_SCAN_MULTI to indicate support. If not the request is
treated as a legacy scan.

Drivers currently supporting scheduled scan are now indicating they support
a single scheduled scan request. This obsoletes WIPHY_FLAG_SUPPORTS_SCHED_SCAN.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   2 +-
 drivers/net/wireless/ti/wlcore/main.c              |   2 +-
 include/net/cfg80211.h                             |   7 +-
 include/uapi/linux/nl80211.h                       |  12 ++-
 net/wireless/core.c                                |  26 ++++--
 net/wireless/core.h                                |  10 +-
 net/wireless/nl80211.c                             |  50 ++++++++--
 net/wireless/rdev-ops.h                            |   2 +-
 net/wireless/scan.c                                | 102 +++++++++++++++++----
 net/wireless/trace.h                               |  18 ++--
 13 files changed, 186 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 48dc66a..0a7814b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3975,7 +3975,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 			    WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
 
 	if (test_bit(ATH6KL_FW_CAPABILITY_SCHED_SCAN_V2, ar->fw_capabilities))
-		ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
+		ar->wiphy->max_sched_scan_reqs = 1;
 
 	if (test_bit(ATH6KL_FW_CAPABILITY_INACTIVITY_TIMEOUT,
 		     ar->fw_capabilities))
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index bd245a6..5d82e1b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6356,11 +6356,11 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
 static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 {
 	/* scheduled scan settings */
+	wiphy->max_sched_scan_reqs = 1;
 	wiphy->max_sched_scan_ssids = BRCMF_PNO_MAX_PFN_COUNT;
 	wiphy->max_match_sets = BRCMF_PNO_MAX_PFN_COUNT;
 	wiphy->max_sched_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
 	wiphy->max_sched_scan_plan_interval = BRCMF_PNO_SCHED_SCAN_MAX_PERIOD;
-	wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d37b169..5f1d648 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -619,7 +619,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	else
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
+	hw->wiphy->max_sched_scan_reqs = 1;
 	hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
 	hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;
 	/* we create the 802.11 header and zero length SSID IE. */
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 322adad..54b549a 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4276,7 +4276,6 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
 			WIPHY_FLAG_AP_UAPSD |
-			WIPHY_FLAG_SUPPORTS_SCHED_SCAN |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
 			WIPHY_FLAG_HAS_CHANNEL_SWITCH |
 			WIPHY_FLAG_PS_ON_BY_DEFAULT;
@@ -4295,6 +4294,7 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
 
+	wiphy->max_sched_scan_reqs = 1;
 	wiphy->max_sched_scan_ssids = MWIFIEX_MAX_SSID_LIST_LENGTH;
 	wiphy->max_sched_scan_ie_len = MWIFIEX_MAX_VSIE_LEN;
 	wiphy->max_match_sets = MWIFIEX_MAX_SSID_LIST_LENGTH;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index a21fda9..382ec15 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6128,6 +6128,7 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->max_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
 			sizeof(struct ieee80211_header);
 
+	wl->hw->wiphy->max_sched_scan_reqs = 1;
 	wl->hw->wiphy->max_sched_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
 		sizeof(struct ieee80211_header);
 
@@ -6135,7 +6136,6 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 
 	wl->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD |
 				WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-				WIPHY_FLAG_SUPPORTS_SCHED_SCAN |
 				WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 	wl->hw->wiphy->features |= NL80211_FEATURE_AP_SCAN;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2a200b9..7721a9b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1678,6 +1678,7 @@ struct cfg80211_bss_select_adjust {
  * @rcu_head: RCU callback used to free the struct
  * @owner_nlportid: netlink portid of owner (if this should is a request
  *	owned by a particular socket)
+ * @list: for keeping list of requests.
  * @delay: delay in seconds to use before starting the first scan
  *	cycle.  The driver may ignore this parameter and start
  *	immediately (or at any other time), if this feature is not
@@ -1722,6 +1723,7 @@ struct cfg80211_sched_scan_request {
 	unsigned long scan_start;
 	struct rcu_head rcu_head;
 	u32 owner_nlportid;
+	struct list_head list;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
@@ -3213,7 +3215,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
-	WIPHY_FLAG_SUPPORTS_SCHED_SCAN		= BIT(11),
+	/* use hole at 11 */
 	/* use hole at 12 */
 	WIPHY_FLAG_SUPPORTS_FW_ROAM		= BIT(13),
 	WIPHY_FLAG_AP_UAPSD			= BIT(14),
@@ -3551,6 +3553,8 @@ struct wiphy_iftype_ext_capab {
  *	this variable determines its size
  * @max_scan_ssids: maximum number of SSIDs the device can scan for in
  *	any given scan
+ * @max_sched_scan_reqs: maximum number of scheduled scan requests that
+ *	the device can run concurrently.
  * @max_sched_scan_ssids: maximum number of SSIDs the device can scan
  *	for in any given scheduled scan
  * @max_match_sets: maximum number of match sets the device can handle
@@ -3687,6 +3691,7 @@ struct wiphy {
 
 	int bss_priv_size;
 	u8 max_scan_ssids;
+	u8 max_sched_scan_reqs;
 	u8 max_sched_scan_ssids;
 	u8 max_match_sets;
 	u16 max_scan_ie_len;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6095a6c..f34127d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -387,7 +387,9 @@
  *	are used.  Extra IEs can also be passed from the userspace by
  *	using the %NL80211_ATTR_IE attribute.  The first cycle of the
  *	scheduled scan can be delayed by %NL80211_ATTR_SCHED_SCAN_DELAY
- *	is supplied.
+ *	is supplied. If the device supports multiple concurrent scheduled
+ *	scans, it will allow such when the caller provides the flag attribute
+ *	%NL80211_ATTR_SCHED_SCAN_MULTI to indicate user-space support for it.
  * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan. Returns -ENOENT if
  *	scheduled scan is not running. The caller may assume that as soon
  *	as the call returns, it is safe to start a new scheduled scan again.
@@ -2081,6 +2083,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_PMK: PMK for the PMKSA identified by %NL80211_ATTR_PMKID.
  *	This is used with @NL80211_CMD_SET_PMKSA.
  *
+ * @NL80211_ATTR_SCHED_SCAN_MULTI: flag attribute which user-space shall use to
+ *	indicate that it supports multiple active scheduled scan requests.
+ * @NL80211_ATTR_SCHED_SCAN_MAX_REQS: indicates maximum number of scheduled
+ *	scan request that may be active for the device (u32).
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2500,6 +2507,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PMK,
 
+	NL80211_ATTR_SCHED_SCAN_MULTI,
+	NL80211_ATTR_SCHED_SCAN_MAX_REQS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index b0d6761..24f7ec7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -346,13 +346,17 @@ static void cfg80211_destroy_iface_wk(struct work_struct *work)
 static void cfg80211_sched_scan_stop_wk(struct work_struct *work)
 {
 	struct cfg80211_registered_device *rdev;
+	struct cfg80211_sched_scan_request *pos, *tmp;
 
 	rdev = container_of(work, struct cfg80211_registered_device,
 			   sched_scan_stop_wk);
 
 	rtnl_lock();
 
-	__cfg80211_stop_sched_scan(rdev, false);
+	/* request gets removed from list so need safe iterator */
+	list_for_each_entry_safe(pos, tmp, &rdev->sched_scan_req_list, list) {
+		cfg80211_stop_sched_scan_req(rdev, pos, false);
+	}
 
 	rtnl_unlock();
 }
@@ -468,6 +472,7 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	spin_lock_init(&rdev->beacon_registrations_lock);
 	spin_lock_init(&rdev->bss_lock);
 	INIT_LIST_HEAD(&rdev->bss_list);
+	INIT_LIST_HEAD(&rdev->sched_scan_req_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
 	INIT_WORK(&rdev->sched_scan_results_wk, __cfg80211_sched_scan_results);
 	INIT_LIST_HEAD(&rdev->mlme_unreg);
@@ -1046,7 +1051,7 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev)
 {
 	struct net_device *dev = wdev->netdev;
-	struct cfg80211_sched_scan_request *sched_scan_req;
+	struct cfg80211_sched_scan_request *pos, *tmp;
 
 	ASSERT_RTNL();
 	ASSERT_WDEV_LOCK(wdev);
@@ -1057,9 +1062,10 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-		sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
-		if (sched_scan_req && dev == sched_scan_req->dev)
-			__cfg80211_stop_sched_scan(rdev, false);
+		list_for_each_entry_safe(pos, tmp, &rdev->sched_scan_req_list, list) {
+			if (dev == pos->dev)
+				cfg80211_stop_sched_scan_req(rdev, pos, false);
+		}
 
 #ifdef CONFIG_CFG80211_WEXT
 		kfree(wdev->wext.ie);
@@ -1134,7 +1140,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev;
-	struct cfg80211_sched_scan_request *sched_scan_req;
+	struct cfg80211_sched_scan_request *pos, *tmp;
 
 	if (!wdev)
 		return NOTIFY_DONE;
@@ -1211,10 +1217,10 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			___cfg80211_scan_done(rdev, false);
 		}
 
-		sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
-		if (WARN_ON(sched_scan_req &&
-			    sched_scan_req->dev == wdev->netdev)) {
-			__cfg80211_stop_sched_scan(rdev, false);
+		list_for_each_entry_safe(pos, tmp,
+					 &rdev->sched_scan_req_list, list) {
+			if (WARN_ON(pos && pos->dev == wdev->netdev))
+				cfg80211_stop_sched_scan_req(rdev, pos, false);
 		}
 
 		rdev->opencount--;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5d27eca..a421658 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -74,6 +74,7 @@ struct cfg80211_registered_device {
 	u32 bss_entries;
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	struct sk_buff *scan_msg;
+	struct list_head sched_scan_req_list;
 	struct cfg80211_sched_scan_request __rcu *sched_scan_req;
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
@@ -424,9 +425,16 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 void __cfg80211_scan_done(struct work_struct *wk);
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 			   bool send_message);
+void cfg80211_add_sched_scan_req(struct cfg80211_registered_device *rdev,
+				 struct cfg80211_sched_scan_request *req);
+int cfg80211_sched_scan_req_possible(struct cfg80211_registered_device *rdev,
+				     bool want_multi);
 void __cfg80211_sched_scan_results(struct work_struct *wk);
+int cfg80211_stop_sched_scan_req(struct cfg80211_registered_device *rdev,
+				 struct cfg80211_sched_scan_request *req,
+				 bool driver_initiated);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
-			       bool driver_initiated);
+			       u64 reqid, bool driver_initiated);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a047992..ce6f55a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -419,6 +419,7 @@ enum nl80211_multicast_groups {
 					.len = FILS_ERP_MAX_RRK_LEN },
 	[NL80211_ATTR_FILS_CACHE_ID] = { .len = 2 },
 	[NL80211_ATTR_PMK] = { .type = NLA_BINARY, .len = PMK_MAX_LEN },
+	[NL80211_ATTR_SCHED_SCAN_MULTI] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -1391,7 +1392,7 @@ static int nl80211_add_commands_unsplit(struct cfg80211_registered_device *rdev,
 		CMD(tdls_mgmt, TDLS_MGMT);
 		CMD(tdls_oper, TDLS_OPER);
 	}
-	if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+	if (rdev->wiphy.max_sched_scan_reqs)
 		CMD(sched_scan_start, START_SCHED_SCAN);
 	CMD(probe_client, PROBE_CLIENT);
 	CMD(set_noack_map, SET_NOACK_MAP);
@@ -1830,6 +1831,11 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		    nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
 			goto nla_put_failure;
 
+		if (rdev->wiphy.max_sched_scan_reqs &&
+		    nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_MAX_REQS,
+				rdev->wiphy.max_sched_scan_reqs))
+			goto nla_put_failure;
+
 		if (nla_put(msg, NL80211_ATTR_EXT_FEATURES,
 			    sizeof(rdev->wiphy.ext_features),
 			    rdev->wiphy.ext_features))
@@ -7342,14 +7348,16 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_sched_scan_request *sched_scan_req;
+	bool want_multi;
 	int err;
 
-	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
-	    !rdev->ops->sched_scan_start)
+	if (!rdev->wiphy.max_sched_scan_reqs || !rdev->ops->sched_scan_start)
 		return -EOPNOTSUPP;
 
-	if (rdev->sched_scan_req)
-		return -EINPROGRESS;
+	want_multi = info->attrs[NL80211_ATTR_SCHED_SCAN_MULTI];
+	err = cfg80211_sched_scan_req_possible(rdev, want_multi);
+	if (err)
+		return err;
 
 	sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy, wdev,
 						  info->attrs,
@@ -7359,6 +7367,14 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (err)
 		goto out_err;
 
+	/* leave request id zero for legacy request
+	 * or if driver does not support multi-scheduled scan
+	 */
+	if (want_multi && rdev->wiphy.max_sched_scan_reqs > 1) {
+		while (!sched_scan_req->reqid)
+			sched_scan_req->reqid = rdev->wiphy.cookie_counter++;
+	}
+
 	err = rdev_sched_scan_start(rdev, dev, sched_scan_req);
 	if (err)
 		goto out_free;
@@ -7369,7 +7385,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
 		sched_scan_req->owner_nlportid = info->snd_portid;
 
-	rcu_assign_pointer(rdev->sched_scan_req, sched_scan_req);
+	cfg80211_add_sched_scan_req(rdev, sched_scan_req);
 
 	nl80211_send_sched_scan(sched_scan_req, NL80211_CMD_START_SCHED_SCAN);
 	return 0;
@@ -7383,13 +7399,27 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 static int nl80211_stop_sched_scan(struct sk_buff *skb,
 				   struct genl_info *info)
 {
+	struct cfg80211_sched_scan_request *req;
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	u64 cookie;
 
-	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
-	    !rdev->ops->sched_scan_stop)
+	if (!rdev->wiphy.max_sched_scan_reqs || !rdev->ops->sched_scan_stop)
 		return -EOPNOTSUPP;
 
-	return __cfg80211_stop_sched_scan(rdev, false);
+	if (info->attrs[NL80211_ATTR_COOKIE]) {
+		cookie = nla_get_u64(info->attrs[NL80211_ATTR_COOKIE]);
+		return __cfg80211_stop_sched_scan(rdev, cookie, false);
+	} else {
+		req = list_first_or_null_rcu(&rdev->sched_scan_req_list,
+					     struct cfg80211_sched_scan_request,
+					     list);
+		if (!req || req->reqid ||
+		    (req->owner_nlportid &&
+		     req->owner_nlportid != info->snd_portid))
+			return -ENOENT;
+
+		return cfg80211_stop_sched_scan_req(rdev, req, false);
+	}
 }
 
 static int nl80211_start_radar_detection(struct sk_buff *skb,
@@ -14900,7 +14930,7 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 			sched_scan_req->owner_nlportid = 0;
 
 			if (rdev->ops->sched_scan_stop &&
-			    rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+			    rdev->wiphy.max_sched_scan_reqs)
 				schedule_work(&rdev->sched_scan_stop_wk);
 		}
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index e4a9998..783f89c 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -813,7 +813,7 @@ static inline int rdev_get_antenna(struct cfg80211_registered_device *rdev,
 		      struct cfg80211_sched_scan_request *request)
 {
 	int ret;
-	trace_rdev_sched_scan_start(&rdev->wiphy, dev, request);
+	trace_rdev_sched_scan_start(&rdev->wiphy, dev, request->reqid);
 	ret = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 6f4996c..1c7dcf4 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -300,6 +300,70 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request,
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
 
+void cfg80211_add_sched_scan_req(struct cfg80211_registered_device *rdev,
+				 struct cfg80211_sched_scan_request *req)
+{
+	ASSERT_RTNL();
+
+	list_add_rcu(&req->list, &rdev->sched_scan_req_list);
+}
+
+static void cfg80211_del_sched_scan_req(struct cfg80211_registered_device *rdev,
+					struct cfg80211_sched_scan_request *req)
+{
+	ASSERT_RTNL();
+
+	list_del_rcu(&req->list);
+	kfree_rcu(req, rcu_head);
+}
+
+static struct cfg80211_sched_scan_request *
+cfg80211_find_sched_scan_req(struct cfg80211_registered_device *rdev, u64 reqid)
+{
+	struct cfg80211_sched_scan_request *pos;
+
+	ASSERT_RTNL();
+
+	list_for_each_entry(pos, &rdev->sched_scan_req_list, list) {
+		if (pos->reqid == reqid)
+			return pos;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
+/*
+ * Determines if a scheduled scan request can be handled. When a legacy
+ * scheduled scan is running no other scheduled scan is allowed regardless
+ * whether the request is for legacy or multi-support scan. When a multi-support
+ * scheduled scan is running a request for legacy scan is not allowed. In this
+ * case a request for multi-support scan can be handled if resources are
+ * available, ie. struct wiphy::max_sched_scan_reqs limit is not yet reached.
+ */
+int cfg80211_sched_scan_req_possible(struct cfg80211_registered_device *rdev,
+				     bool want_multi)
+{
+	struct cfg80211_sched_scan_request *pos;
+	int i = 0;
+
+	list_for_each_entry(pos, &rdev->sched_scan_req_list, list) {
+		/* request id zero means legacy in progress */
+		if (!i && !pos->reqid)
+			return -EINPROGRESS;
+		i++;
+	}
+
+	if (i) {
+		/* no legacy allowed when multi request(s) are active */
+		if (!want_multi)
+			return -EINPROGRESS;
+
+		/* resource limit reached */
+		if (i == rdev->wiphy.max_sched_scan_reqs)
+			return -ENOSPC;
+	}
+	return 0;
+}
+
 void __cfg80211_sched_scan_results(struct work_struct *wk)
 {
 	struct cfg80211_registered_device *rdev;
@@ -346,7 +410,7 @@ void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy)
 
 	trace_cfg80211_sched_scan_stopped(wiphy);
 
-	__cfg80211_stop_sched_scan(rdev, true);
+	__cfg80211_stop_sched_scan(rdev, 0, true);
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped_rtnl);
 
@@ -358,34 +422,40 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
 
-int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
-			       bool driver_initiated)
+int cfg80211_stop_sched_scan_req(struct cfg80211_registered_device *rdev,
+				 struct cfg80211_sched_scan_request *req,
+				 bool driver_initiated)
 {
-	struct cfg80211_sched_scan_request *sched_scan_req;
-	struct net_device *dev;
-
 	ASSERT_RTNL();
 
-	if (!rdev->sched_scan_req)
-		return -ENOENT;
-
-	sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
-	dev = sched_scan_req->dev;
-
 	if (!driver_initiated) {
-		int err = rdev_sched_scan_stop(rdev, dev);
+		int err = rdev_sched_scan_stop(rdev, req->dev);
 		if (err)
 			return err;
 	}
 
-	nl80211_send_sched_scan(sched_scan_req, NL80211_CMD_SCHED_SCAN_STOPPED);
+	nl80211_send_sched_scan(req, NL80211_CMD_SCHED_SCAN_STOPPED);
 
-	RCU_INIT_POINTER(rdev->sched_scan_req, NULL);
-	kfree_rcu(sched_scan_req, rcu_head);
+	cfg80211_del_sched_scan_req(rdev, req);
 
 	return 0;
 }
 
+int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
+			       u64 reqid, bool driver_initiated)
+{
+	struct cfg80211_sched_scan_request *sched_scan_req;
+
+	ASSERT_RTNL();
+
+	sched_scan_req = cfg80211_find_sched_scan_req(rdev, reqid);
+	if (IS_ERR(sched_scan_req))
+		return PTR_ERR(sched_scan_req);
+
+	return cfg80211_stop_sched_scan_req(rdev, sched_scan_req,
+					    driver_initiated);
+}
+
 void cfg80211_bss_age(struct cfg80211_registered_device *rdev,
                       unsigned long age_secs)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index fd55786..52935c4 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1610,20 +1610,26 @@
 	TP_ARGS(wiphy, rx, tx)
 );
 
-TRACE_EVENT(rdev_sched_scan_start,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 struct cfg80211_sched_scan_request *request),
-	TP_ARGS(wiphy, netdev, request),
+DECLARE_EVENT_CLASS(wiphy_netdev_id_evt,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u64 id),
+	TP_ARGS(wiphy, netdev, id),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		NETDEV_ENTRY
+		__field(u64, id)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		NETDEV_ASSIGN;
+		__entry->id = id;
 	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT,
-		  WIPHY_PR_ARG, NETDEV_PR_ARG)
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", id: %llu",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->id)
+);
+
+DEFINE_EVENT(wiphy_netdev_id_evt, rdev_sched_scan_start,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u64 id),
+	TP_ARGS(wiphy, netdev, id)
 );
 
 TRACE_EVENT(rdev_tdls_mgmt,
-- 
1.9.1
