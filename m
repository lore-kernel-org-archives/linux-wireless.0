Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:60920 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbbCIIqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 04:46:30 -0400
Received: from [117.207.78.0] (port=10150 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YUtKX-0033Ry-5u
	for linux-wireless@vger.kernel.org; Mon, 09 Mar 2015 04:46:29 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] ath9k: Initialize pll_pwrsave for AR9462/AR9565
Date: Mon,  9 Mar 2015 14:20:08 +0530
Message-Id: <1425891010-21522-4-git-send-email-sujith@msujith.org> (sfid-20150309_094640_310217_24755857)
In-Reply-To: <1425891010-21522-1-git-send-email-sujith@msujith.org>
References: <1425891010-21522-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Cards based on AR9462/AR9565 support more PCIE
power save mechanisms, so register them correctly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   | 3 +++
 drivers/net/wireless/ath/ath9k/hw.h   | 2 +-
 drivers/net/wireless/ath/ath9k/init.c | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 60aa8d7..cc8bea8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -366,6 +366,9 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 		ah->config.rimt_first = 700;
 	}
 
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
+		ah->config.pll_pwrsave = 7;
+
 	/*
 	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
 	 * _and_ if on non-uniprocessor systems (Multiprocessor/HT).
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e124ee2..2067cb5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -341,7 +341,7 @@ struct ath9k_ops_config {
 	u32 ant_ctrl_comm2g_switch_enable;
 	bool xatten_margin_cfg;
 	bool alt_mingainidx;
-	bool pll_pwrsave;
+	u8 pll_pwrsave;
 	bool tx_gain_buffalo;
 	bool led_active_high;
 };
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index ca66fab..de862ad 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -440,6 +440,7 @@ static void ath9k_init_pcoem_platform(struct ath_softc *sc)
 	/*
 	 * The default value of pll_pwrsave is 1.
 	 * For certain AR9485 cards, it is set to 0.
+	 * For AR9462, AR9565 it's set to 7.
 	 */
 	ah->config.pll_pwrsave = 1;
 
-- 
2.3.1

