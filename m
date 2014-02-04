Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:39109 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaBDKHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 05:07:17 -0500
Message-ID: <1391508433.26522.61.camel@porter.coelho.fi> (sfid-20140204_110721_719973_A1EF1F3C)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 04 Feb 2014 12:07:13 +0200
In-Reply-To: <1391434913.4488.24.camel@jlt4.sipsolutions.net>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140203_110356_335827_0A67B036) <1391434913.4488.24.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-03 at 14:41 +0100, Johannes Berg wrote:
> On Mon, 2014-02-03 at 10:58 +0100, Michal Kazior wrote:
> > This introduces the following benefits:
> >  * cfg80211 is now aware of channel switching
> >    (although more work still needs to be done wrt
> >     interface combinations & multi-interface CSA)
> >  * fixes some channel switching failcases by
> >    disconnecting offending interfaces
> >  * STA CSA no longer modifies BSS channel from
> >    within mac80211
> 
> That's nice.
> 
> > This aims to make the following possible later:
> >  * defer channel switching decision to userspace
> >    (if desired so),
> 
> That's probably not needed, it can disconnect after the CSA event (that
> should be sent when the CSA is first received)

I agree that this shouldn't be needed for client (ie. P2P client or
managed) interfaces.


> >  * inform userspace what interfaces will be
> >    possibly disconnected by a channel switch,
> 
> Huh? Not sure I get that part, why would userspace ever be notified
> about something that *will* happen? Either the interface disconnects
> when the CSA is received, or it just switches and userspace gets a "CSA
> will happen" event?

How do we get the "target" beacon from userspace if the interface just
switches?

Now a bit of brain burp: I think that the "count" decision should remain
in the userspace so it can decide to give more time for its stations to
switch.  Eg. if the client interface got a CSA with count == x and a
host interface has dtim_interval > x, the userspace can send a "quiet"
CSA with count == dtim_interval + 1.  The two requests would be "merged"
and the highest count would win.  The client would be a bit late on the
new channel, but at least the AP wouldn't lose most of its clients.
Does this make any sense? I'm not sure myself. :)


> >  * disconnect non-complying interfaces that were
> >    sharing a channel that is being abandoned by
> >    channel switching interface(s),
> 
> Hmm, that sounds a bit the wrong way around? Shouldn't the CSA not be
> possible (userspace CSA) or cause the switching interface to disconnect,
> rather than *others*??

It depends.  And this logic is too complicated to stay in the kernel,
IMHO.  If we are in a GO-follows-STA scenario, we want to disconnect the
GO.  Now, if you have an AP (with tons of STAs connected to it) and a
P2P client gets a CSA for whatever reason, do we really want to stop the
AP?


> > - * @channel_switch: initiate channel-switch procedure (with CSA)
> > + * @ch_switch_start: initiate channel-switch procedure (with CSA). This should
> > + *	prompt the driver to perform preparation work (start some timers,
> > + *	include CS IEs in beacons, etc) but don't do an actual channel switch.
> > + *	Once driver has completed all preparations and is ready for the actual
> > + *	switch (after CSA counter is completed) it must call
> > + *	cfg80211_ch_switch_complete(wdev). After that ch_switch_finalize() MAY
> > + *	be called, but it doesn't necessarily happen immediately as cfg80211
> > + *	may need to synchronize with other interfaces. If channel switch is
> > + *	cancelled for some reason ch_switch_finalize() is not called and driver
> > + *	should free up resources/cleanup state in interface disconnection flow.
> > + * @ch_switch_finalize: finalize channel-switch procedure, i.e. perform the
> > + *	actual switch.
> 
> I don't like this at all. This totally assumes that every driver behaves
> like mac80211, which clearly is not the case. The split between
> "starting" and "finalizing" it should not be part of the API.

I agree, especially if the driver offloads the channel switch, in which
case it wouldn't be possible for cfg80211 to hold the finalize call to
sync all the interfaces.

--
Luca.

