Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:50439 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdINSh5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 14:37:57 -0400
Received: by mail-io0-f182.google.com with SMTP id w94so2798762ioi.7
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 11:37:57 -0700 (PDT)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1505378361.31630.2.camel@sipsolutions.net>
 <e4a3ab99-f49a-0849-56d7-71ce19b1f323@broadcom.com>
 <1505389462.31630.6.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <e418234f-00a0-dd44-7352-d279f49f83e5@gmail.com> (sfid-20170914_203801_472440_F3E5AD57)
Date: Thu, 14 Sep 2017 13:37:55 -0500
MIME-Version: 1.0
In-Reply-To: <1505389462.31630.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 09/14/2017 06:44 AM, Johannes Berg wrote:
> On Thu, 2017-09-14 at 13:21 +0200, Arend van Spriel wrote:
> 
>> Yep. Toggling the OPER_STATE seems to go against what roaming is
>> about.
> 
> Agree.

The question is whether all APs are actually sane after a roam.  E.g. 
can the STA assume that the same IP address, DHCP lease, etc is still 
valid?  I heard from various people that this might not be the case, but 
we haven't had a chance to verify those claims...

> 
>> Come to think of it, is it a good idea to tightly couple
>> PORT_AUTHORIZED to OPER_STATE. Aren't these separate concepts in
>> different layers of the network stack.
> 
> Well, I think that coupling would make the most sense, since once you
> have oper state UP you'll try to get IPv6 etc., no? And before being
> authorized there's no point.
> 

I think it does make sense to tie one into the other.  However, do we 
have a race condition here?  E.g. AUTHORIZED is sent on one socket, then 
OPER_STATE is signaled on rtnl.  Which one do applications rely on?

> Note that we *can't* do this right now, otherwise we can't transfer the
> EAPOL frames; but once we do that over nl80211 we'd be able to.
> 
>> In earlier discussions the proposal for a separate event was made by
>> Jithu (colleague). In brcmfmac it would become a bit less
>> complicated with a separate event so it has my vote as well. So the
>> AUTHORIZED event will have no attributes, right? So if the event
>> occurs it is AUTHORIZED.
> 
> I think so, yes. I pondered having the attribute in there so you could
> explicitly have a "not authorized" event, but do we really need that?
> If you get disconnected that's pretty much implied, so ... I don't
> think we need it.
> 
> 
>>> (*) is anyone working on that? I'll throw it on my list if not.
> 
> ["that" being EAPOL-over-nl80211]
> 
>> The last I saw on this was Denis Kenzior volunteering for it, but
>> that was about it.
> 
> Oh, thanks for the reminder, I'd forgotten entirely...
> Denis?

*wakes up*

Ah I now seem to remember that I volunteered to look into this before my 
sabbatical :)  I think this was in early June?  I'm certainly still 
interested in doing so.   Let me dust off that portion of my brain and 
come up with a proposal.  Unless you already have a clear idea of how 
things should work?

Regards,
-Denis
