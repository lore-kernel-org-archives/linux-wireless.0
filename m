Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59016 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932836AbdCaNd2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 09:33:28 -0400
Subject: Re: [PATCH v3 1/4] mac80211-hwsim: notify user-space about channel
 change.
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
 <1490776922.7948.9.camel@sipsolutions.net>
 <260bf7e1-5ff2-709a-419b-df54b80c87f0@candelatech.com>
 <1490806271.7948.22.camel@sipsolutions.net>
 <6ddd5a26-042b-0eaf-e8f2-11833ede300b@candelatech.com>
 <1490960938.6288.7.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <16c10539-3ab3-f5ec-38ab-0fc7abca1a94@candelatech.com> (sfid-20170331_153404_662029_99576C7A)
Date: Fri, 31 Mar 2017 06:33:26 -0700
MIME-Version: 1.0
In-Reply-To: <1490960938.6288.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/31/2017 04:48 AM, Johannes Berg wrote:
>
>> I really don't understand what change you are suggesting.  Anything
>> that uses a new API needs to change, and as API is further improved,
>> then the app will need to change again.  Netlink's saving grace is
>> that it is easy to add new data members and so support new API in a
>> forward/backward compatible manner.
>
> That's true, but it'd still mean you have to update all the time, and
> perhaps then we'll find out it'd be easier to break the API, etc.?

In my experience, the big problem with netlink is that if you write
a patch that cannot make it upstream (or takes forever), then the netlink
IDs conflict as upstream adds more stuff.

Other than that, it is easy to add new members, or completely new commands.

User-space can drop old API and simply not fully work against older kernels
if it wants, especially for something as specialized as a simulated
wifi radio.

 >
> OTOH, supporting (on both sides) channel contexts doesn't seem so hard
> - perhaps something like
>  * add chanctx
>  * remove chanctx
>  * change chanctx config
>
> as hwsim commands, and then we can pretend to add/remove in start/stop
> if we have non-chanctx-hwsim?

The project I did this work for is basically done and frozen.  I can tweak
some small API changes to sync up with new netlink ID numbers, but I have no
time to completely re-do the API (and more importantly, to test it all).

So, if my patch can go in as is or with small tweaks, then I'm happy to
keep working on it.  If it needs a complete re-write, then it will have to
wait for someone else or some later date.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
