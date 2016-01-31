Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9395 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256AbcAaLGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:34 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/31] iwlwifi: dvm: handle zero brightness for wifi LED
Date: Sun, 31 Jan 2016 13:06:03 +0200
Message-Id: <1454238386-27032-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120638_669156_7A4C7EA6)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>

In order to have the LED being OFF constantly when the
brightness is set to 0, we need to pass IWL_LED_SOLID to
iwl_led_cmd as the off parameter, otherwise the led will
stay on constantly.

This fixes
https://bugzilla.kernel.org/show_bug.cgi?id=110551

Signed-off-by: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
[reworked the commit message]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/led.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/led.c b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
index 1aabb5e..1bbd17a 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
@@ -152,11 +152,14 @@ static void iwl_led_brightness_set(struct led_classdev *led_cdev,
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
2.5.0

