Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35690 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965841AbdKQQqd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2017 11:46:33 -0500
Subject: Re: What would it take to get WDS working with channel contexts?
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <24f85baf-5e19-a2c9-517d-9b69a47860d9@candelatech.com>
 <1510911915.2030.37.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <6c0f3696-b4bb-d653-3661-35250fae2894@candelatech.com> (sfid-20171117_174739_015809_ACB2ABF4)
Date: Fri, 17 Nov 2017 08:46:27 -0800
MIME-Version: 1.0
In-Reply-To: <1510911915.2030.37.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/17/2017 01:45 AM, Johannes Berg wrote:
> On Thu, 2017-11-16 at 16:28 -0800, Ben Greear wrote:
>> I have a user interested in getting WDS working on ath10k, but evidently
>> this is not supported since ath10k uses channel-contexts:
>>
>>  From net/mac80211/main.c:
>>
>> 		/*
>> 		 * WDS is currently prohibited when channel contexts are used
>> 		 * because there's no clear definition of which channel WDS
>> 		 * type interfaces use
>> 		 */
>>
>>
>> Anyone have any suggestions as to how this could be made to work?
>
> You probably don't want to hear this, but:
>
> WDS isn't even properly working without them right now, since for
> example there's absolutely no feature negotiation between the peers as
> to which rates and other capabilities, bandwidths, etc. are acceptable
> (at any given moment in time).
>
> I therefore don't see any value in WDS mode at all unless these issues
> are fixed [*], and as such wouldn't want to take any patches that just
> do some minimal patching over to allow it with channel contexts.
>
> If you ask me, WDS is entirely useless without vendor-specific
> extensions to allow newer features, and the Linux "vendor-specific"
> extension to do that is AP/client 4-addr mode.
>
> johannes
>
> [*] and since the spec doesn't define this, you can't even fix them in
> any reasonable way, I think, unless you implement some vendor-specific
> things that maybe one vendor happens to do.

It looks like my options are to hack the mac80211 stack to be minimally
functional with WDS and channel-contexts, or to hack ath10k driver to
disable chan-tx in order to try to fix the ath10k firmware WDS issues.

I'd guess the former is of slightly more use to society.  Do you have
any quick hacks to allow mac80211 to work with chantx and WDS, even
if you wouldn't want them upstream?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
