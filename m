Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44448 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630Ab2HVJEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 05:04:50 -0400
Message-ID: <1345626282.4635.8.camel@jlt3.sipsolutions.net> (sfid-20120822_110526_722162_EAE416DE)
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Mahesh Palivela <maheshp@posedge.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Wed, 22 Aug 2012 11:04:42 +0200
In-Reply-To: <20120822090104.GA4959@redhat.com>
References: <502CF2D5.6020704@posedge.com>
	 <20120817140657.GA1645@redhat.com> <502E85D9.5050301@posedge.com>
	 <1345480718.4459.37.camel@jlt3.sipsolutions.net>
	 <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com>
	 <50338E84.3050709@posedge.com>
	 <1345564421.10280.9.camel@jlt3.sipsolutions.net>
	 <5033CE76.6040306@posedge.com>
	 <1345619008.4635.3.camel@jlt3.sipsolutions.net>
	 <20120822090104.GA4959@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-22 at 11:01 +0200, Stanislaw Gruszka wrote:

> > Yeah but we don't have that yet. We could do it that way, sure, but it
> > has wide-spread implications, since we'll need to
> >  - use this new form of specifying channels all over mac80211 and all
> >    drivers,
> >  - define new nl80211 attributes for it,
> >  - write new code in nl80211 to handle all this,
> >  - and parse the old attributes into the new data structure(s) so
> >    drivers use the new API but userspace can continue to use the old
> > 
> > None of that is done yet.
> 
> For starters (for regulatory purpose only) would be sufficient to
> implement
> 
> regulatory_chan_use_permitted(center freq, bandwidth, whatever else),
> 
> and use it where currently IEEE80211_CHAN_NO_HT_X flags are used.

Yes, in theory. However, if this was intended to use the actual "center
freq, bandwidth, control channel offset" values, then it would be much
better to first actually define a struct to hold those, use it here, and
give it to drivers etc. Otherwise, drivers would have to take, e.g.

 - channel = 1 (2412 MHz)
 - HT40+

and calculate

 - center freq = 2422 MHz
 - bandwidth = 40
 - control channel offset = 0

before being able to call this function. To me, that seems wrong.

johannes

