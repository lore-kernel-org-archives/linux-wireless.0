Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab0I2U3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 16:29:00 -0400
Subject: Re: [PATCH] iw:  Flush stdout when printing events.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CA39FCA.6000806@candelatech.com>
References: <1285720244-26149-1-git-send-email-greearb@candelatech.com>
	 <1285743567.3756.1.camel@jlt3.sipsolutions.net>
	 <4CA39FCA.6000806@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 22:29:01 +0200
Message-ID: <1285792141.3756.38.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 13:21 -0700, Ben Greear wrote:
> On 09/28/2010 11:59 PM, Johannes Berg wrote:
> > On Tue, 2010-09-28 at 17:30 -0700, greearb@candelatech.com wrote:
> >
> >> -#define PARSE_BEACON_CHAN(_attr, _chan) do { \
> >> -	r = parse_beacon_hint_chan(tb[_attr], \
> >> -				&_chan); \
> >> -	if (r) \
> >> -		return NL_SKIP; \
> >> -} while (0)
> >> +
> >> +#define PARSE_BEACON_CHAN(_attr, _chan) do {		\
> >> +		r = parse_beacon_hint_chan(tb[_attr],	\
> >> +					&_chan);	\
> >> +		if (r) {				\
> >> +			fflush(stdout);			\
> >> +			return NL_SKIP;			\
> >> +		}					\
> >> +	} while (0)
> >> +
> >
> > Why does that need fflush() here? We'll eventually finish that line, no?
> 
> This returns from the print_event method, so I assume it should
> flush.  If it finishes the line, I'm not sure where.

Oh, you're right, I'll apply this too, and then I'll have done your
three changes in three changesets, heh... oh well :)

johannes

