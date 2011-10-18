Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64751 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab1JRHXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 03:23:49 -0400
Received: by bkbzt19 with SMTP id zt19so452366bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 00:23:48 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>, stable@kernel.org
Subject: [PATCH 1/2] wl12xx: Validate FEM index from ini file and FW
Date: Tue, 18 Oct 2011 09:23:41 +0200
Message-Id: <1318922622-8356-2-git-send-email-pontus.fuchs@gmail.com> (sfid-20111018_092358_166684_1E407A18)
In-Reply-To: <1318922622-8356-1-git-send-email-pontus.fuchs@gmail.com>
References: <1318922622-8356-1-git-send-email-pontus.fuchs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check for out of bound FEM index to prevent reading beyond ini
memory end.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: stable@kernel.org
Reviewed-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/cmd.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 2413c43..38a21a3 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -121,6 +121,11 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 	if (!wl->nvs)
 		return -ENODEV;
 
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from INI out of bounds");
+		return -EINVAL;
+	}
+
 	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
 	if (!gen_parms)
 		return -ENOMEM;
@@ -144,6 +149,12 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
 	gp->tx_bip_fem_manufacturer =
 		gen_parms->general_params.tx_bip_fem_manufacturer;
 
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from FW out of bounds");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
 		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
 
@@ -163,6 +174,11 @@ int wl128x_cmd_general_parms(struct wl1271 *wl)
 	if (!wl->nvs)
 		return -ENODEV;
 
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from ini out of bounds");
+		return -EINVAL;
+	}
+
 	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
 	if (!gen_parms)
 		return -ENOMEM;
@@ -187,6 +203,12 @@ int wl128x_cmd_general_parms(struct wl1271 *wl)
 	gp->tx_bip_fem_manufacturer =
 		gen_parms->general_params.tx_bip_fem_manufacturer;
 
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from FW out of bounds");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
 		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
 
-- 
1.7.4.1

