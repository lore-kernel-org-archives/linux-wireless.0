Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53291 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab2EJQfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 12:35:30 -0400
Date: Thu, 10 May 2012 09:35:25 -0700
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>
Subject: Re: brcmsmac still woes, possible regression?
Message-ID: <20120510163525.GB32040@ubuntu-mba> (sfid-20120510_183541_667999_CBEFA5F6)
References: <4F744DD8.8010004@broadcom.com>
 <20120329133835.GA5196@stt008.linux.site>
 <CAKprTDFxqYq7jMm3z19xEt4NBeN9FbcR0pez9BSjY6R8kZC5KA@mail.gmail.com>
 <20120402215005.GA13969@burratino>
 <4F7B179F.7070502@broadcom.com>
 <20120509094111.GA2333@burratino>
 <4FAA45AF.8050201@broadcom.com>
 <20120509174106.GA7189@ubuntu-mba>
 <4FAAB0FE.601@broadcom.com>
 <1336587054.1121.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336587054.1121.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 09, 2012 at 08:10:54PM +0200, Johannes Berg wrote:
> On Wed, 2012-05-09 at 20:01 +0200, Arend van Spriel wrote:
> 
> > As part of the discussion over here I am proposing to get rid of the tx
> > muting in brcmsmac as mac80211 already has that behaviour for passive
> > channels if I am not mistaken (is this true, Johannes?).
> 
> Arend, I haven't really followed this discussion, can you elaborate?
> 
> On passive channels, when scanning, mac80211 will send a probe only
> after receiving a frame on that channel. When associating, it has no
> such behaviour, at least not directly, but I suppose it could be
> implemented (waiting for the beacon)

The background is that brcmsmac contains a bunch of code for regulatory
support that is either duplicated (and in conflict) with the
protocol-level support or else it would better be handled there. This is
causing problems on pretty much any channel that isn't part of the
default world regulatory domain.

I've sent RFC patches that strip out the vast majority of this code in
favor of better integration with the protocol-level regulatory support.
The piece that's under discussion here is a behavior I maintained in my
changes, which mutes tx on passive scan channels until data is received
on a given channel. But in my opinion, if this sort of behavior is
desired it ought to be implemented at the protocol level instead of in
the driver, so I'd really prefer to see it removed from brcmsmac.

Seth

