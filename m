Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51006 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933751AbdLRMi1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 07:38:27 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Dec 2017 14:38:11 +0200
Message-Id: <20171218123815.3968-8-luca@coelho.fi> (sfid-20171218_133850_037785_2BC2D6C5)
In-Reply-To: <20171218123815.3968-1-luca@coelho.fi>
References: <20171218123815.3968-1-luca@coelho.fi>
Subject: [PATCH 07/11] iwlwifi: add skb address to tx cmd in trace events data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

This helps matching tx cmd with other trace events, like net_dev_xmit
and net_dev_queue etc.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
index 7f16dcce0995..9518a82f44c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
@@ -95,7 +95,7 @@ TRACE_EVENT(iwlwifi_dev_tx,
 	TP_ARGS(dev, skb, tfd, tfdlen, buf0, buf0_len, hdr_len),
 	TP_STRUCT__entry(
 		DEV_ENTRY
-
+		__field(void *, skbaddr)
 		__field(size_t, framelen)
 		__dynamic_array(u8, tfd, tfdlen)
 
@@ -110,6 +110,7 @@ TRACE_EVENT(iwlwifi_dev_tx,
 	),
 	TP_fast_assign(
 		DEV_ASSIGN;
+		__entry->skbaddr = skb;
 		__entry->framelen = buf0_len;
 		if (hdr_len > 0)
 			__entry->framelen += skb->len - hdr_len;
@@ -120,9 +121,9 @@ TRACE_EVENT(iwlwifi_dev_tx,
 				      __get_dynamic_array(buf1),
 				      skb->len - hdr_len);
 	),
-	TP_printk("[%s] TX %.2x (%zu bytes)",
+	TP_printk("[%s] TX %.2x (%zu bytes) skbaddr=%p",
 		  __get_str(dev), ((u8 *)__get_dynamic_array(buf0))[0],
-		  __entry->framelen)
+		  __entry->framelen, __entry->skbaddr)
 );
 
 TRACE_EVENT(iwlwifi_dev_ucode_error,
-- 
2.15.1
