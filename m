Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1927 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbcCBH6M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:58:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/43] iwlwifi: mvm: take care of padded packets
Date: Wed,  2 Mar 2016 09:56:34 +0200
Message-Id: <1456905404-14435-33-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085951_745351_44BEB4BA)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

To ensure that the SNAP/TCP/IP headers are DW aligned, the firmware
may add 2-byte pad at the end of the mac header - after the IV, before
the SNAP.
In that case the mpdu descriptor pad bit will be turned on.
Driver should take it into consideration, and remove the padding before
passing the packet to mac80211. Do that.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 30 ++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 590fc6f..cd6ca37 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -29,7 +29,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -156,7 +156,14 @@ static void iwl_mvm_create_skb(struct sk_buff *skb, struct ieee80211_hdr *hdr,
 			       u16 len, u8 crypt_len,
 			       struct iwl_rx_cmd_buffer *rxb)
 {
-	unsigned int hdrlen, fraglen;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_rx_mpdu_desc *desc = (void *)pkt->data;
+	unsigned int headlen, fraglen, pad_len = 0;
+	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+	if (desc->mac_flags2 & IWL_RX_MPDU_MFLG2_PAD)
+		pad_len = 2;
+	len -= pad_len;
 
 	/* If frame is small enough to fit in skb->head, pull it completely.
 	 * If not, only pull ieee80211_hdr (including crypto if present, and
@@ -170,14 +177,23 @@ static void iwl_mvm_create_skb(struct sk_buff *skb, struct ieee80211_hdr *hdr,
 	 * If the latter changes (there are efforts in the standards group
 	 * to do so) we should revisit this and ieee80211_data_to_8023().
 	 */
-	hdrlen = (len <= skb_tailroom(skb)) ? len :
-					      sizeof(*hdr) + crypt_len + 8;
+	headlen = (len <= skb_tailroom(skb)) ? len :
+					       hdrlen + crypt_len + 8;
 
+	/* The firmware may align the packet to DWORD.
+	 * The padding is inserted after the IV.
+	 * After copying the header + IV skip the padding if
+	 * present before copying packet data.
+	 */
+	hdrlen += crypt_len;
 	memcpy(skb_put(skb, hdrlen), hdr, hdrlen);
-	fraglen = len - hdrlen;
+	memcpy(skb_put(skb, headlen - hdrlen), (u8 *)hdr + hdrlen + pad_len,
+	       headlen - hdrlen);
+
+	fraglen = len - headlen;
 
 	if (fraglen) {
-		int offset = (void *)hdr + hdrlen -
+		int offset = (void *)hdr + headlen + pad_len -
 			     rxb_addr(rxb) + rxb_offset(rxb);
 
 		skb_add_rx_frag(skb, 0, rxb_steal_page(rxb), offset,
-- 
2.5.0

