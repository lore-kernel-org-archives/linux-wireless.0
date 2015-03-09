Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:42443 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbbCIH4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 03:56:32 -0400
Received: by lams18 with SMTP id s18so7150349lam.9
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 00:56:30 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/4] ath10k: add WOW disconnect/magic-packet support
Date: Mon,  9 Mar 2015 08:55:18 +0100
Message-Id: <1425887720-11466-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150309_085637_337120_2CF2B367)
In-Reply-To: <1425887720-11466-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1425887720-11466-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for WOW disconnect and magic-packet.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/Makefile |   1 +
 drivers/net/wireless/ath/ath10k/core.c   |   1 +
 drivers/net/wireless/ath/ath10k/core.h   |   8 +
 drivers/net/wireless/ath/ath10k/mac.c    |  75 +--------
 drivers/net/wireless/ath/ath10k/wmi.c    |  14 +-
 drivers/net/wireless/ath/ath10k/wow.c    | 278 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wow.h    |  34 ++++
 7 files changed, 344 insertions(+), 67 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/wow.c
 create mode 100644 drivers/net/wireless/ath/ath10k/wow.h

diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index 92a1e09..9729e69 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -18,6 +18,7 @@ ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
 ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
 ath10k_core-$(CONFIG_THERMAL) += thermal.o
 ath10k_core-$(CONFIG_MAC80211_DEBUGFS) += debugfs_sta.o
+ath10k_core-$(CONFIG_PM) += wow.o
 
 obj-$(CONFIG_ATH10K_PCI) += ath10k_pci.o
 ath10k_pci-y += pci.o \
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c0e454b..e7fc531 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1386,6 +1386,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	init_completion(&ar->scan.completed);
 	init_completion(&ar->scan.on_channel);
 	init_completion(&ar->target_suspend);
+	init_completion(&ar->wow.wakeup_completed);
 
 	init_completion(&ar->install_key_done);
 	init_completion(&ar->vdev_setup_done);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 9b8f486..23a2f2e 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -35,6 +35,7 @@
 #include "../dfs_pattern_detector.h"
 #include "spectral.h"
 #include "thermal.h"
+#include "wow.h"
 
 #define MS(_v, _f) (((_v) & _f##_MASK) >> _f##_LSB)
 #define SM(_v, _f) (((_v) << _f##_LSB) & _f##_MASK)
@@ -441,6 +442,12 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_MULTI_VIF_PS_SUPPORT = 5,
 
+	/* Some firmware revisions have an incomplete WoWLAN implementation
+	 * despite WMI service bit being advertised. This feature flag is used
+	 * to distinguish whether WoWLAN is really supported or not.
+	 */
+	ATH10K_FW_FEATURE_WOWLAN_SUPPORT = 6,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
@@ -687,6 +694,7 @@ struct ath10k {
 	} stats;
 
 	struct ath10k_thermal thermal;
+	struct ath10k_wow wow;
 
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1138f4f..c642d18 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -29,6 +29,7 @@
 #include "testmode.h"
 #include "wmi.h"
 #include "wmi-ops.h"
+#include "wow.h"
 
 /**********/
 /* Crypto */
@@ -4719,70 +4720,6 @@ static int ath10k_tx_last_beacon(struct ieee80211_hw *hw)
 	return 1;
 }
 
-#ifdef CONFIG_PM
-static int ath10k_suspend(struct ieee80211_hw *hw,
-			  struct cfg80211_wowlan *wowlan)
-{
-	struct ath10k *ar = hw->priv;
-	int ret;
-
-	mutex_lock(&ar->conf_mutex);
-
-	ret = ath10k_wait_for_suspend(ar, WMI_PDEV_SUSPEND);
-	if (ret) {
-		if (ret == -ETIMEDOUT)
-			goto resume;
-		ret = 1;
-		goto exit;
-	}
-
-	ret = ath10k_hif_suspend(ar);
-	if (ret) {
-		ath10k_warn(ar, "failed to suspend hif: %d\n", ret);
-		goto resume;
-	}
-
-	ret = 0;
-	goto exit;
-resume:
-	ret = ath10k_wmi_pdev_resume_target(ar);
-	if (ret)
-		ath10k_warn(ar, "failed to resume target: %d\n", ret);
-
-	ret = 1;
-exit:
-	mutex_unlock(&ar->conf_mutex);
-	return ret;
-}
-
-static int ath10k_resume(struct ieee80211_hw *hw)
-{
-	struct ath10k *ar = hw->priv;
-	int ret;
-
-	mutex_lock(&ar->conf_mutex);
-
-	ret = ath10k_hif_resume(ar);
-	if (ret) {
-		ath10k_warn(ar, "failed to resume hif: %d\n", ret);
-		ret = 1;
-		goto exit;
-	}
-
-	ret = ath10k_wmi_pdev_resume_target(ar);
-	if (ret) {
-		ath10k_warn(ar, "failed to resume target: %d\n", ret);
-		ret = 1;
-		goto exit;
-	}
-
-	ret = 0;
-exit:
-	mutex_unlock(&ar->conf_mutex);
-	return ret;
-}
-#endif
-
 static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
 				     enum ieee80211_reconfig_type reconfig_type)
 {
@@ -5332,8 +5269,8 @@ static const struct ieee80211_ops ath10k_ops = {
 	CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
 
 #ifdef CONFIG_PM
-	.suspend			= ath10k_suspend,
-	.resume				= ath10k_resume,
+	.suspend			= ath10k_wow_op_suspend,
+	.resume				= ath10k_wow_op_resume,
 #endif
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.sta_add_debugfs		= ath10k_sta_add_debugfs,
@@ -5766,6 +5703,12 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 	ar->hw->wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
 
+	ret = ath10k_wow_init(ar->hw);
+	if (ret) {
+		ath10k_warn(ar, "failed to init wow: %d\n", ret);
+		goto err_free;
+	}
+
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 29aef7e..d9d1835 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2859,7 +2859,19 @@ void ath10k_wmi_event_rtt_error_report(struct ath10k *ar, struct sk_buff *skb)
 
 void ath10k_wmi_event_wow_wakeup_host(struct ath10k *ar, struct sk_buff *skb)
 {
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_WOW_WAKEUP_HOST_EVENTID\n");
+	struct wmi_wow_ev_arg ev = {};
+	int ret;
+
+	complete(&ar->wow.wakeup_completed);
+
+	ret = ath10k_wmi_pull_wow_event(ar, skb, &ev);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse wow wakeup event: %d\n", ret);
+		return;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wow wakeup host reason %s\n",
+		   wow_reason(ev.wake_reason));
 }
 
 void ath10k_wmi_event_dcs_interference(struct ath10k *ar, struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath10k/wow.c b/drivers/net/wireless/ath/ath10k/wow.c
new file mode 100644
index 0000000..c566881
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/wow.c
@@ -0,0 +1,278 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "mac.h"
+
+#include <net/mac80211.h>
+#include "hif.h"
+#include "core.h"
+#include "debug.h"
+#include "wmi.h"
+#include "wmi-ops.h"
+
+static const struct wiphy_wowlan_support ath10k_wowlan_support = {
+	.flags = WIPHY_WOWLAN_DISCONNECT |
+		 WIPHY_WOWLAN_MAGIC_PKT,
+};
+
+static int ath10k_wow_vif_cleanup(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	int i, ret;
+
+	for (i = 0; i < WOW_EVENT_MAX; i++) {
+		ret = ath10k_wmi_wow_add_wakeup_event(ar, arvif->vdev_id, i, 0);
+		if (ret) {
+			ath10k_warn(ar, "failed to issue wow wakeup for event %s on vdev %i: %d\n",
+				    wow_wakeup_event(i), arvif->vdev_id, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ath10k_wow_cleanup(struct ath10k *ar)
+{
+	struct ath10k_vif *arvif;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		ret = ath10k_wow_vif_cleanup(arvif);
+		if (ret) {
+			ath10k_warn(ar, "failed to clean wow wakeups on vdev %i: %d\n",
+				    arvif->vdev_id, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ath10k_vif_wow_set_wakeups(struct ath10k_vif *arvif,
+				      struct cfg80211_wowlan *wowlan)
+{
+	int ret, i;
+	unsigned long wow_mask = 0;
+	struct ath10k *ar = arvif->ar;
+
+	/* Setup requested WOW features */
+	switch (arvif->vdev_type) {
+	case WMI_VDEV_TYPE_IBSS:
+		__set_bit(WOW_BEACON_EVENT, &wow_mask);
+		 /* fall through */
+	case WMI_VDEV_TYPE_AP:
+		__set_bit(WOW_DEAUTH_RECVD_EVENT, &wow_mask);
+		__set_bit(WOW_DISASSOC_RECVD_EVENT, &wow_mask);
+		__set_bit(WOW_PROBE_REQ_WPS_IE_EVENT, &wow_mask);
+		__set_bit(WOW_AUTH_REQ_EVENT, &wow_mask);
+		__set_bit(WOW_ASSOC_REQ_EVENT, &wow_mask);
+		__set_bit(WOW_HTT_EVENT, &wow_mask);
+		__set_bit(WOW_RA_MATCH_EVENT, &wow_mask);
+		break;
+	case WMI_VDEV_TYPE_STA:
+		if (wowlan->disconnect) {
+			__set_bit(WOW_DEAUTH_RECVD_EVENT, &wow_mask);
+			__set_bit(WOW_DISASSOC_RECVD_EVENT, &wow_mask);
+			__set_bit(WOW_BMISS_EVENT, &wow_mask);
+			__set_bit(WOW_CSA_IE_EVENT, &wow_mask);
+		}
+
+		if (wowlan->magic_pkt)
+			__set_bit(WOW_MAGIC_PKT_RECVD_EVENT, &wow_mask);
+		break;
+	default:
+		break;
+	}
+
+	for (i = 0; i < WOW_EVENT_MAX; i++) {
+		if (!test_bit(i, &wow_mask))
+			continue;
+		ret = ath10k_wmi_wow_add_wakeup_event(ar, arvif->vdev_id, i, 1);
+		if (ret) {
+			ath10k_warn(ar, "failed to enable wakeup event %s on vdev %i: %d\n",
+				    wow_wakeup_event(i), arvif->vdev_id, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ath10k_wow_set_wakeups(struct ath10k *ar,
+				  struct cfg80211_wowlan *wowlan)
+{
+	struct ath10k_vif *arvif;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		ret = ath10k_vif_wow_set_wakeups(arvif, wowlan);
+		if (ret) {
+			ath10k_warn(ar, "failed to set wow wakeups on vdev %i: %d\n",
+				    arvif->vdev_id, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ath10k_wow_enable(struct ath10k *ar)
+{
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	reinit_completion(&ar->target_suspend);
+
+	ret = ath10k_wmi_wow_enable(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to issue wow enable: %d\n", ret);
+		return ret;
+	}
+
+	ret = wait_for_completion_timeout(&ar->target_suspend, 3 * HZ);
+	if (ret == 0) {
+		ath10k_warn(ar, "timed out while waiting for suspend completion\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static int ath10k_wow_wakeup(struct ath10k *ar)
+{
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	reinit_completion(&ar->wow.wakeup_completed);
+
+	ret = ath10k_wmi_wow_host_wakeup_ind(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to send wow wakeup indication: %d\n",
+			    ret);
+		return ret;
+	}
+
+	ret = wait_for_completion_timeout(&ar->wow.wakeup_completed, 3 * HZ);
+	if (ret == 0) {
+		ath10k_warn(ar, "timed out while waiting for wow wakeup completion\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+int ath10k_wow_op_suspend(struct ieee80211_hw *hw,
+			  struct cfg80211_wowlan *wowlan)
+{
+	struct ath10k *ar = hw->priv;
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (WARN_ON(!test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT,
+			      ar->fw_features))) {
+		ret = 1;
+		goto exit;
+	}
+
+	ret =  ath10k_wow_cleanup(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to clear wow wakeup events: %d\n",
+			    ret);
+		goto exit;
+	}
+
+	ret = ath10k_wow_set_wakeups(ar, wowlan);
+	if (ret) {
+		ath10k_warn(ar, "failed to set wow wakeup events: %d\n",
+			    ret);
+		goto cleanup;
+	}
+
+	ret = ath10k_wow_enable(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to start wow: %d\n", ret);
+		goto cleanup;
+	}
+
+	ret = ath10k_hif_suspend(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to suspend hif: %d\n", ret);
+		goto wakeup;
+	}
+
+	goto exit;
+
+wakeup:
+	ath10k_wow_wakeup(ar);
+
+cleanup:
+	ath10k_wow_cleanup(ar);
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+	return ret ? 1 : 0;
+}
+
+int ath10k_wow_op_resume(struct ieee80211_hw *hw)
+{
+	struct ath10k *ar = hw->priv;
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (WARN_ON(!test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT,
+			      ar->fw_features))) {
+		ret = 1;
+		goto exit;
+	}
+
+	ret = ath10k_hif_resume(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to resume hif: %d\n", ret);
+		goto exit;
+	}
+
+	ret = ath10k_wow_wakeup(ar);
+	if (ret)
+		ath10k_warn(ar, "failed to wakeup from wow: %d\n", ret);
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+	return ret ? 1 : 0;
+}
+
+int ath10k_wow_init(struct ieee80211_hw *hw)
+{
+	struct ath10k *ar = hw->priv;
+
+	if (!test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT, ar->fw_features))
+		return 0;
+
+	if (WARN_ON(!test_bit(WMI_SERVICE_WOW, ar->wmi.svc_map)))
+		return -EINVAL;
+
+	ar->hw->wiphy->wowlan = &ath10k_wowlan_support;
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/ath10k/wow.h b/drivers/net/wireless/ath/ath10k/wow.h
new file mode 100644
index 0000000..32b724a
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/wow.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef _WOW_H_
+#define _WOW_H_
+
+struct ath10k_wow {
+	struct completion wakeup_completed;
+};
+
+#ifdef CONFIG_PM
+int ath10k_wow_init(struct ieee80211_hw *hw);
+int ath10k_wow_op_suspend(struct ieee80211_hw *hw,
+			  struct cfg80211_wowlan *wowlan);
+int ath10k_wow_op_resume(struct ieee80211_hw *hw);
+#else
+static inline int ath10k_wow_init(struct ieee80211_hw *hw)
+{
+	return 0;
+}
+#endif /* CONFIG_PM */
+#endif /* _WOW_H_ */
-- 
1.9.1

