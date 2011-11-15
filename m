Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48486 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1KOGCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:02:25 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
CC: Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 04/18] ath9k_hw: initialize MCI parameters
Date: Tue, 15 Nov 2011 11:32:13 +0530
Message-ID: <1321336933-12518-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111115_070227_862782_80CABA51)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

these parameter will be utilized and modified in the MCI hardware codes
state machine

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e046de9..34b922b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -408,6 +408,7 @@ fail:
 static int ath9k_init_btcoex(struct ath_softc *sc)
 {
 	struct ath_txq *txq;
+	struct ath_hw *ah = sc->sc_ah;
 	int r;
 
 	switch (sc->sc_ah->btcoex_hw.scheme) {
@@ -426,6 +427,27 @@ static int ath9k_init_btcoex(struct ath_softc *sc)
 		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
 		sc->btcoex.duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
 		INIT_LIST_HEAD(&sc->btcoex.mci.info);
+		if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI) {
+			ah->btcoex_hw.mci.ready = false;
+			ah->btcoex_hw.mci.bt_state = 0;
+			ah->btcoex_hw.mci.bt_ver_major = 3;
+			ah->btcoex_hw.mci.bt_ver_minor = 0;
+			ah->btcoex_hw.mci.bt_version_known = false;
+			ah->btcoex_hw.mci.update_2g5g = true;
+			ah->btcoex_hw.mci.is_2g = true;
+			ah->btcoex_hw.mci.wlan_channels_update = false;
+			ah->btcoex_hw.mci.wlan_channels[0] = 0x00000000;
+			ah->btcoex_hw.mci.wlan_channels[1] = 0xffffffff;
+			ah->btcoex_hw.mci.wlan_channels[2] = 0xffffffff;
+			ah->btcoex_hw.mci.wlan_channels[3] = 0x7fffffff;
+			ah->btcoex_hw.mci.query_bt = true;
+			ah->btcoex_hw.mci.unhalt_bt_gpm = true;
+			ah->btcoex_hw.mci.halted_bt_gpm = false;
+			ah->btcoex_hw.mci.need_flush_btinfo = false;
+			ah->btcoex_hw.mci.wlan_cal_seq = 0;
+			ah->btcoex_hw.mci.wlan_cal_done = 0;
+			ah->btcoex_hw.mci.config = 0x2201;
+		}
 		break;
 	default:
 		WARN_ON(1);
-- 
1.7.0.4

