Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:32818 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbeINDKH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 23:10:07 -0400
Date: Thu, 13 Sep 2018 18:58:39 -0300
From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Michal Kubecek <mkubecek@suse.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>, jbenc@redhat.com
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
Message-ID: <20180913215839.GI27095@localhost.localdomain> (sfid-20180913_235851_744540_DF2F2882)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
 <20180913193004.GF4590@localhost.localdomain>
 <20180913212742.GC3876@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180913212742.GC3876@unicorn.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 13, 2018 at 11:27:42PM +0200, Michal Kubecek wrote:
> On Thu, Sep 13, 2018 at 04:30:04PM -0300, Marcelo Ricardo Leitner wrote:
> > On Thu, Sep 13, 2018 at 10:46:02AM +0200, Johannes Berg wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > In some situations some netlink attributes may be used for output
> > > only (kernel->userspace) or may be reserved for future use. It's
> > > then helpful to be able to prevent userspace from using them in
> > > messages sent to the kernel, since they'd otherwise be ignored and
> > > any future will become impossible if this happens.
> > 
> > I don't follow, what's the issue with simply ignoring such attributes?
> 
> A bit artificial example but I can't come with somethin better at the
> moment: let's say newer kernel and iproute2 allow something like
> 
>   ip link del <condition1> <condition2>
> 
> and you run new ip with older kernel which only supports <condition1>.
> You don't really want kernel to silently ignore the second condition.
> Or e.g. when adding a netfilter rule, you wouldn't want kernel to ignore
> parts of the rule it does not understand.

Oh, I thought these are different issues. How would NLA_REJECT protect
against this, by reserving <condition2> in advance?

This example looks more like a case for NLM_F_STRICT:
https://lwn.net/Articles/661266/
On which the user space would explicitly say "please reject this if
you don't get it all", but it was rejected back then.

> 
> I must admit I'm not sure if there is really need for having reserved
> attributes with netlink. Maybe e.g. when we want to share part of
> (numeric) attribute types between different message types. Anyway, we
> have the same problem with attributes higher than maximum; NLA_REJECT
> wouldn't help with this but the discussion also touched the topic.

Yes, agree.

> 
> > > Add NLA_REJECT to the policy which does nothing but reject (with
> > > EINVAL) validation of any messages containing this attribute.
> > > Allow for returning a specific extended ACK error message in the
> > > validation_data pointer.
> > 
> > This has potential to create confusion because we can't use it on
> > {output,reserved} attributes that are already there (as we must always
> > ignore them now) and we will end up with a mix of it.
> 
> We can return -EINVAL even now, we just need to add a check after
> nla_parse() wrapper returns, e.g. here: (lines 314-320)
> 
>   https://github.com/mkubecek/ethnl/blob/master/kernel/0019-ethtool-implement-SET_PARAMS-message.patch#L314

That's new code, it's okay. Won't break anyone's setup.

> 
> It would be easier and IMHO cleaner if I could simply list these "read
> only attributes" with NLA_REJECT policy for "set" request.

Not that I'm against this. Point was fields that are considered output
only today are probably being silently ignored, and we can't change
them to be NLA_REJECT as it would break user applications. Then we
will have fields that are rejected, and those old that are not. In the
long run, nearly all output fields would be marked as NLA_REJECT,
okay.

Then I ask my first question again: why reject these? They are not
hurting anything, are they?  It's different from your example I think.
In there, the extra information which was ignored leads to a
different behavior.

Maybe it would be better to have NLA_IGNORE instead? </idea>

  Marcelo
