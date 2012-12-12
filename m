Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35620 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2LLIPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 03:15:07 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id qBC8F71G020514
	for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2012 02:15:07 -0600
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qBC8F7xp006415
	for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2012 02:15:07 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH] wlcore: use single-role version when verifying the PLT firmware
Date: Wed, 12 Dec 2012 10:14:22 +0200
Message-ID: <1355300062-19677-1-git-send-email-coelho@ti.com> (sfid-20121212_091511_515169_B03DEF26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PLT firmware used by wl12xx for calibration always has the same
version number as the single-role firmware.

Currntly the driver rejects the PLT firmware since anything that is
not single-role uses the multi-role version.  Fix this by using the
single-role version for everything except multi-role.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/boot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index b58ae5f..77752b0 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -84,8 +84,8 @@ out:
 static int wlcore_validate_fw_ver(struct wl1271 *wl)
 {
 	unsigned int *fw_ver = wl->chip.fw_ver;
-	unsigned int *min_ver = (wl->fw_type == WL12XX_FW_TYPE_NORMAL) ?
-		wl->min_sr_fw_ver : wl->min_mr_fw_ver;
+	unsigned int *min_ver = (wl->fw_type == WL12XX_FW_TYPE_MULTI) ?
+		wl->min_mr_fw_ver : wl->min_sr_fw_ver;
 	char min_fw_str[32] = "";
 	int i;
 
-- 
1.7.10.4

