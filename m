Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54110 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954147AbdDYUXD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:03 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:19 +0300
Message-Id: <20170425202243.7844-2-luca@coelho.fi> (sfid-20170425_222322_215275_C5BA0636)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 01/25] iwlwifi: mvm: support new rate flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Rates were changed to adapt to HE. Change is backward compatible.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h | 28 +++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 11 ++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  4 ++--
 4 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
index ad9cc03e16c4..1b7d265ffb0a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -227,6 +229,9 @@ enum {
  */
 #define RATE_LEGACY_RATE_MSK 0xff
 
+/* Bit 10 - OFDM HE */
+#define RATE_MCS_OFDM_HE_POS		10
+#define RATE_MCS_OFDM_HE_MSK		BIT(RATE_MCS_OFDM_HE_POS)
 
 /*
  * Bit 11-12: (0) 20MHz, (1) 40MHz, (2) 80MHz, (3) 160MHz
@@ -255,18 +260,29 @@ enum {
 #define RATE_MCS_ANT_MSK		RATE_MCS_ANT_ABC_MSK
 #define RATE_MCS_ANT_NUM 3
 
-/* Bit 17-18: (0) SS, (1) SS*2 */
+/* Bit 17: (0) SS, (1) SS*2 */
 #define RATE_MCS_STBC_POS		17
-#define RATE_MCS_HT_STBC_MSK		(3 << RATE_MCS_STBC_POS)
-#define RATE_MCS_VHT_STBC_MSK		(1 << RATE_MCS_STBC_POS)
+#define RATE_MCS_STBC_MSK		BIT(RATE_MCS_STBC_POS)
+
+/* Bit 18: OFDM-HE dual carrier mode */
+#define RATE_HE_DUAL_CARRIER_MODE	18
+#define RATE_HE_DUAL_CARRIER_MODE_MSK	BIT(RATE_HE_DUAL_CARRIER_MODE)
 
 /* Bit 19: (0) Beamforming is off, (1) Beamforming is on */
 #define RATE_MCS_BF_POS			19
 #define RATE_MCS_BF_MSK			(1 << RATE_MCS_BF_POS)
 
-/* Bit 20: (0) ZLF is off, (1) ZLF is on */
-#define RATE_MCS_ZLF_POS		20
-#define RATE_MCS_ZLF_MSK		(1 << RATE_MCS_ZLF_POS)
+/*
+ * Bit 20-21: HE guard interval and LTF type.
+ * (0) 1xLTF+1.6us, (1) 2xLTF+0.8us,
+ * (2) 2xLTF+1.6us, (3) 4xLTF+3.2us
+ */
+#define RATE_MCS_HE_GI_LTF_POS		20
+#define RATE_MCS_HE_GI_LTF_MSK		(3 << RATE_MCS_HE_GI_LTF_POS)
+
+/* Bit 22-23: HE type. (0) SU, (1) SU_EXT, (2) MU, (3) trigger based */
+#define RATE_MCS_HE_TYPE_POS		22
+#define RATE_MCS_HE_TYPE_MSK		(3 << RATE_MCS_HE_TYPE_POS)
 
 /* Bit 24-25: (0) 20MHz (no dup), (1) 2x20MHz, (2) 4x20MHz, 3 8x20MHz */
 #define RATE_MCS_DUP_POS		24
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index ce907c58ebf6..7788eefcd2bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -826,7 +826,7 @@ static u32 ucode_rate_from_rs_rate(struct iwl_mvm *mvm,
 	if (is_siso(rate) && rate->stbc) {
 		/* To enable STBC we need to set both a flag and ANT_AB */
 		ucode_rate |= RATE_MCS_ANT_AB_MSK;
-		ucode_rate |= RATE_MCS_VHT_STBC_MSK;
+		ucode_rate |= RATE_MCS_STBC_MSK;
 	}
 
 	ucode_rate |= rate->bw;
@@ -873,7 +873,7 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 		rate->sgi = true;
 	if (ucode_rate & RATE_MCS_LDPC_MSK)
 		rate->ldpc = true;
-	if (ucode_rate & RATE_MCS_VHT_STBC_MSK)
+	if (ucode_rate & RATE_MCS_STBC_MSK)
 		rate->stbc = true;
 	if (ucode_rate & RATE_MCS_BF_MSK)
 		rate->bfer = true;
@@ -3641,13 +3641,12 @@ int rs_pretty_print_rate(char *buf, const u32 rate)
 		bw = "BAD BW";
 	}
 
-	return sprintf(buf, "%s | ANT: %s BW: %s MCS: %d NSS: %d %s%s%s%s%s\n",
+	return sprintf(buf, "%s | ANT: %s BW: %s MCS: %d NSS: %d %s%s%s%s\n",
 		       type, rs_pretty_ant(ant), bw, mcs, nss,
 		       (rate & RATE_MCS_SGI_MSK) ? "SGI " : "NGI ",
-		       (rate & RATE_MCS_HT_STBC_MSK) ? "STBC " : "",
+		       (rate & RATE_MCS_STBC_MSK) ? "STBC " : "",
 		       (rate & RATE_MCS_LDPC_MSK) ? "LDPC " : "",
-		       (rate & RATE_MCS_BF_MSK) ? "BF " : "",
-		       (rate & RATE_MCS_ZLF_MSK) ? "ZLF " : "");
+		       (rate & RATE_MCS_BF_MSK) ? "BF " : "");
 }
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index d4c0ca7ccb34..d7c8e7de960b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -443,13 +443,13 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	if (rate_n_flags & RATE_MCS_LDPC_MSK)
 		rx_status->flag |= RX_FLAG_LDPC;
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
-		u8 stbc = (rate_n_flags & RATE_MCS_HT_STBC_MSK) >>
+		u8 stbc = (rate_n_flags & RATE_MCS_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
 		rx_status->flag |= RX_FLAG_HT;
 		rx_status->rate_idx = rate_n_flags & RATE_HT_MCS_INDEX_MSK;
 		rx_status->flag |= stbc << RX_FLAG_STBC_SHIFT;
 	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
-		u8 stbc = (rate_n_flags & RATE_MCS_VHT_STBC_MSK) >>
+		u8 stbc = (rate_n_flags & RATE_MCS_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
 		rx_status->vht_nss =
 			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 24c4fbe139a3..362b240da65c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -974,13 +974,13 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	if (rate_n_flags & RATE_MCS_LDPC_MSK)
 		rx_status->flag |= RX_FLAG_LDPC;
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
-		u8 stbc = (rate_n_flags & RATE_MCS_HT_STBC_MSK) >>
+		u8 stbc = (rate_n_flags & RATE_MCS_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
 		rx_status->flag |= RX_FLAG_HT;
 		rx_status->rate_idx = rate_n_flags & RATE_HT_MCS_INDEX_MSK;
 		rx_status->flag |= stbc << RX_FLAG_STBC_SHIFT;
 	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
-		u8 stbc = (rate_n_flags & RATE_MCS_VHT_STBC_MSK) >>
+		u8 stbc = (rate_n_flags & RATE_MCS_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
 		rx_status->vht_nss =
 			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
-- 
2.11.0
