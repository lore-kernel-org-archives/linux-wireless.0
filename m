Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8CEC282DD
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57B282077C
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfDWJlW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:41:22 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59062 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725990AbfDWJlV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:41:21 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrvT-0000Je-8F; Tue, 23 Apr 2019 12:41:19 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 1/2] iwlwifi: mvm: check for length correctness in iwl_mvm_create_skb()
Date:   Tue, 23 Apr 2019 12:41:11 +0300
Message-Id: <20190423094112.18570-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423094112.18570-1-luca@coelho.fi>
References: <20190423094112.18570-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We don't check for the validity of the lengths in the packet received
from the firmware.  If the MPDU length received in the rx descriptor
is too short to contain the header length and the crypt length
together, we may end up trying to copy a negative number of bytes
(headlen - hdrlen < 0) which will underflow and cause us to try to
copy a huge amount of data.  This causes oopses such as this one:

BUG: unable to handle kernel paging request at ffff896be2970000
PGD 5e201067 P4D 5e201067 PUD 5e205067 PMD 16110d063 PTE 8000000162970161
Oops: 0003 [#1] PREEMPT SMP NOPTI
CPU: 2 PID: 1824 Comm: irq/134-iwlwifi Not tainted 4.19.33-04308-geea41cf4930f #1
Hardware name: [...]
RIP: 0010:memcpy_erms+0x6/0x10
Code: 90 90 90 90 eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a4 c3
 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe
RSP: 0018:ffffa4630196fc60 EFLAGS: 00010287
RAX: ffff896be2924618 RBX: ffff896bc8ecc600 RCX: 00000000fffb4610
RDX: 00000000fffffff8 RSI: ffff896a835e2a38 RDI: ffff896be2970000
RBP: ffffa4630196fd30 R08: ffff896bc8ecc600 R09: ffff896a83597000
R10: ffff896bd6998400 R11: 000000000200407f R12: ffff896a83597050
R13: 00000000fffffff8 R14: 0000000000000010 R15: ffff896a83597038
FS:  0000000000000000(0000) GS:ffff896be8280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff896be2970000 CR3: 000000005dc12002 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 iwl_mvm_rx_mpdu_mq+0xb51/0x121b [iwlmvm]
 iwl_pcie_rx_handle+0x58c/0xa89 [iwlwifi]
 iwl_pcie_irq_rx_msix_handler+0xd9/0x12a [iwlwifi]
 irq_thread_fn+0x24/0x49
 irq_thread+0xb0/0x122
 kthread+0x138/0x140
 ret_from_fork+0x1f/0x40

Fix that by checking the lengths for correctness and trigger a warning
to show that we have received wrong data.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 28 ++++++++++++++++---
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 1e03acf30762..b516fd1867ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -169,9 +169,9 @@ static inline int iwl_mvm_check_pn(struct iwl_mvm *mvm, struct sk_buff *skb,
 }
 
 /* iwl_mvm_create_skb Adds the rxb to a new skb */
-static void iwl_mvm_create_skb(struct sk_buff *skb, struct ieee80211_hdr *hdr,
-			       u16 len, u8 crypt_len,
-			       struct iwl_rx_cmd_buffer *rxb)
+static int iwl_mvm_create_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
+			      struct ieee80211_hdr *hdr, u16 len, u8 crypt_len,
+			      struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rx_mpdu_desc *desc = (void *)pkt->data;
@@ -204,6 +204,20 @@ static void iwl_mvm_create_skb(struct sk_buff *skb, struct ieee80211_hdr *hdr,
 	 * present before copying packet data.
 	 */
 	hdrlen += crypt_len;
+
+	if (WARN_ONCE(headlen < hdrlen,
+		      "invalid packet lengths (hdrlen=%d, len=%d, crypt_len=%d)\n",
+		      hdrlen, len, crypt_len)) {
+		/*
+		 * We warn and trace because we want to be able to see
+		 * it in trace-cmd as well.
+		 */
+		IWL_DEBUG_RX(mvm,
+			     "invalid packet lengths (hdrlen=%d, len=%d, crypt_len=%d)\n",
+			     hdrlen, len, crypt_len);
+		return -EINVAL;
+	}
+
 	skb_put_data(skb, hdr, hdrlen);
 	skb_put_data(skb, (u8 *)hdr + hdrlen + pad_len, headlen - hdrlen);
 
@@ -216,6 +230,8 @@ static void iwl_mvm_create_skb(struct sk_buff *skb, struct ieee80211_hdr *hdr,
 		skb_add_rx_frag(skb, 0, rxb_steal_page(rxb), offset,
 				fraglen, rxb->truesize);
 	}
+
+	return 0;
 }
 
 static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
@@ -1671,7 +1687,11 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			rx_status->boottime_ns = ktime_get_boot_ns();
 	}
 
-	iwl_mvm_create_skb(skb, hdr, len, crypt_len, rxb);
+	if (iwl_mvm_create_skb(mvm, skb, hdr, len, crypt_len, rxb)) {
+		kfree_skb(skb);
+		goto out;
+	}
+
 	if (!iwl_mvm_reorder(mvm, napi, queue, sta, skb, desc))
 		iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue,
 						sta, csi);
-- 
2.20.1

