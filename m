Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:37754 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaAXIDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 03:03:03 -0500
Message-ID: <1390550580.19968.22.camel@porter.coelho.fi> (sfid-20140124_090307_649594_E5D591DB)
Subject: Re: [PATCH 3/3] cfg80211: implement multi-interface CSA
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 24 Jan 2014 10:03:00 +0200
In-Reply-To: <1390491700.4142.24.camel@jlt4.sipsolutions.net>
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	 <1390226968-18928-4-git-send-email-michal.kazior@tieto.com>
	 <1390458525.4189.46.camel@porter.coelho.fi>
	 <1390465607.4142.7.camel@jlt4.sipsolutions.net>
	 <1390469474.4189.81.camel@porter.coelho.fi>
	 <1390491700.4142.24.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 16:41 +0100, Johannes Berg wrote:
> On Thu, 2014-01-23 at 11:31 +0200, Luca Coelho wrote:
> 
> > > I don't think that makes sense. If userspace requested the CSA
> > > operation, the fact that it will happen should be known as soon as the
> > > request returns 0. No need for a notification (other than when the mlme
> > > code in mac80211 decided to switch by itself). You're mixing the cases
> > > of GO-follow-client-interface and switch-multiple-AP-BSSes, which I'm
> > > not sure is right.
> > 
> > I think all cases should be treated in the same way.  No need to treat
> > different scenarios differently.
> 
> I'm not suggesting that, I'm just saying that I don't think userspace
> should have to ignore the return value. I think if the CSA request
> succeeds, it should have every right to expect that the switch will
> eventually succeed. I'm not saying it shouldn't also get a message
> *when* it succeeded, but I don't think it should have to expect it to
> completely fail still?

We cannot guarantee that the switch will succeed until the actual switch
is done.  Let's say a new interface is added to the target channel or if
regulatory changes.  It's possible that by the time we really switch
we're not allowed to use the target channel anymore (even though we
*were* allowed when it was requested).

Maybe the userspace can assume that the switch will succeed once it got
the OK response, but it still needs to be able to react if something
fails later.



> > I also like to think that, even though it's probably not a good idea, we
> > *could* have two different processes in userspace handling the different
> > interfaces (eg. two hostapd's).  If only the return value of the request
> > is used, any other instances will not know something is happening.
> 
> It really seems like a bad idea to run different tools, but hey.

I agree, it's probably a bad idea, but I also think that we shouldn't
enforce a single tool by the way we define the kernel API.


> > I don't see how a notification can hurt.  It is just good to align all
> > cases: mlme decided to switch or the userspace decided to switch.  In
> > both cases, whoever is listening will get the notification that
> > something is happening.
> 
> I'm not saying the notification hurts, I just think it's wrong to make
> userspace look for a success/fail notification, IMHO it should be able
> to expect it to work if the request succeeded.

Maybe we are talking about different notifications here... What I'm
referring to is a notification telling userspace that its interface must
switch channel (because we don't have an extra context).



> > Let's say we have 2 APs with a single channel (your scenario).  AP1
> > requests a channel switch with count 7.  AP2 gets a notification that
> > its channel must switch at count 7.  AP2 decides to either follow or to
> > shut itself down.
> 
> I don't think this whole notification scheme makes sense. Realistically,
> we'll only have one hostapd or one wpa_s process controlling it, and
> trying to support anything else will result in a big mess. Therefore,
> hostapd can already know before the fact that the switch will occur -
> it's the one requesting it.

It's just about flexibility.  *And*, it would also work if a STA
received a CSA notification (which we handle automatically in the
kernel) and there is an AP in the same context.


> > The same would happen for the GO-follow-client.  The client gets a
> > channel switch with count 7.  GO gets a notification that its channel
> > must switch at count 7.  GO decides to either follow or shut itself
> > down.
> 
> This is the only different case, the AP we're connected to is requesting
> the switch, and dictating the behaviour.

Exactly, and I'm trying to address this different case in the same way
as all other cases. ;)


> We *could have* implemented that as a notification to userspace, and
> then made wpa_s request the switch with exactly the matching parameters,
> but we implemented the reacting in mac80211 instead. That seems like a
> reasonable choice since we don't have any real options (other than
> disconnect, which we preserve since wpa_s might decide to do that upon
> getting a "will switch" notification)

Right, but this is irrelevant to my proposal.  In this case, we're
reacting to a CSA and telling the userspace that *other* interfaces in
that same channel need to switch.

--
Luca.

