Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57816 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2EKRbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 13:31:55 -0400
Date: Fri, 11 May 2012 10:31:49 -0700
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>
Subject: Re: brcmsmac still woes, possible regression?
Message-ID: <20120511173149.GA20232@ubuntu-mba> (sfid-20120511_193159_176421_F4EAA0BF)
References: <CAKprTDFxqYq7jMm3z19xEt4NBeN9FbcR0pez9BSjY6R8kZC5KA@mail.gmail.com>
 <20120402215005.GA13969@burratino>
 <4F7B179F.7070502@broadcom.com>
 <20120509094111.GA2333@burratino>
 <4FAA45AF.8050201@broadcom.com>
 <20120509174106.GA7189@ubuntu-mba>
 <4FAAB0FE.601@broadcom.com>
 <1336587054.1121.2.camel@jlt3.sipsolutions.net>
 <20120510163525.GB32040@ubuntu-mba>
 <1336728772.4310.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336728772.4310.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2012 at 11:32:52AM +0200, Johannes Berg wrote:
> On Thu, 2012-05-10 at 09:35 -0700, Seth Forshee wrote:
> 
> > > On passive channels, when scanning, mac80211 will send a probe only
> > > after receiving a frame on that channel. When associating, it has no
> > > such behaviour, at least not directly, but I suppose it could be
> > > implemented (waiting for the beacon)
> > 
> > The background is that brcmsmac contains a bunch of code for regulatory
> > support that is either duplicated (and in conflict) with the
> > protocol-level support or else it would better be handled there. This is
> > causing problems on pretty much any channel that isn't part of the
> > default world regulatory domain.
> > 
> > I've sent RFC patches that strip out the vast majority of this code in
> > favor of better integration with the protocol-level regulatory support.
> > The piece that's under discussion here is a behavior I maintained in my
> > changes, which mutes tx on passive scan channels until data is received
> > on a given channel. But in my opinion, if this sort of behavior is
> > desired it ought to be implemented at the protocol level instead of in
> > the driver, so I'd really prefer to see it removed from brcmsmac.
> 
> This isn't implemented in mac80211, and since some HW (e.g. ours)
> implements it in lower levels, I don't think you can just generally say
> it has to be in mac80211 now.

I guess I need to familiarize myself with the situation for other
hardware then, which I will do next week when I'm not at a conference.
It just seems to me that if we want to enforce consistent regulatory
behavior for all HW then mac80211 is the logical place to implement it.

Seth

