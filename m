Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53346 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbcJDQb1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 12:31:27 -0400
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
To: Johannes Berg <johannes@sipsolutions.net>,
        "Pedersen, Thomas" <twp@qca.qualcomm.com>
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
 <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>
 <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com>
 <1473662637.4201.2.camel@sipsolutions.net>
 <1473789454.27738.7.camel@qca.qualcomm.com>
 <1473789740.5622.3.camel@sipsolutions.net>
 <1474050629.31554.19.camel@qca.qualcomm.com>
 <1474275637.4469.15.camel@sipsolutions.net>
 <57E01026.9030604@candelatech.com>
 <1475573532.5324.47.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <7cc8610d-453d-1611-6c60-581ca7b68346@candelatech.com> (sfid-20161004_183131_376678_1D93ECED)
Date: Tue, 4 Oct 2016 09:31:26 -0700
MIME-Version: 1.0
In-Reply-To: <1475573532.5324.47.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2016 02:32 AM, Johannes Berg wrote:
> Sorry - needed some time to think through this thread again.
>
>> I think it is a moot point as far as this change goes:  Regardless of
>> whether the NIC should or not, it _does_.  So, mis-reporting it up
>> the stack only hides the issue and does not even give the user a clue
>> that on-the-air encoding may be slightly off-spec.
>
> Arguably, reporting something that *seems* sane, like this patch does,
> will do more to hide it than reporting 0 which is clearly bogus, no?
>
> I realize you were replying to whether or not the *driver* should
> "misreport" it, but the same argument applies the other way here, imho.

If the firmware/NIC is putting it on air at a particular encoding, then
I think the stack should report it exactly as it is on air if possible.

Returning zero is not much of a clue to the user.  Adding a WARN_ON_ONCE()
might be more useful, but no one can fix this by modifying the driver or stack, so the warning
will hit, confuse people, and then still never get fixed since it is a firmware
issue.

And, since someone added specific code to the firmware to use this rate
in certain cases, then maybe it is actually a good thing to do.

>> If the on-air encoding is an issue, then we need to hack the firmware
>> to disable this 'feature', but that is a completely separate issue.
>
> I guess it trusts rate control enough to try, and if it cannot be
> received by a spec-abiding receiver, it won't use it due to the
> failures ... not such a big deal I guess, even though it's odd.
>
> Does /anyone/ know why the spec disallowed it? Perhaps those "system"
> people you refer to?

I didn't talk to any system people, but maybe Thomas did.  I can confirm
that the firmware appears to do this on purpose and not just to be buggy
on accident though.

>> Once this patch goes in, someone might consider properly reporting
>> CCK rx rates for 5Ghz band too:  ath10k can do this 'feature' as
>> well, at least in some firmware.  Probably can reproduce by sending
>> off-channel mgt frames on 5Ghz when associated on 2.4, or something
>> similar to this.  I was using ath9k as sniffer when I found this long
>> ago, so at least ath9k needs the change....
>
> I don't see how this is related? It's not advertising those rates, so
> it probably also can't use/report them as far as mac80211 and the rest
> of the stack are concerned.

I can guarantee you that at least some ath10k firmware has a bug that will
send CCK encodings on 5Ghz.  This is a bug in the firmware, but the packets
will go on air, and they can be decoded by ath9k (and ath10k)
and passed up the stack.

Stock ath9k driver will ignore them (or maybe lie and say rate is 6Mbps, I cannot
recall at this point) currently because it thinks the rate is
bad (since it sort of is).  But, if you relax ath9k, then it can actually
sniff these frames and give you a clue as to what is really wrong.

It reminded me of hiding the rate by setting it to zero, since in both cases,
overly strict decisions based on what is *supposed* to happen caused me
to have to dig closely and modify code in order to understand what is
actually happening on-air.

Basically, if the NIC can decode a frame, and checksums pass and so forth,
then it seems it should pass it up the stack.  Possibly with WARN_ONCE to
give use a better clue that there is an issue.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
