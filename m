Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:11337 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbbHSNAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 09:00:05 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: ido@wizery.com, netdev@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC v2 3/3] iwlwifi: mvm: transfer the truesize to the last TSO segment
Date: Wed, 19 Aug 2015 15:59:41 +0300
Message-Id: <1439989181-4444-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150819_150020_164744_7499637E)
In-Reply-To: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to release the backpressure on the socket only
when the last segment is released.
Now the truesize looks like this:
if the truesize of the original skb is 65420, all the
segments will have a truesize of 704 (skb itself) and the
last one will have 65420.

Change-Id: I3c894cf2afc0aedfe7b2a5b992ba41653ff79c0e
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 5046833..046e50d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -764,7 +764,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
 	bool ipv6 = skb_shinfo(skb_gso)->gso_type & SKB_GSO_TCPV6;
 	struct iwl_lso_splitter s = {};
 	struct page *hdr_page;
-	unsigned int mpdu_sz;
+	unsigned int mpdu_sz, sum_truesize = 0;
 	u8 *hdr_page_pos, *qc, tid;
 	int i, ret;
 
@@ -898,6 +898,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
 						mpdu_sz, tcp_hdrlen(skb_gso));
 
 	__skb_queue_tail(mpdus_skb, skb_gso);
+	sum_truesize += skb_gso->truesize;
 
 	/* mss bytes have been consumed from the data */
 	s.gso_payload_pos = s.mss;
@@ -1034,6 +1035,20 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb_gso,
 		}
 
 		__skb_queue_tail(mpdus_skb, skb);
+		sum_truesize += skb->truesize;
+	}
+
+	/* Release the backpressure on the socket only when
+	 * the last segment is released.
+	 */
+	if (skb_gso->destructor == sock_wfree) {
+		struct sk_buff *tail = mpdus_skb->prev;
+
+		swap(tail->truesize, skb_gso->truesize);
+		swap(tail->destructor, skb_gso->destructor);
+		swap(tail->sk, skb_gso->sk);
+                atomic_add(sum_truesize - skb_gso->truesize,
+                           &skb_gso->sk->sk_wmem_alloc);
 	}
 
 	ret = 0;
-- 
2.1.4

