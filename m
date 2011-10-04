Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab1JDPHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 11:07:08 -0400
Subject: Re: [RFC] mac80211: remove per band sta supported rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <20110929150018.GA4554@redhat.com>
References: <1317121970-3638-1-git-send-email-sgruszka@redhat.com>
	 <1317123289.4082.12.camel@jlt3.sipsolutions.net>
	 <20110929150018.GA4554@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 17:07:04 +0200
Message-ID: <1317740824.6741.22.camel@jlt3.sipsolutions.net> (sfid-20111004_170712_694374_0F2A0C1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-29 at 17:00 +0200, Stanislaw Gruszka wrote:
> On Tue, Sep 27, 2011 at 01:34:49PM +0200, Johannes Berg wrote:
> > On Tue, 2011-09-27 at 13:12 +0200, Stanislaw Gruszka wrote:
> > > It is not possible to connect to remote station on two bands
> > > at once, or I'm wrong?
> > 
> > I don't think it is, but there could be channel switches maybe?
> 
> If AP would like to change to different band, it will need provide new
> Supported Rates element, or operate on older one.
> 
> So this could be simplified, but from other hand this helps to catch
> bugs, so maybe would be better to keep it. As long some other warning
> would be added to check that we send on proper channel.

Yeah I was going to say ... the main purpose of this these days seems to
be catching this tx-on-wrong-band (which should be channel) ...

> > > Which may happen when we are just after disassociation and changed
> > > channel/band, but still want send some frames (namely delBA) to old
> > > sta. Right fix should prevent to change channel before we fully
> > > dissassocate, or prevent to send frames after connection is lost,
> > > or both, but I don't know how to correctly do this so far.
> > 
> > Well, either we should simply not send the frame, or send it before
> > disassoc, no?
> 
> I think I can fix this that way, but I'm not sure if that would be right
> fix either. We have few instances of warning:

I think that would be the right fix. In some cases, we may want to
reorder things instead of just not sending frames.

> 1) started at ieee80211_sta_connection_lost()
> https://bugzilla.redhat.com/show_bug.cgi?id=731365#c0
> could be fixed by:
> ieee80211_set_disassoc(..., false);
> ieee80211_send_deauth_disassoc(, false);

Why would this trigger the problem? Can we somehow lose connection while
already trying to connect to a new AP?

> 2) started at ieee80211_tx_status()
> https://bugzilla.redhat.com/show_bug.cgi?id=731365#c11
> could be fixed by adding association check before 
> ieee80211_send_bar()

That seems reasonable. No use in trying to tear down BA sessions when
we're already disconnected.

> 3) started at ieee80211_offchannel_return()
> https://bugzilla.redhat.com/show_bug.cgi?id=737993#c0
> no idea how to fix

Hm, seems like maybe offchannel return is telling the AP that we woke
up, but maybe the offchannel work disconnected or something?

> All these problems looks like channel switching issue -
> - we changed channel, whereas we should still operate on old one.
> Fedora 15 users start to report that WARNING after update to 3.0
> from 2.6.38, so this could be related to Ben offchannel work.

That's very well possible.

Thanks for looking into all this!

johannes

