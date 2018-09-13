Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39806 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727859AbeINBzD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 21:55:03 -0400
Date: Thu, 13 Sep 2018 22:43:53 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
Message-ID: <20180913204352.GB3876@unicorn.suse.cz> (sfid-20180913_224359_991611_5183ED18)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
 <20180913104955.GE29691@unicorn.suse.cz>
 <1536837915.4160.1.camel@sipsolutions.net>
 <20180913120554.GG29691@unicorn.suse.cz>
 <20180913192014.GE4590@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180913192014.GE4590@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 13, 2018 at 04:20:14PM -0300, Marcelo Ricardo Leitner wrote:
> On Thu, Sep 13, 2018 at 02:05:54PM +0200, Michal Kubecek wrote:
> > On Thu, Sep 13, 2018 at 01:25:15PM +0200, Johannes Berg wrote:
> > > On Thu, 2018-09-13 at 12:49 +0200, Michal Kubecek wrote:
> > > 
> > > > >  		if (type > 0 && type <= maxtype) {
> > > > >  			if (policy) {
> > > > > -				err = validate_nla(nla, maxtype, policy);
> > > > > +				err = validate_nla(nla, maxtype, policy,
> > > > > +						   extack);
> > > > >  				if (err < 0) {
> > > > > -					NL_SET_ERR_MSG_ATTR(extack, nla,
> > > > > -							    "Attribute failed policy validation");
> > > > > +					NL_SET_BAD_ATTR(extack, nla);
> > > > > +					if (extack && !extack->_msg)
> > > > > +						NL_SET_ERR_MSG(extack,
> > > > > +							       "Attribute failed policy validation");
> > > > >  					goto errout;
> > > > >  				}
> > > > >  			}
> > > > > -- 
> > > > 
> > > > Technically, this would change the outcome when nla_parse() is called
> > > > with extack->_msg already set nad validate_nla() fails on something else
> > > > than NLA_REJECT; it will preserve the previous message in such case.
> > > > But I don't think this is a serious problem.
> > > 
> > > Yes, that's true. I looked at quite a few of the setters just now (there
> > > are ~500 already, wow!), and they all set & return, so this shouldn't be
> > > an issue.
> > 
> > In ethtool (work in progress) I sometimes use extack message for
> > non-fatal warnings but AFAICS never before parsing the userspace
> > request (actually always shortly before returning). So I don't have
> > a problem with it.
> 
> Considering we can only report 1 message, it should be okay to drop
> the previous message in favor of the new one, which is either a
> critical one or just another non-fatal one.

What I wanted to point out is that the code above does not behave like
this. It does not distinguish between extack->_msg set by NLA_REJECT
branch and extack->_msg which had been set before nla_parse() was
called.

Michal Kubecek
