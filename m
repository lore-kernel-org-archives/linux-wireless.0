Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:11261 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761989Ab0GUBCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 21:02:37 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0157684154
	for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 10:02:36 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH/RFC 3/3] ath5k: trace resets
Date: Wed, 21 Jul 2010 10:04:59 +0900
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	johannes@sipsolutions.net
References: <1279395336-856-1-git-send-email-me@bobcopeland.com> <201007201420.49305.br1@einfach.org> <20100720145200.GB7049@hash.localnet>
In-Reply-To: <20100720145200.GB7049@hash.localnet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007211004.59372.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue July 20 2010 23:52:00 Bob Copeland wrote:
> > again, here my same concerns: printing the reasons for resets is
> > something which is useful on embedded boards and production setups which
> > can't have tracing enabled. which is why i want to object against this
> > change!
> 
> What Johannes said wrt performance: during tracing, only the binary
> representations of the data are written to the trace ring buffer, so
> unlike the current debug code, we aren't doing printk formatting until
> the trace buffer is read.  You can save the raw binary data from the
> trace and do formatting on another machine.

that's true, but try to run a kernel with tracing compiled in and NOT runtime 
enabled on a small embedded board (soekris net48xx for example) and you'll see 
the difference. without tracing you can get 22Mbps, with tracing max 15Mbps 
UDP thruput. that means you cannot run a kernel with tracing enabled on a 
production system, which also means you cannot log the reasons for a reset 
there any more. and most of the problems we what to trace (e.g. stuck queue) 
happen only after days or weeks of operation in production environments...
 
> Another advantage is better granularity: if you only care about watching
> tx on the cab queue, you can dynamically filter based on the tracepoint
> arguments, something like:
> 
>   # echo "qnum == 6" > /debug/tracing/events/ath5k/ath5k_tx/filter
> 
> With the debug printks, you have to hack the driver or grep and hope
> the printk buffer didn't overflow and spill what you were looking for.

no doubt, i can see the advantages...

so let's go ahead with tracing, since we can always build less performant 
tracing kernels when we want to track down problems.

bruno
