Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:6073 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934154AbZKXW53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 17:57:29 -0500
Date: Tue, 24 Nov 2009 23:59:15 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH v2 1/3] nl80211: PMKSA caching support
Message-ID: <20091124225913.GB8290@sortiz.org>
References: <cover.1259075573.git.sameo@linux.intel.com>
 <ff5bf1a69ecd3ed3695089cf62e6ab51689b683a.1259075573.git.sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ff5bf1a69ecd3ed3695089cf62e6ab51689b683a.1259075573.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an interface to set, delete and flush PMKIDs through nl80211.
Main users would be fullmac devices which firmwares are capable of
generating the RSN IEs for the re-association requests, e.g. iwmc3200wifi.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---

v2: Added NL80211_ATTR_MAX_NUM_PMKIDS attribute

 include/linux/ieee80211.h |    2 +
 include/linux/nl80211.h   |   11 ++++
 include/net/cfg80211.h    |   28 ++++++++++
 net/wireless/nl80211.c    |  120 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 161 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index afa8e0a..d9724a2 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1266,6 +1266,8 @@ enum ieee80211_sa_query_action {
 
 #define WLAN_MAX_KEY_LEN		32
 
+#define WLAN_PMKID_LEN			16
+
 /**
  * ieee80211_get_qos_ctl - get pointer to qos control bytes
  * @hdr: the frame
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 45db17f..da8ea2e 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -349,6 +349,10 @@ enum nl80211_commands {
 	NL80211_CMD_GET_SURVEY,
 	NL80211_CMD_NEW_SURVEY_RESULTS,
 
+	NL80211_CMD_SET_PMKSA,
+	NL80211_CMD_DEL_PMKSA,
+	NL80211_CMD_FLUSH_PMKSA,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -598,6 +602,10 @@ enum nl80211_commands {
  *      the survey response for %NL80211_CMD_GET_SURVEY, nested attribute
  *      containing info as possible, see &enum survey_info.
  *
+ * @NL80211_ATTR_PMKID: PMK material for PMKSA caching.
+ * @NL80211_ATTR_MAX_NUM_PMKIDS: maximum number of PMKIDs a firmware can
+ *	cache, a wiphy attribute.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -732,6 +740,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SURVEY_INFO,
 
+	NL80211_ATTR_PMKID,
+	NL80211_ATTR_MAX_NUM_PMKIDS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a6492e9..0884b9a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -871,6 +871,19 @@ struct cfg80211_bitrate_mask {
 	u32 fixed;   /* fixed bitrate, 0 == not fixed */
 	u32 maxrate; /* in kbps, 0 == no limit */
 };
+/**
+ * struct cfg80211_pmksa - PMK Security Association
+ *
+ * This structure is passed to the set/del_pmksa() method for PMKSA
+ * caching.
+ *
+ * @bssid: The AP's BSSID.
+ * @pmkid: The PMK material itself.
+ */
+struct cfg80211_pmksa {
+	u8 *bssid;
+	u8 *pmkid;
+};
 
 /**
  * struct cfg80211_ops - backend description for wireless configuration
@@ -976,6 +989,13 @@ struct cfg80211_bitrate_mask {
  * @dump_survey: get site survey information.
  *
  * @testmode_cmd: run a test mode command
+ *
+ * @set_pmksa: Cache a PMKID for a BSSID. This is mostly useful for fullmac
+ *	devices running firmwares capable of generating the (re) association
+ *	RSN IE. It allows for faster roaming between WPA2 BSSIDs.
+ * @del_pmksa: Delete a cached PMKID.
+ * @flush_pmksa: Flush all cached PMKIDs.
+ *
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -1097,6 +1117,12 @@ struct cfg80211_ops {
 	int	(*dump_survey)(struct wiphy *wiphy, struct net_device *netdev,
 			int idx, struct survey_info *info);
 
+	int	(*set_pmksa)(struct wiphy *wiphy, struct net_device *netdev,
+			     struct cfg80211_pmksa *pmksa);
+	int	(*del_pmksa)(struct wiphy *wiphy, struct net_device *netdev,
+			     struct cfg80211_pmksa *pmksa);
+	int	(*flush_pmksa)(struct wiphy *wiphy, struct net_device *netdev);
+
 	/* some temporary stuff to finish wext */
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 				  bool enabled, int timeout);
@@ -1195,6 +1221,8 @@ struct wiphy {
 	char fw_version[ETHTOOL_BUSINFO_LEN];
 	u32 hw_version;
 
+	u8 max_num_pmkids;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 149539a..a602843 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -139,6 +139,8 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
 	[NL80211_ATTR_PID] = { .type = NLA_U32 },
 	[NL80211_ATTR_4ADDR] = { .type = NLA_U8 },
+	[NL80211_ATTR_PMKID] = { .type = NLA_BINARY,
+				 .len = WLAN_PMKID_LEN },
 };
 
 /* policy for the attributes */
@@ -450,6 +452,9 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		sizeof(u32) * dev->wiphy.n_cipher_suites,
 		dev->wiphy.cipher_suites);
 
+	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_PMKIDS,
+		   dev->wiphy.max_num_pmkids);
+
 	nl_modes = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_IFTYPES);
 	if (!nl_modes)
 		goto nla_put_failure;
@@ -561,6 +566,9 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	CMD(deauth, DEAUTHENTICATE);
 	CMD(disassoc, DISASSOCIATE);
 	CMD(join_ibss, JOIN_IBSS);
+	CMD(set_pmksa, SET_PMKSA);
+	CMD(del_pmksa, DEL_PMKSA);
+	CMD(flush_pmksa, FLUSH_PMKSA);
 	if (dev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
 		i++;
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
@@ -4221,6 +4229,99 @@ static int nl80211_wiphy_netns(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_setdel_pmksa(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	int (*rdev_ops)(struct wiphy *wiphy, struct net_device *dev,
+			struct cfg80211_pmksa *pmksa) = NULL;
+	int err;
+	struct net_device *dev;
+	struct cfg80211_pmksa pmksa;
+
+	memset(&pmksa, 0, sizeof(struct cfg80211_pmksa));
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_PMKID])
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto out_rtnl;
+
+	pmksa.pmkid = nla_data(info->attrs[NL80211_ATTR_PMKID]);
+	pmksa.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	switch (info->genlhdr->cmd) {
+	case NL80211_CMD_SET_PMKSA:
+		rdev_ops = rdev->ops->set_pmksa;
+		break;
+	case NL80211_CMD_DEL_PMKSA:
+		rdev_ops = rdev->ops->del_pmksa;
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	if (!rdev_ops) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = rdev_ops(&rdev->wiphy, dev, &pmksa);
+
+ out:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
+	return err;
+}
+
+static int nl80211_flush_pmksa(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	int err;
+	struct net_device *dev;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto out_rtnl;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!rdev->ops->flush_pmksa) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = rdev->ops->flush_pmksa(&rdev->wiphy, dev);
+
+ out:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
+	return err;
+
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -4465,6 +4566,25 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.dumpit = nl80211_dump_survey,
 	},
+	{
+		.cmd = NL80211_CMD_SET_PMKSA,
+		.doit = nl80211_setdel_pmksa,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_DEL_PMKSA,
+		.doit = nl80211_setdel_pmksa,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_FLUSH_PMKSA,
+		.doit = nl80211_flush_pmksa,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+
 };
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
 	.name = "mlme",
-- 
1.6.3.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
