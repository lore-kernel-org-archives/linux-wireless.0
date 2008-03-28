Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124AbYC1XZd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:25:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/8] iwlwifi: LED initialize before registering
Date: Fri, 28 Mar 2008 16:21:11 -0700
Message-Id: <1206746472-10443-8-git-send-email-reinette.chatre@intel.com> (sfid-20080328_232538_348020_773A260F)
In-Reply-To: <1206746472-10443-7-git-send-email-reinette.chatre@intel.com>
References: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-2-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-3-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-4-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-5-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-6-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch initialize all fields in led before registering it
This fixes oops on initialization

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-led.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index d59ad18..4fe5ee2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -238,18 +238,20 @@ static int iwl_leds_register_led(struct iwl_priv *priv,
 	led->led_dev.brightness_set = iwl4965_led_brightness_set;
 	led->led_dev.default_trigger = trigger;
 
+	led->priv = priv;
+	led->type = type;
+
 	ret = led_classdev_register(device, &led->led_dev);
 	if (ret) {
 		IWL_ERROR("Error: failed to register led handler.\n");
 		return ret;
 	}
 
-	led->priv = priv;
-	led->type = type;
 	led->registered = 1;
 
 	if (set_led && led->led_on)
 		led->led_on(priv, IWL_LED_LINK);
+
 	return 0;
 }
 
-- 
1.5.3.4

