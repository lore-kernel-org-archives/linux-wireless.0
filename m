Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1186 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1IAJRh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:37 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/30] staging: brcm80211: removed static function
 declarations in mac80211_if.c
Date: Thu, 1 Sep 2011 11:16:57 +0200
Message-ID: <1314868640-9425-8-git-send-email-rvossen@broadcom.com> (sfid-20110901_111839_844712_E8A49CFD)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c | 1116 ++++++++++------------
 1 files changed, 526 insertions(+), 590 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 01829db..bd989737 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -37,6 +37,9 @@
 #define LOCK(wl)	spin_lock_bh(&(wl)->lock)
 #define UNLOCK(wl)	spin_unlock_bh(&(wl)->lock)
 
+#define HW_TO_WL(hw)	 (hw->priv)
+#define WL_TO_HW(wl)	  (wl->pub->ieee_hw)
+
 /* locking from inside brcms_isr */
 #define ISR_LOCK(wl, flags)\
 	do {\
@@ -54,13 +57,6 @@
 #define INT_LOCK(wl, flags)	spin_lock_irqsave(&(wl)->isr_lock, flags)
 #define INT_UNLOCK(wl, flags)	spin_unlock_irqrestore(&(wl)->isr_lock, flags)
 
-static void brcms_timer(unsigned long data);
-static void _brcms_timer(struct brcms_timer *t);
-
-
-static int ieee_hw_init(struct ieee80211_hw *hw);
-static int ieee_hw_rate_init(struct ieee80211_hw *hw);
-
 /* Flags we support */
 #define MAC_FILTERS (FIF_PROMISC_IN_BSS | \
 	FIF_ALLMULTI | \
@@ -70,21 +66,42 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw);
 	FIF_OTHER_BSS | \
 	FIF_BCN_PRBRESP_PROMISC)
 
-static int n_adapters_found;
+#define CHAN2GHZ(channel, freqency, chflags)  { \
+	.band = IEEE80211_BAND_2GHZ, \
+	.center_freq = (freqency), \
+	.hw_value = (channel), \
+	.flags = chflags, \
+	.max_antenna_gain = 0, \
+	.max_power = 19, \
+}
+
+#define CHAN5GHZ(channel, chflags)  { \
+	.band = IEEE80211_BAND_5GHZ, \
+	.center_freq = 5000 + 5*(channel), \
+	.hw_value = (channel), \
+	.flags = chflags, \
+	.max_antenna_gain = 0, \
+	.max_power = 21, \
+}
 
-static int brcms_request_fw(struct brcms_info *wl, struct pci_dev *pdev);
-static void brcms_release_fw(struct brcms_info *wl);
+#define RATE(rate100m, _flags) { \
+	.bitrate = (rate100m), \
+	.flags = (_flags), \
+	.hw_value = (rate100m / 5), \
+}
+
+struct firmware_hdr {
+	u32 offset;
+	u32 len;
+	u32 idx;
+};
 
-/* local prototypes */
-static void brcms_dpc(unsigned long data);
-static irqreturn_t brcms_isr(int irq, void *dev_id);
+char *brcms_firmwares[MAX_FW_IMAGES] = {
+	"brcm/bcm43xx",
+	NULL
+};
 
-static int __devinit brcms_pci_probe(struct pci_dev *pdev,
-				  const struct pci_device_id *ent);
-static void brcms_remove(struct pci_dev *pdev);
-static void brcms_free(struct brcms_info *wl);
-static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate,
-				 bool is_br);
+static int n_adapters_found;
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver.");
@@ -107,50 +124,170 @@ static int msglevel = 0xdeadbeef;
 module_param(msglevel, int, 0);
 #endif				/* BCMDBG */
 
-#define HW_TO_WL(hw)	 (hw->priv)
-#define WL_TO_HW(wl)	  (wl->pub->ieee_hw)
+static struct ieee80211_channel brcms_2ghz_chantable[] = {
+	CHAN2GHZ(1, 2412, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN2GHZ(2, 2417, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN2GHZ(3, 2422, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN2GHZ(4, 2427, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN2GHZ(5, 2432, 0),
+	CHAN2GHZ(6, 2437, 0),
+	CHAN2GHZ(7, 2442, 0),
+	CHAN2GHZ(8, 2447, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(9, 2452, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(10, 2457, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(11, 2462, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(12, 2467,
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(13, 2472,
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN2GHZ(14, 2484,
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
+};
+
+static struct ieee80211_channel brcms_5ghz_nphy_chantable[] = {
+	/* UNII-1 */
+	CHAN5GHZ(36, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(40, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(44, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(48, IEEE80211_CHAN_NO_HT40PLUS),
+	/* UNII-2 */
+	CHAN5GHZ(52,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(56,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(60,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(64,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+	/* MID */
+	CHAN5GHZ(100,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(104,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(108,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(112,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(116,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(120,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(124,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(128,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(132,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(136,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(140,
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS |
+		 IEEE80211_CHAN_NO_HT40MINUS),
+	/* UNII-3 */
+	CHAN5GHZ(149, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(153, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(157, IEEE80211_CHAN_NO_HT40MINUS),
+	CHAN5GHZ(161, IEEE80211_CHAN_NO_HT40PLUS),
+	CHAN5GHZ(165, IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
+};
+
+/*
+ * The rate table is used for both 2.4G and 5G rates. The
+ * latter being a subset as it does not support CCK rates.
+ */
+static struct ieee80211_rate legacy_ratetable[] = {
+	RATE(10, 0),
+	RATE(20, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(55, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(110, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(60, 0),
+	RATE(90, 0),
+	RATE(120, 0),
+	RATE(180, 0),
+	RATE(240, 0),
+	RATE(360, 0),
+	RATE(480, 0),
+	RATE(540, 0),
+};
+
+static struct ieee80211_supported_band brcms_band_2GHz_nphy = {
+	.band = IEEE80211_BAND_2GHZ,
+	.channels = brcms_2ghz_chantable,
+	.n_channels = ARRAY_SIZE(brcms_2ghz_chantable),
+	.bitrates = legacy_ratetable,
+	.n_bitrates = ARRAY_SIZE(legacy_ratetable),
+	.ht_cap = {
+		   /* from include/linux/ieee80211.h */
+		   .cap = IEEE80211_HT_CAP_GRN_FLD |
+		   IEEE80211_HT_CAP_SGI_20 |
+		   IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_40MHZ_INTOLERANT,
+		   .ht_supported = true,
+		   .ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K,
+		   .ampdu_density = AMPDU_DEF_MPDU_DENSITY,
+		   .mcs = {
+			   /* placeholders for now */
+			   .rx_mask = {0xff, 0xff, 0, 0, 0, 0, 0, 0, 0, 0},
+			   .rx_highest = 500,
+			   .tx_params = IEEE80211_HT_MCS_TX_DEFINED}
+		   }
+};
+
+static struct ieee80211_supported_band brcms_band_5GHz_nphy = {
+	.band = IEEE80211_BAND_5GHZ,
+	.channels = brcms_5ghz_nphy_chantable,
+	.n_channels = ARRAY_SIZE(brcms_5ghz_nphy_chantable),
+	.bitrates = legacy_ratetable + BRCMS_LEGACY_5G_RATE_OFFSET,
+	.n_bitrates = ARRAY_SIZE(legacy_ratetable) -
+			BRCMS_LEGACY_5G_RATE_OFFSET,
+	.ht_cap = {
+		   .cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 |
+			  IEEE80211_HT_CAP_SGI_40 |
+			  IEEE80211_HT_CAP_40MHZ_INTOLERANT, /* No 40 mhz yet */
+		   .ht_supported = true,
+		   .ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K,
+		   .ampdu_density = AMPDU_DEF_MPDU_DENSITY,
+		   .mcs = {
+			   /* placeholders for now */
+			   .rx_mask = {0xff, 0xff, 0, 0, 0, 0, 0, 0, 0, 0},
+			   .rx_highest = 500,
+			   .tx_params = IEEE80211_HT_MCS_TX_DEFINED}
+		   }
+};
+
+/* flags the given rate in rateset as requested */
+static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
+{
+	u32 i;
+
+	for (i = 0; i < rs->count; i++) {
+		if (rate != (rs->rates[i] & 0x7f))
+			continue;
 
-/* MAC80211 callback functions */
-static int brcms_ops_start(struct ieee80211_hw *hw);
-static void brcms_ops_stop(struct ieee80211_hw *hw);
-static int brcms_ops_add_interface(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif);
-static void brcms_ops_remove_interface(struct ieee80211_hw *hw,
-				    struct ieee80211_vif *vif);
-static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed);
-static void brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
-				    struct ieee80211_vif *vif,
-				    struct ieee80211_bss_conf *info,
-				    u32 changed);
-static void brcms_ops_configure_filter(struct ieee80211_hw *hw,
-				    unsigned int changed_flags,
-				    unsigned int *total_flags, u64 multicast);
-static int brcms_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
-			  bool set);
-static void brcms_ops_sw_scan_start(struct ieee80211_hw *hw);
-static void brcms_ops_sw_scan_complete(struct ieee80211_hw *hw);
-static void brcms_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf);
-static int brcms_ops_get_stats(struct ieee80211_hw *hw,
-			    struct ieee80211_low_level_stats *stats);
-static void brcms_ops_sta_notify(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif,
-			      enum sta_notify_cmd cmd,
-			      struct ieee80211_sta *sta);
-static int brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
-			  const struct ieee80211_tx_queue_params *params);
-static u64 brcms_ops_get_tsf(struct ieee80211_hw *hw);
-static int brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		      struct ieee80211_sta *sta);
-static int brcms_ops_sta_remove(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_sta *sta);
-static int brcms_ops_ampdu_action(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       enum ieee80211_ampdu_mlme_action action,
-			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			       u8 buf_size);
-static void brcms_ops_rfkill_poll(struct ieee80211_hw *hw);
-static void brcms_ops_flush(struct ieee80211_hw *hw, bool drop);
+		if (is_br)
+			rs->rates[i] |= BRCMS_RATE_FLAG;
+		else
+			rs->rates[i] &= BRCMS_RATE_MASK;
+		return;
+	}
+}
 
 static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
@@ -735,297 +872,218 @@ static int brcms_set_hint(struct brcms_info *wl, char *abbrev)
 	return regulatory_hint(wl->pub->ieee_hw->wiphy, abbrev);
 }
 
-/**
- * attach to the WL device.
- *
- * Attach to the WL device identified by vendor and device parameters.
- * regs is a host accessible memory address pointing to WL device registers.
- *
- * brcms_attach is not defined as static because in the case where no bus
- * is defined, wl_attach will never be called, and thus, gcc will issue
- * a warning that this function is defined but not used if we declare
- * it as static.
- *
- *
- * is called in brcms_pci_probe() context, therefore no locking required.
- */
-static struct brcms_info *brcms_attach(u16 vendor, u16 device,
-				       resource_size_t regs,
-				       struct pci_dev *btparam, uint irq)
+static void brcms_dpc(unsigned long data)
 {
-	struct brcms_info *wl = NULL;
-	int unit, err;
-	struct ieee80211_hw *hw;
-	u8 perm[ETH_ALEN];
+	struct brcms_info *wl;
 
-	unit = n_adapters_found;
-	err = 0;
+	wl = (struct brcms_info *) data;
 
-	if (unit < 0)
-		return NULL;
+	LOCK(wl);
 
-	/* allocate private info */
-	hw = pci_get_drvdata(btparam);	/* btparam == pdev */
-	if (hw != NULL)
-		wl = hw->priv;
-	if (WARN_ON(hw == NULL) || WARN_ON(wl == NULL))
-		return NULL;
-	wl->wiphy = hw->wiphy;
+	/* call the common second level interrupt handler */
+	if (wl->pub->up) {
+		if (wl->resched) {
+			unsigned long flags;
 
-	atomic_set(&wl->callbacks, 0);
+			INT_LOCK(wl, flags);
+			brcms_c_intrsupd(wl->wlc);
+			INT_UNLOCK(wl, flags);
+		}
 
-	/* setup the bottom half handler */
-	tasklet_init(&wl->tasklet, brcms_dpc, (unsigned long) wl);
+		wl->resched = brcms_c_dpc(wl->wlc, true);
+	}
 
-	wl->regsva = ioremap_nocache(regs, PCI_BAR0_WINSZ);
-	if (wl->regsva == NULL) {
-		wiphy_err(wl->wiphy, "wl%d: ioremap() failed\n", unit);
-		goto fail;
-	}
-	spin_lock_init(&wl->lock);
-	spin_lock_init(&wl->isr_lock);
+	/* brcms_c_dpc() may bring the driver down */
+	if (!wl->pub->up)
+		goto done;
 
-	/* prepare ucode */
-	if (brcms_request_fw(wl, btparam) < 0) {
-		wiphy_err(wl->wiphy, "%s: Failed to find firmware usually in "
-			  "%s\n", KBUILD_MODNAME, "/lib/firmware/brcm");
-		brcms_release_fw(wl);
-		brcms_remove(btparam);
-		return NULL;
-	}
+	/* re-schedule dpc */
+	if (wl->resched)
+		tasklet_schedule(&wl->tasklet);
+	else
+		/* re-enable interrupts */
+		brcms_intrson(wl);
 
-	/* common load-time initialization */
-	wl->wlc = brcms_c_attach(wl, vendor, device, unit, false,
-				 wl->regsva, btparam, &err);
-	brcms_release_fw(wl);
-	if (!wl->wlc) {
-		wiphy_err(wl->wiphy, "%s: attach() failed with code %d\n",
-			  KBUILD_MODNAME, err);
-		goto fail;
-	}
-	wl->pub = brcms_c_pub(wl->wlc);
+ done:
+	UNLOCK(wl);
+}
 
-	wl->pub->ieee_hw = hw;
+/*
+ * Precondition: Since this function is called in brcms_pci_probe() context,
+ * no locking is required.
+ */
+static int brcms_request_fw(struct brcms_info *wl, struct pci_dev *pdev)
+{
+	int status;
+	struct device *device = &pdev->dev;
+	char fw_name[100];
+	int i;
 
-	if (brcms_c_set_par(wl->wlc, IOV_MPC, 0) < 0)
-		wiphy_err(wl->wiphy, "wl%d: Error setting MPC variable to 0\n",
-			  unit);
+	memset(&wl->fw, 0, sizeof(struct brcms_firmware));
+	for (i = 0; i < MAX_FW_IMAGES; i++) {
+		if (brcms_firmwares[i] == NULL)
+			break;
+		sprintf(fw_name, "%s-%d.fw", brcms_firmwares[i],
+			UCODE_LOADER_API_VER);
+		status = request_firmware(&wl->fw.fw_bin[i], fw_name, device);
+		if (status) {
+			wiphy_err(wl->wiphy, "%s: fail to load firmware %s\n",
+				  KBUILD_MODNAME, fw_name);
+			return status;
+		}
+		sprintf(fw_name, "%s_hdr-%d.fw", brcms_firmwares[i],
+			UCODE_LOADER_API_VER);
+		status = request_firmware(&wl->fw.fw_hdr[i], fw_name, device);
+		if (status) {
+			wiphy_err(wl->wiphy, "%s: fail to load firmware %s\n",
+				  KBUILD_MODNAME, fw_name);
+			return status;
+		}
+		wl->fw.hdr_num_entries[i] =
+		    wl->fw.fw_hdr[i]->size / (sizeof(struct firmware_hdr));
+	}
+	wl->fw.fw_cnt = i;
+	return brcms_ucode_data_init(wl);
+}
 
-	/* register our interrupt handler */
-	if (request_irq(irq, brcms_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
-		wiphy_err(wl->wiphy, "wl%d: request_irq() failed\n", unit);
-		goto fail;
+/*
+ * Precondition: Since this function is called in brcms_pci_probe() context,
+ * no locking is required.
+ */
+static void brcms_release_fw(struct brcms_info *wl)
+{
+	int i;
+	for (i = 0; i < MAX_FW_IMAGES; i++) {
+		release_firmware(wl->fw.fw_bin[i]);
+		release_firmware(wl->fw.fw_hdr[i]);
 	}
-	wl->irq = irq;
+}
 
-	/* register module */
-	brcms_c_module_register(wl->pub, "linux", wl, NULL);
+/**
+ * This function frees the WL per-device resources.
+ *
+ * This function frees resources owned by the WL device pointed to
+ * by the wl parameter.
+ *
+ * precondition: can both be called locked and unlocked
+ *
+ */
+static void brcms_free(struct brcms_info *wl)
+{
+	struct brcms_timer *t, *next;
 
-	if (ieee_hw_init(hw)) {
-		wiphy_err(wl->wiphy, "wl%d: %s: ieee_hw_init failed!\n", unit,
-			  __func__);
-		goto fail;
-	}
+	/* free ucode data */
+	if (wl->fw.fw_cnt)
+		brcms_ucode_data_free();
+	if (wl->irq)
+		free_irq(wl->irq, wl);
 
-	memcpy(perm, &wl->pub->cur_etheraddr, ETH_ALEN);
-	if (WARN_ON(!is_valid_ether_addr(perm)))
-		goto fail;
-	SET_IEEE80211_PERM_ADDR(hw, perm);
+	/* kill dpc */
+	tasklet_kill(&wl->tasklet);
 
-	err = ieee80211_register_hw(hw);
-	if (err)
-		wiphy_err(wl->wiphy, "%s: ieee80211_register_hw failed, status"
-			  "%d\n", __func__, err);
+	if (wl->pub)
+		brcms_c_module_unregister(wl->pub, "linux", wl);
 
-	if (wl->pub->srom_ccode[0])
-		err = brcms_set_hint(wl, wl->pub->srom_ccode);
-	else
-		err = brcms_set_hint(wl, "US");
-	if (err)
-		wiphy_err(wl->wiphy, "%s: regulatory_hint failed, status %d\n",
-			  __func__, err);
+	/* free common resources */
+	if (wl->wlc) {
+		brcms_c_detach(wl->wlc);
+		wl->wlc = NULL;
+		wl->pub = NULL;
+	}
 
-	n_adapters_found++;
-	return wl;
+	/* virtual interface deletion is deferred so we cannot spinwait */
 
-fail:
-	brcms_free(wl);
-	return NULL;
-}
+	/* wait for all pending callbacks to complete */
+	while (atomic_read(&wl->callbacks) > 0)
+		schedule();
 
+	/* free timers */
+	for (t = wl->timers; t; t = next) {
+		next = t->next;
+#ifdef BCMDBG
+		kfree(t->name);
+#endif
+		kfree(t);
+	}
 
+	/*
+	 * unregister_netdev() calls get_stats() which may read chip
+	 * registers so we cannot unmap the chip registers until
+	 * after calling unregister_netdev() .
+	 */
+	if (wl->regsva)
+		iounmap((void *)wl->regsva);
 
-#define CHAN2GHZ(channel, freqency, chflags)  { \
-	.band = IEEE80211_BAND_2GHZ, \
-	.center_freq = (freqency), \
-	.hw_value = (channel), \
-	.flags = chflags, \
-	.max_antenna_gain = 0, \
-	.max_power = 19, \
+	wl->regsva = NULL;
 }
 
-static struct ieee80211_channel brcms_2ghz_chantable[] = {
-	CHAN2GHZ(1, 2412, IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN2GHZ(2, 2417, IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN2GHZ(3, 2422, IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN2GHZ(4, 2427, IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN2GHZ(5, 2432, 0),
-	CHAN2GHZ(6, 2437, 0),
-	CHAN2GHZ(7, 2442, 0),
-	CHAN2GHZ(8, 2447, IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN2GHZ(9, 2452, IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN2GHZ(10, 2457, IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN2GHZ(11, 2462, IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN2GHZ(12, 2467,
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN2GHZ(13, 2472,
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN2GHZ(14, 2484,
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
-};
+/*
+* called from both kernel as from this kernel module.
+* precondition: perimeter lock is not acquired.
+*/
+static void brcms_remove(struct pci_dev *pdev)
+{
+	struct brcms_info *wl;
+	struct ieee80211_hw *hw;
+	int status;
 
-#define CHAN5GHZ(channel, chflags)  { \
-	.band = IEEE80211_BAND_5GHZ, \
-	.center_freq = 5000 + 5*(channel), \
-	.hw_value = (channel), \
-	.flags = chflags, \
-	.max_antenna_gain = 0, \
-	.max_power = 21, \
-}
+	hw = pci_get_drvdata(pdev);
+	wl = HW_TO_WL(hw);
+	if (!wl) {
+		pr_err("wl: brcms_remove: pci_get_drvdata failed\n");
+		return;
+	}
 
-static struct ieee80211_channel brcms_5ghz_nphy_chantable[] = {
-	/* UNII-1 */
-	CHAN5GHZ(36, IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(40, IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(44, IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(48, IEEE80211_CHAN_NO_HT40PLUS),
-	/* UNII-2 */
-	CHAN5GHZ(52,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(56,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(60,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(64,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	/* MID */
-	CHAN5GHZ(100,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(104,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(108,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(112,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(116,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(120,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(124,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(128,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(132,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(136,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(140,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS |
-		 IEEE80211_CHAN_NO_HT40MINUS),
-	/* UNII-3 */
-	CHAN5GHZ(149, IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(153, IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(157, IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(161, IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(165, IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
-};
+	LOCK(wl);
+	status = brcms_c_chipmatch(pdev->vendor, pdev->device);
+	UNLOCK(wl);
+	if (!status) {
+		wiphy_err(wl->wiphy, "wl: brcms_remove: chipmatch "
+				     "failed\n");
+		return;
+	}
+	if (wl->wlc) {
+		wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, false);
+		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
+		ieee80211_unregister_hw(hw);
+		LOCK(wl);
+		brcms_down(wl);
+		UNLOCK(wl);
+	}
+	pci_disable_device(pdev);
 
-#define RATE(rate100m, _flags) { \
-	.bitrate = (rate100m), \
-	.flags = (_flags), \
-	.hw_value = (rate100m / 5), \
+	brcms_free(wl);
+
+	pci_set_drvdata(pdev, NULL);
+	ieee80211_free_hw(hw);
 }
 
-/*
- * The rate table is used for both 2.4G and 5G rates. The
- * latter being a subset as it does not support CCK rates.
- */
-static struct ieee80211_rate legacy_ratetable[] = {
-	RATE(10, 0),
-	RATE(20, IEEE80211_RATE_SHORT_PREAMBLE),
-	RATE(55, IEEE80211_RATE_SHORT_PREAMBLE),
-	RATE(110, IEEE80211_RATE_SHORT_PREAMBLE),
-	RATE(60, 0),
-	RATE(90, 0),
-	RATE(120, 0),
-	RATE(180, 0),
-	RATE(240, 0),
-	RATE(360, 0),
-	RATE(480, 0),
-	RATE(540, 0),
-};
+static irqreturn_t brcms_isr(int irq, void *dev_id)
+{
+	struct brcms_info *wl;
+	bool ours, wantdpc;
+	unsigned long flags;
 
-static struct ieee80211_supported_band brcms_band_2GHz_nphy = {
-	.band = IEEE80211_BAND_2GHZ,
-	.channels = brcms_2ghz_chantable,
-	.n_channels = ARRAY_SIZE(brcms_2ghz_chantable),
-	.bitrates = legacy_ratetable,
-	.n_bitrates = ARRAY_SIZE(legacy_ratetable),
-	.ht_cap = {
-		   /* from include/linux/ieee80211.h */
-		   .cap = IEEE80211_HT_CAP_GRN_FLD |
-		   IEEE80211_HT_CAP_SGI_20 |
-		   IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_40MHZ_INTOLERANT,
-		   .ht_supported = true,
-		   .ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K,
-		   .ampdu_density = AMPDU_DEF_MPDU_DENSITY,
-		   .mcs = {
-			   /* placeholders for now */
-			   .rx_mask = {0xff, 0xff, 0, 0, 0, 0, 0, 0, 0, 0},
-			   .rx_highest = 500,
-			   .tx_params = IEEE80211_HT_MCS_TX_DEFINED}
-		   }
-};
+	wl = (struct brcms_info *) dev_id;
 
-static struct ieee80211_supported_band brcms_band_5GHz_nphy = {
-	.band = IEEE80211_BAND_5GHZ,
-	.channels = brcms_5ghz_nphy_chantable,
-	.n_channels = ARRAY_SIZE(brcms_5ghz_nphy_chantable),
-	.bitrates = legacy_ratetable + BRCMS_LEGACY_5G_RATE_OFFSET,
-	.n_bitrates = ARRAY_SIZE(legacy_ratetable) -
-			BRCMS_LEGACY_5G_RATE_OFFSET,
-	.ht_cap = {
-		   .cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 |
-			  IEEE80211_HT_CAP_SGI_40 |
-			  IEEE80211_HT_CAP_40MHZ_INTOLERANT, /* No 40 mhz yet */
-		   .ht_supported = true,
-		   .ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K,
-		   .ampdu_density = AMPDU_DEF_MPDU_DENSITY,
-		   .mcs = {
-			   /* placeholders for now */
-			   .rx_mask = {0xff, 0xff, 0, 0, 0, 0, 0, 0, 0, 0},
-			   .rx_highest = 500,
-			   .tx_params = IEEE80211_HT_MCS_TX_DEFINED}
-		   }
-};
+	ISR_LOCK(wl, flags);
+
+	/* call common first level interrupt handler */
+	ours = brcms_c_isr(wl->wlc, &wantdpc);
+	if (ours) {
+		/* if more to do... */
+		if (wantdpc) {
+
+			/* ...and call the second level interrupt handler */
+			/* schedule dpc */
+			tasklet_schedule(&wl->tasklet);
+		}
+	}
+
+	ISR_UNLOCK(wl, flags);
+
+	return IRQ_RETVAL(ours);
+}
 
 /*
  * is called in brcms_pci_probe() context, therefore no locking required.
@@ -1092,6 +1150,126 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 }
 
 /**
+ * attach to the WL device.
+ *
+ * Attach to the WL device identified by vendor and device parameters.
+ * regs is a host accessible memory address pointing to WL device registers.
+ *
+ * brcms_attach is not defined as static because in the case where no bus
+ * is defined, wl_attach will never be called, and thus, gcc will issue
+ * a warning that this function is defined but not used if we declare
+ * it as static.
+ *
+ *
+ * is called in brcms_pci_probe() context, therefore no locking required.
+ */
+static struct brcms_info *brcms_attach(u16 vendor, u16 device,
+				       resource_size_t regs,
+				       struct pci_dev *btparam, uint irq)
+{
+	struct brcms_info *wl = NULL;
+	int unit, err;
+	struct ieee80211_hw *hw;
+	u8 perm[ETH_ALEN];
+
+	unit = n_adapters_found;
+	err = 0;
+
+	if (unit < 0)
+		return NULL;
+
+	/* allocate private info */
+	hw = pci_get_drvdata(btparam);	/* btparam == pdev */
+	if (hw != NULL)
+		wl = hw->priv;
+	if (WARN_ON(hw == NULL) || WARN_ON(wl == NULL))
+		return NULL;
+	wl->wiphy = hw->wiphy;
+
+	atomic_set(&wl->callbacks, 0);
+
+	/* setup the bottom half handler */
+	tasklet_init(&wl->tasklet, brcms_dpc, (unsigned long) wl);
+
+	wl->regsva = ioremap_nocache(regs, PCI_BAR0_WINSZ);
+	if (wl->regsva == NULL) {
+		wiphy_err(wl->wiphy, "wl%d: ioremap() failed\n", unit);
+		goto fail;
+	}
+	spin_lock_init(&wl->lock);
+	spin_lock_init(&wl->isr_lock);
+
+	/* prepare ucode */
+	if (brcms_request_fw(wl, btparam) < 0) {
+		wiphy_err(wl->wiphy, "%s: Failed to find firmware usually in "
+			  "%s\n", KBUILD_MODNAME, "/lib/firmware/brcm");
+		brcms_release_fw(wl);
+		brcms_remove(btparam);
+		return NULL;
+	}
+
+	/* common load-time initialization */
+	wl->wlc = brcms_c_attach(wl, vendor, device, unit, false,
+				 wl->regsva, btparam, &err);
+	brcms_release_fw(wl);
+	if (!wl->wlc) {
+		wiphy_err(wl->wiphy, "%s: attach() failed with code %d\n",
+			  KBUILD_MODNAME, err);
+		goto fail;
+	}
+	wl->pub = brcms_c_pub(wl->wlc);
+
+	wl->pub->ieee_hw = hw;
+
+	if (brcms_c_set_par(wl->wlc, IOV_MPC, 0) < 0)
+		wiphy_err(wl->wiphy, "wl%d: Error setting MPC variable to 0\n",
+			  unit);
+
+	/* register our interrupt handler */
+	if (request_irq(irq, brcms_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
+		wiphy_err(wl->wiphy, "wl%d: request_irq() failed\n", unit);
+		goto fail;
+	}
+	wl->irq = irq;
+
+	/* register module */
+	brcms_c_module_register(wl->pub, "linux", wl, NULL);
+
+	if (ieee_hw_init(hw)) {
+		wiphy_err(wl->wiphy, "wl%d: %s: ieee_hw_init failed!\n", unit,
+			  __func__);
+		goto fail;
+	}
+
+	memcpy(perm, &wl->pub->cur_etheraddr, ETH_ALEN);
+	if (WARN_ON(!is_valid_ether_addr(perm)))
+		goto fail;
+	SET_IEEE80211_PERM_ADDR(hw, perm);
+
+	err = ieee80211_register_hw(hw);
+	if (err)
+		wiphy_err(wl->wiphy, "%s: ieee80211_register_hw failed, status"
+			  "%d\n", __func__, err);
+
+	if (wl->pub->srom_ccode[0])
+		err = brcms_set_hint(wl, wl->pub->srom_ccode);
+	else
+		err = brcms_set_hint(wl, "US");
+	if (err)
+		wiphy_err(wl->wiphy, "%s: regulatory_hint failed, status %d\n",
+			  __func__, err);
+
+	n_adapters_found++;
+	return wl;
+
+fail:
+	brcms_free(wl);
+	return NULL;
+}
+
+
+
+/**
  * determines if a device is a WL device, and if so, attaches it.
  *
  * This function determines if a device pointed to by pdev is a WL device,
@@ -1193,68 +1371,27 @@ static int brcms_resume(struct pci_dev *pdev)
 		return -ENODEV;
 	}
 
-	err = pci_set_power_state(pdev, PCI_D0);
-	if (err)
-		return err;
-
-	pci_restore_state(pdev);
-
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
-
-	pci_set_master(pdev);
-
-	pci_read_config_dword(pdev, 0x40, &val);
-	if ((val & 0x0000ff00) != 0)
-		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
-
-	/*
-	*  done. driver will be put in up state
-	*  in brcms_ops_add_interface() call.
-	*/
-	return err;
-}
-
-/*
-* called from both kernel as from this kernel module.
-* precondition: perimeter lock is not acquired.
-*/
-static void brcms_remove(struct pci_dev *pdev)
-{
-	struct brcms_info *wl;
-	struct ieee80211_hw *hw;
-	int status;
-
-	hw = pci_get_drvdata(pdev);
-	wl = HW_TO_WL(hw);
-	if (!wl) {
-		pr_err("wl: brcms_remove: pci_get_drvdata failed\n");
-		return;
-	}
-
-	LOCK(wl);
-	status = brcms_c_chipmatch(pdev->vendor, pdev->device);
-	UNLOCK(wl);
-	if (!status) {
-		wiphy_err(wl->wiphy, "wl: brcms_remove: chipmatch "
-				     "failed\n");
-		return;
-	}
-	if (wl->wlc) {
-		wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, false);
-		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
-		ieee80211_unregister_hw(hw);
-		LOCK(wl);
-		brcms_down(wl);
-		UNLOCK(wl);
-	}
-	pci_disable_device(pdev);
+	err = pci_set_power_state(pdev, PCI_D0);
+	if (err)
+		return err;
 
-	brcms_free(wl);
+	pci_restore_state(pdev);
 
-	pci_set_drvdata(pdev, NULL);
-	ieee80211_free_hw(hw);
+	err = pci_enable_device(pdev);
+	if (err)
+		return err;
+
+	pci_set_master(pdev);
+
+	pci_read_config_dword(pdev, 0x40, &val);
+	if ((val & 0x0000ff00) != 0)
+		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
+
+	/*
+	*  done. driver will be put in up state
+	*  in brcms_ops_add_interface() call.
+	*/
+	return err;
 }
 
 static struct pci_driver brcms_pci_driver = {
@@ -1307,81 +1444,6 @@ static void __exit brcms_module_exit(void)
 module_init(brcms_module_init);
 module_exit(brcms_module_exit);
 
-/**
- * This function frees the WL per-device resources.
- *
- * This function frees resources owned by the WL device pointed to
- * by the wl parameter.
- *
- * precondition: can both be called locked and unlocked
- *
- */
-static void brcms_free(struct brcms_info *wl)
-{
-	struct brcms_timer *t, *next;
-
-	/* free ucode data */
-	if (wl->fw.fw_cnt)
-		brcms_ucode_data_free();
-	if (wl->irq)
-		free_irq(wl->irq, wl);
-
-	/* kill dpc */
-	tasklet_kill(&wl->tasklet);
-
-	if (wl->pub)
-		brcms_c_module_unregister(wl->pub, "linux", wl);
-
-	/* free common resources */
-	if (wl->wlc) {
-		brcms_c_detach(wl->wlc);
-		wl->wlc = NULL;
-		wl->pub = NULL;
-	}
-
-	/* virtual interface deletion is deferred so we cannot spinwait */
-
-	/* wait for all pending callbacks to complete */
-	while (atomic_read(&wl->callbacks) > 0)
-		schedule();
-
-	/* free timers */
-	for (t = wl->timers; t; t = next) {
-		next = t->next;
-#ifdef BCMDBG
-		kfree(t->name);
-#endif
-		kfree(t);
-	}
-
-	/*
-	 * unregister_netdev() calls get_stats() which may read chip
-	 * registers so we cannot unmap the chip registers until
-	 * after calling unregister_netdev() .
-	 */
-	if (wl->regsva)
-		iounmap((void *)wl->regsva);
-
-	wl->regsva = NULL;
-}
-
-/* flags the given rate in rateset as requested */
-static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
-{
-	u32 i;
-
-	for (i = 0; i < rs->count; i++) {
-		if (rate != (rs->rates[i] & 0x7f))
-			continue;
-
-		if (is_br)
-			rs->rates[i] |= BRCMS_RATE_FLAG;
-		else
-			rs->rates[i] &= BRCMS_RATE_MASK;
-		return;
-	}
-}
-
 /*
  * precondition: perimeter lock has been acquired
  */
@@ -1486,77 +1548,6 @@ void brcms_down(struct brcms_info *wl)
 	LOCK(wl);
 }
 
-static irqreturn_t brcms_isr(int irq, void *dev_id)
-{
-	struct brcms_info *wl;
-	bool ours, wantdpc;
-	unsigned long flags;
-
-	wl = (struct brcms_info *) dev_id;
-
-	ISR_LOCK(wl, flags);
-
-	/* call common first level interrupt handler */
-	ours = brcms_c_isr(wl->wlc, &wantdpc);
-	if (ours) {
-		/* if more to do... */
-		if (wantdpc) {
-
-			/* ...and call the second level interrupt handler */
-			/* schedule dpc */
-			tasklet_schedule(&wl->tasklet);
-		}
-	}
-
-	ISR_UNLOCK(wl, flags);
-
-	return IRQ_RETVAL(ours);
-}
-
-static void brcms_dpc(unsigned long data)
-{
-	struct brcms_info *wl;
-
-	wl = (struct brcms_info *) data;
-
-	LOCK(wl);
-
-	/* call the common second level interrupt handler */
-	if (wl->pub->up) {
-		if (wl->resched) {
-			unsigned long flags;
-
-			INT_LOCK(wl, flags);
-			brcms_c_intrsupd(wl->wlc);
-			INT_UNLOCK(wl, flags);
-		}
-
-		wl->resched = brcms_c_dpc(wl->wlc, true);
-	}
-
-	/* brcms_c_dpc() may bring the driver down */
-	if (!wl->pub->up)
-		goto done;
-
-	/* re-schedule dpc */
-	if (wl->resched)
-		tasklet_schedule(&wl->tasklet);
-	else
-		/* re-enable interrupts */
-		brcms_intrson(wl);
-
- done:
-	UNLOCK(wl);
-}
-
-/*
- * is called by the kernel from software irq context
- */
-static void brcms_timer(unsigned long data)
-{
-	_brcms_timer((struct brcms_timer *) data);
-}
-
 /*
 * precondition: perimeter lock is not acquired
  */
@@ -1582,6 +1573,14 @@ static void _brcms_timer(struct brcms_timer *t)
 }
 
 /*
+ * is called by the kernel from software irq context
+ */
+static void brcms_timer(unsigned long data)
+{
+	_brcms_timer((struct brcms_timer *) data);
+}
+
+/*
  * Adds a timer to the list. Caller supplies a timer function.
  * Is called from wlc.
  *
@@ -1695,17 +1694,6 @@ void brcms_free_timer(struct brcms_info *wl, struct brcms_timer *t)
 
 }
 
-struct firmware_hdr {
-	u32 offset;
-	u32 len;
-	u32 idx;
-};
-
-char *brcms_firmwares[MAX_FW_IMAGES] = {
-	"brcm/bcm43xx",
-	NULL
-};
-
 /*
  * precondition: perimeter lock has been acquired
  */
@@ -1771,44 +1759,6 @@ int brcms_ucode_init_uint(struct brcms_info *wl, u32 *data, u32 idx)
 }
 
 /*
- * Precondition: Since this function is called in brcms_pci_probe() context,
- * no locking is required.
- */
-static int brcms_request_fw(struct brcms_info *wl, struct pci_dev *pdev)
-{
-	int status;
-	struct device *device = &pdev->dev;
-	char fw_name[100];
-	int i;
-
-	memset(&wl->fw, 0, sizeof(struct brcms_firmware));
-	for (i = 0; i < MAX_FW_IMAGES; i++) {
-		if (brcms_firmwares[i] == NULL)
-			break;
-		sprintf(fw_name, "%s-%d.fw", brcms_firmwares[i],
-			UCODE_LOADER_API_VER);
-		status = request_firmware(&wl->fw.fw_bin[i], fw_name, device);
-		if (status) {
-			wiphy_err(wl->wiphy, "%s: fail to load firmware %s\n",
-				  KBUILD_MODNAME, fw_name);
-			return status;
-		}
-		sprintf(fw_name, "%s_hdr-%d.fw", brcms_firmwares[i],
-			UCODE_LOADER_API_VER);
-		status = request_firmware(&wl->fw.fw_hdr[i], fw_name, device);
-		if (status) {
-			wiphy_err(wl->wiphy, "%s: fail to load firmware %s\n",
-				  KBUILD_MODNAME, fw_name);
-			return status;
-		}
-		wl->fw.hdr_num_entries[i] =
-		    wl->fw.fw_hdr[i]->size / (sizeof(struct firmware_hdr));
-	}
-	wl->fw.fw_cnt = i;
-	return brcms_ucode_data_init(wl);
-}
-
-/*
  * precondition: can both be called locked and unlocked
  */
 void brcms_ucode_free_buf(void *p)
@@ -1817,20 +1767,6 @@ void brcms_ucode_free_buf(void *p)
 }
 
 /*
- * Precondition: Since this function is called in brcms_pci_probe() context,
- * no locking is required.
- */
-static void brcms_release_fw(struct brcms_info *wl)
-{
-	int i;
-	for (i = 0; i < MAX_FW_IMAGES; i++) {
-		release_firmware(wl->fw.fw_bin[i]);
-		release_firmware(wl->fw.fw_hdr[i]);
-	}
-}
-
-
-/*
  * checks validity of all firmware images loaded from user space
  *
  * Precondition: Since this function is called in brcms_pci_probe() context,
-- 
1.7.4.1


