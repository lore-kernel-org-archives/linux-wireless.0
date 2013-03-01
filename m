Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53900 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3CAEEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 23:04:30 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k: Allow using ath9k-rate-control without forcing it.
Date: Thu, 28 Feb 2013 20:04:20 -0800
Message-Id: <1362110660-22685-1-git-send-email-greearb@candelatech.com> (sfid-20130301_050435_375392_A61B1798)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Let user still pick the rate control method by setting the
mac80211 module option, ie:

[root@ct520-6157 lanforge]# cat /etc/modprobe.d/mac80211.conf
options mac80211 ieee80211_default_rc_algo=ath9k_rate_control

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

Maybe this instead of outright removing ath9k rate control?

 drivers/net/wireless/ath/ath9k/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index af932c9..e27764d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -810,7 +810,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	sc->ant_tx = hw->wiphy->available_antennas_tx;
 
 #ifdef CONFIG_ATH9K_RATE_CONTROL
-	hw->rate_control_algorithm = "ath9k_rate_control";
+	/* hw->rate_control_algorithm = "ath9k_rate_control"; */
 #endif
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
-- 
1.7.3.4

