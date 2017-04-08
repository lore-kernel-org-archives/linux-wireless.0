Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40370 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752288AbdDHUPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 16:15:16 -0400
Message-ID: <1491682511.2379.2.camel@sipsolutions.net> (sfid-20170408_221554_377712_DEC566AE)
Subject: Re: [PATCH 4/5] netlink: pass extended ACK struct to parsing
 functions
From: Johannes Berg <johannes@sipsolutions.net>
To: David Ahern <dsa@cumulusnetworks.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>, jiri@resnulli.us
Date: Sat, 08 Apr 2017 22:15:11 +0200
In-Reply-To: <3077bf17-553d-f9e3-8873-c59fbb26e2aa@cumulusnetworks.com> (sfid-20170408_205014_016171_8149213D)
References: <20170408174900.12820-1-johannes@sipsolutions.net>
         <20170408174900.12820-5-johannes@sipsolutions.net>
         <3077bf17-553d-f9e3-8873-c59fbb26e2aa@cumulusnetworks.com>
         (sfid-20170408_205014_016171_8149213D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-04-08 at 14:50 -0400, David Ahern wrote:
> On 4/8/17 1:48 PM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Pass the new extended ACK reporting struct to all of the
> > generic netlink parsing functions. For now, pass NULL in
> > almost all callers (except for some in the core.)
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> fails to compile as well:
> 
> In file included from /home/dsa/kernel-
> 4.git/net/sched/cls_rsvp.c:27:0:
> /home/dsa/kernel-4.git/net/sched/cls_rsvp.h: In function
> ‘rsvp_change’:
> /home/dsa/kernel-4.git/net/sched/cls_rsvp.h:487:8: error: too few
> arguments to function ‘nla_parse_nested’
>   err = nla_parse_nested(tb, TCA_RSVP_MAX, opt, rsvp_policy);
>         ^

Yeah, spatch misses header files without special command-line arguments
... this should be fixed in v2, the kbuild bot also noticed it.

johannes
