Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48324 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaK0HpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 02:45:02 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so5667981wgg.35
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 23:45:00 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Jonathan Doron <jond@wizery.com>
Subject: [PATCH v5 3/4] cfg80211: allow wiphy specific regdomain management
Date: Thu, 27 Nov 2014 09:44:57 +0200
Message-Id: <1417074298-12254-3-git-send-email-arik@wizery.com> (sfid-20141127_084509_618457_DD30B2D6)
In-Reply-To: <1417074298-12254-1-git-send-email-arik@wizery.com>
References: <1417074298-12254-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jonathan Doron <jond@wizery.com>

Add a new regulatory flag that allows a driver to manage regdomain
changes/updates for its own wiphy.
A self-managed wiphys only employs regulatory information obtained from
the FW and driver and does not use other cfg80211 sources like
beacon-hints, country-code IEs and hints from other devices on the same
system. Conversely, a self-managed wiphy does not share its regulatory
hints with other devices in the system. If a system contains several
devices, one or more of which are self-managed, there might be
contradictory regulatory settings between them. Usage of flag is
generally discouraged. Only use it if the FW/driver is incompatible
with non-locally originated hints.

A new API lets the driver send a complete regdomain, to be applied on
its wiphy only.

After a wiphy-specific regdomain change takes place, usermode will get
a new type of change notification. The regulatory core also takes care
enforce regulatory restrictions, in case some interfaces are on
forbidden channels.

Signed-off-by: Jonathan Doron <jonathanx.doron@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 include/net/cfg80211.h       | 20 +++++++++++
 include/net/regulatory.h     | 19 ++++++++++
 include/uapi/linux/nl80211.h |  5 +++
 net/wireless/core.c          |  8 +++++
 net/wireless/nl80211.c       | 80 +++++++++++++++++++++++++++++++----------
 net/wireless/nl80211.h       |  1 +
 net/wireless/reg.c           | 84 ++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 199 insertions(+), 18 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb748c4..60f46f6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2971,6 +2971,10 @@ struct wiphy_vendor_command {
  * 	the regulatory_hint() API. This can be used by the driver
  *	on the reg_notifier() if it chooses to ignore future
  *	regulatory domain changes caused by other drivers.
+ * @requested_regd: the driver requests the regulatory core to set this
+ *	regulatory domain as the wiphy's. Only used for
+ *	%REGULATORY_WIPHY_SELF_MANAGED devices using the
+ *	regulatory_set_wiphy_regd() API
  * @signal_type: signal type reported in &struct cfg80211_bss.
  * @cipher_suites: supported cipher suites
  * @n_cipher_suites: number of supported cipher suites
@@ -3183,6 +3187,8 @@ struct wiphy {
 
 	const struct ieee80211_regdomain __rcu *regd;
 
+	const struct ieee80211_regdomain *requested_regd;
+
 	/* the item in /sys/class/ieee80211/ points to this,
 	 * you need use set_wiphy_dev() (see below) */
 	struct device dev;
@@ -3808,6 +3814,20 @@ const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
 int regulatory_hint(struct wiphy *wiphy, const char *alpha2);
 
 /**
+ * regulatory_set_wiphy_regd - set regdom info for self managed drivers
+ * @wiphy: the wireless device we want to process the regulatory domain on
+ * @rd: the regulatory domain informatoin to use for this wiphy
+ *
+ * Set the regulatory domain information for self-managed wiphys, only they
+ * may use this function. See %REGULATORY_WIPHY_SELF_MANAGED for more
+ * information.
+ *
+ * Return: 0 on success. -EINVAL, -EPERM
+ */
+int regulatory_set_wiphy_regd(struct wiphy *wiphy,
+			      struct ieee80211_regdomain *rd);
+
+/**
  * wiphy_apply_custom_regulatory - apply a custom driver regulatory domain
  * @wiphy: the wireless device we want to process the regulatory domain on
  * @regd: the custom regulatory domain to use for this wiphy
diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index b776d72..d72b9a3 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -147,6 +147,24 @@ struct regulatory_request {
  *	NL80211_IFTYPE_P2P_CLIENT, NL80211_IFTYPE_P2P_GO,
  *	NL80211_IFTYPE_P2P_DEVICE. The flag will be set by default if a device
  *	includes any modes unsupported for enforcement checking.
+ * @REGULATORY_WIPHY_SELF_MANAGED: for devices that employ wiphy-specific
+ *	regdom management. These devices will ignore all regdom changes not
+ *	originating from their own wiphy.
+ *	A self-managed wiphys only employs regulatory information obtained from
+ *	the FW and driver and does not use other cfg80211 sources like
+ *	beacon-hints, country-code IEs and hints from other devices on the same
+ *	system. Conversely, a self-managed wiphy does not share its regulatory
+ *	hints with other devices in the system. If a system contains several
+ *	devices, one or more of which are self-managed, there might be
+ *	contradictory regulatory settings between them. Usage of flag is
+ *	generally discouraged. Only use it if the FW/driver is incompatible
+ *	with non-locally originated hints.
+ *	This flag is incompatible with the flags: %REGULATORY_CUSTOM_REG,
+ *	%REGULATORY_STRICT_REG, %REGULATORY_COUNTRY_IE_FOLLOW_POWER,
+ *	%REGULATORY_COUNTRY_IE_IGNORE and %REGULATORY_DISABLE_BEACON_HINTS.
+ *	Mixing any of the above flags with this flag will result in a failure
+ *	to register the wiphy. This flag implies
+ *	%REGULATORY_DISABLE_BEACON_HINTS.
  */
 enum ieee80211_regulatory_flags {
 	REGULATORY_CUSTOM_REG			= BIT(0),
@@ -156,6 +174,7 @@ enum ieee80211_regulatory_flags {
 	REGULATORY_COUNTRY_IE_IGNORE		= BIT(4),
 	REGULATORY_ENABLE_RELAX_NO_IR           = BIT(5),
 	REGULATORY_IGNORE_STALE_KICKOFF         = BIT(6),
+	REGULATORY_WIPHY_SELF_MANAGED		= BIT(7),
 };
 
 struct ieee80211_freq_range {
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1f2f7d6..0143c59 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -776,6 +776,9 @@
  *	peer given by %NL80211_ATTR_MAC. Both peers must be on the base channel
  *	when this command completes.
  *
+ * @NL80211_CMD_WIPHY_REG_CHANGE: Similar to %NL80211_CMD_REG_CHANGE, but used
+ *	for indicating changes for devices with wiphy-specific regdom management
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -960,6 +963,8 @@ enum nl80211_commands {
 	NL80211_CMD_TDLS_CHANNEL_SWITCH,
 	NL80211_CMD_TDLS_CANCEL_CHANNEL_SWITCH,
 
+	NL80211_CMD_WIPHY_REG_CHANGE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index ef0d3a0..1f48d2d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -557,6 +557,14 @@ int wiphy_register(struct wiphy *wiphy)
 	    BIT(NL80211_IFTYPE_MONITOR)))
 		wiphy->regulatory_flags |= REGULATORY_IGNORE_STALE_KICKOFF;
 
+	if (WARN_ON((wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) &&
+		    (wiphy->regulatory_flags &
+		     (REGULATORY_CUSTOM_REG | REGULATORY_STRICT_REG |
+		      REGULATORY_COUNTRY_IE_FOLLOW_POWER |
+		      REGULATORY_COUNTRY_IE_IGNORE |
+		      REGULATORY_DISABLE_BEACON_HINTS))))
+		return -EINVAL;
+
 	if (WARN_ON(wiphy->coalesce &&
 		    (!wiphy->coalesce->n_rules ||
 		     !wiphy->coalesce->n_patterns) &&
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ddee3ba..361a897 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11007,25 +11007,9 @@ void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
 				NL80211_MCGRP_SCAN, GFP_KERNEL);
 }
 
-/*
- * This can happen on global regulatory changes or device specific settings
- * based on custom world regulatory domains.
- */
-void nl80211_send_reg_change_event(struct regulatory_request *request)
+static bool nl80211_reg_change_event_fill(struct sk_buff *msg,
+					  struct regulatory_request *request)
 {
-	struct sk_buff *msg;
-	void *hdr;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return;
-
-	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_REG_CHANGE);
-	if (!hdr) {
-		nlmsg_free(msg);
-		return;
-	}
-
 	/* Userspace can always count this one always being set */
 	if (nla_put_u8(msg, NL80211_ATTR_REG_INITIATOR, request->initiator))
 		goto nla_put_failure;
@@ -11055,6 +11039,66 @@ void nl80211_send_reg_change_event(struct regulatory_request *request)
 	    nla_put_u32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx))
 		goto nla_put_failure;
 
+	return true;
+
+nla_put_failure:
+	return false;
+}
+
+/*
+ * This can happen on global regulatory changes or device specific settings
+ * based on custom world regulatory domains.
+ */
+void nl80211_send_reg_change_event(struct regulatory_request *request)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_REG_CHANGE);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nl80211_reg_change_event_fill(msg, request) == false)
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	rcu_read_lock();
+	genlmsg_multicast_allns(&nl80211_fam, msg, 0,
+				NL80211_MCGRP_REGULATORY, GFP_ATOMIC);
+	rcu_read_unlock();
+
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
+void nl80211_send_wiphy_reg_change_event(struct regulatory_request *request)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_WIPHY_REG_CHANGE);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nl80211_reg_change_event_fill(msg, request) == false)
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 
 	rcu_read_lock();
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 7ad70d6..b91b9c5 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -18,6 +18,7 @@ void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
 void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
 				     struct net_device *netdev);
 void nl80211_send_reg_change_event(struct regulatory_request *request);
+void nl80211_send_wiphy_reg_change_event(struct regulatory_request *request);
 void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
 			  struct net_device *netdev,
 			  const u8 *buf, size_t len, gfp_t gfp);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 48d90da..41badc4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1307,6 +1307,9 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 {
 	struct regulatory_request *lr = get_last_request();
 
+	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+		return true;
+
 	if (!lr) {
 		REG_DBG_PRINT("Ignoring regulatory request set by %s "
 			      "since last_request is not set\n",
@@ -1370,6 +1373,9 @@ static void handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
 	sband = wiphy->bands[reg_beacon->chan.band];
 	chan = &sband->channels[chan_idx];
 
+	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+		return;
+
 	if (likely(chan->center_freq != reg_beacon->chan.center_freq))
 		return;
 
@@ -2147,11 +2153,52 @@ static void reg_process_pending_beacon_hints(void)
 	spin_unlock_bh(&reg_pending_beacons_lock);
 }
 
+static void reg_process_self_managed_hints(void)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wiphy *wiphy;
+	const struct ieee80211_regdomain *tmp;
+	const struct ieee80211_regdomain *regd;
+	enum ieee80211_band band;
+	struct regulatory_request request = {};
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		wiphy = &rdev->wiphy;
+
+		spin_lock(&reg_requests_lock);
+		regd = wiphy->requested_regd;
+		wiphy->requested_regd = NULL;
+		spin_unlock(&reg_requests_lock);
+
+		if (regd == NULL)
+			continue;
+
+		tmp = get_wiphy_regdom(wiphy);
+		rcu_assign_pointer(wiphy->regd, regd);
+		rcu_free_regdom(tmp);
+
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+			handle_band_custom(wiphy, wiphy->bands[band], regd);
+
+		reg_process_ht_flags(wiphy);
+
+		request.wiphy_idx = get_wiphy_idx(wiphy);
+		request.alpha2[0] = regd->alpha2[0];
+		request.alpha2[1] = regd->alpha2[1];
+		request.initiator = NL80211_REGDOM_SET_BY_DRIVER;
+
+		nl80211_send_wiphy_reg_change_event(&request);
+	}
+
+	reg_check_channels();
+}
+
 static void reg_todo(struct work_struct *work)
 {
 	rtnl_lock();
 	reg_process_pending_hints();
 	reg_process_pending_beacon_hints();
+	reg_process_self_managed_hints();
 	rtnl_unlock();
 }
 
@@ -2432,6 +2479,9 @@ static void restore_regulatory_settings(bool reset_user)
 	world_alpha2[1] = cfg80211_world_regdom->alpha2[1];
 
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (rdev->wiphy.regulatory_flags &
+						REGULATORY_WIPHY_SELF_MANAGED)
+			continue;
 		if (rdev->wiphy.regulatory_flags & REGULATORY_CUSTOM_REG)
 			restore_custom_reg_settings(&rdev->wiphy);
 	}
@@ -2835,6 +2885,40 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	return 0;
 }
 
+int regulatory_set_wiphy_regd(struct wiphy *wiphy,
+			      struct ieee80211_regdomain *rd)
+{
+	const struct ieee80211_regdomain *regd;
+	const struct ieee80211_regdomain *prev_regd;
+
+	if (WARN_ON(!wiphy || !rd))
+		return -EINVAL;
+
+	if (WARN(!(wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED),
+		 "wiphy should have REGULATORY_WIPHY_SELF_MANAGED\n"))
+		return -EPERM;
+
+	if (WARN(!is_valid_rd(rd), "Invalid regulatory domain detected\n")) {
+		print_regdomain_info(rd);
+		return -EINVAL;
+	}
+
+	regd = reg_copy_regd(rd);
+	if (IS_ERR(regd))
+		return PTR_ERR(regd);
+
+	spin_lock(&reg_requests_lock);
+	prev_regd = wiphy->requested_regd;
+	wiphy->requested_regd = regd;
+	spin_unlock(&reg_requests_lock);
+
+	kfree(prev_regd);
+
+	schedule_work(&reg_work);
+	return 0;
+}
+EXPORT_SYMBOL(regulatory_set_wiphy_regd);
+
 void wiphy_regulatory_register(struct wiphy *wiphy)
 {
 	struct regulatory_request *lr;
-- 
1.9.1

