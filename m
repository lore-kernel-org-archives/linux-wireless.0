Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:43712 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbeIMQe2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 12:34:28 -0400
Message-ID: <1536837915.4160.1.camel@sipsolutions.net> (sfid-20180913_132532_629901_892A7A78)
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kubecek <mkubecek@suse.cz>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 13 Sep 2018 13:25:15 +0200
In-Reply-To: <20180913104955.GE29691@unicorn.suse.cz>
References: <20180913084603.7979-1-johannes@sipsolutions.net>
         <20180913104955.GE29691@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-09-13 at 12:49 +0200, Michal Kubecek wrote:

> >  		if (type > 0 && type <= maxtype) {
> >  			if (policy) {
> > -				err = validate_nla(nla, maxtype, policy);
> > +				err = validate_nla(nla, maxtype, policy,
> > +						   extack);
> >  				if (err < 0) {
> > -					NL_SET_ERR_MSG_ATTR(extack, nla,
> > -							    "Attribute failed policy validation");
> > +					NL_SET_BAD_ATTR(extack, nla);
> > +					if (extack && !extack->_msg)
> > +						NL_SET_ERR_MSG(extack,
> > +							       "Attribute failed policy validation");
> >  					goto errout;
> >  				}
> >  			}
> > -- 
> 
> Technically, this would change the outcome when nla_parse() is called
> with extack->_msg already set nad validate_nla() fails on something else
> than NLA_REJECT; it will preserve the previous message in such case.
> But I don't think this is a serious problem.

Yes, that's true. I looked at quite a few of the setters just now (there
are ~500 already, wow!), and they all set & return, so this shouldn't be
an issue.

johannes
