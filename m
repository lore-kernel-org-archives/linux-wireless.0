Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42176 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab0IUGb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 02:31:56 -0400
Subject: Re: [mac80211] mac80211:  Support receiving data frames on
 multiple vifs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4C97BC5E.5060704@candelatech.com>
References: <1285005163-4569-1-git-send-email-greearb@candelatech.com>
	 <1285009828.3688.8.camel@jlt3.sipsolutions.net>
	 <4C97BC5E.5060704@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 08:32:18 +0200
Message-ID: <1285050738.3710.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-20 at 12:56 -0700, Ben Greear wrote:
> On 09/20/2010 12:10 PM, Johannes Berg wrote:
> > On Mon, 2010-09-20 at 10:52 -0700, greearb@candelatech.com wrote:
> >> From: Ben Greear<greearb@candelatech.com>
> >>
> >> When using multiple STA interfaces on the same radio, some
> >> data packets need to be received on all interfaces
> >> (broadcast, for instance).
> >>
> >> Remove special loop for data-only packets and just process all
> >> packets in the big loop that previously only handled non-data
> >> packets.
> >
> > I'd prefer keeping different for_each_*, but maybe we can make the loops
> > just call a common function, say with&prev pointer or something? The
> > station loop will typically be iterating over fewer things here.
> 
> While attempting this, I see something strange.  It appears that
> for the last interface (in the non-data loop), the
> if (status->flag & RX_FLAG_MMIC_ERROR)
> logic will not be run?
> 
> Is that on purpose?

No, certainly not.

johannes

