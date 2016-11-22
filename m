Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53700 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932589AbcKVK5A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 05:57:00 -0500
Message-ID: <1479812215.9021.3.camel@sipsolutions.net> (sfid-20161122_115724_886684_D1FB51A9)
Subject: Re: Break-it testing for wifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 22 Nov 2016 11:56:55 +0100
In-Reply-To: <a60dac22-655e-ea93-61c2-73db05a47572@candelatech.com> (sfid-20161121_171042_142074_00CD9837)
References: <a60dac22-655e-ea93-61c2-73db05a47572@candelatech.com>
         (sfid-20161121_171042_142074_00CD9837)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-11-21 at 08:10 -0800, Ben Greear wrote:

> I am thinking about adding some sort of framework to wpa_supplicant
> and/or the mac80211 stack to allow purposefully creating bad station
> behaviour in order to test robustness of APs.

I'm interested in this.

Have you seen the fuzzer stuff in wpa_s/hostapd?

See

https://w1.fi/cgit/hostap/commit/?id=7d3f18d72c3c883112ee927fc402c0eaed09ff65

for example for something Jouni did after our discussions recently.

> Some ideas so far:
> 
> 1)  Allow supplicant to do bad state-machine transitions (start 4-way 
> before associating, for instance).

Why would you do that? In order to test the AP implementation?

> 2)  Randomly corrupt mgt frames in driver and/or mac80211 stack
> and/or supplicant.

I think fuzzing the input path for those frames would be more useful
than just corrupting things.

> 3)  Possibly allow user to make specific corruptions.  This would
> probably be in supplicant
>      only, and I am not sure how this would be configured.  Maybe
> allow user to over-ride
>      existing IEs and add bogus ones of their own choosing.

No idea what you really mean by this :)

> 4)  Maybe some specific tests like putting in over-flow sized lengths
> of IEs.

Again, fuzzing would cover this?

> Has anyone done anything similar they would like to share?
> 
> Johannes:  Any interest in having such a framework in upstream
> kernels?

I suspect you have something entirely different in mind, like testing a
(remote) AP implementation?

All of the local testing is probably better done via hwsim?

johannes
