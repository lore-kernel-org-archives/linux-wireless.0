Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:54263
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbaFDJJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 05:09:58 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/10] ath10k: use safer test on the result of find_first_zero_bit
Date: Wed,  4 Jun 2014 11:07:52 +0200
Message-Id: <1401872880-23685-3-git-send-email-Julia.Lawall@lip6.fr> (sfid-20140604_111300_404982_CAF02B00)
In-Reply-To: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
return a larger number than the maximum position argument if that position
is not a multiple of BITS_PER_LONG.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,e3;
statement S1,S2;
@@

e1 = find_first_zero_bit(e2,e3)
...
if (e1 
- ==
+ >=
  e3)
S1 else S2
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/wireless/ath/ath10k/htt_tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -64,7 +64,7 @@ int ath10k_htt_tx_alloc_msdu_id(struct a
 
 	msdu_id = find_first_zero_bit(htt->used_msdu_ids,
 				      htt->max_num_pending_tx);
-	if (msdu_id == htt->max_num_pending_tx)
+	if (msdu_id >= htt->max_num_pending_tx)
 		return -ENOBUFS;
 
 	ath10k_dbg(ATH10K_DBG_HTT, "htt tx alloc msdu_id %d\n", msdu_id);

