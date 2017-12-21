Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51560 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751705AbdLULAS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 06:00:18 -0500
Message-ID: <1513854015.4827.506.camel@coelho.fi> (sfid-20171221_120319_424226_7FFAC097)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>
Date: Thu, 21 Dec 2017 13:00:15 +0200
In-Reply-To: <87wp1he5dh.fsf@kamboji.qca.qualcomm.com>
References: <20171218123815.3968-1-luca@coelho.fi>
         <20171218123815.3968-8-luca@coelho.fi>
         <878tdxh00r.fsf@kamboji.qca.qualcomm.com>
         <1513786686.4827.485.camel@coelho.fi>
         <87wp1he5dh.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 07/11] iwlwifi: add skb address to tx cmd in trace
 events data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-12-20 at 18:22 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > On Wed, 2017-12-20 at 17:49 +0200, Kalle Valo wrote:
> > > Luca Coelho <luca@coelho.fi> writes:
> > > 
> > > > From: Mordechay Goodstein <mordechay.goodstein@intel.com>
> > > > 
> > > > This helps matching tx cmd with other trace events, like
> > > > net_dev_xmit
> > > > and net_dev_queue etc.
> > > > 
> > > > Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.c
> > > > om>
> > > > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > > 
> > > [...]
> > > 
> > > > @@ -120,9 +121,9 @@ TRACE_EVENT(iwlwifi_dev_tx,
> > > >  				      __get_dynamic_array(buf1
> > > > ),
> > > >  				      skb->len - hdr_len);
> > > >  	),
> > > > -	TP_printk("[%s] TX %.2x (%zu bytes)",
> > > > +	TP_printk("[%s] TX %.2x (%zu bytes) skbaddr=%p",
> > > >  		  __get_str(dev), ((u8
> > > > *)__get_dynamic_array(buf0))[0],
> > > > -		  __entry->framelen)
> > > > +		  __entry->framelen, __entry->skbaddr)
> > > >  );
> > > 
> > > Just so that you know there has been a lot of changes recently
> > > about
> > > %p,
> > > I think the addresses are nowadays hashed due to security
> > > reasons. No
> > > idea if it afffects tracing events, but just wanted to point out
> > > this.
> > 
> > Yeah, I've seen some discussions and I even commented that in our
> > internal review.  But I reckoned that if they are all hash, it
> > should
> > still be possible to match them.
> 
> Good point, matching is of course possible with hashes.
> 
> > It would be good to check if that's done also for traces...
> 
> Yeah, please let me know if you find out that.

Moti investigated this a bit further.  This is what he concluded:

---8<---
Hi from my checking in the trace code it looks like

Tracepoins infrastructure copies as is the skbaddr to the cyclic buffer
User space tools get the content as is, from the cyclic buffer but you
need to be root to read it.  The use of tp_printk is for dumping the
output without userspace tools. (trace-cmd)
It's when you do cat trace in debugfs.

Like
>> cd /sys/kernel/debug/tracing
>> [enable the tracing points]
>> cat trace

It calls
kernel/trace/trace_seq.c :void trace_seq_printf
lib/seq_buf.c: int seq_buf_vprintf
lib/vsprintf.c : int vsnprintf

so if printk is changing to print hash (%p) also tp_printk would print
the hash https://patchwork.kernel.org/patch/10031785/ the changed are
done on vsnprintf but the user that has access to the cyclic buffer
would still have the ability to get the address itself.
--->8---

Thanks for checking Moti!

--
Cheers,
Luca.
