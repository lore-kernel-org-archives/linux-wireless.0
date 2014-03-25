Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20001 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaCYMCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 08:02:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4 v2] ath10k:  invalid msdu-id logging
References: <1395688844-24640-1-git-send-email-greearb@candelatech.com>
	<1395688844-24640-5-git-send-email-greearb@candelatech.com>
Date: Tue, 25 Mar 2014 14:02:11 +0200
In-Reply-To: <1395688844-24640-5-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Mon, 24 Mar 2014 12:20:44
	-0700")
Message-ID: <87txam1o70.fsf@kamboji.qca.qualcomm.com> (sfid-20140325_130219_723952_C64072ED)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Make this message more obvious that it is a serious
> problem (will cause tx flush issues, at least).
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> v2:  Add this to series, but ordering is not overly important.
>

[...]

> --- a/drivers/net/wireless/ath/ath10k/txrx.c
> +++ b/drivers/net/wireless/ath/ath10k/txrx.c
> @@ -58,7 +58,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
>  		   tx_done->msdu_id, !!tx_done->discard, !!tx_done->no_ack);
>  
>  	if (tx_done->msdu_id >= htt->max_num_pending_tx) {
> -		ath10k_warn("warning: msdu_id %d too big, ignoring\n",
> +		ath10k_warn("error: msdu_id %d too big, ignoring\n",
>  			    tx_done->msdu_id);
>  		return;
>  	}

To me any warning is a serious matter, I'm not sure how changing this to
message to use "error:" makes any difference?

-- 
Kalle Valo
