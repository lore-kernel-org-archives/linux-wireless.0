Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab2F0OiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 10:38:12 -0400
Message-ID: <1340807890.11012.43.camel@jlt3.sipsolutions.net> (sfid-20120627_163815_643344_E812658D)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 27 Jun 2012 16:38:10 +0200
In-Reply-To: <CA+XVXfcNpj_UqCOXUG7sr2MQH8qZNHYr7MfBz5J3vwC3f+KU6Q@mail.gmail.com> (sfid-20120627_132722_460723_7FBDB1C9)
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
	 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
	 <1340707305.14634.9.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
	 <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com>
	 <1340795869.11012.12.camel@jlt3.sipsolutions.net>
	 <CA+XVXfcNpj_UqCOXUG7sr2MQH8qZNHYr7MfBz5J3vwC3f+KU6Q@mail.gmail.com>
	 (sfid-20120627_132722_460723_7FBDB1C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 14:27 +0300, Arik Nemtsov wrote:
> On Wed, Jun 27, 2012 at 2:17 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2012-06-26 at 14:35 +0300, Arik Nemtsov wrote:
> >
> >> Can you give a bit more info on the Tx-sync approach, for the uninitiated?
> >> I'm also thinking that maybe we could somehow treat the sleeping-GO as
> >> a special case (maybe with some special code and a HW flag). Right now
> >> I'm not sure the wl12xx FW even supports it.
> >
> > I basically had a simpler version in mind, something like this:
> > http://p.sipsolutions.net/cd928e926a941ac7.txt
> 
> If the low level driver has to prepare for each such Tx, that's fine.

If it doesn't, then it can de-duplicate itself I guess? And it can also
abort everything (if needed) when the bssid is cleared (failure) or when
we go into associated (success), so I didn't add an explicit cancel
operation.

> But does this somehow rely on the timing of the Tx? Relying on op_tx
> to come right after this seems racy.

It'll depend on the driver I guess? If you're going to set a flag "give
this vif priority now" on the first invocation, then you probably
wouldn't care about the timing. It looks like our implementation would
actually start some "give me the channel" operation and when the
firmware says "ok you have the channel now" we'd return and rely on
getting the TX right after.

Wrt. the race, this isn't going to be something that happens within less
than a millisecond or so, it's going to give us maybe 50ms at least of
channel time (WFA mandates replying within 30ms), so that doesn't seem
like a problem?

johannes

