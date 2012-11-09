Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54765 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2KIUJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:09:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 12/13] iwlwifi: fix typo in RX data tracing
Date: Fri,  9 Nov 2012 21:08:11 +0100
Message-Id: <1352491692-28994-13-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210912_164545_F716CC09)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The printk message should say RX, not TX.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 678717b..b3fde5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -306,7 +306,7 @@ TRACE_EVENT(iwlwifi_dev_rx_data,
 			memcpy(__get_dynamic_array(data),
 			       ((u8 *)rxbuf) + offs, len - offs);
 	),
-	TP_printk("[%s] TX frame data", __get_str(dev))
+	TP_printk("[%s] RX frame data", __get_str(dev))
 );
 
 #undef TRACE_SYSTEM
-- 
1.8.0

