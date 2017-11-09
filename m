Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0041.outbound.protection.outlook.com ([104.47.33.41]:53568
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753292AbdKIJkl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 04:40:41 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [RFC PATCH 1/2] nl80211: implement NL80211_CMD_GET_BEACON command
Date: Thu,  9 Nov 2017 12:40:23 +0300
Message-Id: <20171109094024.9085-1-sergey.matyukevich.os@quantenna.com> (sfid-20171109_104132_462807_D8EFBF25)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasily Ulyanov <vulyanov@quantenna.com>

Implement nl80211_get_beacon callback which returns current beacon
configuration. The actual data is saved on .start_ap and .set_beacon calls.

Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>
---
 include/net/cfg80211.h       |   3 +
 include/uapi/linux/nl80211.h |   5 +-
 net/wireless/nl80211.c       | 220 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 227 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8b8118a7fadb..31d39e066274 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4002,6 +4002,8 @@ struct cfg80211_cqm_config;
  *	the user-set channel definition.
  * @preset_chandef: (private) Used by the internal configuration code to
  *	track the channel to be used for AP later
+ * @beacon: (private) Used by the internal configuration code to track
+ *	the user-set effective beacon data.
  * @bssid: (private) Used by the internal configuration code
  * @ssid: (private) Used by the internal configuration code
  * @ssid_len: (private) Used by the internal configuration code
@@ -4078,6 +4080,7 @@ struct wireless_dev {
 	struct cfg80211_internal_bss *current_bss; /* associated / joined */
 	struct cfg80211_chan_def preset_chandef;
 	struct cfg80211_chan_def chandef;
+	struct cfg80211_beacon_data beacon;
 
 	bool ibss_fixed;
 	bool ibss_dfs_possible;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f882fe1f9709..e9e163bbe11a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -279,7 +279,10 @@
  * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_IDX
  *	or %NL80211_ATTR_MAC.
  *
- * @NL80211_CMD_GET_BEACON: (not used)
+ * @NL80211_CMD_GET_BEACON: Get beacon attributes on an access point interface.
+ *	%NL80211_ATTR_BEACON_HEAD, %NL80211_ATTR_BEACON_TAIL, %NL80211_ATTR_IE,
+ *	%NL80211_ATTR_IE_PROBE_RESP, NL80211_ATTR_IE_ASSOC_RESP,
+ *	%NL80211_ATTR_PROBE_RESP will be returned if present.
  * @NL80211_CMD_SET_BEACON: change the beacon on an access point interface
  *	using the %NL80211_ATTR_BEACON_HEAD and %NL80211_ATTR_BEACON_TAIL
  *	attributes. For drivers that generate the beacon and probe responses
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fce2cbe6a193..f03f9989efbc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3784,6 +3784,172 @@ static int nl80211_parse_beacon(struct nlattr *attrs[],
 	return 0;
 }
 
+static size_t nl80211_beacon_size(struct cfg80211_beacon_data *bcn)
+{
+	size_t size = bcn->head_len + bcn->tail_len +
+		      bcn->beacon_ies_len +
+		      bcn->proberesp_ies_len +
+		      bcn->assocresp_ies_len +
+		      bcn->probe_resp_len;
+
+	return size;
+}
+
+static void nl80211_free_beacon(struct cfg80211_beacon_data *bcn)
+{
+#define free_and_null(member) \
+	do { \
+		kfree(bcn->member); \
+		bcn->member = NULL; \
+		bcn->member ## _len = 0; \
+	} while (0)
+
+	free_and_null(head);
+	free_and_null(tail);
+	free_and_null(beacon_ies);
+	free_and_null(proberesp_ies);
+	free_and_null(assocresp_ies);
+	free_and_null(probe_resp);
+
+#undef free_and_null
+}
+
+static int nl80211_dup_beacon(struct cfg80211_beacon_data *dst,
+			      struct cfg80211_beacon_data *src)
+{
+	memset(dst, 0, sizeof(*dst));
+
+#define check_and_dup(member) \
+	do { \
+		if (src->member && (src->member ## _len > 0)) { \
+			dst->member = kmemdup(src->member, \
+					      src->member ## _len, \
+					      GFP_KERNEL); \
+			if (!dst->member) \
+				goto dup_failure; \
+			dst->member ## _len = src->member ## _len; \
+		} \
+	} while (0)
+
+	check_and_dup(head);
+	check_and_dup(tail);
+	check_and_dup(beacon_ies);
+	check_and_dup(proberesp_ies);
+	check_and_dup(assocresp_ies);
+	check_and_dup(probe_resp);
+
+#undef dup_and_check
+
+	return 0;
+
+dup_failure:
+	nl80211_free_beacon(dst);
+	return -ENOMEM;
+}
+
+static int nl80211_merge_beacons(struct cfg80211_beacon_data *dst,
+				 struct cfg80211_beacon_data *old,
+				 struct cfg80211_beacon_data *new)
+{
+	memset(dst, 0, sizeof(*dst));
+
+#define check_and_merge(member) \
+	do { \
+		if (new->member && (new->member ## _len > 0)) { \
+			dst->member = kmemdup(new->member, \
+					      new->member ## _len, \
+					      GFP_KERNEL); \
+			if (!dst->member) \
+				goto dup_failure; \
+			dst->member ## _len = new->member ## _len; \
+		} else if (old->member && (old->member ## _len > 0)) { \
+			dst->member = kmemdup(old->member, \
+					      old->member ## _len, \
+					      GFP_KERNEL); \
+			if (!dst->member) \
+				goto dup_failure; \
+			dst->member ## _len = old->member ## _len; \
+		} \
+	} while (0)
+
+	check_and_merge(head);
+	check_and_merge(tail);
+	check_and_merge(beacon_ies);
+	check_and_merge(proberesp_ies);
+	check_and_merge(assocresp_ies);
+	check_and_merge(probe_resp);
+
+#undef check_and_merge
+
+	return 0;
+
+dup_failure:
+	nl80211_free_beacon(dst);
+	return -ENOMEM;
+}
+
+static void nl80211_assign_beacon(struct cfg80211_beacon_data *dst,
+				  struct cfg80211_beacon_data *src)
+{
+	nl80211_free_beacon(dst);
+	*dst = *src;
+}
+
+static int nl80211_send_beacon(struct sk_buff *msg, u32 portid,
+			       enum nl80211_commands cmd,
+			       u32 seq, int flags,
+			       struct cfg80211_beacon_data *bcn)
+{
+	void *hdr;
+
+	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (bcn->head && (bcn->head_len > 0)) {
+		if (nla_put(msg, NL80211_ATTR_BEACON_HEAD,
+			    bcn->head_len, bcn->head))
+			goto nla_put_failure;
+	}
+
+	if (bcn->tail && (bcn->tail_len > 0)) {
+		if (nla_put(msg, NL80211_ATTR_BEACON_TAIL,
+			    bcn->tail_len, bcn->tail))
+			goto nla_put_failure;
+	}
+
+	if (bcn->beacon_ies && (bcn->beacon_ies_len > 0)) {
+		if (nla_put(msg, NL80211_ATTR_IE,
+			    bcn->beacon_ies_len, bcn->beacon_ies))
+			goto nla_put_failure;
+	}
+
+	if (bcn->proberesp_ies && (bcn->proberesp_ies_len > 0)) {
+		if (nla_put(msg, NL80211_ATTR_IE_PROBE_RESP,
+			    bcn->proberesp_ies_len, bcn->proberesp_ies))
+			goto nla_put_failure;
+	}
+
+	if (bcn->assocresp_ies && (bcn->assocresp_ies_len > 0)) {
+		if (nla_put(msg, NL80211_ATTR_IE_ASSOC_RESP,
+			    bcn->assocresp_ies_len, bcn->assocresp_ies))
+			goto nla_put_failure;
+	}
+
+	if (bcn->probe_resp && (bcn->probe_resp_len > 0)) {
+		if (nla_put(msg, NL80211_ATTR_PROBE_RESP,
+			    bcn->probe_resp_len, bcn->probe_resp))
+			goto nla_put_failure;
+	}
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
 static void nl80211_check_ap_rate_selectors(struct cfg80211_ap_settings *params,
 					    const u8 *rates)
 {
@@ -3903,6 +4069,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_settings params;
+	struct cfg80211_beacon_data new_bcn;
 	int err;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
@@ -4070,6 +4237,10 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 
 	nl80211_calculate_ap_params(&params);
 
+	err = nl80211_dup_beacon(&new_bcn, &params.beacon);
+	if (err)
+		goto dup_failure;
+
 	wdev_lock(wdev);
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
@@ -4078,20 +4249,52 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		wdev->chandef = params.chandef;
 		wdev->ssid_len = params.ssid_len;
 		memcpy(wdev->ssid, params.ssid, wdev->ssid_len);
+		nl80211_assign_beacon(&wdev->beacon, &new_bcn);
 	}
 	wdev_unlock(wdev);
 
+	if (err)
+		nl80211_free_beacon(&new_bcn);
+
+dup_failure:
 	kfree(params.acl);
 
 	return err;
 }
 
+static int nl80211_get_beacon(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct sk_buff *msg;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!wdev->beacon_interval)
+		return -EINVAL;
+
+	msg = nlmsg_new(nl80211_beacon_size(&wdev->beacon), GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	if (nl80211_send_beacon(msg, NL80211_CMD_GET_BEACON, info->snd_portid,
+				info->snd_seq, 0, &wdev->beacon) < 0) {
+		nlmsg_free(msg);
+		return -ENOBUFS;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
 static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_beacon_data params;
+	struct cfg80211_beacon_data merged_bcn;
 	int err;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
@@ -4108,10 +4311,19 @@ static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	err = nl80211_merge_beacons(&merged_bcn, &wdev->beacon, &params);
+	if (err)
+		return err;
+
 	wdev_lock(wdev);
 	err = rdev_change_beacon(rdev, dev, &params);
+	if (!err)
+		nl80211_assign_beacon(&wdev->beacon, &merged_bcn);
 	wdev_unlock(wdev);
 
+	if (err)
+		nl80211_free_beacon(&merged_bcn);
+
 	return err;
 }
 
@@ -12595,6 +12807,14 @@ static const struct genl_ops nl80211_ops[] = {
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
+		.cmd = NL80211_CMD_GET_BEACON,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.doit = nl80211_get_beacon,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_SET_BEACON,
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
-- 
2.11.0
