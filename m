Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53220 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758185AbdJMNZV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 09:25:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Oct 2017 16:25:02 +0300
Message-Id: <20171013132502.10473-10-luca@coelho.fi> (sfid-20171013_152606_725316_4390BAA6)
In-Reply-To: <20171013132502.10473-1-luca@coelho.fi>
References: <20171013132502.10473-1-luca@coelho.fi>
Subject: [PATCH 9/9] iwlwifi: pcie: remove set but not used variable tcph
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This variable is never used, so remove the code to set it.
After this, the variable 'iph' also has the same fate.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 79e4c73a9709..16b345f54ff0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -289,8 +289,7 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 		struct sk_buff *csum_skb = NULL;
 		unsigned int tb_len;
 		dma_addr_t tb_phys;
-		struct tcphdr *tcph;
-		u8 *iph, *subf_hdrs_start = hdr_page->pos;
+		u8 *subf_hdrs_start = hdr_page->pos;
 
 		total_len -= data_left;
 
@@ -312,8 +311,6 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 		 * as MAC header.
 		 */
 		tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
-		iph = hdr_page->pos + 8;
-		tcph = (void *)(iph + ip_hdrlen);
 
 		hdr_page->pos += snap_ip_tcp_hdrlen;
 
-- 
2.14.2
