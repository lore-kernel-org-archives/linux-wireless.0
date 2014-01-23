Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaAWPlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 10:41:52 -0500
Message-ID: <1390491700.4142.24.camel@jlt4.sipsolutions.net> (sfid-20140123_164218_018871_3E2B7BC2)
Subject: Re: [PATCH 3/3] cfg80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 16:41:40 +0100
In-Reply-To: <1390469474.4189.81.camel@porter.coelho.fi>
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	 <1390226968-18928-4-git-send-email-michal.kazior@tieto.com>
	 <1390458525.4189.46.camel@porter.coelho.fi>
	 <1390465607.4142.7.camel@jlt4.sipsolutions.net>
	 <1390469474.4189.81.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 11:31 +0200, Luca Coelho wrote:

> > I don't think that makes sense. If userspace requested the CSA
> > operation, the fact that it will happen should be known as soon as the
> > request returns 0. No need for a notification (other than when the mlme
> > code in mac80211 decided to switch by itself). You're mixing the cases
> > of GO-follow-client-interface and switch-multiple-AP-BSSes, which I'm
> > not sure is right.
> 
> I think all cases should be treated in the same way.  No need to treat
> different scenarios differently.

I'm not suggesting that, I'm just saying that I don't think userspace
should have to ignore the return value. I think if the CSA request
succeeds, it should have every right to expect that the switch will
eventually succeed. I'm not saying it shouldn't also get a message
*when* it succeeded, but I don't think it should have to expect it to
completely fail still?

> I also like to think that, even though it's probably not a good idea, we
> *could* have two different processes in userspace handling the different
> interfaces (eg. two hostapd's).  If only the return value of the request
> is used, any other instances will not know something is happening.

It really seems like a bad idea to run different tools, but hey.

> I don't see how a notification can hurt.  It is just good to align all
> cases: mlme decided to switch or the userspace decided to switch.  In
> both cases, whoever is listening will get the notification that
> something is happening.

I'm not saying the notification hurts, I just think it's wrong to make
userspace look for a success/fail notification, IMHO it should be able
to expect it to work if the request succeeded.

> Let's say we have 2 APs with a single channel (your scenario).  AP1
> requests a channel switch with count 7.  AP2 gets a notification that
> its channel must switch at count 7.  AP2 decides to either follow or to
> shut itself down.

I don't think this whole notification scheme makes sense. Realistically,
we'll only have one hostapd or one wpa_s process controlling it, and
trying to support anything else will result in a big mess. Therefore,
hostapd can already know before the fact that the switch will occur -
it's the one requesting it.

> The same would happen for the GO-follow-client.  The client gets a
> channel switch with count 7.  GO gets a notification that its channel
> must switch at count 7.  GO decides to either follow or shut itself
> down.

This is the only different case, the AP we're connected to is requesting
the switch, and dictating the behaviour.

We *could have* implemented that as a notification to userspace, and
then made wpa_s request the switch with exactly the matching parameters,
but we implemented the reacting in mac80211 instead. That seems like a
reasonable choice since we don't have any real options (other than
disconnect, which we preserve since wpa_s might decide to do that upon
getting a "will switch" notification)

johannes

