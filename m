Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B66940961C
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 21:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150315; cv=none; b=niDHT77WcNGevoAeA6jIfJMRkC5R8BPxto31PiXJcy3ZMQbLJJ4HGxIKOMg8HZ/SjrOplkswl5B3t5G9ZgEinOm180KjA1QzNiBkqeVQKZMRXW0oYbjb3Xu1D3TYt5qOocASqach1OWYlTdqDHBxgrOyY3CCDnREA1Lz1EIy+Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150315; c=relaxed/simple;
	bh=g4HDNQmBEmeSmXJdPk7biVYVk7bDGM+uKXo4vQSv+XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCVDjaZgzPr55xPXy4yAGXBY0d5S86NHRoRUIK05BsejZVBcqY0a/p2FUFJXV7pi1GBQVbhE0ikaM6Z7Bp/SrZQizidi1qwGfSG22M4p8rfPD6its0+VIcoqOFKdryGpnZbrLlsgVM/ItPLKZyrKmnt+4vTzqPp2osR9PMdyODQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NmyxZ6WO; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NmyxZ6WO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Ih/osuUlB5v56zpQ9NLgQFg79kV9YyCxFSJlbCc1xOY=;
	t=1791150312; x=1792359912; b=NmyxZ6WOOIgwWA9fk7el/3MFIdP9V5QIH3d1hblwXBhAiwJ
	9Qh84YsCDdHHFxa8BOaKxLos8lTzhUhlbnOz1wvmSXA+dZbgXSX5sbw1NHE7GRuA603KJkEK/v/kf
	MX7Do0brdPTfI0wHvWX1qyU4vhdPFM5xXUP4W3DAtBBZffCRXeJ1hoFDZibo1iv0+4/Y9JnbjMjPD
	ZBS4k/zhWz9bbjF7P8r/ocCGDH8PBVx+/h66pfOEQN5BX/nMR9pxBhnXStSF3yaFYjPkl9qHBKi8c
	HT6zmV/46pYMmzDj28XrACcwkUWt1IMQzlAw4zryD7CCijbscmkm0ItW1mMZslCQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDU17-00000004OqT-2BJh;
	Sun, 04 Oct 2026 23:45:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 02/12] wifi: nl80211: add NL80211_CMD_UPDATE_BEACON
Date: Sun,  4 Oct 2026 23:40:48 +0200
Message-ID: <20261004234504.60646efbf678.I174b47b65aca1bbaaf6a74d64fa0e264f84028b4@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004214504.1636783-14-johannes@sipsolutions.net>
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Updating beacon and related templates with NL80211_CMD_SET_BEACON
requires the wiphy mutex, which can get contended, delaying the
updates.

Add a NL80211_CMD_UPDATE_BEACON operation that can only do beacon
template updates, not other configuration changes, but is called
without the wiphy mutex. If something requires the mutex then the
driver can return -EAGAIN, to go through the normal change_beacon
with wiphy mutex held.

Also with this support updating multiple beacons for an MLD at
the same time, just to further reduce round-trips if desired.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |   5 +
 include/uapi/linux/nl80211.h |  16 ++
 net/wireless/nl80211.c       | 312 +++++++++++++++++++++++++++++------
 net/wireless/rdev-ops.h      |  11 ++
 net/wireless/trace.h         |  14 +-
 5 files changed, 307 insertions(+), 51 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 76edfe5765c8..ba66fb45dc12 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4943,6 +4943,9 @@ struct mgmt_frame_regs {
  * @start_ap: Start acting in AP mode defined by the parameters.
  * @change_beacon: Change the beacon parameters for an access point mode
  *	interface. This should reject the call when AP mode wasn't started.
+ * @update_beacon: Update the beacon and other templates like @change_beacon,
+ *	but called without the wiphy mutex held. May return -EAGAIN to have
+ *	it fall back to @change_beacon with the wiphy mutex held.
  * @stop_ap: Stop being an AP, including stopping beaconing.
  *
  * @add_station: Add a new station.
@@ -5358,6 +5361,8 @@ struct cfg80211_ops {
 			    struct cfg80211_ap_settings *settings);
 	int	(*change_beacon)(struct wiphy *wiphy, struct net_device *dev,
 				 struct cfg80211_ap_update *info);
+	int	(*update_beacon)(struct wiphy *wiphy, struct net_device *dev,
+				 struct cfg80211_ap_update *info);
 	int	(*stop_ap)(struct wiphy *wiphy, struct net_device *dev,
 			   unsigned int link_id);
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 75d4c5d6a7a3..e3c137a7c4c8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1458,6 +1458,16 @@
  *	keep their non-evacuable marking, removed channels lose it, and newly
  *	added channels are evacuable by default; issue this command again to
  *	change the non-evacuable set.
+ * @NL80211_CMD_UPDATE_BEACON: Update the beacon and other templates of an AP
+ *	interface, but only that. Same attributes as %NL80211_CMD_SET_BEACON,
+ *	%NL80211_ATTR_BEACON_HEAD and %NL80211_ATTR_BEACON_TAIL are required,
+ *	configuration changes such as %NL80211_ATTR_FTM_RESPONDER rejected.
+ *	This doesn't acquire the wiphy mutex internally, so it's faster, but
+ *	cannot update any other configuration.
+ *	For MLO a single link is set with %NL80211_ATTR_MLO_LINK_ID as usual
+ *	and multiple can be nested in %NL80211_ATTR_MLO_LINKS but then the
+ *	update isn't atomic if any failures happen.
+ *	Only supported with %NL80211_EXT_FEATURE_UPDATE_BEACON.
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1738,6 +1748,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS,
 
+	NL80211_CMD_UPDATE_BEACON,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -7173,6 +7185,9 @@ enum nl80211_feature_flags {
  *	offload in station mode, including Fast Transition or Opportunistic
  *	Key Caching.
  *
+ * @NL80211_EXT_FEATURE_UPDATE_BEACON: Driver supports
+ *	%NL80211_CMD_UPDATE_BEACON.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -7256,6 +7271,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SET_KEY_LTF_SEED,
 	NL80211_EXT_FEATURE_PROBE_AP,
 	NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD,
+	NL80211_EXT_FEATURE_UPDATE_BEACON,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2ed6dd84b42f..b342a7b133d5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7563,15 +7563,87 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_parse_ap_update(struct cfg80211_registered_device *rdev,
+				   struct nlattr *attrs[],
+				   struct ieee80211_channel *chan,
+				   struct cfg80211_ap_update *params,
+				   struct netlink_ext_ack *extack)
+{
+	struct nlattr *attr;
+	int err;
+
+	err = nl80211_parse_beacon(rdev, attrs, &params->beacon, chan, extack);
+	if (err)
+		return err;
+
+	attr = attrs[NL80211_ATTR_FILS_DISCOVERY];
+	if (attr) {
+		err = nl80211_parse_fils_discovery(rdev, attr,
+						   &params->fils_discovery);
+		if (err)
+			return err;
+	}
+
+	attr = attrs[NL80211_ATTR_UNSOL_BCAST_PROBE_RESP];
+	if (attr) {
+		err = nl80211_parse_unsol_bcast_probe_resp(rdev, attr,
+							   &params->unsol_bcast_probe_resp);
+		if (err)
+			return err;
+	}
+
+	attr = attrs[NL80211_ATTR_S1G_SHORT_BEACON];
+	if (attr) {
+		err = nl80211_parse_s1g_short_beacon(rdev, attr,
+						     &params->s1g_short_beacon);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int nl80211_change_beacon(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev,
+				 struct cfg80211_ap_update *params)
+{
+	struct cfg80211_beaconing_check_config beacon_check = {};
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	unsigned int link_id = params->beacon.link_id;
+	int err;
+
+	/* recheck beaconing is permitted with possibly changed power type */
+	beacon_check.iftype = wdev->iftype;
+	beacon_check.relax = true;
+	beacon_check.reg_power =
+		cfg80211_get_6ghz_power_type(params->beacon.tail,
+					     params->beacon.tail_len, 0);
+	if (!cfg80211_reg_check_beaconing(&rdev->wiphy,
+					  &wdev->links[link_id].ap.chandef,
+					  &beacon_check))
+		return -EINVAL;
+
+	err = rdev_change_beacon(rdev, dev, params);
+	if (!err)
+		wdev->links[link_id].ap.reg_power = beacon_check.reg_power;
+
+	return err;
+}
+
+static void nl80211_free_ap_update(struct cfg80211_ap_update *params)
+{
+	kfree(params->beacon.mbssid_ies);
+	kfree(params->beacon.rnr_ies);
+	kfree(params);
+}
+
 static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct cfg80211_beaconing_check_config beacon_check = {};
 	unsigned int link_id = nl80211_link_id(info->attrs);
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_update *params;
-	struct nlattr *attr;
 	int err;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
@@ -7588,57 +7660,190 @@ static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
 	if (!params)
 		return -ENOMEM;
 
-	err = nl80211_parse_beacon(rdev, info->attrs, &params->beacon,
-				   wdev->links[link_id].ap.chandef.chan,
-				   info->extack);
-	if (err)
-		goto out;
-
-	/* recheck beaconing is permitted with possibly changed power type */
-	beacon_check.iftype = wdev->iftype;
-	beacon_check.relax = true;
-	beacon_check.reg_power =
-		cfg80211_get_6ghz_power_type(params->beacon.tail,
-					     params->beacon.tail_len, 0);
-	if (!cfg80211_reg_check_beaconing(&rdev->wiphy,
-					  &wdev->links[link_id].ap.chandef,
-					  &beacon_check)) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	attr = info->attrs[NL80211_ATTR_FILS_DISCOVERY];
-	if (attr) {
-		err = nl80211_parse_fils_discovery(rdev, attr,
-						   &params->fils_discovery);
-		if (err)
-			goto out;
-	}
-
-	attr = info->attrs[NL80211_ATTR_UNSOL_BCAST_PROBE_RESP];
-	if (attr) {
-		err = nl80211_parse_unsol_bcast_probe_resp(rdev, attr,
-							   &params->unsol_bcast_probe_resp);
-		if (err)
-			goto out;
-	}
-
-	attr = info->attrs[NL80211_ATTR_S1G_SHORT_BEACON];
-	if (attr) {
-		err = nl80211_parse_s1g_short_beacon(rdev, attr,
-						     &params->s1g_short_beacon);
-		if (err)
-			goto out;
-	}
-
-	err = rdev_change_beacon(rdev, dev, params);
+	err = nl80211_parse_ap_update(rdev, info->attrs,
+				      wdev->links[link_id].ap.chandef.chan,
+				      params, info->extack);
 	if (!err)
-		wdev->links[link_id].ap.reg_power = beacon_check.reg_power;
+		err = nl80211_change_beacon(rdev, dev, params);
 
+	nl80211_free_ap_update(params);
+	return err;
+}
+
+static struct cfg80211_ap_update *
+nl80211_parse_link_update(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev, struct nlattr *attrs[],
+			  struct netlink_ext_ack *extack)
+{
+	struct nlattr *link_attr = attrs[NL80211_ATTR_MLO_LINK_ID];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	unsigned int link_id = nl80211_link_id(attrs);
+	u16 valid_links = READ_ONCE(wdev->valid_links);
+	struct cfg80211_ap_update *params;
+	struct ieee80211_channel *chan;
+	int err;
+
+	/* without locks this is racy, the driver needs to check again */
+	if (valid_links ? !link_attr || !(valid_links & BIT(link_id)) :
+			  !!link_attr)
+		return ERR_PTR(-EINVAL);
+
+	if (attrs[NL80211_ATTR_FTM_RESPONDER] ||
+	    attrs[NL80211_ATTR_HE_BSS_COLOR] ||
+	    attrs[NL80211_ATTR_S1G_SHORT_BEACON]) {
+		NL_SET_ERR_MSG(extack, "cannot change configuration in update");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!attrs[NL80211_ATTR_BEACON_HEAD] ||
+	    !attrs[NL80211_ATTR_BEACON_TAIL]) {
+		NL_SET_ERR_MSG(extack, "beacon head and tail are required");
+		return ERR_PTR(-EINVAL);
+	}
+
+	chan = READ_ONCE(wdev->links[link_id].ap.chandef.chan);
+	if (!chan || !READ_ONCE(wdev->links[link_id].ap.beacon_interval))
+		return ERR_PTR(-EINVAL);
+
+	params = kzalloc_obj(*params);
+	if (!params)
+		return ERR_PTR(-ENOMEM);
+
+	err = nl80211_parse_ap_update(rdev, attrs, chan, params, extack);
+	if (err) {
+		nl80211_free_ap_update(params);
+		return ERR_PTR(err);
+	}
+
+	return params;
+}
+
+static int nl80211_update_link_beacon(struct cfg80211_registered_device *rdev,
+				      struct net_device *dev,
+				      struct cfg80211_ap_update *params)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	unsigned int link_id = params->beacon.link_id;
+
+	/* a power type change needs regulatory checks under the wiphy mutex */
+	if (cfg80211_get_6ghz_power_type(params->beacon.tail,
+					 params->beacon.tail_len, 0) !=
+	    READ_ONCE(wdev->links[link_id].ap.reg_power))
+		return -EAGAIN;
+
+	return rdev_update_beacon(rdev, dev, params);
+}
+
+static int
+nl80211_update_link_beacon_locked(struct cfg80211_registered_device *rdev,
+				  struct net_device *dev,
+				  struct cfg80211_ap_update *params)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	unsigned int link_id = params->beacon.link_id;
+
+	lockdep_assert_wiphy(&rdev->wiphy);
+
+	if (!rdev->wiphy.registered || !wdev_running(wdev))
+		return -ENETDOWN;
+
+	if (wdev->valid_links ? !(wdev->valid_links & BIT(link_id)) : link_id)
+		return -ENOLINK;
+
+	if (!wdev->links[link_id].ap.beacon_interval)
+		return -EINVAL;
+
+	return nl80211_change_beacon(rdev, dev, params);
+}
+
+static int nl80211_update_beacon(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_ap_update *params[IEEE80211_MLD_MAX_NUM_LINKS] = {};
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	unsigned long need_lock = 0;
+	unsigned int n = 0, i;
+	struct nlattr *link;
+	u16 links = 0;
+	int rem, err = 0;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->update_beacon || !rdev->ops->change_beacon ||
+	    !wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_UPDATE_BEACON))
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MLO_LINKS]) {
+		params[0] = nl80211_parse_link_update(rdev, dev, info->attrs,
+						      info->extack);
+		if (IS_ERR(params[0]))
+			return PTR_ERR(params[0]);
+		n = 1;
+	} else {
+		struct nlattr **attrs = kzalloc_objs(*attrs, NUM_NL80211_ATTR);
+
+		if (!attrs)
+			return -ENOMEM;
+
+		nla_for_each_nested(link, info->attrs[NL80211_ATTR_MLO_LINKS],
+				    rem) {
+			struct cfg80211_ap_update *p;
+
+			err = nla_parse_nested(attrs, NL80211_ATTR_MAX, link,
+					       NULL, info->extack);
+			if (err)
+				break;
+
+			p = nl80211_parse_link_update(rdev, dev, attrs,
+						      info->extack);
+			if (IS_ERR(p)) {
+				err = PTR_ERR(p);
+				break;
+			}
+
+			/* also ensures we don't overflow params[] */
+			if (links & BIT(p->beacon.link_id)) {
+				nl80211_free_ap_update(p);
+				err = -EINVAL;
+				break;
+			}
+			links |= BIT(p->beacon.link_id);
+			params[n++] = p;
+		}
+
+		kfree(attrs);
+		if (!err && !n)
+			err = -EINVAL;
+		if (err)
+			goto out;
+	}
+
+	/* try updates without wiphy mutex first */
+	for (i = 0; i < n; i++) {
+		err = nl80211_update_link_beacon(rdev, dev, params[i]);
+		if (err == -EAGAIN)
+			__set_bit(i, &need_lock);
+		else if (err)
+			goto out;
+	}
+
+	err = 0;
+	if (need_lock) {
+		wiphy_lock(&rdev->wiphy);
+		for_each_set_bit(i, &need_lock, n) {
+			err = nl80211_update_link_beacon_locked(rdev, dev,
+								params[i]);
+			if (err)
+				break;
+		}
+		wiphy_unlock(&rdev->wiphy);
+	}
 out:
-	kfree(params->beacon.mbssid_ies);
-	kfree(params->beacon.rnr_ies);
-	kfree(params);
+	for (i = 0; i < n; i++)
+		nl80211_free_ap_update(params[i]);
 	return err;
 }
 
@@ -20888,6 +21093,13 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
 	},
+	{
+		.cmd = NL80211_CMD_UPDATE_BEACON,
+		.doit = nl80211_update_beacon,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
+					 NL80211_FLAG_NO_WIPHY_MTX),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 1f1311c20e94..95882c8972d2 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -183,6 +183,17 @@ static inline int rdev_change_beacon(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_update_beacon(struct cfg80211_registered_device *rdev,
+				     struct net_device *dev,
+				     struct cfg80211_ap_update *info)
+{
+	int ret;
+	trace_rdev_update_beacon(&rdev->wiphy, dev, info);
+	ret = rdev->ops->update_beacon(&rdev->wiphy, dev, info);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_stop_ap(struct cfg80211_registered_device *rdev,
 			       struct net_device *dev, unsigned int link_id)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 83007a824010..f5fa2fb76474 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -740,7 +740,7 @@ TRACE_EVENT(rdev_start_ap,
 		  __entry->inactivity_timeout, __entry->link_id)
 );
 
-TRACE_EVENT(rdev_change_beacon,
+DECLARE_EVENT_CLASS(rdev_ap_update,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 struct cfg80211_ap_update *info),
 	TP_ARGS(wiphy, netdev, info),
@@ -788,6 +788,18 @@ TRACE_EVENT(rdev_change_beacon,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->link_id)
 );
 
+DEFINE_EVENT(rdev_ap_update, rdev_change_beacon,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_ap_update *info),
+	TP_ARGS(wiphy, netdev, info)
+);
+
+DEFINE_EVENT(rdev_ap_update, rdev_update_beacon,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_ap_update *info),
+	TP_ARGS(wiphy, netdev, info)
+);
+
 TRACE_EVENT(rdev_stop_ap,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 unsigned int link_id),
-- 
2.55.0

