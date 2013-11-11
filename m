Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54017 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3KKVPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 16:15:44 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so713837wgg.13
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 13:15:40 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Mihir Shete <smihir@qti.qualcomm.com>,
	Henri Bahini <hbahini@qca.qualcomm.com>,
	Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>
Subject: [PATCH 2/3] cfg80211: add flags to define country IE processing rules
Date: Mon, 11 Nov 2013 22:15:30 +0100
Message-Id: <1384204531-10025-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131111_221556_848965_EF877767)
In-Reply-To: <1384204531-10025-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384204531-10025-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11 cards may have different country IE parsing behavioural
preferences and vendors may want to support these. These preferences
were managed by the REGULATORY_CUSTOM_REG and the REGULATORY_STRICT_REG
flags and their combination. Instead of using this existing notation,
split out the country IE behavioural preferences as a new flag. This
will allow us to add more customizations easily and make the code more
maintainable.

Cc: Mihir Shete <smihir@qti.qualcomm.com>
Cc: Henri Bahini <hbahini@qca.qualcomm.com>
Cc: Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c |  3 ++-
 include/net/regulatory.h        | 36 ++++++++++++++++++++++++------------
 net/wireless/reg.c              |  8 +++-----
 3 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index e557e57..55ad36e 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -505,7 +505,8 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 		 * saved on the wiphy orig_* parameters
 		 */
 		regd = ath_world_regdomain(reg);
-		wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
+		wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
+					   REGULATORY_COUNTRY_IE_FOLLOW_POWER;
 	} else {
 		/*
 		 * This gets applied in the case of the absence of CRDA,
diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index a77368c..bc41203 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -96,27 +96,39 @@ struct regulatory_request {
  * 	initiator is %REGDOM_SET_BY_CORE). Drivers that use
  * 	wiphy_apply_custom_regulatory() should have this flag set
  * 	or the regulatory core will set it for the wiphy.
- * @REGULATORY_FLAG_STRICT_REG: tells us the driver for this device will
- *	ignore regulatory domain settings until it gets its own regulatory
- *	domain via its regulatory_hint() unless the regulatory hint is
- *	from a country IE. After its gets its own regulatory domain it will
- *	only allow further regulatory domain settings to further enhance
- *	compliance. For example if channel 13 and 14 are disabled by this
- *	regulatory domain no user regulatory domain can enable these channels
- *	at a later time. This can be used for devices which do not have
- *	calibration information guaranteed for frequencies or settings
- *	outside of its regulatory domain. If used in combination with
- *	REGULATORY_FLAG_CUSTOM_REG the inspected country IE power settings
- *	will be followed.
+ * @REGULATORY_FLAG_STRICT_REG: tells us that the wiphy for this device
+ *	has regulatory domain that it wishes to be considered as the
+ *	superset for regulatory rules. After this device gets its regulatory
+ *	domain programmed further regulatory hints shall only be considered
+ *	for this device to enhance regulatory compliance, forcing the
+ *	device to only possibly use subsets of the original regulatory
+ *	rules. For example if channel 13 and 14 are disabled by this
+ *	device's regulatory domain no user specified regulatory hint which
+ *	has these channels enabled would enable them for this wiphy,
+ *	the device's original regulatory domain will be trusted as the
+ *	base. You can program the superset of regulatory rules for this
+ *	wiphy with regulatory_hint() for cards programmed with an
+ *	ISO3166-alpha2 country code. wiphys that use regulatory_hint()
+ *	will have their wiphy->regd programmed once the regulatory
+ *	domain is set, and all other regulatory hints will be ignored
+ *	until their own regulatory domain gets programmed.
  * @REGULATORY_FLAG_DISABLE_BEACON_HINTS: enable this if your driver needs to
  *	ensure that passive scan flags and beaconing flags may not be lifted by
  *	cfg80211 due to regulatory beacon hints. For more information on beacon
  *	hints read the documenation for regulatory_hint_found_beacon()
+ * @REGULATORY_COUNTRY_IE_FOLLOW_POWER:  for devices that have a preference
+ *	that even though they may have programmed their own custom power
+ *	setting prior to wiphy registration, they want to ensure their channel
+ *	power settings are updated for this connection with the power settings
+ *	derived from the regulatory domain. The regulatory domain used will be
+ *	based on the ISO3166-alpha2 from country IE provided through
+ *	regulatory_hint_country_ie()
  */
 enum ieee80211_regulatory_flags {
 	REGULATORY_CUSTOM_REG			= BIT(0),
 	REGULATORY_STRICT_REG			= BIT(1),
 	REGULATORY_DISABLE_BEACON_HINTS		= BIT(2),
+	REGULATORY_COUNTRY_IE_FOLLOW_POWER	= BIT(3),
 };
 
 struct ieee80211_freq_range {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e44b4bb..6b3051f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -921,13 +921,11 @@ static void handle_channel(struct wiphy *wiphy,
 	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 	if (chan->orig_mpwr) {
 		/*
-		 * Devices that have their own custom regulatory domain
-		 * but also use REGULATORY_STRICT_REG will follow the
-		 * passed country IE power settings.
+		 * Devices that use REGULATORY_COUNTRY_IE_FOLLOW_POWER
+		 * will always follow the passed country IE power settings.
 		 */
 		if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-		    wiphy->regulatory_flags & REGULATORY_CUSTOM_REG &&
-		    wiphy->regulatory_flags & REGULATORY_STRICT_REG)
+		    wiphy->regulatory_flags & REGULATORY_COUNTRY_IE_FOLLOW_POWER)
 			chan->max_power = chan->max_reg_power;
 		else
 			chan->max_power = min(chan->orig_mpwr,
-- 
1.8.4.rc3

