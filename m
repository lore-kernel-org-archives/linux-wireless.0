Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33667 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab1DYSPy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 14:15:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2.6.39 v2] iwlegacy: led stay solid on when no traffic
Date: Mon, 25 Apr 2011 11:12:57 -0700
Message-Id: <1303755177-28781-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110425_201556_810123_9EF0D66E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 843f26f06a41c5797f19e843c23ca4ed2a71a0bc change the led behavior
for iwlwifi driver; the side effect cause led blink all the time.

Modify the led blink table to fix this problem

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
v2: remove "-1" entry from table
---
 drivers/net/wireless/iwlegacy/iwl-led.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-led.c b/drivers/net/wireless/iwlegacy/iwl-led.c
index 15eb8b7..bda0d61 100644
--- a/drivers/net/wireless/iwlegacy/iwl-led.c
+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
@@ -48,8 +48,21 @@ module_param(led_mode, int, S_IRUGO);
 MODULE_PARM_DESC(led_mode, "0=system default, "
 		"1=On(RF On)/Off(RF Off), 2=blinking");
 
+/* Throughput		OFF time(ms)	ON time (ms)
+ *	>300			25		25
+ *	>200 to 300		40		40
+ *	>100 to 200		55		55
+ *	>70 to 100		65		65
+ *	>50 to 70		75		75
+ *	>20 to 50		85		85
+ *	>10 to 20		95		95
+ *	>5 to 10		110		110
+ *	>1 to 5			130		130
+ *	>0 to 1			167		167
+ *	<=0					SOLID ON
+ */
 static const struct ieee80211_tpt_blink iwl_blink[] = {
-	{ .throughput = 0 * 1024 - 1, .blink_time = 334 },
+	{ .throughput = 0, .blink_time = 334 },
 	{ .throughput = 1 * 1024 - 1, .blink_time = 260 },
 	{ .throughput = 5 * 1024 - 1, .blink_time = 220 },
 	{ .throughput = 10 * 1024 - 1, .blink_time = 190 },
@@ -101,6 +114,11 @@ static int iwl_legacy_led_cmd(struct iwl_priv *priv,
 	if (priv->blink_on == on && priv->blink_off == off)
 		return 0;
 
+	if (off == 0) {
+		/* led is SOLID_ON */
+		on = IWL_LED_SOLID;
+	}
+
 	IWL_DEBUG_LED(priv, "Led blink time compensation=%u\n",
 			priv->cfg->base_params->led_compensation);
 	led_cmd.on = iwl_legacy_blink_compensation(priv, on,
-- 
1.7.0.4

