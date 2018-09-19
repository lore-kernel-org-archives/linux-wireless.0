Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:56264 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbeISWKC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 18:10:02 -0400
Message-ID: <1537374671.10305.41.camel@sipsolutions.net> (sfid-20180919_183128_294861_F71AEB04)
Subject: Re: [PATCH 3/7] netlink: set extack error message in nla_validate()
From: Johannes Berg <johannes@sipsolutions.net>
To: David Ahern <dsahern@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 19 Sep 2018 18:31:11 +0200
In-Reply-To: <3e7aadff-5228-660a-537a-9b54c11fa5cc@gmail.com> (sfid-20180919_182023_809529_1EF8ED3D)
References: <20180919120900.28708-1-johannes@sipsolutions.net>
         <20180919120900.28708-4-johannes@sipsolutions.net>
         <3e7aadff-5228-660a-537a-9b54c11fa5cc@gmail.com>
         (sfid-20180919_182023_809529_1EF8ED3D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-19 at 09:20 -0700, David Ahern wrote:

> >  	nla_for_each_attr(nla, head, len, rem) {
> > -		int err = validate_nla(nla, maxtype, policy, NULL);
> > +		static const char _msg[] = "Attribute failed policy validation";
> > +		const char *msg = _msg;
> > +		int err = validate_nla(nla, maxtype, policy, &msg);
> >  
> >  		if (err < 0) {
> > +			if (extack)
> > +				extack->_msg = msg;
> >  			NL_SET_BAD_ATTR(extack, nla);
> 
> msg, NL_SET_BAD_ATTR and extack handling all can be done in validate_nla
> removing the need for the same message ("Attribute failed policy
> validation") to be declared twice and simplifying the extack setting.

Yeah, perhaps I should take another look at that. I didn't want to do
that originally as validate_nla() has so many exit points, but perhaps
it's better to put a goto label there.

FWIW, in the next patch I'm getting rid of the duplication again - I
wanted to have the patch that has an effect (this one, setting the
message) more clearly separated.

johannes
