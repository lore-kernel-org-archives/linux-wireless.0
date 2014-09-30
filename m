Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:9049 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaI3IXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 04:23:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/6] brcmfmac: Add wowl support for PCIE devices.
Date: Tue, 30 Sep 2014 10:23:18 +0200
Message-ID: <1412065398-14316-7-git-send-email-arend@broadcom.com> (sfid-20140930_102344_754845_71EE2366)
In-Reply-To: <1412065398-14316-1-git-send-email-arend@broadcom.com>
References: <1412065398-14316-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Add basic wowl (magic packet and disconnect) support. This patch adds
this support only for PCIE bus devices. This feature requires FW which
has support for wowl built in.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |  11 +++
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  |   2 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.h  |   3 +-
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |  56 +++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |  74 +++++++++++---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 106 ++++++++++++++++-----
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   4 +
 drivers/net/wireless/brcm80211/include/defs.h      |   5 +-
 8 files changed, 220 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 3122b86..80e73a1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -67,6 +67,7 @@ struct brcmf_bus_dcmd {
  * @txctl: transmit a control request message to dongle.
  * @rxctl: receive a control response message from dongle.
  * @gettxq: obtain a reference of bus transmit queue (optional).
+ * @wowl_config: specify if dongle is configured for wowl when going to suspend
  *
  * This structure provides an abstract interface towards the
  * bus specific driver. For control messages to common driver
@@ -80,6 +81,7 @@ struct brcmf_bus_ops {
 	int (*txctl)(struct device *dev, unsigned char *msg, uint len);
 	int (*rxctl)(struct device *dev, unsigned char *msg, uint len);
 	struct pktq * (*gettxq)(struct device *dev);
+	void (*wowl_config)(struct device *dev, bool enabled);
 };
 
 
@@ -114,6 +116,7 @@ struct brcmf_bus_msgbuf {
  * @dstats: dongle-based statistical data.
  * @dcmd_list: bus/device specific dongle initialization commands.
  * @chip: device identifier of the dongle chip.
+ * @wowl_supported: is wowl supported by bus driver.
  * @chiprev: revision of the dongle chip.
  */
 struct brcmf_bus {
@@ -131,6 +134,7 @@ struct brcmf_bus {
 	u32 chip;
 	u32 chiprev;
 	bool always_use_fws_queue;
+	bool wowl_supported;
 
 	struct brcmf_bus_ops *ops;
 	struct brcmf_bus_msgbuf *msgbuf;
@@ -177,6 +181,13 @@ struct pktq *brcmf_bus_gettxq(struct brcmf_bus *bus)
 	return bus->ops->gettxq(bus->dev);
 }
 
+static inline
+void brcmf_bus_wowl_config(struct brcmf_bus *bus, bool enabled)
+{
+	if (bus->ops->wowl_config)
+		bus->ops->wowl_config(bus->dev, enabled);
+}
+
 static inline bool brcmf_bus_ready(struct brcmf_bus *bus)
 {
 	return bus->state == BRCMF_BUS_LOAD || bus->state == BRCMF_BUS_DATA;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
index 50877e3..aed53ac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -107,6 +107,8 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	struct brcmf_if *ifp = drvr->iflist[0];
 
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_MCHAN, "mchan");
+	if (drvr->bus_if->wowl_supported)
+		brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
 
 	/* set chip related quirks */
 	switch (drvr->bus_if->chip) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
index 961d175..b9a796d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
@@ -22,7 +22,8 @@
  * MCHAN: multi-channel for concurrent P2P.
  */
 #define BRCMF_FEAT_LIST \
-	BRCMF_FEAT_DEF(MCHAN)
+	BRCMF_FEAT_DEF(MCHAN) \
+	BRCMF_FEAT_DEF(WOWL)
 /*
  * Quirks:
  *
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 2bc68a2..5ff5cd0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -53,6 +53,62 @@
 #define BRCMF_OBSS_COEX_OFF		0
 #define BRCMF_OBSS_COEX_ON		1
 
+/* WOWL bits */
+/* Wakeup on Magic packet: */
+#define WL_WOWL_MAGIC			(1 << 0)
+/* Wakeup on Netpattern */
+#define WL_WOWL_NET			(1 << 1)
+/* Wakeup on loss-of-link due to Disassoc/Deauth: */
+#define WL_WOWL_DIS			(1 << 2)
+/* Wakeup on retrograde TSF: */
+#define WL_WOWL_RETR			(1 << 3)
+/* Wakeup on loss of beacon: */
+#define WL_WOWL_BCN			(1 << 4)
+/* Wakeup after test: */
+#define WL_WOWL_TST			(1 << 5)
+/* Wakeup after PTK refresh: */
+#define WL_WOWL_M1			(1 << 6)
+/* Wakeup after receipt of EAP-Identity Req: */
+#define WL_WOWL_EAPID			(1 << 7)
+/* Wakeind via PME(0) or GPIO(1): */
+#define WL_WOWL_PME_GPIO		(1 << 8)
+/* need tkip phase 1 key to be updated by the driver: */
+#define WL_WOWL_NEEDTKIP1		(1 << 9)
+/* enable wakeup if GTK fails: */
+#define WL_WOWL_GTK_FAILURE		(1 << 10)
+/* support extended magic packets: */
+#define WL_WOWL_EXTMAGPAT		(1 << 11)
+/* support ARP/NS/keepalive offloading: */
+#define WL_WOWL_ARPOFFLOAD		(1 << 12)
+/* read protocol version for EAPOL frames: */
+#define WL_WOWL_WPA2			(1 << 13)
+/* If the bit is set, use key rotaton: */
+#define WL_WOWL_KEYROT			(1 << 14)
+/* If the bit is set, frm received was bcast frame: */
+#define WL_WOWL_BCAST			(1 << 15)
+/* If the bit is set, scan offload is enabled: */
+#define WL_WOWL_SCANOL			(1 << 16)
+/* Wakeup on tcpkeep alive timeout: */
+#define WL_WOWL_TCPKEEP_TIME		(1 << 17)
+/* Wakeup on mDNS Conflict Resolution: */
+#define WL_WOWL_MDNS_CONFLICT		(1 << 18)
+/* Wakeup on mDNS Service Connect: */
+#define WL_WOWL_MDNS_SERVICE		(1 << 19)
+/* tcp keepalive got data: */
+#define WL_WOWL_TCPKEEP_DATA		(1 << 20)
+/* Firmware died in wowl mode: */
+#define WL_WOWL_FW_HALT			(1 << 21)
+/* Enable detection of radio button changes: */
+#define WL_WOWL_ENAB_HWRADIO		(1 << 22)
+/* Offloads detected MIC failure(s): */
+#define WL_WOWL_MIC_FAIL		(1 << 23)
+/* Wakeup in Unassociated state (Net/Magic Pattern): */
+#define WL_WOWL_UNASSOC			(1 << 24)
+/* Wakeup if received matched secured pattern: */
+#define WL_WOWL_SECURE			(1 << 25)
+/* Link Down indication in WoWL mode: */
+#define WL_WOWL_LINKDOWN		(1 << 31)
+
 /* join preference types for join_pref iovar */
 enum brcmf_join_pref_types {
 	BRCMF_JOIN_PREF_RSSI = 1,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index e5101b2..8c0632e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -165,6 +165,8 @@ enum brcmf_pcie_state {
 
 #define BRCMF_H2D_HOST_D3_INFORM		0x00000001
 #define BRCMF_H2D_HOST_DS_ACK			0x00000002
+#define BRCMF_H2D_HOST_D0_INFORM_IN_USE		0x00000008
+#define BRCMF_H2D_HOST_D0_INFORM		0x00000010
 
 #define BRCMF_PCIE_MBDATA_TIMEOUT		2000
 
@@ -243,6 +245,7 @@ struct brcmf_pciedev_info {
 	wait_queue_head_t mbdata_resp_wait;
 	bool mbdata_completed;
 	bool irq_allocated;
+	bool wowl_enabled;
 };
 
 struct brcmf_pcie_ringbuf {
@@ -537,7 +540,7 @@ static int brcmf_pcie_exit_download_state(struct brcmf_pciedev_info *devinfo,
 }
 
 
-static void
+static int
 brcmf_pcie_send_mb_data(struct brcmf_pciedev_info *devinfo, u32 htod_mb_data)
 {
 	struct brcmf_pcie_shared_info *shared;
@@ -558,13 +561,15 @@ brcmf_pcie_send_mb_data(struct brcmf_pciedev_info *devinfo, u32 htod_mb_data)
 		msleep(10);
 		i++;
 		if (i > 100)
-			break;
+			return -EIO;
 		cur_htod_mb_data = brcmf_pcie_read_tcm32(devinfo, addr);
 	}
 
 	brcmf_pcie_write_tcm32(devinfo, addr, htod_mb_data);
 	pci_write_config_dword(devinfo->pdev, BRCMF_PCIE_REG_SBMBX, 1);
 	pci_write_config_dword(devinfo->pdev, BRCMF_PCIE_REG_SBMBX, 1);
+
+	return 0;
 }
 
 
@@ -1229,11 +1234,27 @@ static int brcmf_pcie_rx_ctlpkt(struct device *dev, unsigned char *msg,
 }
 
 
+static void brcmf_pcie_wowl_config(struct device *dev, bool enabled)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pciedev *buspub = bus_if->bus_priv.pcie;
+	struct brcmf_pciedev_info *devinfo = buspub->devinfo;
+
+	brcmf_dbg(PCIE, "Configuring WOWL, enabled=%d\n", enabled);
+	devinfo->wowl_enabled = enabled;
+	if (enabled)
+		device_set_wakeup_enable(&devinfo->pdev->dev, true);
+	else
+		device_set_wakeup_enable(&devinfo->pdev->dev, false);
+}
+
+
 static struct brcmf_bus_ops brcmf_pcie_bus_ops = {
 	.txdata = brcmf_pcie_tx,
 	.stop = brcmf_pcie_down,
 	.txctl = brcmf_pcie_tx_ctlpkt,
 	.rxctl = brcmf_pcie_rx_ctlpkt,
+	.wowl_config = brcmf_pcie_wowl_config,
 };
 
 
@@ -1668,6 +1689,7 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	bus->ops = &brcmf_pcie_bus_ops;
 	bus->proto_type = BRCMF_PROTO_MSGBUF;
 	bus->chip = devinfo->coreid;
+	bus->wowl_supported = pci_pme_capable(pdev, PCI_D3hot);
 	dev_set_drvdata(&pdev->dev, bus);
 
 	ret = brcmf_pcie_get_fwnames(devinfo);
@@ -1759,36 +1781,62 @@ static int brcmf_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
 		brcmf_err("Timeout on response for entering D3 substate\n");
 		return -EIO;
 	}
-	brcmf_pcie_release_irq(devinfo);
+	brcmf_pcie_send_mb_data(devinfo, BRCMF_H2D_HOST_D0_INFORM_IN_USE);
 
 	err = pci_save_state(pdev);
-	if (err) {
+	if (err)
 		brcmf_err("pci_save_state failed, err=%d\n", err);
-		return err;
+	if ((err) || (!devinfo->wowl_enabled)) {
+		brcmf_chip_detach(devinfo->ci);
+		devinfo->ci = NULL;
+		brcmf_pcie_remove(pdev);
+		return 0;
 	}
 
-	brcmf_chip_detach(devinfo->ci);
-	devinfo->ci = NULL;
-
-	brcmf_pcie_remove(pdev);
-
 	return pci_prepare_to_sleep(pdev);
 }
 
-
 static int brcmf_pcie_resume(struct pci_dev *pdev)
 {
+	struct brcmf_pciedev_info *devinfo;
+	struct brcmf_bus *bus;
 	int err;
 
-	brcmf_dbg(PCIE, "Enter, pdev=%p\n", pdev);
+	bus = dev_get_drvdata(&pdev->dev);
+	brcmf_dbg(PCIE, "Enter, pdev=%p, bus=%p\n", pdev, bus);
 
 	err = pci_set_power_state(pdev, PCI_D0);
 	if (err) {
 		brcmf_err("pci_set_power_state failed, err=%d\n", err);
-		return err;
+		goto cleanup;
 	}
 	pci_restore_state(pdev);
+	pci_enable_wake(pdev, PCI_D3hot, false);
+	pci_enable_wake(pdev, PCI_D3cold, false);
+
+	/* Check if device is still up and running, if so we are ready */
+	if (bus) {
+		devinfo = bus->bus_priv.pcie->devinfo;
+		if (brcmf_pcie_read_reg32(devinfo,
+					  BRCMF_PCIE_PCIE2REG_INTMASK) != 0) {
+			if (brcmf_pcie_send_mb_data(devinfo,
+						    BRCMF_H2D_HOST_D0_INFORM))
+				goto cleanup;
+			brcmf_dbg(PCIE, "Hot resume, continue....\n");
+			brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
+			brcmf_bus_change_state(bus, BRCMF_BUS_DATA);
+			brcmf_pcie_intr_enable(devinfo);
+			return 0;
+		}
+	}
 
+cleanup:
+	if (bus) {
+		devinfo = bus->bus_priv.pcie->devinfo;
+		brcmf_chip_detach(devinfo->ci);
+		devinfo->ci = NULL;
+		brcmf_pcie_remove(pdev);
+	}
 	err = brcmf_pcie_probe(pdev, NULL);
 	if (err)
 		brcmf_err("probe after resume failed, err=%d\n", err);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6860501..e9e18e1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -37,6 +37,7 @@
 #include "fwil.h"
 #include "proto.h"
 #include "vendor.h"
+#include "dhd_bus.h"
 
 #define BRCMF_SCAN_IE_LEN_MAX		2048
 #define BRCMF_PNO_VERSION		2
@@ -2777,50 +2778,91 @@ static __always_inline void brcmf_delay(u32 ms)
 
 static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+
 	brcmf_dbg(TRACE, "Enter\n");
 
+	if (cfg->wowl_enabled) {
+		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM,
+				      cfg->pre_wowl_pmmode);
+		brcmf_fil_iovar_data_set(ifp, "wowl_pattern", "clr", 4);
+		brcmf_fil_iovar_int_set(ifp, "wowl_clear", 0);
+		cfg->wowl_enabled = false;
+	}
 	return 0;
 }
 
+static void brcmf_configure_wowl(struct brcmf_cfg80211_info *cfg,
+				 struct brcmf_if *ifp,
+				 struct cfg80211_wowlan *wowl)
+{
+	u32 wowl_config;
+
+	brcmf_dbg(TRACE, "Suspend, wowl config.\n");
+
+	brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_PM, &cfg->pre_wowl_pmmode);
+	brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, PM_MAX);
+
+	wowl_config = 0;
+	if (wowl->disconnect)
+		wowl_config |= WL_WOWL_DIS | WL_WOWL_BCN | WL_WOWL_RETR;
+		/* Note: if "wowl" target and not "wowlpf" then wowl_bcn_loss
+		 * should be configured. This paramater is not supported by
+		 * wowlpf.
+		 */
+	if (wowl->magic_pkt)
+		wowl_config |= WL_WOWL_MAGIC;
+	brcmf_fil_iovar_int_set(ifp, "wowl", wowl_config);
+	brcmf_fil_iovar_int_set(ifp, "wowl_activate", 1);
+	brcmf_bus_wowl_config(cfg->pub->bus_if, true);
+	cfg->wowl_enabled = true;
+}
+
 static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
-				  struct cfg80211_wowlan *wow)
+				  struct cfg80211_wowlan *wowl)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_vif *vif;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/*
-	 * if the primary net_device is not READY there is nothing
+	/* if the primary net_device is not READY there is nothing
 	 * we can do but pray resume goes smoothly.
 	 */
-	vif = ((struct brcmf_if *)netdev_priv(ndev))->vif;
-	if (!check_vif_up(vif))
+	if (!check_vif_up(ifp->vif))
 		goto exit;
 
-	list_for_each_entry(vif, &cfg->vif_list, list) {
-		if (!test_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state))
-			continue;
-		/*
-		 * While going to suspend if associated with AP disassociate
-		 * from AP to save power while system is in suspended state
-		 */
-		brcmf_link_down(vif);
-
-		/* Make sure WPA_Supplicant receives all the event
-		 * generated due to DISASSOC call to the fw to keep
-		 * the state fw and WPA_Supplicant state consistent
-		 */
-		brcmf_delay(500);
-	}
-
 	/* end any scanning */
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status))
 		brcmf_abort_scanning(cfg);
 
-	/* Turn off watchdog timer */
-	brcmf_set_mpc(netdev_priv(ndev), 1);
+	if (wowl == NULL) {
+		brcmf_bus_wowl_config(cfg->pub->bus_if, false);
+		list_for_each_entry(vif, &cfg->vif_list, list) {
+			if (!test_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state))
+				continue;
+			/* While going to suspend if associated with AP
+			 * disassociate from AP to save power while system is
+			 * in suspended state
+			 */
+			brcmf_link_down(vif);
+			/* Make sure WPA_Supplicant receives all the event
+			 * generated due to DISASSOC call to the fw to keep
+			 * the state fw and WPA_Supplicant state consistent
+			 */
+			brcmf_delay(500);
+		}
+		/* Configure MPC */
+		brcmf_set_mpc(ifp, 1);
+
+	} else {
+		/* Configure WOWL paramaters */
+		brcmf_configure_wowl(cfg, ifp, wowl);
+	}
 
 exit:
 	brcmf_dbg(TRACE, "Exit\n");
@@ -5393,6 +5435,21 @@ static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 	wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 }
 
+
+#ifdef CONFIG_PM
+static const struct wiphy_wowlan_support brcmf_wowlan_support = {
+	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
+};
+#endif
+
+static void brcmf_wiphy_wowl_params(struct wiphy *wiphy)
+{
+#ifdef CONFIG_PM
+	/* wowl settings */
+	wiphy->wowlan = &brcmf_wowlan_support;
+#endif
+}
+
 static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
 	struct ieee80211_iface_combination ifc_combo;
@@ -5430,6 +5487,9 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	wiphy->vendor_commands = brcmf_vendor_cmds;
 	wiphy->n_vendor_commands = BRCMF_VNDR_CMDS_LAST - 1;
 
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL))
+		brcmf_wiphy_wowl_params(wiphy);
+
 	return brcmf_setup_wiphybands(wiphy);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 82f8778..6abf94e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -363,6 +363,8 @@ struct brcmf_cfg80211_vif_event {
  * @vif_list: linked list of vif instances.
  * @vif_cnt: number of vif instances.
  * @vif_event: vif event signalling.
+ * @wowl_enabled; set during suspend, is wowl used.
+ * @pre_wowl_pmmode: intermediate storage of pm mode during wowl.
  */
 struct brcmf_cfg80211_info {
 	struct wiphy *wiphy;
@@ -396,6 +398,8 @@ struct brcmf_cfg80211_info {
 	struct brcmf_cfg80211_vif_event vif_event;
 	struct completion vif_disabled;
 	struct brcmu_d11inf d11inf;
+	bool wowl_enabled;
+	u32 pre_wowl_pmmode;
 };
 
 /**
diff --git a/drivers/net/wireless/brcm80211/include/defs.h b/drivers/net/wireless/brcm80211/include/defs.h
index fb7cbcf..8d1e85e 100644
--- a/drivers/net/wireless/brcm80211/include/defs.h
+++ b/drivers/net/wireless/brcm80211/include/defs.h
@@ -74,10 +74,6 @@
 #define	BRCM_BAND_2G		2	/* 2.4 Ghz */
 #define	BRCM_BAND_ALL		3	/* all bands */
 
-/* Values for PM */
-#define PM_OFF	0
-#define PM_MAX	1
-
 /* Debug levels */
 #define BRCM_DL_INFO		0x00000001
 #define BRCM_DL_MAC80211	0x00000002
@@ -87,6 +83,7 @@
 #define BRCM_DL_DMA		0x00000020
 #define BRCM_DL_HT		0x00000040
 
+/* Values for PM */
 #define PM_OFF	0
 #define PM_MAX	1
 #define PM_FAST 2
-- 
1.9.1

