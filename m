Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaAOUEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 15:04:49 -0500
Message-ID: <1389816284.4338.22.camel@jlt4.sipsolutions.net> (sfid-20140115_210453_120051_90D05E42)
Subject: Re: [PATCH v3 1/2] mac80211_hwsim: fix duplicate beacons on TSF
 adjust
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <twpedersen@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Wed, 15 Jan 2014 21:04:44 +0100
In-Reply-To: <CAHmEv86K7br1c0ES1N0dWeAoPfJaaiy8+rAXAjoiUOwophhY_A@mail.gmail.com> (sfid-20140115_185607_818730_16B2261B)
References: <1387477515-3583-1-git-send-email-twpedersen@gmail.com>
	 <1389035380.5891.42.camel@jlt4.sipsolutions.net>
	 <CAHmEv86K7br1c0ES1N0dWeAoPfJaaiy8+rAXAjoiUOwophhY_A@mail.gmail.com>
	 (sfid-20140115_185607_818730_16B2261B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 09:55 -0800, Thomas Pedersen wrote:

> >> +     if (!hrtimer_callback_running(&data->beacon_timer.timer) &&
> >> +         !test_bit(TASKLET_STATE_RUN, &data->beacon_timer.tasklet.state))
> >> +             tasklet_hrtimer_cancel(&data->beacon_timer);
> >
> > That test_bit() really seems suspicious - there are no other users in
> > the tree except for the internal tasklet code... What are you trying to
> > do?
> 
> I'm trying to avoid calling tasklet_hrtimer_cancel() recursively, that
> is, when mac80211_hwsim_beacon_sched() is called from within the
> hrtimer tasklet itself. Looking at it again this does seem ugly. Would
> it be acceptable to pass a flag to _beacon_sched() indicating whether
> a reschedule is taking place from within the tasklet? 

That seems fine to me.

> We could also
> have a mac80211_hwsim_beacon_sched() (which would cance the hrtimer
> tasklet) and __mac80211_hwsim_beacon_sched() pair, but I'm not sure if
> that nomenclature applies here.

Whichever causes less code duplication? Could one call the other maybe?
Dunno, up to you. I was really just thinking that the test_bit() was odd
since nobody else uses it.

johannes

