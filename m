Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34970 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbcBWUwr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 15:52:47 -0500
Message-ID: <1456260764.9910.31.camel@sipsolutions.net> (sfid-20160223_215250_112573_27D78A1A)
Subject: Re: [PATCH V7 1/2] nl80211: add feature for BSS selection support
From: Johannes Berg <johannes@sipsolutions.net>
To: arend@broadcom.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 23 Feb 2016 21:52:44 +0100
In-Reply-To: <56CCC50E.4040300@broadcom.com> (sfid-20160223_214611_910140_8E829C65)
References: <1455706070-11915-1-git-send-email-arend@broadcom.com>
	 <1456237245.9910.16.camel@sipsolutions.net> <56CCC50E.4040300@broadcom.com>
	 (sfid-20160223_214611_910140_8E829C65)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 21:46 +0100, Arend Van Spriel wrote:
> 
> > Maybe we should be less specific here regarding the NLA_FLAG and
> > say
> > that it will contain attributes for each, indicating which
> > behaviours
> > are supported, and say there's behaviour-dependent data inside each
> > of
> > those attributes?
> 
> For the GET_WIPHY case there will be not behaviour dependent data.
> 
> > It seems entirely plausible that future behaviours would require
> > their
> > own sub-capabilities; perhaps that's even the case today for having
> > an
> > adjustment range for example, not that I think it's really
> > necessary
> > now.
> 
> At least it does not harm to take that into account.

Right; there isn't today, but there might be later, so for the
GET_WIPHY case it might be worth just specifying that there will be an
attribute, not that it's NLA_FLAG?

Not that it'll matter much - only when we actually add such could
applications possibly want to parse them :)

> > > +	/* only process one nested attribute */
> > > +	nest = nla_data(nla);
> > > +	if (!nla_ok(nest, nla_len(nest)))
> > > +		return -EBADF;
> > 
> > This isn't quite clear to me. Shouldn't you do this by declaring it
> > NLA_TESTED in the nl80211_policy?
> 
> Guess you mean NLA_NESTED.

Heh, yeah.

> > Actually, not really? you use nla_ok() on the inner (without having
> > checked at all that it's even long enough btw, since you didn't do
> > the
> > policy change), but that would already be done by nla_parse()
> > below?
> 
> Because ATTR_BSS_SELECT is used in CMD_GET_WIPHY and CMD_CONNECT the
> length of the attribute is not a constant. Or do I only need to put
> length in nl80211_policy for userspace-2-kernel direction, ie. for
> ATTR_BSS_SELECT in CMD_CONNECT.

Ah. kernel->userspace messages don't use the policy in any way, it's
just for the userspace->kernel message validation, so you can put there
what's needed for CMD_CONNECT and ignore GET_WIPHY.


johannes
