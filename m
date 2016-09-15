Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44074 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbcIOSIc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:08:32 -0400
Subject: Re: [PATCH v2 09/21] ath10k: print fw debug messages in hex.
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
 <1462986153-16318-10-git-send-email-greearb@candelatech.com>
 <87oa3qefac.fsf@kamboji.qca.qualcomm.com> <57D96910.2010608@candelatech.com>
 <87k2edb6kp.fsf@kamboji.qca.qualcomm.com>
 <a26dfea0-9a18-69fc-e23c-cb223490822d@candelatech.com>
 <1473960869.31073.15.camel@intel.com>
 <50a08de4-1959-3dc9-cfc7-89d5b2914cc5@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <6dab62e6-4d5d-207c-b012-960f16e39b95@candelatech.com> (sfid-20160915_200840_000357_435A0F56)
Date: Thu, 15 Sep 2016 11:08:31 -0700
MIME-Version: 1.0
In-Reply-To: <50a08de4-1959-3dc9-cfc7-89d5b2914cc5@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2016 10:59 AM, Ben Greear wrote:
> On 09/15/2016 10:34 AM, Grumbach, Emmanuel wrote:

> I have other patches that remember the last 100 or so firmware log messages from
> the kernel and provide that in a binary dump image when firmware crashes.
>
> This is indeed very useful.
>
> But, when debugging non-crash occasions, it is still useful to see what
> the firmware is doing.
>
> For instance, maybe it is reporting lots of tx-hangs and/or low-level
> resets.  This gives you a clue as to why a user might report 'my wifi sucks'.
>
> Since I am both FW and driver team for my firmware variant,
> and my approach has been working for me, then I feel it is certainly better than
> the current state.  And just maybe the official upstream FW team could start
> using something similar as well.  Currently, I don't see how they can ever make
> much progress on firmware crashes reported in stock kernels.

I forgot the other good reason about console logging this:

Sometimes ath10k firmware crash causes the entire kernel to crash, so there is no time to
grab the binary dump from a file system...but a serial console can help you
make progress...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
