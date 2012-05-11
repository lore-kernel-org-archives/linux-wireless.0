Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab2EKJc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 05:32:58 -0400
Message-ID: <1336728772.4310.6.camel@jlt3.sipsolutions.net> (sfid-20120511_113301_784493_79BEAC28)
Subject: Re: brcmsmac still woes, possible regression?
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	=?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>
Date: Fri, 11 May 2012 11:32:52 +0200
In-Reply-To: <20120510163525.GB32040@ubuntu-mba>
References: <4F744DD8.8010004@broadcom.com>
	 <20120329133835.GA5196@stt008.linux.site>
	 <CAKprTDFxqYq7jMm3z19xEt4NBeN9FbcR0pez9BSjY6R8kZC5KA@mail.gmail.com>
	 <20120402215005.GA13969@burratino> <4F7B179F.7070502@broadcom.com>
	 <20120509094111.GA2333@burratino> <4FAA45AF.8050201@broadcom.com>
	 <20120509174106.GA7189@ubuntu-mba> <4FAAB0FE.601@broadcom.com>
	 <1336587054.1121.2.camel@jlt3.sipsolutions.net>
	 <20120510163525.GB32040@ubuntu-mba>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-10 at 09:35 -0700, Seth Forshee wrote:

> > On passive channels, when scanning, mac80211 will send a probe only
> > after receiving a frame on that channel. When associating, it has no
> > such behaviour, at least not directly, but I suppose it could be
> > implemented (waiting for the beacon)
> 
> The background is that brcmsmac contains a bunch of code for regulatory
> support that is either duplicated (and in conflict) with the
> protocol-level support or else it would better be handled there. This is
> causing problems on pretty much any channel that isn't part of the
> default world regulatory domain.
> 
> I've sent RFC patches that strip out the vast majority of this code in
> favor of better integration with the protocol-level regulatory support.
> The piece that's under discussion here is a behavior I maintained in my
> changes, which mutes tx on passive scan channels until data is received
> on a given channel. But in my opinion, if this sort of behavior is
> desired it ought to be implemented at the protocol level instead of in
> the driver, so I'd really prefer to see it removed from brcmsmac.

This isn't implemented in mac80211, and since some HW (e.g. ours)
implements it in lower levels, I don't think you can just generally say
it has to be in mac80211 now.

johannes

