Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56593 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbcG0IeS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 04:34:18 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Benjamin Berg <benjamin@sipsolutions.net>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Subject: [PATCH] ath10k: Allow setting coverage class
Date: Wed, 27 Jul 2016 10:33:44 +0200
Message-Id: <1469608424-11370-1-git-send-email-benjamin@sipsolutions.net> (sfid-20160727_103425_855676_C1BC84A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unfortunately ath10k does not generally allow modifying the coverage class
with the stock firmware and Qualcomm has so far refused to implement this
feature so that it can be properly supported in ath10k. If we however know
the registers that need to be modified for proper operation with a higher
coverage class, then we can do these modifications from the driver.

This patch implements this hack for first generation cards which are based
on a core that is similar to ath9k. The registers are modified in place and
need to be re-written every time the firmware sets them. To achieve this
the register status is verified after any event from the firmware.

The coverage class may not be modified temporarily right after the card
re-initializes the registers. This is for example the case during scanning.

A warning will be generated if the hack is not supported on the card or
unexpected values are hit. There is no error reporting for userspace
applications though (this is a limitation in the mac80211 driver
interface).

Thanks to Sebastian Gottschall <s.gottschall@dd-wrt.com> for initially
working on a userspace support for this. This patch wouldn't have been
possible without this documentation.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
---
 drivers/net/wireless/ath/ath10k/core.h    |  10 ++
 drivers/net/wireless/ath/ath10k/hw.c      |   9 ++
 drivers/net/wireless/ath/ath10k/hw.h      |  28 +++++-
 drivers/net/wireless/ath/ath10k/mac.c     |  10 ++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  17 ++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 151 ++++++++++++++++++++++++++++++
 6 files changed, 224 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 9374bcd..781219b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -935,6 +935,16 @@ struct ath10k {
 	struct ath10k_thermal thermal;
 	struct ath10k_wow wow;
 
+	/* protected by data_lock */
+	struct {
+		s16 coverage_class;
+
+		u32 reg_slottime_conf;
+		u32 reg_slottime_orig;
+		u32 reg_ack_cts_timeout_conf;
+		u32 reg_ack_cts_timeout_orig;
+	} fw_coverage;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index f903d46..82249be 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -22,6 +22,7 @@ const struct ath10k_hw_regs qca988x_regs = {
 	.rtc_soc_base_address		= 0x00004000,
 	.rtc_wmac_base_address		= 0x00005000,
 	.soc_core_base_address		= 0x00009000,
+	.wlan_mac_base_address		= 0x00020000,
 	.ce_wrapper_base_address	= 0x00057000,
 	.ce0_base_address		= 0x00057400,
 	.ce1_base_address		= 0x00057800,
@@ -48,6 +49,7 @@ const struct ath10k_hw_regs qca6174_regs = {
 	.rtc_soc_base_address			= 0x00000800,
 	.rtc_wmac_base_address			= 0x00001000,
 	.soc_core_base_address			= 0x0003a000,
+	.wlan_mac_base_address			= 0x00020000,
 	.ce_wrapper_base_address		= 0x00034000,
 	.ce0_base_address			= 0x00034400,
 	.ce1_base_address			= 0x00034800,
@@ -74,6 +76,7 @@ const struct ath10k_hw_regs qca99x0_regs = {
 	.rtc_soc_base_address			= 0x00080000,
 	.rtc_wmac_base_address			= 0x00000000,
 	.soc_core_base_address			= 0x00082000,
+	.wlan_mac_base_address			= 0x00030000,
 	.ce_wrapper_base_address		= 0x0004d000,
 	.ce0_base_address			= 0x0004a000,
 	.ce1_base_address			= 0x0004a400,
@@ -109,6 +112,7 @@ const struct ath10k_hw_regs qca99x0_regs = {
 const struct ath10k_hw_regs qca4019_regs = {
 	.rtc_soc_base_address                   = 0x00080000,
 	.soc_core_base_address                  = 0x00082000,
+	.wlan_mac_base_address                  = 0x00030000,
 	.ce_wrapper_base_address                = 0x0004d000,
 	.ce0_base_address                       = 0x0004a000,
 	.ce1_base_address                       = 0x0004a400,
@@ -139,6 +143,7 @@ const struct ath10k_hw_regs qca4019_regs = {
 };
 
 const struct ath10k_hw_values qca988x_values = {
+	.mac_core_rev			= ATH10K_HW_MAC_CORE_ATH9K,
 	.rtc_state_val_on		= 3,
 	.ce_count			= 8,
 	.msi_assign_ce_max		= 7,
@@ -148,6 +153,7 @@ const struct ath10k_hw_values qca988x_values = {
 };
 
 const struct ath10k_hw_values qca6174_values = {
+	.mac_core_rev			= ATH10K_HW_MAC_CORE_ATH9K,
 	.rtc_state_val_on		= 3,
 	.ce_count			= 8,
 	.msi_assign_ce_max		= 7,
@@ -157,6 +163,7 @@ const struct ath10k_hw_values qca6174_values = {
 };
 
 const struct ath10k_hw_values qca99x0_values = {
+	.mac_core_rev			= ATH10K_HW_MAC_CORE_WAVE2,
 	.rtc_state_val_on		= 5,
 	.ce_count			= 12,
 	.msi_assign_ce_max		= 12,
@@ -166,6 +173,7 @@ const struct ath10k_hw_values qca99x0_values = {
 };
 
 const struct ath10k_hw_values qca9888_values = {
+	.mac_core_rev			= ATH10K_HW_MAC_CORE_WAVE2,
 	.rtc_state_val_on		= 3,
 	.ce_count			= 12,
 	.msi_assign_ce_max		= 12,
@@ -175,6 +183,7 @@ const struct ath10k_hw_values qca9888_values = {
 };
 
 const struct ath10k_hw_values qca4019_values = {
+	.mac_core_rev                   = ATH10K_HW_MAC_CORE_WAVE2,
 	.ce_count                       = 12,
 	.num_target_ce_config_wlan      = 10,
 	.ce_desc_meta_data_mask         = 0xFFF0,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index e014cd7..4151326 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -230,6 +230,7 @@ struct ath10k_hw_regs {
 	u32 rtc_soc_base_address;
 	u32 rtc_wmac_base_address;
 	u32 soc_core_base_address;
+	u32 wlan_mac_base_address;
 	u32 ce_wrapper_base_address;
 	u32 ce0_base_address;
 	u32 ce1_base_address;
@@ -257,6 +258,12 @@ extern const struct ath10k_hw_regs qca6174_regs;
 extern const struct ath10k_hw_regs qca99x0_regs;
 extern const struct ath10k_hw_regs qca4019_regs;
 
+enum ath10k_hw_mac_core_rev {
+	ATH10K_HW_MAC_CORE_UNKNOWN = 0,
+	ATH10K_HW_MAC_CORE_ATH9K,
+	ATH10K_HW_MAC_CORE_WAVE2,
+};
+
 struct ath10k_hw_values {
 	u32 rtc_state_val_on;
 	u8 ce_count;
@@ -264,6 +271,7 @@ struct ath10k_hw_values {
 	u8 num_target_ce_config_wlan;
 	u16 ce_desc_meta_data_mask;
 	u8 ce_desc_meta_data_lsb;
+	enum ath10k_hw_mac_core_rev mac_core_rev;
 };
 
 extern const struct ath10k_hw_values qca988x_values;
@@ -545,7 +553,7 @@ enum ath10k_hw_cc_wraparound_type {
 #define WLAN_SI_BASE_ADDRESS			0x00010000
 #define WLAN_GPIO_BASE_ADDRESS			0x00014000
 #define WLAN_ANALOG_INTF_BASE_ADDRESS		0x0001c000
-#define WLAN_MAC_BASE_ADDRESS			0x00020000
+#define WLAN_MAC_BASE_ADDRESS			ar->regs->wlan_mac_base_address
 #define EFUSE_BASE_ADDRESS			0x00030000
 #define FPGA_REG_BASE_ADDRESS			0x00039000
 #define WLAN_UART2_BASE_ADDRESS			0x00054c00
@@ -745,4 +753,22 @@ enum ath10k_hw_cc_wraparound_type {
 
 #define RTC_STATE_V_GET(x) (((x) & RTC_STATE_V_MASK) >> RTC_STATE_V_LSB)
 
+/* Register definitions for ath10k cards that include a MAC which is based
+ * on ATH9k. This ath9k based MAC still has the same or at least similar
+ * registers.
+ * These registers are usually managed by the ath10k firmware. However by
+ * overriding them it is possible to support a few additional features; in this
+ * case setting the coverage class.
+ */
+#define ATH9K_MAC_TIME_OUT		0x8014
+#define ATH9K_MAC_TIME_OUT_MAX		0x00003FFF
+#define ATH9K_MAC_TIME_OUT_ACK		0x00003FFF
+#define ATH9K_MAC_TIME_OUT_ACK_S	0
+#define ATH9K_MAC_TIME_OUT_CTS		0x3FFF0000
+#define ATH9K_MAC_TIME_OUT_CTS_S	16
+
+#define ATH9K_MAC_IFS_SLOT		0x1070
+#define ATH9K_MAC_IFS_SLOT_M		0x0000FFFF
+#define ATH9K_MAC_IFS_SLOT_RESV0	0xFFFF0000
+
 #endif /* _HW_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 55c823f..a9b587e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5372,6 +5372,15 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	mutex_unlock(&ar->conf_mutex);
 }
 
+static void ath10k_set_coverage_class(struct ieee80211_hw *hw,
+				      s16 value)
+{
+	struct ath10k *ar = hw->priv;
+
+	if (ath10k_wmi_pdev_set_coverage_class(ar, value) == -EOPNOTSUPP)
+		ath10k_warn(ar, "Modification of coverage class is not supported!\n");
+}
+
 static int ath10k_hw_scan(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_scan_request *hw_req)
@@ -7397,6 +7406,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.remove_interface		= ath10k_remove_interface,
 	.configure_filter		= ath10k_configure_filter,
 	.bss_info_changed		= ath10k_bss_info_changed,
+	.set_coverage_class		= ath10k_set_coverage_class,
 	.hw_scan			= ath10k_hw_scan,
 	.cancel_hw_scan			= ath10k_cancel_hw_scan,
 	.set_key			= ath10k_set_key,
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 64ebd30..3ebc57e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -52,6 +52,8 @@ struct wmi_ops {
 	int (*pull_wow_event)(struct ath10k *ar, struct sk_buff *skb,
 			      struct wmi_wow_ev_arg *arg);
 	enum wmi_txbf_conf (*get_txbf_conf_scheme)(struct ath10k *ar);
+	void (*set_pdev_coverage_class)(struct ath10k *ar,
+					s16 value);
 
 	struct sk_buff *(*gen_pdev_suspend)(struct ath10k *ar, u32 suspend_opt);
 	struct sk_buff *(*gen_pdev_resume)(struct ath10k *ar);
@@ -1012,6 +1014,21 @@ ath10k_wmi_pdev_get_temperature(struct ath10k *ar)
 }
 
 static inline int
+ath10k_wmi_pdev_set_coverage_class(struct ath10k *ar,
+				   s16 value)
+{
+	if (!ar->wmi.ops->set_pdev_coverage_class)
+		return -EOPNOTSUPP;
+
+	if (value < 0)
+		value = 0;
+
+	ar->wmi.ops->set_pdev_coverage_class(ar, value);
+
+	return 0;
+}
+
+static inline int
 ath10k_wmi_addba_clear_resp(struct ath10k *ar, u32 vdev_id, const u8 *mac)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 169cd2e7..7f30e70 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -28,6 +28,7 @@
 #include "wmi-ops.h"
 #include "p2p.h"
 #include "hw.h"
+#include "hif.h"
 
 /* MAIN WMI cmd track */
 static struct wmi_cmd_map wmi_cmd_map = {
@@ -3096,6 +3097,121 @@ ath10k_wmi_op_pull_peer_kick_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
+static void
+ath10k_ath9k_set_pdev_coverage_class(struct ath10k *ar, s16 value)
+{
+	u32 slottime_reg;
+	u32 slottime;
+	u32 timeout_reg;
+	u32 timeout;
+	u32 counters_freq_mhz = ar->hw_params.channel_counters_freq_hz / 1000;
+
+	/* The firmware does not support setting the coverage class. Instead
+	 * this function monitors and modifies the corresponding MAC registers.
+	 */
+
+	spin_lock_bh(&ar->data_lock);
+
+	/* Retrieve the current values of the two registers that need to be
+	 * adjusted.
+	 */
+	slottime_reg = ath10k_hif_read32(ar, WLAN_MAC_BASE_ADDRESS +
+					     ATH9K_MAC_IFS_SLOT);
+	timeout_reg = ath10k_hif_read32(ar, WLAN_MAC_BASE_ADDRESS +
+					    ATH9K_MAC_TIME_OUT);
+
+	if (value < 0)
+		value = ar->fw_coverage.coverage_class;
+
+	/* Break out if the coverage class and registers have the expected
+	 * value.
+	 */
+	if (value == ar->fw_coverage.coverage_class &&
+	    slottime_reg == ar->fw_coverage.reg_slottime_conf &&
+	    timeout_reg == ar->fw_coverage.reg_ack_cts_timeout_conf)
+		goto unlock;
+
+	/* Store new initial register values from the firmware. */
+	if (slottime_reg != ar->fw_coverage.reg_slottime_conf)
+		ar->fw_coverage.reg_slottime_orig = slottime_reg;
+	if (timeout_reg != ar->fw_coverage.reg_ack_cts_timeout_conf)
+		ar->fw_coverage.reg_ack_cts_timeout_orig = timeout_reg;
+
+	/* Calculat new value based on the (original) firmware calculation. */
+	slottime_reg = ar->fw_coverage.reg_slottime_orig;
+	timeout_reg = ar->fw_coverage.reg_ack_cts_timeout_orig;
+
+	/* Do some sanity checks on the slottime register. */
+	if (unlikely(slottime_reg % counters_freq_mhz)) {
+		ath10k_warn(ar,
+			    "Not adjusting coverage class timeouts, expected an integer microsecond slot time in HW register\n");
+
+		goto store_regs;
+	}
+
+	slottime = (slottime_reg & ATH9K_MAC_IFS_SLOT_M) / counters_freq_mhz;
+	if (unlikely(slottime != 9 && slottime != 20)) {
+		ath10k_warn(ar,
+			    "Not adjusting coverage class timeouts, expected a slot time of 9 or 20us in HW register. It is %uus.\n",
+			    slottime);
+
+		goto store_regs;
+	}
+
+	/* Recalculate the register values by adding the additional propagation
+	 * delay (3us per coverage class).
+	 */
+
+	slottime = (slottime_reg & ATH9K_MAC_IFS_SLOT_M);
+	slottime += value * 3 * counters_freq_mhz;
+	slottime = min_t(u32, slottime, ATH9K_MAC_IFS_SLOT_M);
+	slottime_reg = (slottime_reg & ~ATH9K_MAC_IFS_SLOT_M) | slottime;
+
+	/* Update ack timeout (lower halfword). */
+	timeout = (timeout_reg & ATH9K_MAC_TIME_OUT_ACK);
+	timeout = timeout >> ATH9K_MAC_TIME_OUT_ACK_S;
+	timeout += 3 * value * counters_freq_mhz;
+	timeout = min_t(u32, timeout, ATH9K_MAC_TIME_OUT_MAX);
+	timeout = (timeout << ATH9K_MAC_TIME_OUT_ACK_S)
+	timeout = timeout & ATH9K_MAC_TIME_OUT_ACK;
+	timeout_reg = (timeout_reg & ~ATH9K_MAC_TIME_OUT_ACK) | timeout;
+
+	/* Update cts timeout (upper halfword). */
+	timeout = (timeout_reg & ATH9K_MAC_TIME_OUT_CTS)
+	timeout = timeout >> ATH9K_MAC_TIME_OUT_CTS_S;
+	timeout += 3 * value * counters_freq_mhz;
+	timeout = min_t(u32, timeout, ATH9K_MAC_TIME_OUT_MAX);
+	timeout = (timeout << ATH9K_MAC_TIME_OUT_CTS_S)
+	timeout = timeout & ATH9K_MAC_TIME_OUT_CTS;
+	timeout_reg = (timeout_reg & ~ATH9K_MAC_TIME_OUT_CTS) | timeout;
+
+	ath10k_hif_write32(ar, WLAN_MAC_BASE_ADDRESS + 0x1070, slottime_reg);
+	ath10k_hif_write32(ar, WLAN_MAC_BASE_ADDRESS + 0x8014, timeout_reg);
+
+store_regs:
+	/* After an error we will not retry setting the coverage class. */
+	ar->fw_coverage.coverage_class = value;
+	ar->fw_coverage.reg_slottime_conf = slottime_reg;
+	ar->fw_coverage.reg_ack_cts_timeout_conf = timeout_reg;
+
+unlock:
+	spin_unlock_bh(&ar->data_lock);
+}
+
+static void
+ath10k_wmi_op_set_pdev_coverage_class(struct ath10k *ar, s16 value)
+{
+	switch (ar->hw_values->mac_core_rev) {
+	case ATH10K_HW_MAC_CORE_ATH9K:
+		ath10k_ath9k_set_pdev_coverage_class(ar, value);
+		break;
+	default:
+		if (value != -1)
+			ath10k_warn(ar, "Setting the coverage class is not supported for this chipset.");
+		break;
+	}
+}
+
 void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_peer_kick_ev_arg arg = {};
@@ -4992,6 +5108,12 @@ static void ath10k_wmi_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 
+	/* Check and possibly reset the coverage class configuration override.
+	 * There are many conditions (in particular internal card resets) that
+	 * can cause the registers to be re-initialized.
+	 */
+	ath10k_wmi_op_set_pdev_coverage_class(ar, -1);
+
 out:
 	dev_kfree_skb(skb);
 }
@@ -5116,6 +5238,12 @@ static void ath10k_wmi_10_1_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 
+	/* Check and possibly reset the coverage class configuration override.
+	 * There are many conditions (in particular internal card resets) that
+	 * can cause the registers to be re-initialized.
+	 */
+	ath10k_wmi_op_set_pdev_coverage_class(ar, -1);
+
 out:
 	dev_kfree_skb(skb);
 }
@@ -5240,6 +5368,12 @@ static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 
+	/* Check and possibly reset the coverage class configuration override.
+	 * There are many conditions (in particular internal card resets) that
+	 * can cause the registers to be re-initialized.
+	 */
+	ath10k_wmi_op_set_pdev_coverage_class(ar, -1);
+
 out:
 	dev_kfree_skb(skb);
 }
@@ -5323,6 +5457,12 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 
+	/* Check and possibly reset the coverage class configuration override.
+	 * There are many conditions (in particular internal card resets) that
+	 * can cause the registers to be re-initialized.
+	 */
+	ath10k_wmi_op_set_pdev_coverage_class(ar, -1);
+
 out:
 	dev_kfree_skb(skb);
 }
@@ -6017,6 +6157,7 @@ void ath10k_wmi_start_scan_init(struct ath10k *ar,
 		| WMI_SCAN_EVENT_COMPLETED
 		| WMI_SCAN_EVENT_BSS_CHANNEL
 		| WMI_SCAN_EVENT_FOREIGN_CHANNEL
+		| WMI_SCAN_EVENT_FOREIGN_CHANNEL_EXIT
 		| WMI_SCAN_EVENT_DEQUEUED;
 	arg->scan_ctrl_flags |= WMI_SCAN_CHAN_STAT_EVENT;
 	arg->n_bssids = 1;
@@ -7666,6 +7807,8 @@ static const struct wmi_ops wmi_ops = {
 	.pull_fw_stats = ath10k_wmi_main_op_pull_fw_stats,
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
 
+	.set_pdev_coverage_class = ath10k_wmi_op_set_pdev_coverage_class,
+
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
 	.gen_pdev_set_rd = ath10k_wmi_op_gen_pdev_set_rd,
@@ -7739,6 +7882,8 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
 
+	.set_pdev_coverage_class = ath10k_wmi_op_set_pdev_coverage_class,
+
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
 	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
@@ -7808,6 +7953,8 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
 
+	.set_pdev_coverage_class = ath10k_wmi_op_set_pdev_coverage_class,
+
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
 	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
@@ -7874,6 +8021,8 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
 
+	.set_pdev_coverage_class = ath10k_wmi_op_set_pdev_coverage_class,
+
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
 	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
@@ -7938,6 +8087,8 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
 	.get_txbf_conf_scheme = ath10k_wmi_10_4_txbf_conf_scheme,
 
+	.set_pdev_coverage_class = ath10k_wmi_op_set_pdev_coverage_class,
+
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
 	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
-- 
2.8.1

