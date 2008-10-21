Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYJUKb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 06:31:57 -0400
Subject: [PATCH] wireless: add regulatory_struct_hint
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 12:31:50 +0200
Message-Id: <1224585110.5521.8.camel@johannes.berg> (sfid-20081021_123200_564015_598B617C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a new function, regulatory_struct_hint, which acts
as a hint to the wireless core which regdomain a card thinks
the system is operating in, but given in terms of the actual
regdomain definition. Multiple hints are permitted when the
specified bands do not overlap.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Entirely untested. Anyone want to give it a go in the dual-band scenario?

 include/net/wireless.h |   14 +++
 net/wireless/reg.c     |  225 ++++++++++++++++++++++++++++++++-----------------
 2 files changed, 161 insertions(+), 78 deletions(-)

--- everything.orig/include/net/wireless.h	2008-10-21 11:50:01.000000000 +0200
+++ everything/include/net/wireless.h	2008-10-21 11:50:16.000000000 +0200
@@ -355,4 +355,18 @@ ieee80211_get_channel(struct wiphy *wiph
  * for a regulatory domain structure for the respective country.
  */
 extern void regulatory_hint(const char *alpha2);
+
+/**
+ * regulatory_struct_hint - hint wireless core about regdomain
+ *
+ * @rd: regdomain structure containing the frequency ranges that are
+ *	permitted for use.
+ * @bands: bitmask of bands this contains, use BIT(IEEE80211_BAND_...)
+ *
+ * This function informs the wireless core that the driver believes
+ * that the bands indicated are defined by the given structure in the
+ * regulatory domain the system is operating in.
+ */
+extern void regulatory_struct_hint(struct ieee80211_regdomain *rd,
+				   u32 bands);
 #endif /* __NET_WIRELESS_H */
--- everything.orig/net/wireless/reg.c	2008-10-21 11:50:14.000000000 +0200
+++ everything/net/wireless/reg.c	2008-10-21 12:26:08.000000000 +0200
@@ -45,9 +45,9 @@
 /* wiphy is set if this request's initiator is REGDOM_SET_BY_COUNTRY_IE */
 struct regulatory_request {
 	struct wiphy *wiphy;
-	int granted;
 	enum reg_set_by initiator;
 	char alpha2[2];
+	u32 bands;
 };
 
 static struct regulatory_request *last_request;
@@ -296,82 +296,6 @@ static int call_crda(const char *alpha2)
 	return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, envp);
 }
 
-/* This has the logic which determines when a new request
- * should be ignored. */
-static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
-			  const char *alpha2)
-{
-	/* All initial requests are respected */
-	if (!last_request)
-		return 0;
-
-	switch (set_by) {
-	case REGDOM_SET_BY_INIT:
-		return -EINVAL;
-	case REGDOM_SET_BY_CORE:
-		/* Always respect new wireless core hints, should only
-		 * come in for updating the world regulatory domain at init
-		 * anyway */
-		return 0;
-	case REGDOM_SET_BY_COUNTRY_IE:
-		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
-			if (last_request->wiphy != wiphy) {
-				/* Two cards with two APs claiming different
-				 * different Country IE alpha2s!
-				 * You're special!! */
-				if (!alpha2_equal(last_request->alpha2,
-						cfg80211_regdomain->alpha2)) {
-					/* XXX: Deal with conflict, consider
-					 * building a new one out of the
-					 * intersection */
-					WARN_ON(1);
-					return -EOPNOTSUPP;
-				}
-				return -EALREADY;
-			}
-			/* Two consecutive Country IE hints on the same wiphy */
-			if (!alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
-				return 0;
-			return -EALREADY;
-		}
-		if (WARN_ON(!is_alpha2_set(alpha2) || !is_an_alpha2(alpha2)),
-				"Invalid Country IE regulatory hint passed "
-				"to the wireless core\n")
-			return -EINVAL;
-		/* We ignore Country IE hints for now, as we haven't yet
-		 * added the dot11MultiDomainCapabilityEnabled flag
-		 * for wiphys */
-		return 1;
-	case REGDOM_SET_BY_DRIVER:
-		BUG_ON(!wiphy);
-		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
-			return -EALREADY;
-		if (last_request->initiator == REGDOM_SET_BY_CORE)
-			return 0;
-		/* XXX: Handle intersection, and add the
-		 * dot11MultiDomainCapabilityEnabled flag to wiphy. For now
-		 * we assume the driver has this set to false, following the
-		 * 802.11d dot11MultiDomainCapabilityEnabled documentation */
-		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
-			return 0;
-		return 0;
-	case REGDOM_SET_BY_USER:
-		if (last_request->initiator == REGDOM_SET_BY_USER ||
-		    last_request->initiator == REGDOM_SET_BY_CORE)
-			return 0;
-		/* Drivers can use their wiphy's reg_notifier()
-		 * to override any information */
-		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
-			return 0;
-		/* XXX: Handle intersection */
-		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
-			return -EOPNOTSUPP;
-		return 0;
-	default:
-		return -EINVAL;
-	}
-}
-
 /* Used by nl80211 before kmalloc'ing our regulatory domain */
 bool reg_is_valid_request(const char *alpha2)
 {
@@ -542,6 +466,83 @@ void wiphy_update_regulatory(struct wiph
 	}
 }
 
+/* This has the logic which determines when a new request
+ * should be ignored. */
+static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
+			  const char *alpha2)
+{
+	/* All initial requests are respected */
+	if (!last_request)
+		return 0;
+
+	switch (set_by) {
+	case REGDOM_SET_BY_INIT:
+		return -EINVAL;
+	case REGDOM_SET_BY_CORE:
+		/* Always respect new wireless core hints, should only
+		 * come in for updating the world regulatory domain at init
+		 * anyway */
+		return 0;
+	case REGDOM_SET_BY_COUNTRY_IE:
+		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
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
+		switch (last_request->initiator) {
+		case REGDOM_SET_BY_DRIVER:
+			return -EALREADY;
+		case REGDOM_SET_BY_INIT:
+		case REGDOM_SET_BY_CORE:
+		case REGDOM_SET_BY_USER:
+		case REGDOM_SET_BY_COUNTRY_IE:
+			return 0;
+		default:
+			break;
+		}
+		return 0;
+	case REGDOM_SET_BY_USER:
+		if (last_request->initiator == REGDOM_SET_BY_USER ||
+		    last_request->initiator == REGDOM_SET_BY_CORE)
+			return 0;
+		/* Drivers can use their wiphy's reg_notifier()
+		 * to override any information */
+		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
+			return 0;
+		/* XXX: Handle intersection */
+		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
+			return -EOPNOTSUPP;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 /* Caller must hold &cfg80211_drv_mutex */
 int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 		      const char *alpha2)
@@ -567,6 +568,7 @@ int __regulatory_hint(struct wiphy *wiph
 		request->alpha2[1] = alpha2[1];
 		request->initiator = set_by;
 		request->wiphy = wiphy;
+		request->bands = ~0;
 
 		kfree(last_request);
 		last_request = request;
@@ -594,6 +596,74 @@ void regulatory_hint(const char *alpha2)
 }
 EXPORT_SYMBOL(regulatory_hint);
 
+void regulatory_struct_hint(struct ieee80211_regdomain *rd, u32 bands)
+{
+	const struct ieee80211_regdomain *orig = NULL;
+	struct ieee80211_regdomain *new = NULL;
+	int origrules;
+
+	BUG_ON(!rd);
+	BUG_ON(!bands);
+
+	mutex_lock(&cfg80211_drv_mutex);
+
+	/*
+	 * ignore hint if anything else set it or if the given
+	 * bands overlap already defined bands
+	 */
+	if (last_request) {
+		switch (last_request->initiator) {
+		case REGDOM_SET_BY_DRIVER:
+			if (last_request->bands & bands)
+				goto out;
+			break;
+		case REGDOM_SET_BY_CORE:
+			break;
+		default:
+			goto out;
+		}
+
+		/* modify the currently set regdom */
+		orig = cfg80211_regdomain;
+		origrules = orig->n_reg_rules;
+	} else {
+		last_request = kzalloc(sizeof(struct regulatory_request),
+				       GFP_KERNEL);
+		if (!last_request)
+			goto out;
+
+		last_request->alpha2[0] = '9';
+		last_request->alpha2[1] = '9';
+		last_request->initiator = REGDOM_SET_BY_DRIVER;
+
+		origrules = 0;
+	}
+
+	last_request->bands |= bands;
+
+	new = krealloc(orig,
+		       sizeof(struct ieee80211_regdomain) +
+		       sizeof(struct ieee80211_reg_rule) * origrules +
+		       sizeof(struct ieee80211_reg_rule) * rd->n_reg_rules,
+		       GFP_KERNEL);
+	if (!new)
+		goto out;
+
+	new->alpha2[0] = '9';
+	new->alpha2[1] = '9';
+	new->n_reg_rules = origrules + rd->n_reg_rules;
+	/* original rules still intact */
+	memcpy(&new->reg_rules[origrules],
+	       rd->reg_rules,
+	       sizeof(struct ieee80211_reg_rule) * rd->n_reg_rules);
+
+	set_regdom(new);
+	kfree(rd);
+
+ out:
+	mutex_unlock(&cfg80211_drv_mutex);
+}
+
 
 static void print_rd_rules(const struct ieee80211_regdomain *rd)
 {
@@ -710,7 +780,6 @@ static int __set_regdom(const struct iee
 
 	/* Tada! */
 	cfg80211_regdomain = rd;
-	last_request->granted = 1;
 
 	return 0;
 }


