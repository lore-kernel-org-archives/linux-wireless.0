Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:32901 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbcAXMfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2016 07:35:17 -0500
Received: by mail-lb0-f175.google.com with SMTP id x4so62105476lbm.0
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2016 04:35:17 -0800 (PST)
From: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: egrumbach@gmail.com, hubert.tarasiuk@gmail.com
Subject: [PATCH] iwlwifi: dvm: handle zero brightness for wifi LED
Date: Sun, 24 Jan 2016 13:35:06 +0100
Message-Id: <1453638906-19648-1-git-send-email-hubert.tarasiuk@gmail.com> (sfid-20160124_133551_472484_A9F6F530)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes bug 110551 with regard to sysfs.

Misleading behaviour when 'led_mode=3' is passed to iwlwifi is still
to be fixed (either by changing the option description or by making
the LED permanently dark in such case).

Signed-off-by: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
---
 drivers/net/wireless/iwlwifi/dvm/led.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/led.c b/drivers/net/wireless/iwlwifi/dvm/led.c
index ca4d669..218617a 100644
--- a/drivers/net/wireless/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/iwlwifi/dvm/led.c
@@ -154,11 +154,14 @@ static void iwl_led_brightness_set(struct led_classdev *led_cdev,
 {
 	struct iwl_priv *priv = container_of(led_cdev, struct iwl_priv, led);
 	unsigned long on = 0;
+	unsigned long off = 0;
 
 	if (brightness > 0)
 		on = IWL_LED_SOLID;
+	else
+		off = IWL_LED_SOLID;
 
-	iwl_led_cmd(priv, on, 0);
+	iwl_led_cmd(priv, on, off);
 }
 
 static int iwl_led_blink_set(struct led_classdev *led_cdev,
-- 
2.7.0

