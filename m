Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6844C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0588218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbfAaUXM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:23:12 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53718 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUXL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:23:11 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqs-0004pL-MK; Thu, 31 Jan 2019 22:22:23 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:21:55 +0200
Message-Id: <20190131202206.15903-11-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/21] iwlwifi: mvm: don't hide HE radiotap data in SKB
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Hiding the HE radiotap data for further processing of the SKB just
caused another bug when adding the L-SIG data. Simply stop doing
this and adjust the skb->data pointer accordingly when we need to
get the 802.11 header.

While at it, also verify and fix the data alignment, we need to add
2 bytes padding with the vendor data to ensure the whole length of
all radiotap headers is a multiple of 4.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 6721039d5b8a ("iwlwifi: mvm: add L-SIG length to radiotap")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 47 ++++++++++++++-----
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index d2728fe6a041..957d99932e8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -66,11 +66,37 @@
 #include "mvm.h"
 #include "fw-api.h"
 
+static void *iwl_mvm_skb_get_hdr(struct sk_buff *skb)
+{
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
+	u8 *data = skb->data;
+
+	/* Alignment concerns */
+	BUILD_BUG_ON(sizeof(struct ieee80211_radiotap_he) % 4);
+	BUILD_BUG_ON(sizeof(struct ieee80211_radiotap_he_mu) % 4);
+	BUILD_BUG_ON(sizeof(struct ieee80211_radiotap_lsig) % 4);
+	BUILD_BUG_ON(sizeof(struct ieee80211_vendor_radiotap) % 4);
+
+	if (rx_status->flag & RX_FLAG_RADIOTAP_HE)
+		data += sizeof(struct ieee80211_radiotap_he);
+	if (rx_status->flag & RX_FLAG_RADIOTAP_HE_MU)
+		data += sizeof(struct ieee80211_radiotap_he_mu);
+	if (rx_status->flag & RX_FLAG_RADIOTAP_LSIG)
+		data += sizeof(struct ieee80211_radiotap_lsig);
+	if (rx_status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA) {
+		struct ieee80211_vendor_radiotap *radiotap = (void *)data;
+
+		data += sizeof(*radiotap) + radiotap->len + radiotap->pad;
+	}
+
+	return data;
+}
+
 static inline int iwl_mvm_check_pn(struct iwl_mvm *mvm, struct sk_buff *skb,
 				   int queue, struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_sta *mvmsta;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_hdr *hdr = iwl_mvm_skb_get_hdr(skb);
 	struct ieee80211_rx_status *stats = IEEE80211_SKB_RXCB(skb);
 	struct iwl_mvm_key_pn *ptk_pn;
 	int res;
@@ -197,12 +223,15 @@ static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
 {
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_vendor_radiotap *radiotap;
-	int size = sizeof(*radiotap) + sizeof(__le16);
+	const int size = sizeof(*radiotap) + sizeof(__le16);
 
 	if (!mvm->cur_aid)
 		return;
 
-	radiotap = skb_put(skb, size);
+	/* ensure alignment */
+	BUILD_BUG_ON((size + 2) % 4);
+
+	radiotap = skb_put(skb, size + 2);
 	radiotap->align = 1;
 	/* Intel OUI */
 	radiotap->oui[0] = 0xf6;
@@ -212,10 +241,12 @@ static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
 	radiotap->subns = 1;
 	radiotap->present = 0x1;
 	radiotap->len = size - sizeof(*radiotap);
-	radiotap->pad = 0;
+	radiotap->pad = 2;
 
 	/* fill the data now */
 	memcpy(radiotap->data, &mvm->cur_aid, sizeof(mvm->cur_aid));
+	/* and clear the padding */
+	memset(radiotap->data + sizeof(__le16), 0, radiotap->pad);
 
 	rx_status->flag |= RX_FLAG_RADIOTAP_VENDOR_DATA;
 }
@@ -663,7 +694,7 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 			    struct sk_buff *skb,
 			    struct iwl_rx_mpdu_desc *desc)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_hdr *hdr = iwl_mvm_skb_get_hdr(skb);
 	struct iwl_mvm_sta *mvm_sta;
 	struct iwl_mvm_baid_data *baid_data;
 	struct iwl_mvm_reorder_buffer *buffer;
@@ -1174,22 +1205,16 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 		.flags2 = cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW_KNOWN |
 				      IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW_KNOWN),
 	};
-	unsigned int radiotap_len = 0;
 
 	he = skb_put_data(skb, &known, sizeof(known));
-	radiotap_len += sizeof(known);
 	rx_status->flag |= RX_FLAG_RADIOTAP_HE;
 
 	if (phy_data->info_type == IWL_RX_PHY_INFO_TYPE_HE_MU ||
 	    phy_data->info_type == IWL_RX_PHY_INFO_TYPE_HE_MU_EXT) {
 		he_mu = skb_put_data(skb, &mu_known, sizeof(mu_known));
-		radiotap_len += sizeof(mu_known);
 		rx_status->flag |= RX_FLAG_RADIOTAP_HE_MU;
 	}
 
-	/* temporarily hide the radiotap data */
-	__skb_pull(skb, radiotap_len);
-
 	/* report the AMPDU-EOF bit on single frames */
 	if (!queue && !(phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
 		rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
-- 
2.20.1

