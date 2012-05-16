Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:32772 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965584Ab2EPUP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:15:26 -0400
Date: Wed, 16 May 2012 15:15:21 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>
Subject: Re: brcmsmac still woes, possible regression?
Message-ID: <20120516201521.GA22946@thinkpad-t410> (sfid-20120516_221530_107513_0A152D63)
References: <20120402215005.GA13969@burratino>
 <4F7B179F.7070502@broadcom.com>
 <20120509094111.GA2333@burratino>
 <4FAA45AF.8050201@broadcom.com>
 <20120509174106.GA7189@ubuntu-mba>
 <4FAAB0FE.601@broadcom.com>
 <1336587054.1121.2.camel@jlt3.sipsolutions.net>
 <20120510163525.GB32040@ubuntu-mba>
 <1336728772.4310.6.camel@jlt3.sipsolutions.net>
 <20120511173149.GA20232@ubuntu-mba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120511173149.GA20232@ubuntu-mba>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2012 at 10:31:49AM -0700, Seth Forshee wrote:
> > > I've sent RFC patches that strip out the vast majority of this code in
> > > favor of better integration with the protocol-level regulatory support.
> > > The piece that's under discussion here is a behavior I maintained in my
> > > changes, which mutes tx on passive scan channels until data is received
> > > on a given channel. But in my opinion, if this sort of behavior is
> > > desired it ought to be implemented at the protocol level instead of in
> > > the driver, so I'd really prefer to see it removed from brcmsmac.
> > 
> > This isn't implemented in mac80211, and since some HW (e.g. ours)
> > implements it in lower levels, I don't think you can just generally say
> > it has to be in mac80211 now.
> 
> I guess I need to familiarize myself with the situation for other
> hardware then, which I will do next week when I'm not at a conference.
> It just seems to me that if we want to enforce consistent regulatory
> behavior for all HW then mac80211 is the logical place to implement it.

I had a look at iwlwifi, and I see how passive channels are being
handled. I don't understand though how having this functionality in
mac80211 would hurt iwlwifi, but perhaps we can find an acceptible
solution.

Actually the support already present for regulatory beacon hints would
probably suit this purpose fairly well, and in fact it already does seem
to work for some channels. But for reasons I don't understand the beacon
hints are only processed for channels with IEEE80211_CHAN_RADAR cleared,
making it ineffective for most of the 5 GHz band. If this was changed to
at least give the driver some indication that a beacon has been seen on
the channel (even just setting chan->beacon_found) then drivers should
be able to use it to know when tx can be enabled on passive channels.

Cheers,
Seth

