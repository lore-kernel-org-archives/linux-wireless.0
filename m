Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40334 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731898AbeG0CCL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jul 2018 22:02:11 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        kvalo@codeaurora.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 1/3] ath10k: Add ath10k-ct firmware feature flags and descriptions.
Date: Thu, 26 Jul 2018 17:42:43 -0700
Message-Id: <1532652165-27272-1-git-send-email-greearb@candelatech.com> (sfid-20180727_024257_377362_3E7EEEFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

These feature flags are used by ath10k-ct firmware.  Add these
so we can use them in future patches and so there are no warnings
about feature flags on loading ath10k-ct firmware.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

No significant changes since v2 (though I rebased against latest wireless-testing
and made sure it compiles.  Old patches were not found in patchwork,
so maybe they silently went away?

 drivers/net/wireless/ath/ath10k/core.c | 17 +++++++++
 drivers/net/wireless/ath/ath10k/core.h | 67 ++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 85c58eb..5e48e06 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -563,6 +563,23 @@ static const char *const ath10k_core_fw_feature_str[] = {
 	[ATH10K_FW_FEATURE_NO_PS] = "no-ps",
 	[ATH10K_FW_FEATURE_MGMT_TX_BY_REF] = "mgmt-tx-by-reference",
 	[ATH10K_FW_FEATURE_NON_BMI] = "non-bmi",
+	[ATH10K_FW_FEATURE_WMI_10X_CT] = "wmi-10.x-CT",
+	[ATH10K_FW_FEATURE_CT_RXSWCRYPT] = "rxswcrypt-CT",
+	[ATH10K_FW_FEATURE_HAS_TXSTATUS_NOACK] = "txstatus-noack",
+	[ATH10K_FW_FEATURE_CT_RATEMASK] = "ratemask-CT",
+	[ATH10K_FW_FEATURE_HAS_SAFE_BURST] = "safe-burst",
+	[ATH10K_FW_FEATURE_REGDUMP_CT] = "regdump-CT",
+	[ATH10K_FW_FEATURE_TXRATE_CT] = "txrate-CT",
+	[ATH10K_FW_FEATURE_FLUSH_ALL_CT] = "flush-all-CT",
+	[ATH10K_FW_FEATURE_PINGPONG_READ_CT] = "pingpong-CT",
+	[ATH10K_FW_FEATURE_SKIP_CH_RES_CT] = "ch-regs-CT",
+	[ATH10K_FW_FEATURE_NOP_CT] = "nop-CT",
+	[ATH10K_FW_FEATURE_HTT_MGT_CT] = "htt-mgt-CT",
+	[ATH10K_FW_FEATURE_SET_SPECIAL_CT] = "set-special-CT",
+	[ATH10K_FW_FEATURE_NO_BMISS_CT] = "no-bmiss-CT",
+	[ATH10K_FW_FEATURE_HAS_GET_TEMP_CT] = "get-temp-CT",
+	[ATH10K_FW_FEATURE_HAS_TX_RC_CT] = "tx-rc-CT",
+	[ATH10K_FW_FEATURE_CUST_STATS_CT] = "cust-stats-CT",
 };
 
 static unsigned int ath10k_core_get_fw_feature_str(char *buf,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 427ee57..e49b915 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -729,6 +729,73 @@ enum ath10k_fw_features {
 	/* Firmware load is done externally, not by bmi */
 	ATH10K_FW_FEATURE_NON_BMI = 19,
 
+	/* tx-status has the noack bits (CT firmware version 14 and higher ) */
+	ATH10K_FW_FEATURE_HAS_TXSTATUS_NOACK = 30,
+
+	/* Firmware from Candela Technologies, enables more VIFs, etc */
+	ATH10K_FW_FEATURE_WMI_10X_CT = 31,
+
+	/* Firmware from Candela Technologies with rx-software-crypt.
+	 * Required for multiple stations connected to same AP when using
+	 * encryption (ie, commercial version of CT firmware)
+	 */
+	ATH10K_FW_FEATURE_CT_RXSWCRYPT = 32,
+
+	/* Firmware supports extended wmi_common_peer_assoc_complete_cmd that
+	 * contains an array of rate-disable masks.  This allows the host to
+	 * have better control over what rates the firmware will use.  CT
+	 * Firmware only (v15 and higher)
+	 */
+	ATH10K_FW_FEATURE_CT_RATEMASK = 33,
+
+	/* Versions of firmware before approximately 10.2.4.72 would corrupt
+	 * txop fields during burst.  Since this is fixed now, add a flag to
+	 * denote this.
+	 */
+	ATH10K_FW_FEATURE_HAS_SAFE_BURST = 34,
+
+	/* Register-dump is supported. */
+	ATH10K_FW_FEATURE_REGDUMP_CT = 35,
+
+	/* TX-Rate is reported. */
+	ATH10K_FW_FEATURE_TXRATE_CT = 36,
+
+	/* Firmware can flush all peers. */
+	ATH10K_FW_FEATURE_FLUSH_ALL_CT = 37,
+
+	/* Firmware can read memory with ping-pong protocol. */
+	ATH10K_FW_FEATURE_PINGPONG_READ_CT = 38,
+
+	/* Firmware can skip channel reservation. */
+	ATH10K_FW_FEATURE_SKIP_CH_RES_CT = 39,
+
+	/* Firmware supports NOP keep-alive message. */
+	ATH10K_FW_FEATURE_NOP_CT = 40,
+
+	/* Firmware supports CT HTT MGT feature. */
+	ATH10K_FW_FEATURE_HTT_MGT_CT = 41,
+
+	/* Set-special cmd-id is supported. */
+	ATH10K_FW_FEATURE_SET_SPECIAL_CT = 42,
+
+	/* SW Beacon Miss is disabled in this kernel, so you have to
+	 * let mac80211 manage the connection.
+	 */
+	ATH10K_FW_FEATURE_NO_BMISS_CT = 43,
+
+	/* 10.1 firmware that supports getting temperature.  Stock
+	 * 10.1 cannot.
+	 */
+	ATH10K_FW_FEATURE_HAS_GET_TEMP_CT = 44,
+
+	/* Can peer-id be over-ridden to provide rix + retries for raw pkts?
+	 *  CT only option.
+	 */
+	ATH10K_FW_FEATURE_HAS_TX_RC_CT = 45,
+
+	/* Do we support requesting custom stats */
+	ATH10K_FW_FEATURE_CUST_STATS_CT = 46,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
-- 
2.4.11
