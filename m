Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36622 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3JMEb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Oct 2013 00:31:56 -0400
Received: by mail-pb0-f51.google.com with SMTP id jt11so6000884pbb.10
        for <linux-wireless@vger.kernel.org>; Sat, 12 Oct 2013 21:31:55 -0700 (PDT)
From: Mihir Shete <smihir@qti.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: Mihir Shete <smihir@qti.qualcomm.com>,
	Henri Bahini <hbahini@qca.qualcomm.com>,
	Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 1/2] cfg80211: add flags to define country IE processing rules
Date: Sun, 13 Oct 2013 10:01:36 +0530
Message-Id: <1381638697-2641-2-git-send-email-smihir@qti.qualcomm.com> (sfid-20131013_063205_048348_568E0EC6)
In-Reply-To: <1381638697-2641-1-git-send-email-smihir@qti.qualcomm.com>
References: <1381638697-2641-1-git-send-email-smihir@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11 cards may have different country IE parsing behavioural
preferences and vendors may want to support these. These preferences
were managed by the WIPHY_FLAG_CUSTOM_REGULATORY and the
WIPHY_FLAG_STRICT_REGULATORY flags and their combination.
Instead of using this existing notation, split out the country
IE behavioural preferences to a new flag. This will allow
us to add more customizations easily and make the code more
maintainable

Cc: Henri Bahini <hbahini@qca.qualcomm.com>
Cc: Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>
Cc: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Signed-off-by: Mihir Shete <smihir@qti.qualcomm.com>
---
 drivers/net/wireless/ath/regd.c |  1 +
 include/net/cfg80211.h          | 36 +++++++++++++++++++++++-------------
 include/uapi/linux/nl80211.h    | 28 ++++++++++++++++++++++++++++
 net/wireless/reg.c              |  8 +++-----
 4 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 7d077c7..cbf074c 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -513,6 +513,7 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 		 */
 		regd = ath_world_regdomain(reg);
 		wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+		wiphy->country_ie_pref = NL80211_COUNTRY_IE_FOLLOW_POWER;
 	} else {
 		/*
 		 * This gets applied in the case of the absence of CRDA,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 45f6bf5..9dd71f2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2430,19 +2430,25 @@ struct cfg80211_ops {
  * 	has its own custom regulatory domain and cannot identify the
  * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
  * 	we will disregard the first regulatory hint (when the
- * 	initiator is %REGDOM_SET_BY_CORE).
- * @WIPHY_FLAG_STRICT_REGULATORY: tells us the driver for this device will
- *	ignore regulatory domain settings until it gets its own regulatory
- *	domain via its regulatory_hint() unless the regulatory hint is
- *	from a country IE. After its gets its own regulatory domain it will
- *	only allow further regulatory domain settings to further enhance
- *	compliance. For example if channel 13 and 14 are disabled by this
- *	regulatory domain no user regulatory domain can enable these channels
- *	at a later time. This can be used for devices which do not have
- *	calibration information guaranteed for frequencies or settings
- *	outside of its regulatory domain. If used in combination with
- *	WIPHY_FLAG_CUSTOM_REGULATORY the inspected country IE power settings
- *	will be followed.
+ * 	initiator is %REGDOM_SET_BY_CORE). wiphys can set the custom
+ * 	regulatory domain using wiphy_apply_custom_regulatory()
+ * 	prior to wiphy registration.
+ * @WIPHY_FLAG_STRICT_REGULATORY: tells us that the wiphy for this device
+ * 	has regulatory domain that it wishes to be considered as the
+ * 	superset for regulatory rules. After this device gets its regulatory
+ * 	domain programmed further regulatory hints shall only be considered
+ * 	for this device to enhance regulatory compliance, forcing the
+ * 	device to only possibly use subsets of the original regulatory
+ * 	rules. For example if channel 13 and 14 are disabled by this
+ * 	device's regulatory domain no user specified regulatory hint which
+ * 	has these channels enabled would enable them for this wiphy,
+ * 	the device's original regulatory domain will be trusted as the
+ * 	base. You can program the superset of regulatory rules for this
+ * 	wiphy with regulatory_hint() for cards programmed with an
+ * 	ISO3166-alpha2 country code. wiphys that use regulatory_hint()
+ * 	will have their wiphy->regd programmed once the regulatory
+ * 	domain is set, and all other regulatory hints will be ignored
+ * 	until their own regulatory domain gets programmed.
  * @WIPHY_FLAG_DISABLE_BEACON_HINTS: enable this if your driver needs to ensure
  *	that passive scan flags and beaconing flags may not be lifted by
  *	cfg80211 due to regulatory beacon hints. For more information on beacon
@@ -2773,6 +2779,8 @@ struct wiphy_coalesce_support {
  *	802.11-2012 8.4.2.29 for the defined fields.
  * @extended_capabilities_mask: mask of the valid values
  * @extended_capabilities_len: length of the extended capabilities
+ * @country_ie_pref: country IE processing preferences specified
+ *	by enum nl80211_country_ie_pref
  * @coalesce: packet coalescing support information
  */
 struct wiphy {
@@ -2844,6 +2852,8 @@ struct wiphy {
 	const u8 *extended_capabilities, *extended_capabilities_mask;
 	u8 extended_capabilities_len;
 
+	u8 country_ie_pref;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fde2c02..6e574ce 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2321,6 +2321,34 @@ enum nl80211_reg_type {
 };
 
 /**
+ * enum nl80211_country_ie_pref - country IE processing preferences
+ *
+ * enumerates the different preferences an 802.11 card can advertize
+ * for parsing the country IEs. As per the current implementation
+ * country IEs are only used to derive the ISO3166-apha2, the
+ * information for power settings that comes with the country IE is
+ * ignored and we use the power settings from regdb.
+ *
+ *	The default behaviour for drivers that do not advertize any
+ *	preference to handle the country IE is to allow the core to
+ *	update channel flags according to the ISO3166-alpha2 in
+ *	the country IE. The applied power is -
+ *	MIN(power specified by custom domain, power obtained from regdb)
+ *
+ * @NL80211_COUNTRY_IE_FOLLOW_POWER - for devices that have a
+ *	preference that even though they may have programmed their own
+ *	custom power setting prior to wiphy registration, they want
+ *	to ensure their channel power settings are updated for this
+ *	connection with the power settings derived from the regulatory
+ *	domain. The regulatory domain used will be based on the
+ *	ISO3166-alpha2 from country IE provided through
+ *	regulatory_hint_country_ie()
+ */
+enum nl80211_country_ie_pref {
+	NL80211_COUNTRY_IE_FOLLOW_POWER	= 1<<0,
+};
+
+/**
  * enum nl80211_reg_rule_attr - regulatory rule attributes
  * @__NL80211_REG_RULE_ATTR_INVALID: attribute number 0 is reserved
  * @NL80211_ATTR_REG_RULE_FLAGS: a set of flags which specify additional
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d62cb1e..87b4ee3 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -898,13 +898,11 @@ static void handle_channel(struct wiphy *wiphy,
 	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 	if (chan->orig_mpwr) {
 		/*
-		 * Devices that have their own custom regulatory domain
-		 * but also use WIPHY_FLAG_STRICT_REGULATORY will follow the
-		 * passed country IE power settings.
+		 * Devices that use NL80211_COUNTRY_IE_FOLLOW_POWER will always
+		 * follow the passed country IE power settings.
 		 */
 		if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
-		    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
+		    wiphy->country_ie_pref & NL80211_COUNTRY_IE_FOLLOW_POWER)
 			chan->max_power = chan->max_reg_power;
 		else
 			chan->max_power = min(chan->orig_mpwr,
-- 
1.8.2.1

