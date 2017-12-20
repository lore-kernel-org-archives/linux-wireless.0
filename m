Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51418 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755228AbdLTQSJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 11:18:09 -0500
Message-ID: <1513786686.4827.485.camel@coelho.fi> (sfid-20171220_171831_504671_E8B4685B)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>
Date: Wed, 20 Dec 2017 18:18:06 +0200
In-Reply-To: <878tdxh00r.fsf@kamboji.qca.qualcomm.com>
References: <20171218123815.3968-1-luca@coelho.fi>
         <20171218123815.3968-8-luca@coelho.fi>
         <878tdxh00r.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 07/11] iwlwifi: add skb address to tx cmd in trace
 events data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-12-20 at 17:49 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Mordechay Goodstein <mordechay.goodstein@intel.com>
> > 
> > This helps matching tx cmd with other trace events, like
> > net_dev_xmit
> > and net_dev_queue etc.
> > 
> > Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> [...]
> 
> > @@ -120,9 +121,9 @@ TRACE_EVENT(iwlwifi_dev_tx,
> >  				      __get_dynamic_array(buf1),
> >  				      skb->len - hdr_len);
> >  	),
> > -	TP_printk("[%s] TX %.2x (%zu bytes)",
> > +	TP_printk("[%s] TX %.2x (%zu bytes) skbaddr=%p",
> >  		  __get_str(dev), ((u8
> > *)__get_dynamic_array(buf0))[0],
> > -		  __entry->framelen)
> > +		  __entry->framelen, __entry->skbaddr)
> >  );
> 
> Just so that you know there has been a lot of changes recently about
> %p,
> I think the addresses are nowadays hashed due to security reasons. No
> idea if it afffects tracing events, but just wanted to point out
> this.

Yeah, I've seen some discussions and I even commented that in our
internal review.  But I reckoned that if they are all hash, it should
still be possible to match them.  It would be good to check if that's
done also for traces...

--
Luca.
