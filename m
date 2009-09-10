Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbZIJHKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 03:10:16 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/7] ath9k: move ath9k_hw_setpower() to main.c
Date: Thu, 10 Sep 2009 03:10:16 -0400
Message-Id: <1252566619-30390-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
References: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And we make it static.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   12 ------------
 drivers/net/wireless/ath/ath9k/hw.h   |    1 -
 drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c85c80d..352f197 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2951,18 +2951,6 @@ bool ath9k_hw_setpower_nolock(struct ath_hw *ah, enum ath9k_power_mode mode)
 	return status;
 }
 
-bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
-{
-	unsigned long flags;
-	bool ret;
-
-	spin_lock_irqsave(&ah->ah_sc->sc_pm_lock, flags);
-	ret = ath9k_hw_setpower_nolock(ah, mode);
-	spin_unlock_irqrestore(&ah->ah_sc->sc_pm_lock, flags);
-
-	return ret;
-}
-
 /*
  * Helper for ASPM support.
  *
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 730ae9e..c81f0a0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -654,7 +654,6 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs);
 
 bool ath9k_hw_setpower_nolock(struct ath_hw *ah, enum ath9k_power_mode mode);
-bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode);
 
 void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4055246..38c34a2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -243,6 +243,18 @@ static struct ath9k_channel *ath_get_curchannel(struct ath_softc *sc,
 	return channel;
 }
 
+static bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&ah->ah_sc->sc_pm_lock, flags);
+	ret = ath9k_hw_setpower_nolock(ah, mode);
+	spin_unlock_irqrestore(&ah->ah_sc->sc_pm_lock, flags);
+
+	return ret;
+}
+
 void ath9k_ps_wakeup(struct ath_softc *sc)
 {
 	unsigned long flags;
-- 
1.6.3.3

