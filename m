Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51514 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751631AbdINTRm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 15:17:42 -0400
Message-ID: <1505416658.31630.15.camel@sipsolutions.net> (sfid-20170914_211746_633567_68BB72D0)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 14 Sep 2017 21:17:38 +0200
In-Reply-To: <e418234f-00a0-dd44-7352-d279f49f83e5@gmail.com> (sfid-20170914_203757_701557_A7A3EC0F)
References: <1505378361.31630.2.camel@sipsolutions.net>
         <e4a3ab99-f49a-0849-56d7-71ce19b1f323@broadcom.com>
         <1505389462.31630.6.camel@sipsolutions.net>
         <e418234f-00a0-dd44-7352-d279f49f83e5@gmail.com>
         (sfid-20170914_203757_701557_A7A3EC0F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-14 at 13:37 -0500, Denis Kenzior wrote:

> The question is whether all APs are actually sane after a
> roam.  E.g. can the STA assume that the same IP address, DHCP lease,
> etc is still valid?  I heard from various people that this might not
> be the case, but we haven't had a chance to verify those claims...

I think you pretty much have to assume that, otherwise there's no point
in roaming at all - you want your connections to stay, possibly voice
calls to continue, etc.

> I think it does make sense to tie one into the other.  However, do
> we have a race condition here?  E.g. AUTHORIZED is sent on one
> socket, then OPER_STATE is signaled on rtnl.  Which one do
> applications rely on?

Regular applications wouldn't really look at nl80211.

> > Note that we *can't* do this right now, otherwise we can't transfer
> > the EAPOL frames; but once we do that over nl80211 we'd be able to.

However, I'm not really convinced (any more) that this is actually
correct. If I'm reading the supplicant code correctly, then it sets
IF_OPER_UP only once the connection is *completed*, so it's already
doing what I thought it should be doing and couldn't.

> *wakes up*
> 
> Ah I now seem to remember that I volunteered to look into this before
> my sabbatical :)  I think this was in early June?  I'm certainly
> still interested in doing so.   Let me dust off that portion of my
> brain and come up with a proposal.  Unless you already have a clear
> idea of how things should work?

Not really. I guess a new command/event with the frame, and some flags,
I know that at least we want a "don't encrypt" flag, for example.

johannes
