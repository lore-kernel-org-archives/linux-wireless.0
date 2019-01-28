Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B74C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D163120880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfA1Pmt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:42:49 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:19718 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbfA1Pms (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:42:48 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2019 10:42:40 EST
X-IronPort-AV: E=Sophos;i="5.56,534,1539640800"; 
   d="scan'208";a="1881350"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 28 Jan 2019 16:36:29 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9150"; a="7037500"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 28 Jan 2019 16:36:29 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 02/12] wil6210: use platform specific configuration
Date:   Mon, 28 Jan 2019 17:36:16 +0200
Message-Id: <1548689786-23288-3-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some of wil6210 configuration variables are platform specific.
Add platform op to allow the platform driver to change the wil6210
default configuration.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c     | 15 ++--
 drivers/net/wireless/ath/wil6210/main.c         | 96 +++++++++++--------------
 drivers/net/wireless/ath/wil6210/netdev.c       |  4 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c     | 33 +++++----
 drivers/net/wireless/ath/wil6210/pm.c           |  4 +-
 drivers/net/wireless/ath/wil6210/txrx.c         | 15 ++--
 drivers/net/wireless/ath/wil6210/wil6210.h      | 13 ++--
 drivers/net/wireless/ath/wil6210/wil_platform.h | 23 ++++++
 drivers/net/wireless/ath/wil6210/wmi.c          | 23 +++---
 9 files changed, 112 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 9b2f9f5..0bd2d73 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -25,10 +25,6 @@
 
 #define WIL_MAX_ROC_DURATION_MS 5000
 
-bool disable_ap_sme;
-module_param(disable_ap_sme, bool, 0444);
-MODULE_PARM_DESC(disable_ap_sme, " let user space handle AP mode SME");
-
 #ifdef CONFIG_PM
 static struct wiphy_wowlan_support wil_wowlan_support = {
 	.flags = WIPHY_WOWLAN_ANY | WIPHY_WOWLAN_DISCONNECT,
@@ -1991,7 +1987,7 @@ static int wil_cfg80211_add_station(struct wiphy *wiphy,
 		     mac, params->aid, vif->mid,
 		     params->sta_flags_mask, params->sta_flags_set);
 
-	if (!disable_ap_sme) {
+	if (!wil->config.disable_ap_sme) {
 		wil_err(wil, "not supported with AP SME enabled\n");
 		return -EOPNOTSUPP;
 	}
@@ -2036,7 +2032,7 @@ static int wil_cfg80211_change_station(struct wiphy *wiphy,
 		     mac, params->sta_flags_mask, params->sta_flags_set,
 		     vif->mid);
 
-	if (!disable_ap_sme) {
+	if (!wil->config.disable_ap_sme) {
 		wil_dbg_misc(wil, "not supported with AP SME enabled\n");
 		return -EOPNOTSUPP;
 	}
@@ -2411,10 +2407,7 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 	wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
 			WIPHY_FLAG_PS_ON_BY_DEFAULT;
-	if (!disable_ap_sme)
-		wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME;
-	dev_dbg(wiphy_dev(wiphy), "%s : flags = 0x%08x\n",
-		__func__, wiphy->flags);
+
 	wiphy->probe_resp_offload =
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 5b7de00..087ab0e 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -31,10 +31,6 @@
 #define WIL_DEFAULT_NUM_RX_STATUS_RINGS 1
 #define WIL_BOARD_FILE_MAX_NAMELEN 128
 
-bool debug_fw; /* = false; */
-module_param(debug_fw, bool, 0444);
-MODULE_PARM_DESC(debug_fw, " do not perform card reset. For FW debug");
-
 static u8 oob_mode;
 module_param(oob_mode, byte, 0444);
 MODULE_PARM_DESC(oob_mode,
@@ -44,14 +40,6 @@
 module_param(no_fw_recovery, bool, 0644);
 MODULE_PARM_DESC(no_fw_recovery, " disable automatic FW error recovery");
 
-/* if not set via modparam, will be set to default value of 1/8 of
- * rx ring size during init flow
- */
-unsigned short rx_ring_overflow_thrsh = WIL6210_RX_HIGH_TRSH_INIT;
-module_param(rx_ring_overflow_thrsh, ushort, 0444);
-MODULE_PARM_DESC(rx_ring_overflow_thrsh,
-		 " RX ring overflow threshold in descriptors.");
-
 /* We allow allocation of more than 1 page buffers to support large packets.
  * It is suboptimal behavior performance wise in case MTU above page size.
  */
@@ -81,39 +69,6 @@ static int mtu_max_set(const char *val, const struct kernel_param *kp)
 module_param_cb(mtu_max, &mtu_max_ops, &mtu_max, 0444);
 MODULE_PARM_DESC(mtu_max, " Max MTU value.");
 
-static uint rx_ring_order;
-static uint tx_ring_order = WIL_TX_RING_SIZE_ORDER_DEFAULT;
-static uint bcast_ring_order = WIL_BCAST_RING_SIZE_ORDER_DEFAULT;
-
-static int ring_order_set(const char *val, const struct kernel_param *kp)
-{
-	int ret;
-	uint x;
-
-	ret = kstrtouint(val, 0, &x);
-	if (ret)
-		return ret;
-
-	if ((x < WIL_RING_SIZE_ORDER_MIN) || (x > WIL_RING_SIZE_ORDER_MAX))
-		return -EINVAL;
-
-	*((uint *)kp->arg) = x;
-
-	return 0;
-}
-
-static const struct kernel_param_ops ring_order_ops = {
-	.set = ring_order_set,
-	.get = param_get_uint,
-};
-
-module_param_cb(rx_ring_order, &ring_order_ops, &rx_ring_order, 0444);
-MODULE_PARM_DESC(rx_ring_order, " Rx ring order; size = 1 << order");
-module_param_cb(tx_ring_order, &ring_order_ops, &tx_ring_order, 0444);
-MODULE_PARM_DESC(tx_ring_order, " Tx ring order; size = 1 << order");
-module_param_cb(bcast_ring_order, &ring_order_ops, &bcast_ring_order, 0444);
-MODULE_PARM_DESC(bcast_ring_order, " Bcast ring order; size = 1 << order");
-
 enum {
 	WIL_BOOT_ERR,
 	WIL_BOOT_VANILLA,
@@ -390,7 +345,8 @@ static int wil_disconnect_cid(struct wil6210_vif *vif, int cid,
 	}
 
 	/* inform lower layers */
-	if (wdev->iftype == NL80211_IFTYPE_AP && disable_ap_sme)
+	if (wdev->iftype == NL80211_IFTYPE_AP &&
+	    wil->config.disable_ap_sme)
 		del_sta = true;
 
 	/* disconnect by sending command disconnect/del_sta and wait
@@ -616,7 +572,12 @@ int wil_ring_init_tx(struct wil6210_vif *vif, int cid)
 	wil_dbg_wmi(wil, "Configure for connection CID %d MID %d ring %d\n",
 		    cid, vif->mid, ringid);
 
-	rc = wil->txrx_ops.ring_init_tx(vif, ringid, 1 << tx_ring_order,
+	if (wil->config.tx_ring_order < WIL_RING_SIZE_ORDER_MIN ||
+	    wil->config.tx_ring_order > WIL_RING_SIZE_ORDER_MAX)
+		wil->config.tx_ring_order = WIL_TX_RING_SIZE_ORDER_DEFAULT;
+
+	rc = wil->txrx_ops.ring_init_tx(vif, ringid,
+					1 << wil->config.tx_ring_order,
 					cid, 0);
 	if (rc)
 		wil_err(wil, "init TX for CID %d MID %d vring %d failed\n",
@@ -638,8 +599,14 @@ int wil_bcast_init(struct wil6210_vif *vif)
 	if (ri < 0)
 		return ri;
 
+	if (wil->config.bcast_ring_order < WIL_RING_SIZE_ORDER_MIN ||
+	    wil->config.bcast_ring_order > WIL_RING_SIZE_ORDER_MAX)
+		wil->config.bcast_ring_order =
+			WIL_BCAST_RING_SIZE_ORDER_DEFAULT;
+
 	vif->bcast_ring = ri;
-	rc = wil->txrx_ops.ring_init_bcast(vif, ri, 1 << bcast_ring_order);
+	rc = wil->txrx_ops.ring_init_bcast(vif, ri,
+					   1 << wil->config.bcast_ring_order);
 	if (rc)
 		vif->bcast_ring = -1;
 
@@ -718,9 +685,6 @@ int wil_priv_init(struct wil6210_priv *wil)
 	wil->tx_max_burst_duration = WIL6210_ITR_TX_MAX_BURST_DURATION_DEFAULT;
 	wil->rx_max_burst_duration = WIL6210_ITR_RX_MAX_BURST_DURATION_DEFAULT;
 
-	if (rx_ring_overflow_thrsh == WIL6210_RX_HIGH_TRSH_INIT)
-		rx_ring_overflow_thrsh = WIL6210_RX_HIGH_TRSH_DEFAULT;
-
 	wil->ps_profile =  WMI_PS_PROFILE_TYPE_DEFAULT;
 
 	wil->wakeup_trigger = WMI_WAKEUP_TRIGGER_UCAST |
@@ -1235,6 +1199,12 @@ void wil_refresh_fw_capabilities(struct wil6210_priv *wil)
 	if (test_bit(WMI_FW_CAPABILITY_TX_REQ_EXT, wil->fw_capabilities))
 		wiphy->flags |= WIPHY_FLAG_OFFCHAN_TX;
 
+	if (!wil->config.disable_ap_sme)
+		wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME;
+
+	dev_dbg(wiphy_dev(wiphy), "%s : flags = 0x%08x\n",
+		__func__, wiphy->flags);
+
 	if (wil->platform_ops.set_features) {
 		features = (test_bit(WMI_FW_CAPABILITY_REF_CLOCK_CONTROL,
 				     wil->fw_capabilities) &&
@@ -1566,7 +1536,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 	WARN_ON(test_bit(wil_status_napi_en, wil->status));
 
-	if (debug_fw) {
+	if (wil->config.debug_fw) {
 		static const u8 mac[ETH_ALEN] = {
 			0x00, 0xde, 0xad, 0x12, 0x34, 0x56,
 		};
@@ -1787,12 +1757,14 @@ int __wil_up(struct wil6210_priv *wil)
 		return rc;
 
 	/* Rx RING. After MAC and beacon */
-	if (rx_ring_order == 0)
-		rx_ring_order = wil->hw_version < HW_VER_TALYN_MB ?
+	if (wil->config.rx_ring_order == 0 ||
+	    wil->config.rx_ring_order < WIL_RING_SIZE_ORDER_MIN ||
+	    wil->config.rx_ring_order > WIL_RING_SIZE_ORDER_MAX)
+		wil->config.rx_ring_order = wil->hw_version < HW_VER_TALYN_MB ?
 			WIL_RX_RING_SIZE_ORDER_DEFAULT :
 			WIL_RX_RING_SIZE_ORDER_TALYN_DEFAULT;
 
-	rc = wil->txrx_ops.rx_init(wil, rx_ring_order);
+	rc = wil->txrx_ops.rx_init(wil, wil->config.rx_ring_order);
 	if (rc)
 		return rc;
 
@@ -1965,3 +1937,15 @@ void wil_init_txrx_ops(struct wil6210_priv *wil)
 	else
 		wil_init_txrx_ops_legacy_dma(wil);
 }
+
+void wil_init_configuration(struct wil6210_priv *wil)
+{
+	/* set default config values */
+	wil->config.n_msi = 3;
+	wil->config.max_assoc_sta = WIL6210_MAX_CID;
+
+	/* update the configuration with platform specific configuration */
+	if (wil->platform_ops.get_config)
+		wil->platform_ops.get_config(wil->platform_handle,
+					     &wil->config);
+}
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index b4e0eb1..ca10626 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -54,7 +54,7 @@ static int wil_open(struct net_device *ndev)
 
 	wil_dbg_misc(wil, "open\n");
 
-	if (debug_fw ||
+	if (wil->config.debug_fw ||
 	    test_bit(WMI_FW_CAPABILITY_WMI_ONLY, wil->fw_capabilities)) {
 		wil_err(wil, "while in debug_fw or wmi_only mode\n");
 		return -EINVAL;
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index c8c6613..93da8f1f 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -24,10 +24,6 @@
 #include <linux/rtnetlink.h>
 #include <linux/pm_runtime.h>
 
-static int n_msi = 3;
-module_param(n_msi, int, 0444);
-MODULE_PARM_DESC(n_msi, " Use MSI interrupt: 0 - use INTx, 1 - single, or 3 - (default) ");
-
 bool ftm_mode;
 module_param(ftm_mode, bool, 0444);
 MODULE_PARM_DESC(ftm_mode, " Set factory test mode, default - false");
@@ -201,31 +197,34 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	pci_set_master(pdev);
 
 	/* how many MSI interrupts to request? */
-	switch (n_msi) {
+	switch (wil->config.n_msi) {
 	case 3:
 	case 1:
-		wil_dbg_misc(wil, "Setup %d MSI interrupts\n", n_msi);
+		wil_dbg_misc(wil, "Setup %d MSI interrupts\n",
+			     wil->config.n_msi);
 		break;
 	case 0:
 		wil_dbg_misc(wil, "MSI interrupts disabled, use INTx\n");
 		break;
 	default:
-		wil_err(wil, "Invalid n_msi=%d, default to 1\n", n_msi);
-		n_msi = 1;
+		wil_err(wil, "Invalid n_msi=%d, default to 1\n",
+			wil->config.n_msi);
+		wil->config.n_msi = 1;
 	}
 
-	if (n_msi == 3 &&
-	    pci_alloc_irq_vectors(pdev, n_msi, n_msi, PCI_IRQ_MSI) < n_msi) {
+	if (wil->config.n_msi == 3 &&
+	    pci_alloc_irq_vectors(pdev, wil->config.n_msi, wil->config.n_msi,
+				  PCI_IRQ_MSI) < wil->config.n_msi) {
 		wil_err(wil, "3 MSI mode failed, try 1 MSI\n");
-		n_msi = 1;
+		wil->config.n_msi = 1;
 	}
 
-	if (n_msi == 1 && pci_enable_msi(pdev)) {
+	if (wil->config.n_msi == 1 && pci_enable_msi(pdev)) {
 		wil_err(wil, "pci_enable_msi failed, use INTx\n");
-		n_msi = 0;
+		wil->config.n_msi = 0;
 	}
 
-	wil->n_msi = n_msi;
+	wil->n_msi = wil->config.n_msi;
 
 	if (wil->n_msi == 0 && msi_only) {
 		wil_err(wil, "Interrupt pin not routed, unable to use INTx\n");
@@ -346,6 +345,10 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		wil_err(wil, "wil_platform_init failed\n");
 		goto if_free;
 	}
+
+	/* Set default config and update it with platform configuration */
+	wil_init_configuration(wil);
+
 	/* rollback to err_plat */
 	rc = pci_enable_device(pdev);
 	if (rc && pdev->msi_enabled == 0) {
diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index 75fe932..9c59bc5 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2014,2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -90,7 +90,7 @@ int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime)
 
 	wil_dbg_pm(wil, "can_suspend: %s\n", is_runtime ? "runtime" : "system");
 
-	if (wmi_only || debug_fw) {
+	if (wmi_only || wil->config.debug_fw) {
 		wil_dbg_pm(wil, "Deny any suspend - %s mode\n",
 			   wmi_only ? "wmi_only" : "debug_fw");
 		rc = -EBUSY;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 9877052..b79fcc7 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -30,17 +30,13 @@
 #include "trace.h"
 #include "txrx_edma.h"
 
-bool rx_align_2;
-module_param(rx_align_2, bool, 0444);
-MODULE_PARM_DESC(rx_align_2, " align Rx buffers on 4*n+2, default - no");
-
 bool rx_large_buf;
 module_param(rx_large_buf, bool, 0444);
 MODULE_PARM_DESC(rx_large_buf, " allocate 8KB RX buffers, default - no");
 
-static inline uint wil_rx_snaplen(void)
+static inline uint wil_rx_snaplen(struct wil6210_priv *wil)
 {
-	return rx_align_2 ? 6 : 0;
+	return wil->config.rx_align_2 ? 6 : 0;
 }
 
 /* wil_ring_wmark_low - low watermark for available descriptor space */
@@ -265,7 +261,7 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct wil_ring *vring,
 			       u32 i, int headroom)
 {
 	struct device *dev = wil_to_dev(wil);
-	unsigned int sz = wil->rx_buf_len + ETH_HLEN + wil_rx_snaplen();
+	unsigned int sz = wil->rx_buf_len + ETH_HLEN + wil_rx_snaplen(wil);
 	struct vring_rx_desc dd, *d = &dd;
 	volatile struct vring_rx_desc *_d = &vring->va[i].rx.legacy;
 	dma_addr_t pa;
@@ -383,7 +379,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	struct vring_rx_desc *d;
 	struct sk_buff *skb;
 	dma_addr_t pa;
-	unsigned int snaplen = wil_rx_snaplen();
+	unsigned int snaplen = wil_rx_snaplen(wil);
 	unsigned int sz = wil->rx_buf_len + ETH_HLEN + snaplen;
 	u16 dmalen;
 	u8 ftype;
@@ -823,6 +819,9 @@ static int wil_rx_init(struct wil6210_priv *wil, uint order)
 		return -EINVAL;
 	}
 
+	if (wil->config.rx_ring_overflow_thrsh == WIL6210_RX_HIGH_TRSH_INIT)
+		wil->config.rx_ring_overflow_thrsh = 1 << (order - 3);
+
 	wil_rx_buf_len_init(wil);
 
 	vring->size = 1 << order;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 0f3be3ff..1a8701e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -31,12 +31,8 @@
 
 extern bool no_fw_recovery;
 extern unsigned int mtu_max;
-extern unsigned short rx_ring_overflow_thrsh;
 extern int agg_wsize;
-extern bool rx_align_2;
 extern bool rx_large_buf;
-extern bool debug_fw;
-extern bool disable_ap_sme;
 extern bool ftm_mode;
 
 struct wil6210_priv;
@@ -143,8 +139,7 @@ static inline u32 wil_mtu2macbuf(u32 mtu)
 #define WIL6210_SCAN_TO		msecs_to_jiffies(10000)
 #define WIL6210_DISCONNECT_TO_MS (2000)
 #define WIL6210_RX_HIGH_TRSH_INIT		(0)
-#define WIL6210_RX_HIGH_TRSH_DEFAULT \
-				(1 << (WIL_RX_RING_SIZE_ORDER_DEFAULT - 3))
+
 #define WIL_MAX_DMG_AID 254 /* for DMG only 1-254 allowed (see
 			     * 802.11REVmc/D5.0, section 9.4.1.8)
 			     */
@@ -1045,6 +1040,8 @@ struct wil6210_priv {
 
 	u32 max_agg_wsize;
 	u32 max_ampdu_size;
+
+	struct wil_platform_config config;
 };
 
 #define wil_to_wiphy(i) (i->wiphy)
@@ -1402,4 +1399,6 @@ int wmi_addba_rx_resp_edma(struct wil6210_priv *wil, u8 mid, u8 cid,
 
 void update_supported_bands(struct wil6210_priv *wil);
 
+void wil_init_configuration(struct wil6210_priv *wil);
+
 #endif /* __WIL6210_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.h b/drivers/net/wireless/ath/wil6210/wil_platform.h
index bca0906..6132888 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.h
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2014-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2019 The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -40,6 +41,27 @@ enum wil_platform_capa {
 	WIL_PLATFORM_CAPA_MAX,
 };
 
+struct wil_platform_config {
+	/* use MSI interrupt: 0 - use INTx, 1 - single, or 3 - (default) */
+	int n_msi;
+	/* align Rx buffers on 4*n+2, default - no */
+	u8 rx_align_2;
+	/* do not perform card reset. For FW debug, default - no */
+	u8 debug_fw;
+	/* RX ring overflow threshold in descriptors */
+	unsigned short rx_ring_overflow_thrsh;
+	/* Rx ring order; size = 1 << order, default 10 */
+	uint rx_ring_order;
+	/* Tx ring order; size = 1 << order, default 12 */
+	uint tx_ring_order;
+	/* Bcast ring order; size = 1 << order, default 7 */
+	uint bcast_ring_order;
+	/* let user space handle AP mode SME */
+	u8 disable_ap_sme;
+	/* Max number of stations associated to the AP */
+	unsigned int max_assoc_sta;
+};
+
 /**
  * struct wil_platform_ops - wil platform module calls from this
  * driver to platform driver
@@ -52,6 +74,7 @@ struct wil_platform_ops {
 	int (*notify)(void *handle, enum wil_platform_event evt);
 	int (*get_capa)(void *handle);
 	void (*set_features)(void *handle, int features);
+	void (*get_config)(void *handle, struct wil_platform_config *config);
 };
 
 /**
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index b1ba519..325635a 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -24,10 +24,6 @@
 #include "wmi.h"
 #include "trace.h"
 
-static uint max_assoc_sta = WIL6210_MAX_CID;
-module_param(max_assoc_sta, uint, 0644);
-MODULE_PARM_DESC(max_assoc_sta, " Max number of stations associated to the AP");
-
 int agg_wsize; /* = 0; */
 module_param(agg_wsize, int, 0644);
 MODULE_PARM_DESC(agg_wsize, " Window size for Tx Block Ack after connect;"
@@ -1049,7 +1045,7 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 		   (wdev->iftype == NL80211_IFTYPE_P2P_GO)) {
 
 		if (rc) {
-			if (disable_ap_sme)
+			if (wil->config.disable_ap_sme)
 				/* notify new_sta has failed */
 				cfg80211_del_sta(ndev, evt->bssid, GFP_KERNEL);
 			goto out;
@@ -1113,7 +1109,7 @@ static void wmi_evt_disconnect(struct wil6210_vif *vif, int id,
 
 	mutex_lock(&wil->mutex);
 	wil6210_disconnect_complete(vif, evt->bssid, reason_code);
-	if (disable_ap_sme) {
+	if (wil->config.disable_ap_sme) {
 		struct wireless_dev *wdev = vif_to_wdev(vif);
 		struct net_device *ndev = vif_to_ndev(vif);
 
@@ -1204,7 +1200,7 @@ static void wmi_evt_ring_en(struct wil6210_vif *vif, int id, void *d, int len)
 		return;
 	}
 
-	if (wdev->iftype != NL80211_IFTYPE_AP || !disable_ap_sme ||
+	if (wdev->iftype != NL80211_IFTYPE_AP || !wil->config.disable_ap_sme ||
 	    test_bit(wil_vif_ft_roam, vif->status))
 		/* in AP mode with disable_ap_sme that is not FT,
 		 * this is done by wil_cfg80211_change_station()
@@ -2100,10 +2096,10 @@ int wmi_pcp_start(struct wil6210_vif *vif,
 		.network_type = wmi_nettype,
 		.disable_sec_offload = 1,
 		.channel = chan - 1,
-		.pcp_max_assoc_sta = max_assoc_sta,
+		.pcp_max_assoc_sta = wil->config.max_assoc_sta,
 		.hidden_ssid = hidden_ssid,
 		.is_go = is_go,
-		.ap_sme_offload_mode = disable_ap_sme ?
+		.ap_sme_offload_mode = wil->config.disable_ap_sme ?
 				       WMI_AP_SME_OFFLOAD_PARTIAL :
 				       WMI_AP_SME_OFFLOAD_FULL,
 		.abft_len = wil->abft_len,
@@ -2122,11 +2118,12 @@ int wmi_pcp_start(struct wil6210_vif *vif,
 	    (cmd.pcp_max_assoc_sta <= 0)) {
 		wil_info(wil,
 			 "Requested connection limit %u, valid values are 1 - %d. Setting to %d\n",
-			 max_assoc_sta, WIL6210_MAX_CID, WIL6210_MAX_CID);
+			 wil->config.max_assoc_sta, WIL6210_MAX_CID,
+			 WIL6210_MAX_CID);
 		cmd.pcp_max_assoc_sta = WIL6210_MAX_CID;
 	}
 
-	if (disable_ap_sme &&
+	if (wil->config.disable_ap_sme &&
 	    !test_bit(WMI_FW_CAPABILITY_AP_SME_OFFLOAD_PARTIAL,
 		      wil->fw_capabilities)) {
 		wil_err(wil, "disable_ap_sme not supported by FW\n");
@@ -2499,7 +2496,7 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct wil_ring *vring)
 		.mid = 0, /* TODO - what is it? */
 		.decap_trans_type = WMI_DECAP_TYPE_802_3,
 		.reorder_type = WMI_RX_SW_REORDER,
-		.host_thrsh = cpu_to_le16(rx_ring_overflow_thrsh),
+		.host_thrsh = cpu_to_le16(wil->config.rx_ring_overflow_thrsh),
 	};
 	struct {
 		struct wmi_cmd_hdr wmi;
@@ -2528,7 +2525,7 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct wil_ring *vring)
 		cmd.l3_l4_ctrl |= (1 << L3_L4_CTRL_TCPIP_CHECKSUM_EN_POS);
 	}
 
-	if (rx_align_2)
+	if (wil->config.rx_align_2)
 		cmd.l2_802_3_offload_ctrl |=
 				L2_802_3_OFFLOAD_CTRL_SNAP_KEEP_MSK;
 
-- 
1.9.1

