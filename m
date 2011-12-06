Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63073 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933074Ab1LFKO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 05:14:58 -0500
Received: by mail-lpp01m010-f46.google.com with SMTP id p5so1487299lag.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2011 02:14:57 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] wl12xx: remove redundant commands from plt init
Date: Tue,  6 Dec 2011 12:15:06 +0200
Message-Id: <1323166507-32470-2-git-send-email-eliad@wizery.com> (sfid-20111206_111501_265215_A9F1D9F9)
In-Reply-To: <1323166507-32470-1-git-send-email-eliad@wizery.com>
References: <1323166507-32470-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During plt init we configure some redundant commands,
which are not needed for plt (specifically, we shouldn't
configure any role-specific params, as there are no
active roles). remove them.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   61 +-----------------------------------
 1 files changed, 1 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f4113fe..7e72604 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -641,9 +641,7 @@ static void wl1271_conf_init(struct wl1271 *wl)
 
 static int wl1271_plt_init(struct wl1271 *wl)
 {
-	struct conf_tx_ac_category *conf_ac;
-	struct conf_tx_tid *conf_tid;
-	int ret, i;
+	int ret;
 
 	if (wl->chip.id == CHIP_ID_1283_PG20)
 		ret = wl128x_cmd_general_parms(wl);
@@ -672,10 +670,6 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_init_templates_config(wl);
-	if (ret < 0)
-		return ret;
-
 	ret = wl1271_acx_init_mem_config(wl);
 	if (ret < 0)
 		return ret;
@@ -685,63 +679,10 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
-	ret = wl1271_acx_dco_itrim_params(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
-	/* Initialize connection monitoring thresholds */
-	ret = wl1271_acx_conn_monit_params(wl, NULL, false); /* TODO: fix */
-	if (ret < 0)
-		goto out_free_memmap;
-
-	/* Bluetooth WLAN coexistence */
-	ret = wl1271_init_pta(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
-	/* FM WLAN coexistence */
-	ret = wl1271_acx_fm_coex(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
-	/* Energy detection */
-	ret = wl1271_init_energy_detection(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
 	ret = wl12xx_acx_mem_cfg(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Default fragmentation threshold */
-	ret = wl1271_acx_frag_threshold(wl, wl->conf.tx.frag_threshold);
-	if (ret < 0)
-		goto out_free_memmap;
-
-	/* Default TID/AC configuration */
-	BUG_ON(wl->conf.tx.tid_conf_count != wl->conf.tx.ac_conf_count);
-	for (i = 0; i < wl->conf.tx.tid_conf_count; i++) {
-		conf_ac = &wl->conf.tx.ac_conf[i];
-		/* TODO: fix */
-		ret = wl1271_acx_ac_cfg(wl, NULL, conf_ac->ac, conf_ac->cw_min,
-					conf_ac->cw_max, conf_ac->aifsn,
-					conf_ac->tx_op_limit);
-		if (ret < 0)
-			goto out_free_memmap;
-
-		conf_tid = &wl->conf.tx.tid_conf[i];
-		/* TODO: fix */
-		ret = wl1271_acx_tid_cfg(wl, NULL, conf_tid->queue_id,
-					 conf_tid->channel_type,
-					 conf_tid->tsid,
-					 conf_tid->ps_scheme,
-					 conf_tid->ack_policy,
-					 conf_tid->apsd_conf[0],
-					 conf_tid->apsd_conf[1]);
-		if (ret < 0)
-			goto out_free_memmap;
-	}
-
 	/* Enable data path */
 	ret = wl1271_cmd_data_path(wl, 1);
 	if (ret < 0)
-- 
1.7.6.401.g6a319

