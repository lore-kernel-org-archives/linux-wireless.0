Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZBTFnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 00:43:18 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 12/15] cfg80211: move all regulatory hints to workqueue
Date: Fri, 20 Feb 2009 00:42:47 -0500
Message-Id: <1235108570-17652-13-git-send-email-lrodriguez@atheros.com> (sfid-20090220_065319_562808_FF09F24E)
In-Reply-To: <1235108570-17652-1-git-send-email-lrodriguez@atheros.com>
References: <1235108570-17652-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All regulatory hints (core, driver, userspace and 11d) are now processed in
a workqueue.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c      |    8 +-
 drivers/net/wireless/zd1211rw/zd_mac.c |    6 +-
 include/net/cfg80211.h                 |    2 +
 include/net/wireless.h                 |    9 ++-
 net/wireless/nl80211.c                 |   30 ++----
 net/wireless/reg.c                     |  178 +++++++++++++++++++++++++++++---
 net/wireless/reg.h                     |    2 +
 7 files changed, 194 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7264c4c..9079d32 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1659,8 +1659,12 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 
 	error = ieee80211_register_hw(hw);
 
-	if (!ath9k_is_world_regd(sc->sc_ah))
-		regulatory_hint(hw->wiphy, sc->sc_ah->regulatory.alpha2);
+	if (!ath9k_is_world_regd(sc->sc_ah)) {
+		error = regulatory_hint(hw->wiphy,
+			sc->sc_ah->regulatory.alpha2);
+		if (error)
+			goto error_attach;
+	}
 
 	/* Initialize LED control */
 	ath_init_leds(sc);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 7579af2..da9214e 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -170,10 +170,10 @@ int zd_mac_init_hw(struct ieee80211_hw *hw)
 		goto disable_int;
 
 	r = zd_reg2alpha2(mac->regdomain, alpha2);
-	if (!r)
-		regulatory_hint(hw->wiphy, alpha2);
+	if (r)
+		goto disable_int;
 
-	r = 0;
+	r = regulatory_hint(hw->wiphy, alpha2);
 disable_int:
 	zd_chip_disable_int(chip);
 out:
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb9129f..75fa556 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -404,6 +404,7 @@ enum environment_cap {
  * 	country IE
  * @country_ie_env: lets us know if the AP is telling us we are outdoor,
  * 	indoor, or if it doesn't matter
+ * @list: used to insert into the reg_requests_list linked list
  */
 struct regulatory_request {
 	int wiphy_idx;
@@ -412,6 +413,7 @@ struct regulatory_request {
 	bool intersect;
 	u32 country_ie_checksum;
 	enum environment_cap country_ie_env;
+	struct list_head list;
 };
 
 struct ieee80211_freq_range {
diff --git a/include/net/wireless.h b/include/net/wireless.h
index d815aa8..1f4707d 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -401,8 +401,15 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
  * domain should be in or by providing a completely build regulatory domain.
  * If the driver provides an ISO/IEC 3166 alpha2 userspace will be queried
  * for a regulatory domain structure for the respective country.
+ *
+ * The wiphy must have been registered to cfg80211 prior to this call.
+ * For cfg80211 drivers this means you must first use wiphy_register(),
+ * for mac80211 drivers you must first use ieee80211_register_hw().
+ *
+ * Drivers should check the return value, its possible you can get
+ * an -ENOMEM.
  */
-extern void regulatory_hint(struct wiphy *wiphy, const char *alpha2);
+extern int regulatory_hint(struct wiphy *wiphy, const char *alpha2);
 
 /**
  * regulatory_hint_11d - hints a country IE as a regulatory domain
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0b8f811..737927b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1891,34 +1891,24 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	 */
 	mutex_lock(&cfg80211_mutex);
 	if (unlikely(!cfg80211_regdomain)) {
-		r = -EINPROGRESS;
-		goto out;
+		mutex_unlock(&cfg80211_mutex);
+		return -EINPROGRESS;
 	}
+	mutex_unlock(&cfg80211_mutex);
 
-	if (!info->attrs[NL80211_ATTR_REG_ALPHA2]) {
-		r = -EINVAL;
-		goto out;
-	}
+	if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
+		return -EINVAL;
 
 	data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
 
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
 	/* We ignore world regdom requests with the old regdom setup */
-	if (is_world_regdom(data)) {
-		r = -EINVAL;
-		goto out;
-	}
+	if (is_world_regdom(data))
+		return -EINVAL;
 #endif
-	r = __regulatory_hint(NULL, REGDOM_SET_BY_USER, data, 0, ENVIRON_ANY);
-	/*
-	 * This means the regulatory domain was already set, however
-	 * we don't want to confuse userspace with a "successful error"
-	 * message so lets just treat it as a success
-	 */
-	if (r == -EALREADY)
-		r = 0;
-out:
-	mutex_unlock(&cfg80211_mutex);
+
+	r = regulatory_hint_user(data);
+
 	return r;
 }
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index af762be..0e0eb6a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -64,6 +64,9 @@ const struct ieee80211_regdomain *cfg80211_regdomain;
  * what it thinks should apply for the same country */
 static const struct ieee80211_regdomain *country_ie_regdomain;
 
+static LIST_HEAD(reg_requests_list);
+static spinlock_t reg_requests_lock;
+
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 1,
@@ -831,7 +834,7 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	const struct ieee80211_power_rule *power_rule = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
-	struct wiphy *request_wiphy;
+	struct wiphy *request_wiphy = NULL;
 
 	assert_cfg80211_lock();
 
@@ -1195,6 +1198,89 @@ new_request:
 	return call_crda(alpha2);
 }
 
+/* This currently only processes user and driver regulatory hints */
+static int reg_process_hint(struct regulatory_request *reg_request)
+{
+	int r = 0;
+	struct wiphy *wiphy = NULL;
+
+	BUG_ON(!reg_request->alpha2);
+
+	mutex_lock(&cfg80211_mutex);
+
+	if (wiphy_idx_valid(reg_request->wiphy_idx))
+		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
+
+	if (reg_request->initiator == REGDOM_SET_BY_DRIVER &&
+	    !wiphy) {
+		r = -ENODEV;
+		goto out;
+	}
+
+	r = __regulatory_hint(wiphy,
+			      reg_request->initiator,
+			      reg_request->alpha2,
+			      reg_request->country_ie_checksum,
+			      reg_request->country_ie_env);
+	/* This is required so that the orig_* parameters are saved */
+	if (r == -EALREADY && wiphy->strict_regulatory)
+		wiphy_update_regulatory(wiphy, reg_request->initiator);
+out:
+	mutex_unlock(&cfg80211_mutex);
+
+	if (r == -EALREADY)
+		r = 0;
+
+	return r;
+}
+
+static void reg_process_pending_hints(void)
+	{
+	struct regulatory_request *reg_request;
+	int r;
+
+	spin_lock(&reg_requests_lock);
+	while (!list_empty(&reg_requests_list)) {
+		reg_request = list_first_entry(&reg_requests_list,
+					       struct regulatory_request,
+					       list);
+		list_del_init(&reg_request->list);
+		spin_unlock(&reg_requests_lock);
+
+		r = reg_process_hint(reg_request);
+#ifdef CONFIG_CFG80211_REG_DEBUG
+		if (r && (reg_request->initiator == REGDOM_SET_BY_DRIVER ||
+		    reg_request->initiator == REGDOM_SET_BY_COUNTRY_IE))
+			printk(KERN_ERR "cfg80211: wiphy_idx %d sent a "
+				"regulatory hint for %c%c but now has "
+				"gone fishing, ignoring request\n",
+				reg_request->wiphy_idx,
+				reg_request->alpha2[0],
+				reg_request->alpha2[1]);
+#endif
+		kfree(reg_request);
+		spin_lock(&reg_requests_lock);
+	}
+	spin_unlock(&reg_requests_lock);
+}
+
+static void reg_todo(struct work_struct *work)
+{
+	reg_process_pending_hints();
+}
+
+static DECLARE_WORK(reg_work, reg_todo);
+
+static void queue_regulatory_request(struct regulatory_request *request)
+{
+	spin_lock(&reg_requests_lock);
+	list_add_tail(&request->list, &reg_requests_list);
+	spin_unlock(&reg_requests_lock);
+
+	schedule_work(&reg_work);
+}
+
+/* Core regulatory hint -- happens once during cfg80211_init() */
 static int regulatory_hint_core(const char *alpha2)
 {
 	struct regulatory_request *request;
@@ -1210,23 +1296,56 @@ static int regulatory_hint_core(const char *alpha2)
 	request->alpha2[1] = alpha2[1];
 	request->initiator = REGDOM_SET_BY_CORE;
 
-	last_request = request;
+	queue_regulatory_request(request);
 
-	return call_crda(alpha2);
+	return 0;
 }
 
-void regulatory_hint(struct wiphy *wiphy, const char *alpha2)
+/* User hints */
+int regulatory_hint_user(const char *alpha2)
 {
-	int r;
+	struct regulatory_request *request;
+
 	BUG_ON(!alpha2);
 
-	mutex_lock(&cfg80211_mutex);
-	r = __regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER,
-		alpha2, 0, ENVIRON_ANY);
-	/* This is required so that the orig_* parameters are saved */
-	if (r == -EALREADY && wiphy->strict_regulatory)
-		wiphy_update_regulatory(wiphy, REGDOM_SET_BY_DRIVER);
-	mutex_unlock(&cfg80211_mutex);
+	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+
+	request->wiphy_idx = WIPHY_IDX_STALE;
+	request->alpha2[0] = alpha2[0];
+	request->alpha2[1] = alpha2[1];
+	request->initiator = REGDOM_SET_BY_USER,
+
+	queue_regulatory_request(request);
+
+	return 0;
+}
+
+/* Driver hints */
+int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
+{
+	struct regulatory_request *request;
+
+	BUG_ON(!alpha2);
+	BUG_ON(!wiphy);
+
+	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+
+	request->wiphy_idx = get_wiphy_idx(wiphy);
+
+	/* Must have registered wiphy first */
+	BUG_ON(!wiphy_idx_valid(request->wiphy_idx));
+
+	request->alpha2[0] = alpha2[0];
+	request->alpha2[1] = alpha2[1];
+	request->initiator = REGDOM_SET_BY_DRIVER;
+
+	queue_regulatory_request(request);
+
+	return 0;
 }
 EXPORT_SYMBOL(regulatory_hint);
 
@@ -1260,6 +1379,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	char alpha2[2];
 	u32 checksum = 0;
 	enum environment_cap env = ENVIRON_ANY;
+	struct regulatory_request *request;
 
 	mutex_lock(&cfg80211_mutex);
 
@@ -1343,14 +1463,26 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	if (WARN_ON(reg_same_country_ie_hint(wiphy, checksum)))
 		goto free_rd_out;
 
+	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
+	if (!request)
+		goto free_rd_out;
+
 	/* We keep this around for when CRDA comes back with a response so
 	 * we can intersect with that */
 	country_ie_regdomain = rd;
 
-	__regulatory_hint(wiphy, REGDOM_SET_BY_COUNTRY_IE,
-		country_ie_regdomain->alpha2, checksum, env);
+	request->wiphy_idx = get_wiphy_idx(wiphy);
+	request->alpha2[0] = rd->alpha2[0];
+	request->alpha2[1] = rd->alpha2[1];
+	request->initiator = REGDOM_SET_BY_COUNTRY_IE;
+	request->country_ie_checksum = checksum;
+	request->country_ie_env = env;
+
+	mutex_unlock(&cfg80211_mutex);
+
+	queue_regulatory_request(request);
 
-	goto out;
+	return;
 
 free_rd_out:
 	kfree(rd);
@@ -1661,6 +1793,8 @@ int regulatory_init(void)
 	if (IS_ERR(reg_pdev))
 		return PTR_ERR(reg_pdev);
 
+	spin_lock_init(&reg_requests_lock);
+
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
 	cfg80211_regdomain = static_regdom(ieee80211_regdom);
 
@@ -1700,6 +1834,10 @@ int regulatory_init(void)
 
 void regulatory_exit(void)
 {
+	struct regulatory_request *reg_request, *tmp;
+
+	cancel_work_sync(&reg_work);
+
 	mutex_lock(&cfg80211_mutex);
 
 	reset_regdomains();
@@ -1711,5 +1849,15 @@ void regulatory_exit(void)
 
 	platform_device_unregister(reg_pdev);
 
+	spin_lock(&reg_requests_lock);
+	if (!list_empty(&reg_requests_list)) {
+		list_for_each_entry_safe(reg_request, tmp,
+					 &reg_requests_list, list) {
+			list_del(&reg_request->list);
+			kfree(reg_request);
+		}
+	}
+	spin_unlock(&reg_requests_lock);
+
 	mutex_unlock(&cfg80211_mutex);
 }
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index fe8c83f..4730def 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -6,6 +6,8 @@ extern const struct ieee80211_regdomain *cfg80211_regdomain;
 bool is_world_regdom(const char *alpha2);
 bool reg_is_valid_request(const char *alpha2);
 
+int regulatory_hint_user(const char *alpha2);
+
 void reg_device_remove(struct wiphy *wiphy);
 
 int regulatory_init(void);
-- 
1.6.0.3

