Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56712 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1DCKxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2011 06:53:16 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p33ArFs3004646
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 3 Apr 2011 05:53:16 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH v2] wl12xx: Set correct REF CLK and TCXO CLK values to the FW
Date: Sun,  3 Apr 2011 13:54:54 +0300
Message-Id: <1301828094-29569-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix mismatch between the REF CLK and TCXO CLK information that is
set in the platform data and the NVS, so we override what comes
from the NVS and replace it with what comes from the platform data.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/cmd.c |   11 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 2468044..beb9f88 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -129,6 +129,9 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 	if (gp->tx_bip_fem_auto_detect)
 		answer = true;
 
+	/* Override the REF CLK from the NVS with the one from platform data */
+	gen_parms->general_params.ref_clock = wl->ref_clock;
+
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
 	if (ret < 0) {
 		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
@@ -168,6 +171,14 @@ int wl128x_cmd_general_parms(struct wl1271 *wl)
 	if (gp->tx_bip_fem_auto_detect)
 		answer = true;
 
+	/*
+	 * Override the REF&TCXO CLKs from the NVS with the one from platform
+	 * data.
+	 * FW use the relevant CLK (REF or TCXO) according to the boot sequence
+	 */
+	gen_parms->general_params.ref_clock = wl->ref_clock;
+	gen_parms->general_params.tcxo_ref_clock = wl->tcxo_clock;
+
 	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
 	if (ret < 0) {
 		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
-- 
1.7.0.4

