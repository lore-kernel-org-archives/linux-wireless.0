Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:51403 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbcABIlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 03:41:51 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 3/7] brcmfmac: Add support for scheduled scan mac randomization
Date: Sat, 2 Jan 2016 09:41:38 +0100
Message-ID: <1451724102-21911-4-git-send-email-arend@broadcom.com> (sfid-20160102_094229_575682_D5B5D204)
In-Reply-To: <1451724102-21911-1-git-send-email-arend@broadcom.com>
References: <1451724102-21911-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Scheduled scan be requested to use mac randomization. This patch
checks the flags and enables the randomization if desired.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
V2:
 - set nl80211 feature flags in wiphy object.
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 54 +++++++++++++++++++---
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 10 ++++
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 17 +++++++
 4 files changed, 77 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 6b9339b..05843b7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3544,9 +3544,14 @@ static int brcmf_dev_pno_clean(struct net_device *ndev)
 	return ret;
 }
 
-static int brcmf_dev_pno_config(struct net_device *ndev)
+static int brcmf_dev_pno_config(struct brcmf_if *ifp,
+				struct cfg80211_sched_scan_request *request)
 {
 	struct brcmf_pno_param_le pfn_param;
+	struct brcmf_pno_macaddr_le pfn_mac;
+	s32 err;
+	u8 *mac_mask;
+	int i;
 
 	memset(&pfn_param, 0, sizeof(pfn_param));
 	pfn_param.version = cpu_to_le32(BRCMF_PNO_VERSION);
@@ -3559,8 +3564,37 @@ static int brcmf_dev_pno_config(struct net_device *ndev)
 	/* set up pno scan fr */
 	pfn_param.scan_freq = cpu_to_le32(BRCMF_PNO_TIME);
 
-	return brcmf_fil_iovar_data_set(netdev_priv(ndev), "pfn_set",
-					&pfn_param, sizeof(pfn_param));
+	err = brcmf_fil_iovar_data_set(ifp, "pfn_set", &pfn_param,
+				       sizeof(pfn_param));
+	if (err) {
+		brcmf_err("pfn_set failed, err=%d\n", err);
+		return err;
+	}
+
+	/* Find out if mac randomization should be turned on */
+	if (!(request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR))
+		return 0;
+
+	pfn_mac.version = BRCMF_PFN_MACADDR_CFG_VER;
+	pfn_mac.flags = BRCMF_PFN_MAC_OUI_ONLY | BRCMF_PFN_SET_MAC_UNASSOC;
+
+	memcpy(pfn_mac.mac, request->mac_addr, ETH_ALEN);
+	mac_mask = request->mac_addr_mask;
+	for (i = 0; i < ETH_ALEN; i++) {
+		pfn_mac.mac[i] &= mac_mask[i];
+		pfn_mac.mac[i] |= get_random_int() & ~(mac_mask[i]);
+	}
+	/* Clear multi bit */
+	pfn_mac.mac[0] &= 0xFE;
+	/* Set locally administered */
+	pfn_mac.mac[0] |= 0x02;
+
+	err = brcmf_fil_iovar_data_set(ifp, "pfn_macaddr", &pfn_mac,
+				       sizeof(pfn_mac));
+	if (err)
+		brcmf_err("pfn_macaddr failed, err=%d\n", err);
+
+	return err;
 }
 
 static int
@@ -3614,11 +3648,8 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 		}
 
 		/* configure pno */
-		ret = brcmf_dev_pno_config(ndev);
-		if (ret < 0) {
-			brcmf_err("PNO setup failed!! ret=%d\n", ret);
+		if (brcmf_dev_pno_config(ifp, request))
 			return -EINVAL;
-		}
 
 		/* configure each match set */
 		for (i = 0; i < request->n_match_sets; i++) {
@@ -6455,6 +6486,15 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		goto wiphy_unreg_out;
 	}
 
+	/* Fill in some of the advertised nl80211 supported features */
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_SCAN_RANDOM_MAC)) {
+		wiphy->features |= NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR;
+#ifdef CONFIG_PM
+		if (wiphy->wowlan->flags & WIPHY_WOWLAN_NET_DETECT)
+			wiphy->features |= NL80211_FEATURE_ND_RANDOM_MAC_ADDR;
+#endif
+	}
+
 	return cfg;
 
 wiphy_unreg_out:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index d9d1ca4..e7ac8a2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -18,10 +18,12 @@
 #include <linux/module.h>
 
 #include <brcm_hw_ids.h>
+#include <brcmu_wifi.h>
 #include "core.h"
 #include "bus.h"
 #include "debug.h"
 #include "fwil.h"
+#include "fwil_types.h"
 #include "feature.h"
 
 
@@ -129,6 +131,8 @@ static void brcmf_feat_iovar_int_set(struct brcmf_if *ifp,
 void brcmf_feat_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
+	struct brcmf_pno_macaddr_le pfn_mac;
+	s32 err;
 
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_MCHAN, "mchan");
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
@@ -140,6 +144,12 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_RSDB, "rsdb_mode");
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_TDLS, "tdls_enable");
 
+	pfn_mac.version = BRCMF_PFN_MACADDR_CFG_VER;
+	err = brcmf_fil_iovar_data_get(ifp, "pfn_macaddr", &pfn_mac,
+				       sizeof(pfn_mac));
+	if (!err)
+		ifp->drvr->feat_flags |= BIT(BRCMF_FEAT_SCAN_RANDOM_MAC);
+
 	if (brcmf_feature_disable) {
 		brcmf_dbg(INFO, "Features: 0x%02x, disable: 0x%02x\n",
 			  ifp->drvr->feat_flags, brcmf_feature_disable);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 1390656..2e2479d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -26,6 +26,7 @@
  * P2P: peer-to-peer
  * RSDB: Real Simultaneous Dual Band
  * TDLS: Tunneled Direct Link Setup
+ * SCAN_RANDOM_MAC: Random MAC during (net detect) scheduled scan.
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
@@ -34,7 +35,8 @@
 	BRCMF_FEAT_DEF(WOWL) \
 	BRCMF_FEAT_DEF(P2P) \
 	BRCMF_FEAT_DEF(RSDB) \
-	BRCMF_FEAT_DEF(TDLS)
+	BRCMF_FEAT_DEF(TDLS) \
+	BRCMF_FEAT_DEF(SCAN_RANDOM_MAC)
 
 /*
  * Quirks:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 0b1e46d..bf2df49 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -128,6 +128,10 @@
 
 #define	BRCMF_MAXPMKID			16	/* max # PMKID cache entries */
 
+#define BRCMF_PFN_MACADDR_CFG_VER	1
+#define BRCMF_PFN_MAC_OUI_ONLY		BIT(0)
+#define BRCMF_PFN_SET_MAC_UNASSOC	BIT(1)
+
 /* join preference types for join_pref iovar */
 enum brcmf_join_pref_types {
 	BRCMF_JOIN_PREF_RSSI = 1,
@@ -752,6 +756,19 @@ struct brcmf_pno_scanresults_le {
 };
 
 /**
+ * struct brcmf_pno_macaddr_le - to configure PNO macaddr randomization.
+ *
+ * @version: PNO version identifier.
+ * @flags: Flags defining how mac addrss should be used.
+ * @mac: MAC address.
+ */
+struct brcmf_pno_macaddr_le {
+	u8 version;
+	u8 flags;
+	u8 mac[ETH_ALEN];
+};
+
+/**
  * struct brcmf_pktcnt_le - packet counters.
  *
  * @rx_good_pkt: packets (MSDUs & MMPDUs) received from this station
-- 
1.9.1

