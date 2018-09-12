Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:54962 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbeILNYm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 09:24:42 -0400
Message-ID: <1536740466.3678.6.camel@sipsolutions.net> (sfid-20180912_102121_536760_0FB77929)
Subject: Re: [RFC] netlink: add NLA_REJECT policy type
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kubecek <mkubecek@suse.cz>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 12 Sep 2018 10:21:06 +0200
In-Reply-To: <20180912081621.GC29691@unicorn.suse.cz>
References: <20180912073245.8047-1-johannes@sipsolutions.net>
         <20180912081621.GC29691@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-12 at 10:16 +0200, Michal Kubecek wrote:
> On Wed, Sep 12, 2018 at 09:32:45AM +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > In some situations some netlink attributes may be used for output
> > only (kernel->userspace) or may be reserved for future use. It's
> > then helpful to be able to prevent userspace from using them in
> > messages sent to the kernel, since they'd otherwise be ignored and
> > any future will become impossible if this happens.
> > 
> > Add NLA_REJECT to the policy which does nothing but reject (with
> > EINVAL) validation of any messages containing this attribute.
> > 
> > The specific case I have in mind now is a shared nested attribute
> > containing request/response data, and it would be pointless and
> > potentially confusing to have userspace include response data in
> > the messages that actually contain a request.
> 
> I find this feature very useful. Actually, I was a bit surprised when
> I found I can't mark an attribute "forbidden" using policy.

:-)

> IMHO it would be even nicer if one could also specify an error message
> to use in extack if NLA_REJECT is applied; the easiest way would be
> using .validation_data and passing extack to validate_nla() but I'm not
> sure if it wouldn't qualify as an abuse.

I think it's fine - validation data is by nature validation type
dependent, so we can document it here. I'll send a v2.

johannes
