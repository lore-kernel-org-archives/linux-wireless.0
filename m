Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:64718 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3LCReF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 12:34:05 -0500
Received: by mail-we0-f172.google.com with SMTP id w62so8275233wes.31
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 09:34:04 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: c_manoha@qca.qualcomm.com, linville@tuxdriver.com,
	johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFT 1/2] ath: fix warning on usage of REGULATORY_CUSTOM_REG
Date: Tue,  3 Dec 2013 18:33:53 +0100
Message-Id: <1386092034-13442-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131203_183413_687237_C14C6AFB)
In-Reply-To: <1386092034-13442-1-git-send-email-mcgrof@do-not-panic.com>
References: <1386092034-13442-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath wants to first apply the custom regd and only later
will it revert to not using it if an alpha2 regulatory
domain is found. Since the wireless core now enforces
usage of the REGULATORY_CUSTOM_REG strictly when
wiphy_apply_custom_regulatory() is used this makes
ath adhere to the expected behaviour but also updates
the wiphy after its done with the custom usage.

This fixes this warning:

[    5.488733] ath: phy0: ASPM enabled: 0x43
[    5.488735] ath: EEPROM regdomain: 0x0
[    5.488736] ath: EEPROM indicates default country code should be used
[    5.488736] ath: doing EEPROM country->regdmn map search
[    5.488737] ath: country maps to regdmn code: 0x3a
[    5.488737] ath: Country alpha2 being used: US
[    5.488738] ath: Regpair used: 0x3a
[    5.488738] ------------[ cut here ]------------
[    5.488745] WARNING: CPU: 0 PID: 161 at
	/home/sujith/dev/wireless-testing/net/wireless/reg.c:1361
	wiphy_apply_custom_regulatory+0x17a/0x1b0 [cfg80211]()
[    5.488746] wiphy should have REGULATORY_CUSTOM_REG

The wireless core can *later* lift this flag for us for when
using the regulatory_hint() to make this fix more generic.

Reported-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index d3bbf48..06b05d0 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -602,7 +602,8 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 	const struct ieee80211_regdomain *regd;
 
 	wiphy->reg_notifier = reg_notifier;
-	wiphy->regulatory_flags |= REGULATORY_STRICT_REG;
+	wiphy->regulatory_flags |= REGULATORY_STRICT_REG |
+				   REGULATORY_CUSTOM_REG;
 
 	if (ath_is_world_regd(reg)) {
 		/*
@@ -610,8 +611,7 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 		 * saved on the wiphy orig_* parameters
 		 */
 		regd = ath_world_regdomain(reg);
-		wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
-					   REGULATORY_COUNTRY_IE_FOLLOW_POWER;
+		wiphy->regulatory_flags |= REGULATORY_COUNTRY_IE_FOLLOW_POWER;
 	} else {
 		/*
 		 * This gets applied in the case of the absence of CRDA,
@@ -620,7 +620,10 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 		 */
 		regd = ath_default_world_regdomain();
 	}
+
 	wiphy_apply_custom_regulatory(wiphy, regd);
+	if (!ath_is_world_regd(reg))
+		wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG;
 	ath_reg_apply_radar_flags(wiphy);
 	ath_reg_apply_world_flags(wiphy, NL80211_REGDOM_SET_BY_DRIVER, reg);
 	return 0;
-- 
1.8.4.3

