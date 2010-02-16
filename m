Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:46005 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab0BPUKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 15:10:36 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1GKAWdH028301
	for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 22:10:32 +0200
Received: from [127.0.1.1] (essapo-nirac25384.europe.nokia.com [10.162.253.84])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1GKAR3T004775
	for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 22:10:28 +0200
Subject: [RFC PATCH] nl80211: add power save commands
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 16 Feb 2010 22:10:26 +0200
Message-ID: <20100216201026.25148.40799.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The only missing command from nl80211, which Wireless Extensions had,
was support for power save mode. Add a simple command to make it possible
to enable and disable power save.

I was also planning about extending the interface, for example adding the
timeout value, but after thinking more about this I decided not to do it.
Basically there were three reasons.

Firstly, the parameters for power save are very much hardware dependent.
Trying to find a unified interface which would work with all hardware, and
still make sense to users, will be very difficult.

Secondly, IEEE 802.11 power save implementation in Linux is still in state
of flux. We have a long way to still to go and there is no way to predict
what kind of implementation we will have after two years. And because we
need to support nl80211 interface a long time, practically forever, adding
now parameters to nl80211 might create maintenance problems later on.

Third issue is the users. Power save parameters are mostly used for
debugging, so debugfs is better, more flexible, interface for this.
For example, wpa_supplicant currently doesn't configure anything related
to power save mode. It's better to strive that kernel can automatically
optimise the power save parameters, like with help of pm qos network
and other traffic parameters.

Later on, when we have better understanding of power save, we can extend
this command with more features, if there's a need for that.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 include/linux/nl80211.h    |   10 +++
 include/net/cfg80211.h     |    7 +-
 net/wireless/core.c        |   16 +++--
 net/wireless/nl80211.c     |  132 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/wext-compat.c |   10 ++-
 5 files changed, 160 insertions(+), 15 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 127a730..1567175 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -387,6 +387,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_TX_BITRATE_MASK,
 
+	NL80211_CMD_SET_POWER_SAVE,
+	NL80211_CMD_GET_POWER_SAVE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -798,6 +801,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TX_RATES,
 
+	NL80211_ATTR_PS_STATE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1534,4 +1539,9 @@ enum nl80211_band {
 	NL80211_BAND_5GHZ,
 };
 
+enum nl80211_ps_state {
+	NL80211_PS_DISABLED,
+	NL80211_PS_ENABLED,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5b3569b..816c8a4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1144,7 +1144,6 @@ struct cfg80211_ops {
 					    struct net_device *dev,
 					    u64 cookie);
 
-	/* some temporary stuff to finish wext */
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 				  bool enabled, int timeout);
 };
@@ -1478,6 +1477,9 @@ struct wireless_dev {
 	struct cfg80211_internal_bss *auth_bsses[MAX_AUTH_BSSES];
 	struct cfg80211_internal_bss *current_bss; /* associated / joined */
 
+	bool ps;
+	int ps_timeout;
+
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
@@ -1489,8 +1491,7 @@ struct wireless_dev {
 		u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 		u8 ssid[IEEE80211_MAX_SSID_LEN];
 		s8 default_key, default_mgmt_key;
-		bool ps, prev_bssid_valid;
-		int ps_timeout;
+		bool prev_bssid_valid;
 	} wext;
 #endif
 };
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 71b6b3a..649afc1 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -695,19 +695,21 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
 		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
+#endif
+
 		if (wdev->wiphy->flags & WIPHY_FLAG_PS_ON_BY_DEFAULT)
-			wdev->wext.ps = true;
+			wdev->ps = true;
 		else
-			wdev->wext.ps = false;
-		wdev->wext.ps_timeout = 100;
+			wdev->ps = false;
+		wdev->ps_timeout = 100;
 		if (rdev->ops->set_power_mgmt)
 			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
-						      wdev->wext.ps,
-						      wdev->wext.ps_timeout)) {
+						      wdev->ps,
+						      wdev->ps_timeout)) {
 				/* assume this means it's off */
-				wdev->wext.ps = false;
+				wdev->ps = false;
 			}
-#endif
+
 		if (!dev->ethtool_ops)
 			dev->ethtool_ops = &cfg80211_ethtool_ops;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5b79ecf..53dad87 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -145,6 +145,7 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_DURATION] = { .type = NLA_U32 },
 	[NL80211_ATTR_COOKIE] = { .type = NLA_U64 },
 	[NL80211_ATTR_TX_RATES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_PS_STATE] = { .type = NLA_U8 },
 };
 
 /* policy for the attributes */
@@ -4549,6 +4550,125 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	u8 ps_state;
+	bool state;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_PS_STATE]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	ps_state = nla_get_u8(info->attrs[NL80211_ATTR_PS_STATE]);
+
+	if (ps_state != NL80211_PS_DISABLED && ps_state != NL80211_PS_ENABLED) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rdev;
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_power_mgmt) {
+		err = -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	state = (ps_state == NL80211_PS_ENABLED) ? true : false;
+
+	if (state == wdev->ps)
+		goto unlock_rdev;
+
+	wdev->ps = state;
+
+	if (rdev->ops->set_power_mgmt(wdev->wiphy, dev, wdev->ps,
+				      wdev->ps_timeout))
+		/* assume this means it's off */
+		wdev->ps = false;
+
+unlock_rdev:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+	rtnl_unlock();
+
+out:
+	return err;
+}
+
+static int nl80211_get_power_save(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	enum nl80211_ps_state ps_state;
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_power_mgmt) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_GET_POWER_SAVE);
+	if (!hdr) {
+		err = -ENOMEM;
+		goto free_msg;
+	}
+
+	if (wdev->ps)
+		ps_state = NL80211_PS_ENABLED;
+	else
+		ps_state = NL80211_PS_DISABLED;
+
+	NLA_PUT_U8(msg, NL80211_ATTR_PS_STATE, ps_state);
+
+	genlmsg_end(msg, hdr);
+	err = genlmsg_reply(msg, info);
+	goto out;
+
+nla_put_failure:
+	err = -ENOBUFS;
+
+free_msg:
+	nlmsg_free(msg);
+
+out:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+
+unlock_rtnl:
+	rtnl_unlock();
+
+	return err;
+}
+
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -4829,6 +4949,18 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_POWER_SAVE,
+		.doit = nl80211_set_power_save,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_GET_POWER_SAVE,
+		.doit = nl80211_get_power_save,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index b17eeae..9ab5183 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1099,8 +1099,8 @@ int cfg80211_wext_siwpower(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
-	bool ps = wdev->wext.ps;
-	int timeout = wdev->wext.ps_timeout;
+	bool ps = wdev->ps;
+	int timeout = wdev->ps_timeout;
 	int err;
 
 	if (wdev->iftype != NL80211_IFTYPE_STATION)
@@ -1133,8 +1133,8 @@ int cfg80211_wext_siwpower(struct net_device *dev,
 	if (err)
 		return err;
 
-	wdev->wext.ps = ps;
-	wdev->wext.ps_timeout = timeout;
+	wdev->ps = ps;
+	wdev->ps_timeout = timeout;
 
 	return 0;
 
@@ -1147,7 +1147,7 @@ int cfg80211_wext_giwpower(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
-	wrq->disabled = !wdev->wext.ps;
+	wrq->disabled = !wdev->ps;
 
 	return 0;
 }

