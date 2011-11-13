Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26832 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1KMJnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Nov 2011 04:43:39 -0500
Message-ID: <4EBF913F.9030304@qca.qualcomm.com> (sfid-20111113_104349_273777_9075A659)
Date: Sun, 13 Nov 2011 11:43:27 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix packet drop when ath6kl_cookie runs out
References: <1320762685-4665-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1320762685-4665-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 04:31 PM, Vasanthakumar Thiagarajan wrote:
> "ath6kl: Maintain virtual interface in a list" mistakenly stops the
> netq only when the mode is ibss. This causes packet drops in sta mode
> when the available cookies (buffer abstraction in ath6kl and also used
> for tx throttling) runs out for the highest priority traffic. This patch
> just fixes this regression though the original code may still need fixes
> which can be addressed in separate patches.
> 
> Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

>  	 * The last MAX_HI_COOKIE_NUM "batch" of cookies are reserved for
> @@ -465,20 +465,18 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
>  	 */
>  	if (ar->ac_stream_pri_map[ar->ep2ac_map[endpoint]] <
>  	    ar->hiac_stream_active_pri &&
> -	    ar->cookie_count <= MAX_HI_COOKIE_NUM) {
> +	    ar->cookie_count <= MAX_HI_COOKIE_NUM)
>  		/*
>  		 * Give preference to the highest priority stream by
>  		 * dropping the packets which overflowed.
>  		 */
>  		action = HTC_SEND_FULL_DROP;

In the code before "ath6kl: Maintain virtual interface in a list" this
test was not run in Ad-Hoc mode, but now it is run. AFAICS it shouldn't
create any issues, but wanted to point out anyway.

Also, as discussed earlier, it's better to have braces when you have a
comment in a single line if statement. But this is a minor style issue
and can be fixed later. Any case here are examples what I mean:

if (foo)
	return 0;

if (bar) {
	/* this is a comment */
	return 0;
}

/* this is a second comment */
if (foobar)
	return 0;

Kalle
