Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41257 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0L2Xcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 18:32:48 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so4915990ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 15:32:47 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v4 14/18] wl1271: AP mode - record TX configuration settings
Date: Thu, 30 Dec 2010 01:32:09 +0200
Message-Id: <1293665533-7599-15-git-send-email-arik@wizery.com>
In-Reply-To: <1293665533-7599-1-git-send-email-arik@wizery.com>
References: <1293665533-7599-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Record TX configuration settings in the "conf" member of our global
structure (struct wl1271) if conf_tx is called when the firmware is
not loaded.

Later on when the firmware is loaded, we apply the tx conf as part of
the init sequence.

Important for AP mode since conf_tx is called before add_interface
(where the firmware is initialized).

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   72 ++++++++++++++++++++++++------------
 1 files changed, 48 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ed5e2fc..8b897e3 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2314,42 +2314,66 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 {
 	struct wl1271 *wl = hw->priv;
 	u8 ps_scheme;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&wl->mutex);
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 conf tx %d", queue);
 
-	if (unlikely(wl->state == WL1271_STATE_OFF)) {
-		ret = -EAGAIN;
-		goto out;
-	}
-
-	ret = wl1271_ps_elp_wakeup(wl, false);
-	if (ret < 0)
-		goto out;
-
-	/* the txop is confed in units of 32us by the mac80211, we need us */
-	ret = wl1271_acx_ac_cfg(wl, wl1271_tx_get_queue(queue),
-				params->cw_min, params->cw_max,
-				params->aifs, params->txop << 5);
-	if (ret < 0)
-		goto out_sleep;
-
 	if (params->uapsd)
 		ps_scheme = CONF_PS_SCHEME_UPSD_TRIGGER;
 	else
 		ps_scheme = CONF_PS_SCHEME_LEGACY;
 
-	ret = wl1271_acx_tid_cfg(wl, wl1271_tx_get_queue(queue),
-				 CONF_CHANNEL_TYPE_EDCF,
-				 wl1271_tx_get_queue(queue),
-				 ps_scheme, CONF_ACK_POLICY_LEGACY, 0, 0);
-	if (ret < 0)
-		goto out_sleep;
+	if (wl->state == WL1271_STATE_OFF) {
+		/*
+		 * If the state is off, the parameters will be recorded and
+		 * configured on init. This happens in AP-mode.
+		 */
+		struct conf_tx_ac_category *conf_ac =
+			&wl->conf.tx.ac_conf[wl1271_tx_get_queue(queue)];
+		struct conf_tx_tid *conf_tid =
+			&wl->conf.tx.tid_conf[wl1271_tx_get_queue(queue)];
+
+		conf_ac->ac = wl1271_tx_get_queue(queue);
+		conf_ac->cw_min = (u8)params->cw_min;
+		conf_ac->cw_max = params->cw_max;
+		conf_ac->aifsn = params->aifs;
+		conf_ac->tx_op_limit = params->txop << 5;
+
+		conf_tid->queue_id = wl1271_tx_get_queue(queue);
+		conf_tid->channel_type = CONF_CHANNEL_TYPE_EDCF;
+		conf_tid->tsid = wl1271_tx_get_queue(queue);
+		conf_tid->ps_scheme = ps_scheme;
+		conf_tid->ack_policy = CONF_ACK_POLICY_LEGACY;
+		conf_tid->apsd_conf[0] = 0;
+		conf_tid->apsd_conf[1] = 0;
+	} else {
+		ret = wl1271_ps_elp_wakeup(wl, false);
+		if (ret < 0)
+			goto out;
+
+		/*
+		 * the txop is confed in units of 32us by the mac80211,
+		 * we need us
+		 */
+		ret = wl1271_acx_ac_cfg(wl, wl1271_tx_get_queue(queue),
+					params->cw_min, params->cw_max,
+					params->aifs, params->txop << 5);
+		if (ret < 0)
+			goto out_sleep;
+
+		ret = wl1271_acx_tid_cfg(wl, wl1271_tx_get_queue(queue),
+					 CONF_CHANNEL_TYPE_EDCF,
+					 wl1271_tx_get_queue(queue),
+					 ps_scheme, CONF_ACK_POLICY_LEGACY,
+					 0, 0);
+		if (ret < 0)
+			goto out_sleep;
 
 out_sleep:
-	wl1271_ps_elp_sleep(wl);
+		wl1271_ps_elp_sleep(wl);
+	}
 
 out:
 	mutex_unlock(&wl->mutex);
-- 
1.7.1

