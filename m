Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35711 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaB1JGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 04:06:22 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 4/8] ath10k: bypass htc for htt tx path
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
	<1393485587-16879-5-git-send-email-michal.kazior@tieto.com>
Date: Fri, 28 Feb 2014 11:06:17 +0200
In-Reply-To: <1393485587-16879-5-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 27 Feb 2014 08:19:43 +0100")
Message-ID: <8738j3d2t2.fsf@kamboji.qca.qualcomm.com> (sfid-20140228_100636_243256_73087DA9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Going through full htc tx path for htt tx is a
> waste of resources. By skipping it it's possible
> to easily submit scatter-gather to the pci hif for
> reduced host cpu load and improved performance.
>
> The new approach uses dma pool to store the
> following metadata for each tx request:
>  * msdu fragment list
>  * htc header
>  * htt tx command
>
> The htt tx command contains a msdu prefetch.
> Instead of copying it original mapped msdu address
> is used to submit a second scatter-gather item to
> hif to make a complete htt tx command.
>
> The htt tx command itself hands over dma mapped
> pointers to msdus and completion of the command
> itself doesn't mean the frame has been sent and
> can be unmapped/freed. This is why htc tx
> completion is skipped for htt tx as all tx related
> resources are freed upon htt tx completion
> indication event (which also implicitly means htt
> tx command itself was completed).
>
> Since now each htt tx request effectively consists
> of 2 copy engine items CE_HTT_H2T_MSG_SRC_NENTRIES
> is updated to allow maximum of
> TARGET_10X_NUM_MSDU_DESC msdus being queued. This
> keeps the tx path resource management simple.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> v2:
>  * improve commit log
>  * improve comment in code
>  * fix sparse/checkpatch/buildbot warnings

[...]

> --- a/drivers/net/wireless/ath/ath10k/htc.c
> +++ b/drivers/net/wireless/ath/ath10k/htc.c
> @@ -202,10 +202,8 @@ static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
>  	struct ath10k_htc *htc = &ar->htc;
>  	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
>  
> -	if (!skb) {
> -		ath10k_warn("invalid sk_buff completion - NULL pointer. firmware crashed?\n");
> +	if (WARN_ON(!skb))
>  		return 0;
> -	}

WARN_ON() is a bit dangerous here as it might cause excessive spamming.
Why did you want to change this? I think either ath10k_warn() or
WARN_ON_ONCE() would be safer, but not sure which one to use.

-- 
Kalle Valo
