Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab3EFP3R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 11:29:17 -0400
Date: Mon, 6 May 2013 17:30:45 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jake Edge <jake@lwn.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	lkml <linux-kernel@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
Message-ID: <20130506153044.GB1602@redhat.com> (sfid-20130506_172937_479092_20758F17)
References: <20130505143803.7e46e4c6@chukar.edge2.net>
 <20130506123805.GA1602@redhat.com>
 <20130506083759.556dac76@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130506083759.556dac76@chukar.edge2.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 06, 2013 at 08:37:59AM -0600, Jake Edge wrote:
> On Mon, 6 May 2013 14:38:06 +0200 Stanislaw Gruszka wrote:
> 
> > > I bisected the problem to:
> > > 
> > > commit 1672c0e31917f49d31d30d79067103432bc20cc7
> 
> > > What more information is needed from me?  I may still mess around
> > > with trying to revert that patch just to nail it down for sure, but
> > > two separate bisection exercises ended up at the same place.
> > 
> > Below patch should restore old mac80211 behaviour, by stop
> > telling mac that 4965 supports TX ACK status. Does it help?
> 
> Yup, that fixed the problem, thanks.  So did reverting Johannes's
> commit above, fwiw, but just turning off that flag in 3.9 as your patch
> does fixes it.
> 
> seems like that needs to head to Linus and the stable folks ...

We can fix the problem that way, but I'm not sure if that is the best
way. IEEE80211_HW_REPORTS_TX_ACK_STATUS is nice to have as long hardware
really supports that feature.

I thought this happen because 4965 firmware does not mark tx status
ack for PROBE_REQUEST frame, because it is not acked by standard 
ACK frame, but by PROBE_RESPONSE frame. But if so, I would also see
the breakage on my setup, but I don't - it works quite well here. So
perhaps something different is broken on commit
1672c0e31917f49d31d30d79067103432bc20cc7 , that make we can not
associate with some APs.

Let me think a bit longer about this issue. Also maybe Johannes will
have some thoughts.

Stanislaw 
