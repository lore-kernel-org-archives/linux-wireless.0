Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:63168 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3LCReH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 12:34:07 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so14041817wes.15
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 09:34:06 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: c_manoha@qca.qualcomm.com, linville@tuxdriver.com,
	johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFT 2/2] cfg80211: make regulatory_hint() remove REGULATORY_CUSTOM_REG
Date: Tue,  3 Dec 2013 18:33:54 +0100
Message-Id: <1386092034-13442-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131203_183414_359070_B7442146)
In-Reply-To: <1386092034-13442-1-git-send-email-mcgrof@do-not-panic.com>
References: <1386092034-13442-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The REGULATORY_CUSTOM_REG can be used during early init with
the goal of overriding the wiphy's default regulatory settings
in case the alpha2 of the device is not known. In the case that
the alpha2 becomes known lets avoid having drivers having to
clear the REGULATORY_CUSTOM_REG flag by doing it for them
when regulatory_hint() is used.

Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 2 --
 include/net/regulatory.h        | 4 ++++
 net/wireless/reg.c              | 2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 06b05d0..43d6234 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -622,8 +622,6 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 	}
 
 	wiphy_apply_custom_regulatory(wiphy, regd);
-	if (!ath_is_world_regd(reg))
-		wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG;
 	ath_reg_apply_radar_flags(wiphy);
 	ath_reg_apply_world_flags(wiphy, NL80211_REGDOM_SET_BY_DRIVER, reg);
 	return 0;
diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index c96a0b8..b07cdc9 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -96,6 +96,10 @@ struct regulatory_request {
  *	initiator is %REGDOM_SET_BY_CORE). Drivers that use
  *	wiphy_apply_custom_regulatory() should have this flag set
  *	or the regulatory core will set it for the wiphy.
+ *	If you use regulatory_hint() *after* using
+ *	wiphy_apply_custom_regulatory() the wireless core will
+ *	clear the REGULATORY_CUSTOM_REG for your wiphy as it would be
+ *	implied that the device somehow gained knowledge of its region.
  * @REGULATORY_STRICT_REG: tells us that the wiphy for this device
  *	has regulatory domain that it wishes to be considered as the
  *	superset for regulatory rules. After this device gets its regulatory
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ec54e1a..edebd04 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1826,6 +1826,8 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 	if (WARN_ON(!alpha2 || !wiphy))
 		return -EINVAL;
 
+	wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG;
+
 	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
-- 
1.8.4.3

