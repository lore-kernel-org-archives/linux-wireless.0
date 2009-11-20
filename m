Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42088 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234AbZKTUFL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:11 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 18/19] iwlwifi: remove reset led_tpt from iwl_leds_init()
Date: Fri, 20 Nov 2009 12:05:09 -0800
Message-Id: <1258747510-21233-19-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Current blinking rate is calculated based on the difference between
current tx/rx byte counts and priv->led_tpt.

priv->led_tpt should not get reset in iwl_leds_init(), this function can be
called by bring interface "up" or "down", or when uCode sysassert occurred.
resetting the led_tpt parameter will introduce incorrect led blinking behavior.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-led.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 478c905..46c7a95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -219,7 +219,6 @@ EXPORT_SYMBOL(iwl_leds_background);
 void iwl_leds_init(struct iwl_priv *priv)
 {
 	priv->last_blink_rate = 0;
-	priv->led_tpt = 0;
 	priv->last_blink_time = 0;
 	priv->allow_blinking = 0;
 }
-- 
1.5.6.3

