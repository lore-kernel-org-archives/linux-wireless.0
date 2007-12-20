Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:54145 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760229AbXLTOQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 09:16:01 -0500
Received: by fk-out-0910.google.com with SMTP id z23so3259364fkz.5
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2007 06:15:59 -0800 (PST)
Message-ID: <c85cb4470712200615o60132254lebe9d5553ddf2f3d@mail.gmail.com> (sfid-20071220_141614_194860_1513533A)
Date: Thu, 20 Dec 2007 16:15:55 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1198154463.16241.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
	 <1198145667.16241.23.camel@johannes.berg>
	 <c85cb4470712200432w3640359dje70f57c86be3497a@mail.gmail.com>
	 <1198154463.16241.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ok, I agree.
I'll make one patch for seperation only inside __ieee80211_rx, and
then build the reordering on top of it.

> > > Also, what you're doing means that
> > > the frame is accounted for channel load twice (yeah, I know, the stats
> > > there suck... but still...)
> >
> > here i am already checking the .ordered field (like i proposed for
> > monitor), and ignore the in-order frames.
>
> Ah. You'd need to ignore the out-of-order frames too since they too have
> gone through __ieee80211_rx already, no? Or do you by out-of-order just
> mean those that have been queued?
>
> > so you suggest to remove ieee80211_rx_h_reorder_ampdu in favor of a
> > function that will call ieee80211_sta_manage_reorder_buf?
>
> I guess the rx_h_reorder_ampdu pre-handler can stay, but as far as I
> understood the flow it will cause some frames to be "buffered". And I
> think frames shouldn't go through the same path twice even if you've
> annotated that path all over skipping when the frame was injected.
>
> Basically, it seems to me that you're injecting frames down the same
> __ieee80211_rx() path when they have already gone through that, and then
> after the fact annotate pretty much all of that path before the actual
> rx handlers (after pre-handlers) with "skip if reordered frame". That I
> don't really like, it means we need to special-case everything we ever
> put there.
>
> > 2 - (pro) yet, i'll end up checking the .ordered field in 3 places -
> > monitor,statistics and reordering buf, which lowers the encapsulation
> > of work inside ieee80211_rx_h_reorder_ampdu
> > 3 - (con) i will have to free un-needed sk_buffs in
> > ieee80211_sta_stop_rx_BA_session without going back to __ieee80211_rx,
> >  which may confuse othere.
>
> I don't think it's that confusing because __ieee80211_rx would do the
> same thing, it would free the frame if requested by the pre-handlers
> instead of passing it to the rx handlers. What your code does would
> simply be a diversion through another queue that has the same effect.
> (If you keep the rx-pre-handler for that you should add a comment that
> it must be last)
>
> johannes
>
>
