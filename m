Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:27834 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760651AbZKZPJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 10:09:48 -0500
Subject: [PATCH 08/12] wl1251: implement acx_ac_cfg to configure hardware
	queues
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 17:09:18 +0200
Message-ID: <20091126150918.917.61.stgit@tikku>
In-Reply-To: <20091126150141.917.35278.stgit@tikku>
References: <20091126150141.917.35278.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Needed for WMM.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_acx.c  |   33 ++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_acx.h  |   32 ++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_init.c |    5 +++
 drivers/net/wireless/wl12xx/wl1251_init.h |   47 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_main.c |   27 +++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_tx.h   |   20 ++++++++++++
 6 files changed, 164 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
index acfa086..b409c75 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -976,3 +976,36 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1251_acx_ac_cfg(struct wl1251 *wl, u8 ac, u8 cw_min, u16 cw_max,
+		      u8 aifs, u16 txop)
+{
+	struct wl1251_acx_ac_cfg *acx;
+	int ret = 0;
+
+	wl1251_debug(DEBUG_ACX, "acx ac cfg %d cw_ming %d cw_max %d "
+		     "aifs %d txop %d", ac, cw_min, cw_max, aifs, txop);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->ac = ac;
+	acx->cw_min = cw_min;
+	acx->cw_max = cw_max;
+	acx->aifsn = aifs;
+	acx->txop_limit = txop;
+
+	ret = wl1251_cmd_configure(wl, ACX_AC_CFG, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1251_warning("acx ac cfg failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index 6523714..5679324 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -1166,6 +1166,36 @@ struct wl1251_acx_wr_tbtt_and_dtim {
 	u8  padding;
 } __attribute__ ((packed));
 
+struct wl1251_acx_ac_cfg {
+	struct acx_header header;
+
+	/*
+	 * Access Category - The TX queue's access category
+	 * (refer to AccessCategory_enum)
+	 */
+	u8 ac;
+
+	/*
+	 * The contention window minimum size (in slots) for
+	 * the access class.
+	 */
+	u8 cw_min;
+
+	/*
+	 * The contention window maximum size (in slots) for
+	 * the access class.
+	 */
+	u16 cw_max;
+
+	/* The AIF value (in slots) for the access class. */
+	u8 aifsn;
+
+	u8 reserved;
+
+	/* The TX Op Limit (in microseconds) for the access class. */
+	u16 txop_limit;
+} __attribute__ ((packed));
+
 /*************************************************************************
 
     Host Interrupt Register (WiLink -> Host)
@@ -1322,5 +1352,7 @@ int wl1251_acx_tsf_info(struct wl1251 *wl, u64 *mactime);
 int wl1251_acx_rate_policies(struct wl1251 *wl);
 int wl1251_acx_mem_cfg(struct wl1251 *wl);
 int wl1251_acx_wr_tbtt_and_dtim(struct wl1251 *wl, u16 tbtt, u8 dtim);
+int wl1251_acx_ac_cfg(struct wl1251 *wl, u8 ac, u8 cw_min, u16 cw_max,
+		      u8 aifs, u16 txop);
 
 #endif /* __WL1251_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.c b/drivers/net/wireless/wl12xx/wl1251_init.c
index 5cb5733..5aad56e 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.c
+++ b/drivers/net/wireless/wl12xx/wl1251_init.c
@@ -294,6 +294,11 @@ static int wl1251_hw_init_tx_queue_config(struct wl1251 *wl)
 			goto out;
 	}
 
+	wl1251_acx_ac_cfg(wl, AC_BE, CWMIN_BE, CWMAX_BE, AIFS_DIFS, TXOP_BE);
+	wl1251_acx_ac_cfg(wl, AC_BK, CWMIN_BK, CWMAX_BK, AIFS_DIFS, TXOP_BK);
+	wl1251_acx_ac_cfg(wl, AC_VI, CWMIN_VI, CWMAX_VI, AIFS_DIFS, TXOP_VI);
+	wl1251_acx_ac_cfg(wl, AC_VO, CWMIN_VO, CWMAX_VO, AIFS_DIFS, TXOP_VO);
+
 out:
 	kfree(config);
 	return ret;
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.h b/drivers/net/wireless/wl12xx/wl1251_init.h
index b3b25ec..269cefb 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.h
+++ b/drivers/net/wireless/wl12xx/wl1251_init.h
@@ -26,6 +26,53 @@
 
 #include "wl1251.h"
 
+enum {
+	/* best effort/legacy */
+	AC_BE = 0,
+
+	/* background */
+	AC_BK = 1,
+
+	/* video */
+	AC_VI = 2,
+
+	/* voice */
+	AC_VO = 3,
+
+	/* broadcast dummy access category */
+	AC_BCAST = 4,
+
+	NUM_ACCESS_CATEGORIES = 4
+};
+
+/* following are defult values for the IE fields*/
+#define CWMIN_BK  15
+#define CWMIN_BE  15
+#define CWMIN_VI  7
+#define CWMIN_VO  3
+#define CWMAX_BK  1023
+#define CWMAX_BE  63
+#define CWMAX_VI  15
+#define CWMAX_VO  7
+
+/* slot number setting to start transmission at PIFS interval */
+#define AIFS_PIFS 1
+
+/*
+ * slot number setting to start transmission at DIFS interval - normal DCF
+ * access
+ */
+#define AIFS_DIFS 2
+
+#define AIFSN_BK  7
+#define AIFSN_BE  3
+#define AIFSN_VI  AIFS_PIFS
+#define AIFSN_VO  AIFS_PIFS
+#define TXOP_BK   0
+#define TXOP_BE   0
+#define TXOP_VI   3008
+#define TXOP_VO   1504
+
 int wl1251_hw_init_hwenc_config(struct wl1251 *wl);
 int wl1251_hw_init_templates_config(struct wl1251 *wl);
 int wl1251_hw_init_rx_config(struct wl1251 *wl, u32 config, u32 filter);
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 8ba6742..4d335d6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1279,6 +1279,32 @@ static struct ieee80211_channel wl1251_channels[] = {
 	{ .hw_value = 13, .center_freq = 2472},
 };
 
+static int wl1251_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
+			     const struct ieee80211_tx_queue_params *params)
+{
+	struct wl1251 *wl = hw->priv;
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	wl1251_debug(DEBUG_MAC80211, "mac80211 conf tx %d", queue);
+
+	ret = wl1251_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1251_acx_ac_cfg(wl, wl1251_tx_get_queue(queue),
+				params->cw_min, params->cw_max,
+				params->aifs, params->txop);
+
+	wl1251_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_supported_band wl1251_band_2ghz = {
 	.channels = wl1251_channels,
@@ -1299,6 +1325,7 @@ static const struct ieee80211_ops wl1251_ops = {
 	.hw_scan = wl1251_op_hw_scan,
 	.bss_info_changed = wl1251_op_bss_info_changed,
 	.set_rts_threshold = wl1251_op_set_rts_threshold,
+	.conf_tx = wl1251_op_conf_tx,
 };
 
 static int wl1251_register_hw(struct wl1251 *wl)
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.h b/drivers/net/wireless/wl12xx/wl1251_tx.h
index 7c1c166..b7bead8 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.h
@@ -26,6 +26,7 @@
 #define __WL1251_TX_H__
 
 #include <linux/bitops.h>
+#include "wl1251_acx.h"
 
 /*
  *
@@ -209,6 +210,25 @@ struct tx_result {
 	u8 done_2;
 } __attribute__ ((packed));
 
+static inline int wl1251_tx_get_queue(int queue)
+{
+	/* FIXME: use best effort until WMM is enabled */
+	return QOS_AC_BE;
+
+	switch (queue) {
+	case 0:
+		return QOS_AC_VO;
+	case 1:
+		return QOS_AC_VI;
+	case 2:
+		return QOS_AC_BE;
+	case 3:
+		return QOS_AC_BK;
+	default:
+		return QOS_AC_BE;
+	}
+}
+
 void wl1251_tx_work(struct work_struct *work);
 void wl1251_tx_complete(struct wl1251 *wl);
 void wl1251_tx_flush(struct wl1251 *wl);

