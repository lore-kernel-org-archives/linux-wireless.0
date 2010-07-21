Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62259 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709Ab0GUBMa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 21:12:30 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 18:12:30 -0700
Date: Tue, 20 Jul 2010 18:12:28 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bruno Randolf <br1@einfach.org>
CC: Bob Copeland <me@bobcopeland.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH/RFC 3/3] ath5k: trace resets
Message-ID: <20100721011227.GB1999@tux>
References: <1279395336-856-1-git-send-email-me@bobcopeland.com>
 <201007201420.49305.br1@einfach.org>
 <20100720145200.GB7049@hash.localnet>
 <201007211004.59372.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201007211004.59372.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 20, 2010 at 06:04:59PM -0700, Bruno Randolf wrote:
> On Tue July 20 2010 23:52:00 Bob Copeland wrote:
> > > again, here my same concerns: printing the reasons for resets is
> > > something which is useful on embedded boards and production setups which
> > > can't have tracing enabled. which is why i want to object against this
> > > change!
> > 
> > What Johannes said wrt performance: during tracing, only the binary
> > representations of the data are written to the trace ring buffer, so
> > unlike the current debug code, we aren't doing printk formatting until
> > the trace buffer is read.  You can save the raw binary data from the
> > trace and do formatting on another machine.
> 
> that's true, but try to run a kernel with tracing compiled in and NOT runtime 
> enabled on a small embedded board (soekris net48xx for example) and you'll see 
> the difference. without tracing you can get 22Mbps, with tracing max 15Mbps 
> UDP thruput. that means you cannot run a kernel with tracing enabled on a 
> production system, which also means you cannot log the reasons for a reset 
> there any more. and most of the problems we what to trace (e.g. stuck queue) 
> happen only after days or weeks of operation in production environments...
>  
> > Another advantage is better granularity: if you only care about watching
> > tx on the cab queue, you can dynamically filter based on the tracepoint
> > arguments, something like:
> > 
> >   # echo "qnum == 6" > /debug/tracing/events/ath5k/ath5k_tx/filter
> > 
> > With the debug printks, you have to hack the driver or grep and hope
> > the printk buffer didn't overflow and spill what you were looking for.
> 
> no doubt, i can see the advantages...
> 
> so let's go ahead with tracing, since we can always build less performant 
> tracing kernels when we want to track down problems.

FWIW I intend on adding tracing as well to ath9k_hw on the hw-ops.
Hence the hw-ops.h file, etc.

  Luis
