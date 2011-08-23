Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58136 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab1HWMzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:55:12 -0400
Received: by fxh19 with SMTP id 19so213173fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 05:55:11 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wl12xx: allow 11a AP-mode for wl127x devices
Date: Tue, 23 Aug 2011 15:56:22 +0300
Message-Id: <1314104183-31612-1-git-send-email-eliad@wizery.com> (sfid-20110823_145516_715134_54277076)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

There was a check preventing 127x devices from using the 11a band when
operating as AP. Since we now support this functionality, remove the
check.

With this patch, a 11a AP starts ok on 127x cards.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index cc70422..6d5664b 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -294,9 +294,7 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 		 */
 		if (wl->nvs_len == sizeof(struct wl1271_nvs_file) ||
 		    wl->nvs_len == WL1271_INI_LEGACY_NVS_FILE_SIZE) {
-			/* for now 11a is unsupported in AP mode */
-			if (wl->bss_type != BSS_TYPE_AP_BSS &&
-			    nvs->general_params.dual_mode_select)
+			if (nvs->general_params.dual_mode_select)
 				wl->enable_11a = true;
 		}
 
-- 
1.7.6.401.g6a319

