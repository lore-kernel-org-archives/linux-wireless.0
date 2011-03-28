Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:59390 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab1C1Hca (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 03:32:30 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p2S7WUj2016493
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 02:32:30 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: Set correct REF CLK and TCXO CLK values to the FW
Date: Mon, 28 Mar 2011 09:34:51 +0200
Message-Id: <1301297691-27665-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the correct values to the FW of REF CLK and TCXO CLK from
wl12xx_platform_data to ini_general_params.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/cmd.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 2468044..beb9f88 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -129,6 +129,9 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 	if (gp->tx_bip_fem_auto_detect)
 		answer = true;
 
+	/* Set the ref CLK value */
+	gen_parms->general_params.ref_clock = wl->ref_clock;
+
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
 	if (ret < 0) {
 		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
@@ -168,6 +171,13 @@ int wl128x_cmd_general_parms(struct wl1271 *wl)
 	if (gp->tx_bip_fem_auto_detect)
 		answer = true;
 
+	/*
+	 * Set the ref CLK & TCXO values.
+	 * The HW will know which of them is the valid one due to boot setting.
+	 */
+	gen_parms->general_params.ref_clock = wl->ref_clock;
+	gen_parms->general_params.tcxo_ref_clock = wl->tcxo_clock;
+
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
 	if (ret < 0) {
 		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
-- 
1.7.0.4

