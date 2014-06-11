Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57074 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbaFKGzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 02:55:33 -0400
Received: by mail-wg0-f47.google.com with SMTP id k14so7604206wgh.30
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 23:55:32 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/5] cfg80211: allow drivers to provide regulatory settings
Date: Wed, 11 Jun 2014 09:55:21 +0300
Message-Id: <1402469724-22358-2-git-send-email-arik@wizery.com> (sfid-20140611_085538_122888_471F54BE)
In-Reply-To: <1402469724-22358-1-git-send-email-arik@wizery.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define a new wiphy callback allowing drivers to provide regulatory
settings.

Only The first wiphy registered with this callback will be able to provide
regulatory domain info. If such a wiphy exists, it takes precedence over
other data sources.

Change-Id: If8f8faf1d127120ae464b45098c5edbc5aee3dc0
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/32858
Tested-by: IWL Jenkins
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 16 +++++++++++++
 net/wireless/reg.c     | 65 +++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5c17b1f..b8f0269 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2950,6 +2950,19 @@ struct wiphy_vendor_command {
  *	low rssi when a frame is heard on different channel, then it should set
  *	this variable to the maximal offset for which it can compensate.
  *	This value should be set in MHz.
+ * @get_regd: a driver callback to for publishing regulatory information.
+ *	By implementing this callback, a wiphy indicates it will provide
+ *	regulatory information. The callback must be set before the wiphy is
+ *	is registered. Only the first wiphy with this callback will be called
+ *	to provide a regdomain on country-code changes.
+ *	Returns A driver allocated regdomain structure. The alpha2 in the
+ *	returned regdomain can be different from the one given via the alpha2
+ *	argument, if the argument contains "99", meaning unknown.
+ *	If an ERR_PTR is returned the regulatory core will consult other
+ *	sources for the regdomain info (internal regdb and CRDA). Returning
+ *	NULL will cause the regdomain to remain the same. The callee will
+ *	return a struct allocated with kmalloc(). After the struct is returned,
+ *	the regulatory core is responsible for freeing it.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3033,6 +3046,9 @@ struct wiphy {
 	void (*reg_notifier)(struct wiphy *wiphy,
 			     struct regulatory_request *request);
 
+	struct ieee80211_regdomain * (*get_regd)(struct wiphy *wiphy,
+						 const char *alpha2);
+
 	/* fields below are read-only, assigned by cfg80211 */
 
 	const struct ieee80211_regdomain __rcu *regd;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index efd6d0d..e2f33d7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -78,6 +78,8 @@
  *	further processing is required, i.e., not need to update last_request
  *	etc. This should be used for user hints that do not provide an alpha2
  *	but some other type of regulatory hint, i.e., indoor operation.
+ * @REG_REQ_HANDLED: a request was handled synchronously. No need to set
+ *	timeouts and potentially revert to the default settings.
  */
 enum reg_request_treatment {
 	REG_REQ_OK,
@@ -85,6 +87,7 @@ enum reg_request_treatment {
 	REG_REQ_INTERSECT,
 	REG_REQ_ALREADY_SET,
 	REG_REQ_USER_HINT_HANDLED,
+	REG_REQ_HANDLED,
 };
 
 static struct regulatory_request core_request_world = {
@@ -129,6 +132,15 @@ static int reg_num_devs_support_basehint;
  */
 static bool reg_is_indoor;
 
+/*
+ * Wiphy with a get_regd() callback that can provide regulatory information
+ * when the country code changes. Only the first wiphy registered with the
+ * get_regd callback will be called to provide a regdomain on country-code
+ * changes.
+ * (protected by RTNL)
+ */
+static struct wiphy *regd_info_wiphy;
+
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
 	return rtnl_dereference(cfg80211_regdomain);
@@ -538,9 +550,39 @@ static int call_crda(const char *alpha2)
 	return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, env);
 }
 
+static int call_wiphy_regd_info(const char *alpha2)
+{
+	struct ieee80211_regdomain *regd;
+
+	if (!regd_info_wiphy)
+		return -ENOENT;
+
+	/* can happen if the driver removes the callback at runtime */
+	if (WARN_ON(!regd_info_wiphy->get_regd))
+		return -EINVAL;
+
+	regd = regd_info_wiphy->get_regd(regd_info_wiphy, alpha2);
+	if (IS_ERR(regd))
+		return -EIO;
+
+	if (regd)
+		set_regdom(regd);
+
+	return 0;
+}
+
 static enum reg_request_treatment
-reg_call_crda(struct regulatory_request *request)
+reg_get_regdom_data(struct regulatory_request *request)
 {
+	ASSERT_RTNL();
+
+	/*
+	 * A wiphy wishing to set the regdomain takes precedence. Note the
+	 * regdomain setting happens synchronously inside.
+	 */
+	if (!call_wiphy_regd_info(request->alpha2))
+		return REG_REQ_HANDLED;
+
 	if (call_crda(request->alpha2))
 		return REG_REQ_IGNORE;
 	return REG_REQ_OK;
@@ -1641,7 +1683,7 @@ reg_process_hint_core(struct regulatory_request *core_request)
 
 	reg_update_last_request(core_request);
 
-	return reg_call_crda(core_request);
+	return reg_get_regdom_data(core_request);
 }
 
 static enum reg_request_treatment
@@ -1715,7 +1757,7 @@ reg_process_hint_user(struct regulatory_request *user_request)
 	user_alpha2[0] = user_request->alpha2[0];
 	user_alpha2[1] = user_request->alpha2[1];
 
-	return reg_call_crda(user_request);
+	return reg_get_regdom_data(user_request);
 }
 
 static enum reg_request_treatment
@@ -1764,6 +1806,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		break;
 	case REG_REQ_IGNORE:
 	case REG_REQ_USER_HINT_HANDLED:
+	case REG_REQ_HANDLED:
 		reg_free_request(driver_request);
 		return treatment;
 	case REG_REQ_INTERSECT:
@@ -1794,7 +1837,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		return treatment;
 	}
 
-	return reg_call_crda(driver_request);
+	return reg_get_regdom_data(driver_request);
 }
 
 static enum reg_request_treatment
@@ -1864,6 +1907,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 		break;
 	case REG_REQ_IGNORE:
 	case REG_REQ_USER_HINT_HANDLED:
+	case REG_REQ_HANDLED:
 		/* fall through */
 	case REG_REQ_ALREADY_SET:
 		reg_free_request(country_ie_request);
@@ -1883,7 +1927,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 
 	reg_update_last_request(country_ie_request);
 
-	return reg_call_crda(country_ie_request);
+	return reg_get_regdom_data(country_ie_request);
 }
 
 /* This processes *all* regulatory hints */
@@ -1903,7 +1947,8 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		treatment = reg_process_hint_user(reg_request);
 		if (treatment == REG_REQ_IGNORE ||
 		    treatment == REG_REQ_ALREADY_SET ||
-		    treatment == REG_REQ_USER_HINT_HANDLED)
+		    treatment == REG_REQ_USER_HINT_HANDLED ||
+		    treatment == REG_REQ_HANDLED)
 			return;
 		queue_delayed_work(system_power_efficient_wq,
 				   &reg_timeout, msecs_to_jiffies(3142));
@@ -2684,6 +2729,9 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 {
 	struct regulatory_request *lr;
 
+	if (wiphy->get_regd && !regd_info_wiphy)
+		regd_info_wiphy = wiphy;
+
 	if (!reg_dev_ignore_cell_hint(wiphy))
 		reg_num_devs_support_basehint++;
 
@@ -2696,6 +2744,8 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 	struct wiphy *request_wiphy = NULL;
 	struct regulatory_request *lr;
 
+	ASSERT_RTNL();
+
 	lr = get_last_request();
 
 	if (!reg_dev_ignore_cell_hint(wiphy))
@@ -2704,6 +2754,9 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 	rcu_free_regdom(get_wiphy_regdom(wiphy));
 	RCU_INIT_POINTER(wiphy->regd, NULL);
 
+	if (wiphy == regd_info_wiphy)
+		regd_info_wiphy = NULL;
+
 	if (lr)
 		request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
-- 
1.9.1

