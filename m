Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42973 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab1BUTAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 14:00:36 -0500
Date: Mon, 21 Feb 2011 13:47:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Nathaniel Smith <njs@pobox.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	johannes@sipsolutions.net, nbd@openwrt.org
Subject: Re: [RFC v2] mac80211: implement eBDP algorithm to fight bufferbloat
Message-ID: <20110221184716.GD9650@tuxdriver.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
 <1298064074-8108-1-git-send-email-linville@tuxdriver.com>
 <AANLkTikJeN=CG20PAj-n1ZoaiJLbsiG=jfZnbu4Or3KS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTikJeN=CG20PAj-n1ZoaiJLbsiG=jfZnbu4Or3KS@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 18, 2011 at 07:44:30PM -0800, Nathaniel Smith wrote:
> On Fri, Feb 18, 2011 at 1:21 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > +       /* grab timestamp info for buffer control estimates */
> > +       tserv = ktime_sub(ktime_get(), skb->tstamp);
> [...]
> > +               ewma_add(&sta->sdata->qdata[q].tserv_ns_avg,
> > +                        ktime_to_ns(tserv));
> 
> I think you're still measuring how long it takes one packet to get
> from the end of the queue to the beginning, rather than measuring how
> long it takes each packet to go out?

Yes, I am measuring how long the driver+device takes to release each
skb back to me (using that as a proxy for how long it takes to get
the fragment to the next hop).  Actually, FWIW I'm only measuring
that time for those skb's that result in a tx status report.

I tried to see how your measurement would be useful, but I just don't
see how the number of frames ahead of me in the queue is relevant to
the measured link latency?  I mean, I realize that having more packets
ahead of me in the queue is likely to increase the latency for this
frame, but I don't understand why I should use that information to
discount the measured latency...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
