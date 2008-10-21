Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYJUHmn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 03:42:43 -0400
Subject: [PATCH] wireless: don't publish __regulatory_hint
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 09:42:38 +0200
Message-Id: <1224574958.27899.96.camel@johannes.berg> (sfid-20081021_094246_965480_598913E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function requires an internal lock to be held, so it cannot
be published to other modules in the kernel.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/wireless.h |   37 +++++++++----------------------------
 net/wireless/reg.h     |   28 ++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 28 deletions(-)

--- everything.orig/include/net/wireless.h	2008-10-21 09:25:18.000000000 +0200
+++ everything/include/net/wireless.h	2008-10-21 09:40:14.000000000 +0200
@@ -344,33 +344,6 @@ ieee80211_get_channel(struct wiphy *wiph
 }
 
 /**
- * __regulatory_hint - hint to the wireless core a regulatory domain
- * @wiphy: if a driver is providing the hint this is the driver's very
- * 	own &struct wiphy
- * @alpha2: the ISO/IEC 3166 alpha2 being claimed the regulatory domain
- * 	should be in. If @rd is set this should be NULL
- * @rd: a complete regulatory domain, if passed the caller need not worry
- * 	about freeing it
- *
- * The Wireless subsystem can use this function to hint to the wireless core
- * what it believes should be the current regulatory domain by
- * giving it an ISO/IEC 3166 alpha2 country code it knows its regulatory
- * domain should be in or by providing a completely build regulatory domain.
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
- *
- */
-extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
-		const char *alpha2, struct ieee80211_regdomain *rd);
-/**
  * regulatory_hint - driver hint to the wireless core a regulatory domain
  * @wiphy: the driver's very own &struct wiphy
  * @alpha2: the ISO/IEC 3166 alpha2 the driver claims its regulatory domain
@@ -391,7 +364,15 @@ extern int __regulatory_hint(struct wiph
  * the wireless core it is unknown. If you pass a built regulatory domain
  * and we return non zero you are in charge of kfree()'ing the structure.
  *
- * See __regulatory_hint() documentation for possible return values.
+ * Returns -EALREADY if *a regulatory domain* has already been set. Note that
+ * this could be by another driver. It is safe for drivers to continue if
+ * -EALREADY is returned, if drivers are not capable of world roaming they
+ * should not register more channels than they support. Right now we only
+ * support listening to the first driver hint. If the driver is capable
+ * of world roaming but wants to respect its own EEPROM mappings for
+ * specific regulatory domains it should register the @reg_notifier callback
+ * on the &struct wiphy. Returns 0 if the hint went through fine or through an
+ * intersection operation. Otherwise a standard error code is returned.
  */
 extern int regulatory_hint(struct wiphy *wiphy,
 		const char *alpha2, struct ieee80211_regdomain *rd);
--- everything.orig/net/wireless/reg.h	2008-10-21 09:40:19.000000000 +0200
+++ everything/net/wireless/reg.h	2008-10-21 09:40:30.000000000 +0200
@@ -10,4 +10,32 @@ void regulatory_exit(void);
 
 int set_regdom(const struct ieee80211_regdomain *rd);
 
+/**
+ * __regulatory_hint - hint to the wireless core a regulatory domain
+ * @wiphy: if a driver is providing the hint this is the driver's very
+ * 	own &struct wiphy
+ * @alpha2: the ISO/IEC 3166 alpha2 being claimed the regulatory domain
+ * 	should be in. If @rd is set this should be NULL
+ * @rd: a complete regulatory domain, if passed the caller need not worry
+ * 	about freeing it
+ *
+ * The Wireless subsystem can use this function to hint to the wireless core
+ * what it believes should be the current regulatory domain by
+ * giving it an ISO/IEC 3166 alpha2 country code it knows its regulatory
+ * domain should be in or by providing a completely build regulatory domain.
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
+ */
+extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
+		const char *alpha2, struct ieee80211_regdomain *rd);
+
 #endif  /* __NET_WIRELESS_REG_H */


