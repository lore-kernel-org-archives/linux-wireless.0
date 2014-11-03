Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16619 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaKCXfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2014 18:35:21 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Michal Kazior" <michal.kazior@tieto.com>
Subject: Re: [PATCH v2] ath10k: handle ieee80211 header and payload tracing separately
References: <1414661336-20764-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 4 Nov 2014 01:34:37 +0200
In-Reply-To: <1414661336-20764-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Thu, 30 Oct 2014 14:58:56 +0530")
Message-ID: <874muf7t9u.fsf@kamboji.qca.qualcomm.com> (sfid-20141104_003524_831422_37C2BAC4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> For packet log, the transmitted frame 802.11 header alone is sufficient.
> Recording entire packet is also consuming lot of disk space. To optimize
> this, tx and rx data tracepoints are splitted into header and payload
> tracepoints.
>
> To record tx ieee80211 headers
>
>      trace-cmd record -e ath10k_tx_hdr
>
> To record complete packets
>
>      trace-cmd record -e ath10k_tx_hdr -e ath10k_tx_payload
>
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/trace.h
> +++ b/drivers/net/wireless/ath/ath10k/trace.h
> @@ -341,7 +341,10 @@ TRACE_EVENT(ath10k_txrx_tx_unref,
>  	 )
>  );
>  
> -DECLARE_EVENT_CLASS(ath10k_data_event,
> +#define ATH10K_FRM_HDR_LEN  \
> +	ieee80211_hdrlen(((struct ieee80211_hdr *)data)->frame_control)

This macro does not look good. I would recommend to follow what Johannes
suggested:

"It would be worth hiding that inside the tracepoint's assign function,
so instead of passing data/len here you'd pass the full skb, or the full
skb data/skb len, like this:

ar, skb->data, skb->len

to both tracers. Then inside the tracer you can do the hdrlen check, and
that way move the code into the tracing so it's not hit when tracing is
disabled."

-- 
Kalle Valo
