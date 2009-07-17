Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:47318 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934735AbZGQQab (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:31 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/14] iwlwifi: Led blinking counting both tx and rx
Date: Fri, 17 Jul 2009 09:30:20 -0700
Message-Id: <1247848227-24031-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-7-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-5-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For controlling led blinking, counting both tx and rx data traffic; this
will be able to handle traffic in either direction

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-led.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 36d88a0..8c81152 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -54,7 +54,7 @@ static const char *led_type_str[] = {
 
 
 static const struct {
-	u16 tpt;
+	u16 tpt;	/* Mb/s */
 	u8 on_time;
 	u8 off_time;
 } blink_tbl[] =
@@ -264,13 +264,15 @@ static int iwl_leds_register_led(struct iwl_priv *priv, struct iwl_led *led,
 
 
 /*
- * calculate blink rate according to last 2 sec Tx/Rx activities
+ * calculate blink rate according to last second Tx/Rx activities
  */
 static int iwl_get_blink_rate(struct iwl_priv *priv)
 {
 	int i;
-	u64 current_tpt = priv->tx_stats[2].bytes;
-	/* FIXME: + priv->rx_stats[2].bytes; */
+	/* count both tx and rx traffic to be able to
+	 * handle traffic in either direction
+	 */
+	u64 current_tpt = priv->tx_stats[2].bytes + priv->rx_stats[2].bytes;
 	s64 tpt = current_tpt - priv->led_tpt;
 
 	if (tpt < 0) /* wraparound */
-- 
1.5.6.3

