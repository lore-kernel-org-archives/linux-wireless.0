Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33446 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZBMFg5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 00:36:57 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 21:36:57 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 6/6] cfg80211: move regulatory hints to workqueue
Date: Thu, 12 Feb 2009 21:36:03 -0800
Message-ID: <1234503363-11014-7-git-send-email-lrodriguez@atheros.com> (sfid-20090213_063702_199989_401C0D74)
In-Reply-To: <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver and userspace regulatory hints are now processed in
a workqueue. This should fix some lockdep warnings which complain
about possible circular locking dependencies such as:

1:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc4-wl-13559-g0416c58-dirty #40
-------------------------------------------------------
iw/4598 is trying to acquire lock:
 (rtnl_mutex){--..}, at: [<ffffffff805013e2>] rtnl_lock+0x12/0x20
 but task is already holding lock:
  (&drv->mtx){--..}, at: [<ffffffffa0352991>] cfg80211_get_dev_from_ifindex+0x61/0xa0 [cfg80211]

2:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc4-wl #7
-------------------------------------------------------
wpa_supplicant/3333 is trying to acquire lock:
 (&ifsta->work){--..}, at: [<ffffffff8025555d>] __cancel_work_timer+0x5d/0x1f0

but task is already holding lock:
 (rtnl_mutex){--..}, at: [<ffffffff804997a6>] devinet_ioctl+0x136/0x7a0

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c      |    8 ++-
 drivers/net/wireless/zd1211rw/zd_mac.c |    6 +-
 include/net/cfg80211.h                 |    2 +
 include/net/wireless.h                 |    9 ++-
 net/wireless/nl80211.c                 |   10 +--
 net/wireless/reg.c                     |  140 +++++++++++++++++++++++++++++---
 net/wireless/reg.h                     |    2 +
 7 files changed, 153 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index fc3460f..f51e7c8 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1656,8 +1656,12 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 
 	error = ieee80211_register_hw(hw);
 
-	if (!ath9k_is_world_regd(sc->sc_ah))
-		regulatory_hint(hw->wiphy, sc->sc_ah->regulatory.alpha2);
+	if (!ath9k_is_world_regd(sc->sc_ah)) {
+		error = regulatory_hint(hw->wiphy,
+			sc->sc_ah->regulatory.alpha2);
+		if (error)
+			goto detach;
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
index 2a83510..ec29843 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -396,6 +396,7 @@ enum environment_cap {
  * 	country IE
  * @country_ie_env: lets us know if the AP is telling us we are outdoor,
  * 	indoor, or if it doesn't matter
+ * @list: used to insert into a linked list
  */
 struct regulatory_request {
 	int wiphy_idx;
@@ -404,6 +405,7 @@ struct regulatory_request {
 	bool intersect;
 	u32 country_ie_checksum;
 	enum environment_cap country_ie_env;
+	struct list_head list;
 };
 
 struct ieee80211_freq_range {
diff --git a/include/net/wireless.h b/include/net/wireless.h
index 1c6285e..afeade9 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -398,8 +398,15 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
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
index 843d26d..fb1c99e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1911,14 +1911,8 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	if (is_world_regdom(data))
 		return -EINVAL;
 #endif
-	mutex_lock(&cfg80211_mutex);
-	r = __regulatory_hint(NULL, REGDOM_SET_BY_USER, data, 0, ENVIRON_ANY);
-	mutex_unlock(&cfg80211_mutex);
-	/* This means the regulatory domain was already set, however
-	 * we don't want to confuse userspace with a "successful error"
-	 * message so lets just treat it as a success */
-	if (r == -EALREADY)
-		r = 0;
+	r = regulatory_hint_user(data);
+
 	return r;
 }
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 316b2e4..78ff554 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -64,6 +64,18 @@ const struct ieee80211_regdomain *cfg80211_regdomain;
  * what it thinks should apply for the same country */
 static const struct ieee80211_regdomain *country_ie_regdomain;
 
+static LIST_HEAD(reg_requests_list);
+static DEFINE_MUTEX(reg_mutex);
+
+static void reg_process_pending_hints(void);
+
+static void reg_todo(struct work_struct *work)
+{
+	reg_process_pending_hints();
+}
+
+static DECLARE_WORK(reg_work, reg_todo);
+
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 1,
@@ -829,7 +841,7 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	const struct ieee80211_power_rule *power_rule = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
-	struct wiphy *request_wiphy;
+	struct wiphy *request_wiphy = NULL;
 
 	assert_cfg80211_lock();
 
@@ -1206,21 +1218,66 @@ new_request:
 	return call_crda(alpha2);
 }
 
-void regulatory_hint(struct wiphy *wiphy, const char *alpha2)
+/* This currently queues driver and user hints */
+static void queue_regulatory_request(struct regulatory_request *request)
 {
-	int r;
+	mutex_lock(&reg_mutex);
+	list_add_tail(&request->list, &reg_requests_list);
+	mutex_unlock(&reg_mutex);
+
+	schedule_work(&reg_work);
+}
+
+/* Driver hints */
+int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
+{
+	struct regulatory_request *request;
+
 	BUG_ON(!alpha2);
+	BUG_ON(!wiphy);
 
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
+	request->wiphy_idx = wiphy_idx(wiphy);
+
+	/* Must have registered wiphy first */
+	BUG_ON(!wiphy_idx_valid(request->wiphy_idx));
+
+	request->alpha2[0] = alpha2[0];
+	request->alpha2[1] = alpha2[1];
+	request->initiator = REGDOM_SET_BY_DRIVER;
+	request->country_ie_env = ENVIRON_ANY;
+
+	queue_regulatory_request(request);
+
+	return 0;
 }
 EXPORT_SYMBOL(regulatory_hint);
 
+/* User hints */
+int regulatory_hint_user(const char *alpha2)
+{
+	struct regulatory_request *request;
+
+	BUG_ON(!alpha2);
+
+	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+
+	request->wiphy_idx = WIPHY_IDX_STALE;
+	request->alpha2[0] = alpha2[0];
+	request->alpha2[1] = alpha2[1];
+	request->initiator = REGDOM_SET_BY_USER,
+	request->country_ie_env = ENVIRON_ANY;
+
+	queue_regulatory_request(request);
+
+	return 0;
+}
+
 static bool reg_same_country_ie_hint(struct wiphy *wiphy,
 			u32 country_ie_checksum)
 {
@@ -1620,6 +1677,58 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	return r;
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
+	r = __regulatory_hint(wiphy, reg_request->initiator,
+		reg_request->alpha2, 0, reg_request->country_ie_env);
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
+	struct regulatory_request *reg_request, *tmp;
+	int r;
+
+	mutex_lock(&reg_mutex);
+	list_for_each_entry_safe(reg_request, tmp, &reg_requests_list, list) {
+		r = reg_process_hint(reg_request);
+		if (r)
+			printk(KERN_ERR "cfg80211: wiphy_idx %d sent a "
+				"regulatory hint but now has gone fishing, "
+				"ignoring request\n", reg_request->wiphy_idx);
+		list_del(&reg_request->list);
+		kfree(reg_request);
+	}
+	mutex_unlock(&reg_mutex);
+}
+
+
 /* Caller must hold cfg80211_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
@@ -1673,6 +1782,11 @@ int regulatory_init(void)
 
 void regulatory_exit(void)
 {
+	struct regulatory_request *reg_request, *tmp;
+
+	cancel_work_sync(&reg_work);
+
+	mutex_lock(&reg_mutex);
 	mutex_lock(&cfg80211_mutex);
 
 	reset_regdomains();
@@ -1684,5 +1798,11 @@ void regulatory_exit(void)
 
 	platform_device_unregister(reg_pdev);
 
+	list_for_each_entry_safe(reg_request, tmp, &reg_requests_list, list) {
+		list_del(&reg_request->list);
+		kfree(reg_request);
+	}
+
 	mutex_unlock(&cfg80211_mutex);
+	mutex_unlock(&reg_mutex);
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
1.6.1.2.253.ga34a

