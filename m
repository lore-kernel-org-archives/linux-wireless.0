Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52216 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZAJLji (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 06:39:38 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 03:39:38 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Fix basic connectivity issue
Date: Sat, 10 Jan 2009 17:07:09 +0530
Message-ID: <1231587429-23989-1-git-send-email-vasanth@atheros.com> (sfid-20090110_123942_176836_59B52955)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch temporarily fixes a regression introduced by BT coexistence support.
There is an instability in connection when BT coexistence is enabled on some h/w.
This interim fix introduces a module parameter for BT coexistence configuration.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index cbd408f..6800e5c 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -23,6 +23,10 @@
 #include "phy.h"
 #include "initvals.h"
 
+static int btcoex_enable;
+module_param(btcoex_enable, bool, 0);
+MODULE_PARM_DESC(btcoex_enable, "Enable Bluetooth coexistence support");
+
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
@@ -3359,7 +3363,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	pCap->num_antcfg_2ghz =
 		ath9k_hw_get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_10_OR_LATER(ah) && btcoex_enable) {
 		pCap->hw_caps |= ATH9K_HW_CAP_BT_COEX;
 		ah->ah_btactive_gpio = 6;
 		ah->ah_wlanactive_gpio = 5;
-- 
1.5.5.1

