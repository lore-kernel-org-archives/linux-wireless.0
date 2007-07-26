Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22848 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756867AbXGZD3E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 23:29:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] iwlwifi: rxon filter_flags endianity fix
Date: Thu, 26 Jul 2007 11:26:45 +0800
Message-Id: <11854204121057-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11854204113166-git-send-email-yi.zhu@intel.com>
References: <11854204053593-git-send-email-yi.zhu@intel.com>
 <11854204073964-git-send-email-yi.zhu@intel.com>
 <118542040911-git-send-email-yi.zhu@intel.com>
 <11854204113166-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endianty issues in rxon.filter_flags.
It also discards usage of iwl_check_bits in some cases.
The result is the same but the semantic is not.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |   12 +++----
 drivers/net/wireless/iwl-hw.h   |   74 ++++++++++++++++++--------------------
 2 files changed, 40 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 82470f1..3d19a1a 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -984,15 +984,13 @@ static int iwl_full_rxon_required(struct iwl_priv *priv)
 	 * flag transitions are allowed using RXON_ASSOC */
 
 	/* Check if we are not switching bands */
-	if (iwl_check_bits(priv->staging_rxon.flags, RXON_FLG_BAND_24G_MSK) !=
-	    iwl_check_bits(priv->active_rxon.flags, RXON_FLG_BAND_24G_MSK))
+	if ((priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) !=
+	    (priv->active_rxon.flags & RXON_FLG_BAND_24G_MSK))
 		return 1;
 
 	/* Check if we are switching association toggle */
-	if (iwl_check_bits(priv->staging_rxon.filter_flags,
-			   RXON_FILTER_ASSOC_MSK) !=
-	    iwl_check_bits(priv->active_rxon.filter_flags,
-			   RXON_FILTER_ASSOC_MSK))
+	if ((priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) !=
+		(priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK))
 		return 1;
 
 	return 0;
@@ -1154,7 +1152,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 		       "* bssid = " MAC_FMT "\n",
 		       ((priv->staging_rxon.filter_flags &
 			 RXON_FILTER_ASSOC_MSK) ? "" : "out"),
-		       priv->staging_rxon.channel,
+		       le16_to_cpu(priv->staging_rxon.channel),
 		       MAC_ARG(priv->staging_rxon.bssid_addr));
 
 	/* Apply the new configuration */
diff --git a/drivers/net/wireless/iwl-hw.h b/drivers/net/wireless/iwl-hw.h
index 3f7e5bd..58afbf7 100644
--- a/drivers/net/wireless/iwl-hw.h
+++ b/drivers/net/wireless/iwl-hw.h
@@ -193,47 +193,43 @@ enum {
 };
 
 /* rx_config flags */
-enum {
-	/* band & modulation selection */
-	RXON_FLG_BAND_24G_MSK = (1 << 0),
-	RXON_FLG_CCK_MSK = (1 << 1),
-	/* auto detection enable */
-	RXON_FLG_AUTO_DETECT_MSK = (1 << 2),
-	/* TGg protection when tx */
-	RXON_FLG_TGG_PROTECT_MSK = (1 << 3),
-	/* cck short slot & preamble */
-	RXON_FLG_SHORT_SLOT_MSK = (1 << 4),
-	RXON_FLG_SHORT_PREAMBLE_MSK = (1 << 5),
-	/* antenna selection */
-	RXON_FLG_DIS_DIV_MSK = (1 << 7),
-	RXON_FLG_ANT_SEL_MSK = 0x0f00,
-	RXON_FLG_ANT_A_MSK = (1 << 8),
-	RXON_FLG_ANT_B_MSK = (1 << 9),
-	/* radar detection enable */
-	RXON_FLG_RADAR_DETECT_MSK = (1 << 12),
-	RXON_FLG_TGJ_NARROW_BAND_MSK = (1 << 13),
-	/* rx response to host with 8-byte TSF
-	 * (according to ON_AIR deassertion) */
-	RXON_FLG_TSF2HOST_MSK = (1 << 15)
-};
+/* band & modulation selection */
+#define RXON_FLG_BAND_24G_MSK           __constant_cpu_to_le32(1 << 0)
+#define RXON_FLG_CCK_MSK                __constant_cpu_to_le32(1 << 1)
+/* auto detection enable */
+#define RXON_FLG_AUTO_DETECT_MSK        __constant_cpu_to_le32(1 << 2)
+/* TGg protection when tx */
+#define RXON_FLG_TGG_PROTECT_MSK        __constant_cpu_to_le32(1 << 3)
+/* cck short slot & preamble */
+#define RXON_FLG_SHORT_SLOT_MSK          __constant_cpu_to_le32(1 << 4)
+#define RXON_FLG_SHORT_PREAMBLE_MSK     __constant_cpu_to_le32(1 << 5)
+/* antenna selection */
+#define RXON_FLG_DIS_DIV_MSK            __constant_cpu_to_le32(1 << 7)
+#define RXON_FLG_ANT_SEL_MSK            __constant_cpu_to_le32(0x0f00)
+#define RXON_FLG_ANT_A_MSK              __constant_cpu_to_le32(1 << 8)
+#define RXON_FLG_ANT_B_MSK              __constant_cpu_to_le32(1 << 9)
+/* radar detection enable */
+#define RXON_FLG_RADAR_DETECT_MSK       __constant_cpu_to_le32(1 << 12)
+#define RXON_FLG_TGJ_NARROW_BAND_MSK    __constant_cpu_to_le32(1 << 13)
+/* rx response to host with 8-byte TSF
+* (according to ON_AIR deassertion) */
+#define RXON_FLG_TSF2HOST_MSK           __constant_cpu_to_le32(1 << 15)
 
 /* rx_config filter flags */
-enum {
-	/* accept all data frames */
-	RXON_FILTER_PROMISC_MSK = (1 << 0),
-	/* pass control & management to host */
-	RXON_FILTER_CTL2HOST_MSK = (1 << 1),
-	/* accept multi-cast */
-	RXON_FILTER_ACCEPT_GRP_MSK = (1 << 2),
-	/* don't decrypt uni-cast frames */
-	RXON_FILTER_DIS_DECRYPT_MSK = (1 << 3),
-	/* don't decrypt multi-cast frames */
-	RXON_FILTER_DIS_GRP_DECRYPT_MSK = (1 << 4),
-	/* STA is associated */
-	RXON_FILTER_ASSOC_MSK = (1 << 5),
-	/* transfer to host non bssid beacons in associated state */
-	RXON_FILTER_BCON_AWARE_MSK = (1 << 6)
-};
+/* accept all data frames */
+#define RXON_FILTER_PROMISC_MSK         __constant_cpu_to_le32(1 << 0)
+/* pass control & management to host */
+#define RXON_FILTER_CTL2HOST_MSK        __constant_cpu_to_le32(1 << 1)
+/* accept multi-cast */
+#define RXON_FILTER_ACCEPT_GRP_MSK      __constant_cpu_to_le32(1 << 2)
+/* don't decrypt uni-cast frames */
+#define RXON_FILTER_DIS_DECRYPT_MSK     __constant_cpu_to_le32(1 << 3)
+/* don't decrypt multi-cast frames */
+#define RXON_FILTER_DIS_GRP_DECRYPT_MSK __constant_cpu_to_le32(1 << 4)
+/* STA is associated */
+#define RXON_FILTER_ASSOC_MSK           __constant_cpu_to_le32(1 << 5)
+/* transfer to host non bssid beacons in associated state */
+#define RXON_FILTER_BCON_AWARE_MSK      __constant_cpu_to_le32(1 << 6)
 
 /*
  * RXON-Timings Command & Response
-- 
1.5.2
