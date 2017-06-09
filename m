Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38304 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbdFINqD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 09:46:03 -0400
Subject: Re: Question on setting key right after the EAPOL 4/4 is sent.
To: Johannes Berg <johannes@sipsolutions.net>,
        Denis Kenzior <denkenz@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
 <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com>
 <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com>
 <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com>
 <1496993334.2424.1.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <de7611e7-c34d-26e2-4083-b7e01b657426@candelatech.com> (sfid-20170609_154605_701973_BAF68F6F)
Date: Fri, 9 Jun 2017 06:46:01 -0700
MIME-Version: 1.0
In-Reply-To: <1496993334.2424.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/09/2017 12:28 AM, Johannes Berg wrote:
> On Thu, 2017-06-08 at 19:07 -0500, Denis Kenzior wrote:
>
>>>> Fundamentally there is a race between the genl/nl80211 socket to
>>>> the
>>>> kernel and the PAE socket that handles the authentication
>>>> aspects.  I
>>>> think the only way to
>>>> fix this is to make sure that PAE flows over the genl/nl80211
>>>> socket
>>>> to preserve the proper order of events.
>
> Correct.
>
>>>> However there are lots of
>>>> dragons in the kernel
>>>> side of this and we haven't been brave enough to venture into the
>>>> depths yet :)
>
> We've actually discussed doing precisely this, for - among other things
> - this reason. Just nobody stepped up yet to propose the necessary APIs
> and do the remaining work to use it etc.
>
>>> I think that would just push the problem lower.  Probably a real
>>> fix
>>> would be to somehow propagate
>>> the tx-status for the specific packet back to the supplicant and
>>> only
>>> then it would know that the
>>> key could be set.
>
> That's actually possible today, with the wifi-ack sockopt. It's not
> really a full solution though I think, there are other issues to solve.
> We also discussed this at the last workshop, IIRC.
>
>> Having userspace track individual packets in the kernel sounds  wrong
>> to  me.  This also won't help with the packets being received out-of-
>> order.  It would be nice if both the RX and TX ordering was
>> preserved.  Hence my thinking about running PAE over NL80211.  It
>> would then be up to the kernel / drivers to guarantee that the
>> various packets are ordered appropriately.
>
> That's actually not possible, since ordering set_key operations vs.
> transmitted packets isn't something that's easily done by drivers.
>
> However, the solution is far simpler! Once you have nl80211 PAE
> transport, you can easily even set the key before transmitting the
> packet and simply indicate that this particular packet should _not_ be
> encrypted regardless of key presence.

My ath10k firmware cannot deal with a case like this:

pkt is enqueued before key is set
key is set
pkt is transmitted (incorrectly)

This is because of how the tid's header-length variables are set up and modified
when the keys are set, and I don't see any good way to fix this.

Stock ath10k firmware goes to great lengths to parse EAPOL frames and try to work around
it in that manner, but that breaks .11r (or used to, I haven't tried stock firmware lately)
and adds more complexity to the code.

 From a patch someone sent to hostapd list last night, it seems we could get the tx-status for
the EAPOL 4/4, and in that case, we *know* the pkt has been transmitted, so we can then
set the key safely it would seem?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
