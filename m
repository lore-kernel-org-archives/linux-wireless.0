Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2E2HQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 03:16:17 -0400
Message-ID: <1338275778.4342.26.camel@jlt3.sipsolutions.net> (sfid-20120529_091623_300773_2E6C482F)
Subject: Re: brcmsmac still woes, possible regression?
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	=?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>
Date: Tue, 29 May 2012 09:16:18 +0200
In-Reply-To: <20120516201521.GA22946@thinkpad-t410>
References: <20120402215005.GA13969@burratino>
	 <4F7B179F.7070502@broadcom.com> <20120509094111.GA2333@burratino>
	 <4FAA45AF.8050201@broadcom.com> <20120509174106.GA7189@ubuntu-mba>
	 <4FAAB0FE.601@broadcom.com> <1336587054.1121.2.camel@jlt3.sipsolutions.net>
	 <20120510163525.GB32040@ubuntu-mba>
	 <1336728772.4310.6.camel@jlt3.sipsolutions.net>
	 <20120511173149.GA20232@ubuntu-mba> <20120516201521.GA22946@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-16 at 15:15 -0500, Seth Forshee wrote:

> > > This isn't implemented in mac80211, and since some HW (e.g. ours)
> > > implements it in lower levels, I don't think you can just generally say
> > > it has to be in mac80211 now.
> > 
> > I guess I need to familiarize myself with the situation for other
> > hardware then, which I will do next week when I'm not at a conference.
> > It just seems to me that if we want to enforce consistent regulatory
> > behavior for all HW then mac80211 is the logical place to implement it.
> 
> I had a look at iwlwifi, and I see how passive channels are being
> handled. I don't understand though how having this functionality in
> mac80211 would hurt iwlwifi, but perhaps we can find an acceptible
> solution.

I'm just thinking that having both would make it have a bigger delay or
so. Since mac80211 can't really know our device's internal state (even
the driver can't really keep track easily) we couldn't remove the
iwlwifi pieces.

> Actually the support already present for regulatory beacon hints would
> probably suit this purpose fairly well, and in fact it already does seem
> to work for some channels. But for reasons I don't understand the beacon
> hints are only processed for channels with IEEE80211_CHAN_RADAR cleared,
> making it ineffective for most of the 5 GHz band. If this was changed to
> at least give the driver some indication that a beacon has been seen on
> the channel (even just setting chan->beacon_found) then drivers should
> be able to use it to know when tx can be enabled on passive channels.

RADAR channels have specific time requirements, the beacon hints are
used for something like "geography detection".

johannes

