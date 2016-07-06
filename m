Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33210 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753353AbcGFKlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:41:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:02 +0300
Message-Id: <1467801651-1816-7-git-send-email-luca@coelho.fi> (sfid-20160706_124136_709762_D91A36CF)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 07/56] iwlwifi: mvm: remove an unused variable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

We never initialize ampdu_status so it causes a static checker warning
when we pass it to iwl_mvm_pass_packet_to_mac80211().  Fortunately, it's
never used so we can just remove it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 6d096b6..2d5a7cc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -101,7 +101,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 					    struct napi_struct *napi,
 					    struct sk_buff *skb,
 					    struct ieee80211_hdr *hdr, u16 len,
-					    u32 ampdu_status, u8 crypt_len,
+					    u8 crypt_len,
 					    struct iwl_rx_cmd_buffer *rxb)
 {
 	unsigned int hdrlen, fraglen;
@@ -268,7 +268,6 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	struct ieee80211_sta *sta = NULL;
 	struct sk_buff *skb;
 	u32 len;
-	u32 ampdu_status;
 	u32 rate_n_flags;
 	u32 rx_pkt_status;
 	u8 crypt_len = 0;
@@ -480,7 +479,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 		iwl_mvm_ref(mvm, IWL_MVM_REF_RX);
 
 	iwl_mvm_pass_packet_to_mac80211(mvm, sta, napi, skb, hdr, len,
-					ampdu_status, crypt_len, rxb);
+					crypt_len, rxb);
 
 	if (take_ref)
 		iwl_mvm_unref(mvm, IWL_MVM_REF_RX);
-- 
2.8.1

