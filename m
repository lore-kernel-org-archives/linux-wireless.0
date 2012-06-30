Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53898 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab2F3NSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:18:05 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 16/18] brcmsmac: extend brcms_c_chipmatch() to also handle non PCIe devices
Date: Sat, 30 Jun 2012 15:16:19 +0200
Message-Id: <1341062181-28071-17-git-send-email-hauke@hauke-m.de> (sfid-20120630_151809_543303_F1672DFB)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now brcms_c_chipmatch() is also able to handle non PCI devices and also
does some checking for SoC if they are supported by brcmsmac.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   38 ++++++++++++++++----
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    2 +-
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 2d5a404..2b57f57 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -319,8 +319,7 @@ static void brcms_ops_stop(struct ieee80211_hw *hw)
 		return;
 
 	spin_lock_bh(&wl->lock);
-	status = brcms_c_chipmatch(wl->wlc->hw->vendorid,
-				   wl->wlc->hw->deviceid);
+	status = brcms_c_chipmatch(wl->wlc->hw->d11core);
 	spin_unlock_bh(&wl->lock);
 	if (!status) {
 		wiphy_err(wl->wiphy,
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 46d7646..28988cb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4473,11 +4473,9 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	}
 
 	/* verify again the device is supported */
-	if (core->bus->hosttype == BCMA_HOSTTYPE_PCI &&
-	    !brcms_c_chipmatch(pcidev->vendor, pcidev->device)) {
-		wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported "
-			"vendor/device (0x%x/0x%x)\n",
-			 unit, pcidev->vendor, pcidev->device);
+	if (!brcms_c_chipmatch(core)) {
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported device\n",
+			 unit);
 		err = 12;
 		goto fail;
 	}
@@ -5790,8 +5788,12 @@ void brcms_c_print_txstatus(struct tx_status *txs)
 		 (txs->ackphyrxsh & PRXS1_SQ_MASK) >> PRXS1_SQ_SHIFT);
 }
 
-bool brcms_c_chipmatch(u16 vendor, u16 device)
+static bool brcms_c_chipmatch_pci(struct bcma_device *core)
 {
+	struct pci_dev *pcidev = core->bus->host_pci;
+	u16 vendor = pcidev->vendor;
+	u16 device = pcidev->device;
+
 	if (vendor != PCI_VENDOR_ID_BROADCOM) {
 		pr_err("unknown vendor id %04x\n", vendor);
 		return false;
@@ -5810,6 +5812,30 @@ bool brcms_c_chipmatch(u16 vendor, u16 device)
 	return false;
 }
 
+static bool brcms_c_chipmatch_soc(struct bcma_device *core)
+{
+	struct bcma_chipinfo *chipinfo = &core->bus->chipinfo;
+
+	if (chipinfo->id == BCMA_CHIP_ID_BCM4716)
+		return true;
+
+	pr_err("unknown chip id %04x\n", chipinfo->id);
+	return false;
+}
+
+bool brcms_c_chipmatch(struct bcma_device *core)
+{
+	switch (core->bus->hosttype) {
+	case BCMA_HOSTTYPE_PCI:
+		return brcms_c_chipmatch_pci(core);
+	case BCMA_HOSTTYPE_SOC:
+		return brcms_c_chipmatch_soc(core);
+	default:
+		pr_err("unknown host type: %i\n", core->bus->hosttype);
+		return false;
+	}
+}
+
 #if defined(DEBUG)
 void brcms_c_print_txdesc(struct d11txh *txh)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index aa5d67f..5855f4f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -311,7 +311,7 @@ extern uint brcms_c_detach(struct brcms_c_info *wlc);
 extern int brcms_c_up(struct brcms_c_info *wlc);
 extern uint brcms_c_down(struct brcms_c_info *wlc);
 
-extern bool brcms_c_chipmatch(u16 vendor, u16 device);
+extern bool brcms_c_chipmatch(struct bcma_device *core);
 extern void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx);
 extern void brcms_c_reset(struct brcms_c_info *wlc);
 
-- 
1.7.9.5

