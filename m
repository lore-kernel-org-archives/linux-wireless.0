Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41130 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753129AbcJDJcS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 05:32:18 -0400
Message-ID: <1475573532.5324.47.camel@sipsolutions.net> (sfid-20161004_113232_772115_FF2CE766)
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "Pedersen, Thomas" <twp@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 04 Oct 2016 11:32:12 +0200
In-Reply-To: <57E01026.9030604@candelatech.com>
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
                 <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>
                 <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com>
                 <1473662637.4201.2.camel@sipsolutions.net>
                 <1473789454.27738.7.camel@qca.qualcomm.com>
                 <1473789740.5622.3.camel@sipsolutions.net>
                 <1474050629.31554.19.camel@qca.qualcomm.com>
                 (sfid-20160916_203211_452910_08E25A89) <1474275637.4469.15.camel@sipsolutions.net>
         <57E01026.9030604@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry - needed some time to think through this thread again.

> I think it is a moot point as far as this change goes:  Regardless of
> whether the NIC should or not, it _does_.  So, mis-reporting it up
> the stack only hides the issue and does not even give the user a clue
> that on-the-air encoding may be slightly off-spec.

Arguably, reporting something that *seems* sane, like this patch does,
will do more to hide it than reporting 0 which is clearly bogus, no?

I realize you were replying to whether or not the *driver* should
"misreport" it, but the same argument applies the other way here, imho.

> If the on-air encoding is an issue, then we need to hack the firmware
> to disable this 'feature', but that is a completely separate issue.

I guess it trusts rate control enough to try, and if it cannot be
received by a spec-abiding receiver, it won't use it due to the
failures ... not such a big deal I guess, even though it's odd.

Does /anyone/ know why the spec disallowed it? Perhaps those "system"
people you refer to?

> Once this patch goes in, someone might consider properly reporting
> CCK rx rates for 5Ghz band too:  ath10k can do this 'feature' as
> well, at least in some firmware.  Probably can reproduce by sending
> off-channel mgt frames on 5Ghz when associated on 2.4, or something
> similar to this.  I was using ath9k as sniffer when I found this long
> ago, so at least ath9k needs the change....

I don't see how this is related? It's not advertising those rates, so
it probably also can't use/report them as far as mac80211 and the rest
of the stack are concerned.

johannes
