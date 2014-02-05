Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:38397 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaBEHkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 02:40:01 -0500
Message-ID: <1391585999.16723.7.camel@porter.coelho.fi> (sfid-20140205_084007_134740_55F0D436)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 05 Feb 2014 09:39:59 +0200
In-Reply-To: <CA+BoTQngW4Ycuv0H=ba5KWs2qDcqPQtKJWp-9XEwdqQv+Xu6CA@mail.gmail.com>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	 <1391434913.4488.24.camel@jlt4.sipsolutions.net>
	 <1391508433.26522.61.camel@porter.coelho.fi>
	 <CA+BoTQngW4Ycuv0H=ba5KWs2qDcqPQtKJWp-9XEwdqQv+Xu6CA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 13:14 +0100, Michal Kazior wrote:
> On 4 February 2014 11:07, Luca Coelho <luca@coelho.fi> wrote:
> > On Mon, 2014-02-03 at 14:41 +0100, Johannes Berg wrote:
> >> On Mon, 2014-02-03 at 10:58 +0100, Michal Kazior wrote:
> >> >  * inform userspace what interfaces will be
> >> >    possibly disconnected by a channel switch,
> >>
> >> Huh? Not sure I get that part, why would userspace ever be notified
> >> about something that *will* happen? Either the interface disconnects
> >> when the CSA is received, or it just switches and userspace gets a "CSA
> >> will happen" event?
> 
> True. Userspace can probably deduce from interface combinations some
> interfaces require attention due to channel switching.
> 
> 
> > How do we get the "target" beacon from userspace if the interface just
> > switches?
> 
> Do you really need the beacon? What for?

I meant if we would switch the AP/GO interfaces automatically.  We need
the beacon that should be transmitted in the new channel (like the one
we need to pass in the existing channel switch request API).


> > Now a bit of brain burp: I think that the "count" decision should remain
> > in the userspace so it can decide to give more time for its stations to
> > switch.  Eg. if the client interface got a CSA with count == x and a
> > host interface has dtim_interval > x, the userspace can send a "quiet"
> > CSA with count == dtim_interval + 1.  The two requests would be "merged"
> > and the highest count would win.  The client would be a bit late on the
> > new channel, but at least the AP wouldn't lose most of its clients.
> > Does this make any sense? I'm not sure myself. :)
> 
> Makes sense.

Let's keep this in mind as an improvement for later.


> >> >  * disconnect non-complying interfaces that were
> >> >    sharing a channel that is being abandoned by
> >> >    channel switching interface(s),
> >>
> >> Hmm, that sounds a bit the wrong way around? Shouldn't the CSA not be
> >> possible (userspace CSA) or cause the switching interface to disconnect,
> >> rather than *others*??
> >
> > It depends.  And this logic is too complicated to stay in the kernel,
> > IMHO.  If we are in a GO-follows-STA scenario, we want to disconnect the
> > GO.  Now, if you have an AP (with tons of STAs connected to it) and a
> > P2P client gets a CSA for whatever reason, do we really want to stop the
> > AP?
> 
> Agreed.
> 
> But doesn't this imply STA CSA shouldn't be started within kernel
> itself? Otherwise you leave a corner case when STA CSA is very short
> making it impossible for userspace to take any action.

I don't see how involving the userspace in the STA CSA decision would
make any difference.  Doesn't it actually make it worse, because the STA
CSA *itself* may fail because userspace doesn't have the time to react?


> >> > - * @channel_switch: initiate channel-switch procedure (with CSA)
> >> > + * @ch_switch_start: initiate channel-switch procedure (with CSA). This should
> >> > + * prompt the driver to perform preparation work (start some timers,
> >> > + * include CS IEs in beacons, etc) but don't do an actual channel switch.
> >> > + * Once driver has completed all preparations and is ready for the actual
> >> > + * switch (after CSA counter is completed) it must call
> >> > + * cfg80211_ch_switch_complete(wdev). After that ch_switch_finalize() MAY
> >> > + * be called, but it doesn't necessarily happen immediately as cfg80211
> >> > + * may need to synchronize with other interfaces. If channel switch is
> >> > + * cancelled for some reason ch_switch_finalize() is not called and driver
> >> > + * should free up resources/cleanup state in interface disconnection flow.
> >> > + * @ch_switch_finalize: finalize channel-switch procedure, i.e. perform the
> >> > + * actual switch.
> >>
> >> I don't like this at all. This totally assumes that every driver behaves
> >> like mac80211, which clearly is not the case. The split between
> >> "starting" and "finalizing" it should not be part of the API.
> >
> > I agree, especially if the driver offloads the channel switch, in which
> > case it wouldn't be possible for cfg80211 to hold the finalize call to
> > sync all the interfaces.
> 
> This implies we don't care if channel switching breaks interface
> combinations, right?

Those decisions need to be made *before* the channel switch starts.

--
Luca.

