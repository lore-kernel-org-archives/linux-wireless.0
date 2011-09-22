Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56531 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab1IVOEs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 10:04:48 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	nataraja@qca.qualcomm.com
Subject: [PATCH] ath9k: fix a regression in ath9k_ps_restore
Date: Thu, 22 Sep 2011 08:04:32 -0600
Message-Id: <1316700272-8656-1-git-send-email-nbd@openwrt.org> (sfid-20110922_160456_257797_6359B287)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After 'ath9k: optimize ath9k_ps_restore', it would only send the device to
network sleep and not to full sleep anymore, potentially causing more
battery drain.

Reported-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ee39702..616bf16 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -133,7 +133,7 @@ void ath9k_ps_restore(struct ath_softc *sc)
 	ath_hw_cycle_counters_update(common);
 	spin_unlock(&common->cc_lock);
 
-	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
+	ath9k_hw_setpower(sc->sc_ah, mode);
 
  unlock:
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
-- 
1.7.3.2

