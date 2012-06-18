Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8162 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2FRGYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 02:24:52 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 09/10] ath9k: Add WoW related mac80211 callbacks
Date: Mon, 18 Jun 2012 11:51:53 +0530
Message-ID: <1340000514-7779-10-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120618_082455_212783_170ED90C)
In-Reply-To: <1340000514-7779-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1340000514-7779-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

add suspend/resume/set_wakeup callbacks to the driver

*suspend

- bail out only if all the conditions for configuring WoW
  is fine, currently multivif case is not handled
- check for associated state
- map wow triggers from user space data
- add deauth/disassoc pattern and user defined pattern.,
  for the later a list is maintained
- store the interrupt mask before suspend, enabled beacon
  miss interrupt for WoW
- configure WoW in the hardware by calling the
  ath9k_hw_wow_enable

*resume

- restore the interrupts based on the interrupt mask
  stored before suspend
- call ath9k_hw_wow_wakeup to configure/restore the hardware
  after wow wakeup by clearning away WoW events and also
  to know the WoW wakeup reason from the status register

*set_wakeup

- to call 'device_set_wakeup_enable' from cfg80211/mac80211
  when wow is configured and as per Rafael/johannnes the
  right way to do so rather in the driver suspend/resume
  call back

also a minor cleanup

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    9 +
 drivers/net/wireless/ath/ath9k/init.c  |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |  375 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/pci.c   |    3 +
 4 files changed, 379 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 264c25b..292e61a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -518,6 +518,14 @@ struct ath9k_wow_info {
 	struct list_head wow_patterns;
 };
 
+#ifdef CONFIG_PM_SLEEP
+void ath_wow_cleanup(struct ath_softc *sc);
+#else
+static inline void ath_wow_cleanup(struct ath_softc *sc)
+{
+}
+#endif
+
 /********************/
 /*   LED Control    */
 /********************/
@@ -719,6 +727,7 @@ struct ath_softc {
 	struct ath_ant_comb ant_comb;
 	u8 ant_tx, ant_rx;
 	struct dfs_pattern_detector *dfs_detector;
+	u32 wow_enabled;
 
 #ifdef CONFIG_PM_SLEEP
 	bool wow_got_bmiss_intr;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d08824f..39bf275 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -885,6 +885,7 @@ void ath9k_deinit_device(struct ath_softc *sc)
 	ath9k_ps_restore(sc);
 
 	ieee80211_unregister_hw(hw);
+	ath_wow_cleanup(sc);
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
 	ath9k_deinit_softc(sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 52561b3..eca3f40 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -486,6 +486,17 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (status & SCHED_INTR)
 		sched = true;
 
+#ifdef CONFIG_PM_SLEEP
+	if (status & ATH9K_INT_BMISS) {
+		if (sc->wow_sleep_proc_intr) {
+			ath_dbg(common, ANY, "during WoW we got a BMISS\n");
+			sc->wow_got_bmiss_intr = true;
+			sc->wow_sleep_proc_intr = false;
+		}
+	ath_dbg(common, INTERRUPT, "beacon miss interrupt\n");
+	}
+#endif
+
 	/*
 	 * If a FATAL or RXORN interrupt is received, we have to reset the
 	 * chip immediately.
@@ -2091,24 +2102,364 @@ static void ath9k_get_et_stats(struct ieee80211_hw *hw,
 #endif
 
 
+#ifdef CONFIG_PM_SLEEP
+
+void ath_wow_cleanup(struct ath_softc *sc)
+{
+	struct ath9k_wow_info *wow_info = &sc->wow_info;
+	struct ath9k_wow_pattern *wow_pattern  = NULL, *tmp;
+
+	if (!(sc->wow_enabled & AH_WOW_USER_PATTERN_EN))
+		return;
+
+	list_for_each_entry_safe(wow_pattern, tmp,
+				 &wow_info->wow_patterns, list) {
+
+		list_del(&wow_pattern->list);
+		kfree(wow_pattern);
+	}
+
+}
+
+static void ath9k_wow_map_triggers(struct ath_softc *sc,
+				   struct cfg80211_wowlan *wowlan,
+				   u32 *wow_triggers)
+{
+	if (wowlan->disconnect)
+		*wow_triggers |= AH_WOW_LINK_CHANGE |
+				AH_WOW_BEACON_MISS;
+	if (wowlan->magic_pkt)
+		*wow_triggers |= AH_WOW_MAGIC_PATTERN_EN;
+
+	if (wowlan->n_patterns)
+		*wow_triggers |= AH_WOW_USER_PATTERN_EN;
+
+	sc->wow_enabled = *wow_triggers;
+
+}
+
+void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_capabilities *pcaps = &ah->caps;
+	int pattern_count = 0;
+	int i, byte_cnt;
+	u8 dis_deauth_pattern[MAX_PATTERN_SIZE];
+	u8 dis_deauth_mask[MAX_PATTERN_SIZE];
+
+	memset(dis_deauth_pattern, 0, MAX_PATTERN_SIZE);
+	memset(dis_deauth_mask, 0, MAX_PATTERN_SIZE);
+
+	/*
+	 * Create Dissassociate / Deauthenticate packet filter
+	 *
+	 *     2 bytes        2 byte    6 bytes   6 bytes  6 bytes
+	 *  +--------------+----------+---------+--------+--------+----
+	 *  + Frame Control+ Duration +   DA    +  SA    +  BSSID +
+	 *  +--------------+----------+---------+--------+--------+----
+	 *
+	 * The above is the management frame format for disassociate/
+	 * deauthenticate pattern, from this we need to match the first byte
+	 * of 'Frame Control' and DA, SA, and BSSID fields
+	 * (skipping 2nd byte of FC and Duration feild.
+	 *
+	 * Disassociate pattern
+	 * --------------------
+	 * Frame control = 00 00 1010
+	 * DA, SA, BSSID = x:x:x:x:x:x
+	 * Pattern will be A0000000 | x:x:x:x:x:x | x:x:x:x:x:x
+	 *			    | x:x:x:x:x:x  -- 22 bytes
+	 *
+	 * Deauthenticate pattern
+	 * ----------------------
+	 * Frame control = 00 00 1100
+	 * DA, SA, BSSID = x:x:x:x:x:x
+	 * Pattern will be C0000000 | x:x:x:x:x:x | x:x:x:x:x:x
+	 *			    | x:x:x:x:x:x  -- 22 bytes
+	 */
+
+	/* Create Disassociate Pattern first */
+
+	byte_cnt = 0;
+
+	/* Fill out the mask with all FF's */
+
+	for (i = 0; i < MAX_PATTERN_MASK_SIZE; i++)
+		dis_deauth_mask[i] = 0xff;
+
+	/* copy the first byte of frame control field */
+	dis_deauth_pattern[byte_cnt] = 0xa0;
+	byte_cnt++;
+
+	/* skip 2nd byte of frame control and Duration field */
+	byte_cnt += 3;
+
+	/*
+	 * need not match the destination mac address, it can be a broadcast
+	 * mac address or an unicast to this station
+	 */
+	byte_cnt += 6;
+
+	/* copy the source mac address */
+	memcpy((dis_deauth_pattern + byte_cnt), common->curbssid, ETH_ALEN);
+
+	byte_cnt += 6;
+
+	/* copy the bssid, its same as the source mac address */
+
+	memcpy((dis_deauth_pattern + byte_cnt), common->curbssid, ETH_ALEN);
+
+	/* Create Disassociate pattern mask */
+
+	if (pcaps->wow_caps & ATH9K_HW_WOW_PATTERN_MATCH_EXACT) {
+
+		if (pcaps->wow_caps & ATH9K_HW_WOW_PATTERN_MATCH_DWORD) {
+			/*
+			 * for AR9280, because of hardware limitation, the
+			 * first 4 bytes have to be matched for all patterns.
+			 * the mask for disassociation and de-auth pattern
+			 * matching need to enable the first 4 bytes.
+			 * also the duration field needs to be filled.
+			 */
+			dis_deauth_mask[0] = 0xf0;
+
+			/*
+			 * fill in duration field
+			 FIXME: what is the exact value ?
+			 */
+			dis_deauth_pattern[2] = 0xff;
+			dis_deauth_pattern[3] = 0xff;
+		} else {
+			dis_deauth_mask[0] = 0xfe;
+		}
+
+		dis_deauth_mask[1] = 0x03;
+		dis_deauth_mask[2] = 0xc0;
+	} else {
+		dis_deauth_mask[0] = 0xef;
+		dis_deauth_mask[1] = 0x3f;
+		dis_deauth_mask[2] = 0x00;
+		dis_deauth_mask[3] = 0xfc;
+	}
+
+	ath_dbg(common, WOW, "Adding disassoc/deauth patterns for WoW\n");
+
+	ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
+				   pattern_count, byte_cnt);
+
+	pattern_count++;
+	/*
+	 * for de-authenticate pattern, only the first byte of the frame
+	 * control field gets changed from 0xA0 to 0xC0
+	 */
+	dis_deauth_pattern[0] = 0xC0;
+
+	ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
+				   pattern_count, byte_cnt);
+
+}
+
+void ath9k_wow_add_pattern(struct ath_softc *sc, struct cfg80211_wowlan *wowlan)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_wow_info *wow_info = &sc->wow_info;
+	struct ath9k_wow_pattern *wow_pattern = NULL;
+	struct cfg80211_wowlan_trig_pkt_pattern *patterns = wowlan->patterns;
+	int mask_len;
+	s8 i = 0;
+
+	if (!wowlan->n_patterns)
+		return;
+
+	/*
+	 * Clear existing WoW patterns.
+	 */
+	ath_wow_cleanup(sc);
+
+	/*
+	 * Add the new user configured patterns
+	 */
+	for (i = 0; i < wowlan->n_patterns; i++) {
+
+		wow_pattern = kzalloc(sizeof(*wow_pattern), GFP_KERNEL);
+
+		if (!wow_pattern)
+			return;
+
+		mask_len = DIV_ROUND_UP(wowlan->patterns[i].pattern_len, 8);
+		memset(wow_pattern->pattern_bytes, 0, MAX_PATTERN_SIZE);
+		memset(wow_pattern->mask_bytes, 0, MAX_PATTERN_SIZE);
+		memcpy(wow_pattern->pattern_bytes, patterns[i].pattern,
+		       patterns[i].pattern_len);
+		memcpy(wow_pattern->mask_bytes, patterns[i].mask, mask_len);
+		wow_pattern->pattern_len = patterns[i].pattern_len;
+
+		list_add_tail(&wow_pattern->list, &wow_info->wow_patterns);
+		wow_info->num_of_patterns = i + 2;
+		/*
+		 * just need to take care of deauth and disssoc pattern,
+		 * make sure we don't overwrite them.
+		 */
+
+		ath9k_hw_wow_apply_pattern(ah, wow_pattern->pattern_bytes,
+					   wow_pattern->mask_bytes,
+					   wow_info->num_of_patterns,
+					   wow_pattern->pattern_len);
+
+	}
+
+}
+
+static int ath9k_suspend(struct ieee80211_hw *hw,
+			 struct cfg80211_wowlan *wowlan)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 wow_triggers_enabled = 0;
+	int ret = 0;
+
+	mutex_lock(&sc->mutex);
+
+	if (WARN_ON(!wowlan)) {
+		ath_dbg(common, WOW, "None of the WoW triggers enabled\n");
+		ret = -EINVAL;
+		goto fail_wow;
+	}
+
+	if (!device_can_wakeup(sc->dev)) {
+		ath_dbg(common, WOW, "device_can_wakeup failed, WoW is not enabled\n");
+		ret = 1;
+		goto fail_wow;
+	}
+
+	/*
+	 * none of the sta vifs are associated
+	 * and we are not currently handling multivif
+	 * cases, for instance we have to seperately
+	 * configure 'keep alive frame' for each
+	 * STA.
+	 */
+	if (!(sc->sc_flags & SC_OP_PRIM_STA_VIF)) {
+		ath_dbg(common, WOW, "None of the STA vifs are associated\n");
+		ret = 1;
+		goto fail_wow;
+	}
+
+	if (sc->nvifs > 1) {
+		ath_dbg(common, WOW, "WoW for multivif is not yet supported\n");
+		ret = 1;
+		goto fail_wow;
+	}
+
+	ath9k_wow_map_triggers(sc, wowlan, &wow_triggers_enabled);
+
+	ath_dbg(common, WOW, "WoW triggers enabled 0x%x\n",
+		wow_triggers_enabled);
+
+	ath9k_ps_wakeup(sc);
+
+	/*
+	 * Enable wake up on recieving disassoc/deauth
+	 * frame by default.
+	 */
+	ath9k_wow_add_disassoc_deauth_pattern(sc);
+
+	if (wow_triggers_enabled & AH_WOW_USER_PATTERN_EN)
+		ath9k_wow_add_pattern(sc, wowlan);
+
+	/*
+	 * To avoid false wake, we enable beacon miss interrupt only
+	 * when we go to sleep. We save the current interrupt mask
+	 * so we can restore it after the system wakes up
+	 */
+	sc->wow_intr_before_sleep = ah->imask;
+	ah->imask &= ~ATH9K_INT_GLOBAL;
+	ath9k_hw_disable_interrupts(ah);
+	ah->imask = ATH9K_INT_BMISS | ATH9K_INT_GLOBAL;
+	ath9k_hw_set_interrupts(ah);
+	ath9k_hw_enable_interrupts(ah);
+
+	ath9k_hw_wow_enable(ah, wow_triggers_enabled);
+
+	ath9k_ps_restore(sc);
+	ath_dbg(common, ANY, "WoW enabled in ath9k\n");
+	sc->wow_sleep_proc_intr = true;
+
+fail_wow:
+	mutex_unlock(&sc->mutex);
+	return ret;
+}
+
+static int ath9k_resume(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 wow_status;
+
+	mutex_lock(&sc->mutex);
+
+	ath9k_ps_wakeup(sc);
+	ath9k_hw_disable_interrupts(ah);
+	ah->imask = sc->wow_intr_before_sleep;
+	ath9k_hw_set_interrupts(ah);
+	ath9k_hw_enable_interrupts(ah);
+
+	wow_status = ath9k_hw_wow_wakeup(ah);
+
+	if (sc->wow_got_bmiss_intr) {
+		/*
+		 * some devices may not pick beacon miss
+		 * as the reason they woke up so we add
+		 * that here for that shortcoming.
+		 */
+		wow_status |= AH_WOW_BEACON_MISS;
+		sc->wow_got_bmiss_intr = false;
+		ath_dbg(common, ANY, "Beacon miss interrupt picked up during WoW sleep");
+	}
+
+	if (wow_status) {
+		ath_dbg(common, ANY, "Waking up due to WoW triggers %s with WoW status = %x\n",
+			ath9k_hw_wow_event_to_string(wow_status), wow_status);
+	}
+
+	ath9k_ps_restore(sc);
+	mutex_unlock(&sc->mutex);
+
+	return 0;
+}
+
+static void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
+{
+	struct ath_softc *sc = hw->priv;
+
+	mutex_lock(&sc->mutex);
+	device_set_wakeup_enable(sc->dev, enabled);
+	mutex_unlock(&sc->mutex);
+}
+
+#endif
+
 struct ieee80211_ops ath9k_ops = {
-	.tx 		    = ath9k_tx,
-	.start 		    = ath9k_start,
-	.stop 		    = ath9k_stop,
-	.add_interface 	    = ath9k_add_interface,
+	.tx		    = ath9k_tx,
+	.start		    = ath9k_start,
+	.stop		    = ath9k_stop,
+	.add_interface	    = ath9k_add_interface,
 	.change_interface   = ath9k_change_interface,
 	.remove_interface   = ath9k_remove_interface,
-	.config 	    = ath9k_config,
+	.config		    = ath9k_config,
 	.configure_filter   = ath9k_configure_filter,
 	.sta_add	    = ath9k_sta_add,
 	.sta_remove	    = ath9k_sta_remove,
 	.sta_notify         = ath9k_sta_notify,
-	.conf_tx 	    = ath9k_conf_tx,
+	.conf_tx	    = ath9k_conf_tx,
 	.bss_info_changed   = ath9k_bss_info_changed,
 	.set_key            = ath9k_set_key,
-	.get_tsf 	    = ath9k_get_tsf,
-	.set_tsf 	    = ath9k_set_tsf,
-	.reset_tsf 	    = ath9k_reset_tsf,
+	.get_tsf	    = ath9k_get_tsf,
+	.set_tsf	    = ath9k_set_tsf,
+	.reset_tsf	    = ath9k_reset_tsf,
 	.ampdu_action       = ath9k_ampdu_action,
 	.get_survey	    = ath9k_get_survey,
 	.rfkill_poll        = ath9k_rfkill_poll_state,
@@ -2120,6 +2471,12 @@ struct ieee80211_ops ath9k_ops = {
 	.set_antenna	    = ath9k_set_antenna,
 	.get_antenna	    = ath9k_get_antenna,
 
+#ifdef CONFIG_PM_SLEEP
+	.suspend	    = ath9k_suspend,
+	.resume		    = ath9k_resume,
+	.set_wakeup	    = ath9k_set_wakeup,
+#endif
+
 #ifdef CONFIG_ATH9K_DEBUGFS
 	.get_et_sset_count  = ath9k_get_et_sset_count,
 	.get_et_stats  = ath9k_get_et_stats,
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index aa0e83a..2b7fe51 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -221,6 +221,9 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
+	device_init_wakeup(&pdev->dev, 1);
+	device_set_wakeup_enable(&pdev->dev, 0);
+
 	ret = pci_request_region(pdev, 0, "ath9k");
 	if (ret) {
 		dev_err(&pdev->dev, "PCI memory region reserve error\n");
-- 
1.7.0.4

