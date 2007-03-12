Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:59952 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964817AbXCLAId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2007 20:08:33 -0400
Date: Mon, 12 Mar 2007 01:04:20 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFT] [PATCH] bcm43xx: ACI fixes
Message-ID: <20070312010420.353a59c0@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please test the following patch. It syncs ACI (Adjacent Channels
Interference) code to specs. I can't test it right now. Will port to
mac80211 branch ASAP.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
----

diff --git a/drivers/net/wireless/bcm43xx/bcm43xx.h b/drivers/net/wireless/bcm43xx/bcm43xx.h
index 95ff175..7023327 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx.h
+++ b/drivers/net/wireless/bcm43xx/bcm43xx.h
@@ -398,6 +398,9 @@
 #define BCM43xx_DEFAULT_SHORT_RETRY_LIMIT	7
 #define BCM43xx_DEFAULT_LONG_RETRY_LIMIT	4
 
+/* Statscounter offsets. */
+#define BCM43xx_SC_ACI		0x2E
+
 /* FIXME: the next line is a guess as to what the maximum RSSI value might be */
 #define RX_RSSI_MAX				60
 
@@ -550,7 +553,11 @@ struct bcm43xx_phyinfo {
 	u8 connected:1,
 	   calibrated:1,
 	   is_locked:1, /* used in bcm43xx_phy_{un}lock() */
-	   dyn_tssi_tbl:1; /* used in bcm43xx_phy_init_tssi2dbm_table() */
+	   dyn_tssi_tbl:1, /* used in bcm43xx_phy_init_tssi2dbm_table() */
+	   g_interfmode:1; /* bit 4000 in PHY_G_CRS, used in periodic tasks */
+	u8 g_interfmode_timer; /* how much time ago g_interfmode was unset */
+	u16 g_sc_saved; /* used in periodic tasks for ACI */
+
 	/* LO Measurement Data.
 	 * Use bcm43xx_get_lopair() to get a value.
 	 */
@@ -629,7 +636,9 @@ struct bcm43xx_radioinfo {
 	/* ACI (adjacent channel interference) flags. */
 	u8 aci_enable:1,
 	   aci_wlan_automatic:1,
-	   aci_hw_rssi:1;
+	   aci_hw_rssi:1,
+	   aci_delay:5;
+	u8 aci_start;
 };
 
 /* Data structures for DMA transmission, per 80211 core. */
@@ -699,6 +708,18 @@ struct bcm43xx_noise_calculation {
 	s8 samples[8][4];
 };
 
+/* Statscounter data (currently ACI only). */
+struct bcm43xx_statscounter_saved {
+	u16 aci;
+};
+
+/* Values for ACI moving average calculation. */
+struct bcm43xx_aci_saved {
+	u16 value[8];
+	u8 next:3,
+	   set:3;
+};
+
 struct bcm43xx_stats {
 	u8 noise;
 	struct iw_statistics wstats;
@@ -812,6 +833,10 @@ struct bcm43xx_private {
 	u32 irq_savedstate;
 	/* Link Quality calculation context. */
 	struct bcm43xx_noise_calculation noisecalc;
+	/* Statscounter tracking. */
+	struct bcm43xx_statscounter_saved sc;
+	/* ACI tracking. */
+	struct bcm43xx_aci_saved aci;
 	/* if > 0 MAC is suspended. if == 0 MAC is enabled. */
 	int mac_suspended;
 
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
index e594af4..27ec519 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -3059,6 +3059,44 @@ static void bcm43xx_pcie_mdio_write(stru
 	bcm43xx_write32(bcm, BCM43xx_PCIECORE_MDIO_CTL, 0);
 }
 
+/* We don't use any statscounter other than ACI for now */
+static u16 bcm43xx_sc_read(struct bcm43xx_private *bcm)
+{
+	struct bcm43xx_statscounter_saved *sc = &bcm->sc;
+	u16 tmp;
+
+	tmp = bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED, 0x80 + BCM43xx_SC_ACI)
+		- sc->aci;
+	if (tmp)
+		sc->aci += tmp;
+
+	return tmp;
+}
+
+static u16 bcm43xx_aci_moving_average(struct bcm43xx_private *bcm)
+{
+	struct bcm43xx_aci_saved *aci = &bcm->aci;
+
+	u8 i;
+	u16 avg;
+	u32 sum = 0;
+
+	aci->value[aci->next] = bcm43xx_sc_read(bcm);
+	if (unlikely(aci->set < 7))
+		aci->set++;
+	for (i = 0; i < aci->set; i++)
+		sum += aci->value[i];
+	avg = sum / (u16)8;
+	if ((sum % 8) > 3)
+		avg++;
+	if (aci->next < 7)
+		aci->next++;
+	else
+		aci->next = 0;
+
+	return avg;
+}
+
 /* Make an I/O Core usable. "core_mask" is the bitmask of the cores to enable.
  * To enable core 0, pass a core_mask of 1<<0
  */
@@ -3182,6 +3220,8 @@ static void bcm43xx_periodic_every1sec(s
 	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
 	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
 	int radio_hw_enable;
+	unsigned long phylock_flags;
+	u16 tmp;
 
 	/* check if radio hardware enabled status changed */
 	radio_hw_enable = bcm43xx_is_hw_radio_enabled(bcm);
@@ -3191,27 +3231,56 @@ static void bcm43xx_periodic_every1sec(s
 		       (radio_hw_enable == 0) ? "disabled" : "enabled");
 		bcm43xx_leds_update(bcm, 0);
 	}
+
 	if (phy->type == BCM43xx_PHYTYPE_G) {
-		//TODO: update_aci_moving_average
-		if (radio->aci_enable && radio->aci_wlan_automatic) {
+		
+		if (radio->aci_start < 60)
+			radio->aci_start++;
+		if (radio->aci_delay)
+			radio->aci_delay--;
+		if (phy->g_interfmode && phy->g_interfmode_timer < 30)
+			phy->g_interfmode_timer++;
+
+		if (radio->interfmode == BCM43xx_RADIO_INTERFMODE_AUTOWLAN &&
+				!radio->aci_delay) {
 			bcm43xx_mac_suspend(bcm);
-			if (!radio->aci_enable && 1 /*TODO: not scanning? */) {
-				if (0 /*TODO: bunch of conditions*/) {
-					bcm43xx_radio_set_interference_mitigation(bcm,
-										  BCM43xx_RADIO_INTERFMODE_MANUALWLAN);
-				}
-			} else if (1/*TODO*/) {
-				/*
-				if ((aci_average > 1000) && !(bcm43xx_radio_aci_scan(bcm))) {
-					bcm43xx_radio_set_interference_mitigation(bcm,
-										  BCM43xx_RADIO_INTERFMODE_NONE);
+			if (!radio->aci_enable)
+			{
+				if (bcm43xx_aci_moving_average(bcm) < 200) {
+					if (bcm43xx_radio_aci_scan(bcm)) {
+						bcm43xx_radio_set_interference_mitigation(bcm,
+							BCM43xx_RADIO_INTERFMODE_MANUALWLAN);
+						radio->aci_start = 0;
+					} else
+						radio->aci_delay = 20;
 				}
-				*/
+			} else if (radio->aci_start == 60) {
+				if (bcm43xx_aci_moving_average(bcm) > 1000)
+					if (!bcm43xx_radio_aci_scan(bcm))
+						bcm43xx_radio_set_interference_mitigation(bcm,
+							BCM43xx_RADIO_INTERFMODE_NONE);
 			}
 			bcm43xx_mac_enable(bcm);
 		} else if (radio->interfmode == BCM43xx_RADIO_INTERFMODE_NONWLAN &&
-			   phy->rev == 1) {
-			//TODO: implement rev1 workaround
+				phy->rev == 1) {
+			tmp = bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED, 0x00AE);
+			if (phy->g_interfmode) {
+				if (tmp && ((tmp - phy->g_sc_saved) > 1500)) {
+					bcm43xx_phy_lock(bcm, phylock_flags);
+					bcm43xx_phy_write(bcm, 0x00AE,
+						bcm43xx_phy_read(bcm, 0x00AE) & ~0x4000);
+					bcm43xx_phy_unlock(bcm, phylock_flags);
+					phy->g_interfmode = 1;
+					phy->g_interfmode_timer = 0;
+				}
+			} else if (phy->g_interfmode_timer == 30) {
+						bcm43xx_phy_lock(bcm, phylock_flags);
+						bcm43xx_phy_write(bcm, 0x00AE,
+							bcm43xx_phy_read(bcm, 0x00AE & 0x4000));
+						bcm43xx_phy_unlock(bcm, phylock_flags);
+						phy->g_interfmode = 0;
+			}
+			phy->g_sc_saved = tmp;
 		}
 	}
 }
@@ -3297,10 +3366,16 @@ void bcm43xx_periodic_tasks_delete(struc
 void bcm43xx_periodic_tasks_setup(struct bcm43xx_private *bcm)
 {
 	struct delayed_work *work = &bcm->periodic_work;
+	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
 
 	assert(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED);
 	INIT_DELAYED_WORK(work, bcm43xx_periodic_work_handler);
 	schedule_delayed_work(work, 0);
+	
+	if (bcm43xx_phy_read(bcm, BCM43xx_PHY_G_CRS) & 0x4000)
+		phy->g_interfmode = 1;
+	else
+		phy->g_interfmode = 0;
 }
 
 static void bcm43xx_security_init(struct bcm43xx_private *bcm)
@@ -3429,6 +3504,8 @@ static void prepare_radiodata_for_init(s
 	radio->aci_enable = 0;
 	radio->aci_wlan_automatic = 0;
 	radio->aci_hw_rssi = 0;
+	radio->aci_start = 0;
+	radio->aci_delay = 0;
 }
 
 static void prepare_priv_for_init(struct bcm43xx_private *bcm)
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
