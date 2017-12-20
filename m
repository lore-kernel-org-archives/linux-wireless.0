Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754664AbdLTPuB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 10:50:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 07/11] iwlwifi: add skb address to tx cmd in trace events data
References: <20171218123815.3968-1-luca@coelho.fi>
        <20171218123815.3968-8-luca@coelho.fi>
Date: Wed, 20 Dec 2017 17:49:56 +0200
In-Reply-To: <20171218123815.3968-8-luca@coelho.fi> (Luca Coelho's message of
        "Mon, 18 Dec 2017 14:38:11 +0200")
Message-ID: <878tdxh00r.fsf@kamboji.qca.qualcomm.com> (sfid-20171220_165006_872106_DC02C289)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Mordechay Goodstein <mordechay.goodstein@intel.com>
>
> This helps matching tx cmd with other trace events, like net_dev_xmit
> and net_dev_queue etc.
>
> Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

[...]

> @@ -120,9 +121,9 @@ TRACE_EVENT(iwlwifi_dev_tx,
>  				      __get_dynamic_array(buf1),
>  				      skb->len - hdr_len);
>  	),
> -	TP_printk("[%s] TX %.2x (%zu bytes)",
> +	TP_printk("[%s] TX %.2x (%zu bytes) skbaddr=%p",
>  		  __get_str(dev), ((u8 *)__get_dynamic_array(buf0))[0],
> -		  __entry->framelen)
> +		  __entry->framelen, __entry->skbaddr)
>  );

Just so that you know there has been a lot of changes recently about %p,
I think the addresses are nowadays hashed due to security reasons. No
idea if it afffects tracing events, but just wanted to point out this.

-- 
Kalle Valo
