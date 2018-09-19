Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44097 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbeITAsO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 20:48:14 -0400
Date: Wed, 19 Sep 2018 16:08:51 -0300
From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/7] netlink: prepare validate extack setting for
 recursion
Message-ID: <20180919190851.GM4590@localhost.localdomain> (sfid-20180919_210902_167221_57EDACA0)
References: <20180919120900.28708-1-johannes@sipsolutions.net>
 <20180919120900.28708-6-johannes@sipsolutions.net>
 <18ea5293-5a12-7aca-7373-12d1ab3a0821@gmail.com>
 <1537374995.10305.47.camel@sipsolutions.net>
 <50773483-5732-8874-c5bf-99fa09d7e94a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50773483-5732-8874-c5bf-99fa09d7e94a@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2018 at 09:44:37AM -0700, David Ahern wrote:
> On 9/19/18 9:36 AM, Johannes Berg wrote:
> > On Wed, 2018-09-19 at 09:28 -0700, David Ahern wrote:
> >> On 9/19/18 5:08 AM, Johannes Berg wrote:
> >>> diff --git a/lib/nlattr.c b/lib/nlattr.c
> >>> index 966cd3dcf31b..2b015e43b725 100644
> >>> --- a/lib/nlattr.c
> >>> +++ b/lib/nlattr.c
> >>> @@ -69,7 +69,7 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
> >>>  
> >>>  static int validate_nla(const struct nlattr *nla, int maxtype,
> >>>  			const struct nla_policy *policy,
> >>> -			const char **error_msg)
> >>> +			struct netlink_ext_ack *extack, bool *extack_set)
> >>
> >> extack_set arg is not needed if you handle the "Attribute failed policy
> >> validation" message and NL_SET_BAD_ATTR here as well.
> > 
> > I'm not sure that's true, but perhaps you have a better idea than me?
> > 
> > My thought would be to introduce an "error" label in validate_nla(),
> > that sets up the extack data.
> > 
> > Then we could skip over that if we have a separate message to report,
> > making the NLA_REJECT case easier.
> > 
> > However, if we do nested validation, I'm not sure it really is that much
> > easier? We still need to figure out if the nested validation was setting
> > the message (and bad attr), rather than it having been set before we
> > even get into this function.
> > 
> > So let's say we have
> > 
> >         case NLA_NESTED:
> >                 /* a nested attributes is allowed to be empty; if its not,
> >                  * it must have a size of at least NLA_HDRLEN.
> >                  */
> >                 if (attrlen == 0)
> >                         break;
> >                 if (attrlen < NLA_HDRLEN)
> >                         return -ERANGE;
> >                 if (pt->validation_data) {
> >                         int err;
> > 
> >                         err = nla_validate_parse(nla_data(nla), nla_len(nla),
> >                                                  pt->len, pt->validation_data,
> >                                                  extack, extack_set, NULL);
> >                         if (err < 0)
> >                                 return err;
> >                 }
> >                 break;
> > 
> > right now after all the patches.
> > 
> > The "return -ERANGE;" would become "{ err = -ERANGE; goto error; }", but
> > I'm not really sure we can cleanly handle the other case?
> > 
> > Hmm. Maybe it works if we ensure that nla_validate_parse() has no other
> > return points that can fail outside of validate_nla(), or we set up the
> > extack data there as well, so that once we have a nested
> > nla_validate_parse() we know that it's been set.
> > 
> > Actually, we need to do that anyway so that we can move the setting into
> > validate_nla(), and then it should work.
> > 
> > Mechanics aside - I'll take a look later tonight or tomorrow - do you
> > think the goal/external interface of this makes sense?
> 
> If it fails and returns (nested and all) on the first failure it should
> be fine. I was thinking something like this (whitespace damaged on paste):

This will avoid the situation that we were discussing in the older
thread, btw.

  Marcelo
