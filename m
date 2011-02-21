Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42974 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1BUTAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 14:00:36 -0500
Date: Mon, 21 Feb 2011 13:52:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Nathaniel Smith <njs@pobox.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	johannes@sipsolutions.net, nbd@openwrt.org
Subject: Re: [RFC v2] mac80211: implement eBDP algorithm to fight bufferbloat
Message-ID: <20110221185221.GE9650@tuxdriver.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
 <1298064074-8108-1-git-send-email-linville@tuxdriver.com>
 <AANLkTinTcdbjSYvt7Z_yOe_8kGZnyp2MBXZYYJ9zGB_D@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTinTcdbjSYvt7Z_yOe_8kGZnyp2MBXZYYJ9zGB_D@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 19, 2011 at 04:37:00PM -0800, Nathaniel Smith wrote:
> Actually, a few more comments just occurred to me...
> 
> On Fri, Feb 18, 2011 at 1:21 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > Johannes' comment about tx status reporting being unreliable (and what
> > he was really saying) finally sunk-in.  So, this version uses
> > skb->destructor to track in-flight fragments.  That should handle
> > fragments that get silently dropped in the driver for whatever reason
> > without leaking queue capacity.  Correct me if I'm wrong!
> 
> Should we be somehow filtering out and ignoring the packets that get
> dropped, when we're calculating the average packet transmission rate?
> Presumably they're getting dropped almost instantly, so they don't
> really take up queue space and they have abnormally fast transmission
> times, which will tend to cause us to overestimate max_enqueued? They
> should be rare, though, at least. (And presumably we *should* include
> packets that get dropped because their retry timer ran out, since they
> were sitting in the queue for that long.) Possibly we should just
> ignore any packet that was handled in less than, oh, say, a few
> microseconds?

If you look, I only do the timing measurement for frames that
result in a tx status report.  Frames that are dropped will only hit
ieee80211_tx_skb_free (which reduces the enqueued count but doesn't
recalculate max_enqueue).

> Alternatively, if we aren't worried about those packets, then is there
> any reason this patch should be mac80211 specific?

No, in fact I was thinking the same thing.  Some thought needs to be
put to whether or not we can ignore the effects of letting dropped
packets effect the latency estimate...
 
> > +static void ieee80211_tx_skb_free(struct sk_buff *skb)
> > +{
> > +       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
> > +       struct ieee80211_local *local = sdata->local;
> > +       int q = skb_get_queue_mapping(skb);
> > +
> > +       /* decrement enqueued count */
> > +       atomic_dec(&sdata->qdata[q].enqueued);
> > +
> > +       /* if queue stopped, wake it */
> > +       if (ieee80211_queue_stopped(&local->hw, q))
> > +               ieee80211_wake_queue(&local->hw, q);
> > +}
> 
> I think you need to check that .enqueued is < max_enqueued here,
> instead of waking the queue unconditionally.
> 
> Suppose the data rate drops while there's a steady flow -- our
> max_enqueued value will drop below the current queue size, but because
> we wake the queue unconditionally after each packet goes out, and then
> only stop it again after we've queued at least one new packet, we
> might get 'stuck' with an over-large queue.

Yes, thanks for pointing that out.  My non-thorough tests seem to do
a better job at holding the latency lower with that change.

Thanks for taking a look!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
