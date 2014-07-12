Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:13133 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaGLGtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:49:46 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/9] brcmfmac: introduce feature and quirk handling
Date: Sat, 12 Jul 2014 08:49:39 +0200
Message-ID: <1405147782-12768-7-git-send-email-arend@broadcom.com> (sfid-20140712_085003_037283_ECE2834C)
In-Reply-To: <1405147782-12768-1-git-send-email-arend@broadcom.com>
References: <1405147782-12768-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introducing a new source module that will be responsible for
identifying features and quirks related to the device being
handled.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |   1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   5 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  13 +-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  | 137 +++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/feature.h  |  87 +++++++++++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  30 +++--
 6 files changed, 246 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/feature.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/feature.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 4cffb2e..de0cff3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -34,6 +34,7 @@ brcmfmac-objs += \
 		dhd_common.o \
 		dhd_linux.o \
 		firmware.o \
+		feature.o \
 		btcoex.o \
 		vendor.o
 brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index a8998eb..7da6441 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -103,6 +103,10 @@ struct brcmf_pub {
 
 	struct brcmf_ampdu_rx_reorder
 		*reorder_flows[BRCMF_AMPDU_RX_REORDER_MAXFLOWS];
+
+	u32 feat_flags;
+	u32 chip_quirks;
+
 #ifdef DEBUG
 	struct dentry *dbgfs_dir;
 #endif
@@ -175,7 +179,6 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
-u32 brcmf_get_chip_info(struct brcmf_if *ifp);
 void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp, u8 ifidx,
 		      bool success);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 09dd8c1..bf44808 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -30,6 +30,7 @@
 #include "wl_cfg80211.h"
 #include "fwil.h"
 #include "fwsignal.h"
+#include "feature.h"
 #include "proto.h"
 
 MODULE_AUTHOR("Broadcom Corporation");
@@ -936,6 +937,8 @@ int brcmf_bus_start(struct device *dev)
 	if (ret < 0)
 		goto fail;
 
+	brcmf_feat_attach(drvr);
+
 	ret = brcmf_fws_init(drvr);
 	if (ret < 0)
 		goto fail;
@@ -1073,16 +1076,6 @@ int brcmf_netdev_wait_pend8021x(struct net_device *ndev)
 	return !err;
 }
 
-/*
- * return chip id and rev of the device encoded in u32.
- */
-u32 brcmf_get_chip_info(struct brcmf_if *ifp)
-{
-	struct brcmf_bus *bus = ifp->drvr->bus_if;
-
-	return bus->chip << 4 | bus->chiprev;
-}
-
 static void brcmf_driver_register(struct work_struct *work)
 {
 #ifdef CONFIG_BRCMFMAC_SDIO
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
new file mode 100644
index 0000000..482cf0a
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -0,0 +1,137 @@
+/*
+ * Copyright (c) 2014 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/netdevice.h>
+
+#include <brcm_hw_ids.h>
+#include "dhd.h"
+#include "dhd_bus.h"
+#include "dhd_dbg.h"
+#include "fwil.h"
+#include "feature.h"
+
+/*
+ * firmware error code received if iovar is unsupported.
+ */
+#define EBRCMF_FEAT_UNSUPPORTED		23
+
+/*
+ * expand feature list to array of feature strings.
+ */
+#define BRCMF_FEAT_DEF(_f) \
+	#_f,
+static const char *brcmf_feat_names[] = {
+	BRCMF_FEAT_LIST
+};
+#undef BRCMF_FEAT_DEF
+
+#ifdef DEBUG
+/*
+ * expand quirk list to array of quirk strings.
+ */
+#define BRCMF_QUIRK_DEF(_q) \
+	#_q,
+static const char * const brcmf_quirk_names[] = {
+	BRCMF_QUIRK_LIST
+};
+#undef BRCMF_QUIRK_DEF
+
+/**
+ * brcmf_feat_debugfs_read() - expose feature info to debugfs.
+ *
+ * @seq: sequence for debugfs entry.
+ * @data: raw data pointer.
+ */
+static int brcmf_feat_debugfs_read(struct seq_file *seq, void *data)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(seq->private);
+	u32 feats = bus_if->drvr->feat_flags;
+	u32 quirks = bus_if->drvr->chip_quirks;
+	int id;
+
+	seq_printf(seq, "Features: %08x\n", feats);
+	for (id = 0; id < BRCMF_FEAT_LAST; id++)
+		if (feats & BIT(id))
+			seq_printf(seq, "\t%s\n", brcmf_feat_names[id]);
+	seq_printf(seq, "\nQuirks:   %08x\n", quirks);
+	for (id = 0; id < BRCMF_FEAT_QUIRK_LAST; id++)
+		if (quirks & BIT(id))
+			seq_printf(seq, "\t%s\n", brcmf_quirk_names[id]);
+	return 0;
+}
+#else
+static int brcmf_feat_debugfs_read(struct seq_file *seq, void *data)
+{
+	return 0;
+}
+#endif /* DEBUG */
+
+/**
+ * brcmf_feat_iovar_int_get() - determine feature through iovar query.
+ *
+ * @ifp: interface to query.
+ * @id: feature id.
+ * @name: iovar name.
+ */
+static void brcmf_feat_iovar_int_get(struct brcmf_if *ifp,
+				     enum brcmf_feat_id id, char *name)
+{
+	u32 data;
+	int err;
+
+	err = brcmf_fil_iovar_int_get(ifp, name, &data);
+	if (err == 0) {
+		brcmf_dbg(INFO, "enabling feature: %s\n", brcmf_feat_names[id]);
+		ifp->drvr->feat_flags |= BIT(id);
+	} else {
+		brcmf_dbg(TRACE, "%s feature check failed: %d\n",
+			  brcmf_feat_names[id], err);
+	}
+}
+
+void brcmf_feat_attach(struct brcmf_pub *drvr)
+{
+	struct brcmf_if *ifp = drvr->iflist[0];
+
+	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_MCHAN, "mchan");
+
+	/* set chip related quirks */
+	switch (drvr->bus_if->chip) {
+	case BRCM_CC_43236_CHIP_ID:
+		drvr->chip_quirks |= BIT(BRCMF_FEAT_QUIRK_AUTO_AUTH);
+		break;
+	case BRCM_CC_4329_CHIP_ID:
+		drvr->chip_quirks |= BIT(BRCMF_FEAT_QUIRK_NEED_MPC);
+		break;
+	default:
+		/* no quirks */
+		break;
+	}
+
+	brcmf_debugfs_add_entry(drvr, "features", brcmf_feat_debugfs_read);
+}
+
+bool brcmf_feat_is_enabled(struct brcmf_if *ifp, enum brcmf_feat_id id)
+{
+	return (ifp->drvr->feat_flags & BIT(id));
+}
+
+bool brcmf_feat_is_quirk_enabled(struct brcmf_if *ifp,
+				 enum brcmf_feat_quirk quirk)
+{
+	return (ifp->drvr->chip_quirks & BIT(quirk));
+}
+
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
new file mode 100644
index 0000000..dc8270b
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright (c) 2014 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef _BRCMF_FEATURE_H
+#define _BRCMF_FEATURE_H
+
+/*
+ * Features:
+ *
+ * MCHAN: multi-channel for concurrent P2P.
+ */
+#define BRCMF_FEAT_LIST \
+	BRCMF_FEAT_DEF(MCHAN)
+/*
+ * Quirks:
+ *
+ * AUTO_AUTH: workaround needed for automatic authentication type.
+ * NEED_MPC: driver needs to disable MPC during scanning operation.
+ */
+#define BRCMF_QUIRK_LIST \
+	BRCMF_QUIRK_DEF(AUTO_AUTH) \
+	BRCMF_QUIRK_DEF(NEED_MPC)
+
+#define BRCMF_FEAT_DEF(_f) \
+	BRCMF_FEAT_ ## _f,
+/*
+ * expand feature list to enumeration.
+ */
+enum brcmf_feat_id {
+	BRCMF_FEAT_LIST
+	BRCMF_FEAT_LAST
+};
+#undef BRCMF_FEAT_DEF
+
+#define BRCMF_QUIRK_DEF(_q) \
+	BRCMF_FEAT_QUIRK_ ## _q,
+/*
+ * expand quirk list to enumeration.
+ */
+enum brcmf_feat_quirk {
+	BRCMF_QUIRK_LIST
+	BRCMF_FEAT_QUIRK_LAST
+};
+#undef BRCMF_QUIRK_DEF
+
+/**
+ * brcmf_feat_attach() - determine features and quirks.
+ *
+ * @drvr: driver instance.
+ */
+void brcmf_feat_attach(struct brcmf_pub *drvr);
+
+/**
+ * brcmf_feat_is_enabled() - query feature.
+ *
+ * @ifp: interface instance.
+ * @id: feature id to check.
+ *
+ * Return: true is feature is enabled; otherwise false.
+ */
+bool brcmf_feat_is_enabled(struct brcmf_if *ifp, enum brcmf_feat_id id);
+
+/**
+ * brcmf_feat_is_quirk_enabled() - query chip quirk.
+ *
+ * @ifp: interface instance.
+ * @quirk: quirk id to check.
+ *
+ * Return: true is quirk is enabled; otherwise false.
+ */
+bool brcmf_feat_is_quirk_enabled(struct brcmf_if *ifp,
+				 enum brcmf_feat_quirk quirk);
+
+#endif /* _BRCMF_FEATURE_H */
+
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index af846d5..c1695cf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -33,6 +33,7 @@
 #include "p2p.h"
 #include "btcoex.h"
 #include "wl_cfg80211.h"
+#include "feature.h"
 #include "fwil.h"
 #include "vendor.h"
 
@@ -592,7 +593,7 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 
 static void brcmf_scan_config_mpc(struct brcmf_if *ifp, int mpc)
 {
-	if ((brcmf_get_chip_info(ifp) >> 4) == 0x4329)
+	if (brcmf_feat_is_quirk_enabled(ifp, BRCMF_FEAT_QUIRK_NEED_MPC))
 		brcmf_set_mpc(ifp, mpc);
 }
 
@@ -1619,17 +1620,10 @@ static
 enum nl80211_auth_type brcmf_war_auth_type(struct brcmf_if *ifp,
 					   enum nl80211_auth_type type)
 {
-	u32 ci;
-	if (type == NL80211_AUTHTYPE_AUTOMATIC) {
-		/* shift to ignore chip revision */
-		ci = brcmf_get_chip_info(ifp) >> 4;
-		switch (ci) {
-		case 43236:
-			brcmf_dbg(CONN, "43236 WAR: use OPEN instead of AUTO\n");
-			return NL80211_AUTHTYPE_OPEN_SYSTEM;
-		default:
-			break;
-		}
+	if (type == NL80211_AUTHTYPE_AUTOMATIC &&
+	    brcmf_feat_is_quirk_enabled(ifp, BRCMF_FEAT_QUIRK_AUTO_AUTH)) {
+		brcmf_dbg(CONN, "WAR: use OPEN instead of AUTO\n");
+		type = NL80211_AUTHTYPE_OPEN_SYSTEM;
 	}
 	return type;
 }
@@ -4310,10 +4304,10 @@ static const struct ieee80211_iface_limit brcmf_iface_limits[] = {
 		.types = BIT(NL80211_IFTYPE_P2P_DEVICE)
 	}
 };
-static const struct ieee80211_iface_combination brcmf_iface_combos[] = {
+static struct ieee80211_iface_combination brcmf_iface_combos[] = {
 	{
 		 .max_interfaces = BRCMF_IFACE_MAX_CNT,
-		 .num_different_channels = 2,
+		 .num_different_channels = 1,
 		 .n_limits = ARRAY_SIZE(brcmf_iface_limits),
 		 .limits = brcmf_iface_limits
 	}
@@ -4348,7 +4342,8 @@ brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
 	}
 };
 
-static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
+static
+struct wiphy *brcmf_setup_wiphy(struct brcmf_if *ifp, struct device *phydev)
 {
 	struct wiphy *wiphy;
 	s32 err = 0;
@@ -4368,6 +4363,9 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				 BIT(NL80211_IFTYPE_P2P_GO) |
 				 BIT(NL80211_IFTYPE_P2P_DEVICE);
+	/* need VSDB firmware feature for concurrent channels */
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MCHAN))
+		brcmf_iface_combos[0].num_different_channels = 2;
 	wiphy->iface_combinations = brcmf_iface_combos;
 	wiphy->n_iface_combinations = ARRAY_SIZE(brcmf_iface_combos);
 	wiphy->bands[IEEE80211_BAND_2GHZ] = &__wl_band_2ghz;
@@ -5567,7 +5565,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	}
 
 	ifp = netdev_priv(ndev);
-	wiphy = brcmf_setup_wiphy(busdev);
+	wiphy = brcmf_setup_wiphy(ifp, busdev);
 	if (IS_ERR(wiphy))
 		return NULL;
 
-- 
1.9.1

