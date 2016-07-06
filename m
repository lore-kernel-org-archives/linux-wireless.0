Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33450 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753651AbcGFKoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:44 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:41 +0300
Message-Id: <1467801651-1816-46-git-send-email-luca@coelho.fi> (sfid-20160706_124448_421502_2CB9C3EC)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 46/56] iwlwifi: tracing: decouple from mac80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to be able to properly record SKBs that didn't come through
mac80211, don't rely on the IEEE80211_TX_CTRL_PORT_CTRL_PROTO flag
but instead check for ETH_P_PAE directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h | 25 ++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
index f4d3cd0..545d14b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(C) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -33,11 +34,29 @@
 static inline bool iwl_trace_data(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	__le16 fc = hdr->frame_control;
+	int offs = 24; /* start with normal header length */
 
-	if (!ieee80211_is_data(hdr->frame_control))
+	if (!ieee80211_is_data(fc))
 		return false;
-	return !(info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO);
+
+	/* Try to determine if the frame is EAPOL. This might have false
+	 * positives (if there's no RFC 1042 header and we compare to some
+	 * payload instead) but since we're only doing tracing that's not
+	 * a problem.
+	 */
+
+	if (ieee80211_has_a4(fc))
+		offs += 6;
+	if (ieee80211_is_data_qos(fc))
+		offs += 2;
+	/* don't account for crypto - these are unencrypted */
+
+	/* also account for the RFC 1042 header, of course */
+	offs += 6;
+
+	return skb->len > offs + 2 &&
+	       *(__be16 *)(skb->data + offs) == cpu_to_be16(ETH_P_PAE);
 }
 
 static inline size_t iwl_rx_trace_len(const struct iwl_trans *trans,
-- 
2.8.1

