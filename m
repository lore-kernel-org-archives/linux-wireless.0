Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59903 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbbKIWnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 17:43:04 -0500
Date: Mon, 9 Nov 2015 23:42:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC 0/4] mac80211: jump labels for hw flags
Message-ID: <20151109224259.GP17308@twins.programming.kicks-ass.net> (sfid-20151109_234309_399241_3712B028)
References: <1447106557-17684-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447106557-17684-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 09, 2015 at 11:02:33PM +0100, Johannes Berg wrote:
> As far as the code is concerned, there are two really ugly things:
>  1) I still use struct static_key - couldn't quite figure it out
>     with static_key_false. I think I can replace it easily though.

Yeah, didn't see anything that would avoid using struct
static_key_false. Was there anything specific that was difficult?

>  2) There are a lot of boilerplate ifdefs/macros.

I'm sure we can reduce that a lot with some CPP trickery, lots of that
looked like endless repetition of the same pattern.

