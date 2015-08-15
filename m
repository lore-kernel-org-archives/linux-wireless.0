Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1725 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbbHOTkm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 15:40:42 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/9] nl80211: support vendor dumpit commands
Date: Sat, 15 Aug 2015 22:39:49 +0300
Message-Id: <1439667594-13632-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150815_214044_949182_EEF7FCCA)
In-Reply-To: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to transfer many items in vendor commands, support the
dumpit netlink method for them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h |   9 +++
 net/wireless/nl80211.c | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 201 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f0889a2..0f54c9e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2971,12 +2971,21 @@ enum wiphy_vendor_command_flags {
  * @doit: callback for the operation, note that wdev is %NULL if the
  *	flags didn't ask for a wdev and non-%NULL otherwise; the data
  *	pointer may be %NULL if userspace provided no data at all
+ * @dumpit: dump callback, for transferring bigger/multiple items. The
+ *	@storage points to cb->args[5], ie. is preserved over the multiple
+ *	dumpit calls.
+ * It's recommended to not have the same sub command with both @doit and
+ * @dumpit, so that userspace can assume certain ones are get and others
+ * are used with dump requests.
  */
 struct wiphy_vendor_command {
 	struct nl80211_vendor_cmd_info info;
 	u32 flags;
 	int (*doit)(struct wiphy *wiphy, struct wireless_dev *wdev,
 		    const void *data, int data_len);
+	int (*dumpit)(struct wiphy *wiphy, struct wireless_dev *wdev,
+		      struct sk_buff *skb, const void *data, int data_len,
+		      unsigned long *storage);
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5d8748b..19d240b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2015	Intel Deutschland GmbH
  */
 
 #include <linux/if.h>
@@ -9938,6 +9939,9 @@ static int nl80211_vendor_cmd(struct sk_buff *skb, struct genl_info *info)
 				if (!wdev->netdev && !wdev->p2p_started)
 					return -ENETDOWN;
 			}
+
+			if (!vcmd->doit)
+				return -EOPNOTSUPP;
 		} else {
 			wdev = NULL;
 		}
@@ -9957,6 +9961,193 @@ static int nl80211_vendor_cmd(struct sk_buff *skb, struct genl_info *info)
 	return -EOPNOTSUPP;
 }
 
+static int nl80211_prepare_vendor_dump(struct sk_buff *skb,
+				       struct netlink_callback *cb,
+				       struct cfg80211_registered_device **rdev,
+				       struct wireless_dev **wdev)
+{
+	u32 vid, subcmd;
+	unsigned int i;
+	int vcmd_idx = -1;
+	int err;
+	void *data = NULL;
+	unsigned int data_len = 0;
+
+	rtnl_lock();
+
+	if (cb->args[0]) {
+		/* subtract the 1 again here */
+		struct wiphy *wiphy = wiphy_idx_to_wiphy(cb->args[0] - 1);
+		struct wireless_dev *tmp;
+
+		if (!wiphy) {
+			err = -ENODEV;
+			goto out_unlock;
+		}
+		*rdev = wiphy_to_rdev(wiphy);
+		*wdev = NULL;
+
+		if (cb->args[1]) {
+			list_for_each_entry(tmp, &(*rdev)->wdev_list, list) {
+				if (tmp->identifier == cb->args[1] - 1) {
+					*wdev = tmp;
+					break;
+				}
+			}
+		}
+
+		/* keep rtnl locked in successful case */
+		return 0;
+	}
+
+	err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
+			  nl80211_fam.attrbuf, nl80211_fam.maxattr,
+			  nl80211_policy);
+	if (err)
+		goto out_unlock;
+
+	if (!nl80211_fam.attrbuf[NL80211_ATTR_VENDOR_ID] ||
+	    !nl80211_fam.attrbuf[NL80211_ATTR_VENDOR_SUBCMD]) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	*wdev = __cfg80211_wdev_from_attrs(sock_net(skb->sk),
+					   nl80211_fam.attrbuf);
+	if (IS_ERR(*wdev))
+		*wdev = NULL;
+
+	*rdev = __cfg80211_rdev_from_attrs(sock_net(skb->sk),
+					   nl80211_fam.attrbuf);
+	if (IS_ERR(*rdev)) {
+		err = PTR_ERR(*rdev);
+		goto out_unlock;
+	}
+
+	vid = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_VENDOR_ID]);
+	subcmd = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_VENDOR_SUBCMD]);
+
+	for (i = 0; i < (*rdev)->wiphy.n_vendor_commands; i++) {
+		const struct wiphy_vendor_command *vcmd;
+
+		vcmd = &(*rdev)->wiphy.vendor_commands[i];
+
+		if (vcmd->info.vendor_id != vid || vcmd->info.subcmd != subcmd)
+			continue;
+
+		if (!vcmd->dumpit) {
+			err = -EOPNOTSUPP;
+			goto out_unlock;
+		}
+
+		vcmd_idx = i;
+		break;
+	}
+
+	if (vcmd_idx < 0) {
+		err = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	if (nl80211_fam.attrbuf[NL80211_ATTR_VENDOR_DATA]) {
+		data = nla_data(nl80211_fam.attrbuf[NL80211_ATTR_VENDOR_DATA]);
+		data_len = nla_len(nl80211_fam.attrbuf[NL80211_ATTR_VENDOR_DATA]);
+	}
+
+	/* 0 is the first index - add 1 to parse only once */
+	cb->args[0] = (*rdev)->wiphy_idx + 1;
+	/* add 1 to know if it was NULL */
+	cb->args[1] = *wdev ? (*wdev)->identifier + 1 : 0;
+	cb->args[2] = vcmd_idx;
+	cb->args[3] = (unsigned long)data;
+	cb->args[4] = data_len;
+
+	/* keep rtnl locked in successful case */
+	return 0;
+ out_unlock:
+	rtnl_unlock();
+	return err;
+}
+
+static int nl80211_vendor_cmd_dump(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	unsigned int vcmd_idx;
+	const struct wiphy_vendor_command *vcmd;
+	void *data;
+	int data_len;
+	int err;
+	struct nlattr *vendor_data;
+
+	err = nl80211_prepare_vendor_dump(skb, cb, &rdev, &wdev);
+	if (err)
+		return err;
+
+	vcmd_idx = cb->args[2];
+	data = (void *)cb->args[3];
+	data_len = cb->args[4];
+	vcmd = &rdev->wiphy.vendor_commands[vcmd_idx];
+
+	if (vcmd->flags & (WIPHY_VENDOR_CMD_NEED_WDEV |
+			   WIPHY_VENDOR_CMD_NEED_NETDEV)) {
+		if (!wdev)
+			return -EINVAL;
+		if (vcmd->flags & WIPHY_VENDOR_CMD_NEED_NETDEV &&
+		    !wdev->netdev)
+			return -EINVAL;
+
+		if (vcmd->flags & WIPHY_VENDOR_CMD_NEED_RUNNING) {
+			if (wdev->netdev &&
+			    !netif_running(wdev->netdev))
+				return -ENETDOWN;
+			if (!wdev->netdev && !wdev->p2p_started)
+				return -ENETDOWN;
+		}
+	}
+
+	while (1) {
+		void *hdr = nl80211hdr_put(skb, NETLINK_CB_PORTID(cb->skb),
+					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
+					   NL80211_CMD_VENDOR);
+		if (!hdr)
+			break;
+
+		if (nla_put_u32(skb, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+		    (wdev && nla_put_u64(skb, NL80211_ATTR_WDEV,
+					 wdev_id(wdev)))) {
+			genlmsg_cancel(skb, hdr);
+			break;
+		}
+
+		vendor_data = nla_nest_start(skb, NL80211_ATTR_VENDOR_DATA);
+		if (!vendor_data) {
+			genlmsg_cancel(skb, hdr);
+			break;
+		}
+
+		err = vcmd->dumpit(&rdev->wiphy, wdev, skb, data, data_len,
+				   &cb->args[5]);
+		nla_nest_end(skb, vendor_data);
+
+		if (err == -ENOBUFS || err == -ENOENT) {
+			genlmsg_cancel(skb, hdr);
+			break;
+		} else if (err) {
+			genlmsg_cancel(skb, hdr);
+			goto out;
+		}
+
+		genlmsg_end(skb, hdr);
+	}
+
+	err = skb->len;
+ out:
+	rtnl_unlock();
+	return err;
+}
+
 struct sk_buff *__cfg80211_alloc_reply_skb(struct wiphy *wiphy,
 					   enum nl80211_commands cmd,
 					   enum nl80211_attrs attr,
@@ -10994,6 +11185,7 @@ static const struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_VENDOR,
 		.doit = nl80211_vendor_cmd,
+		.dumpit = nl80211_vendor_cmd_dump,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
-- 
2.1.4

