Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24744 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0BRL2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:22 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH 06/22] wl1271: implement WMM
Date: Thu, 18 Feb 2010 13:25:41 +0200
Message-Id: <1266492357-462-7-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Now that necessary commands for WMM are implemented, implement queue handling
for WMM. But WMM is not enabled yet, only one queue is used.

Based on a similar patch from wl1251.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   31 +++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   10 +++++---
 drivers/net/wireless/wl12xx/wl1271_tx.h   |   36 +++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index a3742c8..6f7a7d9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1712,6 +1712,36 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
+static int wl1271_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
+			     const struct ieee80211_tx_queue_params *params)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 conf tx %d", queue);
+
+	ret = wl1271_acx_ac_cfg(wl, wl1271_tx_get_queue(queue),
+				params->cw_min, params->cw_max,
+				params->aifs, params->txop);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_acx_tid_cfg(wl, wl1271_tx_get_queue(queue),
+				 CONF_CHANNEL_TYPE_EDCF,
+				 wl1271_tx_get_queue(queue),
+				 CONF_PS_SCHEME_LEGACY_PSPOLL,
+				 CONF_ACK_POLICY_LEGACY, 0, 0);
+	if (ret < 0)
+		goto out;
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
 
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_rate wl1271_rates[] = {
@@ -1877,6 +1907,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.hw_scan = wl1271_op_hw_scan,
 	.bss_info_changed = wl1271_op_bss_info_changed,
 	.set_rts_threshold = wl1271_op_set_rts_threshold,
+	.conf_tx = wl1271_op_conf_tx,
 };
 
 static int wl1271_register_hw(struct wl1271 *wl)
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index a288cc3..f6815a9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -87,7 +87,7 @@ static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 			      u32 extra, struct ieee80211_tx_info *control)
 {
 	struct wl1271_tx_hw_descr *desc;
-	int pad;
+	int pad, ac;
 	u16 tx_attr;
 
 	desc = (struct wl1271_tx_hw_descr *) skb->data;
@@ -107,9 +107,11 @@ static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 
 	/* configure the tx attributes */
 	tx_attr = wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
-	/* FIXME: do we know the packet priority? can we identify mgmt
-	   packets, and use max prio for them at least? */
-	desc->tid = 0;
+
+	/* queue */
+	ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
+	desc->tid = wl1271_tx_ac_to_tid(ac);
+
 	desc->aid = TX_HW_DEFAULT_AID;
 	desc->reserved = 0;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
index 416396c..17e405a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -123,6 +123,42 @@ struct wl1271_tx_hw_res_if {
 	struct wl1271_tx_hw_res_descr tx_results_queue[TX_HW_RESULT_QUEUE_LEN];
 } __attribute__ ((packed));
 
+static inline int wl1271_tx_get_queue(int queue)
+{
+	/* FIXME: use best effort until WMM is enabled */
+	return CONF_TX_AC_BE;
+
+	switch (queue) {
+	case 0:
+		return CONF_TX_AC_VO;
+	case 1:
+		return CONF_TX_AC_VI;
+	case 2:
+		return CONF_TX_AC_BE;
+	case 3:
+		return CONF_TX_AC_BK;
+	default:
+		return CONF_TX_AC_BE;
+	}
+}
+
+/* wl1271 tx descriptor needs the tid and we need to convert it from ac */
+static inline int wl1271_tx_ac_to_tid(int ac)
+{
+	switch (ac) {
+	case 0:
+		return 0;
+	case 1:
+		return 2;
+	case 2:
+		return 4;
+	case 3:
+		return 6;
+	default:
+		return 0;
+	}
+}
+
 void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_complete(struct wl1271 *wl, u32 count);
 void wl1271_tx_flush(struct wl1271 *wl);
-- 
1.6.3.3

