Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSOFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:05:17 -0400
Message-ID: <1395237914.4142.13.camel@jlt4.sipsolutions.net> (sfid-20140319_150523_078342_27AD4DAB)
Subject: Re: [PATCH 3/3] mac80211: compute chanctx refcount dynamically
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 19 Mar 2014 15:05:14 +0100
In-Reply-To: <CA+BoTQnnWfNxeo6rtATU8qgj=dk9Kkx36GVewDr7p8OVFfcxNA@mail.gmail.com> (sfid-20140311_143307_127674_73F11729)
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
	 <1394191196-6425-3-git-send-email-michal.kazior@tieto.com>
	 <CA+BoTQkke050EMs0Nnz3O3XM6U2uRRVrxffVdwKJrWua+iapFw@mail.gmail.com>
	 <1394543770.30155.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnnWfNxeo6rtATU8qgj=dk9Kkx36GVewDr7p8OVFfcxNA@mail.gmail.com>
	 (sfid-20140311_143307_127674_73F11729)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-11 at 14:33 +0100, Michal Kazior wrote:

> >> I'm planning on adding `struct list_head` to sdata and chanctx to be
> >> able to iterate over assigned (and reserved, in the future) chanctx.
> >> What do you think? Do you have other ideas?
> >
> > I guess that seems reasonable - not sure why you'd want the reserved
> > one? Some of the maintenance there might be tricky?
> 
> For multi-vif we need to be able to track list of interfaces that have
> a reservation. This is needed for example for chandef calculation
> (e.g. to see if you can start a new vif on given chanctx that is part
> of a reservation already, etc).
> 
> It's also necessary so you can synchronize CSA across interfaces with
> the chanctx reservation that happen "in place" when you're out of
> max_num_different_channels. In that case you must unassign all
> interfaces, free chanctx, create new chanctx, and then assign the
> reservation interfaces.
> 
> Actually I think there's also one thing that might benefit from
> chanctx-vif list tracking: ieee80211_recalc_chanctx_chantype(). It
> seems to complain with WARN_ON splat when I reload driver when more
> than 1 vif is running because it doesn't find a non-NULL `compat`
> chandef (rightfully so as local->interfaces is empty at that point due
> to ieee80211_remove_interfaces).

Ok, makes sense. I guess I don't see any easier solution either.

johannes

