Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43420 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759582AbZCaCai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 22:30:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
Subject: [PATCH 6/9] Make ar9170 use common ath reg code
Date: Mon, 30 Mar 2009 22:30:32 -0400
Message-Id: <1238466635-23280-7-git-send-email-lrodriguez@atheros.com> (sfid-20090331_043052_922722_C7975F09)
In-Reply-To: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
References: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christian Lamparter <chunkeey@web.de>

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
 drivers/net/wireless/ar9170/Kconfig  |    1 +
 drivers/net/wireless/ar9170/ar9170.h |    3 +++
 drivers/net/wireless/ar9170/main.c   |   18 ++++++++++++++++++
 drivers/net/wireless/ath/Kconfig     |    2 +-
 4 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ar9170/Kconfig b/drivers/net/wireless/ar9170/Kconfig
index de4281f..b99e326 100644
--- a/drivers/net/wireless/ar9170/Kconfig
+++ b/drivers/net/wireless/ar9170/Kconfig
@@ -2,6 +2,7 @@ config AR9170_USB
 	tristate "Atheros AR9170 802.11n USB support"
 	depends on USB && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
+	select ATH_COMMON
 	help
 	  This is a driver for the Atheros "otus" 802.11n USB devices.
 
diff --git a/drivers/net/wireless/ar9170/ar9170.h b/drivers/net/wireless/ar9170/ar9170.h
index f4fb2e9..87c1985 100644
--- a/drivers/net/wireless/ar9170/ar9170.h
+++ b/drivers/net/wireless/ar9170/ar9170.h
@@ -48,6 +48,8 @@
 #include "eeprom.h"
 #include "hw.h"
 
+#include "../ath/regd.h"
+
 #define PAYLOAD_MAX	(AR9170_MAX_CMD_LEN/4 - 1)
 
 enum ar9170_bw {
@@ -151,6 +153,7 @@ struct ar9170 {
 
 	/* EEPROM */
 	struct ar9170_eeprom eeprom;
+	struct ath_regulatory regulatory;
 
 	/* global tx status for unregistered Stations. */
 	struct sk_buff_head global_tx_status;
diff --git a/drivers/net/wireless/ar9170/main.c b/drivers/net/wireless/ar9170/main.c
index 5996ff9..d40cfae 100644
--- a/drivers/net/wireless/ar9170/main.c
+++ b/drivers/net/wireless/ar9170/main.c
@@ -1619,12 +1619,24 @@ static int ar9170_read_eeprom(struct ar9170 *ar)
 	else
 		ar->hw->channel_change_time = 80 * 1000;
 
+	ar->regulatory.current_rd = le16_to_cpu(ar->eeprom.reg_domain[0]);
+	ar->regulatory.current_rd_ext = le16_to_cpu(ar->eeprom.reg_domain[1]);
+
 	/* second part of wiphy init */
 	SET_IEEE80211_PERM_ADDR(ar->hw, addr);
 
 	return bands ? 0 : -EINVAL;
 }
 
+static int ar9170_reg_notifier(struct wiphy *wiphy,
+			struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct ar9170 *ar = hw->priv;
+
+	return ath_reg_notifier_apply(wiphy, request, &ar->regulatory);
+}
+
 int ar9170_register(struct ar9170 *ar, struct device *pdev)
 {
 	int err;
@@ -1634,10 +1646,16 @@ int ar9170_register(struct ar9170 *ar, struct device *pdev)
 	if (err)
 		goto err_out;
 
+	err = ath_regd_init(&ar->regulatory, ar->hw->wiphy,
+			    ar9170_reg_notifier);
+
 	err = ieee80211_register_hw(ar->hw);
 	if (err)
 		goto err_out;
 
+	if (!ath_is_world_regd(&ar->regulatory))
+		regulatory_hint(ar->hw->wiphy, ar->regulatory.alpha2);
+
 	err = ar9170_init_leds(ar);
 	if (err)
 		goto err_unreg;
diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index c2873a2..76517a4 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -1,4 +1,4 @@
 config ATH_COMMON
 	tristate "Atheros Wireless Cards Shared Support"
-	depends on ATH5K || ATH9K
+	depends on ATH5K || ATH9K || AR9170_USB
 
-- 
1.6.0.6

