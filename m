Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53274 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2L0Pcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 10:32:42 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/7] ath6kl: add tracing points for sdio transfers
References: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
	<20121227114430.27069.9849.stgit@localhost6.localdomain6>
	<1356610386.15149.6.camel@jlt4.sipsolutions.net>
Date: Thu, 27 Dec 2012 17:32:47 +0200
In-Reply-To: <1356610386.15149.6.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Thu, 27 Dec 2012 13:13:06 +0100")
Message-ID: <87623nfr34.fsf@qca.qualcomm.com> (sfid-20121227_163246_506760_BBDC28FC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2012-12-27 at 13:44 +0200, Kalle Valo wrote:
>
>> +	if (request & HIF_WRITE)
>> +		trace_ath6kl_sdio_wr(addr, request, buf, len);
>> +	else
>> +		trace_ath6kl_sdio_rd(addr, request, buf, len);
>
> It would be more efficient to use a single tracepoint and have a
> "direction" field or so -- then the if doesn't have to be executed when
> tracing is disabled.

Heh, I first had a single tracepoint with an int (1 == tx, 0 == rx) for
this but then I split it to two tracepoints just to make it easier for
filtering. But it would be good to get rid of that extra if.

One way would be to just remove if the clause and let user space parse
the request variable (btw which should be renamed to flags) but then
implementing printk for the trace point is more difficult as HIF_WRITE
is defined for the printk. Is there any easy way to "export" some of the
defines, like HIF_WRITE, for the printk part in a tracepoint?

>> +	for (i = 0; i < scat_req->scat_entries; i++) {
>> +		if (scat_req->req & HIF_WRITE)
>> +			trace_ath6kl_sdio_wr(scat_req->addr,
>> +					     scat_req->req,
>> +					     scat_req->scat_list[i].buf,
>> +					     scat_req->scat_list[i].len);
>> +		else
>> +			trace_ath6kl_sdio_rd(scat_req->addr,
>> +					     scat_req->req,
>> +					     scat_req->scat_list[i].buf,
>> +					     scat_req->scat_list[i].len);
>> +	}
>
> Same here, although it would be even better to move the loop into the
> tracepoint ... is there a small upper bound on "scat_entries"?

Yes, the limit should be 8.

> If yes, you could do something like here:
>
> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-next.git;a=blob;f=drivers/net/wireless/iwlwifi/iwl-devtrace.h;hb=HEAD#l325
>
> where I put a function call into the __entry to figure out how much
> space is needed.

That looks good, I'll take a look and try to implement the same for
ath6kl.

Thank you for the review!

Kalle
