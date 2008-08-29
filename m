Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39817 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbYH2RSG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 13:18:06 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] cfg80211: Check regulatory hints a bit more carefully
Date: Fri, 29 Aug 2008 10:17:57 -0700
Message-ID: <1220030278-6088-4-git-send-email-lrodriguez@atheros.com> (sfid-20080829_191811_988328_CC2F3C87)
In-Reply-To: <1220030278-6088-3-git-send-email-lrodriguez@atheros.com>
References: <1220030278-6088-1-git-send-email-lrodriguez@atheros.com>
 <1220030278-6088-2-git-send-email-lrodriguez@atheros.com>
 <1220030278-6088-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds some initial elaborate checks when setting
the regulatory domain. Right now we only support setting
the regulatory domain by the driver and the wireless core,
however, this will grow soon to allow users to set the
regulatory domain and the wireless stack for Country IEs
when using devices which are capable of world roaming.

This adds a sort of state machine check for all the possible
scenerios when a regulatory domain can be set and informs
the core whether it is allowed or not.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |   13 ++++++
 net/wireless/reg.c     |  110 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 117 insertions(+), 6 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index 4b947c2..24afa80 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -338,6 +338,17 @@ extern struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
  * what it believes should be the current regulatory domain by
  * giving it an ISO/IEC 3166 alpha2 country code it knows its regulatory
  * domain should be in or by providing a completely build regulatory domain.
+ *
+ * Returns -EALREADY if *a regulatory domain* has already been set. Note that
+ * this could be by another driver. It is safe for drivers to continue if
+ * -EALREADY is returned, if drivers are not capable of world roaming they
+ * should not register more channels than they support. Right now we only
+ * support listening to the first driver hint. If the driver is capable
+ * of world roaming but wants to respect its own EEPROM mappings for
+ * specific regulatory domains it should register the @reg_notifier callback
+ * on the &struct wiphy. Returns 0 if the hint went through fine or through an
+ * intersection operation. Otherwise a standard error code is returned.
+ *
  */
 extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 		const char *alpha2, struct ieee80211_regdomain *rd);
@@ -355,6 +366,8 @@ extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
  * domain should be in or by providing a completely build regulatory domain.
  * If the driver provides an ISO/IEC 3166 alpha2 userspace will be queried
  * for a regulatory domain structure for the respective country.
+ *
+ * See __regulatory_hint() documentation for possible return values.
  */
 extern int regulatory_hint(struct wiphy *wiphy,
 		const char *alpha2, struct ieee80211_regdomain *rd);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8838a6f..17d0e8f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -129,6 +129,95 @@ static int call_crda(const char *alpha2)
 	return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, envp);
 }
 
+/* This has the logic which determines when a new request
+ * should be ignored. Must hold cfg80211_reg_mutex */
+static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
+	char *alpha2, struct ieee80211_regdomain *rd)
+{
+	struct regulatory_request *last_request = NULL;
+
+	/* All initial requests are respected */
+	if (list_empty(&regulatory_requests))
+		return 0;
+
+	last_request = list_first_entry(&regulatory_requests,
+		struct regulatory_request, list);
+
+	switch (set_by) {
+	case REGDOM_SET_BY_INIT:
+		return -EINVAL;
+	case REGDOM_SET_BY_CORE:
+		/* Always respect new wireless core hints, should only
+		 * come in for updating the world regulatory domain at init
+		 * anyway */
+		return 0;
+	case REGDOM_SET_BY_80211D:
+		if (last_request->initiator == set_by) {
+			if (last_request->wiphy != wiphy) {
+				/* Two cards with two APs claiming different
+				 * different Country IE alpha2s!
+				 * You're special!! */
+				if (!alpha2_equal(last_request->alpha2,
+						cfg80211_regdomain->alpha2)) {
+					/* XXX: Deal with conflict, consider
+					 * building a new one out of the
+					 * intersection */
+					WARN_ON(1);
+					return -EOPNOTSUPP;
+				}
+				return -EALREADY;
+			}
+			/* Two consecutive Country IE hints on the same wiphy */
+			if (!alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+				return 0;
+			return -EALREADY;
+		}
+		if (WARN_ON(!is_alpha2_set(alpha2) || !is_an_alpha2(alpha2)),
+				"Invalid Country IE regulatory hint passed "
+				"to the wireless core\n")
+			return -EINVAL;
+		/* We ignore Country IE hints for now, as we haven't yet
+		 * added the dot11MultiDomainCapabilityEnabled flag
+		 * for wiphys */
+		return 1;
+	case REGDOM_SET_BY_DRIVER:
+		BUG_ON(!wiphy);
+		if (last_request->initiator == set_by) {
+			/* Two separate drivers hinting different things,
+			 * this is possible if you have two devices present
+			 * on a system with different EEPROM regulatory
+			 * readings. XXX: Do intersection, we support only
+			 * the first regulatory hint for now */
+			if (last_request->wiphy != wiphy)
+				return -EALREADY;
+			if (last_request->wiphy == wiphy) {
+				if (rd)
+					return -EALREADY;
+				if (alpha2_equal(alpha2,
+						cfg80211_regdomain->alpha2))
+					return -EALREADY;
+				/* Driver should not be trying to hint
+				 * different regulatory domains! */
+				BUG_ON(!alpha2_equal(alpha2,
+						cfg80211_regdomain->alpha2));
+				return -EALREADY;
+			}
+		}
+		if (last_request->initiator == REGDOM_SET_BY_CORE)
+			return 0;
+		/* XXX: Handle intersection, and add the
+		 * dot11MultiDomainCapabilityEnabled flag to wiphy. For now
+		 * we assume the driver has this set to false, following the
+		 * 802.11d dot11MultiDomainCapabilityEnabled documentation */
+		if (last_request->initiator == REGDOM_SET_BY_80211D)
+			return 0;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+/* If a wiphy is passed the caller hold &cfg80211_drv_mutex */
 int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 		      const char *alpha2, struct ieee80211_regdomain *rd)
 {
@@ -136,6 +225,14 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 	char *rd_alpha2;
 	int r = 0;
 
+	mutex_lock(&cfg80211_reg_mutex);
+	r = ignore_request(wiphy, set_by, (char *) alpha2, rd);
+	if (r) {
+		mutex_unlock(&cfg80211_reg_mutex);
+		return r;
+	}
+	mutex_unlock(&cfg80211_reg_mutex);
+
 	if (rd)
 		rd_alpha2 = rd->alpha2;
 	else
@@ -143,9 +240,8 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 
 	switch (set_by) {
 	case REGDOM_SET_BY_CORE:
-	case REGDOM_SET_BY_DRIVER:
-	/* we may do this differently eventually */
 	case REGDOM_SET_BY_80211D:
+	case REGDOM_SET_BY_DRIVER:
 		request = kzalloc(sizeof(struct regulatory_request),
 			GFP_KERNEL);
 		if (!request)
@@ -182,8 +278,12 @@ EXPORT_SYMBOL(__regulatory_hint);
 int regulatory_hint(struct wiphy *wiphy, const char *alpha2,
 	struct ieee80211_regdomain *rd)
 {
+	int r;
 	BUG_ON(!rd && !alpha2);
-	return __regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER, alpha2, rd);
+	mutex_lock(&cfg80211_drv_mutex);
+	r = __regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER, alpha2, rd);
+	mutex_unlock(&cfg80211_drv_mutex);
+	return r;
 }
 EXPORT_SYMBOL(regulatory_hint);
 
@@ -466,9 +566,7 @@ int set_regdom(struct ieee80211_regdomain *rd)
 
 	reset_regdomains();
 
-	/* We only support the setting the regulatory domain by the driver or
-	 * core for a dynamic world regualtory domain right now. Country IE
-	 * parsing coming soon */
+	/* User setting and Country IE parsing coming soon */
 	switch (request->initiator) {
 	case REGDOM_SET_BY_CORE:
 	case REGDOM_SET_BY_DRIVER:
-- 
1.5.6.4

