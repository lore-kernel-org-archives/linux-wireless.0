Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35893 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1LRSYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 13:24:53 -0500
Received: by wgbdr13 with SMTP id dr13so9434272wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2011 10:24:52 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/7] wl12xx: remove redundant code from wl1271_op_conf_tx
Date: Sun, 18 Dec 2011 20:25:40 +0200
Message-Id: <1324232745-22928-3-git-send-email-eliad@wizery.com> (sfid-20111218_192457_025921_4EADBCBD)
In-Reply-To: <1324232745-22928-1-git-send-email-eliad@wizery.com>
References: <1324232745-22928-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the conf_tx callback passes the vif as param,
we must have been added first (and mac80211 verifies it).

Remove the handling of such case.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   25 +------------------------
 1 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 86a7ee3..17e62e4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3958,31 +3958,8 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw,
 	else
 		ps_scheme = CONF_PS_SCHEME_LEGACY;
 
-	if (wl->state == WL1271_STATE_OFF) {
-		/*
-		 * If the state is off, the parameters will be recorded and
-		 * configured on init. This happens in AP-mode.
-		 */
-		struct conf_tx_ac_category *conf_ac =
-			&wl->conf.tx.ac_conf[wl1271_tx_get_queue(queue)];
-		struct conf_tx_tid *conf_tid =
-			&wl->conf.tx.tid_conf[wl1271_tx_get_queue(queue)];
-
-		conf_ac->ac = wl1271_tx_get_queue(queue);
-		conf_ac->cw_min = (u8)params->cw_min;
-		conf_ac->cw_max = params->cw_max;
-		conf_ac->aifsn = params->aifs;
-		conf_ac->tx_op_limit = params->txop << 5;
-
-		conf_tid->queue_id = wl1271_tx_get_queue(queue);
-		conf_tid->channel_type = CONF_CHANNEL_TYPE_EDCF;
-		conf_tid->tsid = wl1271_tx_get_queue(queue);
-		conf_tid->ps_scheme = ps_scheme;
-		conf_tid->ack_policy = CONF_ACK_POLICY_LEGACY;
-		conf_tid->apsd_conf[0] = 0;
-		conf_tid->apsd_conf[1] = 0;
+	if (!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags))
 		goto out;
-	}
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
-- 
1.7.6.401.g6a319

