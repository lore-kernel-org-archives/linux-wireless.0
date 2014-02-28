Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40149 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaB1JAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 04:00:49 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 5/8] ath10k: batch htt tx/rx completions
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
	<1393485587-16879-6-git-send-email-michal.kazior@tieto.com>
Date: Fri, 28 Feb 2014 11:00:43 +0200
In-Reply-To: <1393485587-16879-6-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 27 Feb 2014 08:19:44 +0100")
Message-ID: <877g8fd32c.fsf@kamboji.qca.qualcomm.com> (sfid-20140228_100052_935934_97B87B26)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> HTT Rx endpoint processes both frame rx
> indications and frame tx completion indications.
>
> Those completions typically come in batches and
> may be mixed so it makes sense to defer processing
> hoping to get a bunch of them and take advantage
> of hot caches.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +void ath10k_htt_txrx_compl_task(unsigned long ptr)
> +{
> +	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
> +	struct htt_resp *resp;
> +	struct sk_buff *skb;

I think this can be a static function. Is it ok if I change this patch
with the diff below?

--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1360,6 +1360,5 @@ int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt);
 void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id);
 int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *);
 int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *);
-void ath10k_htt_txrx_compl_task(unsigned long ptr);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index e362358240e8..3a02e654d871 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -43,7 +43,7 @@
 
 
 static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb);
-
+static void ath10k_htt_txrx_compl_task(unsigned long ptr);
 
 static int ath10k_htt_rx_ring_size(struct ath10k_htt *htt)
 {
@@ -1347,7 +1347,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 
-void ath10k_htt_txrx_compl_task(unsigned long ptr)
+static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 {
 	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
 	struct htt_resp *resp;


-- 
Kalle Valo
