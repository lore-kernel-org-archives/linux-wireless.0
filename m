Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57372 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab1LDHjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Dec 2011 02:39:06 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.2] ath9k: fix check for antenna diversity support
Date: Sun,  4 Dec 2011 08:38:54 +0100
Message-Id: <1322984334-62659-1-git-send-email-nbd@openwrt.org> (sfid-20111204_083913_456385_8694EDC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fixes a regression on single-stream chips introduced in
commit 43c3528430bd29f5e52438cad7cf7c0c62bf4583
"ath9k: implement .get_antenna and .set_antenna"

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 714c7d8..1c87c7f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -286,7 +286,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 			ath_start_ani(common);
 	}
 
-	if (ath9k_hw_ops(ah)->antdiv_comb_conf_get && sc->ant_rx != 3) {
+	if ((ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) && sc->ant_rx != 3) {
 		struct ath_hw_antcomb_conf div_ant_conf;
 		u8 lna_conf;
 
-- 
1.7.3.2

