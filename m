Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDC344C51D
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754894; cv=none; b=hMthpGtVoS0Ommx7iMoKIeSpyFRhwt6Cyx8V6R9xiiLZx9Qnst3jU4U/8qyBlqY7NwztF7YMzcTwr4eE0+db9ygCC0X5WzvpfqkOLeHoDG5lkXd88VQOQU1Q4gu5kf7eTZjPCOBaxxZsZVNj3ZSKjFfkk93JmPo/3luNHk2Ln3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754894; c=relaxed/simple;
	bh=0DIVIPCkBwRMeJtWrJZDKgTrcPOZzZgrP30VHt60TPA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=njtHvOuVYMu1gfIJ/wRoXfdxcrPNv7iM6cQks+9fcUNBXnBL3bE7sBdMf71yFFavPjtKF9yo2QhI0u7WhNuRkxFKirXWXca1WA9ewPtG2k29r3dVzPnoZQ65xRLQue433tMwmkVTKx81lLT/qSuIXQHKO0nJubBtYM7eu3oZR1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cACz1krA; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cACz1krA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754893; x=1822290893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0DIVIPCkBwRMeJtWrJZDKgTrcPOZzZgrP30VHt60TPA=;
  b=cACz1krARnqRJPqda9O4TrpWP6J3Jykag+dHSGK50toA+BEMI3RZ57nJ
   OPZqZRhMfA6NhlGcmAQlPPOkqk6IueluCdBjqL0gm5BkrvNPrhPE2Z+ym
   p/oAY8qPduSOBR044l4dLk613hZKO3fxlkrVeBCAlSN+gDB2BsPt6GFyG
   76h+q5Q9OxIekNyvtMT31bCD8ZXXfkt9ea6tYO26E+EWft3NR7If/KliC
   4hjrQ6BMk/AUDiWHgFmhDhGo50u9pHIoprz3f9NX8GqmoXMqhxePwNIZp
   OMIvAkqIMCWoAqXhJHTHwjJ1l4CPB/wewBIEDk0om8qj6/cawEWIkJHlP
   g==;
X-CSE-ConnectionGUID: 4ZLgxoL6T0Gc6mqLl6iSKg==
X-CSE-MsgGUID: ZjwtFXe+S7mDO7LmXidP3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296819"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296819"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:54:53 -0700
X-CSE-ConnectionGUID: PoR/gI4dSgSxTcOTLMH5mw==
X-CSE-MsgGUID: hZOBIHd3QCqLjMRyCex+jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278962919"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:54:51 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Daniel Gabay <daniel.gabay@intel.com>
Subject: [PATCH iwlwifi-next 04/15] wifi: iwlwifi: mld: add gp2 timestamps to TX commands
Date: Wed, 30 Sep 2026 10:56:32 +0300
Message-Id: <20260930104824.94a96ed7899a.Ie4d4af8d7100a656a8469edc0c38ec81b0b58860@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
References: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Daniel Gabay <daniel.gabay@intel.com>

TX command v12 adds a driver timestamp in the gp2 clock domain.
Firmware uses it to age out frames deferred by CCA for more than
four seconds. Without it, a blocked queue can stall until the
datapath monitor fires LMAC assert 0x4433.

Reading the gp2 register per frame is too expensive for the TX path.
Instead, use a worker to measure its offset from host boottime and
publish the offset and validity deadline using atomic stores. TX
then estimates gp2 without allocation or locking for timestamp reads.

TX requests a refresh after five seconds, while the estimate remains
valid for ten seconds to tolerate worker delays and bound clock drift.
Successful refreshes require no periodic work while traffic is idle.
A failed read invalidates the estimate and schedules a retry after
roughly one second, rounded for timer coalescing, even without traffic.

Invalidate the estimate before D3 entry and firmware shutdown, and
refresh it on resume or reload because gp2 restarts with firmware.
Frames without a valid estimate carry a zero timestamp, which firmware
ignores.

Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Assisted-by: LLM
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/tx.h    |  11 +-
 .../wireless/intel/iwlwifi/mld/constants.h    |   4 +
 drivers/net/wireless/intel/iwlwifi/mld/d3.c   |   5 +
 drivers/net/wireless/intel/iwlwifi/mld/fw.c   |   7 +-
 .../net/wireless/intel/iwlwifi/mld/mac80211.c |   2 +
 drivers/net/wireless/intel/iwlwifi/mld/mld.c  |  13 ++
 drivers/net/wireless/intel/iwlwifi/mld/mld.h  |   6 +
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c  |  12 +-
 drivers/net/wireless/intel/iwlwifi/mld/tx.c   | 130 ++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mld/tx.h   |  36 ++++-
 10 files changed, 209 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index 31d3336726b4..9d9eb320db7b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
 #ifndef __iwl_fw_api_tx_h__
@@ -292,6 +292,9 @@ struct iwl_tx_cmd_v9 {
  * @dram_info: FW internal DRAM storage
  * @rate_n_flags: rate for *all* Tx attempts, if TX_CMD_FLG_STA_RATE_MSK is
  *	cleared. Combination of RATE_MCS_*; format depends on version
+ * @driver_timestamp: gp2 time, in microseconds, assigned before queueing the
+ *	MPDU. Firmware uses it to detect frames blocked for too long.
+ *	Zero means no timestamp. Used from TX_CMD_API_S_VER_12.
  * @reserved: reserved
  * @hdr: 802.11 header
  */
@@ -301,10 +304,12 @@ struct iwl_tx_cmd {
 	__le32 offload_assist;
 	struct iwl_dram_sec_info dram_info;
 	__le32 rate_n_flags;
-	u8 reserved[8];
+	__le32 driver_timestamp;
+	u8 reserved[4];
 	struct ieee80211_hdr hdr[];
 } __packed; /* TX_CMD_API_S_VER_10,
-	     * TX_CMD_API_S_VER_11
+	     * TX_CMD_API_S_VER_11,
+	     * TX_CMD_API_S_VER_12
 	     */
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/constants.h b/drivers/net/wireless/intel/iwlwifi/mld/constants.h
index 890abcab3837..bfd5398510ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/constants.h
@@ -39,6 +39,10 @@
 
 #define IWL_MLD_TPT_COUNT_WINDOW (5 * HZ)
 
+#define IWL_MLD_TX_GP2_VALID_PERIOD	(10 * HZ)
+#define IWL_MLD_TX_GP2_REFRESH_MARGIN	(5 * HZ)
+#define IWL_MLD_TX_GP2_RETRY_PERIOD	HZ
+
 #define IWL_MLD_DIS_RANDOM_FW_ID                false
 #define IWL_MLD_D3_DEBUG                        false
 #define IWL_MLD_NON_TRANSMITTING_AP	        false
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index 55f9b809e764..b05abea72a66 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -5,6 +5,7 @@
 #include "mld.h"
 
 #include "d3.h"
+#include "tx.h"
 #include "power.h"
 #include "hcmd.h"
 #include "iface.h"
@@ -1608,6 +1609,8 @@ int iwl_mld_no_wowlan_suspend(struct iwl_mld *mld)
 
 	iwl_mld_low_latency_stop(mld);
 
+	iwl_mld_tx_gp2_stop(mld);
+
 	ret = iwl_mld_update_device_power(mld, true);
 	if (ret) {
 		IWL_ERR(mld,
@@ -1661,6 +1664,8 @@ int iwl_mld_no_wowlan_resume(struct iwl_mld *mld)
 
 	iwl_mld_low_latency_restart(mld);
 
+	iwl_mld_tx_gp2_start(mld);
+
 	return iwl_mld_update_device_power(mld, false);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/fw.c b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
index e5866d89176d..7891afd556a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
@@ -1,9 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 
 #include "mld.h"
+#include "tx.h"
 
 #include "fw/api/alive.h"
 #include "fw/api/scan.h"
@@ -355,6 +356,8 @@ void iwl_mld_stop_fw(struct iwl_mld *mld)
 {
 	lockdep_assert_wiphy(mld->wiphy);
 
+	iwl_mld_tx_gp2_stop(mld);
+
 	iwl_abort_notification_waits(&mld->notif_wait);
 
 	iwl_fw_dbg_stop_sync(&mld->fwrt);
@@ -542,6 +545,8 @@ int iwl_mld_start_fw(struct iwl_mld *mld)
 	if (ret)
 		goto error;
 
+	iwl_mld_tx_gp2_start(mld);
+
 	return 0;
 
 error:
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 0b121114d47c..e05bdbd3e1a9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2168,6 +2168,8 @@ static int iwl_mld_resume(struct ieee80211_hw *hw)
 
 	iwl_mld_low_latency_restart(mld);
 
+	iwl_mld_tx_gp2_start(mld);
+
 	return 0;
 }
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index b7b1e3686336..95d6f36b9fd9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -35,6 +35,17 @@ MODULE_IMPORT_NS("IWLWIFI");
 
 static const struct iwl_op_mode_ops iwl_mld_ops;
 
+int iwl_mld_get_systime(struct iwl_mld *mld, u32 *gp2)
+{
+	*gp2 = iwl_read_prph(mld->trans,
+			     mld->trans->mac_cfg->base->gp2_reg_addr);
+
+	if (*gp2 == 0x5a5a5a5a)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int __init iwl_mld_init(void)
 {
 	int ret = iwl_opmode_register("iwlmld", &iwl_mld_ops);
@@ -425,6 +436,8 @@ iwl_op_mode_mld_start(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 	/* Configure transport layer with the opmode specific params */
 	iwl_mld_configure_trans(op_mode);
 
+	iwl_mld_tx_gp2_init(mld);
+
 	/* needed for regulatory init */
 	rtnl_lock();
 	/* Needed for sending commands */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.h b/drivers/net/wireless/intel/iwlwifi/mld/mld.h
index 37f41b504b54..a9e65b216fd3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.h
@@ -29,6 +29,7 @@
 #include "notif.h"
 #include "scan.h"
 #include "rx.h"
+#include "tx.h"
 #include "thermal.h"
 #include "low_latency.h"
 #include "constants.h"
@@ -196,6 +197,7 @@
  *	being IBSS manager for that time and needing to respond to probe
  *	requests
  * @ptp_data: data of the PTP clock
+ * @tx_gp2: gp2 timestamping state for TX commands
  * @time_sync: time sync data.
  * @ftm_initiator: FTM initiator data
  * @nan_device_vif: points to the NAN device vif if exists
@@ -306,6 +308,8 @@ struct iwl_mld {
 
 	struct ptp_data ptp_data;
 
+	struct iwl_mld_tx_gp2 tx_gp2;
+
 	struct iwl_mld_time_sync_data __rcu *time_sync;
 
 	struct ftm_initiator_data ftm_initiator;
@@ -572,6 +576,8 @@ iwl_mld_fw_id_to_link_conf(struct iwl_mld *mld, u8 fw_link_id)
 
 #define MSEC_TO_TU(_msec)	((_msec) * 1000 / 1024)
 
+int iwl_mld_get_systime(struct iwl_mld *mld, u32 *gp2);
+
 void iwl_mld_add_vif_debugfs(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
 void iwl_mld_add_link_debugfs(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
index 1ac85d6ce1d7..9f7d17dbdee1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2025 Intel Corporation
+ * Copyright (C) 2025 - 2026 Intel Corporation
  */
 
 #include "mld.h"
@@ -19,16 +19,6 @@
 #define IWL_PTP_WRAP_TIME	(3600 * HZ)
 #define IWL_PTP_WRAP_THRESHOLD_USEC	(5000)
 
-static int iwl_mld_get_systime(struct iwl_mld *mld, u32 *gp2)
-{
-	*gp2 = iwl_read_prph(mld->trans, mld->trans->mac_cfg->base->gp2_reg_addr);
-
-	if (*gp2 == 0x5a5a5a5a)
-		return -EINVAL;
-
-	return 0;
-}
-
 static void iwl_mld_ptp_update_new_read(struct iwl_mld *mld, u32 gp2)
 {
 	IWL_DEBUG_PTP(mld, "PTP: last_gp2=%u, new gp2 read=%u\n",
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index 2df6643a5aa8..aac7d43bffd1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2024 - 2026 Intel Corporation
  */
+#include <linux/timekeeping.h>
 #include <net/ip.h>
 
 #include "tx.h"
@@ -20,6 +21,132 @@
 
 #define MAX_ANT_NUM 2
 
+static u32 iwl_mld_tx_gp2_host_us(void)
+{
+	return div_u64(ktime_get_boottime_ns(), NSEC_PER_USEC);
+}
+
+/* Returns the gp2 for the TX command, or 0 to leave the frame unstamped.
+ * Sets @refresh when the estimate expired or is about to.
+ */
+static u32
+iwl_mld_tx_gp2_from_est(u32 delta_us, unsigned long valid_until, u32 host_us,
+			unsigned long now, bool *refresh)
+{
+	u32 gp2;
+
+	*refresh = time_after_eq(now, valid_until -
+				 IWL_MLD_TX_GP2_REFRESH_MARGIN);
+
+	if (time_after_eq(now, valid_until))
+		return 0;
+
+	gp2 = host_us + delta_us;
+
+	/* 0 means no timestamp; use 1 for a valid wrapped value. */
+	return gp2 ?: 1;
+}
+
+static u32
+iwl_mld_tx_gp2_timestamp(struct iwl_mld *mld)
+{
+	unsigned long valid_until =
+		atomic_long_read_acquire(&mld->tx_gp2.valid_until);
+	bool refresh = false;
+	u32 gp2;
+
+	if (!valid_until)
+		return 0;
+
+	gp2 = iwl_mld_tx_gp2_from_est(atomic_read(&mld->tx_gp2.delta_us),
+				      valid_until, iwl_mld_tx_gp2_host_us(),
+				      jiffies, &refresh);
+
+	if (refresh)
+		wiphy_delayed_work_queue(mld->wiphy, &mld->tx_gp2.wk, 0);
+
+	return gp2;
+}
+
+static void iwl_mld_tx_gp2_refresh(struct iwl_mld *mld)
+{
+	unsigned long valid_until, delay;
+	u32 gp2, host_us;
+
+	lockdep_assert_wiphy(mld->wiphy);
+
+	if (!mld->fw_status.running)
+		return;
+
+#ifdef CONFIG_PM_SLEEP
+	if (mld->fw_status.in_d3)
+		return;
+#endif
+
+	if (iwl_mld_get_systime(mld, &gp2))
+		goto retry;
+
+	host_us = iwl_mld_tx_gp2_host_us();
+	valid_until = jiffies + IWL_MLD_TX_GP2_VALID_PERIOD;
+
+	/* Keep arithmetic in u32 to match firmware wraparound semantics. */
+	atomic_set(&mld->tx_gp2.delta_us, gp2 - host_us);
+	atomic_long_set_release(&mld->tx_gp2.valid_until, valid_until ?: 1);
+
+	IWL_DEBUG_TX(mld, "gp2 sync: gp2=%u host_us=%u delta_us=%u\n",
+		     gp2, host_us, gp2 - host_us);
+	return;
+
+retry:
+	/* Stop new TX readers from requesting immediate retries. */
+	atomic_long_set(&mld->tx_gp2.valid_until, 0);
+	delay = round_jiffies_relative(IWL_MLD_TX_GP2_RETRY_PERIOD);
+	wiphy_delayed_work_queue(mld->wiphy, &mld->tx_gp2.wk, delay);
+}
+
+static void iwl_mld_tx_gp2_wk(struct wiphy *wiphy, struct wiphy_work *wk)
+{
+	struct iwl_mld *mld = container_of(wk, struct iwl_mld, tx_gp2.wk.work);
+	unsigned long valid_until = atomic_long_read(&mld->tx_gp2.valid_until);
+
+	/* TX may have queued this work using an older estimate. */
+	if (valid_until &&
+	    time_before(jiffies, valid_until - IWL_MLD_TX_GP2_REFRESH_MARGIN))
+		return;
+
+	iwl_mld_tx_gp2_refresh(mld);
+}
+
+void iwl_mld_tx_gp2_init(struct iwl_mld *mld)
+{
+	atomic_set(&mld->tx_gp2.delta_us, 0);
+	atomic_long_set(&mld->tx_gp2.valid_until, 0);
+	wiphy_delayed_work_init(&mld->tx_gp2.wk, iwl_mld_tx_gp2_wk);
+}
+
+void iwl_mld_tx_gp2_start(struct iwl_mld *mld)
+{
+	lockdep_assert_wiphy(mld->wiphy);
+
+	if (iwl_fw_lookup_cmd_ver(mld->fw, TX_CMD, 0) < 12)
+		return;
+
+	iwl_mld_tx_gp2_refresh(mld);
+}
+
+/* TX is quiesced before stopping the refresh work. */
+void iwl_mld_tx_gp2_stop(struct iwl_mld *mld)
+{
+	lockdep_assert_wiphy(mld->wiphy);
+
+	if (iwl_fw_lookup_cmd_ver(mld->fw, TX_CMD, 0) < 12)
+		return;
+
+	wiphy_delayed_work_cancel(mld->wiphy, &mld->tx_gp2.wk);
+
+	atomic_long_set(&mld->tx_gp2.valid_until, 0);
+}
+
 /* Toggles between TX antennas. Receives the bitmask of valid TX antennas and
  * the *index* used for the last TX, and returns the next valid *index* to use.
  * In order to set it in the tx_cmd, must do BIT(idx).
@@ -588,6 +715,9 @@ iwl_mld_fill_tx_cmd(struct iwl_mld *mld, struct sk_buff *skb,
 	tx_cmd->flags = cpu_to_le16(flags);
 
 	tx_cmd->rate_n_flags = rate_n_flags;
+
+	tx_cmd->driver_timestamp =
+		cpu_to_le32(iwl_mld_tx_gp2_timestamp(mld));
 }
 
 /* Caller of this need to check that info->control.vif is not NULL */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.h b/drivers/net/wireless/intel/iwlwifi/mld/tx.h
index 520f15f9d33c..0a9a2e4abcab 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.h
@@ -1,11 +1,15 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2024 Intel Corporation
+ * Copyright (C) 2024, 2026 Intel Corporation
  */
 #ifndef __iwl_mld_tx_h__
 #define __iwl_mld_tx_h__
 
-#include "mld.h"
+#include <linux/atomic.h>
+#include <net/mac80211.h>
+
+struct iwl_mld;
+struct iwl_rx_packet;
 
 #define IWL_MLD_INVALID_QUEUE		0xFFFF
 #define IWL_MLD_INVALID_DROP_TX		0xFFFE
@@ -74,4 +78,32 @@ u8 iwl_mld_get_lowest_rate(struct iwl_mld *mld,
 void iwl_mld_tx_skb(struct iwl_mld *mld, struct sk_buff *skb,
 		    struct ieee80211_txq *txq);
 
+/**
+ * struct iwl_mld_tx_gp2 - gp2 timestamping state for TX commands
+ *
+ * Reading gp2 directly in the TX path is too costly. Instead, TX lazily
+ * schedules @wk to refresh gp2 in process context and adds @delta_us to the
+ * host clock to timestamp queued frames.
+ *
+ * A zero @valid_until leaves frames unstamped, including on older firmware
+ * without TX_CMD v12. A deadline that wraps to zero is published as one.
+ * Failed refreshes clear @valid_until, leaving @delta_us for old readers, and
+ * schedule a retry with %IWL_MLD_TX_GP2_RETRY_PERIOD rounded for timer
+ * coalescing, even without further TX traffic. Old readers may retry sooner.
+ *
+ * @delta_us: gp2 minus host time, in microseconds, modulo 2^32;
+ *	valid while @valid_until is nonzero and has not expired
+ * @valid_until: jiffies deadline for the offset, or zero when disabled
+ * @wk: worker that refreshes the offset and retries failures
+ */
+struct iwl_mld_tx_gp2 {
+	atomic_t delta_us;
+	atomic_long_t valid_until;
+	struct wiphy_delayed_work wk;
+};
+
+void iwl_mld_tx_gp2_init(struct iwl_mld *mld);
+void iwl_mld_tx_gp2_start(struct iwl_mld *mld);
+void iwl_mld_tx_gp2_stop(struct iwl_mld *mld);
+
 #endif /* __iwl_mld_tx_h__ */
-- 
2.34.1

