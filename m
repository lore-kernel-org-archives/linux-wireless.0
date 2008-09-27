Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46528 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYI0BXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 21:23:24 -0400
Date: Fri, 26 Sep 2008 21:23:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Noonan <steven@uplinklabs.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5,
 rc6, probably others)
In-Reply-To: <20080919083208.GA15730@elte.hu>
Message-ID: <alpine.DEB.1.10.0809262117590.29360@gandalf.stny.rr.com> (sfid-20080927_032330_258096_0882EECC)
References: <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com> <20080918220102.GE7408@tesla> <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com> <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
 <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com> <f488382f0809181952g628ab5a4nd86f396a08f4d6c8@mail.gmail.com> <20080919030125.GG7408@tesla> <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com> <20080919081733.GC19491@elte.hu>
 <f488382f0809190122k1b30cd9q22fd076c1e3eaa18@mail.gmail.com> <20080919083208.GA15730@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I hate trips where my email box becomes filled. I skip over a lot of 
emails that I should not have.

On Fri, 19 Sep 2008, Ingo Molnar wrote:
> 
> What is needed is to set kernel/trace/trace.c's tracing_disabled 
> variable to 0. I've Cc:-ed Steve Rostedt - Steve, why is there no easy 
> ad-hoc way to trigger a stop-tracing event without elaborate changes?

I think I added a way to do this. Hmm, I think it was in -rt that I added 
it, and have not gotten around to sending you the updates.

Yes, we need an easy way to disable the tracer. I think we have 
ftrace_disable() function. Perhaps that only disables tracing that checks 
the tracing_disabled variable.

Anyway, I made sure the new ring_buffer code has an easy way to disable 
it.

-- Steve

