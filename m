Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:30537 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbcABIl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 03:41:58 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 6/7] brcmfmac: Move all module parameters to one place
Date: Sat, 2 Jan 2016 09:41:41 +0100
Message-ID: <1451724102-21911-7-git-send-email-arend@broadcom.com> (sfid-20160102_094238_944648_1896B559)
In-Reply-To: <1451724102-21911-1-git-send-email-arend@broadcom.com>
References: <1451724102-21911-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Module parameters are defined in several files. Move them in one
place and make them device specific or global. This makes it
easier to override device specific settings by external data like
platform data in the future.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 12 ++---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 13 ++---
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 63 ++++++++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  | 43 +++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 22 ++++----
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 13 ++---
 .../broadcom/brcm80211/brcmfmac/firmware.c         | 16 +++---
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  9 ++--
 9 files changed, 144 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 410a664..5363739 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -47,6 +47,8 @@
 #include "debug.h"
 #include "sdio.h"
 #include "of.h"
+#include "core.h"
+#include "common.h"
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
@@ -57,7 +59,6 @@
 /* Maximum milliseconds to wait for F2 to come up */
 #define SDIO_WAIT_F2RDY	3000
 
-#define BRCMF_DEFAULT_TXGLOM_SIZE	32  /* max tx frames in glom chain */
 #define BRCMF_DEFAULT_RXGLOM_SIZE	32  /* max rx frames in glom chain */
 
 struct brcmf_sdiod_freezer {
@@ -68,10 +69,6 @@ struct brcmf_sdiod_freezer {
 	struct completion resumed;
 };
 
-static int brcmf_sdiod_txglomsz = BRCMF_DEFAULT_TXGLOM_SIZE;
-module_param_named(txglomsz, brcmf_sdiod_txglomsz, int, 0);
-MODULE_PARM_DESC(txglomsz, "maximum tx packet chain size [SDIO]");
-
 static irqreturn_t brcmf_sdiod_oob_irqhandler(int irq, void *dev_id)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev_id);
@@ -890,7 +887,8 @@ static void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 	if (!sdiodev->sg_support)
 		return;
 
-	nents = max_t(uint, BRCMF_DEFAULT_RXGLOM_SIZE, brcmf_sdiod_txglomsz);
+	nents = max_t(uint, BRCMF_DEFAULT_RXGLOM_SIZE,
+		      sdiodev->bus_if->drvr->settings->sdiod_txglomsz);
 	nents += (nents >> 4) + 1;
 
 	WARN_ON(nents > sdiodev->max_segment_count);
@@ -902,7 +900,7 @@ static void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 		sdiodev->sg_support = false;
 	}
 
-	sdiodev->txglomsz = brcmf_sdiod_txglomsz;
+	sdiodev->txglomsz = sdiodev->bus_if->drvr->settings->sdiod_txglomsz;
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index dc14dd4..6a7759f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -236,10 +236,6 @@ struct parsed_vndr_ies {
 	struct parsed_vndr_ie_info ie_info[VNDR_IE_PARSE_LIMIT];
 };
 
-static int brcmf_roamoff;
-module_param_named(roamoff, brcmf_roamoff, int, S_IRUSR);
-MODULE_PARM_DESC(roamoff, "do not use internal roaming engine");
-
 
 static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
 			       struct cfg80211_chan_def *ch)
@@ -5395,7 +5391,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	__le32 roam_delta[2];
 
 	/* Configure beacon timeout value based upon roaming setting */
-	if (brcmf_roamoff)
+	if (ifp->drvr->settings->roamoff)
 		bcn_timeout = BRCMF_DEFAULT_BCN_TIMEOUT_ROAM_OFF;
 	else
 		bcn_timeout = BRCMF_DEFAULT_BCN_TIMEOUT_ROAM_ON;
@@ -5409,8 +5405,9 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	 * roaming.
 	 */
 	brcmf_dbg(INFO, "Internal Roaming = %s\n",
-		  brcmf_roamoff ? "Off" : "On");
-	err = brcmf_fil_iovar_int_set(ifp, "roam_off", !!(brcmf_roamoff));
+		  ifp->drvr->settings->roamoff ? "Off" : "On");
+	err = brcmf_fil_iovar_int_set(ifp, "roam_off",
+				      ifp->drvr->settings->roamoff);
 	if (err) {
 		brcmf_err("roam_off error (%d)\n", err);
 		goto roam_setup_done;
@@ -6082,7 +6079,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_TDLS))
 		wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
-	if (!brcmf_roamoff)
+	if (!ifp->drvr->settings->roamoff)
 		wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 474de11..bb9e2b3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -35,6 +35,40 @@ const u8 ALLFFMAC[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 /* boost value for RSSI_DELTA in preferred join selection */
 #define BRCMF_JOIN_PREF_RSSI_BOOST	8
 
+#define BRCMF_DEFAULT_TXGLOM_SIZE	32  /* max tx frames in glom chain */
+
+static int brcmf_sdiod_txglomsz = BRCMF_DEFAULT_TXGLOM_SIZE;
+module_param_named(txglomsz, brcmf_sdiod_txglomsz, int, 0);
+MODULE_PARM_DESC(txglomsz, "Maximum tx packet chain size [SDIO]");
+
+/* Debug level configuration. See debug.h for bits, sysfs modifiable */
+int brcmf_msg_level;
+module_param_named(debug, brcmf_msg_level, int, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(debug, "Level of debug output");
+
+static int brcmf_p2p_enable;
+module_param_named(p2pon, brcmf_p2p_enable, int, 0);
+MODULE_PARM_DESC(p2pon, "Enable legacy p2p management functionality");
+
+static int brcmf_feature_disable;
+module_param_named(feature_disable, brcmf_feature_disable, int, 0);
+MODULE_PARM_DESC(feature_disable, "Disable features");
+
+static char brcmf_firmware_path[BRCMF_FW_ALTPATH_LEN];
+module_param_string(alternative_fw_path, brcmf_firmware_path,
+		    BRCMF_FW_ALTPATH_LEN, S_IRUSR);
+MODULE_PARM_DESC(alternative_fw_path, "Alternative firmware path");
+
+static int brcmf_fcmode;
+module_param_named(fcmode, brcmf_fcmode, int, 0);
+MODULE_PARM_DESC(fcmode, "Mode of firmware signalled flow control");
+
+static int brcmf_roamoff;
+module_param_named(roamoff, brcmf_roamoff, int, S_IRUSR);
+MODULE_PARM_DESC(roamoff, "Do not use internal roaming engine");
+
+struct brcmf_mp_global_t brcmf_mp_global;
+
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
@@ -178,3 +212,32 @@ void __brcmf_dbg(u32 level, const char *func, const char *fmt, ...)
 	va_end(args);
 }
 #endif
+
+void brcmf_mp_attach(void)
+{
+	strlcpy(brcmf_mp_global.firmware_path, brcmf_firmware_path,
+		BRCMF_FW_ALTPATH_LEN);
+}
+
+int brcmf_mp_device_attach(struct brcmf_pub *drvr)
+{
+	drvr->settings = kzalloc(sizeof(*drvr->settings), GFP_ATOMIC);
+	if (!drvr->settings) {
+		brcmf_err("Failed to alloca storage space for settings\n");
+		return -ENOMEM;
+	}
+
+	drvr->settings->sdiod_txglomsz = brcmf_sdiod_txglomsz;
+	drvr->settings->p2p_enable = !!brcmf_p2p_enable;
+	drvr->settings->feature_disable = brcmf_feature_disable;
+	drvr->settings->fcmode = brcmf_fcmode;
+	drvr->settings->roamoff = !!brcmf_roamoff;
+
+	return 0;
+}
+
+void brcmf_mp_device_detach(struct brcmf_pub *drvr)
+{
+	kfree(drvr->settings);
+}
+
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index 21c7488..abe3764 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -17,6 +17,49 @@
 
 extern const u8 ALLFFMAC[ETH_ALEN];
 
+#define BRCMF_FW_ALTPATH_LEN			256
+
+/* Definitions for the module global and device specific settings are defined
+ * here. Two structs are used for them. brcmf_mp_global_t and brcmf_mp_device.
+ * The mp_global is instantiated once in a global struct and gets initialized
+ * by the common_attach function which should be called before any other
+ * (module) initiliazation takes place. The device specific settings is part
+ * of the drvr struct and should be initialized on every brcmf_attach.
+ */
+
+/**
+ * struct brcmf_mp_global_t - Global module paramaters.
+ *
+ * @firmware_path: Alternative firmware path.
+ */
+struct brcmf_mp_global_t {
+	char	firmware_path[BRCMF_FW_ALTPATH_LEN];
+};
+
+extern struct brcmf_mp_global_t brcmf_mp_global;
+
+/**
+ * struct brcmf_mp_device - Device module paramaters.
+ *
+ * @sdiod_txglomsz: SDIO txglom size.
+ * @joinboost_5g_rssi: 5g rssi booost for preferred join selection.
+ * @p2p_enable: Legacy P2P0 enable (old wpa_supplicant).
+ * @feature_disable: Feature_disable bitmask.
+ * @fcmode: FWS flow control.
+ * @roamoff: Firmware roaming off?
+ */
+struct brcmf_mp_device {
+	int	sdiod_txglomsz;
+	int	joinboost_5g_rssi;
+	bool	p2p_enable;
+	int	feature_disable;
+	int	fcmode;
+	bool	roamoff;
+};
+
+void brcmf_mp_attach(void);
+int brcmf_mp_device_attach(struct brcmf_pub *drvr);
+void brcmf_mp_device_detach(struct brcmf_pub *drvr);
 /* Sets dongle media info (drv_version, mac address). */
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 4c8f7bf..3fa7bc5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -57,16 +57,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 #define BRCMF_BSSIDX_INVALID			-1
 
-/* Error bits */
-int brcmf_msg_level;
-module_param_named(debug, brcmf_msg_level, int, S_IRUSR | S_IWUSR);
-MODULE_PARM_DESC(debug, "level of debug output");
-
-/* P2P0 enable */
-static int brcmf_p2p_enable;
-module_param_named(p2pon, brcmf_p2p_enable, int, 0);
-MODULE_PARM_DESC(p2pon, "enable legacy p2p management functionality");
-
 char *brcmf_ifname(struct brcmf_if *ifp)
 {
 	if (!ifp)
@@ -827,7 +817,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 		}
 	}
 
-	if (!brcmf_p2p_enable && is_p2pdev) {
+	if (!drvr->settings->p2p_enable && is_p2pdev) {
 		/* this is P2P_DEVICE interface */
 		brcmf_dbg(INFO, "allocate non-netdev interface\n");
 		ifp = kzalloc(sizeof(*ifp), GFP_KERNEL);
@@ -1058,6 +1048,10 @@ int brcmf_attach(struct device *dev)
 	drvr->bus_if = dev_get_drvdata(dev);
 	drvr->bus_if->drvr = drvr;
 
+	/* Initialize device specific settings */
+	if (brcmf_mp_device_attach(drvr))
+		goto fail;
+
 	/* attach debug facilities */
 	brcmf_debug_attach(drvr);
 
@@ -1150,7 +1144,7 @@ int brcmf_bus_start(struct device *dev)
 	brcmf_fws_add_interface(ifp);
 
 	drvr->config = brcmf_cfg80211_attach(drvr, bus_if->dev,
-					     brcmf_p2p_enable);
+					     drvr->settings->p2p_enable);
 	if (drvr->config == NULL) {
 		ret = -ENOMEM;
 		goto fail;
@@ -1158,7 +1152,7 @@ int brcmf_bus_start(struct device *dev)
 
 	ret = brcmf_net_attach(ifp, false);
 
-	if ((!ret) && (brcmf_p2p_enable)) {
+	if ((!ret) && (drvr->settings->p2p_enable)) {
 		p2p_ifp = drvr->iflist[1];
 		if (p2p_ifp)
 			ret = brcmf_net_p2p_attach(p2p_ifp);
@@ -1260,6 +1254,8 @@ void brcmf_detach(struct device *dev)
 
 	brcmf_proto_detach(drvr);
 
+	brcmf_mp_device_detach(drvr);
+
 	brcmf_debug_detach(drvr);
 	bus_if->drvr = NULL;
 	kfree(drvr);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 6018af7..8f39435 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -69,8 +69,8 @@ struct brcmf_ampdu_rx_reorder {
 
 /* Forward decls for struct brcmf_pub (see below) */
 struct brcmf_proto;	/* device communication protocol info */
-struct brcmf_cfg80211_dev; /* cfg80211 device info */
-struct brcmf_fws_info; /* firmware signalling info */
+struct brcmf_fws_info;	/* firmware signalling info */
+struct brcmf_mp_device;	/* module paramateres, device specific */
 
 /*
  * struct brcmf_rev_info
@@ -143,6 +143,7 @@ struct brcmf_pub {
 #endif
 
 	struct notifier_block inetaddr_notifier;
+	struct brcmf_mp_device *settings;
 };
 
 /* forward declarations */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index d41f343..1ffa95f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -25,13 +25,9 @@
 #include "fwil.h"
 #include "fwil_types.h"
 #include "feature.h"
+#include "common.h"
 
 
-/* Module param feature_disable (global for all devices) */
-static int brcmf_feature_disable;
-module_param_named(feature_disable, brcmf_feature_disable, int, 0);
-MODULE_PARM_DESC(feature_disable, "Disable features");
-
 /*
  * expand feature list to array of feature strings.
  */
@@ -159,10 +155,11 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	if (!err)
 		ifp->drvr->feat_flags |= BIT(BRCMF_FEAT_SCAN_RANDOM_MAC);
 
-	if (brcmf_feature_disable) {
+	if (drvr->settings->feature_disable) {
 		brcmf_dbg(INFO, "Features: 0x%02x, disable: 0x%02x\n",
-			  ifp->drvr->feat_flags, brcmf_feature_disable);
-		ifp->drvr->feat_flags &= ~brcmf_feature_disable;
+			  ifp->drvr->feat_flags,
+			  drvr->settings->feature_disable);
+		ifp->drvr->feat_flags &= ~drvr->settings->feature_disable;
 	}
 
 	/* set chip related quirks */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 1e4d5f6..1365c12 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -23,15 +23,13 @@
 
 #include "debug.h"
 #include "firmware.h"
+#include "core.h"
+#include "common.h"
 
 #define BRCMF_FW_MAX_NVRAM_SIZE			64000
 #define BRCMF_FW_NVRAM_DEVPATH_LEN		19	/* devpath0=pcie/1/4/ */
 #define BRCMF_FW_NVRAM_PCIEDEV_LEN		10	/* pcie/1/4/ + \0 */
 
-static char brcmf_firmware_path[BRCMF_FW_NAME_LEN];
-module_param_string(alternative_fw_path, brcmf_firmware_path,
-		    BRCMF_FW_NAME_LEN, 0440);
-
 enum nvram_parser_state {
 	IDLE,
 	KEY,
@@ -559,13 +557,15 @@ int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
 	}
 
 	/* check if firmware path is provided by module parameter */
-	if (brcmf_firmware_path[0] != '\0') {
-		strlcpy(fw_name, brcmf_firmware_path, BRCMF_FW_NAME_LEN);
+	if (brcmf_mp_global.firmware_path[0] != '\0') {
+		strlcpy(fw_name, brcmf_mp_global.firmware_path,
+			BRCMF_FW_NAME_LEN);
 		if ((nvram_name) && (mapping_table[i].nvram))
-			strlcpy(nvram_name, brcmf_firmware_path,
+			strlcpy(nvram_name, brcmf_mp_global.firmware_path,
 				BRCMF_FW_NAME_LEN);
 
-		end = brcmf_firmware_path[strlen(brcmf_firmware_path) - 1];
+		end = brcmf_mp_global.firmware_path[
+				strlen(brcmf_mp_global.firmware_path) - 1];
 		if (end != '/') {
 			strlcat(fw_name, "/", BRCMF_FW_NAME_LEN);
 			if ((nvram_name) && (mapping_table[i].nvram))
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index e5f5fac..f82c9ab 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -36,6 +36,7 @@
 #include "p2p.h"
 #include "cfg80211.h"
 #include "proto.h"
+#include "common.h"
 
 /**
  * DOC: Firmware Signalling
@@ -521,10 +522,6 @@ static const int brcmf_fws_prio2fifo[] = {
 	BRCMF_FWS_FIFO_AC_VO
 };
 
-static int fcmode;
-module_param(fcmode, int, S_IRUSR);
-MODULE_PARM_DESC(fcmode, "mode of firmware signalled flow control");
-
 #define BRCMF_FWS_TLV_DEF(name, id, len) \
 	case BRCMF_FWS_TYPE_ ## name: \
 		return len;
@@ -2134,10 +2131,10 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 
 	/* set linkage back */
 	fws->drvr = drvr;
-	fws->fcmode = fcmode;
+	fws->fcmode = drvr->settings->fcmode;
 
 	if ((drvr->bus_if->always_use_fws_queue == false) &&
-	    (fcmode == BRCMF_FWS_FCMODE_NONE)) {
+	    (fws->fcmode == BRCMF_FWS_FCMODE_NONE)) {
 		fws->avoid_queueing = true;
 		brcmf_dbg(INFO, "FWS queueing will be avoided\n");
 		return 0;
-- 
1.9.1

