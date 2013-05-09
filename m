Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48777 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3EIFjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 01:39:39 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20875.13834.615920.337442@gargle.gargle.HOWL> (sfid-20130509_073953_625459_295D9AF4)
Date: Thu, 9 May 2013 11:07:14 +0530
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Disable spectral scan code to fix crash on rmmod.
In-Reply-To: <1368050908-7554-1-git-send-email-greearb@candelatech.com>
References: <1368050908-7554-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> With CONFIG_ATH9K_DEBUGFS enabled, and slub memory poisoning
> enabled, I see this crash on rmmod of ath9k.  I'm not sure how
> to fix this properly, but in the meantime, this patch to disable
> the spectral scan code works around the problem for me.
> 
> With memory poisoning and the verify_mem_not_deleted code
> below added, the crash looks as follows...  The dentry
> is not *always* freed at this point, probably because rcu
> callbacks haven't completed.  You still get a crash soon
> after, however.

The relay file should probably be closed before calling ieee80211_unregister_hw().
The ath9k debugfs directory is created inside the phy#/ directory and that would
get cleaned up when the wiphy is unregistered.

Does this help ?

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 4101c4a..cecbe1f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1684,6 +1684,14 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
 	WARN_ON(i != ATH9K_SSTATS_LEN);
 }
 
+void ath9k_deinit_debug(struct ath_softc *sc)
+{
+	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && sc->rfs_chan_spec_scan) {
+		relay_close(sc->rfs_chan_spec_scan);
+		sc->rfs_chan_spec_scan = NULL;
+	}
+}
+
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 62da19c..223418d 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -297,6 +297,7 @@ struct ath9k_debug {
 };
 
 int ath9k_init_debug(struct ath_hw *ah);
+void ath9k_deinit_debug(struct ath_softc *sc);
 
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
@@ -332,6 +333,10 @@ static inline int ath9k_init_debug(struct ath_hw *ah)
 	return 0;
 }
 
+static inline void ath9k_deinit_debug(struct ath_softc *sc)
+{
+}
+
 static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
 					    enum ath9k_int status)
 {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c7b888f..c0aa4ff 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -903,7 +903,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 	if (!ath_is_world_regd(reg)) {
 		error = regulatory_hint(hw->wiphy, reg->alpha2);
 		if (error)
-			goto unregister;
+			goto debug_cleanup;
 	}
 
 	ath_init_leds(sc);
@@ -911,6 +911,8 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 
 	return 0;
 
+debug_cleanup:
+	ath9k_deinit_debug(sc);
 unregister:
 	ieee80211_unregister_hw(hw);
 rx_cleanup:
@@ -939,11 +941,6 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 		sc->dfs_detector->exit(sc->dfs_detector);
 
 	ath9k_eeprom_release(sc);
-
-	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && sc->rfs_chan_spec_scan) {
-		relay_close(sc->rfs_chan_spec_scan);
-		sc->rfs_chan_spec_scan = NULL;
-	}
 }
 
 void ath9k_deinit_device(struct ath_softc *sc)
@@ -957,6 +954,7 @@ void ath9k_deinit_device(struct ath_softc *sc)
 
 	ath9k_ps_restore(sc);
 
+	ath9k_deinit_debug(sc);
 	ieee80211_unregister_hw(hw);
 	ath_rx_cleanup(sc);
 	ath9k_deinit_softc(sc);
