Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60181 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251Ab2DJPPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 11:15:33 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [WIP 08/11] ath9k: Add WoW related mac80211 callbacks
Date: Tue, 10 Apr 2012 20:43:18 +0530
Message-ID: <1334070801-21708-9-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120410_171536_794148_C7DDC864)
In-Reply-To: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
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
 drivers/net/wireless/ath/ath9k/main.c  |  384 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/pci.c   |    3 +
 4 files changed, 388 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2b3c94b..f32f43a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -500,6 +500,14 @@ struct ath9k_wow_info {
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
@@ -693,6 +701,7 @@ struct ath_softc {
 
 	struct ath_ant_comb ant_comb;
 	u8 ant_tx, ant_rx;
+	bool wow_enabled;
 
 #ifdef CONFIG_PM_SLEEP
 	bool wow_got_bmiss_intr;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 0e82981..4872d0f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -854,6 +854,7 @@ void ath9k_deinit_device(struct ath_softc *sc)
 	ath9k_ps_restore(sc);
 
 	ieee80211_unregister_hw(hw);
+	ath_wow_cleanup(sc);
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
 	ath9k_deinit_softc(sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 215eb25..7b8b8a9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -803,6 +803,17 @@ irqreturn_t ath_isr(int irq, void *dev)
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
@@ -2366,24 +2377,374 @@ static int ath9k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+
+void ath_wow_cleanup(struct ath_softc *sc)
+{
+	struct ath9k_wow_info *wow_info = &sc->wow_info;
+	struct ath9k_wow_pattern *wow_pattern  = NULL, *tmp;
+
+	if (!sc->wow_enabled)
+		return;
+
+	list_for_each_entry_safe(wow_pattern, tmp,
+				&wow_info->wow_patterns, list) {
+
+		list_del(&wow_pattern->list);
+		kfree(wow_pattern);
+
+	}
+
+}
+
+u32 ath9k_wow_map_triggers(struct ath_softc *sc, struct cfg80211_wowlan *wowlan)
+{
+	u32 wow_triggers = 0;
+
+	if (wowlan->disconnect)
+		wow_triggers |= AH_WOW_LINK_CHANGE |
+				AH_WOW_BEACON_MISS;
+	if (wowlan->magic_pkt)
+		wow_triggers |= AH_WOW_MAGIC_PATTERN_EN;
+
+	if (wowlan->n_patterns)
+		wow_triggers |= AH_WOW_USER_PATTERN_EN;
+
+	if (wow_triggers)
+		sc->wow_enabled = true;
+
+	return wow_triggers;
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
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_wow_info *wow_info = &sc->wow_info;
+	struct ath9k_wow_pattern *wow_pattern  = NULL;
+	struct cfg80211_wowlan_trig_pkt_pattern *patterns = wowlan->patterns;
+	s8 i = 0;
+
+	/*
+	 * check for duplicate patterns
+	 */
+	list_for_each_entry(wow_pattern, &wow_info->wow_patterns, list) {
+		if (wow_pattern->slot) {
+			if (!memcmp(wow_pattern->pattern_bytes,
+				    patterns->pattern, MAX_PATTERN_SIZE) &&
+			    !memcmp(wow_pattern->mask_bytes,
+				    patterns->mask, MAX_PATTERN_SIZE))
+				return;
+		}
+
+		i++;
+
+		if (i >= MAX_NUM_USER_PATTERN)
+			break;
+	}
+
+	i = 0;
+
+	list_for_each_entry(wow_pattern, &wow_info->wow_patterns, list) {
+
+
+		if (!wow_pattern->slot) {
+			wow_pattern = kzalloc(sizeof(*wow_pattern), GFP_KERNEL);
+
+			if (!wow_pattern)
+				return;
+			memcpy(wow_pattern->pattern_bytes,
+			       patterns->pattern, MAX_PATTERN_SIZE);
+			memcpy(wow_pattern->mask_bytes,
+			       patterns->mask, MAX_PATTERN_SIZE);
+			wow_pattern->slot = true;
+			wow_pattern->pattern_len = patterns->pattern_len;
+			list_add_tail(&wow_pattern->list,
+				      &wow_info->wow_patterns);
+
+			wow_info->num_of_patterns = i + 2;
+			/*
+			 * just need to take care of deauth and
+			 * disssoc pattern, make sure we don't overwirte
+			 */
+
+			ath9k_hw_wow_apply_pattern(ah,
+						   wow_pattern->pattern_bytes,
+						   wow_pattern->mask_bytes,
+						   wow_info->num_of_patterns,
+						   wow_pattern->pattern_len);
+			break;
+		}
+
+		i++;
+
+		if (i >= MAX_NUM_USER_PATTERN)
+			break;
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
+	sc->wow_enabled = false;
+
+	if (WARN_ON(!wowlan))
+		return -EINVAL;
+
+	ath9k_ps_wakeup(sc);
+
+	if (!device_can_wakeup(sc->dev)) {
+		ret = 1;
+		goto fail_wow;
+	}
+
+	/*
+	 * none of the sta vifs are associated
+	 * and we are not currently handling multivif
+	 * cases, for instance we have to seperately
+	 * configure 'keep alive frame' for each
+	 * STA
+	 */
+	if (!(sc->sc_flags & SC_OP_PRIM_STA_VIF) || (sc->nvifs > 1)) {
+		ret = 1;
+		goto fail_wow;
+	}
+
+	wow_triggers_enabled = ath9k_wow_map_triggers(sc, wowlan);
+
+	if (wow_triggers_enabled & AH_WOW_USER_PATTERN_EN) {
+		ath9k_wow_add_disassoc_deauth_pattern(sc);
+		ath9k_wow_add_pattern(sc, wowlan);
+	}
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
+	ath_dbg(common, ANY, "WoW enabled in ath9k\n");
+	sc->wow_sleep_proc_intr = true;
+
+fail_wow:
+	ath9k_ps_restore(sc);
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
+	if (!sc->wow_enabled)
+		goto wow_unlock;
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
+		 * that here for that shortcoming
+		 */
+		wow_status |= AH_WOW_BEACON_MISS;
+		sc->wow_got_bmiss_intr = false;
+		ath_dbg(common, ANY, "Beacon miss interrupt picked up during"
+			"sleep adding as possible wake up reason\n");
+	}
+
+	if (wow_status) {
+		ath_dbg(common, ANY, "Waking up due to WoW triggers %s"
+			"with WoW status = %x\n",
+			ath9k_hw_wow_event_to_string(wow_status), wow_status);
+	}
+
+	ath9k_ps_restore(sc);
+
+wow_unlock:
+
+	mutex_unlock(&sc->mutex);
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
+
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
@@ -2394,4 +2755,9 @@ struct ieee80211_ops ath9k_ops = {
 	.get_stats	    = ath9k_get_stats,
 	.set_antenna	    = ath9k_set_antenna,
 	.get_antenna	    = ath9k_get_antenna,
+#ifdef CONFIG_PM_SLEEP
+	.suspend	    = ath9k_suspend,
+	.resume		    = ath9k_resume,
+	.set_wakeup	    = ath9k_set_wakeup,
+#endif
 };
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 77dc327..9b25299 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -215,6 +215,9 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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

