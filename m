Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbbEZTTF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:19:05 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/39] iwlwifi: tracing: add rx cmd header fields
Date: Tue, 26 May 2015 22:17:47 +0300
Message-Id: <1432667872-18092-34-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211911_613514_B15EEF18)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Having explicit rx cmd header fields is useful, as it can
be used for event filtering (e.g. saving only debug logs,
rather than the whole data)

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h b/drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h
index 223b875..948ce08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -64,19 +65,21 @@ TRACE_EVENT(iwlwifi_dev_hcmd,
 
 TRACE_EVENT(iwlwifi_dev_rx,
 	TP_PROTO(const struct device *dev, const struct iwl_trans *trans,
-		 void *rxbuf, size_t len),
-	TP_ARGS(dev, trans, rxbuf, len),
+		 struct iwl_rx_packet *pkt, size_t len),
+	TP_ARGS(dev, trans, pkt, len),
 	TP_STRUCT__entry(
 		DEV_ENTRY
-		__dynamic_array(u8, rxbuf, iwl_rx_trace_len(trans, rxbuf, len))
+		__field(u8, cmd)
+		__dynamic_array(u8, rxbuf, iwl_rx_trace_len(trans, pkt, len))
 	),
 	TP_fast_assign(
 		DEV_ASSIGN;
-		memcpy(__get_dynamic_array(rxbuf), rxbuf,
-		       iwl_rx_trace_len(trans, rxbuf, len));
+		__entry->cmd = pkt->hdr.cmd;
+		memcpy(__get_dynamic_array(rxbuf), pkt,
+		       iwl_rx_trace_len(trans, pkt, len));
 	),
 	TP_printk("[%s] RX cmd %#.2x",
-		  __get_str(dev), ((u8 *)__get_dynamic_array(rxbuf))[4])
+		  __get_str(dev), __entry->cmd)
 );
 
 TRACE_EVENT(iwlwifi_dev_tx,
-- 
2.1.4

