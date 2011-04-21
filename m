Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4650 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab1DULCW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 07:02:22 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 1/3] staging: brcm80211: replaced WL_NONE with
 no_printk
Date: Thu, 21 Apr 2011 13:02:03 +0200
Message-ID: <1303383725-1440-2-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
References: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Using Linux functions instead of Broadcom functions.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h       |    2 -
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c  |   48 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c    |    8 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c  |    8 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_main.c     |    6 +-
 6 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 0188417..c80d83d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -112,7 +112,7 @@ bool bcmsdh_chipmatch(u16 vendor, u16 device)
 #ifdef BCMSDIOH_SPI
 	/* This is the PciSpiHost. */
 	if (device == SPIH_FPGA_ID && vendor == PCI_VENDOR_ID_BROADCOM) {
-		WL_NONE("Found PCI SPI Host Controller\n");
+		no_printk("Found PCI SPI Host Controller\n");
 		return true;
 	}
 #endif				/* BCMSDIOH_SPI */
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
index 54af257..8705b40 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
@@ -20,8 +20,6 @@
 /* wl_msg_level is a bit vector with defs in wlioctl.h */
 extern u32 wl_msg_level;
 
-#define WL_NONE(fmt, args...) no_printk(fmt, ##args)
-
 #define WL_PRINT(level, fmt, args...)		\
 do {						\
 	if (wl_msg_level & level)		\
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 61da97f..62d4a86 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -171,7 +171,7 @@ static int wl_ops_start(struct ieee80211_hw *hw)
 	bool blocked;
 	/*
 	  struct ieee80211_channel *curchan = hw->conf.channel;
-	  WL_NONE("%s : Initial channel: %d\n", __func__, curchan->hw_value);
+	  no_printk("%s : Initial channel: %d\n", __func__, curchan->hw_value);
 	*/
 
 	ieee80211_wake_queues(hw);
@@ -365,7 +365,7 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_HT) {
 		/* 802.11n parameters changed */
 		u16 mode = info->ht_operation_mode;
-		WL_NONE("%s: HT mode: 0x%04X\n", __func__, mode);
+		no_printk("%s: HT mode: 0x%04X\n", __func__, mode);
 		wlc_protection_upd(wl->wlc, WLC_PROT_N_CFG,
 			mode & IEEE80211_HT_OP_MODE_PROTECTION);
 		wlc_protection_upd(wl->wlc, WLC_PROT_N_NONGF,
@@ -380,13 +380,13 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		/* Beacon interval changed */
-		WL_NONE("%s: Beacon Interval: %d\n",
+		no_printk("%s: Beacon Interval: %d\n",
 			__func__, info->beacon_int);
 		wlc_set(wl->wlc, WLC_SET_BCNPRD, info->beacon_int);
 	}
 	if (changed & BSS_CHANGED_BSSID) {
 		/* BSSID changed, for whatever reason (IBSS and managed mode) */
-		WL_NONE("%s: new BSSID: aid %d  bss:%pM\n", __func__,
+		no_printk("%s: new BSSID: aid %d  bss:%pM\n", __func__,
 			info->aid, info->bssid);
 		WL_LOCK(wl);
 		wlc_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET,
@@ -456,7 +456,7 @@ wl_ops_configure_filter(struct ieee80211_hw *hw,
 	if (changed_flags & FIF_OTHER_BSS)
 		WL_ERROR("FIF_OTHER_BSS\n");
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		WL_NONE("FIF_BCN_PRBRESP_PROMISC\n");
+		no_printk("FIF_BCN_PRBRESP_PROMISC\n");
 		WL_LOCK(wl);
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
 			wl->pub->mac80211_state |= MAC80211_PROMISC_BCNS;
@@ -473,14 +473,14 @@ wl_ops_configure_filter(struct ieee80211_hw *hw,
 static int
 wl_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
 {
-	WL_NONE("%s: Enter\n", __func__);
+	no_printk("%s: Enter\n", __func__);
 	return 0;
 }
 
 static void wl_ops_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct wl_info *wl = hw->priv;
-	WL_NONE("Scan Start\n");
+	no_printk("Scan Start\n");
 	WL_LOCK(wl);
 	wlc_scan_start(wl->wlc);
 	WL_UNLOCK(wl);
@@ -490,7 +490,7 @@ static void wl_ops_sw_scan_start(struct ieee80211_hw *hw)
 static void wl_ops_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct wl_info *wl = hw->priv;
-	WL_NONE("Scan Complete\n");
+	no_printk("Scan Complete\n");
 	WL_LOCK(wl);
 	wlc_scan_stop(wl->wlc);
 	WL_UNLOCK(wl);
@@ -534,7 +534,7 @@ static void
 wl_ops_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		  enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
 {
-	WL_NONE("%s: Enter\n", __func__);
+	no_printk("%s: Enter\n", __func__);
 	switch (cmd) {
 	default:
 		WL_ERROR("%s: Unknown cmd = %d\n", __func__, cmd);
@@ -549,8 +549,8 @@ wl_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 {
 	struct wl_info *wl = hw->priv;
 
-	WL_NONE("%s: Enter (WME config)\n", __func__);
-	WL_NONE("queue %d, txop %d, cwmin %d, cwmax %d, aifs %d\n", queue,
+	no_printk("%s: Enter (WME config)\n", __func__);
+	no_printk("queue %d, txop %d, cwmin %d, cwmax %d, aifs %d\n", queue,
 		 params->txop, params->cw_min, params->cw_max, params->aifs);
 
 	WL_LOCK(wl);
@@ -605,7 +605,7 @@ static int
 wl_ops_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		  struct ieee80211_sta *sta)
 {
-	WL_NONE("%s: Enter\n", __func__);
+	no_printk("%s: Enter\n", __func__);
 	return 0;
 }
 
@@ -625,10 +625,10 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 	ASSERT(scb->magic == SCB_MAGIC);
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		WL_NONE("%s: action = IEEE80211_AMPDU_RX_START\n", __func__);
+		no_printk("%s: action = IEEE80211_AMPDU_RX_START\n", __func__);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
-		WL_NONE("%s: action = IEEE80211_AMPDU_RX_STOP\n", __func__);
+		no_printk("%s: action = IEEE80211_AMPDU_RX_STOP\n", __func__);
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		WL_LOCK(wl);
@@ -652,7 +652,7 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		/* Not sure what to do here */
 		/* Power save wakeup */
-		WL_NONE("%s: action = IEEE80211_AMPDU_TX_OPERATIONAL\n",
+		no_printk("%s: action = IEEE80211_AMPDU_TX_OPERATIONAL\n",
 			__func__);
 		break;
 	default:
@@ -671,7 +671,7 @@ static void wl_ops_rfkill_poll(struct ieee80211_hw *hw)
 	blocked = wlc_check_radio_disabled(wl->wlc);
 	WL_UNLOCK(wl);
 
-	WL_NONE("wl: rfkill_poll: %d\n", blocked);
+	no_printk("wl: rfkill_poll: %d\n", blocked);
 	wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, blocked);
 }
 
@@ -704,7 +704,7 @@ static const struct ieee80211_ops wl_ops = {
  */
 static int wl_set_hint(struct wl_info *wl, char *abbrev)
 {
-	WL_NONE("%s: Sending country code %c%c to MAC80211\n",
+	no_printk("%s: Sending country code %c%c to MAC80211\n",
 		 __func__, abbrev[0], abbrev[1]);
 	return regulatory_hint(wl->pub->ieee_hw->wiphy, abbrev);
 }
@@ -1031,7 +1031,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	if (wlc_get(wl->wlc, WLC_GET_PHYLIST, (int *)&phy_list) < 0) {
 		WL_ERROR("Phy list failed\n");
 	}
-	WL_NONE("%s: phylist = %c\n", __func__, phy_list[0]);
+	no_printk("%s: phylist = %c\n", __func__, phy_list[0]);
 
 	if (phy_list[0] == 'n' || phy_list[0] == 'c') {
 		if (phy_list[0] == 'c') {
@@ -1056,7 +1056,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 		}
 	}
 
-	WL_NONE("%s: 2ghz = %d, 5ghz = %d\n", __func__, 1, has_5g);
+	no_printk("%s: 2ghz = %d, 5ghz = %d\n", __func__, 1, has_5g);
 
 	return 0;
 }
@@ -1250,7 +1250,7 @@ static void wl_remove(struct pci_dev *pdev)
 		WL_LOCK(wl);
 		wl_down(wl);
 		WL_UNLOCK(wl);
-		WL_NONE("%s: Down\n", __func__);
+		no_printk("%s: Down\n", __func__);
 	}
 	pci_disable_device(pdev);
 
@@ -1838,14 +1838,14 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 			break;
 		sprintf(fw_name, "%s-%d.fw", wl_firmwares[i],
 			UCODE_LOADER_API_VER);
-		WL_NONE("request fw %s\n", fw_name);
+		no_printk("request fw %s\n", fw_name);
 		status = request_firmware(&wl->fw.fw_bin[i], fw_name, device);
 		if (status) {
 			WL_ERROR("%s: fail to load firmware %s\n",
 				 KBUILD_MODNAME, fw_name);
 			return status;
 		}
-		WL_NONE("request fw %s\n", fw_name);
+		no_printk("request fw %s\n", fw_name);
 		sprintf(fw_name, "%s_hdr-%d.fw", wl_firmwares[i],
 			UCODE_LOADER_API_VER);
 		status = request_firmware(&wl->fw.fw_hdr[i], fw_name, device);
@@ -1856,7 +1856,7 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 		}
 		wl->fw.hdr_num_entries[i] =
 		    wl->fw.fw_hdr[i]->size / (sizeof(struct wl_fw_hdr));
-		WL_NONE("request fw %s find: %d entries\n",
+		no_printk("request fw %s find: %d entries\n",
 			fw_name, wl->fw.hdr_num_entries[i]);
 	}
 	wl->fw.fw_cnt = i;
@@ -1944,7 +1944,7 @@ bool wl_rfkill_set_hw_state(struct wl_info *wl)
 {
 	bool blocked = wlc_check_radio_disabled(wl->wlc);
 
-	WL_NONE("%s: update hw state: blocked=%s\n", __func__,
+	no_printk("%s: update hw state: blocked=%s\n", __func__,
 		blocked ? "true" : "false");
 	WL_UNLOCK(wl);
 	wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, blocked);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 9803449..ea168f5 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -251,7 +251,7 @@ void scb_ampdu_cleanup(struct ampdu_info *ampdu, struct scb *scb)
  */
 void wlc_ampdu_reset(struct ampdu_info *ampdu)
 {
-	WL_NONE("%s: Entering\n", __func__);
+	no_printk("%s: Entering\n", __func__);
 }
 
 static void scb_ampdu_update_config(struct ampdu_info *ampdu, struct scb *scb)
@@ -680,7 +680,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 			    min(scb_ampdu->max_rxlen,
 				ampdu->max_txlen[mcs][is40][sgi]);
 
-			WL_NONE("sendampdu: sgi %d, is40 %d, mcs %d\n",
+			no_printk("sendampdu: sgi %d, is40 %d, mcs %d\n",
 				sgi, is40, mcs);
 
 			/* XXX Fix me to honor real max_rxlen */
@@ -733,7 +733,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		}
 
 		if (count == scb_ampdu->max_pdu) {
-			WL_NONE("Stop taking from q, reached %d deep\n",
+			no_printk("Stop taking from q, reached %d deep\n",
 				scb_ampdu->max_pdu);
 			break;
 		}
@@ -1052,7 +1052,7 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 					 CHSPEC_CHANNEL(wlc->default_bss->chanspec));
 			} else {
 				if (supr_status == TX_STATUS_SUPR_FRAG)
-					WL_NONE("%s: AMPDU frag err\n",
+					no_printk("%s: AMPDU frag err\n",
 						__func__);
 				else
 					WL_ERROR("%s: wlc_ampdu_dotxstatus: supr_status 0x%x\n",
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index 96161c0..7f4c80a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -656,7 +656,7 @@ wlc_cm_info_t *wlc_channel_mgr_attach(struct wlc_info *wlc)
 	ccode = getvar(wlc->pub->vars, "ccode");
 	if (ccode) {
 		strncpy(wlc->pub->srom_ccode, ccode, WLC_CNTRY_BUF_SZ - 1);
-		WL_NONE("%s: SROM country code is %c%c\n",
+		no_printk("%s: SROM country code is %c%c\n",
 			__func__,
 			wlc->pub->srom_ccode[0], wlc->pub->srom_ccode[1]);
 	}
@@ -708,9 +708,9 @@ wlc_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
 	char mapped_ccode[WLC_CNTRY_BUF_SZ];
 	uint mapped_regrev;
 
-	WL_NONE("%s: (country_abbrev \"%s\", ccode \"%s\", regrev %d) SPROM \"%s\"/%u\n",
-		__func__, country_abbrev, ccode, regrev,
-		wlc_cm->srom_ccode, wlc_cm->srom_regrev);
+	no_printk("%s: (country_abbrev \"%s\", ccode \"%s\", regrev %d) SPROM"
+		  " \"%s\"/%u\n", __func__, country_abbrev, ccode, regrev,
+		  wlc_cm->srom_ccode, wlc_cm->srom_regrev);
 
 	/* if regrev is -1, lookup the mapped country code,
 	 * otherwise use the ccode and regrev directly
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 113de97..2cf154b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -1684,7 +1684,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	struct wlc_txq_info *qi;
 	uint n_disabled;
 
-	WL_NONE("wl%d: %s: vendor 0x%x device 0x%x\n",
+	no_printk("wl%d: %s: vendor 0x%x device 0x%x\n",
 		unit, __func__, vendor, device);
 
 	/* allocate struct wlc_info state and its substructures */
@@ -3019,7 +3019,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	bool_val = val != 0;
 
 	if (cmd != WLC_SET_CHANNEL)
-		WL_NONE("WLC_IOCTL: cmd %d val 0x%x (%d) len %d\n",
+		no_printk("WLC_IOCTL: cmd %d val 0x%x (%d) len %d\n",
 			cmd, (uint)val, val, len);
 
 	bcmerror = 0;
@@ -6552,7 +6552,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 
 	supr_status = txs->status & TX_STATUS_SUPR_MASK;
 	if (supr_status == TX_STATUS_SUPR_BADCH)
-		WL_NONE("%s: Pkt tx suppressed, possibly channel %d\n",
+		no_printk("%s: Pkt tx suppressed, possibly channel %d\n",
 			__func__, CHSPEC_CHANNEL(wlc->default_bss->chanspec));
 
 	tx_rts = cpu_to_le16(txh->MacTxControlLow) & TXC_SENDRTS;
-- 
1.7.1


