Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42568 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2BVHKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:10:25 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38103.756886.834632@gargle.gargle.HOWL> (sfid-20120222_081041_547626_39E99A12)
Date: Wed, 22 Feb 2012 12:40:15 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 03/26] ath9k: Initialize MCI params using a helper
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   24 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/btcoex.h |    1 +
 drivers/net/wireless/ath/ath9k/init.c   |   23 ++---------------------
 3 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index a6712a9..6566952 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -152,6 +152,30 @@ void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_btcoex_init_3wire);
 
+void ath9k_hw_btcoex_init_mci(struct ath_hw *ah)
+{
+	ah->btcoex_hw.mci.ready = false;
+	ah->btcoex_hw.mci.bt_state = 0;
+	ah->btcoex_hw.mci.bt_ver_major = 3;
+	ah->btcoex_hw.mci.bt_ver_minor = 0;
+	ah->btcoex_hw.mci.bt_version_known = false;
+	ah->btcoex_hw.mci.update_2g5g = true;
+	ah->btcoex_hw.mci.is_2g = true;
+	ah->btcoex_hw.mci.wlan_channels_update = false;
+	ah->btcoex_hw.mci.wlan_channels[0] = 0x00000000;
+	ah->btcoex_hw.mci.wlan_channels[1] = 0xffffffff;
+	ah->btcoex_hw.mci.wlan_channels[2] = 0xffffffff;
+	ah->btcoex_hw.mci.wlan_channels[3] = 0x7fffffff;
+	ah->btcoex_hw.mci.query_bt = true;
+	ah->btcoex_hw.mci.unhalt_bt_gpm = true;
+	ah->btcoex_hw.mci.halted_bt_gpm = false;
+	ah->btcoex_hw.mci.need_flush_btinfo = false;
+	ah->btcoex_hw.mci.wlan_cal_seq = 0;
+	ah->btcoex_hw.mci.wlan_cal_done = 0;
+	ah->btcoex_hw.mci.config = 0x2201;
+}
+EXPORT_SYMBOL(ath9k_hw_btcoex_init_mci);
+
 static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 0cb7ce9..0cb15cd 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -99,6 +99,7 @@ struct ath_btcoex_hw {
 
 void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah);
 void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah);
+void ath9k_hw_btcoex_init_mci(struct ath_hw *ah);
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum);
 void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
 				u32 bt_weight,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 53a005d..a944fc9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -449,27 +449,8 @@ static int ath9k_init_btcoex(struct ath_softc *sc)
 		if (r)
 			return r;
 
-		if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI) {
-			ah->btcoex_hw.mci.ready = false;
-			ah->btcoex_hw.mci.bt_state = 0;
-			ah->btcoex_hw.mci.bt_ver_major = 3;
-			ah->btcoex_hw.mci.bt_ver_minor = 0;
-			ah->btcoex_hw.mci.bt_version_known = false;
-			ah->btcoex_hw.mci.update_2g5g = true;
-			ah->btcoex_hw.mci.is_2g = true;
-			ah->btcoex_hw.mci.wlan_channels_update = false;
-			ah->btcoex_hw.mci.wlan_channels[0] = 0x00000000;
-			ah->btcoex_hw.mci.wlan_channels[1] = 0xffffffff;
-			ah->btcoex_hw.mci.wlan_channels[2] = 0xffffffff;
-			ah->btcoex_hw.mci.wlan_channels[3] = 0x7fffffff;
-			ah->btcoex_hw.mci.query_bt = true;
-			ah->btcoex_hw.mci.unhalt_bt_gpm = true;
-			ah->btcoex_hw.mci.halted_bt_gpm = false;
-			ah->btcoex_hw.mci.need_flush_btinfo = false;
-			ah->btcoex_hw.mci.wlan_cal_seq = 0;
-			ah->btcoex_hw.mci.wlan_cal_done = 0;
-			ah->btcoex_hw.mci.config = 0x2201;
-		}
+		ath9k_hw_btcoex_init_mci(ah);
+
 		break;
 	default:
 		WARN_ON(1);
-- 
1.7.9.1

