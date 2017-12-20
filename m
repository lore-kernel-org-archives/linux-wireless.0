Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbdLTQWj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 11:22:39 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>
Subject: Re: [PATCH 07/11] iwlwifi: add skb address to tx cmd in trace events data
References: <20171218123815.3968-1-luca@coelho.fi>
        <20171218123815.3968-8-luca@coelho.fi>
        <878tdxh00r.fsf@kamboji.qca.qualcomm.com>
        <1513786686.4827.485.camel@coelho.fi>
Date: Wed, 20 Dec 2017 18:22:34 +0200
In-Reply-To: <1513786686.4827.485.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 20 Dec 2017 18:18:06 +0200")
Message-ID: <87wp1he5dh.fsf@kamboji.qca.qualcomm.com> (sfid-20171220_172243_787048_D1FE80A4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Wed, 2017-12-20 at 17:49 +0200, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>> 
>> > From: Mordechay Goodstein <mordechay.goodstein@intel.com>
>> > 
>> > This helps matching tx cmd with other trace events, like
>> > net_dev_xmit
>> > and net_dev_queue etc.
>> > 
>> > Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
>> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>> 
>> [...]
>> 
>> > @@ -120,9 +121,9 @@ TRACE_EVENT(iwlwifi_dev_tx,
>> >  				      __get_dynamic_array(buf1),
>> >  				      skb->len - hdr_len);
>> >  	),
>> > -	TP_printk("[%s] TX %.2x (%zu bytes)",
>> > +	TP_printk("[%s] TX %.2x (%zu bytes) skbaddr=%p",
>> >  		  __get_str(dev), ((u8
>> > *)__get_dynamic_array(buf0))[0],
>> > -		  __entry->framelen)
>> > +		  __entry->framelen, __entry->skbaddr)
>> >  );
>> 
>> Just so that you know there has been a lot of changes recently about
>> %p,
>> I think the addresses are nowadays hashed due to security reasons. No
>> idea if it afffects tracing events, but just wanted to point out
>> this.
>
> Yeah, I've seen some discussions and I even commented that in our
> internal review.  But I reckoned that if they are all hash, it should
> still be possible to match them.

Good point, matching is of course possible with hashes.

> It would be good to check if that's done also for traces...

Yeah, please let me know if you find out that.

-- 
Kalle Valo
