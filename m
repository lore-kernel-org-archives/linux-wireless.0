Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:47180 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaAXMzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 07:55:24 -0500
Message-ID: <1390568119.19968.107.camel@porter.coelho.fi> (sfid-20140124_135529_664827_521CDF03)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Fri, 24 Jan 2014 14:55:19 +0200
In-Reply-To: <CA+BoTQnaoqv_KZkM=Q=TbJRFmeq8A1U43cOQpf+ytqmyu9aaHQ@mail.gmail.com>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 <1390380726.4334.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	 <1390382020.4334.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	 <1390385995.4334.27.camel@jlt4.sipsolutions.net>
	 <1390394166.4189.28.camel@porter.coelho.fi>
	 <1390403432.4334.33.camel@jlt4.sipsolutions.net>
	 <1390403634.4189.39.camel@porter.coelho.fi>
	 <CA+BoTQ=+TGFo0f0z1SymiN5DkeLZUPC_p_YVZ59s=FFqpGV3vQ@mail.gmail.com>
	 <1390458664.4189.48.camel@porter.coelho.fi>
	 <CA+BoTQnyd5HQxU9n=7G8bhJTukMJqZwNmD1FgWowHm2LJ=NUsA@mail.gmail.com>
	 <1390462306.4189.56.camel@porter.coelho.fi>
	 <CA+BoTQn-wjQYfUVxJU+xOUoANKE=8ajmq=ytmzAqVuiqMXJj=w@mail.gmail.com>
	 <1390470648.4189.88.camel@porter.coelho.fi>
	 <CA+BoTQm768pE7w1x9p5dN+qTxYjzf8R5u4WASd4zEaQ=v717BQ@mail.gmail.com>
	 <1390479620.4142.14.camel@jlt4.sipsolutions.net>
	 <CA+BoTQkd6XLYpJPAb-HLosbmT3duVCdpEStpxNCcHCGTx9djzw@mail.gmail.com>
	 <1390549306.19968.6.camel@porter.coelho.fi>
	 <1390552837.4257.33.camel@jlt4.sipsolutions.net>
	 <1390557170.19968.72.camel@porter.coelho.fi>
	 <CA+BoTQnaoqv_KZkM=Q=TbJRFmeq8A1U43cOQpf+ytqmyu9aaHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-24 at 11:40 +0100, Michal Kazior wrote:
> On 24 January 2014 10:52, Luca Coelho <luca@coelho.fi> wrote:
> > On Fri, 2014-01-24 at 09:40 +0100, Johannes Berg wrote:
> >> On Fri, 2014-01-24 at 09:41 +0200, Luca Coelho wrote:
> >>
> >> > Yeah, I agree that updating the IEs in mac80211 is not a good idea.
> >> > That's why I would prefer to have the notifications to the user space
> >> > ("your interface must switch channel") and wait for the userspace to
> >> > request a channel switch (with all the necessary information).
> >>
> >> Even in the sentence "your interface must switch channel" you're
> >> conflating multiple things though. Consider a managed+AP interface being
> >> concurrent, with the managed one receiving CSA from its BSS.
> >>
> >>  1) maybe it's a radar channel, and the AP detected radar, then we must
> >> switch
> >>     (to make authorities happy); but in this case we should have
> >> detected radar
> >>     as well on the AP we're running...
> >
> > Fine, the AP would have detected the radar.  Then it gets the "must
> > switch" notification triggered by the managed interface and can sync the
> > count, so both switch at the same time (which must be the case anyway).
> 
> What if the AP interface receives 'radar detected' before managed
> interfaces gets CSA? You'll need to consider both cases (either AP
> wants to switch first, or STA wants it first).

Hmmm... This should be okay, the only problem would be that the counts
may conflict.  If our AP decides to switch at count x and later our
station gets a CSA with count y.  The station cannot change the the
count (since it's chosen externally) and for the AP it's too late to
change (since the CSA has already been sent out).


> (z) I wonder if we could have nl80211 channel_switch also work with
> STA? This way we could have
> single-request-for-multi-interface-channel-switch work for
> GO-follow-STA too, as the STA interface would simply send out "I got a
> CSA: params.." and wait for either a channel_switch or disconnect
> after a timeout.

I don't really see how this would help.  It doesn't really make a
difference if we send an "I got a CSA: params" to the userspace, because
the userspace can't do anything but comply.  It's the same as if we send
a "you must switch or die" to the AP.


> The timeout itself would have to be conservative, i.e. possibly longer
> than beacon_interval x csa count so that userspace has time to make a
> decision (to prevent disconnects when csa count is small and/or
> userspace lags a bit due to I/O, etc). This (delaying STA chswitch,
> i.e. going beyond the bcnint x count threshold) should be safe since
> you don't really need to channel switch STA so fast (if you lag a few
> beacons nobody cares). Perhaps mac80211 could even use connection loss
> work for the timeout itself. All that needs to be taken care of is to
> lock tx queues on STA.

It's safeish for a station to switch later, but it will start losing
packets.  If it is not in the new channel by the time the AP told it to
be, it will start missing stuff.

It's possible for the AP to do some kind of check before starting to
transmit to the station again, like waiting for a NULL packet or
something, but this is not part of the specs, so we can't rely on it.


> This obviously means you get eventually disconnected with STA
> interface if you get a CSA without wpa_s running (i.e. `iw connect`.
> But then again.. I don't think it makes much sense to run your
> wireless stack _without_ wpa_s. Maybe current STA CSA behaviour could
> be left for single-interface cases, but I'm not really sure there
> would be much use for it?

I think this case is not that important to justify complicating things.
But still, it can be avoided if we don't do the "I got CSA: params"
notification.



> The same would have to be applied for IBSS and mesh -- they must not
> switch implicitly in-kernel upon receiving CSA but notify userspace
> about it and let userspace make the decision.

More complications... Especially because with MESH we need to replicate
the CSA packets.  So would the userspace send two requests for mesh? One
to say "it's okay to switch" and the other to say "trigger a switch"?


> This also means "switch or die" policy is moved to userspace where it
> probably should've been from the start.

/me shouts '"switch or die" or die!' :P

"switch or die" is not a policy, it's a fact.  It's easy for the kernel
to identify that and easy for the userspace to make the decision.
That's why I think a notification started in the kernel is a good idea.


> >> The same cases exist if, like you suggested, we'd make such a
> >> notification when one AP interface starts to switch. I'm still mostly
> >> against that though.
> >
> > I think we're in a deadlock of I'm pro and you're against. :)
> >
> >
> >> "[Y]our interface must switch channel" is therefore not very well
> >> defined, and I'd hate to see a client interface CSA-started notification
> >> interpreted as such;
> >
> > We don't send the "must switch" notification to the interfaces that
> > *triggered* the channel switch.  Either if it was a
> > client-interface-started CSA or if it was a remotely triggered CSA (ie.
> > the AP/GO our managed/client is connected to).  We send the notification
> > to the *other* interfaces that are on the same channel.
> 
> See (z).
> 
> 
> >
> >
> >> >  you can see that there's at least one sub-case where other
> >> > interfaces don't have to switch.
> >
> > The notification is also just sent if it *must* switch (ie. when there's
> > no extra context available).  In this case, even if the "other
> > interfaces don't have to switch", they must switch or die.
> 
> Actually you could want to migrate your AP along with STA even if you
> can operate on two channels. E.g. you might want to maximize
> performance and such, no?

Sure, but this is possible only when we have extra contexts.  And it can
be done later, as long as we have the "channel-switch done" notification
that we all seem to agree is needed.  No need to switch at the same
time.


> > Let's say hostapd is managing two APs.  It decides that AP1 needs to
> > switch channel.  At this point it doesn't necessarily know that AP2 must
> > also switch because there are no extra channel contexts available to
> > keep them in separate channels.  mac80211 knows and indicates that so
> > that hostapd decides to switch AP2 as well.  With the
> > single-CSA-request-for-mutliple-interfaces proposal, it must switch all
> > of them at once even if it *would be* possible to keep them in separate
> > channels, because there's no way of know that beforehand.
> 
> You could try to rely on "if (err == -EBUSY)
> ch_switch_all_the_things()". EBUSY at this point can either mean
> "iface comb impossible due to iftype/ifnum failure" or "num_diff_chans
> != available_num_chans". The former shouldn't be true since, well, you
> already got iftype/ifnum combo running, so you're only left with
> channel count. Or am I missing something?

You would need to rely on the response and keep trying different things
until you got it right.  The first case (iftype/ifnum) could also happen
because there is already another interface of type X in the new channel.
We have AP1 and AP2 in channel X and AP3 in channel Y.  The maximum
number of APs in the same channel is 2.  With single-CSA-request, if AP1
needs to move to Y, hostapd would ask both AP1 and AP2 to move to
channel Y.  Then it would get "EBUSY".  How does it know if the problem
is the lack of extra context or iftype/ifnum?

With a single interface per request this would happen: hostapd asks AP1
to move to channel Y.  Channel why can have both AP1 and AP3, so the
switch happens and we don't send a "switch or die" to AP2.  Everyone is
happy.  Now if AP2 also needs to switch, hostapd tried to switch to
channel Y.  It gets EBUSY because of iftype/ifnum.  It can then try
something else, like moving to channel Z.


> >>  The question also is how to handle it if
> >> wpa_s doesn't respond (e.g. old wpa_s version that has no idea what's
> >> going on) - which interface should "lose"?
> >
> > If it doesn't respond, the AP/GO will get disconnected.  That's where
> > the "switch or *die*" comes in.  If we're using an old wpa_s, this
> > wouldn't work anyway.  With my proposal and a *new* wpa_s, we could do
> > what I suggested above.
> >
> > How would the single-CSA-request-for-multiple-interfaces proposal help
> > in this case?
> 
> See (z).

(z) would still not work with older versions of wpa_s.

--
Luca.

