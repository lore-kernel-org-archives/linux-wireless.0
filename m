Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34245 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaAXJwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 04:52:55 -0500
Message-ID: <1390557170.19968.72.camel@porter.coelho.fi> (sfid-20140124_105336_738581_988A0852)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Fri, 24 Jan 2014 11:52:50 +0200
In-Reply-To: <1390552837.4257.33.camel@jlt4.sipsolutions.net>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-24 at 09:40 +0100, Johannes Berg wrote:
> On Fri, 2014-01-24 at 09:41 +0200, Luca Coelho wrote:
> 
> > Yeah, I agree that updating the IEs in mac80211 is not a good idea.
> > That's why I would prefer to have the notifications to the user space
> > ("your interface must switch channel") and wait for the userspace to
> > request a channel switch (with all the necessary information).
> 
> Even in the sentence "your interface must switch channel" you're
> conflating multiple things though. Consider a managed+AP interface being
> concurrent, with the managed one receiving CSA from its BSS.
> 
>  1) maybe it's a radar channel, and the AP detected radar, then we must
> switch
>     (to make authorities happy); but in this case we should have
> detected radar
>     as well on the AP we're running...

Fine, the AP would have detected the radar.  Then it gets the "must
switch" notification triggered by the managed interface and can sync the
count, so both switch at the same time (which must be the case anyway).


>  2) maybe it's a non-radar 5 GHz channel, and the device (like iwlwifi)
> only
>     permitted beaconing on 5 GHz as long as connected to another AP,
> then we
>     also must switch (to make the device happy)

Check!


>  3) maybe it's neither, or the device is allowed to use non-radar
> channels for
>     AP/GO operation, but the AP we're connected to just decided to
> switch for
>     other implementation-specific reasons, e.g. wanting to use a better
> channel,
>     *AND* we don't have enough channel contexts to stay, so we "must"
> switch

Check!


> The same cases exist if, like you suggested, we'd make such a
> notification when one AP interface starts to switch. I'm still mostly
> against that though.

I think we're in a deadlock of I'm pro and you're against. :)


> "[Y]our interface must switch channel" is therefore not very well
> defined, and I'd hate to see a client interface CSA-started notification
> interpreted as such;

We don't send the "must switch" notification to the interfaces that
*triggered* the channel switch.  Either if it was a
client-interface-started CSA or if it was a remotely triggered CSA (ie.
the AP/GO our managed/client is connected to).  We send the notification
to the *other* interfaces that are on the same channel.


> >  you can see that there's at least one sub-case where other
> > interfaces don't have to switch.

The notification is also just sent if it *must* switch (ie. when there's
no extra context available).  In this case, even if the "other
interfaces don't have to switch", they must switch or die.


> It sounds to me like you're still hung up on the whole "ohh, what if
> there's wpa_s and hostapd running" thing ... I really don't think it's a
> concern. I'd be rather surprised if this was the only thing that'd break
> then.

Not really.  I don't care what is the binary listening to the
notifications.  I just think it's probably much cleaner to treat the
interfaces independently.

Let's say hostapd is managing two APs.  It decides that AP1 needs to
switch channel.  At this point it doesn't necessarily know that AP2 must
also switch because there are no extra channel contexts available to
keep them in separate channels.  mac80211 knows and indicates that so
that hostapd decides to switch AP2 as well.  With the
single-CSA-request-for-mutliple-interfaces proposal, it must switch all
of them at once even if it *would be* possible to keep them in separate
channels, because there's no way of know that beforehand.


> The question also is whether we want to handle all the corner cases.
> Consider this corner case:
>  * non-chanctx driver
>  * running at least one AP/GO
>  * running one station interface connected to BSS1
>  * BSS1 decides to do a CSA
> 
> Even today, we'll try to execute the channel switch, even though that
> completely leaves the AP/GO interface dead in the water and beaconing
> wrongly. That's something we should probably address.

I think today, if we have non-chanctx with more than one vif and the
station gets a CSA, we disconnect the station, don't we?


>  The question is
> how we should address it. It seems to me that you actually want to
> handle that case by asking wpa_s to switch the AP/GO interface, but I'm
> not really sure it's necessary?

With non-chanctx or no-more-chanctx-available cases the AP/GO must
switch.  Or, if hostapd is managing both, it can disconnect the STA,
upon receiving the "AP must switch" notification so that the AP doesn't
have to change channel (if for whatever reason hostapd thinks the AP has
higher priority).


>  The question also is how to handle it if
> wpa_s doesn't respond (e.g. old wpa_s version that has no idea what's
> going on) - which interface should "lose"?

If it doesn't respond, the AP/GO will get disconnected.  That's where
the "switch or *die*" comes in.  If we're using an old wpa_s, this
wouldn't work anyway.  With my proposal and a *new* wpa_s, we could do
what I suggested above.

How would the single-CSA-request-for-multiple-interfaces proposal help
in this case?


> IMHO we don't have to design it to handle all these quirky corner cases.
> This particular case might be something we want to handle for case 2)
> above, but who actually cares? The only driver that is looking at case 2
> is ours, and that has channel contexts, so we don't really have to
> handle it with non-chanctx.

To tell you the truth, I didn't think about this "quirky corner case",
but it just happens that my "switch or die notification" proposal would
still allow it to be handled.


> It's obvious that we need a "CSA started" notification for managed mode
> interfaces. It's not clear to me that we need it for AP interfaces,
> since handling multiple AP interfaces with different hostapd instances
> is stupid to start with, and IMHO this makes the situation more complex.

I don't care about the "CSA started" notification for AP interfaces.
What I want to see is a "your interface must switch or die" indication
when *needed* (ie. with non-chanctx or no-extra-chanctx-available).


> Let's enumerate all the corner cases. Let me know if I missed some.
> 
>  1. chanctx drivers
>    a) managed mode CSA received with other interfaces present, but no
> available
>       channel context(s)
>    b) AP CSA requested by userspace with other interfaces present, but
> no
>       available channel context(s)
>    c) (mesh CSA has similar cases, I believe)
>    d) (IBSS CSA has similar cases for drivers that allow IBSS/other
> combinations)
>  2. non-chanctx drivers
>    a) managed mode CSA received with other interfaces present
>    b) AP CSA requested by userspace with other interfaces present
>    c) (mesh)
>    d) (IBSS)
> 
> (Is that all?)

I assume that MESH and IBSS are, in the current context, the same as
either a) or b), depending on whether our station started or is
responding to the channel switch.


> Those cases are (mostly) identical if we treat non-chanctx drivers as
> having exactly one channel context.

Yes.


> I can't really speak for cases c) and d), but would think handling them
> like the others would make sense. I'd also leave the question of
> regulatory compliance out of the CSA mechanism entirely. If we discuss
> the CSA case 2) at the beginning of this email, for example, then we
> could argue that we should require the CSA or whatever. I say that we
> should enforce the regulatory stuff after the fact, and stop the AP
> interface if the managed one is gone for a while/too long from that
> channel. That can be enforced in cfg80211 fairly easily.

Yes, I think we should treat regulatory separately.  Regardless of what
wpa_s/hostapd decides to do, we can enforce it in cfg80211 when the
request is made.


> With that then, I'd suggest that in case a), the managed mode interface
> just disconnects, as it does today. There would be a possibility that we
> could send the "I need to do CSA" event to userspace so it could
> simultaneously switch the AP to the same channel, but I'm not convinced
> it's worth it.


I'd say it's debatable. :D


> In case b), I'd say that the CSA should be refused. If needed,
> wpa_supplicant could have disconnected the managed interfaces (it knows
> about possible channel combinations), otherwise this will fail and it
> needs to be prepared for failures anyway (and will likely shut down the
> GO in that case.) This does, however, imply that we need multi-AP
> switching like Michał implemented. I don't really see how else to do it,
> because if you want to keep this as multiple single-interface switches
> you (i) can't enforce the switch time and (ii) have to add complex code
> to handle the case where userspace 'forgets' to switch one of the many
> interfaces.

(i) we should somehow "merge" the switch time.  We would have to do this
anyway if the switch was triggered via a managed interface (ie. the BSS
it's connected to sent the CSA).  With either proposals, we would get a
notification about this (either the "must switch" or the "CSA started")
and would have to request a CSA for the AP interface with the same
switch time.


(ii) this is very simple: if the userspace "forgets" to switch any of
the interfaces, we disconnect it.  It's the same as if the userspace
would "forget" to include one of the interfaces in the
single-CSA-request-with-multiple-interfaces implementation.


> IMHO the complexity of multi-switch is less than for trying to handle
> that (ii) case and similar corner cases.

As I see it, with the single-switch you need to treat lots of different
corner cases separately.  And force some outcomes (eg. refuse the CSA
request in case b).  With the multi-switch There Are No Corner
Cases[TM]. :P

--
Luca.

