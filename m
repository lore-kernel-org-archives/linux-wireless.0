Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42862 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727199AbeHUJz5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:55:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:49 +0300
Message-Id: <20180821063657.30071-8-luca@coelho.fi> (sfid-20180821_083731_609649_B2DCF2FB)
In-Reply-To: <20180821063657.30071-1-luca@coelho.fi>
References: <20180821063657.30071-1-luca@coelho.fi>
Subject: [PATCH 07/15] iwlwifi: add 80211 hdr offset to trace data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

Every rx mpdu cmd is built from cmd_hdr | 80211_hdr.  The problem is
that the size of cmd_hdr changes with API changes and we don't know
where the 80211_hdr starts.

By adding the size of cmd_hdr dynamically, we can ensure that we always
know how to parse mpdu frames, without dependending on the API changes.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../intel/iwlwifi/iwl-devtrace-data.h         | 10 +++------
 .../intel/iwlwifi/iwl-devtrace-iwlwifi.h      | 14 +++++++-----
 .../net/wireless/intel/iwlwifi/iwl-devtrace.h | 22 +++++++++++--------
 3 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
index a80e4202cd03..2cc6c019d0e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
@@ -2,6 +2,7 @@
  *
  * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -12,10 +13,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
@@ -76,12 +73,11 @@ TRACE_EVENT(iwlwifi_dev_rx_data,
 	TP_ARGS(dev, trans, rxbuf, len),
 	TP_STRUCT__entry(
 		DEV_ENTRY
-
 		__dynamic_array(u8, data,
-				len - iwl_rx_trace_len(trans, rxbuf, len))
+				len - iwl_rx_trace_len(trans, rxbuf, len, NULL))
 	),
 	TP_fast_assign(
-		size_t offs = iwl_rx_trace_len(trans, rxbuf, len);
+		size_t offs = iwl_rx_trace_len(trans, rxbuf, len, NULL);
 		DEV_ASSIGN;
 		if (offs < len)
 			memcpy(__get_dynamic_array(data),
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
index 27e3e4e96aa2..82cfbfa0795d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
@@ -3,6 +3,7 @@
  * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -13,10 +14,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
@@ -75,13 +72,18 @@ TRACE_EVENT(iwlwifi_dev_rx,
 	TP_STRUCT__entry(
 		DEV_ENTRY
 		__field(u16, cmd)
-		__dynamic_array(u8, rxbuf, iwl_rx_trace_len(trans, pkt, len))
+		__field(u8, hdr_offset)
+		__dynamic_array(u8, rxbuf,
+				iwl_rx_trace_len(trans, pkt, len, NULL))
 	),
 	TP_fast_assign(
+		size_t hdr_offset = 0;
+
 		DEV_ASSIGN;
 		__entry->cmd = WIDE_ID(pkt->hdr.group_id, pkt->hdr.cmd);
 		memcpy(__get_dynamic_array(rxbuf), pkt,
-		       iwl_rx_trace_len(trans, pkt, len));
+		       iwl_rx_trace_len(trans, pkt, len, &hdr_offset));
+		__entry->hdr_offset = hdr_offset;
 	),
 	TP_printk("[%s] RX cmd %#.2x",
 		  __get_str(dev), __entry->cmd)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
index f5c1127253cb..fc649b2bc017 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
@@ -1,7 +1,8 @@
 /******************************************************************************
  *
  * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
- * Copyright(C) 2016 Intel Deutschland GmbH
+ * Copyright(C) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -12,10 +13,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  * The full GNU General Public License is included in this distribution in the
  * file called LICENSE.
  *
@@ -60,16 +57,23 @@ static inline bool iwl_trace_data(struct sk_buff *skb)
 }
 
 static inline size_t iwl_rx_trace_len(const struct iwl_trans *trans,
-				      void *rxbuf, size_t len)
+				      void *rxbuf, size_t len,
+				      size_t *out_hdr_offset)
 {
 	struct iwl_cmd_header *cmd = (void *)((u8 *)rxbuf + sizeof(__le32));
-	struct ieee80211_hdr *hdr;
+	struct ieee80211_hdr *hdr = NULL;
+	size_t hdr_offset;
 
 	if (cmd->cmd != trans->rx_mpdu_cmd)
 		return len;
 
-	hdr = (void *)((u8 *)cmd + sizeof(struct iwl_cmd_header) +
-			trans->rx_mpdu_cmd_hdr_size);
+	hdr_offset = sizeof(struct iwl_cmd_header) +
+		     trans->rx_mpdu_cmd_hdr_size;
+
+	if (out_hdr_offset)
+		*out_hdr_offset = hdr_offset;
+
+	hdr = (void *)((u8 *)cmd + hdr_offset);
 	if (!ieee80211_is_data(hdr->frame_control))
 		return len;
 	/* maybe try to identify EAPOL frames? */
-- 
2.18.0
