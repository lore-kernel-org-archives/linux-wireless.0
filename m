Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:60043 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaJWPJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 11:09:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/9] ath10k: add extra sanity check when popping amsdu
References: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
	<1413812438-14640-8-git-send-email-michal.kazior@tieto.com>
Date: Thu, 23 Oct 2014 18:09:31 +0300
Message-ID: <87wq7qomac.fsf@kamboji.qca.qualcomm.com> (sfid-20141023_170941_834651_12071627)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The netbuf pop can return NULL. Make sure to check
> for that. It shouldn't happen but better safe than
> sorry.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_rx.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index 7fa4d87..ddb9fe9 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -428,6 +428,15 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
>  		while (msdu_chained--) {
>  			struct sk_buff *next = ath10k_htt_rx_netbuf_pop(htt);
>  
> +			if (!next) {
> +				ath10k_err(ar, "failed to pop chained msdu\n");

ath10k_warn() is better here, right? I have folded this diff to the patch:

--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -429,7 +429,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
                        struct sk_buff *next = ath10k_htt_rx_netbuf_pop(htt);
 
                        if (!next) {
-                               ath10k_err(ar, "failed to pop chained msdu\n");
+                               ath10k_warn(ar, "failed to pop chained msdu\n");
                                ath10k_htt_rx_free_msdu_chain(*head_msdu);
                                *head_msdu = NULL;
                                msdu = NULL;

Full commit:

https://github.com/kvalo/ath/commit/03f316720d664a79e874c13df1e86a64c5f2bf5f

-- 
Kalle Valo
