Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35470 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754578AbZCCRZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:34 -0500
Message-Id: <20090303172527.793025391@atheros.com> (sfid-20090303_182544_436438_581A56A3)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:37 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 12/15] ath9k: Add workaround to recover from failed channel changes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like channel change may fail in some cases and end up leaving
the hardware in state where it cannot transmit any frames. Add a
workaround to recover from this state if we detect that wiphy
selection is failing due to wiphys not leaving PAUSING state.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/ath9k.h   |    4 +++
 drivers/net/wireless/ath9k/main.c    |    4 +--
 drivers/net/wireless/ath9k/virtual.c |   37 +++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:31:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:32:06.000000000 +0200
@@ -567,6 +567,8 @@ struct ath_softc {
 	int chan_is_ht;
 	struct ath_wiphy *next_wiphy;
 	struct work_struct chan_work;
+	int wiphy_select_failures;
+	unsigned long wiphy_select_first_fail;
 
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
@@ -665,6 +667,8 @@ void ath9k_update_ichannel(struct ath_so
 void ath_update_chainmask(struct ath_softc *sc, int is_ht);
 int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		    struct ath9k_channel *hchan);
+void ath_radio_enable(struct ath_softc *sc);
+void ath_radio_disable(struct ath_softc *sc);
 
 #ifdef CONFIG_PCI
 int ath_pci_init(void);
--- wireless-testing.orig/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:31:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:32:06.000000000 +0200
@@ -432,6 +432,18 @@ int ath9k_wiphy_unpause(struct ath_wiphy
 	return ret;
 }
 
+static void __ath9k_wiphy_mark_all_paused(struct ath_softc *sc)
+{
+	int i;
+	if (sc->pri_wiphy->state != ATH_WIPHY_INACTIVE)
+		sc->pri_wiphy->state = ATH_WIPHY_PAUSED;
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		if (sc->sec_wiphy[i] &&
+		    sc->sec_wiphy[i]->state != ATH_WIPHY_INACTIVE)
+			sc->sec_wiphy[i]->state = ATH_WIPHY_PAUSED;
+	}
+}
+
 /* caller must hold wiphy_lock */
 static void __ath9k_wiphy_pause_all(struct ath_softc *sc)
 {
@@ -452,9 +464,34 @@ int ath9k_wiphy_select(struct ath_wiphy 
 
 	spin_lock_bh(&sc->wiphy_lock);
 	if (__ath9k_wiphy_pausing(sc)) {
+		if (sc->wiphy_select_failures == 0)
+			sc->wiphy_select_first_fail = jiffies;
+		sc->wiphy_select_failures++;
+		if (time_after(jiffies, sc->wiphy_select_first_fail + HZ / 2))
+		{
+			printk(KERN_DEBUG "ath9k: Previous wiphy select timed "
+			       "out; disable/enable hw to recover\n");
+			__ath9k_wiphy_mark_all_paused(sc);
+			/*
+			 * TODO: this workaround to fix hardware is unlikely to
+			 * be specific to virtual wiphy changes. It can happen
+			 * on normal channel change, too, and as such, this
+			 * should really be made more generic. For example,
+			 * tricker radio disable/enable on GTT interrupt burst
+			 * (say, 10 GTT interrupts received without any TX
+			 * frame being completed)
+			 */
+			spin_unlock_bh(&sc->wiphy_lock);
+			ath_radio_disable(sc);
+			ath_radio_enable(sc);
+			queue_work(aphy->sc->hw->workqueue,
+				   &aphy->sc->chan_work);
+			return -EBUSY; /* previous select still in progress */
+		}
 		spin_unlock_bh(&sc->wiphy_lock);
 		return -EBUSY; /* previous select still in progress */
 	}
+	sc->wiphy_select_failures = 0;
 
 	/* Store the new channel */
 	sc->chan_idx = aphy->chan_idx;
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:32:00.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:32:06.000000000 +0200
@@ -1088,7 +1088,7 @@ fail:
 /*	Rfkill	   */
 /*******************/
 
-static void ath_radio_enable(struct ath_softc *sc)
+void ath_radio_enable(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_channel *channel = sc->hw->conf.channel;
@@ -1129,7 +1129,7 @@ static void ath_radio_enable(struct ath_
 	ath9k_ps_restore(sc);
 }
 
-static void ath_radio_disable(struct ath_softc *sc)
+void ath_radio_disable(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_channel *channel = sc->hw->conf.channel;

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
