Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2L0MMp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 07:12:45 -0500
Message-ID: <1356610386.15149.6.camel@jlt4.sipsolutions.net> (sfid-20121227_131249_993995_25A74003)
Subject: Re: [PATCH 2/7] ath6kl: add tracing points for sdio transfers
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Date: Thu, 27 Dec 2012 13:13:06 +0100
In-Reply-To: <20121227114430.27069.9849.stgit@localhost6.localdomain6> (sfid-20121227_125304_397419_424F7D8C)
References: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
	 <20121227114430.27069.9849.stgit@localhost6.localdomain6>
	 (sfid-20121227_125304_397419_424F7D8C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-27 at 13:44 +0200, Kalle Valo wrote:

> +	if (request & HIF_WRITE)
> +		trace_ath6kl_sdio_wr(addr, request, buf, len);
> +	else
> +		trace_ath6kl_sdio_rd(addr, request, buf, len);

It would be more efficient to use a single tracepoint and have a
"direction" field or so -- then the if doesn't have to be executed when
tracing is disabled.


> +	for (i = 0; i < scat_req->scat_entries; i++) {
> +		if (scat_req->req & HIF_WRITE)
> +			trace_ath6kl_sdio_wr(scat_req->addr,
> +					     scat_req->req,
> +					     scat_req->scat_list[i].buf,
> +					     scat_req->scat_list[i].len);
> +		else
> +			trace_ath6kl_sdio_rd(scat_req->addr,
> +					     scat_req->req,
> +					     scat_req->scat_list[i].buf,
> +					     scat_req->scat_list[i].len);
> +	}

Same here, although it would be even better to move the loop into the
tracepoint ... is there a small upper bound on "scat_entries"? If yes,
you could do something like here:

http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-next.git;a=blob;f=drivers/net/wireless/iwlwifi/iwl-devtrace.h;hb=HEAD#l325

where I put a function call into the __entry to figure out how much
space is needed.

johannes

