Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53305 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab2LNPPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 10:15:44 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so3212041iay.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 07:15:43 -0800 (PST)
Date: Fri, 14 Dec 2012 10:14:42 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: thomas@cozybit.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org
Subject: [PATCH/RFC] nl80211/cfg80211/mac80211: add
 NL80211_CMD_GET_MESH_SETUP
Message-ID: <20121214151442.GA10736@localhost> (sfid-20121214_161548_225507_5AF461A6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new netlink call to get the parameters used at join time
for the mesh.  This provides a way for userspace to get
some basic mesh properties that are otherwise unavailable, such
as the meshid and (eventually) configured dtim and beacon
values.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
We can currently return the config values in GET_MESH_CONFIG
but not the fixed join-time values.

My use case is to have a way to get the locally configured
dtim and beacon interval, once Marco's patches are in
(obviously not handled yet in this patch).  Note the local
values might be different from peer mesh STAs' settings.

Thomas suggested a general GET_MESH_SETUP would be good to
also allow userspace to get the meshid and to know if mesh
is running without doing a bogus SET_MESH_CONFIG.

Presumably, once someone implements beacon collision avoidance,
I'd rather have the current dtim/beacon_int values, which isn't
really setup anymore, but maybe we don't care so much.

Thoughts?

 include/net/cfg80211.h       |    3 ++
 include/uapi/linux/nl80211.h |    5 +++
 net/mac80211/cfg.c           |   30 ++++++++++++++++
 net/wireless/nl80211.c       |   78 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 116 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8e6a6b7..51386b8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1833,6 +1833,9 @@ struct cfg80211_ops {
 	int	(*update_mesh_config)(struct wiphy *wiphy,
 				      struct net_device *dev, u32 mask,
 				      const struct mesh_config *nconf);
+	int	(*get_mesh_setup)(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  struct mesh_setup *setup);
 	int	(*join_mesh)(struct wiphy *wiphy, struct net_device *dev,
 			     const struct mesh_config *conf,
 			     const struct mesh_setup *setup);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e3e19f8..3974a92 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -586,6 +586,9 @@
  * @NL80211_CMD_SET_MCAST_RATE: Change the rate used to send multicast frames
  *	for IBSS or MESH vif.
  *
+ * @NL80211_CMD_GET_MESH_SETUP: Retrieve mesh properties that are set at
+ *      mesh join time, for the interface identified by %NL80211_ATTR_IFINDEX.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -736,6 +739,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_MCAST_RATE,
 
+	NL80211_CMD_GET_MESH_SETUP,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5c61677..36e9c97 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1616,6 +1616,35 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	return 0;
 }
 
+static int ieee80211_get_mesh_setup(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    struct mesh_setup *setup)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_mesh *ifmsh;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	ifmsh = &sdata->u.mesh;
+
+	if (!ifmsh->mesh_id_len)
+		return -ENOLINK;
+
+	setup->mesh_id = ifmsh->mesh_id;
+	setup->mesh_id_len = ifmsh->mesh_id_len;
+	setup->sync_method = ifmsh->mesh_sp_id;
+	setup->path_sel_proto = ifmsh->mesh_pp_id;
+	setup->path_metric = ifmsh->mesh_pm_id;
+	setup->is_authenticated = ifmsh->security & IEEE80211_MESH_SEC_AUTHED;
+	setup->is_secure = ifmsh->security & IEEE80211_MESH_SEC_SECURED;
+	setup->ie = ifmsh->ie;
+	setup->ie_len = ifmsh->ie_len;
+
+	memcpy(setup->mcast_rate, sdata->vif.bss_conf.mcast_rate,
+		sizeof(sdata->vif.bss_conf.mcast_rate));
+	return 0;
+}
+
+
 static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 					struct net_device *dev, u32 mask,
 					const struct mesh_config *nconf)
@@ -3206,6 +3235,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.dump_mpath = ieee80211_dump_mpath,
 	.update_mesh_config = ieee80211_update_mesh_config,
 	.get_mesh_config = ieee80211_get_mesh_config,
+	.get_mesh_setup = ieee80211_get_mesh_setup,
 	.join_mesh = ieee80211_join_mesh,
 	.leave_mesh = ieee80211_leave_mesh,
 #endif
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f45706a..84a6a45 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3921,6 +3921,76 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	return -ENOBUFS;
 }
 
+static int nl80211_get_mesh_setup(struct sk_buff *skb,
+				  struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct mesh_setup setup;
+	int err = 0;
+	void *hdr;
+	struct nlattr *pinfoattr;
+	struct sk_buff *msg;
+
+	if (wdev->iftype != NL80211_IFTYPE_MESH_POINT)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->get_mesh_setup)
+		return -EOPNOTSUPP;
+
+	wdev_lock(wdev);
+	err = rdev->ops->get_mesh_setup(&rdev->wiphy, dev, &setup);
+	if (err)
+		goto out;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_GET_MESH_SETUP);
+	if (!hdr)
+		goto out_err;
+
+	if (nla_put(msg, NL80211_ATTR_MESH_ID, setup.mesh_id_len,
+		    setup.mesh_id))
+		goto nla_put_failure;
+
+	pinfoattr = nla_nest_start(msg, NL80211_ATTR_MESH_SETUP);
+	if (!pinfoattr)
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC,
+		       setup.sync_method) ||
+	    nla_put_u8(msg, NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL,
+		       setup.path_sel_proto) ||
+	    nla_put_u8(msg, NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC,
+		       setup.path_metric) ||
+	    (setup.is_authenticated &&
+	     nla_put_flag(msg, NL80211_MESH_SETUP_USERSPACE_AUTH)) ||
+	    (setup.is_secure &&
+	     nla_put_flag(msg, NL80211_MESH_SETUP_USERSPACE_AMPE)))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, pinfoattr);
+	genlmsg_end(msg, hdr);
+
+	err = genlmsg_reply(msg, info);
+	goto out;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+ out_err:
+	nlmsg_free(msg);
+	err = -ENOBUFS;
+ out:
+	wdev_unlock(wdev);
+	return err;
+}
+
 static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_ATTR_MAX+1] = {
 	[NL80211_MESHCONF_RETRY_TIMEOUT] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_CONFIRM_TIMEOUT] = { .type = NLA_U16 },
@@ -7784,6 +7854,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_GET_MESH_SETUP,
+		.doit = nl80211_get_mesh_setup,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.7.10.4

-- 
Bob Copeland %% www.bobcopeland.com
