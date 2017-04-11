Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50568 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754737AbdDKMiD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:38:03 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:24 +0300
Message-Id: <20170411123742.12214-8-luca@coelho.fi> (sfid-20170411_143807_566330_9532A078)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 07/25] iwlwifi: mvm: fix RX SKB header size and align it properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When receiving a frame, we currently pull in sizeof(*hdr) plus
some extra (crypto/snap), which is too much, most headers aren't
actually sizeof(*hdr) since that takes into account the 4-address
format but doesn't take into account QoS. As a result, a typical
frame will have 4 bytes of the payload in the SKB header already.

Fix this by calculating the correct header length, and now that
we have that, align the end of the SKB header to a multiple of 4
so that the IP header will be aligned properly when pulled in.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 20473df79c94..c1bf67f04cf6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -104,7 +104,20 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 					    u8 crypt_len,
 					    struct iwl_rx_cmd_buffer *rxb)
 {
-	unsigned int hdrlen, fraglen;
+	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	unsigned int fraglen;
+
+	/*
+	 * The 'hdrlen' (plus the 8 bytes for the SNAP and the crypt_len,
+	 * but those are all multiples of 4 long) all goes away, but we
+	 * want the *end* of it, which is going to be the start of the IP
+	 * header, to be aligned when it gets pulled in.
+	 * The beginning of the skb->data is aligned on at least a 4-byte
+	 * boundary after allocation. Everything here is aligned at least
+	 * on a 2-byte boundary so we can just take hdrlen & 3 and pad by
+	 * the result.
+	 */
+	skb_reserve(skb, hdrlen & 3);
 
 	/* If frame is small enough to fit in skb->head, pull it completely.
 	 * If not, only pull ieee80211_hdr (including crypto if present, and
@@ -118,8 +131,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 	 * If the latter changes (there are efforts in the standards group
 	 * to do so) we should revisit this and ieee80211_data_to_8023().
 	 */
-	hdrlen = (len <= skb_tailroom(skb)) ? len :
-					      sizeof(*hdr) + crypt_len + 8;
+	hdrlen = (len <= skb_tailroom(skb)) ? len : hdrlen + crypt_len + 8;
 
 	memcpy(skb_put(skb, hdrlen), hdr, hdrlen);
 	fraglen = len - hdrlen;
-- 
2.11.0
