Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57927 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067Ab0JDRfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 13:35:09 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 10:35:00 -0700
Date: Mon, 4 Oct 2010 10:35:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [PATCH v2 0/3] mac80211: fix rate_control_send_low warnings
 for delbas
Message-ID: <20101004173507.GN2105@tux>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
 <1286198845.3620.37.camel@jlt3.sipsolutions.net>
 <20101004164149.GE2105@tux>
 <1286210566.3620.42.camel@jlt3.sipsolutions.net>
 <20101004172504.GL2105@tux>
 <1286213426.3620.43.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1286213426.3620.43.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 10:30:26AM -0700, Johannes Berg wrote:
> On Mon, 2010-10-04 at 10:25 -0700, Luis R. Rodriguez wrote:
> > On Mon, Oct 04, 2010 at 09:42:46AM -0700, Johannes Berg wrote:
> > > On Mon, 2010-10-04 at 09:41 -0700, Luis R. Rodriguez wrote:
> > > > On Mon, Oct 04, 2010 at 06:27:25AM -0700, Johannes Berg wrote:
> > > > > How about this instead of your patches 2 and 3?
> > > > > 
> > > > > We're disassociating from the old AP since we associate with the new AP,
> > > > > so there's not a whole lot of sense in explicitly tearing down
> > > > > aggregation sessions either, right?
> > > > 
> > > > Good question, but why do we not get a warning when transmitting
> > > > the disassoc frame?
> > > 
> > > We aren't transmitting a disassoc frame!
> > 
> > OK, then the question is if we should even at least do that...
> 
> No, why should we? We're sending a re-assoc frame to the new AP.

I was wondering if actively disassociating might help with a smoother
transition. I was under this why we were doing this in the first place.
I frankly do not know, but if it does not help then I do agree with
your patch replacement.

  Luis
