Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39028 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbbKJHns (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 02:43:48 -0500
Message-ID: <1447141424.2421.1.camel@sipsolutions.net> (sfid-20151110_084352_064721_F60B616F)
Subject: Re: [RFC 0/4] mac80211: jump labels for hw flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-wireless@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 10 Nov 2015 08:43:44 +0100
In-Reply-To: <20151109224259.GP17308@twins.programming.kicks-ass.net>
References: <1447106557-17684-1-git-send-email-johannes@sipsolutions.net>
	 <20151109224259.GP17308@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-09 at 23:42 +0100, Peter Zijlstra wrote:
> On Mon, Nov 09, 2015 at 11:02:33PM +0100, Johannes Berg wrote:
> > As far as the code is concerned, there are two really ugly things:
> >  1) I still use struct static_key - couldn't quite figure it out
> >     with static_key_false. I think I can replace it easily though.
> 
> Yeah, didn't see anything that would avoid using struct
> static_key_false. Was there anything specific that was difficult?

No, I think I just needed to wrap my head around the _ON and _OFF
semantics. I had originally thought I needed both _true and _false
static keys.

> >  2) There are a lot of boilerplate ifdefs/macros.
> 
> I'm sure we can reduce that a lot with some CPP trickery, lots of
> that looked like endless repetition of the same pattern.

Oh, it is, and I even generated it that way. I just haven't quite
figured out how to do that since you can't put an #if into a macro
expansion. Perhaps some tricks with the optimiser "if (0 && ..." or so.
I'll play with it.

For now though I think we need to figure out if we want this at all :)

johannes
