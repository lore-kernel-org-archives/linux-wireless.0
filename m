Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1K2WOj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 17:14:39 -0500
Subject: Re: [PATCH] mac80211: reset addba retries after timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <CALGY4fvSOdKtZbPSdvYkY3XXaGXNo-Ft8ir4LikmnTLqSkVCGA@mail.gmail.com> (sfid-20111129_230154_722045_7B8D85F9)
References: <1322533625-24641-1-git-send-email-mar.kolya@gmail.com>
	 <1322555084.4110.2.camel@jlt3.sipsolutions.net>
	 <CALGY4fvLSKBY93M9Bhb-F8Sm=Uw5nU+OvTtAmk_BXQX8WX6V8A@mail.gmail.com>
	 <1322579973.4110.22.camel@jlt3.sipsolutions.net>
	 <CALGY4fvSOdKtZbPSdvYkY3XXaGXNo-Ft8ir4LikmnTLqSkVCGA@mail.gmail.com>
	 (sfid-20111129_230154_722045_7B8D85F9)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 23:14:37 +0100
Message-ID: <1322604877.11282.1.camel@jlt3.sipsolutions.net> (sfid-20111129_231443_228434_A71EA7A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-29 at 17:01 -0500, Nikolay Martynov wrote:

> >>   Do APs broken is such way exist? I.e. APs which declare aggregation
> >> support but do not respond to addba.
> >
> > I seem to remember something ... not really sure.
> 
>   If such APs exist I think it might be possible to extend my patch to
> do something like the following. For the first time make 10 attempts
> to establish addba. If this fails - make no more attempts for the
> duration of the connection. If this succeeds - use logic I've added in
> the patch. This should handle broken APs and won't allow agg to be
> disable because of some random blackout.

Wouldn't that be equivalent to just bumping the number of tries?

> >>   On the other hand looking at the code I've got an impression that
> >> connection doesn't stall while waiting for addba resp, i.e. packets
> >> still go though non-agg path. Did I miss something in this regards?
> >
> > We queue up packets in ieee80211_tx_prep_agg() when
> > HT_AGG_STATE_WANT_START is clear but HT_AGG_STATE_OPERATIONAL is not
> > set, this is the case after we send the addBA request frame and before
> > we get a response. So since the timeout is 1 second, the connection can
> > stall for quite a while.
> 
>   Is the any particular reason why packets are not being sent via
> non-agg path while agg path is being established? I'm not suggesting
> that it is wrong, I'm just curious. The delay in data transmission
> you've mentioned in regards to my patch is probably applicable here
> too, so won't it make sense to ignore agg until it is fully set up?

It's required because you tell the peer what the first aggregated
packet's sequence number is going to be.

johannes

