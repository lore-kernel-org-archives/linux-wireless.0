Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44219 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYJUKat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 06:30:49 -0400
Subject: [PATCH] wireless: remove struct regdom hinting
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 12:30:42 +0200
Message-Id: <1224585042.5521.7.camel@johannes.berg> (sfid-20081021_123054_310885_86F4CE07)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code needs to be split out and cleaned up, so as a
first step remove the capability, to add it back in a
subsequent patch as a separate function. Also remove the
publically facing return value of the function and the
wiphy argument.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    2 -
 include/net/wireless.h                 |   22 +-----------
 net/wireless/nl80211.c                 |    2 -
 net/wireless/reg.c                     |   60 +++++++--------------------------
 net/wireless/reg.h                     |   23 +++---------
 5 files changed, 24 insertions(+), 85 deletions(-)

--- everything.orig/include/net/wireless.h	2008-10-21 11:13:57.000000000 +0200
+++ everything/include/net/wireless.h	2008-10-21 11:50:01.000000000 +0200
@@ -342,35 +342,17 @@ ieee80211_get_channel(struct wiphy *wiph
 
 /**
  * regulatory_hint - driver hint to the wireless core a regulatory domain
- * @wiphy: the driver's very own &struct wiphy
  * @alpha2: the ISO/IEC 3166 alpha2 the driver claims its regulatory domain
  * 	should be in. If @rd is set this should be NULL. Note that if you
  * 	set this to NULL you should still set rd->alpha2 to some accepted
  * 	alpha2.
- * @rd: a complete regulatory domain provided by the driver. If passed
- * 	the driver does not need to worry about freeing it.
  *
  * Wireless drivers can use this function to hint to the wireless core
  * what it believes should be the current regulatory domain by
  * giving it an ISO/IEC 3166 alpha2 country code it knows its regulatory
  * domain should be in or by providing a completely build regulatory domain.
  * If the driver provides an ISO/IEC 3166 alpha2 userspace will be queried
- * for a regulatory domain structure for the respective country. If
- * a regulatory domain is build and passed you should set the alpha2
- * if possible, otherwise set it to the special value of "99" which tells
- * the wireless core it is unknown. If you pass a built regulatory domain
- * and we return non zero you are in charge of kfree()'ing the structure.
- *
- * Returns -EALREADY if *a regulatory domain* has already been set. Note that
- * this could be by another driver. It is safe for drivers to continue if
- * -EALREADY is returned, if drivers are not capable of world roaming they
- * should not register more channels than they support. Right now we only
- * support listening to the first driver hint. If the driver is capable
- * of world roaming but wants to respect its own EEPROM mappings for
- * specific regulatory domains it should register the @reg_notifier callback
- * on the &struct wiphy. Returns 0 if the hint went through fine or through an
- * intersection operation. Otherwise a standard error code is returned.
+ * for a regulatory domain structure for the respective country.
  */
-extern int regulatory_hint(struct wiphy *wiphy,
-		const char *alpha2, struct ieee80211_regdomain *rd);
+extern void regulatory_hint(const char *alpha2);
 #endif /* __NET_WIRELESS_H */
--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2008-10-21 11:15:28.000000000 +0200
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.c	2008-10-21 11:42:12.000000000 +0200
@@ -171,7 +171,7 @@ int zd_mac_init_hw(struct ieee80211_hw *
 
 	r = zd_reg2alpha2(mac->regdomain, alpha2);
 	if (!r)
-		regulatory_hint(hw->wiphy, alpha2, NULL);
+		regulatory_hint(alpha2);
 
 	r = 0;
 disable_int:
--- everything.orig/net/wireless/nl80211.c	2008-10-21 11:20:23.000000000 +0200
+++ everything/net/wireless/nl80211.c	2008-10-21 11:20:26.000000000 +0200
@@ -1693,7 +1693,7 @@ static int nl80211_req_set_reg(struct sk
 		return -EINVAL;
 #endif
 	mutex_lock(&cfg80211_drv_mutex);
-	r = __regulatory_hint(NULL, REGDOM_SET_BY_USER, data, NULL);
+	r = __regulatory_hint(NULL, REGDOM_SET_BY_USER, data);
 	mutex_unlock(&cfg80211_drv_mutex);
 	return r;
 }
--- everything.orig/net/wireless/reg.c	2008-10-21 11:15:49.000000000 +0200
+++ everything/net/wireless/reg.c	2008-10-21 11:50:14.000000000 +0200
@@ -42,7 +42,7 @@
 #include "core.h"
 #include "reg.h"
 
-/* wiphy is set if this request's initiator is REGDOM_SET_BY_DRIVER */
+/* wiphy is set if this request's initiator is REGDOM_SET_BY_COUNTRY_IE */
 struct regulatory_request {
 	struct wiphy *wiphy;
 	int granted;
@@ -299,7 +299,7 @@ static int call_crda(const char *alpha2)
 /* This has the logic which determines when a new request
  * should be ignored. */
 static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
-	char *alpha2, struct ieee80211_regdomain *rd)
+			  const char *alpha2)
 {
 	/* All initial requests are respected */
 	if (!last_request)
@@ -344,22 +344,8 @@ static int ignore_request(struct wiphy *
 		return 1;
 	case REGDOM_SET_BY_DRIVER:
 		BUG_ON(!wiphy);
-		if (last_request->initiator == REGDOM_SET_BY_DRIVER) {
-			/* Two separate drivers hinting different things,
-			 * this is possible if you have two devices present
-			 * on a system with different EEPROM regulatory
-			 * readings. XXX: Do intersection, we support only
-			 * the first regulatory hint for now */
-			if (last_request->wiphy != wiphy)
-				return -EALREADY;
-			if (rd)
-				return -EALREADY;
-			/* Driver should not be trying to hint different
-			 * regulatory domains! */
-			BUG_ON(!alpha2_equal(alpha2,
-					cfg80211_regdomain->alpha2));
+		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
 			return -EALREADY;
-		}
 		if (last_request->initiator == REGDOM_SET_BY_CORE)
 			return 0;
 		/* XXX: Handle intersection, and add the
@@ -558,40 +544,32 @@ void wiphy_update_regulatory(struct wiph
 
 /* Caller must hold &cfg80211_drv_mutex */
 int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
-		      const char *alpha2, struct ieee80211_regdomain *rd)
+		      const char *alpha2)
 {
 	struct regulatory_request *request;
-	char *rd_alpha2;
 	int r = 0;
 
-	r = ignore_request(wiphy, set_by, (char *) alpha2, rd);
+	r = ignore_request(wiphy, set_by, alpha2);
 	if (r)
 		return r;
 
-	if (rd)
-		rd_alpha2 = rd->alpha2;
-	else
-		rd_alpha2 = (char *) alpha2;
-
 	switch (set_by) {
 	case REGDOM_SET_BY_CORE:
 	case REGDOM_SET_BY_COUNTRY_IE:
 	case REGDOM_SET_BY_DRIVER:
 	case REGDOM_SET_BY_USER:
 		request = kzalloc(sizeof(struct regulatory_request),
-			GFP_KERNEL);
+				  GFP_KERNEL);
 		if (!request)
 			return -ENOMEM;
 
-		request->alpha2[0] = rd_alpha2[0];
-		request->alpha2[1] = rd_alpha2[1];
+		request->alpha2[0] = alpha2[0];
+		request->alpha2[1] = alpha2[1];
 		request->initiator = set_by;
 		request->wiphy = wiphy;
 
 		kfree(last_request);
 		last_request = request;
-		if (rd)
-			break;
 		r = call_crda(alpha2);
 #ifndef CONFIG_WIRELESS_OLD_REGULATORY
 		if (r)
@@ -606,25 +584,13 @@ int __regulatory_hint(struct wiphy *wiph
 	return r;
 }
 
-int regulatory_hint(struct wiphy *wiphy, const char *alpha2,
-	struct ieee80211_regdomain *rd)
+void regulatory_hint(const char *alpha2)
 {
-	int r;
-	BUG_ON(!rd && !alpha2);
+	BUG_ON(!alpha2);
 
 	mutex_lock(&cfg80211_drv_mutex);
-
-	r = __regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER, alpha2, rd);
-	if (r || !rd)
-		goto unlock_and_exit;
-
-	/* If the driver passed a regulatory domain we skipped asking
-	 * userspace for one so we can now go ahead and set it */
-	r = set_regdom(rd);
-
-unlock_and_exit:
+	__regulatory_hint(NULL, REGDOM_SET_BY_DRIVER, alpha2);
 	mutex_unlock(&cfg80211_drv_mutex);
-	return r;
 }
 EXPORT_SYMBOL(regulatory_hint);
 
@@ -794,11 +760,11 @@ int regulatory_init(void)
 	 * that is not a valid ISO / IEC 3166 alpha2 */
 	if (ieee80211_regdom[0] != 'E' || ieee80211_regdom[1] != 'U')
 		err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
-					ieee80211_regdom, NULL);
+					ieee80211_regdom);
 #else
 	cfg80211_regdomain = cfg80211_world_regdom;
 
-	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00", NULL);
+	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00");
 	if (err)
 		printk(KERN_ERR "cfg80211: calling CRDA failed - "
 		       "unable to update world regulatory domain, "
--- everything.orig/net/wireless/reg.h	2008-10-21 11:16:54.000000000 +0200
+++ everything/net/wireless/reg.h	2008-10-21 11:43:18.000000000 +0200
@@ -11,30 +11,21 @@ int set_regdom(const struct ieee80211_re
 
 /**
  * __regulatory_hint - hint to the wireless core a regulatory domain
- * @wiphy: if a driver is providing the hint this is the driver's very
- * 	own &struct wiphy
+ * @wiphy: if the hint comes from country information from an AP, this
+ *	is required to be set to the wiphy that received the information
  * @alpha2: the ISO/IEC 3166 alpha2 being claimed the regulatory domain
- * 	should be in. If @rd is set this should be NULL
- * @rd: a complete regulatory domain, if passed the caller need not worry
- * 	about freeing it
+ *	should be in. If @rd is set this should be NULL
  *
  * The Wireless subsystem can use this function to hint to the wireless core
  * what it believes should be the current regulatory domain by
  * giving it an ISO/IEC 3166 alpha2 country code it knows its regulatory
- * domain should be in or by providing a completely build regulatory domain.
+ * domain should be in.
  *
- * Returns -EALREADY if *a regulatory domain* has already been set. Note that
- * this could be by another driver. It is safe for drivers to continue if
- * -EALREADY is returned, if drivers are not capable of world roaming they
- * should not register more channels than they support. Right now we only
- * support listening to the first driver hint. If the driver is capable
- * of world roaming but wants to respect its own EEPROM mappings for
- * specific regulatory domains it should register the @reg_notifier callback
- * on the &struct wiphy. Returns 0 if the hint went through fine or through an
- * intersection operation. Otherwise a standard error code is returned.
+ * Returns zero if all went fine, %-EALREADY if a regulatory domain had
+ * already been set or other standard error codes.
  *
  */
 extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
-		const char *alpha2, struct ieee80211_regdomain *rd);
+			     const char *alpha2);
 
 #endif  /* __NET_WIRELESS_REG_H */


