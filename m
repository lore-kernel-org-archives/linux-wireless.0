Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab2JVN3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 09:29:18 -0400
Message-ID: <1350912590.10166.9.camel@jlt4.sipsolutions.net> (sfid-20121022_152921_305203_E86F2FF1)
Subject: Re: [RFC] mac80211: add explicit AP/GO driver operations
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org, ilan.peer@intel.com
Date: Mon, 22 Oct 2012 15:29:50 +0200
In-Reply-To: <CAB3XZEc0PbzcCFfkabEg9UfwnCizKGvKEhZ_iYfMA6QC=xcxFw@mail.gmail.com> (sfid-20121021_105351_428681_543405D7)
References: <1350654441-6761-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEc0PbzcCFfkabEg9UfwnCizKGvKEhZ_iYfMA6QC=xcxFw@mail.gmail.com>
	 (sfid-20121021_105351_428681_543405D7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-10-21 at 10:53 +0200, Eliad Peller wrote:

> > This would make the code in iwlwifi a lot simpler
> > as having bss_info_change do everything depending
> > on whether the beacon was enabled/disabled etc.
> > is tricky to get right, the explicit operations
> > make it easier.
> >
> is it really different from acting upon BSS_CHANGED_BEACON_ENABLED
> (when vif == ap)?

We did implement it this way but the error handling is a bit of a deal
breaker, it's just not good to have to ignore errors...

> >         ieee80211_bss_info_change_notify(sdata, changed);
> >
> > +       err = drv_start_ap(sdata->local, sdata);
> > +       if (err) {
> > +               old = rtnl_dereference(sdata->u.ap.beacon);
> > +               if (old)
> > +                       kfree_rcu(old, rcu_head);
> > +               RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
> > +               return err;
> 
> they'll probably be mutually exclusive, but i think you should still
> notify BSS_CHANGED_BEACON_ENABLED after removing the beacon (or more
> easily, call ieee80211_bss_info_change_notify only after this block).

Good point.

> > +DEFINE_EVENT(local_sdata_evt, drv_start_ap,
> > +       TP_PROTO(struct ieee80211_local *local,
> > +                struct ieee80211_sub_if_data *sdata),
> > +       TP_ARGS(local, sdata)
> > +);
> 
> adding traces for ssid and beacon_int might be nice :)

Yeah, quick & dirty for now.

> what about other direct notification of BSS_CHANGED_BEACON_ENABLED
> (like in offchannel and ieee80211_do_stop)? should we call
> start_ap/stop_ap there as well?

The one in do_stop() should probably just be cleaned up, cfg80211 will
now stop the AP operation while the interface goes down ... so that
won't actually do anything, but could be a concern for the old API
because it might cause an off/off transition.

For offchannel, I'm not sure. Does it really make sense to call it
there? I can do it, I suppose, but ... hmm. The software-offchannel
hopefully won't actually be needed much longer given channel
contexts ;-)

johannes

