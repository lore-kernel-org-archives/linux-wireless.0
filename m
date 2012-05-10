Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50831 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371Ab2EJJQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:23 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so247958wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:22 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 51/78] wl18xx: add a module parameter to control 11a support
Date: Thu, 10 May 2012 12:13:56 +0300
Message-Id: <1336641263-5761-52-git-send-email-arik@wizery.com> (sfid-20120510_111638_424995_9B061DB7)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

In wl18xx we don't have an NVS yet, so we need to control whether 11a
is supported with a module parameter for now.  11a support is enabled
by default and can be changed by setting enable_11a to false when
loading the module.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 52d63ff..d4e331f 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -48,6 +48,7 @@ static bool dc2dc_param = false;
 static int n_antennas_2_param = 1;
 static int n_antennas_5_param = 1;
 static bool checksum_param = true;
+static bool enable_11a_param = true;
 
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
@@ -1097,6 +1098,8 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 		wl18xx_ops.init_vif = NULL;
 	}
 
+	wl->enable_11a = enable_11a_param;
+
 	wl18xx_conf_init(wl);
 
 	return wlcore_probe(wl, pdev);
@@ -1149,6 +1152,9 @@ MODULE_PARM_DESC(n_antennas_5, "Number of installed 5GHz antennas: 1 (default) o
 module_param_named(checksum, checksum_param, bool, S_IRUSR);
 MODULE_PARM_DESC(checksum, "Enable TCP checksum: boolean (defaults to true)");
 
+module_param_named(enable_11a, enable_11a_param, bool, S_IRUSR);
+MODULE_PARM_DESC(enable_11a, "Enable 11a (5GHz): boolean (defaults to true)");
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_FIRMWARE(WL18XX_FW_NAME);
-- 
1.7.9.5

