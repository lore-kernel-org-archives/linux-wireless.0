Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:63003 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759043Ab0JGHQ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 03:16:57 -0400
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o977Gt9F003653
	for <linux-wireless@vger.kernel.org>; Thu, 7 Oct 2010 10:16:55 +0300
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl1271: Support FEM autodetection
Date: Thu,  7 Oct 2010 10:16:42 +0300
Message-Id: <1286435802-8152-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

In the NVS/INI-parameters for the driver/firmware there is the FEM
(front end module) selection option, which may configure the hardware FEM
via autodetection or manual selection. So far, there has been support for
manual selection only.

Add support for FEM autodetection.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 596e333..5d3e848 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -108,6 +108,8 @@ out:
 int wl1271_cmd_general_parms(struct wl1271 *wl)
 {
 	struct wl1271_general_parms_cmd *gen_parms;
+	struct wl1271_ini_general_params *gp = &wl->nvs->general_params;
+	bool answer = false;
 	int ret;
 
 	if (!wl->nvs)
@@ -119,13 +121,24 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 
 	gen_parms->test.id = TEST_CMD_INI_FILE_GENERAL_PARAM;
 
-	memcpy(&gen_parms->general_params, &wl->nvs->general_params,
-	       sizeof(struct wl1271_ini_general_params));
+	memcpy(&gen_parms->general_params, gp, sizeof(*gp));
 
-	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), 0);
-	if (ret < 0)
+	if (gp->tx_bip_fem_auto_detect)
+		answer = true;
+
+	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
+	if (ret < 0) {
 		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
+		goto out;
+	}
+
+	gp->tx_bip_fem_manufacturer =
+		gen_parms->general_params.tx_bip_fem_manufacturer;
 
+	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
+		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
+
+out:
 	kfree(gen_parms);
 	return ret;
 }
-- 
1.7.0.4

