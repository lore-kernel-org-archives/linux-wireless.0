Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41176 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab0F2TpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:45:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: do not export iwl_leds_background
Date: Tue, 29 Jun 2010 15:39:38 -0400
Message-Id: <1277840378-18305-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
References: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is only used from within the iwlcore module.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-led.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index db5bfcb..486244b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -214,7 +214,6 @@ void iwl_leds_background(struct iwl_priv *priv)
 	priv->last_blink_time = jiffies;
 	priv->last_blink_rate = blink_idx;
 }
-EXPORT_SYMBOL(iwl_leds_background);
 
 void iwl_leds_init(struct iwl_priv *priv)
 {
-- 
1.7.0.1

