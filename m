Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZBZCkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 21:40:00 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, mb@bu3sch.de,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/3] cfg80211: remove REGDOM_SET_BY_INIT
Date: Wed, 25 Feb 2009 21:39:47 -0500
Message-Id: <1235615989-1323-2-git-send-email-lrodriguez@atheros.com> (sfid-20090226_034006_225864_9EB4273F)
In-Reply-To: <1235615989-1323-1-git-send-email-lrodriguez@atheros.com>
References: <1235615989-1323-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not used as we can always just assume the first
regulatory domain set will _always_ be a static regulatory
domain. REGDOM_SET_BY_CORE will be the first request from
cfg80211 for a regdomain and that then populates the first
regulatory request.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    2 +-
 drivers/net/wireless/ath9k/regd.c |    1 -
 include/net/cfg80211.h            |    3 ---
 net/wireless/reg.c                |    2 --
 4 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7823d37..b85f6cf 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1653,7 +1653,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	}
 	wiphy_apply_custom_regulatory(hw->wiphy, regd);
 	ath9k_reg_apply_radar_flags(hw->wiphy);
-	ath9k_reg_apply_world_flags(hw->wiphy, REGDOM_SET_BY_INIT);
+	ath9k_reg_apply_world_flags(hw->wiphy, REGDOM_SET_BY_DRIVER);
 
 	error = ieee80211_register_hw(hw);
 
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index f7d7cc2..4f27cec 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -339,7 +339,6 @@ int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 
 	switch (request->initiator) {
 	case REGDOM_SET_BY_DRIVER:
-	case REGDOM_SET_BY_INIT:
 	case REGDOM_SET_BY_CORE:
 	case REGDOM_SET_BY_USER:
 		break;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 157f3d3..142de14 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -350,8 +350,6 @@ struct bss_parameters {
 
 /**
  * enum reg_set_by - Indicates who is trying to set the regulatory domain
- * @REGDOM_SET_BY_INIT: regulatory domain was set by initialization. We will be
- * 	using a static world regulatory domain by default.
  * @REGDOM_SET_BY_CORE: Core queried CRDA for a dynamic world regulatory domain.
  * @REGDOM_SET_BY_USER: User asked the wireless core to set the
  * 	regulatory domain.
@@ -362,7 +360,6 @@ struct bss_parameters {
  *	should consider.
  */
 enum reg_set_by {
-	REGDOM_SET_BY_INIT,
 	REGDOM_SET_BY_CORE,
 	REGDOM_SET_BY_USER,
 	REGDOM_SET_BY_DRIVER,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ce66bfd..a230d4b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1243,8 +1243,6 @@ static int ignore_request(struct wiphy *wiphy,
 		return 0;
 
 	switch (pending_request->initiator) {
-	case REGDOM_SET_BY_INIT:
-		return -EINVAL;
 	case REGDOM_SET_BY_CORE:
 		return -EINVAL;
 	case REGDOM_SET_BY_COUNTRY_IE:
-- 
1.6.0.3

