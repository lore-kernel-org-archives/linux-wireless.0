Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab3AINyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 08:54:11 -0500
Message-ID: <1357739673.9757.15.camel@jlt4.sipsolutions.net> (sfid-20130109_145415_346986_2AB7C5E1)
Subject: Re: mac80211 and RX of A-MPDU with missing back agreement
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Johan Danielsson <joda@kth.se>, linux-wireless@vger.kernel.org,
	sgruszka@redhat.com
Date: Wed, 09 Jan 2013 14:54:33 +0100
In-Reply-To: <201301091446.44597.chunkeey@googlemail.com> (sfid-20130109_144650_306301_899B1DDC)
References: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com>
	 <201301090038.01984.chunkeey@googlemail.com>
	 <1357732965.9757.4.camel@jlt4.sipsolutions.net>
	 <201301091446.44597.chunkeey@googlemail.com>
	 (sfid-20130109_144650_306301_899B1DDC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-09 at 14:46 +0100, Christian Lamparter wrote:

> > > [Note: Action frames like DELBA have to be encrypted/decrypted when 
> > > MFP/802.11w is enabled on the link and some HW/FW can't do that. So
> > > it takes even longer to react to those.]
> > 
> > Actually no: HT action frames aren't robust management frames.
> 
> DelBA is part of the Block Ack Actions as defined in 802.11-2012 8.5.5.
> The Block Ack category is marked in Table 8-38 as "robust"?!
> 
> Was this changed from the original 11w spec? Maybe that would explain
> why the Nexus 4 thinks it doesn't need to de-/encrypt BA agreements?.

Oops, no. I'm confusing HT action frames and BA agreement frames. Maybe
the Nexus4 developers made the same mistake? :)

> > FWIW, our (Intel's) firmware will send frames from the aggregation
> > queues unaggregated as soon as it receives a DelBA frame from the
> > peer, so as long as it receives it there's no issue.

> Good. Then it was probably just more convenient ;). But we still need
> a case for HW which doesn't support IEEE80211_HW_REPORTS_TX_ACK_STATUS.

Yeah.

But I think we're concerned about RX sessions here, so this behaviour
isn't really all that relevant. Sorry, I'm still a bit confused I guess.

Why do we even tear down RX sessions at all?

> Uh, this note was out of context. It had to do with a sentence
> from a previous post that wasn't discussed:
> 
> On Tuesday, January 08, 2013 11:39:10 AM Johan Danielsson wrote:
> > It seems more reasonable to send the DELBA and wait for an ACK
> > before removing the BACK state (with ampdu_action). Currently this
> > is done the other way around.
> 
> If we only call ampdu_action(RX_STOP) as part of a callback when we have
> received an ACK from a outgoing DELBA [yes I know some HW doesn't support
> that] what happens to BA agreements after all DELBAs retries have been 
> used up? Or do we have to retry them endlessly? [I'm asking this because
> we do have a retry-when-we-receive-unicast for BARs already...].

Oh, right, ok.

I tend to think that if a unicast management packet really didn't go
through there isn't much you can do. Typically it would have been
retried like a dozen times already ...

johannes


