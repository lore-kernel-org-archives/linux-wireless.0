Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:7229 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaCXLMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 07:12:09 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k:  Add debugging for tx-credits usage.
References: <1395428150-31996-1-git-send-email-greearb@candelatech.com>
Date: Mon, 24 Mar 2014 13:12:03 +0200
In-Reply-To: <1395428150-31996-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Fri, 21 Mar 2014 11:55:48
	-0700")
Message-ID: <871txr7svw.fsf@kamboji.qca.qualcomm.com> (sfid-20140324_121240_886053_89D1BF9B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This helps track tx credits accounting and usage.  If
> firmware hangs or otherwise fails to return credits, one
> can more easily see the last few command types that
> was send to the firmware.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

This patchset didn't apply, and the sha1 ids were useless so that 3-way
merge didn't work. Can you rebase, please? And better yet if you rebase
in top of my master branch.

>  int ath10k_htc_send(struct ath10k_htc *htc,
>  		    enum ath10k_htc_ep_id eid,
> -		    struct sk_buff *skb)
> +		    struct sk_buff *skb, int dbg)
>  {
>  	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
>  	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
> @@ -167,6 +167,10 @@ int ath10k_htc_send(struct ath10k_htc *htc,
>  			goto err_pull;
>  		}
>  		ep->tx_credits -= credits;
> +		ath10k_dbg(ATH10K_DBG_HTC,
> +			   "ep %d used %d credits, remaining %d dbg %d (0x%x)\n",
> +			   eid, credits, ep->tx_credits, dbg, dbg);
> +
>  		spin_unlock_bh(&htc->tx_lock);
>  	}

[...]

> @@ -680,7 +684,7 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
>  
>  	reinit_completion(&htc->ctl_resp);
>  
> -	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
> +	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb, __LINE__);

Using line numbers in debug messages is very cumbersome. Some people
cherry pick patches, have their own changes and whatnot which will make
it more difficult to read the debug logs. Isn't there any better way to
do this?

> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -544,7 +544,7 @@ static int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
>  	cmd_hdr->cmd_id = __cpu_to_le32(cmd);
>  
>  	memset(skb_cb, 0, sizeof(*skb_cb));
> -	ret = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb);
> +	ret = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb, 0x71100000 | cmd_id);
>  	trace_ath10k_wmi_cmd(cmd_id, skb->data, skb->len, ret);

What does 0x71100000 stand for?

-- 
Kalle Valo
